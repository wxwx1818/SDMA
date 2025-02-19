// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   ahb_rram_master.v
// AUTHOR   :   Hengxin Wang 
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2025.1.15   Hengxin Wang    First release
// 1.1      2025.1.22   Hengxin Wang    merge to 2depth fifo master, delete parameter SCLK_OR_NOT and re-construct
// -----------------------------------------------------------------------------
// KEYWORDS : AHB, Master
// -----------------------------------------------------------------------------
// PURPOSE : AHB master interface
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME           RANGE           			DESCRIPTION                     DEFAULT     UNITS
// AHB_DATA_WIDTH       n*8       					AHB side data width             32          bit
// AHB_ADDR_WIDTH       32, 16, 8       			AHB side address width          32          bit
// RRAM_DATA_WIDTH      n*8 && <= AHB_DATA_WIDTH    RRAM side data width            32          bit
// RRAM_ADDR_WIDTH      n*8 && <= AHB_ADDR_WIDTH    RRAM side address width         32          bit
// RRAM_BMASK_WIDTH     1 || RRAM_DATA_WIDTH/8    	RRAM side byte enable width     4          	bit
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   ahb_hclk, rram_clk
//  Critical Timing     :   
//  Test Features       :   
//  Asynchronous I/F    :   
//  Instantiations      :   
//  Synthesizable (y/n) :   Y
//  Other Considerations:   none
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps

module ahb_rram_master #(
// +PARAMETER DECLARATION--------------------------------------------------------
	parameter	AHB_DATA_WIDTH			= 32    ,				// AHB data bitwidth
	parameter	AHB_ADDR_WIDTH			= 32    ,				// AHB address width
	parameter	RRAM_DATA_WIDTH			= 32    ,				// RRAM data bitwidth
	parameter	RRAM_ADDR_WIDTH			= 32    ,				// RRAM address width
	parameter   RRAM_BMASK_WIDTH        = 4     
// -PARAMETER DECLARATION--------------------------------------------------------
)
(
	// +INPUT PORT DECLARATION-------------------------------------------------------
	// AHB INPUTS
	input              					    i_ahb_hclk        ,  	// Clock input
	input              					    i_ahb_hrst_n      ,	// Reset asynchronous (active low)
	input              					    i_ahb_mhgrant     ,	// Master grant signal (active high, this version: 1'b1)
	input       [AHB_DATA_WIDTH-1:0]		i_ahb_mhrdata     ,	// Master read data bus
	input              					    i_ahb_mhready     ,	// Master response ready signal (active high)
	input       [1:0] 					    i_ahb_mhresp      ,	// Master response error signal (1:error, 0:OKAY) ({mhready,mhresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
	// RRAM INPUTS
	input								    i_rram_clk        ,	// RRAM Input clock (low-speed clock)
	input								    i_rram_rst_n      ,	// RRAM input reset (active low)
	input		[RRAM_BMASK_WIDTH-1:0]		i_rram_mena       ,	// RRAM Input write/read enable (i.e. SRAM timing)
	input								    i_rram_mwea       ,	// RRAM Input write/read mode (i.e. SRAM timing)
	input		[RRAM_ADDR_WIDTH-1:0]		i_rram_maddr      ,	// RRAM Input address (i.e. SRAM timing)
	input		[RRAM_DATA_WIDTH-1:0]		i_rram_mwdata     ,	// RRAM Input write data (i.e. SRAM timing)
	// -INPUT PORT DECLARATION-------------------------------------------------------

	// +OUTPUT PORT DECLARATION------------------------------------------------------	
	// AHB OUTPUTS
	output		[AHB_ADDR_WIDTH-1:0]		o_ahb_mhaddr      ,	// Master address bus
	output		[2:0] 					    o_ahb_mhburst     ,	// Master burst type signals (just be 3'b000 in wujian100, single transfer)
	output		[3:0] 					    o_ahb_mhprot      ,	// Master protection control signal (this version: keeping 4'b0011)
	output		[2:0] 					    o_ahb_mhsize      ,	// Master transfer size signal (this version: only 8b/16b/32b?DMA?E902?)
	output		[1:0] 					    o_ahb_mhtrans     ,	// Master transfer type signal
	output 		[AHB_DATA_WIDTH-1:0]		o_ahb_mhwdata     ,	// Master write data bus
	output 	        					    o_ahb_mhwrite     ,	// Master write enable signal
	// RRAM OUTPUTS
	output								    o_rram_mready     ,	// RRAM Input write/read ready (delay 1 cycle after rram_mena, 1'b0: master can't process the next data)
	output								    o_rram_merror     ,	// RRAM Input write/read error (delay n cycle after rram_mena, sync with rram_ready, 1'b1:error, 1'b0:normal)
	output		[RRAM_DATA_WIDTH-1:0]		o_rram_mrdata     ,	// RRAM Output read data (delay n cycle after rram_mena, sync with rram_ready)
	output		[RRAM_BMASK_WIDTH-1:0]	    o_rram_mrdata_vld	// RRAM Output read data valid (delay n cycle after rram_mena, sync with rram_ready)
	// -OUTPUT PORT DECLARATION------------------------------------------------------
);


/*Parameters and Variables*/
// +INTERNAL Localparam DECLARATION----------------------------------------------
    localparam FIFO_TX_DATA_WIDTH = RRAM_DATA_WIDTH + RRAM_ADDR_WIDTH + 1 + 3;	// {wdata, addr, wea, hsize}
    localparam FIFO_RX_DATA_WIDTH = AHB_DATA_WIDTH + 1 + 3;					// {rdata, error, hsize}


    localparam STATE_IDLE           = 2'b00;    // AHB FSM idle state
    localparam STATE_READ           = 2'b01;    // AHB FSM read state
    localparam STATE_WRITE          = 2'b10;    // AHB FSM write state

    localparam AHB_HTRANS_IDLE      = 2'b00;    // o_ahb_mhtrans IDLE state define
    localparam AHB_HTRANS_BUSY      = 2'b01;    // o_ahb_mhtrans BUSY state define
    localparam AHB_HTRANS_NONSEQ    = 2'b10;    // o_ahb_mhtrans NONSEQ state define
    localparam AHB_HTRANS_SEQ       = 2'b11;    // o_ahb_mhtrans SEQ state define

    localparam AHB_HBRUST_SINGLE    = 3'b000;
    localparam AHB_HBRUST_INCR      = 3'b001;
    localparam AHB_HBRUST_WRAP4     = 3'b010;
    localparam AHB_HBRUST_INCR4     = 3'b011;
    localparam AHB_HBRUST_WRAP8     = 3'b100;
    localparam AHB_HBRUST_INCR8     = 3'b101;
    localparam AHB_HBRUST_WRAP16    = 3'b110;
    localparam AHB_HBRUST_INCR16    = 3'b111;

    localparam AHB_HWRITE_READ      = 1'b0;
    localparam AHB_HWRITE_WRITE     = 1'b0;

    localparam AHB_HSIZE_8_BIT      = 3'b000;
    localparam AHB_HSIZE_16_BIT     = 3'b001;
    localparam AHB_HSIZE_32_BIT     = 3'b010;
    localparam AHB_HSIZE_64_BIT     = 3'b011;
    localparam AHB_HSIZE_128_BIT    = 3'b100;
    localparam AHB_HSIZE_256_BIT    = 3'b101;
    localparam AHB_HSIZE_512_BIT    = 3'b110;
    localparam AHB_HSIZE_1024_BIT   = 3'b111;

    localparam AHB_HREADY_OK        = 1'b1;
    localparam AHB_HREADY_DELAY     = 1'b0;

    localparam AHB_HRESP_OKAY       = 2'b00;
    localparam AHB_HRESP_ERROR      = 2'b01;
    localparam AHB_HRESP_RETRY      = 2'b10;
    localparam AHB_HRESP_SPLIT      = 2'b11;
// -INTERNAL Localparam DECLARATION----------------------------------------------
    
// +INTERNAL Special Variables DECLARATION----------------------------------------------
    reg  	[1:0]              		current_state;      // AHB FSM current state reg
    reg  	[1:0]              		next_state;         // AHB FSM next state wire
// +INTERNAL Special Variables DECLARATION----------------------------------------------

// +INTERNAL Register DECLARATION-----------------------------------------------------
    reg  	[AHB_DATA_WIDTH-1:0]	ahb_mhwdata_dly_buf;
	reg	 	[2:0]					ahb_mhsize_dly_buf;

// -INTERNAL Register DECLARATION-----------------------------------------------------
    
// +INTERNAL Wire DECLARATION----------------------------------------------------
	wire	[2:0]						fifo_tx_wr_data_mhsize;
    wire    [2:0]                      	fifo_tx_rd_data_mhsize;
    wire                            	fifo_tx_rd_data_mwea;
    wire    [RRAM_ADDR_WIDTH-1:0]   	fifo_tx_rd_data_maddr;
    wire    [RRAM_DATA_WIDTH-1:0]   	fifo_tx_rd_data_mwdata;
    wire    [FIFO_TX_DATA_WIDTH-1:0] 	fifo_tx_rd_data;
    wire                            	fifo_tx_rd_data_vld;
    wire                            	fifo_tx_empty;
	wire								fifo_tx_full;

    wire    [2:0]                      	fifo_rx_rd_data_hsize;
    wire                            	fifo_rx_rd_data_error;
    wire    [RRAM_DATA_WIDTH-1:0]   	fifo_rx_rd_data_rdata;
    wire                            	fifo_rx_wr_en;
    wire    [FIFO_RX_DATA_WIDTH-1:0] 	fifo_rx_rd_data;
    wire                            	fifo_rx_rd_data_vld;
    wire                            	fifo_rx_empty;
	//wx 2025.1.29
	wire	[RRAM_BMASK_WIDTH-1:0]		rvld_temp;

// -INTERNAL Wire DECLARATION----------------------------------------------------

/*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
// +INTERNAL Assign DECLARATION--------------------------------------------------
    // fifo_tx_wr_data_mhsize logic
    generate
        if(RRAM_BMASK_WIDTH == 1) begin
            if (RRAM_DATA_WIDTH == 8) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_8_BIT;
            end else if(RRAM_DATA_WIDTH == 16) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_16_BIT;
            end else if(RRAM_DATA_WIDTH == 32) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_32_BIT;
            end else if(RRAM_DATA_WIDTH == 64) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_64_BIT;
            end else if(RRAM_DATA_WIDTH == 128) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_128_BIT;
            end else if(RRAM_DATA_WIDTH == 256) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_256_BIT;
            end else if(RRAM_DATA_WIDTH == 512) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_512_BIT;
            end else if(RRAM_DATA_WIDTH == 1024) begin
                assign fifo_tx_wr_data_mhsize = AHB_HSIZE_1024_BIT;
            end
        end else if(RRAM_BMASK_WIDTH == 2) begin
            assign fifo_tx_wr_data_mhsize = i_rram_mena == 2'b01 ? AHB_HSIZE_8_BIT : AHB_HSIZE_16_BIT;
        end else if(RRAM_BMASK_WIDTH == 4) begin
            assign fifo_tx_wr_data_mhsize = i_rram_mena == 4'b0001 ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == 4'b0011 ? AHB_HSIZE_16_BIT : AHB_HSIZE_32_BIT);
        end else if(RRAM_BMASK_WIDTH == 8) begin
            assign fifo_tx_wr_data_mhsize = i_rram_mena == 8'b00000001 ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == 8'b00000011 ? AHB_HSIZE_16_BIT : 
                                			(i_rram_mena == 8'b00001111 ? AHB_HSIZE_32_BIT : AHB_HSIZE_64_BIT));
        end else if(RRAM_BMASK_WIDTH == 16) begin
            assign fifo_tx_wr_data_mhsize =  i_rram_mena == {{(16-1){1'b0}}, {1{1'b1}}} ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == {{(16-2){1'b0}}, {2{1'b1}}} ? AHB_HSIZE_16_BIT : 
                                			(i_rram_mena == {{(16-4){1'b0}}, {4{1'b1}}} ? AHB_HSIZE_32_BIT : 
                                			(i_rram_mena == {{(16-8){1'b0}}, {8{1'b1}}} ? AHB_HSIZE_64_BIT : AHB_HSIZE_128_BIT)));
        end else if(RRAM_BMASK_WIDTH == 32) begin
            assign fifo_tx_wr_data_mhsize =  i_rram_mena == {{(32-1){1'b0}} , {1{1'b1}}} ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == {{(32-2){1'b0}} , {2{1'b1}}} ? AHB_HSIZE_16_BIT : 
                                			(i_rram_mena == {{(32-4){1'b0}} , {4{1'b1}}} ? AHB_HSIZE_32_BIT : 
                                			(i_rram_mena == {{(32-8){1'b0}} , {8{1'b1}}} ? AHB_HSIZE_64_BIT : 
                                			(i_rram_mena == {{(32-16){1'b0}}, {16{1'b1}}} ? AHB_HSIZE_128_BIT : AHB_HSIZE_256_BIT))));
        end else if(RRAM_BMASK_WIDTH == 64) begin
            assign fifo_tx_wr_data_mhsize =  i_rram_mena == {{(64-1){1'b0}} , {1{1'b1}}} ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == {{(64-2){1'b0}} , {2{1'b1}}} ? AHB_HSIZE_16_BIT : 
                                			(i_rram_mena == {{(64-4){1'b0}} , {4{1'b1}}} ? AHB_HSIZE_32_BIT : 
                                			(i_rram_mena == {{(64-8){1'b0}} , {8{1'b1}}} ? AHB_HSIZE_64_BIT : 
                                			(i_rram_mena == {{(64-16){1'b0}}, {16{1'b1}}} ? AHB_HSIZE_128_BIT : 
                                			(i_rram_mena == {{(64-32){1'b0}}, {32{1'b1}}} ? AHB_HSIZE_256_BIT : AHB_HSIZE_512_BIT)))));
        end else if(RRAM_BMASK_WIDTH == 128) begin
            assign fifo_tx_wr_data_mhsize =  i_rram_mena == {{(128-1){1'b0}} , {1{1'b1}}} ? AHB_HSIZE_8_BIT :
                                			(i_rram_mena == {{(128-2){1'b0}} , {2{1'b1}}} ? AHB_HSIZE_16_BIT : 
                                			(i_rram_mena == {{(128-4){1'b0}} , {4{1'b1}}} ? AHB_HSIZE_32_BIT : 
                                			(i_rram_mena == {{(128-8){1'b0}} , {8{1'b1}}} ? AHB_HSIZE_64_BIT : 
                                			(i_rram_mena == {{(128-16){1'b0}}, {16{1'b1}}} ? AHB_HSIZE_128_BIT : 
                                			(i_rram_mena == {{(128-32){1'b0}}, {32{1'b1}}} ? AHB_HSIZE_256_BIT : 
                                			(i_rram_mena == {{(128-64){1'b0}}, {64{1'b1}}} ? AHB_HSIZE_512_BIT : AHB_HSIZE_1024_BIT))))));
        end
    endgenerate


    assign o_ahb_mhaddr   	= fifo_tx_rd_data_maddr;
    assign o_ahb_mhburst  	= AHB_HBRUST_SINGLE;
    assign o_ahb_mhprot   	= 4'b0011;
	assign o_ahb_mhsize		= fifo_tx_rd_data_mhsize;
    assign o_ahb_mhtrans  	= fifo_tx_rd_data_vld ? AHB_HTRANS_NONSEQ : AHB_HTRANS_IDLE;
    //assign o_ahb_mhwdata  	= ahb_mhwdata_dly_buf;
    assign o_ahb_mhwdata 	= fifo_tx_rd_data_mwdata;
	assign o_ahb_mhwrite  	= fifo_tx_rd_data_mwea;

    assign o_rram_mready	= ~fifo_tx_full;
    assign o_rram_merror	= fifo_rx_rd_data_vld ? fifo_rx_rd_data_error : 1'b0;
    assign o_rram_mrdata	= fifo_rx_rd_data_rdata;
	//wx 2025.1.29
	assign o_rram_mrdata_vld = (fifo_tx_rd_data_mwea)?4'd0:rvld_temp;
	// o_rram_mrdata_vld logic modified by wx 2025.1.29
    generate
        if(RRAM_BMASK_WIDTH == 1) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld						? 1'b0 							: 1'b1;
        end else if(RRAM_BMASK_WIDTH == 2) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {2{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(2-1){1'b0}},	{1{1'b1}}}  : {2{1'b1}});
        end else if(RRAM_BMASK_WIDTH == 4) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {4{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(4-1){1'b0}},	{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(4-2){1'b0}},	{2{1'b1}}}  : {4{1'b1}}));
        end else if(RRAM_BMASK_WIDTH == 8) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {8{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(8-1){1'b0}},	{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(8-2){1'b0}},	{2{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_32_BIT 	? {{(8-4){1'b0}},	{4{1'b1}}}  : {8{1'b1}})));
        end else if(RRAM_BMASK_WIDTH == 16) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {16{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(16-1){1'b0}},	{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(16-2){1'b0}},	{2{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_32_BIT 	? {{(16-4){1'b0}},	{4{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_64_BIT 	? {{(16-8){1'b0}},	{8{1'b1}}}  : {16{1'b1}}))));
        end else if(RRAM_BMASK_WIDTH == 32) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {32{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(32-1){1'b0}},	{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(32-2){1'b0}},	{2{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_32_BIT 	? {{(32-4){1'b0}},	{4{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_64_BIT 	? {{(32-8){1'b0}},	{8{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_128_BIT ? {{(32-16){1'b0}}, {16{1'b1}}} : {32{1'b1}})))));
        end else if(RRAM_BMASK_WIDTH == 64) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {64{1'b0}} 					: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(64-1){1'b0}},	{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(64-2){1'b0}},	{2{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_32_BIT 	? {{(64-4){1'b0}},	{4{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_64_BIT 	? {{(64-8){1'b0}},	{8{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_128_BIT ? {{(64-16){1'b0}}, {16{1'b1}}} : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_256_BIT ? {{(64-32){1'b0}}, {32{1'b1}}} : {64{1'b1}}))))));
        end else if(RRAM_BMASK_WIDTH == 128) begin
            assign rvld_temp 	= ~fifo_rx_rd_data_vld 						? {128{1'b0}} 						: 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_8_BIT 	? {{(128-1){1'b0}},		{1{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_16_BIT 	? {{(128-2){1'b0}},		{2{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_32_BIT 	? {{(128-4){1'b0}},		{4{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_64_BIT 	? {{(128-8){1'b0}},		{8{1'b1}}}  : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_128_BIT ? {{(128-16){1'b0}},	{16{1'b1}}} : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_256_BIT ? {{(128-32){1'b0}},	{32{1'b1}}} : 
										(fifo_rx_rd_data_hsize == AHB_HSIZE_512_BIT ? {{(128-64){1'b0}},	{64{1'b1}}} : {128{1'b1}})))))));
        end
    endgenerate

    assign fifo_tx_rd_data_mhsize  	= fifo_tx_rd_data[0						+:	3				];
    assign fifo_tx_rd_data_mwea  	= fifo_tx_rd_data[3						+:	1				];
    assign fifo_tx_rd_data_maddr 	= fifo_tx_rd_data[3+1					+:	RRAM_ADDR_WIDTH	];
    assign fifo_tx_rd_data_mwdata	= fifo_tx_rd_data[3+1+RRAM_ADDR_WIDTH	+: 	RRAM_DATA_WIDTH	];

	assign fifo_rx_rd_data_hsize	= fifo_rx_rd_data[0 					+: 3				];
	assign fifo_rx_rd_data_error	= fifo_rx_rd_data[3 					+: 1				];
	assign fifo_rx_rd_data_rdata	= fifo_rx_rd_data[4 					+: AHB_DATA_WIDTH	];

// -INTERNAL Assign DECLARATION--------------------------------------------------

/*State Machine----------------------------------------------------------------------------------------------------*/
    // Current State
    always @(posedge i_ahb_hclk or negedge i_ahb_hrst_n) begin
        if(~i_ahb_hrst_n) begin
            current_state <= STATE_IDLE;
        end else if(i_ahb_mhready == AHB_HREADY_OK) begin
            current_state <= next_state;
        end
    end
    
    // Next State
    always @(*) begin
        case(current_state)
            STATE_IDLE: begin
                if(fifo_tx_rd_data_vld) begin
                    next_state = fifo_tx_rd_data_mwea ? STATE_WRITE : STATE_READ;
                end else begin
                    next_state = STATE_IDLE;
                end
            end
            STATE_READ: begin
                if(fifo_tx_rd_data_vld) begin
                    next_state = fifo_tx_rd_data_mwea ? STATE_WRITE : STATE_READ;
                end else begin
                    next_state = STATE_IDLE;
                end
            end
            STATE_WRITE: begin
                if(fifo_tx_rd_data_vld) begin
                    next_state = fifo_tx_rd_data_mwea ? STATE_WRITE : STATE_READ;
                end else begin
                    next_state = STATE_IDLE;
                end
            end
            default: begin
                next_state = STATE_IDLE;
            end
        endcase
    end
    
/*AHB Signal logic----------------------------------------------------------------------------------------------------*/

    // ahb_mhsize_dly_buf ahb_mhwdata_dly_buf logic
    always @(posedge i_ahb_hclk or negedge i_ahb_hrst_n) begin
        if(~i_ahb_hrst_n) begin
            ahb_mhsize_dly_buf 		<= {3{1'b0}};
            ahb_mhwdata_dly_buf <= {AHB_DATA_WIDTH{1'b0}};
        end else begin
            if(i_ahb_mhready == AHB_HREADY_OK) begin
                ahb_mhsize_dly_buf 	<= o_ahb_mhsize;
                ahb_mhwdata_dly_buf <= fifo_tx_rd_data_mwdata;
            end
        end
    end

    // sync_fifo_tx inst
	sync_fifo #( // First Word Fall Through Mode!!!
		// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH            (	FIFO_TX_DATA_WIDTH	),
		.FIFO_DEPTH            (	2					),
		.ALMOST_EMPTY_ENABLE   (	0					),
		.ALMOST_FULL_ENABLE    (	0					),
		.UNDERFLOW_ENABLE      (	0					),
		.OVERFLOW_ENABLE       (	0					),
		.ALMOST_FULL_NUM       (						),
		.ALMOST_EMPTY_NUM      (						)
		// -PARAMETER DECLARATION--------------------------------------------------------
	) sync_fifo_tx (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		.i_wr_clk			(	i_rram_clk												),
		.i_wr_rst_n			(	i_rram_rst_n											),
		.i_wr_en			(	|i_rram_mena											),
		.i_wr_data		    (	{i_rram_mwdata, i_rram_maddr, i_rram_mwea, fifo_tx_wr_data_mhsize}	),
		
		.i_rd_clk			(	i_ahb_hclk															),
		.i_rd_rst_n			(	i_ahb_hrst_n														),
		.i_rd_en			(	i_ahb_mhgrant && i_ahb_mhready == AHB_HREADY_OK && ~fifo_tx_empty	),
		// -INPUT PORT DECLARATION-------------------------------------------------------
		
		// +OUTPUT PORT DECLARATION------------------------------------------------------
		.o_rd_data			(	fifo_tx_rd_data		),
		.o_rd_data_vld		(	fifo_tx_rd_data_vld	),
		.o_fifo_full		(	fifo_tx_full		),
		.o_fifo_empty		(	fifo_tx_empty		),
		.o_fifo_almost_full	(						),
		.o_fifo_almost_empty(						),
		.o_overflow			(						),
		.o_underflow		(						)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);
    
    // sync_buf_rx inst
	sync_fifo #( // First Word Fall Through Mode!!!
		// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH            (	FIFO_RX_DATA_WIDTH	),
		.FIFO_DEPTH            (	2					),
		.ALMOST_EMPTY_ENABLE   (	0					),
		.ALMOST_FULL_ENABLE    (	0					),
		.UNDERFLOW_ENABLE      (	0					),
		.OVERFLOW_ENABLE       (	0					),
		.ALMOST_FULL_NUM       (						),
		.ALMOST_EMPTY_NUM      (						)
		// -PARAMETER DECLARATION--------------------------------------------------------
	) sync_fifo_rx (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		.i_wr_clk			(	i_ahb_hclk																						),
		.i_wr_rst_n			(	i_ahb_hrst_n																					),
		.i_wr_en			(	(current_state == STATE_READ) && i_ahb_mhready == AHB_HREADY_OK	),
		.i_wr_data		    (	{i_ahb_mhrdata, i_ahb_mhresp == AHB_HRESP_ERROR, ahb_mhsize_dly_buf}							),
		
		.i_rd_clk			(	i_rram_clk			),
		.i_rd_rst_n			(	i_rram_rst_n		),
		.i_rd_en			(	~fifo_rx_empty		),
		// -INPUT PORT DECLARATION-------------------------------------------------------
		
		// +OUTPUT PORT DECLARATION------------------------------------------------------
		.o_rd_data			(	fifo_rx_rd_data		),
		.o_rd_data_vld		(	fifo_rx_rd_data_vld	),
		.o_fifo_full		(						),
		.o_fifo_empty		(	fifo_rx_empty		),
		.o_fifo_almost_full	(						),
		.o_fifo_almost_empty(						),
		.o_overflow			(						),
		.o_underflow		(						)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);

endmodule
