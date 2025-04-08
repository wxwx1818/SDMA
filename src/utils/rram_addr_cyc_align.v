// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   rram_addr_cyc_align.v
// AUTHOR   :   Hengxin Wang
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2025.3.21   Jianbiao Xiao   First release (Interface)
// 1.1		2025.3.21	Hengxin	Wang	Implementation
// 1.2		2025.3.21	Hengxin	Wang	separate i_rram_d0_aca_ena into i_rram_d0_rd_aca_ena and i_rram_d0_wr_aca_ena
// -----------------------------------------------------------------------------
// KEYWORDS : 
// -----------------------------------------------------------------------------
// PURPOSE : 
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE 	DESCRIPTION        	DEFAULT  	UNITS
// RRAM_ADDR_WIDTH	        width of the addr  	32       	bit
// RRAM_DATA_WIDTH	        width of the data  	32       	bit
// RRAM_PARAL_NUM	        paral num          	4        	bit
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   
//  Clock Domains       :   
//  Critical Timing     :   N/A
//  Test Features       :   None
//  Asynchronous I/F    :   Both
//  Instantiations      :   
//  Synthesizable (y/n) :   Y
//  Other Considerations:
//  (1) Support Any RRAM Address R/W;
//  (2) Support Unaligned R/W;
//  (3) Support Aligned-1/2/4 RRAM Address R/W;
//  (4) Address: No Risk Of Address Disclosure;
//  (5) Error: No Special Handling For Error.
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps

module rram_addr_cyc_align #(
	// +PARAMETER DECLARATION--------------------------------------------------------
	parameter				RRAM_ADDR_WIDTH									= 32							,	// Port address width
	parameter				RRAM_DATA_WIDTH									= 32							,	// Port data bitwidth of RRAM0
	parameter				RRAM_PARAL_NUM									= 4									// Port data bitwidth / 8 (i.e. byte) of RRAM0
	// -PARAMETER DECLARATION--------------------------------------------------------
)
(
	// +PORT Regular DECLARATION-------------------------------------------------------		
	input																	i_rram_d0_rd_aca_ena			,	// address cyclic alignment rd
	input																	i_rram_d0_wr_aca_ena			,	// address cyclic alignment wr
	input					[RRAM_ADDR_WIDTH-1:0]							i_rram_d1_saddr					,	// start address of target (D1)
	input					[RRAM_ADDR_WIDTH-1:0]							i_rram_d1_eaddr					,	// end address of target (D1)
	// -PORT Regular DECLARATION-------------------------------------------------------

	// +PORT RRAM Master Source DECLARATION-------------------------------------------------------
	// Address Start: 0x00
	output					[RRAM_DATA_WIDTH-1:0]							o_rram_d0_rdata					,	// Source Master RRAM Output data (delay n cycle after port_mena, sync with port_ready)
	output					[RRAM_PARAL_NUM-1:0]							o_rram_d0_rdata_vld				,	// Source Master RRAM Output data valid (delay n cycle after port_mena, sync with port_ready)
	output																	o_rram_d0_ready					,	// Source Master RRAM Output write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	output																	o_rram_d0_error					,	// Source Master RRAM Output write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	input					[RRAM_PARAL_NUM-1:0]							i_rram_d0_ena					,	// Source Master RRAM Input write/read enable (i.e. SRAM timing)
	input																	i_rram_d0_wea					,	// Source Master RRAM Input write/read mode (i.e. SRAM timing)
	input					[RRAM_ADDR_WIDTH-1:0]							i_rram_d0_addr					,	// Source Master RRAM Input address (i.e. SRAM timing)
	input					[RRAM_DATA_WIDTH-1:0]							i_rram_d0_wdata					,	// Source Master RRAM Input write data (i.e. SRAM timing)
	// -PORT RRAM Master Source DECLARATION-------------------------------------------------------

	// +PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------
	// Address Start: 0x00 (i.e. i_rram_s0_maddr-RRAM_TGT0_SADDR)
    input					[RRAM_DATA_WIDTH-1:0]							i_rram_d1_rdata					,	// Target Slave RRAM Input data (delay n cycle after port_mena, sync with port_ready)
	input					[RRAM_PARAL_NUM-1:0]							i_rram_d1_rdata_vld				,	// Target Slave RRAM Input data valid (delay n cycle after port_mena, sync with port_ready)
	input																	i_rram_d1_ready					,	// Target Slave RRAM Input write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	input																	i_rram_d1_error					,	// Target Slave RRAM Input write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	output					[RRAM_PARAL_NUM-1:0]							o_rram_d1_ena					,	// Target Slave RRAM Output write/read enable (i.e. SRAM timing)
	output																	o_rram_d1_wea					,	// Target Slave RRAM Output write/read mode (i.e. SRAM timing)
	output					[RRAM_ADDR_WIDTH-1:0]							o_rram_d1_addr					,	// Target Slave RRAM Output address (i.e. SRAM timing)
	output					[RRAM_DATA_WIDTH-1:0]							o_rram_d1_wdata						// Target Slave RRAM Output write data (i.e. SRAM timing)
	// -PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------
);

reg [RRAM_ADDR_WIDTH-1:0] rram_d1_addr_logic;

always @(*) begin
	if((i_rram_d0_rd_aca_ena && !i_rram_d0_wea) || (i_rram_d0_wr_aca_ena && i_rram_d0_wea)) begin
		if(i_rram_d0_addr > i_rram_d1_eaddr) begin
			rram_d1_addr_logic = i_rram_d0_addr - (i_rram_d1_eaddr - i_rram_d1_saddr + 1'b1);
		end else begin
			rram_d1_addr_logic = i_rram_d0_addr;
		end
	end else begin
		rram_d1_addr_logic = i_rram_d0_addr;
	end
end

assign o_rram_d1_addr		= rram_d1_addr_logic	;

assign o_rram_d0_rdata		= i_rram_d1_rdata		;
assign o_rram_d0_rdata_vld	= i_rram_d1_rdata_vld	;
assign o_rram_d0_ready		= i_rram_d1_ready		;
assign o_rram_d0_error		= i_rram_d1_error		;
assign o_rram_d1_ena		= i_rram_d0_ena			;
assign o_rram_d1_wea		= i_rram_d0_wea			;
assign o_rram_d1_wdata		= i_rram_d0_wdata		;

endmodule