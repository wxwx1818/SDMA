// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   ahb_port_slave_wo_sfifo.v
// AUTHOR   :   Hengxin Wang
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2024.1.31   Hengxin Wang    First release
// 1.1      2025.1.22   Hengxin Wang    add hsize function
// -----------------------------------------------------------------------------
// KEYWORDS : AHB-Lite, Slave
// -----------------------------------------------------------------------------
// PURPOSE : Connect a submodule to AHB-Lite bus as a slave;
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE               DESCRIPTION             DEFAULT     UNITS
// DATA_WIDTH       [32,1]              width of the data       32          bit
// ADDR_WIDTH       [32,1]              width of the addr       32          bit
// PORT_BMASK_WIDTH                     width of the bytemask   4           bit
// AHB_ADDR_OFFSET  [0xffffffff,0x0]    addr offset in ahb      0x0         
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   ahb_hclk
//  Critical Timing     :   N/A
//  Test Features       :   None
//  Asynchronous I/F    :   N
//  Instantiations      :   None
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

module ahb_port_slave_wo_sfifo #(
    // +PARAMETER DECLARATION--------------------------------------------------------
	parameter	DATA_WIDTH			= 32,				// Port data bitwidth
	parameter	ADDR_WIDTH			= 32,				// Port address width
    parameter   PORT_BMASK_WIDTH    = 4             ,   // Port Byte mask
	parameter	AHB_ADDR_OFFSET		= 32'h0000_0000	    // AHB slave start address 
    // -PARAMETER DECLARATION--------------------------------------------------------
)
(
    // +INPUT PORT DECLARATION-------------------------------------------------------
    // AHB INPUTS (w/ AHB_ADDR_OFFSET)
    input              						ahb_hclk,			// AHB Clock input (high-speed clock)   
    input              						ahb_hrst_n,			// AHB Reset asynchronous Active low       
    input              						ahb_hsel,			// AHB Slave select signal
    input       [ADDR_WIDTH-1:0]			ahb_haddr,			// AHB Address bus
    input       [3:0] 						ahb_hprot,			// AHB Protection control signals (this version: keeping 4'b0011, don't used)
    input       [2:0] 						ahb_hsize,			// AHB Transfer size signals (this version: all mode supported)
    input       [1:0]						ahb_htrans,			// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
    input       [DATA_WIDTH-1:0]			ahb_hwdata,			// AHB Write data bus
    input              						ahb_hwrite,			// AHB Write enable signal
	input		[2:0]						ahb_hburst,			// AHB Burst transfer type (this version: keeping 3'b000?) 
	input                          			ahb_hreadyin,       // AHB Bus hready signal input
	
	// Port INPUTS 
	input									port_clk,			// Port Input clock (low-speed clock)
	input									port_rst_n,			// Port input reset (active low)
	input		[DATA_WIDTH-1:0]			port_rdata,			// Port Input data
	input									port_ready,			// Port Input write/read ready (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
	input									port_error,			// Port Input write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
    // -INPUT PORT DECLARATION-------------------------------------------------------
    
    // +OUTPUT PORT DECLARATION------------------------------------------------------
    // AHB OUTPUTS 
    output		[DATA_WIDTH-1:0]			ahb_hrdata,			// AHB Read data bus
    output 		        					ahb_hready,			// AHB Transfer ready signal (active high)
    output		[1:0]						ahb_hresp,			// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
	
	// Port OUTPUTS (w/o AHB_ADDR_OFFSET)
	output		[PORT_BMASK_WIDTH-1:0]		port_ena,			// Port Output write/read enable (i.e. SRAM timing)
	output									port_wea,			// port Output write/read mode (i.e. SRAM timing)
	output		[ADDR_WIDTH-1:0]			port_addr,			// Port Output address (i.e. SRAM timing)
	output		[DATA_WIDTH-1:0]			port_wdata,			// Port Output write data (delay n-cycle)
	output									port_wdata_vld		// Port Output valid of write data (delay n-cycle)
	// -OUTPUT PORT DECLARATION------------------------------------------------------
);  

    /*Parameters and Variables*/
    // +INTERNAL Localparam DECLARATION----------------------------------------------
    localparam STATE_ID  = 2'b00;           // AHB FSM idle state
    localparam STATE_R = 2'b01;             // AHB FSM read state
    localparam STATE_W = 2'b10;             // AHB FSM write state
    localparam STATE_ERR = 2'b11;           // AHB FSM error state
    
    localparam AHB_HSIZE_8_BIT      = 3'b000;
    localparam AHB_HSIZE_16_BIT     = 3'b001;
    localparam AHB_HSIZE_32_BIT     = 3'b010;
    localparam AHB_HSIZE_64_BIT     = 3'b011;
    localparam AHB_HSIZE_128_BIT    = 3'b100;
    localparam AHB_HSIZE_256_BIT    = 3'b101;
    localparam AHB_HSIZE_512_BIT    = 3'b110;
    localparam AHB_HSIZE_1024_BIT   = 3'b111;

    localparam AHB_HRESP_OK     = 2'b00;    // ahb_hresp ok state define
    localparam AHB_HRESP_ERROR  = 2'b01;    // ahb_hresp error state define
    // -INTERNAL Localparam DECLARATION----------------------------------------------
    
    // +INTERNAL Special Variables DECLARATION----------------------------------------------
    reg  [1:0]  current_state;              // AHB FSM current state reg
    reg  [1:0]  next_state;                 // AHB FSM next state wire
    // +INTERNAL Special Variables DECLARATION----------------------------------------------
    
    // +INTERNAL Register DECLARATION-----------------------------------------------------
    reg                     port_ready_delay;
    // -INTERNAL Register DECLARATION-----------------------------------------------------
    
    // +INTERNAL Wire DECLARATION----------------------------------------------------
    wire ahb_hsel_filt;
    reg  [DATA_WIDTH-1:0]	            	ahb_hrdata_wire;
    reg                    					ahb_hready_wire;
    reg  [1:0]              				ahb_hresp_wire;
    wire [ADDR_WIDTH-1:0]             		offset_addr;
    wire [ADDR_WIDTH-1:0]   				edited_addr;
    wire [DATA_WIDTH-1:0]   				edited_wdata;
    // -INTERNAL Wire DECLARATION----------------------------------------------------
    
    /*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
    // +INTERNAL Assign DECLARATION--------------------------------------------------
    assign ahb_hsel_filt = ahb_hreadyin ? ahb_hsel : 1'b0;
    assign ahb_hrdata       = ahb_hrdata_wire;
    assign ahb_hready       = ahb_hready_wire;
    assign ahb_hresp        = ahb_hresp_wire;
    assign offset_addr      = ahb_haddr - AHB_ADDR_OFFSET;
    assign edited_addr      = offset_addr[ADDR_WIDTH-1:0];
    assign edited_wdata     = ahb_hwdata[DATA_WIDTH-1:0];

    // port_ena logic
    generate
        if(PORT_BMASK_WIDTH == 1) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? 1'b0 : 1'b1;
        end else if(PORT_BMASK_WIDTH == 2) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}});
        end else if(PORT_BMASK_WIDTH == 4) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}));
        end else if(PORT_BMASK_WIDTH == 8) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})));
        end else if(PORT_BMASK_WIDTH == 16) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}))));
        end else if(PORT_BMASK_WIDTH == 32) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})))));
        end else if(PORT_BMASK_WIDTH == 64) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_256_BIT  ? {{(PORT_BMASK_WIDTH-32){1'b0}}, {32{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}}))))));
        end else if(PORT_BMASK_WIDTH == 128) begin
            assign port_ena = ~(ahb_hsel_filt && ahb_hready) ? {PORT_BMASK_WIDTH{1'b0}} : 
                            (ahb_hsize == AHB_HSIZE_8_BIT   ? {{(PORT_BMASK_WIDTH-1){1'b0}}, {1{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_16_BIT  ? {{(PORT_BMASK_WIDTH-2){1'b0}}, {2{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_32_BIT  ? {{(PORT_BMASK_WIDTH-4){1'b0}}, {4{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_64_BIT  ? {{(PORT_BMASK_WIDTH-8){1'b0}}, {8{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_128_BIT  ? {{(PORT_BMASK_WIDTH-16){1'b0}}, {16{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_256_BIT  ? {{(PORT_BMASK_WIDTH-32){1'b0}}, {32{1'b1}}} : 
                            (ahb_hsize == AHB_HSIZE_512_BIT  ? {{(PORT_BMASK_WIDTH-64){1'b0}}, {64{1'b1}}} : {PORT_BMASK_WIDTH{1'b1}})))))));
        end
    endgenerate
    assign port_wea         = |port_ena ? ahb_hwrite : 1'b0;
    assign port_addr        = |port_ena ? edited_addr : {ADDR_WIDTH{1'b0}};
    assign port_wdata       = (~port_error && current_state == STATE_W) ? edited_wdata : {DATA_WIDTH{1'b0}};
    assign port_wdata_vld   = (~port_error && current_state == STATE_W && port_ready_delay);
    // -INTERNAL Assign DECLARATION--------------------------------------------------
    
    // Delay module ahb_port2sram
    always @(posedge ahb_hclk or negedge ahb_hrst_n) begin
        if(~ahb_hrst_n) begin
            current_state <= STATE_ID;
        end else begin
            current_state <= next_state;
        end
    end
    
    /*State Machine----------------------------------------------------------------------------------------------------*/
    // Current State
    always @(posedge ahb_hclk or negedge ahb_hrst_n) begin
        if(~ahb_hrst_n) begin
            port_ready_delay <= 1'b0;
        end else begin
            port_ready_delay <= port_ready;
        end
    end
    
    // Next State
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                if(ahb_hsel_filt) begin
                    next_state = ahb_hwrite ? STATE_W : STATE_R;
                end else begin
                    next_state = STATE_ID;
                end
            end
            STATE_R: begin
                if(port_ready) begin                // if port ready
                    if(port_error) begin                // if port error
                        next_state = STATE_ERR;
                    end else begin                      // if port not error
                        if(ahb_hsel_filt) begin                  // if selected
                            next_state = ahb_hwrite ? STATE_W : STATE_R;
                        end else begin                      // if not selected
                            next_state = STATE_ID;
                        end
                    end
                end else begin                      // if port not ready
                    next_state = STATE_R;
                end
            end
            STATE_W: begin
                if(port_ready) begin                // if port ready
                    if(port_error) begin                // if port error
                        next_state = STATE_ERR;
                    end else begin                      // if port not error
                        if(ahb_hsel_filt) begin                  // if selected
                            next_state = ahb_hwrite ? STATE_W : STATE_R;
                        end else begin                      // if not selected
                            next_state = STATE_ID;
                        end
                    end
                end else begin                      // if port not ready
                    next_state = STATE_W;
                end
            end
            STATE_ERR: begin
                if(ahb_hsel_filt) begin
                    next_state = ahb_hwrite ? STATE_W : STATE_R;
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
    // ahb_hrdata logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
            end
            STATE_R: begin
                if(port_ready && ~port_error) begin
                    ahb_hrdata_wire = port_rdata;
                end else begin
                    ahb_hrdata_wire = {DATA_WIDTH{1'b0}};
                end
            end
            STATE_W: begin
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
    
    // ahb_hready logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hready_wire = 1'b1;
            end
            STATE_R: begin
                if(port_ready) begin
                    ahb_hready_wire = ~port_error;
                end else begin
                    ahb_hready_wire = 1'b0;
                end
            end
            STATE_W: begin
                if(port_ready) begin
                    ahb_hready_wire = ~port_error;
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
    
    // ahb_hresp logic
    always @(*) begin
        case(current_state)
            STATE_ID: begin
                ahb_hresp_wire = AHB_HRESP_OK; // OK
            end
            STATE_R: begin
                if(port_error) begin
                    ahb_hresp_wire = AHB_HRESP_ERROR; // OK
                end else begin
                    ahb_hresp_wire = AHB_HRESP_OK; // OK
                end
            end
            STATE_W: begin
                if(port_error) begin
                    ahb_hresp_wire = AHB_HRESP_ERROR; // OK
                end else begin
                    ahb_hresp_wire = AHB_HRESP_OK; // OK
                end
            end
            STATE_ERR: begin
                ahb_hresp_wire = AHB_HRESP_ERROR; // ERROR
            end
            default: begin
                ahb_hresp_wire = AHB_HRESP_OK; // OK
            end
        endcase
    end
    
endmodule
