// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   ahb_port2sram.v
// AUTHOR   :   Jianbiao Xiao
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2024.1.31   Jianbiao Xiao    First release
// 1.1      2025.1.22   Hengxin Wang    add hsize function
// -----------------------------------------------------------------------------
// KEYWORDS : AHB, AHB-Lite, Port to sram
// -----------------------------------------------------------------------------
// PURPOSE : Convert port to sram timing;
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE           DESCRIPTION         DEFAULT     UNITS
// DATA_WIDTH       [32,1]          width of the data   32          bit
// ADDR_WIDTH       [32,1]          width of the addr   32          bit
// PORT_BMASK_WIDTH                     width of the bytemask   4           bit
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   port_hclk
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

module ahb_port2sram #(
// +PARAMETER DECLARATION--------------------------------------------------------
	parameter	DATA_WIDTH			= 32,				// data bitwidth
	parameter	ADDR_WIDTH			= 32,				// address width
    parameter   PORT_BMASK_WIDTH    = 4                // Port Byte mask
// -PARAMETER DECLARATION--------------------------------------------------------
)
(
// +INPUT PORT DECLARATION-------------------------------------------------------
	input									clk,				// Input clock (low-speed clock)
	input									rst_n,				// input reset (active low)

	// Port INPUTS (From ahb2port) (w/o AHB_ADDR_OFFSET)
	input		[PORT_BMASK_WIDTH-1:0]		port_ena,			// Port Input write/read enable (i.e. SRAM timing)
	input									port_wea,			// port Input write/read mode (i.e. SRAM timing)
	input		[ADDR_WIDTH-1:0]			port_addr,			// Port Input address (i.e. SRAM timing)
	input		[DATA_WIDTH-1:0]			port_wdata,			// Port Input write data (delay n-cycle)
	input									port_wdata_vld,		// Port Input valid of write data (delay n-cycle)

	// SRAM INPUTS (w/o AHB_ADDR_OFFSET)
	input		[DATA_WIDTH-1:0]			sram_rdata,			// SRAM Input read data
	input									sram_ready,			// SRAM Input ready, 0: not ready 
	input									sram_error,			// SRAM Input error, 0: not error (Combinational logic generation according port_xxx_bypass)

// -INPUT PORT DECLARATION-------------------------------------------------------

// +OUTPUT PORT DECLARATION------------------------------------------------------
	// SRAM OUTPUTS (w/o AHB_ADDR_OFFSET)
	output		[PORT_BMASK_WIDTH-1:0]		sram_ena,			// SRAM Output write/read enable (i.e. SRAM timing)
	output									sram_wea,			// SRAM Output write/read mode (i.e. SRAM timing)
	output		[ADDR_WIDTH-1:0]			sram_addr,			// SRAM Output address (i.e. SRAM timing)
	output		[DATA_WIDTH-1:0]			sram_wdata,			// SRAM Output write data (i.e. SRAM timing)


	// SRAM OUTPUTS (while port_ena_bypass=1, feedback sram_ready & sram_error by LUT, don't use Sequential logic)
	output		[PORT_BMASK_WIDTH-1:0]		port_ena_bypass,	// 
	output									port_wea_bypass,	// 
	output		[ADDR_WIDTH-1:0]			port_addr_bypass,	// 
	
	// Port OUTPUTS (From ahb2port) (w/o AHB_ADDR_OFFSET)
	output		[DATA_WIDTH-1:0]			port_rdata,			// Port Output read data
	output									port_ready,			// Port Output write/read ready (always be 1) (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
	output									port_error			// Port Output write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
// -OUTPUT PORT DECLARATION------------------------------------------------------
);

	
/*Parameters and Variables*/
// +INTERNAL Localparam DECLARATION----------------------------------------------
// -INTERNAL Localparam DECLARATION----------------------------------------------
// +INTERNAL Special Variables DECLARATION----------------------------------------------
// +INTERNAL Special Variables DECLARATION----------------------------------------------
// +INTERNAL Register DECLARATION-----------------------------------------------------
	reg										sram_rd_ready_buf;	
	reg										sram_error_buf;	
	reg			[PORT_BMASK_WIDTH-1:0]		port_ena_buf;			
	reg										port_wea_buf;
	reg 		[ADDR_WIDTH-1:0] 			port_addr_buf;
	reg			[DATA_WIDTH-1:0]			port_wdata_buf;
	reg 									port_wdata_vld_buf;
// -INTERNAL Register DECLARATION-----------------------------------------------------
	
	
// +INTERNAL Wire DECLARATION----------------------------------------------------
	wire									port_rd_en;
	wire									port_wr_en;
	wire									sram_rd_en;
	wire									sram_wr_en;
	wire									sram_ready_inner;
	wire									sram_error_inner;
	wire									sram_wr_ready_wire;
	wire									port_w2r;
	wire									port_wdel;

	reg 		[PORT_BMASK_WIDTH-1:0]		sram_ena_mux;
	reg 									sram_wea_mux;
	reg 		[ADDR_WIDTH-1:0]			sram_addr_mux;
	reg 		[DATA_WIDTH-1:0]			sram_wdata_mux;
// -INTERNAL Wire DECLARATION----------------------------------------------------
	
/*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
// +INTERNAL Assign DECLARATION--------------------------------------------------
	assign port_rd_en  		= (|port_ena && (~port_wea));
	assign port_wr_en  		= (|port_ena && port_wea);
	assign sram_rd_en  		= (|sram_ena && (~sram_wea));
	assign sram_wr_en  		= (|sram_ena && sram_wea);
	assign sram_ready_inner = sram_ready && (~port_w2r) && (~port_wdel);
	assign sram_error_inner = sram_error;
	assign port_w2r 		= port_rd_en && sram_wr_en;
	assign port_wdel 		= port_ena_buf && port_wea_buf && ( ~( (port_wdata_vld || port_wdata_vld_buf) && sram_ready ) ) ;
	
	/*Output Assign*/
	assign port_ready		= sram_rd_ready_buf && sram_wr_ready_wire;
	assign port_error		= sram_error_buf;
	assign port_ena_bypass 	= port_ena;
	assign port_wea_bypass 	= port_wea;
	assign port_addr_bypass	= port_addr;
	assign port_rdata		= sram_rdata;
	
	assign sram_ena			= sram_ena_mux;
	assign sram_wea			= sram_wea_mux;
	assign sram_addr		= sram_addr_mux;
	assign sram_wdata		= sram_wdata_mux;
// -INTERNAL Assign DECLARATION--------------------------------------------------


	
	/*Multiplexer Between Port And Port_buf Signals*/
	always@(*)begin
		if( port_rd_en ) begin
			if( ~port_ena_buf && sram_ready && ~sram_error) begin
				sram_ena_mux = port_ena;
				sram_wea_mux = port_wea;
				sram_addr_mux = port_addr;
			end
			else begin
				sram_ena_mux = port_ena_buf;
				sram_wea_mux = port_wea_buf;
				sram_addr_mux = port_addr_buf;
			end
		end
		else begin
			if( ~sram_ready || port_wdel) begin
				sram_ena_mux = {PORT_BMASK_WIDTH{1'b0}};
				sram_wea_mux = port_wea_buf;
				sram_addr_mux = port_addr_buf;
			end
			else begin
				sram_ena_mux = port_ena_buf;
				sram_wea_mux = port_wea_buf;
				sram_addr_mux = port_addr_buf;
			end
		end

		if(port_wdata_vld) begin
			sram_wdata_mux = port_wdata;
		end
		else begin
			sram_wdata_mux = port_wdata_buf;
		end
	end
	
	/*Buffer For Port Signals*/
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			port_ena_buf <= {PORT_BMASK_WIDTH{1'b0}};
			port_wea_buf <= 1'b0;
			port_addr_buf <= {ADDR_WIDTH{1'b0}};
			port_wdata_buf <= {DATA_WIDTH{1'b0}};
			port_wdata_vld_buf <= 1'b0;
		end
		else begin
			if( ~sram_error_inner ) begin
				if( (~sram_ready_inner && port_rd_en) || port_wr_en ) begin
					port_ena_buf <= port_ena;
					port_wea_buf <= port_wea;
					port_addr_buf <= port_addr;
				end
				else if(sram_ready_inner) begin
					port_ena_buf <= {PORT_BMASK_WIDTH{1'b0}};
					port_wdata_vld_buf <= 1'b0;
				end
			end
			else begin
				port_ena_buf <= {PORT_BMASK_WIDTH{1'b0}};
				port_wdata_vld_buf <= 1'b0;
			end
			
			if(port_wdata_vld && (~sram_ready) && (~sram_error)) begin
				port_wdata_buf <= port_wdata;
				port_wdata_vld_buf <= port_wdata_vld;
			end
		end
	end
	
	/*Delay For sram_ready_inner And sram_error_inner*/
	assign sram_wr_ready_wire = ~port_wdel ;
	always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			sram_rd_ready_buf <= 1'b1;
			sram_error_buf <= 1'b0;
		end
		else begin
			if(port_rd_en || (port_ena_buf && ~port_wea_buf)) begin
				sram_rd_ready_buf <= sram_ready_inner;
			end
			else begin
				sram_rd_ready_buf <= 1'b1;
			end
			sram_error_buf <= sram_error_inner;
		end
	end
	
	
endmodule