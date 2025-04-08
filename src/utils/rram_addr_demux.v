// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   rram_addr_demux.v
// AUTHOR   :   Yang zhengwei
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2025.3.21   yang zheng wei   First release
// 1.1      2025.3.24   Hengxin Wang   	Fix Timing loops in ahb_rram_slave_sreg
// -----------------------------------------------------------------------------
// KEYWORDS : 
// -----------------------------------------------------------------------------
// PURPOSE : 
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE               DESCRIPTION                         DEFAULT     UNITS
// DATA_WIDTH       [32,1]              width of the data                   32          bit
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
//  (6) Attenetion: Allow the input addr to affect the output ready signal (ready = comb(addr)). 
//		Please ensure that these three elements - {rram_2rram_rram(addr = comb(ena)) + host enable protection (ena = comb(ready))} 
//		- are not present simultaneously on the same combinational path.
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps

module rram_addr_demux #(
	// +PARAMETER DECLARATION--------------------------------------------------------
	parameter				RRAM_DATA_WIDTH									= 32							,	// Port data bitwidth
	parameter				RRAM_ADDR_WIDTH									= 32							,	// Port address width
	parameter				RRAM_PARAL_NUM									= 4								,	// Port data bitwidth / 8 (i.e. Byte)
	parameter				RRAM_TGT0_SUB_SADDR_ENA							= 1								,	// RRAM slave target 0 address control, 1: o_rram_t0_maddr =  i_rram_s0_maddr-RRAM_TGT0_SADDR
	parameter				RRAM_TGT0_SADDR									= 32'h0000_0000					,	// AHB slave target 0 start address 
	parameter				RRAM_TGT0_EADDR									= 32'h4000_0000					,	// AHB slave target 0 end address 
	parameter				RRAM_TGT1_SUB_SADDR_ENA							= 1								,	// RRAM slave target 1 address control, 1: o_rram_t1_maddr =  i_rram_s0_maddr-RRAM_TGT1_SADDR
	parameter				RRAM_TGT1_SADDR									= 32'h8000_0000					,	// AHB slave target 1 start address 
	parameter				RRAM_TGT1_EADDR									= 32'h9000_0000					,	// AHB slave target 1 end address 
	parameter               RRAM_RDCNT_WIDTH                                = 8                                 // RRAM slave width of the maximum number of continuous read accesss to same target
)
(
	// +PORT Regular DECLARATION-------------------------------------------------------		
    input      				       											i_clk							,	// AHB Clock input (high-speed clock)   
    input      				       											i_arst_n						,	// AHB Reset asynchronous Active low      
	// -PORT Regular DECLARATION-------------------------------------------------------

	// +PORT RRAM Master Source DECLARATION-------------------------------------------------------
	// Address Start: 0x00
	output					[RRAM_DATA_WIDTH-1:0]							o_rram_s0_rdata				,	// Source Master RRAM Output data (delay n cycle after port_mena, sync with port_ready)
	output					[RRAM_PARAL_NUM-1:0]							o_rram_s0_rdata_vld			,	// Source Master RRAM Output data valid (delay n cycle after port_mena, sync with port_ready)
	output																	o_rram_s0_ready				,	// Source Master RRAM Output write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	output																	o_rram_s0_error				,	// Source Master RRAM Output write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	input					[RRAM_PARAL_NUM-1:0]							i_rram_s0_ena					,	// Source Master RRAM Input write/read enable (i.e. SRAM timing)
	input																	i_rram_s0_wea					,	// Source Master RRAM Input write/read mode (i.e. SRAM timing)
	input					[RRAM_ADDR_WIDTH-1:0]							i_rram_s0_addr					,	// Source Master RRAM Input address (i.e. SRAM timing)
	input					[RRAM_DATA_WIDTH-1:0]							i_rram_s0_wdata				,	// Source Master RRAM Input write data (i.e. SRAM timing)
	// -PORT RRAM Master Source DECLARATION-------------------------------------------------------

	// +PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------
	// Address Start: 0x00 (i.e. i_rram_s0_addr-RRAM_TGT0_SADDR)
    input					[RRAM_DATA_WIDTH-1:0]							i_rram_t0_rdata				,	// Target Slave RRAM Input data (delay n cycle after port_mena, sync with port_ready)
	input					[RRAM_PARAL_NUM-1:0]							i_rram_t0_rdata_vld			,	// Target Slave RRAM Input data valid (delay n cycle after port_mena, sync with port_ready)
	input																	i_rram_t0_ready				,	// Target Slave RRAM Input write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	input																	i_rram_t0_error				,	// Target Slave RRAM Input write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	output					[RRAM_PARAL_NUM-1:0]							o_rram_t0_ena					,	// Target Slave RRAM Output write/read enable (i.e. SRAM timing)
	output																	o_rram_t0_wea					,	// Target Slave RRAM Output write/read mode (i.e. SRAM timing)
	output					[RRAM_ADDR_WIDTH-1:0]							o_rram_t0_addr					,	// Target Slave RRAM Output address (i.e. SRAM timing)
	output					[RRAM_DATA_WIDTH-1:0]							o_rram_t0_wdata				,	// Target Slave RRAM Output write data (i.e. SRAM timing)
	// -PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------

	// +PORT RRAM Slave Target 1 DECLARATION-------------------------------------------------------
    // Address Start: 0x00 (i.e. i_rram_s0_addr-RRAM_TGT1_SADDR)
	input					[RRAM_DATA_WIDTH-1:0]							i_rram_t1_rdata				,	// Target Slave RRAM Input data (delay n cycle after port_mena, sync with port_ready)
	input					[RRAM_PARAL_NUM-1:0]							i_rram_t1_rdata_vld			,	// Target Slave RRAM Input data valid (delay n cycle after port_mena, sync with port_ready)
	input																	i_rram_t1_ready				,	// Target Slave RRAM Input write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	input																	i_rram_t1_error				,	// Target Slave RRAM Input write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	output					[RRAM_PARAL_NUM-1:0]							o_rram_t1_ena					,	// Target Slave RRAM Output write/read enable (i.e. SRAM timing)
	output																	o_rram_t1_wea					,	// Target Slave RRAM Output write/read mode (i.e. SRAM timing)
	output					[RRAM_ADDR_WIDTH-1:0]							o_rram_t1_addr					,	// Target Slave RRAM Output address (i.e. SRAM timing)
	output					[RRAM_DATA_WIDTH-1:0]							o_rram_t1_wdata					// Target Slave RRAM Output write data (i.e. SRAM timing)
	// -PORT RRAM Slave Target 1 DECLARATION-------------------------------------------------------
);  

// + Flag setting
wire gte_t0_s_flag;
wire gte_t0_e_flag;
wire gte_t1_s_flag;
wire gte_t1_e_flag;
wire [RRAM_ADDR_WIDTH-1:0] t0_addr;
wire [RRAM_ADDR_WIDTH-1:0] t1_addr;
assign gte_t0_s_flag = (i_rram_s0_addr >= RRAM_TGT0_SADDR) ? 1'b1 : 1'b0;
assign gte_t0_e_flag = (i_rram_s0_addr >= RRAM_TGT0_EADDR) ? 1'b1 : 1'b0;
assign gte_t1_s_flag = (i_rram_s0_addr >= RRAM_TGT1_SADDR) ? 1'b1 : 1'b0;
assign gte_t1_e_flag = (i_rram_s0_addr >= RRAM_TGT1_EADDR) ? 1'b1 : 1'b0;
assign t0_addr = RRAM_TGT0_SUB_SADDR_ENA ? (gte_t0_s_flag ? (i_rram_s0_addr - RRAM_TGT0_SADDR) : {RRAM_ADDR_WIDTH{1'b0}}) : i_rram_s0_addr;
assign t1_addr = RRAM_TGT1_SUB_SADDR_ENA ? (gte_t1_s_flag ? (i_rram_s0_addr - RRAM_TGT1_SADDR) : {RRAM_ADDR_WIDTH{1'b0}}) : i_rram_s0_addr;

wire t0_flag;
wire t1_flag;
assign t0_flag = (gte_t0_s_flag & (!gte_t0_e_flag)) ? 1'b1 : 1'b0;
assign t1_flag = (gte_t1_s_flag & (!gte_t1_e_flag)) ? 1'b1 : 1'b0;
// - Flag setting

reg [RRAM_DATA_WIDTH-1:0] o_rram_s0_mrdata_buf;
reg [RRAM_PARAL_NUM-1:0] o_rram_s0_mrdata_vld_buf;
reg o_rram_s0_mready_buf;
reg o_rram_s0_merror_buf;

// + Feedback data distribution
wire allow_t0_read_flag;
wire allow_t1_read_flag;
reg [RRAM_RDCNT_WIDTH-1:0] t0_read_times_cnt;
reg [RRAM_RDCNT_WIDTH-1:0] t1_read_times_cnt;
reg t0_read_flag_reg;
reg t1_read_flag_reg;
wire [RRAM_RDCNT_WIDTH:0] full_flag;
assign full_flag = (({{(RRAM_RDCNT_WIDTH-1){1'b0}},{1'b1}}<<RRAM_RDCNT_WIDTH)-1);
assign allow_t0_read_flag = ((t1_read_times_cnt == 'd0) || ((t1_read_times_cnt == 'd1) && (|i_rram_t1_rdata_vld))) && (t0_read_times_cnt != full_flag);
assign allow_t1_read_flag = ((t0_read_times_cnt == 'd0) || ((t0_read_times_cnt == 'd1) && (|i_rram_t0_rdata_vld))) && (t1_read_times_cnt != full_flag);

always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		t0_read_flag_reg <= 1'b0;
	end
	else begin
		if (allow_t0_read_flag && (|o_rram_t0_ena) && t0_flag && (!i_rram_s0_wea)) begin
			t0_read_flag_reg <= 1'b1;
		end
		else begin
			if (i_rram_t0_rdata_vld) begin
				if (t0_read_times_cnt == 'd1) begin
					t0_read_flag_reg <= 1'b0;
				end
			end
		end
	end
end
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		t0_read_times_cnt <= {RRAM_RDCNT_WIDTH{1'b0}};
	end
	else begin
		if (allow_t0_read_flag && (|o_rram_t0_ena) && t0_flag && (!i_rram_s0_wea)) begin
			t0_read_times_cnt <= t0_read_times_cnt + 'd1;
		end
		else begin
			if (i_rram_t0_rdata_vld) begin
				if (t0_read_times_cnt != 'd0) begin
					t0_read_times_cnt <= t0_read_times_cnt - 'd1;
				end
			end
		end
	end
end

always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		t1_read_flag_reg <= 1'b0;
	end
	else begin
		if (allow_t1_read_flag && (|o_rram_t1_ena) && t1_flag && (!i_rram_s0_wea)) begin
			t1_read_flag_reg <= 1'b1;
		end
		else begin
			if (i_rram_t1_rdata_vld) begin
				if (t1_read_times_cnt == 'd1) begin
					t1_read_flag_reg <= 1'b0;
				end
			end
		end
	end
end
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		t1_read_times_cnt <= {RRAM_RDCNT_WIDTH{1'b0}};
	end
	else begin
		if (allow_t1_read_flag && (|o_rram_t1_ena) && t1_flag && (!i_rram_s0_wea)) begin
			t1_read_times_cnt <= t1_read_times_cnt + 'd1;
		end
		else begin
			if (i_rram_t1_rdata_vld) begin
				if (t1_read_times_cnt != 'd0) begin
					t1_read_times_cnt <= t1_read_times_cnt - 'd1;
				end
			end
		end
	end
end

wire [1:0] state;
assign state = {t1_read_flag_reg,t0_read_flag_reg};
always @(*) begin
	case (state)
		2'b00: begin
			o_rram_s0_mrdata_buf = {RRAM_DATA_WIDTH{1'b0}};
			o_rram_s0_mrdata_vld_buf = {RRAM_PARAL_NUM{1'b0}};
		end
		2'b01: begin
			o_rram_s0_mrdata_buf = i_rram_t0_rdata;
			o_rram_s0_mrdata_vld_buf = i_rram_t0_rdata_vld;
		end
		2'b10: begin
			o_rram_s0_mrdata_buf = i_rram_t1_rdata;
			o_rram_s0_mrdata_vld_buf = i_rram_t1_rdata_vld;
		end
		2'b11: begin
			o_rram_s0_mrdata_buf = {RRAM_DATA_WIDTH{1'b0}};
			o_rram_s0_mrdata_vld_buf = {RRAM_PARAL_NUM{1'b0}};
		end
	endcase
end
// - Feedback data distribution

// + Feedback control distribution
wire [1:0] flag_state;
assign flag_state = {t1_flag,t0_flag};
always @(*) begin
	case (flag_state)
		2'b00: begin
			o_rram_s0_mready_buf = 1'b1;
			o_rram_s0_merror_buf = 1'b0;
		end
		2'b01: begin
			// o_rram_s0_mready_buf = i_rram_t0_ready;
			o_rram_s0_mready_buf = allow_t0_read_flag && i_rram_t0_ready;
			o_rram_s0_merror_buf = i_rram_t0_error;
		end
		2'b10: begin
			// o_rram_s0_mready_buf = i_rram_t1_ready;
			o_rram_s0_mready_buf = allow_t1_read_flag && i_rram_t1_ready;
			o_rram_s0_merror_buf = i_rram_t1_error;
		end
		2'b11: begin
			o_rram_s0_mready_buf = 1'b1;
			o_rram_s0_merror_buf = 1'b0;
		end
	endcase
end
// - Feedback control distribution

// + Slave to master
assign o_rram_s0_rdata = o_rram_s0_mrdata_buf;
assign o_rram_s0_rdata_vld = o_rram_s0_mrdata_vld_buf;
assign o_rram_s0_ready = o_rram_s0_mready_buf;
assign o_rram_s0_error = o_rram_s0_merror_buf;
// - Slave to master

// + Master to slave0
reg [RRAM_PARAL_NUM-1:0] o_rram_t0_mena_buf;
reg o_rram_t0_mwea_buf;
reg [RRAM_ADDR_WIDTH-1:0] o_rram_t0_maddr_buf;
reg [RRAM_DATA_WIDTH-1:0] o_rram_t0_mwdata_buf;
always @(*) begin
	if (t0_flag) begin
		o_rram_t0_mena_buf = i_rram_s0_ena;
		o_rram_t0_mwea_buf = i_rram_s0_wea;
		o_rram_t0_maddr_buf = t0_addr;
		o_rram_t0_mwdata_buf = i_rram_s0_wdata;
	end
	else begin
		o_rram_t0_mena_buf = {RRAM_PARAL_NUM{1'b0}};
		o_rram_t0_mwea_buf = 1'b0;
		o_rram_t0_maddr_buf = {RRAM_ADDR_WIDTH{1'b0}};
		o_rram_t0_mwdata_buf = {RRAM_DATA_WIDTH{1'b0}};
	end
end
// assign o_rram_t0_ena = o_rram_t0_mena_buf;
assign o_rram_t0_ena = (!i_rram_s0_wea) ? ({RRAM_PARAL_NUM{allow_t0_read_flag}} & o_rram_t0_mena_buf) : o_rram_t0_mena_buf;
assign o_rram_t0_wea = o_rram_t0_mwea_buf;
assign o_rram_t0_addr = o_rram_t0_maddr_buf;
assign o_rram_t0_wdata = o_rram_t0_mwdata_buf;
// - Master to slave0

// + Master to slave1
reg [RRAM_PARAL_NUM-1:0] o_rram_t1_mena_buf;
reg o_rram_t1_mwea_buf;
reg [RRAM_ADDR_WIDTH-1:0] o_rram_t1_maddr_buf;
reg [RRAM_DATA_WIDTH-1:0] o_rram_t1_mwdata_buf;
always @(*) begin
	if (t1_flag) begin
		o_rram_t1_mena_buf = i_rram_s0_ena;
		o_rram_t1_mwea_buf = i_rram_s0_wea;
		o_rram_t1_maddr_buf = t1_addr;
		o_rram_t1_mwdata_buf = i_rram_s0_wdata;
	end
	else begin
		o_rram_t1_mena_buf = {RRAM_PARAL_NUM{1'b0}};
		o_rram_t1_mwea_buf = 1'b0;
		o_rram_t1_maddr_buf = {RRAM_ADDR_WIDTH{1'b0}};
		o_rram_t1_mwdata_buf = {RRAM_DATA_WIDTH{1'b0}};
	end
end
// assign o_rram_t1_ena = o_rram_t1_mena_buf;
assign o_rram_t1_ena = (!i_rram_s0_wea) ? ({RRAM_PARAL_NUM{allow_t1_read_flag}} & o_rram_t1_mena_buf) : o_rram_t1_mena_buf;
assign o_rram_t1_wea = o_rram_t1_mwea_buf;
assign o_rram_t1_addr = o_rram_t1_maddr_buf;
assign o_rram_t1_wdata = o_rram_t1_mwdata_buf;
// - Master to slave1

endmodule
