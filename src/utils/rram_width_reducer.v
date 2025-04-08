// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   rram_width_reducer.v
// AUTHOR   :   Yang zhengwei
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 2.0      2025.3.27   yang zheng wei   Second release
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
//  (6) Attenetion: Allowed to pass any value of ena when ready equals 0.
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps

module rram_width_reducer #(
	// +PARAMETER DECLARATION--------------------------------------------------------
	parameter				RRAM0_DATA_WIDTH								= 128							,	// Port data bitwidth of RRAM0
	parameter				RRAM0_PARAL_NUM									= 16							,	// Port data bitwidth / 8 (i.e. byte) of RRAM0
	parameter				RRAM1_DATA_WIDTH								= 32							,	// Port data bitwidth of RRAM1 (Must be smaller than RRAM0)
	parameter				RRAM1_PARAL_NUM									= 4								,	// Port data bitwidth / 8 (i.e. byte) of RRAM1
	parameter				RRAMX_ADDR_WIDTH								= 32								// Port address width
)
(
	// +PORT Regular DECLARATION-------------------------------------------------------		
    input      				       											i_clk							,	// AHB Clock input (high-speed clock)   
    input      				       											i_arst_n						,	// AHB Reset asynchronous Active low      
	// -PORT Regular DECLARATION-------------------------------------------------------

	// +PORT RRAM Master Source DECLARATION-------------------------------------------------------
	// Address Start: 0x00
	output					[RRAM0_DATA_WIDTH-1:0]							o_rram_d0_rdata					,	// Source Master RRAM Output data (delay n cycle after port_mena, sync with port_ready)
	output					[RRAM0_PARAL_NUM-1:0]							o_rram_d0_rdata_vld				,	// Source Master RRAM Output data valid (delay n cycle after port_mena, sync with port_ready)
	output																	o_rram_d0_ready					,	// Source Master RRAM Output write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	output																	o_rram_d0_error					,	// Source Master RRAM Output write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	input					[RRAM0_PARAL_NUM-1:0]							i_rram_d0_ena					,	// Source Master RRAM Input write/read enable (i.e. SRAM timing)
	input																	i_rram_d0_wea					,	// Source Master RRAM Input write/read mode (i.e. SRAM timing)
	input					[RRAMX_ADDR_WIDTH-1:0]							i_rram_d0_addr					,	// Source Master RRAM Input address (i.e. SRAM timing)
	input					[RRAM0_DATA_WIDTH-1:0]							i_rram_d0_wdata					,	// Source Master RRAM Input write data (i.e. SRAM timing)
	// -PORT RRAM Master Source DECLARATION-------------------------------------------------------

	// +PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------
	// Address Start: 0x00 (i.e. i_rram_s0_maddr-RRAM_TGT0_SADDR)
    input					[RRAM1_DATA_WIDTH-1:0]							i_rram_d1_rdata					,	// Target Slave RRAM Input data (delay n cycle after port_mena, sync with port_ready)
	input					[RRAM1_PARAL_NUM-1:0]							i_rram_d1_rdata_vld				,	// Target Slave RRAM Input data valid (delay n cycle after port_mena, sync with port_ready)
	input																	i_rram_d1_ready					,	// Target Slave RRAM Input write/read ready (delay 1 cycle after port_mena, 1'b0: master can't process the next data)
	input																	i_rram_d1_error					,	// Target Slave RRAM Input write/read error (delay n cycle after port_mena, sync with port_ready, 1'b1:error, 1'b0:normal)

	output					[RRAM1_PARAL_NUM-1:0]							o_rram_d1_ena					,	// Target Slave RRAM Output write/read enable (i.e. SRAM timing)
	output																	o_rram_d1_wea					,	// Target Slave RRAM Output write/read mode (i.e. SRAM timing)
	output					[RRAMX_ADDR_WIDTH-1:0]							o_rram_d1_addr					,	// Target Slave RRAM Output address (i.e. SRAM timing)
	output					[RRAM1_DATA_WIDTH-1:0]							o_rram_d1_wdata					// Target Slave RRAM Output write data (i.e. SRAM timing)
	// -PORT RRAM Slave Target 0 DECLARATION-------------------------------------------------------
);

localparam SLICING_TIMES = RRAM0_PARAL_NUM / RRAM1_PARAL_NUM;
localparam SLICING_TIMES_LOG2 = $clog2(SLICING_TIMES);

wire [RRAM0_DATA_WIDTH-1:0] o_rram_d0_rdata_tmp_wire1;
wire [RRAM0_PARAL_NUM-1:0] o_rram_d0_rdata_vld_tmp_wire1;

// Get statistics information by compress
reg [SLICING_TIMES-1:0] stat;
integer i;
always @(*) begin
	stat = {SLICING_TIMES{1'b0}};
	for (i = 0; i < SLICING_TIMES; i = i + 1) begin
		stat[i] = |i_rram_d0_ena[i+:RRAM1_PARAL_NUM];
	end
end

// Get sum of compressed statistics information
reg [SLICING_TIMES_LOG2:0] stat_sum;
integer j;
always @(*) begin
	stat_sum = {(SLICING_TIMES_LOG2+1){1'b0}};
	for (j = 0; j < SLICING_TIMES; j = j + 1) begin
		stat_sum = stat_sum + stat[j];
	end
end

// Get info
reg [SLICING_TIMES_LOG2-1:0] stat_info_idx;
reg [SLICING_TIMES_LOG2-1:0] stat_info [SLICING_TIMES-1:0];
integer k;
always @(*) begin
	stat_info_idx = {SLICING_TIMES_LOG2{1'b0}};
	for (k = 0; k < SLICING_TIMES; k = k+1) begin
		stat_info[k] = {SLICING_TIMES_LOG2{1'b0}};
	end
	for (k = 0; k < SLICING_TIMES; k = k+1) begin
		stat_info[stat_info_idx] = stat[k] ? k : {SLICING_TIMES_LOG2{1'b0}};
		stat_info_idx = stat_info_idx + stat[k];
	end
end

// Flags
wire checking_vld_ena;
assign checking_vld_ena = |i_rram_d0_ena;
wire need_multi_send_flag;  // Multi-send-or-not
assign need_multi_send_flag = checking_vld_ena && (stat_sum != 'd1);
wire need_read_flag;  // Read or not
assign need_read_flag = checking_vld_ena && (!o_rram_d1_wea);
// wire need_multi_read_flag;  // Multi-read-or-not
// assign need_multi_read_flag = need_read_flag && need_multi_send_flag;

// Flag for multi-send process
reg multi_sending_flag;
reg [SLICING_TIMES_LOG2-1:0] cnt_max_reg;
reg [SLICING_TIMES_LOG2-1:0] stat_info_for_control [SLICING_TIMES-1:0];
reg [SLICING_TIMES_LOG2-1:0] multi_send_cnt;
reg [RRAM0_PARAL_NUM-1:0] i_rram_d0_ena_save;
reg i_rram_d0_wea_save;
reg [RRAMX_ADDR_WIDTH-1:0] i_rram_d0_addr_save;
reg [RRAM0_DATA_WIDTH-1:0] i_rram_d0_wdata_save;
integer idx;
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		multi_sending_flag <= 1'b0;
		cnt_max_reg <= {SLICING_TIMES_LOG2{1'b0}};
		for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
			stat_info_for_control[idx] <= 'd0;
		end
		i_rram_d0_ena_save <= {RRAM0_PARAL_NUM{1'b0}};
		i_rram_d0_wea_save <= 1'b0;
		i_rram_d0_addr_save <= {RRAMX_ADDR_WIDTH{1'b0}};
		i_rram_d0_wdata_save <= {RRAM0_DATA_WIDTH{1'b0}};
	end
	else begin
		if (need_multi_send_flag) begin
			multi_sending_flag <= 1'b1;
			cnt_max_reg <= stat_sum - 'd1;
			for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
				stat_info_for_control[idx] <= stat_info[idx];
			end
			i_rram_d0_ena_save <= i_rram_d0_ena;
			i_rram_d0_wea_save <= i_rram_d0_wea;
			i_rram_d0_addr_save <= i_rram_d0_addr;
			i_rram_d0_wdata_save <= i_rram_d0_wdata;
		end
		else begin
			if ((multi_send_cnt == cnt_max_reg) && i_rram_d1_ready) begin
				multi_sending_flag <= 1'b0;
				cnt_max_reg <= {SLICING_TIMES_LOG2{1'b0}};
				for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
					stat_info_for_control[idx] <= 'd0;
				end
				i_rram_d0_ena_save <= {RRAM0_PARAL_NUM{1'b0}};
				i_rram_d0_wea_save <= 1'b0;
				i_rram_d0_addr_save <= {RRAMX_ADDR_WIDTH{1'b0}};
				i_rram_d0_wdata_save <= {RRAM0_DATA_WIDTH{1'b0}};
			end
		end
	end
end

// Counter for multi-send process
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		multi_send_cnt <= 'd0;
	end
	else begin
		if (multi_sending_flag && (multi_send_cnt == cnt_max_reg) && i_rram_d1_ready) begin
			multi_send_cnt <= 'd0;
		end
		else begin
			if (need_multi_send_flag || multi_sending_flag) begin
				multi_send_cnt <= multi_send_cnt + i_rram_d1_ready;
			end
		end
	end
end
wire final_send_flag;
assign final_send_flag = (multi_send_cnt == cnt_max_reg);

reg reading_flag;  // Reading process flag
reg [SLICING_TIMES_LOG2-1:0] stat_info_for_read [SLICING_TIMES-1:0];
reg [SLICING_TIMES_LOG2-1:0] multi_read_cnt;  // Reading process controller
reg [SLICING_TIMES_LOG2-1:0] cnt_max_reg_for_read;
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		reading_flag <= 1'b0;
		for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
			stat_info_for_read[idx] <= 'd0;
		end
		cnt_max_reg_for_read <= {SLICING_TIMES_LOG2{1'b0}};
	end
	else begin
		if (need_read_flag) begin
			reading_flag <= 1'b1;
			for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
				stat_info_for_read[idx] <= stat_info[idx];
			end
			cnt_max_reg_for_read <= stat_sum - 'd1;
		end
		else begin
			if ((multi_read_cnt == cnt_max_reg_for_read) & (|i_rram_d1_rdata_vld)) begin
				reading_flag <= 1'b0;
				for (idx = 0; idx < SLICING_TIMES; idx = idx+1) begin
					stat_info_for_read[idx] <= 'd0;
				end
				cnt_max_reg_for_read <= {SLICING_TIMES_LOG2{1'b0}};
			end
		end
	end
end
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		multi_read_cnt <= 'd0;
	end
	else begin
		if ((multi_read_cnt == cnt_max_reg_for_read) && (|i_rram_d1_rdata_vld)) begin
			multi_read_cnt <= 'd0;
		end
		else begin
			if (|i_rram_d1_rdata_vld) begin
				multi_read_cnt <= multi_read_cnt + 'd1;
			end
		end
	end
end
reg [RRAM0_DATA_WIDTH-1:0] o_rram_d0_rdata_buf;  // Output data buffer
reg [RRAM0_PARAL_NUM-1:0] o_rram_d0_rdata_vld_buf;  // Output valid buffer
wire [$clog2(RRAM0_DATA_WIDTH):0] tmp_1;
assign tmp_1 = stat_info_for_read[multi_read_cnt] << $clog2(RRAM1_PARAL_NUM) << 3;
wire [$clog2(RRAM0_DATA_WIDTH):0] tmp_3;
assign tmp_3 = stat_info_for_read[multi_read_cnt] << $clog2(RRAM1_PARAL_NUM);
always @(posedge i_clk or negedge i_arst_n) begin
	if (!i_arst_n) begin
		o_rram_d0_rdata_buf <= {RRAM0_DATA_WIDTH{1'b0}};
		o_rram_d0_rdata_vld_buf <= {RRAM0_PARAL_NUM{1'b0}};
	end
	else begin
		if (reading_flag) begin
			if ((multi_read_cnt == cnt_max_reg_for_read) & (|i_rram_d1_rdata_vld)) begin
				o_rram_d0_rdata_buf <= {RRAM0_DATA_WIDTH{1'b0}};
				o_rram_d0_rdata_vld_buf <= {RRAM0_PARAL_NUM{1'b0}};
			end
			else begin
				if (|i_rram_d1_rdata_vld) begin
					// o_rram_d0_rdata_buf <= o_rram_d0_rdata_buf | (i_rram_d1_rdata << tmp_1);
					// o_rram_d0_rdata_vld_buf <= o_rram_d0_rdata_vld_buf | (i_rram_d1_rdata_vld << tmp_3);
					o_rram_d0_rdata_buf <= o_rram_d0_rdata_tmp_wire1;
					o_rram_d0_rdata_vld_buf <= o_rram_d0_rdata_vld_tmp_wire1;
				end			
			end
		end
		else begin
			o_rram_d0_rdata_buf <= {RRAM0_DATA_WIDTH{1'b0}};
			o_rram_d0_rdata_vld_buf <= {RRAM0_PARAL_NUM{1'b0}};
		end
	end
end

// Assignments
localparam RRAM1_PARAL_NUM_LOG2 = $clog2(RRAM1_PARAL_NUM);
localparam RRAM1_DATA_WIDTH_LOG2 = $clog2(RRAM1_DATA_WIDTH);

wire [SLICING_TIMES:0] tmp_4;
assign tmp_4 = stat_info_for_control[multi_send_cnt] << RRAM1_PARAL_NUM_LOG2;
wire [RRAM0_PARAL_NUM-1:0] o_rram_d1_ena_tmp_wire1;
wire [RRAM0_PARAL_NUM-1:0] o_rram_d1_ena_tmp_wire2;
assign o_rram_d1_ena_tmp_wire1 = (i_rram_d0_ena >> tmp_4);
assign o_rram_d1_ena_tmp_wire2 = (i_rram_d0_ena_save >> tmp_4);
assign o_rram_d1_ena = checking_vld_ena ? o_rram_d1_ena_tmp_wire1[RRAM1_PARAL_NUM-1:0] : o_rram_d1_ena_tmp_wire2[RRAM1_PARAL_NUM-1:0];

assign o_rram_d1_wea = checking_vld_ena ? i_rram_d0_wea : i_rram_d0_wea_save;
assign o_rram_d1_addr = checking_vld_ena ? i_rram_d0_addr : i_rram_d0_addr_save + (multi_send_cnt << $clog2(RRAM1_PARAL_NUM));

wire [$clog2(RRAM0_DATA_WIDTH):0] tmp_2;
assign tmp_2 = stat_info_for_control[multi_send_cnt] << $clog2(RRAM1_PARAL_NUM) << 3;
wire [RRAM0_DATA_WIDTH-1:0] o_rram_d1_wdata_tmp_wire1;
wire [RRAM0_DATA_WIDTH-1:0] o_rram_d1_wdata_tmp_wire2;
assign o_rram_d1_wdata_tmp_wire1 = (i_rram_d0_wdata >> tmp_2);
assign o_rram_d1_wdata_tmp_wire2 = (i_rram_d0_wdata_save >> tmp_2);
assign o_rram_d1_wdata = checking_vld_ena ? o_rram_d1_wdata_tmp_wire1[RRAM1_DATA_WIDTH-1:0] : o_rram_d1_wdata_tmp_wire2[RRAM1_DATA_WIDTH-1:0];

assign o_rram_d0_rdata_tmp_wire1 = (o_rram_d0_rdata_buf | (i_rram_d1_rdata << tmp_1));
assign o_rram_d0_rdata = o_rram_d0_ready ? o_rram_d0_rdata_tmp_wire1 : {RRAM0_DATA_WIDTH{1'b0}};

assign o_rram_d0_rdata_vld_tmp_wire1 = (o_rram_d0_rdata_vld_buf | (i_rram_d1_rdata_vld << tmp_3));
assign o_rram_d0_rdata_vld = o_rram_d0_ready ? o_rram_d0_rdata_vld_tmp_wire1 : {RRAM0_PARAL_NUM{1'b0}};

assign o_rram_d0_ready = multi_sending_flag ? (reading_flag ? 1'b0 : (1'b0 | final_send_flag)) : i_rram_d1_ready;
assign o_rram_d0_error = i_rram_d1_error;

endmodule
