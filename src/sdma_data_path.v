// -----------------------------------------------------------------------------
// FILE NAME : sdma_data_path.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-10
// -----------------------------------------------------------------------------
// DESCRIPTION : Store data from src port and load data to dst port. Support multiple 
// valid datawidth(8b/32b/512b) mode to accommodate different ports.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/sdma_params.vh"
module sdma_data_path
(
	input										clk,
	input										rst_n,
	input										i_sdp_en,
	//i_sdp_transfer_pending maintains high if the current section is not the last section(transfer complete).
	input										i_sdp_transfer_pending,
	//i_sdp_num_of_remain_bytes indicate the transfer bytes number of the current section.
	input  [`SDMA_SECTION_DINNUMDATAWIDTH-1:0]	i_sdp_num_of_remain_bytes,
	//i_sdp_mode do not change during transfer. 
	input  [2:0]								i_sdp_mode,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdp_din_strb,
	input										i_sdp_din_vld,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdp_din,
	input										i_sdp_dout_ready,
	//i_sdp_dout_ldb_num is driven by sdma_addr_path. It indicates the bytes number to load from data_buffer.
	input  [`SDMA_SECTION_DINNUMDATAWIDTH-1:0]  i_sdp_dout_ldb_num,
	//i_sdp_paddingflag is driven by sdma_addr_path. When padding happens, it maintains high level and o_sdp_dout maintains 0.
	input										i_sdp_paddingflag,
	//i_sdp_upsampleflag is driven by sdma_addr_path. When upsample happens, it maintains high level and o_sdp_dout maintains 0.
	input										i_sdp_upsampleflag,
	output										o_sdp_din_ready,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdp_dout,
	//o_sdp_input_section_done generate a pulse when the input process of current section is done.
	output										o_sdp_input_section_done,
	//o_sdp_output_section_done generate a pulse when the output process of current section is done.
	output										o_sdp_output_section_done,
	//o_sdp_parallelinout_section_done generate a pulse when the current parallelinout(AHB2CACHENONSEQ) section is done.
	output										o_sdp_parallelinout_section_done,
	//o_sdp_parallelinout_empty maintains high level when the state is PARALLELINOUT and data_buffer is empty.
	output										o_sdp_parallelinout_empty
);

//----------------------------------STATE-------------------------------------------------------------------
localparam [2:0] IDLE 			= 3'b000; 
localparam [2:0] INPUTDATA 		= 3'b001;
localparam [2:0] PARALLELINOUT 	= 3'b010;
localparam [2:0] OUTPUTDATA		= 3'b100;

//----------------------------------------------------------------------------------------------------------

//----------------------------------VARIABLES---------------------------------------------------------------
reg	 [2:0]							 	 cur_state;
reg	 [2:0]							 	 next_state;
reg	 [7:0]							 	 data_buffer 	 [0:`SDMA_CACHEDATAWIDTH/8-1];//data buffer to store data from source port
reg	 [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] din_num;
reg	 [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] din_cnt;									//data input can be 32b or 512b valid/write
reg	 [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] dout_num;	
reg	 [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] dout_cnt;									//data output can be 8b or 32b or 512b valid/read
reg										 input_section_done;
wire									 parallelinout_empty;
wire									 parallelinout_section_done;
wire									 output_section_done;
reg	 [`SDMA_CACHEDATAWIDTH-1:0]		 	 dout_r;
reg										 din_ready_r;
reg	 [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] din_strb_num;
reg	 [`SDMA_CACHEDATAWIDTH-1:0]			 dout_next_ldany;

//----------------------------------------------------------------------------------------------------------

//----------------------------------STATE TRANSFER----------------------------------------------------------
//SDMA_SDP_MODE consists of the src port type, dst port type and whether transpose happens(NONSEQ corresponds to
//transpose happens). After analysis, we assume that only in AHB2CACHENONSEQ case the output process and the input
//process overlap.

always@(*)begin
	case(cur_state)
		IDLE:begin
			if(i_sdp_en && i_sdp_mode == `SDMA_SDP_MODE_AHB2CACHENONSEQ)
				next_state = PARALLELINOUT;
			else if(i_sdp_en)
				next_state = INPUTDATA;
			else
				next_state = IDLE;
		end
		INPUTDATA:begin
			if(input_section_done)
				next_state = OUTPUTDATA;
			else
				next_state = INPUTDATA;
		end
		PARALLELINOUT:begin //only for MODE_AHB2CACHENONSEQ case
			if(parallelinout_section_done && ~i_sdp_transfer_pending)
				next_state = IDLE;
			else
				next_state = PARALLELINOUT;
		end
		OUTPUTDATA:begin
			if(output_section_done && i_sdp_transfer_pending)
				next_state = INPUTDATA;
			else if(output_section_done)
				next_state = IDLE;
			else
				next_state = OUTPUTDATA;
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
//----------------------------------------------------------------------------------------------------------

//----------------------------------REGISTER VALUE LOGIC----------------------------------------------------
integer i;
always@(*)begin
	din_strb_num = 0;
	for(i = 0; i < `SDMA_CACHEDATAWIDTH/8; i = i+1)begin
		din_strb_num = din_strb_num + i_sdp_din_strb[i];
	end
end

always@(*)begin
	if(cur_state == IDLE)begin
		if(i_sdp_en)begin
			din_num		= 	i_sdp_num_of_remain_bytes;
			dout_num	= 	i_sdp_num_of_remain_bytes;
		end
		else begin
			din_num		=	{`SDMA_SECTION_DINNUMDATAWIDTH{1'b0}};
			dout_num	= 	{`SDMA_SECTION_DINNUMDATAWIDTH{1'b0}};
		end
	end
	else begin
		din_num		= 	i_sdp_num_of_remain_bytes;
		dout_num	= 	i_sdp_num_of_remain_bytes;
	end
end


always@(*)begin
	if(cur_state == INPUTDATA)begin
		input_section_done = i_sdp_din_vld?(din_cnt + din_strb_num == din_num):1'b0;
	end
	else begin
		input_section_done = 1'b0;
	end
end


always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		din_cnt	<=	{(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
	else begin
		if((cur_state == INPUTDATA && ~input_section_done) || (cur_state == PARALLELINOUT && ~parallelinout_section_done))begin
			din_cnt	<=	(i_sdp_din_vld & din_ready_r)?(din_cnt + din_strb_num):din_cnt;
		end
		else begin
			din_cnt	<=	{(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
		end
	end
end

integer j;
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		for(j = 0;j < `SDMA_CACHEDATAWIDTH/8;j = j+1)begin
			data_buffer[j] <= 8'd0;
		end
	end
	else begin
		if((cur_state == INPUTDATA) || (cur_state == PARALLELINOUT))begin
			if(din_ready_r & i_sdp_din_strb[0]) data_buffer[din_cnt + 6'd0] <= i_sdp_din[7:0];
			if(din_ready_r & i_sdp_din_strb[1]) data_buffer[din_cnt + 6'd1] <= i_sdp_din[15:8];
			if(din_ready_r & i_sdp_din_strb[2]) data_buffer[din_cnt + 6'd2] <= i_sdp_din[23:16];
			if(din_ready_r & i_sdp_din_strb[3]) data_buffer[din_cnt + 6'd3] <= i_sdp_din[31:24];
			if(din_ready_r & i_sdp_din_strb[4]) data_buffer[din_cnt + 6'd4] <= i_sdp_din[39:32];
			if(din_ready_r & i_sdp_din_strb[5]) data_buffer[din_cnt + 6'd5] <= i_sdp_din[47:40];
			if(din_ready_r & i_sdp_din_strb[6]) data_buffer[din_cnt + 6'd6] <= i_sdp_din[55:48];
			if(din_ready_r & i_sdp_din_strb[7]) data_buffer[din_cnt + 6'd7] <= i_sdp_din[63:56];
			if(din_ready_r & i_sdp_din_strb[8]) data_buffer[din_cnt + 6'd8] <= i_sdp_din[71:64];
			if(din_ready_r & i_sdp_din_strb[9]) data_buffer[din_cnt + 6'd9] <= i_sdp_din[79:72];
			if(din_ready_r & i_sdp_din_strb[10]) data_buffer[din_cnt + 6'd10] <= i_sdp_din[87:80];
			if(din_ready_r & i_sdp_din_strb[11]) data_buffer[din_cnt + 6'd11] <= i_sdp_din[95:88];
			if(din_ready_r & i_sdp_din_strb[12]) data_buffer[din_cnt + 6'd12] <= i_sdp_din[103:96];
			if(din_ready_r & i_sdp_din_strb[13]) data_buffer[din_cnt + 6'd13] <= i_sdp_din[111:104];
			if(din_ready_r & i_sdp_din_strb[14]) data_buffer[din_cnt + 6'd14] <= i_sdp_din[119:112];
			if(din_ready_r & i_sdp_din_strb[15]) data_buffer[din_cnt + 6'd15] <= i_sdp_din[127:120];
			if(din_ready_r & i_sdp_din_strb[16]) data_buffer[din_cnt + 6'd16] <= i_sdp_din[135:128];
			if(din_ready_r & i_sdp_din_strb[17]) data_buffer[din_cnt + 6'd17] <= i_sdp_din[143:136];
			if(din_ready_r & i_sdp_din_strb[18]) data_buffer[din_cnt + 6'd18] <= i_sdp_din[151:144];
			if(din_ready_r & i_sdp_din_strb[19]) data_buffer[din_cnt + 6'd19] <= i_sdp_din[159:152];
			if(din_ready_r & i_sdp_din_strb[20]) data_buffer[din_cnt + 6'd20] <= i_sdp_din[167:160];
			if(din_ready_r & i_sdp_din_strb[21]) data_buffer[din_cnt + 6'd21] <= i_sdp_din[175:168];
			if(din_ready_r & i_sdp_din_strb[22]) data_buffer[din_cnt + 6'd22] <= i_sdp_din[183:176];
			if(din_ready_r & i_sdp_din_strb[23]) data_buffer[din_cnt + 6'd23] <= i_sdp_din[191:184];
			if(din_ready_r & i_sdp_din_strb[24]) data_buffer[din_cnt + 6'd24] <= i_sdp_din[199:192];
			if(din_ready_r & i_sdp_din_strb[25]) data_buffer[din_cnt + 6'd25] <= i_sdp_din[207:200];
			if(din_ready_r & i_sdp_din_strb[26]) data_buffer[din_cnt + 6'd26] <= i_sdp_din[215:208];
			if(din_ready_r & i_sdp_din_strb[27]) data_buffer[din_cnt + 6'd27] <= i_sdp_din[223:216];
			if(din_ready_r & i_sdp_din_strb[28]) data_buffer[din_cnt + 6'd28] <= i_sdp_din[231:224];
			if(din_ready_r & i_sdp_din_strb[29]) data_buffer[din_cnt + 6'd29] <= i_sdp_din[239:232];
			if(din_ready_r & i_sdp_din_strb[30]) data_buffer[din_cnt + 6'd30] <= i_sdp_din[247:240];
			if(din_ready_r & i_sdp_din_strb[31]) data_buffer[din_cnt + 6'd31] <= i_sdp_din[255:248];
			if(din_ready_r & i_sdp_din_strb[32]) data_buffer[din_cnt + 6'd32] <= i_sdp_din[263:256];
			if(din_ready_r & i_sdp_din_strb[33]) data_buffer[din_cnt + 6'd33] <= i_sdp_din[271:264];
			if(din_ready_r & i_sdp_din_strb[34]) data_buffer[din_cnt + 6'd34] <= i_sdp_din[279:272];
			if(din_ready_r & i_sdp_din_strb[35]) data_buffer[din_cnt + 6'd35] <= i_sdp_din[287:280];
			if(din_ready_r & i_sdp_din_strb[36]) data_buffer[din_cnt + 6'd36] <= i_sdp_din[295:288];
			if(din_ready_r & i_sdp_din_strb[37]) data_buffer[din_cnt + 6'd37] <= i_sdp_din[303:296];
			if(din_ready_r & i_sdp_din_strb[38]) data_buffer[din_cnt + 6'd38] <= i_sdp_din[311:304];
			if(din_ready_r & i_sdp_din_strb[39]) data_buffer[din_cnt + 6'd39] <= i_sdp_din[319:312];
			if(din_ready_r & i_sdp_din_strb[40]) data_buffer[din_cnt + 6'd40] <= i_sdp_din[327:320];
			if(din_ready_r & i_sdp_din_strb[41]) data_buffer[din_cnt + 6'd41] <= i_sdp_din[335:328];
			if(din_ready_r & i_sdp_din_strb[42]) data_buffer[din_cnt + 6'd42] <= i_sdp_din[343:336];
			if(din_ready_r & i_sdp_din_strb[43]) data_buffer[din_cnt + 6'd43] <= i_sdp_din[351:344];
			if(din_ready_r & i_sdp_din_strb[44]) data_buffer[din_cnt + 6'd44] <= i_sdp_din[359:352];
			if(din_ready_r & i_sdp_din_strb[45]) data_buffer[din_cnt + 6'd45] <= i_sdp_din[367:360];
			if(din_ready_r & i_sdp_din_strb[46]) data_buffer[din_cnt + 6'd46] <= i_sdp_din[375:368];
			if(din_ready_r & i_sdp_din_strb[47]) data_buffer[din_cnt + 6'd47] <= i_sdp_din[383:376];
			if(din_ready_r & i_sdp_din_strb[48]) data_buffer[din_cnt + 6'd48] <= i_sdp_din[391:384];
			if(din_ready_r & i_sdp_din_strb[49]) data_buffer[din_cnt + 6'd49] <= i_sdp_din[399:392];
			if(din_ready_r & i_sdp_din_strb[50]) data_buffer[din_cnt + 6'd50] <= i_sdp_din[407:400];
			if(din_ready_r & i_sdp_din_strb[51]) data_buffer[din_cnt + 6'd51] <= i_sdp_din[415:408];
			if(din_ready_r & i_sdp_din_strb[52]) data_buffer[din_cnt + 6'd52] <= i_sdp_din[423:416];
			if(din_ready_r & i_sdp_din_strb[53]) data_buffer[din_cnt + 6'd53] <= i_sdp_din[431:424];
			if(din_ready_r & i_sdp_din_strb[54]) data_buffer[din_cnt + 6'd54] <= i_sdp_din[439:432];
			if(din_ready_r & i_sdp_din_strb[55]) data_buffer[din_cnt + 6'd55] <= i_sdp_din[447:440];
			if(din_ready_r & i_sdp_din_strb[56]) data_buffer[din_cnt + 6'd56] <= i_sdp_din[455:448];
			if(din_ready_r & i_sdp_din_strb[57]) data_buffer[din_cnt + 6'd57] <= i_sdp_din[463:456];
			if(din_ready_r & i_sdp_din_strb[58]) data_buffer[din_cnt + 6'd58] <= i_sdp_din[471:464];
			if(din_ready_r & i_sdp_din_strb[59]) data_buffer[din_cnt + 6'd59] <= i_sdp_din[479:472];
			if(din_ready_r & i_sdp_din_strb[60]) data_buffer[din_cnt + 6'd60] <= i_sdp_din[487:480];
			if(din_ready_r & i_sdp_din_strb[61]) data_buffer[din_cnt + 6'd61] <= i_sdp_din[495:488];
			if(din_ready_r & i_sdp_din_strb[62]) data_buffer[din_cnt + 6'd62] <= i_sdp_din[503:496];
			if(din_ready_r & i_sdp_din_strb[63]) data_buffer[din_cnt + 6'd63] <= i_sdp_din[511:504];
		end
		else begin
			for(j = 0;j < `SDMA_CACHEDATAWIDTH/8;j = j+1)begin
				data_buffer[j] <= data_buffer[j];
			end	
		end
	end
end

assign output_section_done = (cur_state == OUTPUTDATA) && (dout_cnt == dout_num) && i_sdp_dout_ready && ~(i_sdp_paddingflag);

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		dout_cnt <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
	else begin
		if((cur_state == OUTPUTDATA && ~output_section_done) || (cur_state == PARALLELINOUT && ~parallelinout_section_done))begin
			dout_cnt <= (i_sdp_dout_ready & ~(i_sdp_paddingflag || i_sdp_upsampleflag))?{dout_cnt + i_sdp_dout_ldb_num}:dout_cnt;
		end
		else begin
			dout_cnt <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
		end
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		dout_r <= {(`SDMA_CACHEDATAWIDTH){1'b0}};		
	end
	else begin
		if((cur_state == OUTPUTDATA && ~output_section_done) || (cur_state == PARALLELINOUT && ~parallelinout_section_done))begin
			dout_r <= (~(i_sdp_paddingflag || i_sdp_upsampleflag))?dout_next_ldany:{(`SDMA_CACHEDATAWIDTH){1'b0}};
		end
		else begin
			dout_r <= {`SDMA_CACHEDATAWIDTH{1'b0}};
		end
	end
end


assign 	parallelinout_empty		   = (cur_state == PARALLELINOUT) && (dout_cnt == din_cnt)  && ~parallelinout_section_done;
assign	parallelinout_section_done = (cur_state == PARALLELINOUT) && (dout_cnt == dout_num) && i_sdp_dout_ready && (~i_sdp_paddingflag);

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		din_ready_r <= 1'b0;
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_sdp_en)begin
					din_ready_r <= 1'b1;
				end
				else begin
					din_ready_r	<= 1'b0;
				end
			end
			INPUTDATA:begin
				if(input_section_done)begin
					din_ready_r <= 1'b0;
				end
				else begin
					din_ready_r <= 1'b1;
				end
			end
			PARALLELINOUT:begin
				if(parallelinout_section_done)begin
					din_ready_r <= 1'b0;
				end
				else begin
					din_ready_r <= 1'b1;
				end
			end
			OUTPUTDATA:begin
				if(output_section_done && i_sdp_transfer_pending)begin
					din_ready_r <= 1'b1;
				end
				else if(output_section_done)begin
					din_ready_r <= 1'b0;
				end
				else begin
					din_ready_r <= 1'b0;
				end
			end
			default:begin
				din_ready_r <= 1'b0;
			end
		endcase
	end
end
//----------------------------------------------------------------------------------------------------------

//----------------------------------SUBMODULE INSTANCE------------------------------------------------------

sdma_sdp_lddata U_SDMA_SDP_LDDATA_0(
  .i_sdp_l_doutcnt    (dout_cnt),
  .i_sdp_l_databuffer (data_buffer),
  .i_sdp_l_ldbnum     (i_sdp_dout_ldb_num),
  .o_sdp_l_lddataany  (dout_next_ldany)
);
//----------------------------------------------------------------------------------------------------------

//----------------------------------OUTPUT LOGIC------------------------------------------------------------
assign o_sdp_dout 				 	 	= 	dout_r;
assign o_sdp_din_ready			 	 	=	din_ready_r;
assign o_sdp_input_section_done	 	 	=   input_section_done;
assign o_sdp_output_section_done 	 	= 	output_section_done;
assign o_sdp_parallelinout_section_done =	parallelinout_section_done;
assign o_sdp_parallelinout_empty		=	parallelinout_empty;
//----------------------------------------------------------------------------------------------------------


endmodule
