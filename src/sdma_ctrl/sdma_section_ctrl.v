// -----------------------------------------------------------------------------
// FILE NAME : sdma_section_ctrl.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-18
// -----------------------------------------------------------------------------
// DESCRIPTION : Divide transfer into several sections based on sdmamode.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_section_ctrl
(
	input													clk,
	input													rst_n,
	input													i_ssc_en,
	input  													i_ssc_concateen,
	input  		[`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0] 		i_ssc_srcfmsmovelength,
	input  		[`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0]  	i_ssc_srcfms2movelength,
	input  		[`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0]	i_ssc_srcfms1concatelength,
	input  		[`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0]	i_ssc_srcfms2concatelength,
	input													i_ssc_sdp_outputsectiondone,
	input													i_ssc_sdp_parallelinoutsectiondone,
	output	reg												o_ssc_transfer_pending,
	output													o_ssc_transfer_done,
	output  reg [`SDMA_SECTION_DINNUMDATAWIDTH-1:0]			o_ssc_num_of_remain_bytes,
	output	reg												o_ssc_concate_fms_switch_flag,
	output	reg												o_ssc_sapsdpen,
	output	reg												o_ssc_ready,
	output		[9:0]										o_ssc_sigmnt1,
	output		[9:0]										o_ssc_sigmnt2
);

//----------------------------------STATE---------------------------------------
localparam [1:0] IDLE 	 		 = 2'b00;
localparam [1:0] TRANSFER 		 = 2'b01;
localparam [1:0] CONCATETRANSFER = 2'b10;
//------------------------------------------------------------------------------

//----------------------------------VARIABLES-----------------------------------
reg	[1:0]										cur_state;
reg	[1:0]										next_state;
reg	[`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0]		sfms1_transfer_cnt;
reg	[`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0]		sfms2_transfer_cnt;
reg	[`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0]	sfms1_concate_cnt;
reg	[`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0]	sfms2_concate_cnt;
reg	[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]			num_of_remain_bytes_next;
reg												concate_fms_switch_next;
//------------------------------------------------------------------------------

//----------------------------------STATE TRANSFER------------------------------
always@(*)begin
	case(cur_state)
		IDLE:begin
			if(i_ssc_en & i_ssc_concateen)begin
				next_state = CONCATETRANSFER;
			end
			else if(i_ssc_en)begin
				next_state = TRANSFER;
			end
			else begin
				next_state = IDLE;
			end
		end
		TRANSFER:begin
			if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
				next_state = IDLE;
			end
			else begin
				next_state = TRANSFER;
			end
		end
		CONCATETRANSFER:begin
			if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
				next_state = IDLE;
			end
			else begin
				next_state = CONCATETRANSFER;
			end
		end
		default:begin
			next_state = IDLE;
		end
	endcase
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end
//------------------------------------------------------------------------------

//----------------------------------REGISTER VALUE LOGIC------------------------

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		sfms1_transfer_cnt <= {(`SDMA_INST_SRCFMSMOVELENGTHWIDTH){1'b0}};
		sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
		sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
		sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_ssc_en & i_ssc_concateen)begin
					sfms1_transfer_cnt <= (i_ssc_srcfms1concatelength > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):i_ssc_srcfms1concatelength;
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms1_concate_cnt  <= (i_ssc_srcfms1concatelength > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):i_ssc_srcfms1concatelength;
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
				end
				else if(i_ssc_en)begin
					sfms1_transfer_cnt <= (i_ssc_srcfmsmovelength > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):i_ssc_srcfmsmovelength;
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
				end
				else begin
					sfms1_transfer_cnt <= {(`SDMA_INST_SRCFMSMOVELENGTHWIDTH){1'b0}};
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
				end
			end
			TRANSFER:begin
				if(next_state == IDLE)begin
					sfms1_transfer_cnt <= {(`SDMA_INST_SRCFMSMOVELENGTHWIDTH){1'b0}};
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
				end
				else begin
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
						sfms1_transfer_cnt <= sfms1_transfer_cnt + num_of_remain_bytes_next;
						sfms1_concate_cnt  <= (sfms1_concate_cnt == i_ssc_srcfms1concatelength)?{(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}}:(sfms1_concate_cnt + num_of_remain_bytes_next); 
					end
					else begin
						sfms1_transfer_cnt <= sfms1_transfer_cnt;
						sfms1_concate_cnt  <= sfms1_concate_cnt;
					end
				end
			end
			CONCATETRANSFER:begin
				if(next_state == IDLE)begin
					sfms1_transfer_cnt <= {(`SDMA_INST_SRCFMSMOVELENGTHWIDTH){1'b0}};
					sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
					sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
					sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
				end
				else begin
					if(!o_ssc_concate_fms_switch_flag)begin  //transfer fms1			
						if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
							sfms1_transfer_cnt <= sfms1_transfer_cnt;
							sfms1_concate_cnt  <= (sfms1_concate_cnt == i_ssc_srcfms1concatelength)?{(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}}:sfms2_concate_cnt;
							sfms2_transfer_cnt <= sfms2_transfer_cnt + num_of_remain_bytes_next;
							sfms2_concate_cnt  <= (sfms2_concate_cnt == i_ssc_srcfms2concatelength)?{(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}}:(sfms2_concate_cnt + num_of_remain_bytes_next); 
						end
						else begin
							sfms1_transfer_cnt <= sfms1_transfer_cnt;
							sfms1_concate_cnt  <= sfms1_concate_cnt;
							sfms2_transfer_cnt <= sfms2_transfer_cnt;
							sfms2_concate_cnt  <= sfms2_concate_cnt;
						end
					end
					else begin
						if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
							sfms1_transfer_cnt <= sfms1_transfer_cnt + num_of_remain_bytes_next;
							sfms1_concate_cnt  <= (sfms1_concate_cnt == i_ssc_srcfms1concatelength)?{(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}}:(sfms1_concate_cnt + num_of_remain_bytes_next); 
							sfms2_transfer_cnt <= sfms2_transfer_cnt;
							sfms2_concate_cnt  <= (sfms2_concate_cnt == i_ssc_srcfms2concatelength)?{(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}}:sfms2_concate_cnt;
						end
						else begin
							sfms1_transfer_cnt <= sfms1_transfer_cnt;
							sfms1_concate_cnt  <= sfms1_concate_cnt;
							sfms2_transfer_cnt <= sfms2_transfer_cnt;
							sfms2_concate_cnt  <= sfms2_concate_cnt;
						end
					end
				end
			end
			default:begin
				sfms1_transfer_cnt <= {(`SDMA_INST_SRCFMSMOVELENGTHWIDTH){1'b0}};
				sfms2_transfer_cnt <= {(`SDMA_INST_SRCFMS2MOVELENGTHWIDTH){1'b0}};
				sfms1_concate_cnt  <= {(`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH){1'b0}};
				sfms2_concate_cnt  <= {(`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH){1'b0}};
			end
		endcase
	end
end

always@(*)begin
	case(cur_state)
		IDLE:begin
			concate_fms_switch_next = 1'b0;
		end
		TRANSFER:begin
			concate_fms_switch_next = 1'b0;
		end
		CONCATETRANSFER:begin
			concate_fms_switch_next = (~o_ssc_concate_fms_switch_flag && (sfms1_concate_cnt == i_ssc_srcfms1concatelength));
		end
		default:begin
			concate_fms_switch_next = 1'b0;
		end
	endcase
end

always@(*)begin
	case(cur_state)
		IDLE:begin
			num_of_remain_bytes_next = {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
		end
		TRANSFER:begin
			num_of_remain_bytes_next = ($unsigned(i_ssc_srcfmsmovelength - sfms1_transfer_cnt) > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):(i_ssc_srcfmsmovelength - sfms1_transfer_cnt);
		end
		CONCATETRANSFER:begin
			if(~o_ssc_concate_fms_switch_flag)begin
				num_of_remain_bytes_next = ($unsigned(i_ssc_srcfms2concatelength - sfms2_concate_cnt) > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):(i_ssc_srcfms2concatelength - sfms2_concate_cnt);
			end
			else begin
				num_of_remain_bytes_next = ($unsigned(i_ssc_srcfms1concatelength - sfms1_concate_cnt) > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):(i_ssc_srcfms1concatelength - sfms1_concate_cnt);
			end
		end
		default:begin
			num_of_remain_bytes_next = {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
		end
	endcase
end

//------------------------------------------------------------------------------

//----------------------------------OUTPUT LOGIC--------------------------------

assign o_ssc_transfer_done = (cur_state == TRANSFER || cur_state == CONCATETRANSFER) && ~o_ssc_transfer_pending 
							&&(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone);

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_ssc_sapsdpen <= 1'b0;
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_ssc_en)begin
					o_ssc_sapsdpen <= 1'b1;
				end
				else begin
					o_ssc_sapsdpen <= 1'b0;
				end
			end
			TRANSFER:begin
				if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
					o_ssc_sapsdpen <= 1'b0;
				end
				else begin
					o_ssc_sapsdpen <= 1'b1;
				end
			end
			CONCATETRANSFER:begin
				if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
					o_ssc_sapsdpen <= 1'b0;
				end
				else begin
					o_ssc_sapsdpen <= 1'b1;
				end
			end
			default:begin
				o_ssc_sapsdpen <= 1'b0;
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_ssc_transfer_pending <= 1'b0;
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_ssc_en && i_ssc_concateen)begin
					o_ssc_transfer_pending <= 1'b1;
				end
				else if(i_ssc_en) begin
					o_ssc_transfer_pending <= (i_ssc_srcfmsmovelength > `SDMA_CACHEDATAWIDTH/8);
				end
				else begin
					o_ssc_transfer_pending <= 1'b0;
				end
			end
			TRANSFER:begin
				if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
					o_ssc_transfer_pending <= ~((sfms1_transfer_cnt + num_of_remain_bytes_next == i_ssc_srcfmsmovelength)||(sfms1_transfer_cnt == i_ssc_srcfmsmovelength));
				end
				else begin
					o_ssc_transfer_pending <= o_ssc_transfer_pending;
				end
			end
			CONCATETRANSFER:begin
				if((sfms1_transfer_cnt == i_ssc_srcfmsmovelength) && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
					o_ssc_transfer_pending <= ~((sfms2_transfer_cnt + num_of_remain_bytes_next == i_ssc_srcfms2movelength)||(sfms2_transfer_cnt == i_ssc_srcfms2movelength));
				end
				else begin
					o_ssc_transfer_pending <= o_ssc_transfer_pending;
				end
			end
			default:begin
				o_ssc_transfer_pending <= 1'b0;
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_ssc_num_of_remain_bytes <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_ssc_en & i_ssc_concateen)begin
					o_ssc_num_of_remain_bytes <= (i_ssc_srcfms1concatelength > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):i_ssc_srcfms1concatelength;
				end
				else if(i_ssc_en)begin
					o_ssc_num_of_remain_bytes <= (i_ssc_srcfmsmovelength > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):i_ssc_srcfmsmovelength;
				end
				else begin
					o_ssc_num_of_remain_bytes <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
				end
			end
			TRANSFER,CONCATETRANSFER:begin
				if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
					o_ssc_num_of_remain_bytes <= num_of_remain_bytes_next;
				end
				else begin
					o_ssc_num_of_remain_bytes <= o_ssc_num_of_remain_bytes;
				end
			end
			default:begin
				o_ssc_num_of_remain_bytes <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_ssc_concate_fms_switch_flag <= 1'b0;
	end
	else begin
		case(cur_state)
			IDLE:begin
				o_ssc_concate_fms_switch_flag <= 1'b0;
			end
			TRANSFER:begin
				o_ssc_concate_fms_switch_flag <= 1'b0;
			end
			CONCATETRANSFER:begin
				if(i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone)begin
					o_ssc_concate_fms_switch_flag <= concate_fms_switch_next;
				end
				else begin
					o_ssc_concate_fms_switch_flag <= o_ssc_concate_fms_switch_flag;
				end
			end
			default:begin
				o_ssc_concate_fms_switch_flag <= 1'b0;
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_ssc_ready <= 1'b1;
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_ssc_en & i_ssc_concateen)begin
					o_ssc_ready <= 1'b0;
				end
				else if(i_ssc_en)begin
					o_ssc_ready <= 1'b0;
				end
				else begin
					o_ssc_ready <= 1'b1;
				end
			end
			TRANSFER:begin
				if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
					o_ssc_ready <= 1'b1;
				end
				else begin
					o_ssc_ready <= 1'b0;
				end
			end
			CONCATETRANSFER:begin
				if(~o_ssc_transfer_pending && (i_ssc_sdp_outputsectiondone || i_ssc_sdp_parallelinoutsectiondone))begin
					o_ssc_ready <= 1'b1;	
				end
				else begin
					o_ssc_ready <= 1'b0;
				end
			end
			default:begin
				o_ssc_ready <= 1'b1;
			end
		endcase
	end
end

assign o_ssc_sigmnt1 = {clk,o_ssc_transfer_pending,o_ssc_transfer_done,o_ssc_num_of_remain_bytes};
assign o_ssc_sigmnt2 = {clk,6'd0,o_ssc_concate_fms_switch_flag,cur_state};
//------------------------------------------------------------------------------

endmodule
