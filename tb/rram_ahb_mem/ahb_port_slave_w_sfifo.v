// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   ahb_port_slave_w_sfifo.v
// AUTHOR   :   Hengxin Wang
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2024.1.31   Hengxin Wang    First release
// 1.1      2025.1.22   Hengxin Wang    add hsize function
// -----------------------------------------------------------------------------
// KEYWORDS : AHB-Lite, Slave, Synchronous FIFO
// -----------------------------------------------------------------------------
// PURPOSE : Connect a submodule to AHB-Lite bus as a slave between different synchronous clock regions;
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE               DESCRIPTION             DEFAULT     UNITS
// DATA_WIDTH       [32,1]              width of the data       32          bit
// ADDR_WIDTH       [32,1]              width of the addr       32          bit
// PORT_BMASK_WIDTH                     width of the bytemask   4           bit
// AHB_ADDR_OFFSET  [0xffffffff,0x0]    addr offset in ahb      0x0         
// FIFO_DEPTH       [INF,2]             depth of the FIFO       2        
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   ahb_hclk, port_clk
//  Critical Timing     :   N/A
//  Test Features       :   None
//  Asynchronous I/F    :   Y
//  Instantiations      :   sync_fifo
//  Synthesizable (y/n) :   Y
//  Other Considerations:   None
// -FHDR------------------------------------------------------------------------


// <top level name> is the name of the top level module
// <sub level name> is the name of a module under the top level module name
// <signal name> is a meaningful signal name
// <signal_suffix> is specified for some critical infomations

// <top level name>_<signal name>_<signal_suffix> for signals leaving the top level module
// <sub level name>_<signal name>_<signal_suffix> for signals leaving a sub-module, but not leaving top level
// module. The <sub level name> may optionally be prefixed by <top level name> as well.
// <signal name>_<signal_suffix> for internal signals. The <signal name> may optionally be prefixed by <top level
// name> and/or <sub level name>.

// <signal_suffix> must only be used in this order and suffix is optional
// [_async|_sync] sync identifies a version of an asynchronous signal that has been synchronized with
// the destination clock domain;async identifies a asynchronous signal, or first stage of synchronizing
// [_clk_<suffix>] if multi clk domain in a module, signal's clk domain MUST be specified, e.g. <_clk_200M> <_clk_CORE>

`timescale 1ns / 1ps

module ahb_port_slave_w_sfifo #(
    // +PARAMETER DECLARATION--------------------------------------------------------
	parameter	DATA_WIDTH			= 32,				// Port data bitwidth
	parameter	ADDR_WIDTH			= 32,				// Port address width
    parameter   PORT_BMASK_WIDTH    = 4             ,   // Port Byte mask
	parameter	AHB_ADDR_OFFSET		= 32'h0000_0000,	// AHB slave start address 
	parameter	FIFO_DEPTH			= 2					// FIFO depth
    // -PARAMETER DECLARATION--------------------------------------------------------
)
(
    // +INPUT PORT DECLARATION-------------------------------------------------------
    // AHB INPUTS (w/ AHB_ADDR_OFFSET)
    input              					ahb_hclk,			// AHB Clock input (high-speed clock)   
    input              					ahb_hrst_n,			// AHB Reset asynchronous Active low       
    input              					ahb_hsel,			// AHB Slave select signal
    input       [ADDR_WIDTH-1:0]		ahb_haddr,			// AHB Address bus
    input       [3:0] 					ahb_hprot,			// AHB Protection control signals (this version: keeping 4'b0011, don't used)
    input       [2:0] 					ahb_hsize,			// AHB Transfer size signals (this version: all mode supported)
    input       [1:0]					ahb_htrans,			// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
    input       [DATA_WIDTH-1:0]		ahb_hwdata,			// AHB Write data bus
    input              					ahb_hwrite,			// AHB Write enable signal
	input		[2:0]					ahb_hburst,			// AHB Burst transfer type (this version: keeping 3'b000?) 
	input                         		ahb_hreadyin,       // AHB Bus hready signal input
		
	// Port INPUTS 
	input								port_clk,			// Port Input clock (low-speed clock)
	input								port_rst_n,			// Port input reset (active low)
	input		[DATA_WIDTH-1:0]		port_rdata,			// Port Input data
	input								port_ready,			// Port Input write/read ready (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
	input								port_error,			// Port Input write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
    // -INPUT PORT DECLARATION-------------------------------------------------------
    
    // +OUTPUT PORT DECLARATION------------------------------------------------------
    // AHB OUTPUTS 
    output		[DATA_WIDTH-1:0]		ahb_hrdata,			// AHB Read data bus
    output 		        				ahb_hready,			// AHB Transfer ready signal (active high)
    output		[1:0]					ahb_hresp,			// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
	
	// Port OUTPUTS (w/o AHB_ADDR_OFFSET)
	output		[PORT_BMASK_WIDTH-1:0]	port_ena,			// Port Output write/read enable (i.e. SRAM timing)
	output								port_wea,			// port Output write/read mode (i.e. SRAM timing)
	output		[ADDR_WIDTH-1:0]		port_addr,			// Port Output address (i.e. SRAM timing)
	output		[DATA_WIDTH-1:0]		port_wdata,			// Port Output write data (delay n-cycle)
	output								port_wdata_vld		// Port Output valid of write data (delay n-cycle)
	// -OUTPUT PORT DECLARATION------------------------------------------------------
);  
    
    /*Parameters and Variables*/
    // +INTERNAL Localparam DECLARATION----------------------------------------------
    localparam STATE_ID     = 3'b000;       // AHB FSM idle state
    localparam STATE_R1     = 3'b001;       // AHB FSM read1 state
    localparam STATE_R2     = 3'b011;       // AHB FSM read2 state
    localparam STATE_ERR    = 3'b110;       // AHB FSM error state
    localparam STATE_W1     = 3'b101;       // AHB FSM write1 state
    localparam STATE_W2     = 3'b100;       // AHB FSM write2 state

    localparam AHB_HRESP_OK     = 2'b00;    // ahb_hresp ok state define
    localparam AHB_HRESP_ERROR  = 2'b01;    // ahb_hresp error state define
    
    localparam AHB_HSIZE_8_BIT      = 3'b000;
    localparam AHB_HSIZE_16_BIT     = 3'b001;
    localparam AHB_HSIZE_32_BIT     = 3'b010;
    localparam AHB_HSIZE_64_BIT     = 3'b011;
    localparam AHB_HSIZE_128_BIT    = 3'b100;
    localparam AHB_HSIZE_256_BIT    = 3'b101;
    localparam AHB_HSIZE_512_BIT    = 3'b110;
    localparam AHB_HSIZE_1024_BIT   = 3'b111;
    // -INTERNAL Localparam DECLARATION----------------------------------------------
    
    // +INTERNAL Special Variables DECLARATION----------------------------------------------
    reg  [2:0]              current_state;
    reg  [2:0]              next_state;
    // +INTERNAL Special Variables DECLARATION----------------------------------------------
    
    // +INTERNAL Register DECLARATION-----------------------------------------------------
    reg                     port_wait_respond;
    // -INTERNAL Register DECLARATION-----------------------------------------------------
    
    // +INTERNAL Wire DECLARATION----------------------------------------------------
    wire                    	ahb_hsel_filtered;
    reg  [DATA_WIDTH-1:0]	ahb_hrdata_wire;
    reg                    	 	ahb_hready_wire;
    reg  [1:0]              	ahb_hresp_wire;

    wire [ADDR_WIDTH-1:0]	offset_addr;
    wire [ADDR_WIDTH-1:0]   	edited_addr;
    wire [DATA_WIDTH-1:0]   	edited_wdata;
    
    
    wire                    fifo_rx_ins_rd_en;
    wire [ADDR_WIDTH+3:0]     fifo_rx_ins_rd_data;
    wire [2:0]              fifo_rx_ins_rd_data_hsize;
    wire                    fifo_rx_ins_vld;
    wire                    fifo_rx_ins_wr_en;
    wire [ADDR_WIDTH:0]     fifo_rx_ins_wr_data;
    wire                    fifo_rx_ins_empty;
    
    wire                    fifo_rx_wdata_rd_en;
    wire [DATA_WIDTH-1:0]   fifo_rx_wdata_rd_data;
    wire                    fifo_rx_wdata_vld;
    wire                    fifo_rx_wdata_wr_en;
    wire [DATA_WIDTH-1:0]   fifo_rx_wdata_wr_data;
    
    wire                    fifo_tx_rd_en;
    wire [DATA_WIDTH:0]     fifo_tx_rd_data;
    wire                    fifo_tx_vld;
    wire                    fifo_tx_wr_en;
    wire [DATA_WIDTH:0]     fifo_tx_wr_data;
    wire                    fifo_tx_rd_data_error;
    wire [DATA_WIDTH-1:0]   fifo_tx_rd_data_data;
    // -INTERNAL Wire DECLARATION----------------------------------------------------
    
    /*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
    // +INTERNAL Assign DECLARATION--------------------------------------------------
    assign ahb_hsel_filtered    = ahb_hreadyin ? ahb_hsel : 1'b0;
    assign ahb_hrdata           = ahb_hrdata_wire;
    assign ahb_hready           = ahb_hready_wire;
    assign ahb_hresp            = ahb_hresp_wire;
    
    assign offset_addr          = ahb_haddr - AHB_ADDR_OFFSET;
    assign edited_addr          = offset_addr[ADDR_WIDTH-1:0];
    assign edited_wdata         = ahb_hwdata[DATA_WIDTH-1:0];
    
    assign fifo_rx_ins_rd_en    = 1'b1;
    assign fifo_rx_ins_wr_en    = ahb_hsel_filtered && ahb_hready;
    assign fifo_rx_ins_wr_data  = {ahb_hsize, edited_addr, ahb_hwrite};
    assign fifo_rx_ins_rd_data_hsize = fifo_rx_ins_rd_data[ADDR_WIDTH+1 +: 3];
    
    // port_ena logic
    // assign port_ena             = fifo_rx_ins_vld;
    generate
        if(PORT_BMASK_WIDTH == 1) begin
            assign port_ena = ~fifo_rx_ins_vld ? 1'b0 : 1'b1;
        end else if(PORT_BMASK_WIDTH == 2) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}});
        end else if(PORT_BMASK_WIDTH == 4) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}));
        end else if(PORT_BMASK_WIDTH == 8) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})));
        end else if(PORT_BMASK_WIDTH == 16) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}))));
        end else if(PORT_BMASK_WIDTH == 32) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})))));
        end else if(PORT_BMASK_WIDTH == 64) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_256_BIT  ? {{(PORT_BMASK_WIDTH-32){1'b0}}, {32{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}))))));
        end else if(PORT_BMASK_WIDTH == 128) begin
            assign port_ena = ~fifo_rx_ins_vld ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_256_BIT  ? {{(PORT_BMASK_WIDTH-32){1'b0}}, {32{1'b1}}} : 
                            (fifo_rx_ins_rd_data_hsize == AHB_HSIZE_512_BIT  ? {{(PORT_BMASK_WIDTH-64){1'b0}}, {64{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})))))));
        end
    endgenerate
    assign port_wea             = fifo_rx_ins_rd_data[0];
    assign port_addr            = fifo_rx_ins_rd_data[ADDR_WIDTH:1];
    
    assign fifo_rx_wdata_rd_en  = 1'b1;
    assign fifo_rx_wdata_wr_en  = (current_state == STATE_W1);
    assign fifo_rx_wdata_wr_data    = edited_wdata;
    assign port_wdata           = fifo_rx_wdata_rd_data;
    assign port_wdata_vld       = fifo_rx_wdata_vld;
    
    assign fifo_tx_rd_en        = current_state == STATE_R2 || current_state == STATE_W2;
    assign fifo_tx_wr_en        = port_wait_respond && (port_ready || port_error);
    assign fifo_tx_wr_data      = {port_rdata, port_error};
    assign fifo_tx_rd_data_error    = fifo_tx_rd_data[0];
    assign fifo_tx_rd_data_data = fifo_tx_rd_data[DATA_WIDTH:1];
    // -INTERNAL Assign DECLARATION--------------------------------------------------
    
    /*State Machine----------------------------------------------------------------------------------------------------*/
    // Current State
    always @(posedge ahb_hclk or negedge ahb_hrst_n) begin
        if(~ahb_hrst_n) begin
            current_state <= STATE_ID;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next State
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                if(ahb_hsel_filtered) begin
                    next_state = ahb_hwrite ? STATE_W1 : STATE_R1;
                end else begin
                    next_state = STATE_ID;
                end
            end
            STATE_R1: begin
                next_state = STATE_R2;
            end
            STATE_R2: begin
                if(fifo_tx_vld) begin                // if port ready
                    if(fifo_tx_rd_data_error) begin                // if port error
                        next_state = STATE_ERR;
                    end else begin                      // if port not error
                        if(ahb_hsel_filtered) begin                  // if selected
                            next_state = ahb_hwrite ? STATE_W1 : STATE_R1;
                        end else begin                      // if not selected
                            next_state = STATE_ID;
                        end
                    end
                end else begin                      // if port not ready
                    next_state = STATE_R2;
                end
            end
            STATE_W1: begin
                next_state = STATE_W2;
            end
            STATE_W2: begin
                if(fifo_tx_vld) begin                // if port ready
                    if(fifo_tx_rd_data_error) begin                // if port error
                        next_state = STATE_ERR;
                    end else begin                      // if port not error
                        if(ahb_hsel_filtered) begin                  // if selected
                            next_state = ahb_hwrite ? STATE_W1 : STATE_R1;
                        end else begin                      // if not selected
                            next_state = STATE_ID;
                        end
                    end
                end else begin                      // if port not ready
                    next_state = STATE_W2;
                end
            end
            STATE_ERR: begin
                if(ahb_hsel_filtered) begin
                    next_state = ahb_hwrite ? STATE_W1 : STATE_R1;
                end else begin
                    next_state = STATE_ID;
                end
            end
            default: begin
                next_state = STATE_ID;
            end
        endcase
    end
    
    /*AHB Signal logic----------------------------------------------------------------------------------------------------*/
    // fifo inst
	sync_fifo #( // First Word Fall Through Mode!!!
		// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH            (	ADDR_WIDTH + 1 + 3	),
		.FIFO_DEPTH            (	FIFO_DEPTH					),
		.ALMOST_EMPTY_ENABLE   (	0					),
		.ALMOST_FULL_ENABLE    (	0					),
		.UNDERFLOW_ENABLE      (	0					),
		.OVERFLOW_ENABLE       (	0					),
		.ALMOST_FULL_NUM       (						),
		.ALMOST_EMPTY_NUM      (						)
		// -PARAMETER DECLARATION--------------------------------------------------------
	) fifo_rx_ins (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		.i_wr_clk			(	ahb_hclk			),
		.i_wr_rst_n			(	ahb_hrst_n			),
		.i_wr_en			(	fifo_rx_ins_wr_en	),
		.i_wr_data		    (	fifo_rx_ins_wr_data	),
		
		.i_rd_clk			(	port_clk			),
		.i_rd_rst_n			(	port_rst_n			),
		.i_rd_en			(	fifo_rx_ins_rd_en	),
		// -INPUT PORT DECLARATION-------------------------------------------------------
		
		// +OUTPUT PORT DECLARATION------------------------------------------------------
		.o_rd_data			(	fifo_rx_ins_rd_data	),
		.o_rd_data_vld		(	fifo_rx_ins_vld		),
		.o_fifo_full		(						),
		.o_fifo_empty		(	fifo_rx_ins_empty	),
		.o_fifo_almost_full	(						),
		.o_fifo_almost_empty(						),
		.o_overflow			(						),
		.o_underflow		(						)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);
	
	sync_fifo #( // First Word Fall Through Mode!!!
		// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH            (	DATA_WIDTH	),
		.FIFO_DEPTH            (	FIFO_DEPTH					),
		.ALMOST_EMPTY_ENABLE   (	0					),
		.ALMOST_FULL_ENABLE    (	0					),
		.UNDERFLOW_ENABLE      (	0					),
		.OVERFLOW_ENABLE       (	0					),
		.ALMOST_FULL_NUM       (						),
		.ALMOST_EMPTY_NUM      (						)
		// -PARAMETER DECLARATION--------------------------------------------------------
	) fifo_rx_wdata (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		.i_wr_clk			(	ahb_hclk			),
		.i_wr_rst_n			(	ahb_hrst_n			),
		.i_wr_en			(	fifo_rx_wdata_wr_en	),
		.i_wr_data		    (	fifo_rx_wdata_wr_data	),
		
		.i_rd_clk			(	port_clk			),
		.i_rd_rst_n			(	port_rst_n			),
		.i_rd_en			(	fifo_rx_wdata_rd_en	),
		// -INPUT PORT DECLARATION-------------------------------------------------------
		
		// +OUTPUT PORT DECLARATION------------------------------------------------------
		.o_rd_data			(	fifo_rx_wdata_rd_data	),
		.o_rd_data_vld		(	fifo_rx_wdata_vld		),
		.o_fifo_full		(						),
		.o_fifo_empty		(		),
		.o_fifo_almost_full	(						),
		.o_fifo_almost_empty(						),
		.o_overflow			(						),
		.o_underflow		(						)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);
	
	sync_fifo #( // First Word Fall Through Mode!!!
		// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH            (	DATA_WIDTH + 32'd1	),
		.FIFO_DEPTH            (	FIFO_DEPTH					),
		.ALMOST_EMPTY_ENABLE   (	0					),
		.ALMOST_FULL_ENABLE    (	0					),
		.UNDERFLOW_ENABLE      (	0					),
		.OVERFLOW_ENABLE       (	0					),
		.ALMOST_FULL_NUM       (						),
		.ALMOST_EMPTY_NUM      (						)
		// -PARAMETER DECLARATION--------------------------------------------------------
	) fifo_tx (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		.i_wr_clk			(	ahb_hclk			),
		.i_wr_rst_n			(	ahb_hrst_n			),
		.i_wr_en			(	fifo_tx_wr_en	),
		.i_wr_data		    (	fifo_tx_wr_data	),
		
		.i_rd_clk			(	port_clk			),
		.i_rd_rst_n			(	port_rst_n			),
		.i_rd_en			(	fifo_tx_rd_en	),
		// -INPUT PORT DECLARATION-------------------------------------------------------
		
		// +OUTPUT PORT DECLARATION------------------------------------------------------
		.o_rd_data			(	fifo_tx_rd_data	),
		.o_rd_data_vld		(	fifo_tx_vld		),
		.o_fifo_full		(						),
		.o_fifo_empty		(		),
		.o_fifo_almost_full	(						),
		.o_fifo_almost_empty(						),
		.o_overflow			(						),
		.o_underflow		(						)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);
    
            
    // port_wait_respond logic
    always @(posedge port_clk or negedge port_rst_n) begin
        if(~port_rst_n) begin
            port_wait_respond <= 1'b0;
        end else begin
            if(~fifo_rx_ins_empty) begin
                port_wait_respond <= 1'b1;
            end else if(port_ready || port_error) begin
                port_wait_respond <= 1'b0;
            end
        end
    end
    
    // ahb_hrdata_wire logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            STATE_R1: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            STATE_R2: begin
                if(fifo_tx_vld && ~fifo_tx_rd_data_error) begin
                    ahb_hrdata_wire = fifo_tx_rd_data_data;
                end else begin
                    ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
                end
            end
            STATE_W1: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            STATE_W2: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            STATE_ERR: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            default: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
        endcase
    end
    
    // ahb_hready_wire logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hready_wire = 1'b1;
            end
            STATE_R1: begin
                ahb_hready_wire = 1'b0;
            end
            STATE_R2: begin
                if(fifo_tx_vld && ~fifo_tx_rd_data_error) begin
                    ahb_hready_wire = 1'b1;
                end else begin
                    ahb_hready_wire = 1'b0;
                end
            end
            STATE_W1: begin
                ahb_hready_wire = 1'b0;
            end
            STATE_W2: begin
                if(fifo_tx_vld && ~fifo_tx_rd_data_error) begin
                    ahb_hready_wire = 1'b1;
                end else begin
                    ahb_hready_wire = 1'b0;
                end
            end
            STATE_ERR: begin
                ahb_hready_wire = 1'b1;
            end
            default: begin
                ahb_hready_wire = 1'b1;
            end
        endcase
    end
    
    // ahb_hresp_wire logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hresp_wire = AHB_HRESP_OK;
            end
            STATE_R1: begin
                ahb_hresp_wire = AHB_HRESP_OK;
            end
            STATE_R2: begin
                if(fifo_tx_vld) begin                // if port ready
                    if(fifo_tx_rd_data_error) begin     // if port error
                        ahb_hresp_wire = AHB_HRESP_ERROR;
                    end else begin                      // if port not error
                        ahb_hresp_wire = AHB_HRESP_OK;
                    end
                end else begin                      // if port not ready
                    ahb_hresp_wire = AHB_HRESP_OK;
                end
            end
            STATE_W1: begin
                ahb_hresp_wire = AHB_HRESP_OK;
            end
            STATE_W2: begin
                if(fifo_tx_vld) begin                // if port ready
                    if(fifo_tx_rd_data_error) begin     // if port error
                        ahb_hresp_wire = AHB_HRESP_ERROR;
                    end else begin                      // if port not error
                        ahb_hresp_wire = AHB_HRESP_OK;
                    end
                end else begin                      // if port not ready
                    ahb_hresp_wire = AHB_HRESP_OK;
                end
            end
            STATE_ERR: begin
                ahb_hresp_wire = AHB_HRESP_ERROR;
            end
            default: begin
                ahb_hresp_wire = AHB_HRESP_OK;
            end
        endcase
    end
    
endmodule
