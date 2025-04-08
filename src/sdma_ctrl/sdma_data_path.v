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
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
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
	output										o_sdp_parallelinout_empty,
	output [9:0]								o_sdp_sigmnt1
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
wire [`SDMA_CACHEDATAWIDTH-1:0]			 data_buffer_assemble;
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
wire [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] din_strb_num;
wire [`SDMA_CACHEDATAWIDTH-1:0]			 dout_next_ldany;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]		 din_strb_shifted;
wire [`SDMA_SECTION_DINNUMDATAWIDTH+2:0] din_cnt_bit;			 
wire [`SDMA_CACHEDATAWIDTH-1:0]			 din_shifted;
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

assign din_strb_num = i_sdp_din_strb[0] + i_sdp_din_strb[1] + i_sdp_din_strb[2] + i_sdp_din_strb[3] + i_sdp_din_strb[4] + i_sdp_din_strb[5] + i_sdp_din_strb[6] + i_sdp_din_strb[7] + i_sdp_din_strb[8] + i_sdp_din_strb[9] + i_sdp_din_strb[10] + i_sdp_din_strb[11] + i_sdp_din_strb[12] + i_sdp_din_strb[13] + i_sdp_din_strb[14] + i_sdp_din_strb[15] + i_sdp_din_strb[16] + i_sdp_din_strb[17] + i_sdp_din_strb[18] + i_sdp_din_strb[19] + i_sdp_din_strb[20] + i_sdp_din_strb[21] + i_sdp_din_strb[22] + i_sdp_din_strb[23] + i_sdp_din_strb[24] + i_sdp_din_strb[25] + i_sdp_din_strb[26] + i_sdp_din_strb[27] + i_sdp_din_strb[28] + i_sdp_din_strb[29] + i_sdp_din_strb[30] + i_sdp_din_strb[31] + i_sdp_din_strb[32] + i_sdp_din_strb[33] + i_sdp_din_strb[34] + i_sdp_din_strb[35] + i_sdp_din_strb[36] + i_sdp_din_strb[37] + i_sdp_din_strb[38] + i_sdp_din_strb[39] + i_sdp_din_strb[40] + i_sdp_din_strb[41] + i_sdp_din_strb[42] + i_sdp_din_strb[43] + i_sdp_din_strb[44] + i_sdp_din_strb[45] + i_sdp_din_strb[46] + i_sdp_din_strb[47] + i_sdp_din_strb[48] + i_sdp_din_strb[49] + i_sdp_din_strb[50] + i_sdp_din_strb[51] + i_sdp_din_strb[52] + i_sdp_din_strb[53] + i_sdp_din_strb[54] + i_sdp_din_strb[55] + i_sdp_din_strb[56] + i_sdp_din_strb[57] + i_sdp_din_strb[58] + i_sdp_din_strb[59] + i_sdp_din_strb[60] + i_sdp_din_strb[61] + i_sdp_din_strb[62] + i_sdp_din_strb[63];

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

assign din_cnt_bit = din_cnt << 3;
assign din_shifted = (i_sdp_din << din_cnt_bit);
assign din_strb_shifted = (i_sdp_din_strb << din_cnt);

integer j;
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		for(j = 0;j < `SDMA_CACHEDATAWIDTH/8;j = j+1)begin
			data_buffer[j] <= 8'd0;
		end
	end
	else begin
		if((cur_state == INPUTDATA) || (cur_state == PARALLELINOUT) && din_ready_r)begin
			data_buffer[0] <= din_strb_shifted[0]?din_shifted[7:0]:data_buffer[0];
			data_buffer[1] <= din_strb_shifted[1]?din_shifted[15:8]:data_buffer[1];
			data_buffer[2] <= din_strb_shifted[2]?din_shifted[23:16]:data_buffer[2];
			data_buffer[3] <= din_strb_shifted[3]?din_shifted[31:24]:data_buffer[3];
			data_buffer[4] <= din_strb_shifted[4]?din_shifted[39:32]:data_buffer[4];
			data_buffer[5] <= din_strb_shifted[5]?din_shifted[47:40]:data_buffer[5];
			data_buffer[6] <= din_strb_shifted[6]?din_shifted[55:48]:data_buffer[6];
			data_buffer[7] <= din_strb_shifted[7]?din_shifted[63:56]:data_buffer[7];
			data_buffer[8] <= din_strb_shifted[8]?din_shifted[71:64]:data_buffer[8];
			data_buffer[9] <= din_strb_shifted[9]?din_shifted[79:72]:data_buffer[9];
			data_buffer[10] <= din_strb_shifted[10]?din_shifted[87:80]:data_buffer[10];
			data_buffer[11] <= din_strb_shifted[11]?din_shifted[95:88]:data_buffer[11];
			data_buffer[12] <= din_strb_shifted[12]?din_shifted[103:96]:data_buffer[12];
			data_buffer[13] <= din_strb_shifted[13]?din_shifted[111:104]:data_buffer[13];
			data_buffer[14] <= din_strb_shifted[14]?din_shifted[119:112]:data_buffer[14];
			data_buffer[15] <= din_strb_shifted[15]?din_shifted[127:120]:data_buffer[15];
			data_buffer[16] <= din_strb_shifted[16]?din_shifted[135:128]:data_buffer[16];
			data_buffer[17] <= din_strb_shifted[17]?din_shifted[143:136]:data_buffer[17];
			data_buffer[18] <= din_strb_shifted[18]?din_shifted[151:144]:data_buffer[18];
			data_buffer[19] <= din_strb_shifted[19]?din_shifted[159:152]:data_buffer[19];
			data_buffer[20] <= din_strb_shifted[20]?din_shifted[167:160]:data_buffer[20];
			data_buffer[21] <= din_strb_shifted[21]?din_shifted[175:168]:data_buffer[21];
			data_buffer[22] <= din_strb_shifted[22]?din_shifted[183:176]:data_buffer[22];
			data_buffer[23] <= din_strb_shifted[23]?din_shifted[191:184]:data_buffer[23];
			data_buffer[24] <= din_strb_shifted[24]?din_shifted[199:192]:data_buffer[24];
			data_buffer[25] <= din_strb_shifted[25]?din_shifted[207:200]:data_buffer[25];
			data_buffer[26] <= din_strb_shifted[26]?din_shifted[215:208]:data_buffer[26];
			data_buffer[27] <= din_strb_shifted[27]?din_shifted[223:216]:data_buffer[27];
			data_buffer[28] <= din_strb_shifted[28]?din_shifted[231:224]:data_buffer[28];
			data_buffer[29] <= din_strb_shifted[29]?din_shifted[239:232]:data_buffer[29];
			data_buffer[30] <= din_strb_shifted[30]?din_shifted[247:240]:data_buffer[30];
			data_buffer[31] <= din_strb_shifted[31]?din_shifted[255:248]:data_buffer[31];
			data_buffer[32] <= din_strb_shifted[32]?din_shifted[263:256]:data_buffer[32];
			data_buffer[33] <= din_strb_shifted[33]?din_shifted[271:264]:data_buffer[33];
			data_buffer[34] <= din_strb_shifted[34]?din_shifted[279:272]:data_buffer[34];
			data_buffer[35] <= din_strb_shifted[35]?din_shifted[287:280]:data_buffer[35];
			data_buffer[36] <= din_strb_shifted[36]?din_shifted[295:288]:data_buffer[36];
			data_buffer[37] <= din_strb_shifted[37]?din_shifted[303:296]:data_buffer[37];
			data_buffer[38] <= din_strb_shifted[38]?din_shifted[311:304]:data_buffer[38];
			data_buffer[39] <= din_strb_shifted[39]?din_shifted[319:312]:data_buffer[39];
			data_buffer[40] <= din_strb_shifted[40]?din_shifted[327:320]:data_buffer[40];
			data_buffer[41] <= din_strb_shifted[41]?din_shifted[335:328]:data_buffer[41];
			data_buffer[42] <= din_strb_shifted[42]?din_shifted[343:336]:data_buffer[42];
			data_buffer[43] <= din_strb_shifted[43]?din_shifted[351:344]:data_buffer[43];
			data_buffer[44] <= din_strb_shifted[44]?din_shifted[359:352]:data_buffer[44];
			data_buffer[45] <= din_strb_shifted[45]?din_shifted[367:360]:data_buffer[45];
			data_buffer[46] <= din_strb_shifted[46]?din_shifted[375:368]:data_buffer[46];
			data_buffer[47] <= din_strb_shifted[47]?din_shifted[383:376]:data_buffer[47];
			data_buffer[48] <= din_strb_shifted[48]?din_shifted[391:384]:data_buffer[48];
			data_buffer[49] <= din_strb_shifted[49]?din_shifted[399:392]:data_buffer[49];
			data_buffer[50] <= din_strb_shifted[50]?din_shifted[407:400]:data_buffer[50];
			data_buffer[51] <= din_strb_shifted[51]?din_shifted[415:408]:data_buffer[51];
			data_buffer[52] <= din_strb_shifted[52]?din_shifted[423:416]:data_buffer[52];
			data_buffer[53] <= din_strb_shifted[53]?din_shifted[431:424]:data_buffer[53];
			data_buffer[54] <= din_strb_shifted[54]?din_shifted[439:432]:data_buffer[54];
			data_buffer[55] <= din_strb_shifted[55]?din_shifted[447:440]:data_buffer[55];
			data_buffer[56] <= din_strb_shifted[56]?din_shifted[455:448]:data_buffer[56];
			data_buffer[57] <= din_strb_shifted[57]?din_shifted[463:456]:data_buffer[57];
			data_buffer[58] <= din_strb_shifted[58]?din_shifted[471:464]:data_buffer[58];
			data_buffer[59] <= din_strb_shifted[59]?din_shifted[479:472]:data_buffer[59];
			data_buffer[60] <= din_strb_shifted[60]?din_shifted[487:480]:data_buffer[60];
			data_buffer[61] <= din_strb_shifted[61]?din_shifted[495:488]:data_buffer[61];
			data_buffer[62] <= din_strb_shifted[62]?din_shifted[503:496]:data_buffer[62];
			data_buffer[63] <= din_strb_shifted[63]?din_shifted[511:504]:data_buffer[63];
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

assign data_buffer_assemble = {
    data_buffer[63], data_buffer[62], data_buffer[61], data_buffer[60],
    data_buffer[59], data_buffer[58], data_buffer[57], data_buffer[56],
    data_buffer[55], data_buffer[54], data_buffer[53], data_buffer[52],
    data_buffer[51], data_buffer[50], data_buffer[49], data_buffer[48],
    data_buffer[47], data_buffer[46], data_buffer[45], data_buffer[44],
    data_buffer[43], data_buffer[42], data_buffer[41], data_buffer[40],
    data_buffer[39], data_buffer[38], data_buffer[37], data_buffer[36],
    data_buffer[35], data_buffer[34], data_buffer[33], data_buffer[32],
    data_buffer[31], data_buffer[30], data_buffer[29], data_buffer[28],
    data_buffer[27], data_buffer[26], data_buffer[25], data_buffer[24],
    data_buffer[23], data_buffer[22], data_buffer[21], data_buffer[20],
    data_buffer[19], data_buffer[18], data_buffer[17], data_buffer[16],
    data_buffer[15], data_buffer[14], data_buffer[13], data_buffer[12],
    data_buffer[11], data_buffer[10], data_buffer[9],  data_buffer[8],
    data_buffer[7],  data_buffer[6],  data_buffer[5],  data_buffer[4],
    data_buffer[3],  data_buffer[2],  data_buffer[1],  data_buffer[0]
};
//----------------------------------------------------------------------------------------------------------

//----------------------------------SUBMODULE INSTANCE------------------------------------------------------

sdma_sdp_lddata U_SDMA_SDP_LDDATA_0(
  .i_sdp_l_doutcnt    (dout_cnt),
  .i_sdp_l_databuffer (data_buffer_assemble),
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
assign o_sdp_sigmnt1					= 	{clk,2'd0,cur_state,o_sdp_parallelinout_empty,o_sdp_parallelinout_section_done,o_sdp_output_section_done,o_sdp_input_section_done};
//----------------------------------------------------------------------------------------------------------


endmodule
