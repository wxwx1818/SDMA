// -----------------------------------------------------------------------------
// FILE NAME : sdma_addr_path.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-15
// -----------------------------------------------------------------------------
// DESCRIPTION : Generate raddr of sport ,waddr of dport and some control signals.  
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_addr_path
(
	input												clk,
	input												rst_n,
	input												i_sap_en,
	input												i_sap_transfer_pending,
	input  	[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]			i_sap_num_of_remain_bytes,
	//i_sap_concate_fms_switch_flag: low level indicates transfer of fms1;high level indicates transfer of fms2. 
	input												i_sap_concate_fms_switch_flag,
	input  	[2:0]										i_sap_sdpmode,
	//i_sap_sdpmode[5:0]: [5]Move [4]Concate [3]Transpose [2]Padding [1]Upsamle [0]Crop
	input  	[`SDMA_INST_SDMAMODEWIDTH - 1:0]  			i_sap_sdmamode,
	//The following signals are parsed from instruction.
	input  	[`SDMA_INST_SRCFMSADDRWIDTH - 1:0]  		i_sap_srcfmsaddr,
	input  	[`SDMA_INST_DSTFMSADDRWIDTH - 1:0]  		i_sap_dstfmsaddr,
	input  	[`SDMA_INST_SRCFMS2ADDRWIDTH - 1:0]  		i_sap_srcfms2addr,
	input  	[`SDMA_INST_SRCFMSCWIDTH - 1:0]  			i_sap_srcfmsc,
	input  	[`SDMA_INST_SRCFMSXWIDTH - 1:0]  			i_sap_srcfmsx,
	input  	[`SDMA_INST_SRCFMSYWIDTH - 1:0]  			i_sap_srcfmsy,
	input  	[`SDMA_INST_DSTFMSSTRIDE3WIDTH - 1:0]  		i_sap_dstfmsstride3,
	input  	[`SDMA_INST_DSTFMSSTRIDE2WIDTH - 1:0]  		i_sap_dstfmsstride2,
	input  	[`SDMA_INST_DSTFMSSTRIDE1WIDTH - 1:0]  		i_sap_dstfmsstride1,
	input	[`SDMA_INST_PADDINGAXISBEFOREWIDTH - 1:0]	i_sap_paddingaxisbefore,
	input  	[`SDMA_INST_PADDINGLEFTXWIDTH - 1:0]  		i_sap_paddingleftx,
	input  	[`SDMA_INST_PADDINGRIGHTXWIDTH - 1:0]  		i_sap_paddingrightx,
	input  	[`SDMA_INST_PADDINGLEFTYWIDTH - 1:0]  		i_sap_paddinglefty,
	input  	[`SDMA_INST_PADDINGRIGHTYWIDTH - 1:0]  		i_sap_paddingrighty,
	input  	[`SDMA_INST_INSERTZERONUMWIDTH - 1:0]  		i_sap_insertzeronum,
	input  	[`SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1:0] i_sap_insertzeronumtotalx,
	input  	[`SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1:0] i_sap_insertzeronumtotaly,
	input	[`SDMA_INST_UPSAMPLEIDXXWIDTH - 1:0]		i_sap_upsampleidxx,
	input	[`SDMA_INST_UPSAMPLEIDXYWIDTH - 1:0]		i_sap_upsampleidxy,
	input	[`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0]		i_sap_cropfmsstride2,
	input  	[`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0]  	i_sap_cropfmsstride1,
	input  	[`SDMA_INST_CROPFMSCWIDTH - 1:0]  			i_sap_cropfmsc,
	input  	[`SDMA_INST_CROPFMSXWIDTH - 1:0]  			i_sap_cropfmsx,
	input  	[`SDMA_INST_CROPFMSYWIDTH - 1:0]  			i_sap_cropfmsy,
	input	[`SDMA_INST_CROPFMS2STRIDE2WIDTH - 1:0]		i_sap_cropfms2stride2,
	input  	[`SDMA_INST_CROPFMS2STRIDE1WIDTH - 1:0]  	i_sap_cropfms2stride1,
	input  	[`SDMA_INST_CROPFMSCWIDTH - 1:0]  			i_sap_cropfms2c,
	input  	[`SDMA_INST_CROPFMSXWIDTH - 1:0]  			i_sap_cropfms2x,
	input  	[`SDMA_INST_CROPFMSYWIDTH - 1:0]  			i_sap_cropfms2y,
	//The above signals are parsed from instruction.
	input												i_sap_sdp_ready,
	input												i_sap_sdp_inputsectiondone,
	input												i_sap_sdp_outputsectiondone,
	input												i_sap_sdp_parallelinoutsectiondone,
	input												i_sap_sdp_parallelinoutempty,
	input												i_sap_sport_ready,
	input												i_sap_dport_ready,
	//o_sap_sdp_ldb_num indicates the bytes number to load from data_buffer.
	output	[`SDMA_SECTION_DINNUMDATAWIDTH - 1:0]		o_sap_sdp_ldb_num,
	output	[`SDMA_CACHEDATAWIDTH/8 - 1:0]				o_sap_sport_ren,
	output  [`SDMA_ADDRWIDTH - 1:0]	 					o_sap_sport_raddr,
	output	[`SDMA_CACHEDATAWIDTH/8 - 1:0]				o_sap_dport_wen,
	output	[`SDMA_ADDRWIDTH - 1:0]						o_sap_dport_waddr,
	//When padding happens, o_sap_padding_flag maintains high level.
	output												o_sap_padding_flag,
	//When upsample happens, o_sap_upsample_flag maintains high level.
	output												o_sap_upsample_flag,
	output [9:0]										o_sap_sigmnt1,
	output [9:0]										o_sap_sigmnt2
);

//----------------------------------STATE---------------------------------------
localparam [3:0] IDLE 			= 4'b0000; 
localparam [3:0] RDATA 			= 4'b0001;
localparam [3:0] PARALLELRW 	= 4'b0010;
localparam [3:0] WDATA			= 4'b0100;
localparam [3:0] BADDRSWITCH	= 4'b1000;

//------------------------------------------------------------------------------

//----------------------------------VARIABLES-----------------------------------
reg		[3:0]							 				cur_state;
reg		[3:0]							 				next_state;
//The following signals are used for rd from sport.
reg		[`SDMA_ADDRWIDTH-1:0]				 			sfms_raddr;
reg														sfms_raddr_inc_flag;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				sport_ren_num;
wire	[`SDMA_CACHEDATAWIDTH/8-1:0]					sport_ren;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				section_r_num;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				section_r_cnt;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				section_w_num;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				section_w_cnt;
reg		[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]			crop_fms_rbaddr1_cnt;      
reg		[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]			crop_fms_rbaddr2_cnt;
reg														crop_fms_inc_stride1_flag; //Indicates when the raddr increse crop_stride1
reg														crop_fms_inc_stride2_flag; //Indicates when the raddr increse crop_stride2
//The following signals are used for concate fms switch.
reg		[`SDMA_ADDRWIDTH-1:0]				 			sfms1_raddr_context;//Save current fms context for next section of this fms.
reg		[`SDMA_ADDRWIDTH-1:0]				 			sfms2_raddr_context;			
reg		[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]			crop_fms1_rbaddr1_cnt_context;
reg		[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]			crop_fms1_rbaddr2_cnt_context;
reg		[`SDMA_INST_CROPFMS2STRIDE1WIDTH-1:0]			crop_fms2_rbaddr1_cnt_context;
reg		[`SDMA_INST_CROPFMS2STRIDE2WIDTH-1:0]			crop_fms2_rbaddr2_cnt_context;
//The following signals are used for wr to dport.
reg		[`SDMA_INST_SRCFMSYWIDTH-1:0]					sfms_y_cnt;
reg		[`SDMA_INST_SRCFMSXWIDTH-1:0]					sfms_x_cnt;
reg		[`SDMA_INST_SRCFMSCWIDTH-1:0]					sfms_c_cnt;
reg		[`SDMA_INST_SRCFMSYWIDTH-1:0]					sfms_y_withpu;			//Take Padding and Upsample into consideration.
reg		[`SDMA_INST_SRCFMSXWIDTH-1:0]					sfms_x_withpu;			
reg		[`SDMA_INST_SRCFMSCWIDTH-1:0]					sfms_c_withpu;
reg														sfms_y_wrap_flag;		//Indicates y the index jump of src fms.
reg														sfms_x_wrap_flag;		//Indicates x the index jump of src fms.
reg														sfms_c_wrap_flag;		//Indicates c the index jump of src fms.
reg		[`SDMA_CACHEDATAWIDTH/8-1:0]					dport_wen;
reg		[`SDMA_ADDRWIDTH-1:0]							dfms_waddr;
reg		[`SDMA_ADDRWIDTH-1:0]							dfms_waddr_r;
reg														dfms_waddr_inc_flag;
reg		[`SDMA_INST_DSTFMSSTRIDE1WIDTH-1:0]				trans_fms_stride1_idx;
reg		[`SDMA_INST_DSTFMSSTRIDE2WIDTH-1:0]				trans_fms_stride2_idx;	
wire	[`SDMA_CACHEDATAWIDTH/8-1:0]					sdp_ldb;
reg		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]				sdp_ldb_num;
reg		[`SDMA_INST_INSERTZERONUMWIDTH-1:0] 			upsample_x_cnt;
reg		[`SDMA_INST_INSERTZERONUMWIDTH-1:0] 			upsample_y_cnt;
wire													padding_flag;
wire													upsample_flag;


//------------------------------------------------------------------------------

//----------------------------------STATE TRANSFER------------------------------
always@(*)begin
	case(cur_state)
		IDLE:begin
			if(i_sap_en && i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHENONSEQ)
				next_state = PARALLELRW;
			else if(i_sap_en)
				next_state = RDATA;
			else
				next_state = IDLE;
		end
		RDATA:begin
			if(i_sap_sdp_inputsectiondone)
				next_state = WDATA;
			else
				next_state = RDATA;
		end
		PARALLELRW:begin //only for MODE_AHB2CACHENONSEQ case
			if(i_sap_sdp_parallelinoutsectiondone && ~i_sap_transfer_pending)
				next_state = IDLE;
			else if(i_sap_sdp_parallelinoutsectiondone && i_sap_transfer_pending && i_sap_sdmamode[4])
				next_state = BADDRSWITCH;
			else
				next_state = PARALLELRW;
		end
		WDATA:begin
			if(i_sap_sdp_outputsectiondone && ~i_sap_transfer_pending)
				next_state = IDLE;
			else if(i_sap_sdp_outputsectiondone && i_sap_transfer_pending && i_sap_sdmamode[4])
				next_state = BADDRSWITCH;
			else if(i_sap_sdp_outputsectiondone && i_sap_transfer_pending)
				next_state = RDATA;
			else
				next_state = WDATA;
		end
		BADDRSWITCH:begin
			next_state = RDATA;
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
always@(*)begin
	if(cur_state == IDLE)begin
		if(i_sap_en)begin
			section_r_num		= 	i_sap_num_of_remain_bytes;
			section_w_num		= 	i_sap_num_of_remain_bytes;
		end
		else begin
			section_r_num		=	{`SDMA_SECTION_DINNUMDATAWIDTH{1'b0}};
			section_w_num		= 	{`SDMA_SECTION_DINNUMDATAWIDTH{1'b0}};
		end
	end
	else begin
		section_r_num		= 	i_sap_num_of_remain_bytes;
		section_w_num		= 	i_sap_num_of_remain_bytes;
	end
end


always@(*)begin
	if(cur_state == RDATA || cur_state == PARALLELRW)begin
		sfms_raddr_inc_flag = i_sap_sport_ready & ~(section_r_cnt == section_r_num);
	end
	else begin
		sfms_raddr_inc_flag = 1'b0;
	end
end

genvar j;
generate
	for(j=0;j<`SDMA_CACHEDATAWIDTH/8;j=j+1)begin:strbgen
		assign sport_ren[j] = (j < sport_ren_num);
	end
endgenerate

always@(*)begin
	if((cur_state == RDATA || cur_state == PARALLELRW) && ~(section_r_cnt == section_r_num))begin
		if(i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHESEQ
		|| i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHENONSEQ
		|| i_sap_sdpmode == `SDMA_SDP_MODE_AHB2AHBSEQ
		|| i_sap_sdpmode == `SDMA_SDP_MODE_AHB2AHBNONSEQ)begin
			if(i_sap_sdmamode[0] && i_sap_concate_fms_switch_flag)begin
			`ifdef HIGH_BANDWIDTH_VERSION
				if(~((sfms_raddr[3]||sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 5'd16 > section_r_num) || (crop_fms_rbaddr1_cnt + 5'd16 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-5){1'b0}},5'd16};
				end
				else if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num) || (crop_fms_rbaddr1_cnt + 4'd8 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
			`ifdef MED_BANDWIDTH_VERSION
				if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num) || (crop_fms_rbaddr1_cnt + 4'd8 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
				if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`endif
			`endif
				else if(~((sfms_raddr[0]) || (section_r_cnt + 2'd2 > section_r_num) || (crop_fms_rbaddr1_cnt + 2'd2 > i_sap_cropfms2c)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'd1};
				end
			end
			else if(i_sap_sdmamode[0])begin
			`ifdef HIGH_BANDWIDTH_VERSION
				if(~((sfms_raddr[3]||sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 5'd16 > section_r_num) || (crop_fms_rbaddr1_cnt + 5'd16 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-5){1'b0}},5'd16};
				end
				else if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num) || (crop_fms_rbaddr1_cnt + 4'd8 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
			`ifdef MED_BANDWIDTH_VERSION
				if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num) || (crop_fms_rbaddr1_cnt + 4'd8 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
				if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd4 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`endif
			`endif
				else if(~((sfms_raddr[0]) || (section_r_cnt + 2'd2 > section_r_num) || (crop_fms_rbaddr1_cnt + 3'd2 > i_sap_cropfmsc)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'd1};
				end
			end
			else begin
			`ifdef HIGH_BANDWIDTH_VERSION
				if(~((sfms_raddr[3]||sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 5'd16 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-5){1'b0}},5'd16};
				end
				else if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end

			`else
			`ifdef MED_BANDWIDTH_VERSION
				if(~((sfms_raddr[2]||sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 4'd8 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
				if(~((sfms_raddr[1]||sfms_raddr[0]) || (section_r_cnt + 3'd4 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`endif
			`endif
				else if(~((sfms_raddr[0]) || (section_r_cnt + 2'd2 > section_r_num)))begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sport_ren_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'd1};
				end	
			end
		end
		else begin
			if(i_sap_sdmamode[0] && i_sap_concate_fms_switch_flag)begin
				if((section_r_num - section_r_cnt)>(i_sap_cropfms2c - crop_fms_rbaddr2_cnt))begin
					sport_ren_num = (i_sap_cropfms2c - crop_fms_rbaddr2_cnt);
				end
				else begin
					sport_ren_num = (section_r_num - section_r_cnt);
				end
			end
			else if(i_sap_sdmamode[0])begin
				if((section_r_num - section_r_cnt)>(i_sap_cropfmsc - crop_fms_rbaddr2_cnt))begin
					sport_ren_num = (i_sap_cropfmsc - crop_fms_rbaddr2_cnt);
				end
				else begin
					sport_ren_num = (section_r_num - section_r_cnt);
				end
			end
			else begin
				if(section_r_cnt == {`SDMA_SECTION_DINNUMDATAWIDTH{1'b0}})begin
					sport_ren_num = section_r_num;
				end
				else begin
					sport_ren_num = {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
				end
			end
		end	
	end
	else begin
		sport_ren_num = {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
end

always@(*)begin
	if((cur_state == RDATA || cur_state == PARALLELRW) && sfms_raddr_inc_flag)begin
		if(i_sap_concate_fms_switch_flag)
			crop_fms_inc_stride2_flag = (crop_fms_inc_stride1_flag && (crop_fms_rbaddr2_cnt + 1'd1 == i_sap_cropfms2x));
		else
			crop_fms_inc_stride2_flag = (crop_fms_inc_stride1_flag && (crop_fms_rbaddr2_cnt + 1'd1 == i_sap_cropfmsx));
	end
	else begin
		crop_fms_inc_stride2_flag = 1'b0;
	end
end

always@(*)begin
	if((cur_state == RDATA || cur_state == PARALLELRW) && sfms_raddr_inc_flag)begin
		if(i_sap_concate_fms_switch_flag)
			crop_fms_inc_stride1_flag = (crop_fms_rbaddr1_cnt + sport_ren_num == i_sap_cropfms2c);
		else
			crop_fms_inc_stride1_flag = (crop_fms_rbaddr1_cnt + sport_ren_num == i_sap_cropfmsc);
	end
	else begin
		crop_fms_inc_stride1_flag = 1'b0;
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		sfms_raddr 	 		 <= {(`SDMA_ADDRWIDTH){1'b0}};
		section_r_cnt 		 <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
		crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
		crop_fms_rbaddr2_cnt <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_sap_en)begin
					sfms_raddr 		 <= i_sap_srcfmsaddr;
				end
				else begin
					sfms_raddr 		 <= {(`SDMA_ADDRWIDTH){1'b0}};
				end
				section_r_cnt 		 <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
				crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
				crop_fms_rbaddr2_cnt <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
			end
			RDATA,PARALLELRW:begin
				if(sfms_raddr_inc_flag)begin
					section_r_cnt	<= section_r_cnt + sport_ren_num;
					if(i_sap_sdmamode[0] && i_sap_concate_fms_switch_flag)begin
						if(crop_fms_inc_stride2_flag)begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num + i_sap_cropfms2stride2;
							crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
							crop_fms_rbaddr2_cnt <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
						end
						else if(crop_fms_inc_stride1_flag)begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num + i_sap_cropfms2stride1;
							crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
							crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt + 1'd1;
						end
						else begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num;
							crop_fms_rbaddr1_cnt <= crop_fms_rbaddr1_cnt + sport_ren_num;
							crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt;
						end
					end
					else if(i_sap_sdmamode[0])begin
						if(crop_fms_inc_stride2_flag)begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num + i_sap_cropfmsstride2;
							crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
							crop_fms_rbaddr2_cnt <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
						end
						else if(crop_fms_inc_stride1_flag)begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num + i_sap_cropfmsstride1;
							crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
							crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt + 1'd1;
						end
						else begin
							sfms_raddr			 <= sfms_raddr + sport_ren_num;
							crop_fms_rbaddr1_cnt <= crop_fms_rbaddr1_cnt + sport_ren_num;
							crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt;
						end						
					end
					else begin
						sfms_raddr			 <= sfms_raddr + sport_ren_num;
						crop_fms_rbaddr1_cnt <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
						crop_fms_rbaddr2_cnt <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
					end
				end
				else begin
					sfms_raddr		 	 <= sfms_raddr;
					section_r_cnt		 <= (i_sap_sdp_parallelinoutsectiondone)?{(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}}:section_r_cnt;
					crop_fms_rbaddr1_cnt <= crop_fms_rbaddr1_cnt;
					crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt;
				end
			end
			WDATA:begin
				if(next_state == IDLE)begin
					sfms_raddr			<= {(`SDMA_ADDRWIDTH){1'b0}};
				end
				else begin
					sfms_raddr			<= sfms_raddr;
				end
				section_r_cnt 		 <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
				crop_fms_rbaddr1_cnt <= crop_fms_rbaddr1_cnt;
				crop_fms_rbaddr2_cnt <= crop_fms_rbaddr2_cnt;
			end
			BADDRSWITCH:begin
				sfms_raddr	  		 <= (i_sap_concate_fms_switch_flag)?(sfms2_raddr_context):(sfms1_raddr_context);
				section_r_cnt 		 <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
				crop_fms_rbaddr1_cnt <= (i_sap_concate_fms_switch_flag)?(crop_fms2_rbaddr1_cnt_context):(crop_fms1_rbaddr1_cnt_context);
				crop_fms_rbaddr2_cnt <= (i_sap_concate_fms_switch_flag)?(crop_fms2_rbaddr2_cnt_context):(crop_fms1_rbaddr2_cnt_context);
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		sfms1_raddr_context <= {(`SDMA_ADDRWIDTH){1'b0}};
		sfms2_raddr_context <= {(`SDMA_ADDRWIDTH){1'b0}};
		crop_fms1_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
		crop_fms1_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
		crop_fms2_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE1WIDTH){1'b0}};
		crop_fms2_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE2WIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_sap_en & i_sap_sdmamode[4])begin
					sfms1_raddr_context <= i_sap_srcfmsaddr;
					sfms2_raddr_context <= i_sap_srcfms2addr;
					crop_fms1_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
					crop_fms1_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
					crop_fms2_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE1WIDTH){1'b0}};
					crop_fms2_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE2WIDTH){1'b0}};
				end
				else begin
					sfms1_raddr_context <= {(`SDMA_ADDRWIDTH){1'b0}};
					sfms2_raddr_context <= {(`SDMA_ADDRWIDTH){1'b0}};
					crop_fms1_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE1WIDTH){1'b0}};
					crop_fms1_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMSSTRIDE2WIDTH){1'b0}};
					crop_fms2_rbaddr1_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE1WIDTH){1'b0}};
					crop_fms2_rbaddr2_cnt_context <= {(`SDMA_INST_CROPFMS2STRIDE2WIDTH){1'b0}};
				end
			end
			RDATA:begin
				sfms1_raddr_context <= sfms1_raddr_context;
				sfms2_raddr_context <= sfms2_raddr_context;
				crop_fms1_rbaddr1_cnt_context <= crop_fms1_rbaddr1_cnt_context;
				crop_fms1_rbaddr2_cnt_context <= crop_fms1_rbaddr2_cnt_context;
				crop_fms2_rbaddr1_cnt_context <= crop_fms2_rbaddr1_cnt_context;
				crop_fms2_rbaddr2_cnt_context <= crop_fms2_rbaddr2_cnt_context;
			end
			WDATA,PARALLELRW:begin
				if((i_sap_sdp_outputsectiondone || i_sap_sdp_parallelinoutsectiondone) && i_sap_sdmamode[4])begin
					if(i_sap_concate_fms_switch_flag)begin
						sfms1_raddr_context <= sfms1_raddr_context;
						sfms2_raddr_context <= sfms_raddr;
						crop_fms1_rbaddr1_cnt_context <= crop_fms1_rbaddr1_cnt_context;
						crop_fms1_rbaddr2_cnt_context <= crop_fms1_rbaddr2_cnt_context;
						crop_fms2_rbaddr1_cnt_context <= crop_fms_rbaddr1_cnt;
						crop_fms2_rbaddr2_cnt_context <= crop_fms_rbaddr2_cnt;
					end
					else begin
						sfms1_raddr_context <= sfms_raddr;
						sfms2_raddr_context <= sfms2_raddr_context;
						crop_fms1_rbaddr1_cnt_context <= crop_fms_rbaddr1_cnt;
						crop_fms1_rbaddr2_cnt_context <= crop_fms_rbaddr2_cnt;
						crop_fms2_rbaddr1_cnt_context <= crop_fms2_rbaddr1_cnt_context;
						crop_fms2_rbaddr2_cnt_context <= crop_fms2_rbaddr2_cnt_context;						
					end
				end
				else begin
					sfms1_raddr_context <= sfms1_raddr_context;
					sfms2_raddr_context <= sfms2_raddr_context;
					crop_fms1_rbaddr1_cnt_context <= crop_fms1_rbaddr1_cnt_context;
					crop_fms1_rbaddr2_cnt_context <= crop_fms1_rbaddr2_cnt_context;
					crop_fms2_rbaddr1_cnt_context <= crop_fms2_rbaddr1_cnt_context;
					crop_fms2_rbaddr2_cnt_context <= crop_fms2_rbaddr2_cnt_context;
				end
			end
			BADDRSWITCH:begin
				sfms1_raddr_context <= sfms1_raddr_context;
				sfms2_raddr_context <= sfms2_raddr_context;
				crop_fms1_rbaddr1_cnt_context <= crop_fms1_rbaddr1_cnt_context;
				crop_fms1_rbaddr2_cnt_context <= crop_fms1_rbaddr2_cnt_context;
				crop_fms2_rbaddr1_cnt_context <= crop_fms2_rbaddr1_cnt_context;
				crop_fms2_rbaddr2_cnt_context <= crop_fms2_rbaddr2_cnt_context;
			end
			default:begin
				sfms1_raddr_context <= sfms1_raddr_context;
				sfms2_raddr_context <= sfms2_raddr_context;
				crop_fms1_rbaddr1_cnt_context <= crop_fms1_rbaddr1_cnt_context;
				crop_fms1_rbaddr2_cnt_context <= crop_fms1_rbaddr2_cnt_context;
				crop_fms2_rbaddr1_cnt_context <= crop_fms2_rbaddr1_cnt_context;
				crop_fms2_rbaddr2_cnt_context <= crop_fms2_rbaddr2_cnt_context;
			end
		endcase
	end
end

genvar i;
generate 
	for(i=0;i<`SDMA_CACHEDATAWIDTH/8;i=i+1)begin: gen_sdp_ldb
		assign sdp_ldb[i] = (i < sdp_ldb_num);
	end
endgenerate

always@(*)begin
	if(cur_state == WDATA)begin
		dfms_waddr_inc_flag = i_sap_dport_ready && ~((section_w_cnt == section_w_num) && ~padding_flag);
	end
	else if(cur_state == PARALLELRW)begin
		dfms_waddr_inc_flag = i_sap_dport_ready && ~((section_w_cnt == section_w_num) && ~padding_flag) && ~i_sap_sdp_parallelinoutempty;
	end
	else begin
		dfms_waddr_inc_flag = 1'b0;
	end
end

always@(*)begin
	if(i_sap_sdmamode[3])begin
		case(i_sap_paddingaxisbefore[2:0])
			3'b000:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			3'b111:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
					sfms_c_withpu = i_sap_srcfmsc;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddingleftx + i_sap_paddingrighty;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddinglefty + i_sap_paddingrighty;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotalx;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotaly;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			3'b001:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddinglefty + i_sap_paddingrighty;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddingleftx + i_sap_paddingrightx;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotaly;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_insertzeronumtotalx;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			3'b110:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddinglefty + i_sap_paddingrighty;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_insertzeronumtotaly;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			3'b010:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddingleftx + i_sap_paddingrightx;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_insertzeronumtotalx;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			3'b101:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddingleftx + i_sap_paddingrightx;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_paddinglefty + i_sap_paddingrighty;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotalx;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc + i_sap_insertzeronumtotaly;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
			default:begin
				if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc;
				end	
				else if(i_sap_sdmamode[2])begin					//Padding
					sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else if(i_sap_sdmamode[1])begin					//Upsample
					sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotaly;
					sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotalx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
				else begin
					sfms_y_withpu = i_sap_srcfmsy;
					sfms_x_withpu = i_sap_srcfmsx;
					sfms_c_withpu = i_sap_srcfmsc;
				end
			end
		endcase
	end
	else begin
		if(i_sap_sdmamode[2] && i_sap_sdmamode[1])begin //Padding and Upsample
			sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty + i_sap_insertzeronumtotaly;
			sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx + i_sap_insertzeronumtotalx;
			sfms_c_withpu = i_sap_srcfmsc;
		end	
		else if(i_sap_sdmamode[2])begin					//Padding
			sfms_y_withpu = i_sap_srcfmsy + i_sap_paddinglefty + i_sap_paddingrighty;
			sfms_x_withpu = i_sap_srcfmsx + i_sap_paddingleftx + i_sap_paddingrightx;
			sfms_c_withpu = i_sap_srcfmsc;
		end
		else if(i_sap_sdmamode[1])begin					//Upsample
			sfms_y_withpu = i_sap_srcfmsy + i_sap_insertzeronumtotaly;
			sfms_x_withpu = i_sap_srcfmsx + i_sap_insertzeronumtotalx;
			sfms_c_withpu = i_sap_srcfmsc;
		end
		else begin
			sfms_y_withpu = i_sap_srcfmsy;
			sfms_x_withpu = i_sap_srcfmsx;
			sfms_c_withpu = i_sap_srcfmsc;
		end
	end
end

always@(*)begin
	if(cur_state == WDATA || cur_state == PARALLELRW)begin
		if(i_sap_sdmamode[3] || i_sap_sdmamode[2] || i_sap_sdmamode[1])begin
			sfms_c_wrap_flag = (dfms_waddr_inc_flag && (sfms_c_cnt + sdp_ldb_num == sfms_c_withpu));
		end
		else begin
			sfms_c_wrap_flag = 1'b0;
		end
	end
	else begin
		sfms_c_wrap_flag = 1'b0;
	end
end

always@(*)begin
	if(cur_state == WDATA || cur_state == PARALLELRW)begin
		if(i_sap_sdmamode[3] || i_sap_sdmamode[2] || i_sap_sdmamode[1])begin
			sfms_x_wrap_flag = (dfms_waddr_inc_flag && sfms_c_wrap_flag && (sfms_x_cnt + 1'd1 == sfms_x_withpu));
		end
		else begin
			sfms_x_wrap_flag = 1'b0;
		end
	end
	else begin
		sfms_x_wrap_flag = 1'b0;
	end
end

always@(*)begin
	if(cur_state == WDATA || cur_state == PARALLELRW)begin
		if(i_sap_sdmamode[3] || i_sap_sdmamode[2] || i_sap_sdmamode[1])begin
			sfms_y_wrap_flag = (dfms_waddr_inc_flag && sfms_x_wrap_flag && (sfms_y_cnt + 1'd1== sfms_y_withpu));
		end
		else begin
			sfms_y_wrap_flag = 1'b0;
		end
	end
	else begin
		sfms_y_wrap_flag = 1'b0;
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
		sfms_x_cnt <= {(`SDMA_INST_SRCFMSXWIDTH){1'b0}};
		sfms_y_cnt <= {(`SDMA_INST_SRCFMSYWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
				sfms_x_cnt <= {(`SDMA_INST_SRCFMSXWIDTH){1'b0}};
				sfms_y_cnt <= {(`SDMA_INST_SRCFMSYWIDTH){1'b0}};
			end
			RDATA:begin
				sfms_c_cnt <= sfms_c_cnt;
				sfms_x_cnt <= sfms_x_cnt;
				sfms_y_cnt <= sfms_y_cnt;
			end
			WDATA,PARALLELRW:begin
				if(dfms_waddr_inc_flag)begin
					if(i_sap_sdmamode[3] || i_sap_sdmamode[2] || i_sap_sdmamode[1])begin //Transpose or Padding or Upsample
						if(sfms_y_wrap_flag)begin
							sfms_c_cnt <= sfms_c_withpu;
							sfms_x_cnt <= sfms_x_withpu;
							sfms_y_cnt <= sfms_y_withpu;
						end
						else if(sfms_x_wrap_flag)begin
							sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
							sfms_x_cnt <= {(`SDMA_INST_SRCFMSXWIDTH){1'b0}};
							sfms_y_cnt <= sfms_y_cnt + 1'd1;
						end
						else if(sfms_c_wrap_flag)begin
							sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
							sfms_x_cnt <= sfms_x_cnt + 1'd1;
							sfms_y_cnt <= sfms_y_cnt;
						end
						else begin
							sfms_c_cnt <= sfms_c_cnt + sdp_ldb_num;
							sfms_x_cnt <= sfms_x_cnt;
							sfms_y_cnt <= sfms_y_cnt;
						end
					end
					else begin
						sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
						sfms_x_cnt <= {(`SDMA_INST_SRCFMSXWIDTH){1'b0}};
						sfms_y_cnt <= {(`SDMA_INST_SRCFMSYWIDTH){1'b0}};
					end
				end
				else begin
					sfms_c_cnt <= sfms_c_cnt;
					sfms_x_cnt <= sfms_x_cnt;
					sfms_y_cnt <= sfms_y_cnt;
				end
			end
			BADDRSWITCH:begin
				sfms_c_cnt <= sfms_c_cnt;
				sfms_x_cnt <= sfms_x_cnt;
				sfms_y_cnt <= sfms_y_cnt;
			end
			default:begin
				sfms_c_cnt <= {(`SDMA_INST_SRCFMSCWIDTH){1'b0}};
				sfms_x_cnt <= {(`SDMA_INST_SRCFMSXWIDTH){1'b0}};
				sfms_y_cnt <= {(`SDMA_INST_SRCFMSYWIDTH){1'b0}};
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
		trans_fms_stride1_idx <= {(`SDMA_INST_DSTFMSSTRIDE1WIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
				trans_fms_stride1_idx <= {(`SDMA_INST_DSTFMSSTRIDE1WIDTH){1'b0}};
			end
			RDATA:begin
				trans_fms_stride2_idx <= trans_fms_stride2_idx;
				trans_fms_stride1_idx <= trans_fms_stride1_idx;	
			end
			WDATA,PARALLELRW:begin
				if(dfms_waddr_inc_flag)begin
					if(i_sap_sdpmode == `SDMA_SDP_MODE_AHB2AHBSEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHESEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2AHBSEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2CACHESEQ)begin
						trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
						trans_fms_stride1_idx <= {(`SDMA_INST_DSTFMSSTRIDE1WIDTH){1'b0}};	
					end
					else begin //Transpose
						if(sfms_y_wrap_flag)begin
							trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
							trans_fms_stride1_idx <= {(`SDMA_INST_DSTFMSSTRIDE1WIDTH){1'b0}};	
						end
						else if(sfms_x_wrap_flag)begin
							trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
							trans_fms_stride1_idx <= trans_fms_stride1_idx + i_sap_dstfmsstride1;
						end
						else if(sfms_c_wrap_flag)begin
							trans_fms_stride2_idx <= trans_fms_stride2_idx + i_sap_dstfmsstride2;
							trans_fms_stride1_idx <= trans_fms_stride1_idx;
						end
						else begin
							trans_fms_stride2_idx <= trans_fms_stride2_idx;
							trans_fms_stride1_idx <= trans_fms_stride1_idx;
						end
					end
				end
				else begin
					trans_fms_stride2_idx <= trans_fms_stride2_idx;
					trans_fms_stride1_idx <= trans_fms_stride1_idx;	
				end
			end
			BADDRSWITCH:begin
				trans_fms_stride2_idx <= trans_fms_stride2_idx;
				trans_fms_stride1_idx <= trans_fms_stride1_idx;
			end
			default:begin
				trans_fms_stride2_idx <= {(`SDMA_INST_DSTFMSSTRIDE2WIDTH){1'b0}};
				trans_fms_stride1_idx <= {(`SDMA_INST_DSTFMSSTRIDE1WIDTH){1'b0}};
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		upsample_x_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
		upsample_y_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				upsample_x_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
				upsample_y_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
			end
			RDATA:begin
				upsample_x_cnt <= upsample_x_cnt;
				upsample_y_cnt <= upsample_y_cnt;
			end
			WDATA,PARALLELRW:begin
				if(dfms_waddr_inc_flag)begin
					if(i_sap_sdmamode[3])begin	//Transpose
						case(i_sap_paddingaxisbefore)
							3'b000:begin
								upsample_x_cnt <= (sfms_c_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
								upsample_y_cnt <= (sfms_x_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
							end
							3'b111:begin
								upsample_x_cnt <= (sfms_x_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
								upsample_y_cnt <= (sfms_c_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
							end
							3'b001:begin
								upsample_x_cnt <= (upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1);
								upsample_y_cnt <= (sfms_c_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
							end
							3'b110:begin
								upsample_x_cnt <= (sfms_c_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
								upsample_y_cnt <= (upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1);
							end
							3'b010:begin
								upsample_x_cnt <= (upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1);
								upsample_y_cnt <= (sfms_x_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
							end
							3'b101:begin
								upsample_x_cnt <= (sfms_x_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
								upsample_y_cnt <= (upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1);
							end
							default:begin
								upsample_x_cnt <= (sfms_c_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
								upsample_y_cnt <= (sfms_x_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
							end
						endcase
					end
					else begin
						upsample_x_cnt <= (sfms_c_wrap_flag)?((upsample_x_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_x_cnt + 1'd1)):upsample_x_cnt;
						upsample_y_cnt <= (sfms_x_wrap_flag)?((upsample_y_cnt == i_sap_insertzeronum)?{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}}:(upsample_y_cnt + 1'd1)):upsample_y_cnt;
					end
				end
				else begin
					upsample_x_cnt <= upsample_x_cnt;
					upsample_y_cnt <= upsample_y_cnt;
				end
			end
			BADDRSWITCH:begin
				upsample_x_cnt <= upsample_x_cnt;
				upsample_y_cnt <= upsample_y_cnt;
			end
			default:begin
				upsample_x_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
				upsample_y_cnt <= {(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
			end
		endcase
	end
end

always@(*)begin
	if((cur_state == WDATA || cur_state == PARALLELRW) && dfms_waddr_inc_flag)begin
		if(i_sap_sdpmode == `SDMA_SDP_MODE_AHB2AHBSEQ || i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2AHBSEQ)begin //dport ahb, w/o Transpose
			if(i_sap_sdmamode[2] || i_sap_sdmamode[1])begin // with Padding or Upsample
			`ifdef HIGH_BANDWIDTH_VERSION
				if(~((dfms_waddr[3]||dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (~(padding_flag || upsample_flag) && (section_w_cnt + 5'd16 > section_w_num)) ||  (sfms_c_cnt + 5'd16 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-5){1'b0}},5'd16};
				end
				else if(~((dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (~(padding_flag || upsample_flag) && (section_w_cnt + 4'd8 > section_w_num)) ||  (sfms_c_cnt + 4'd8 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((dfms_waddr[1]||dfms_waddr[0]) || (~(padding_flag || upsample_flag) && (section_w_cnt + 3'd4 > section_w_num)) ||  (sfms_c_cnt + 3'd4 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
			`ifdef MED_BANDWIDTH_VERSION
				if(~((dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 4'd8 > section_w_num) || (sfms_c_cnt + 4'd8 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 3'd4 > section_w_num) || (sfms_c_cnt + 3'd4 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
				if(~((dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 3'd4 > section_w_num) || (sfms_c_cnt + 3'd4 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`endif
			`endif
				else if(~((dfms_waddr[0]) || (~(padding_flag || upsample_flag) && (section_w_cnt + 2'd2 > section_w_num)) || (sfms_c_cnt + 2'd2 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'b1};
				end
			end
			else begin	// w/o Padding or Upsample
			`ifdef HIGH_BANDWIDTH_VERSION
				if(i_sap_sdmamode[5])begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else if(~((dfms_waddr[3]||dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 5'd16 > section_w_num)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-5){1'b0}},5'd16};
				end
				else if(~((dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 4'd8 > section_w_num)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 3'd4 > section_w_num)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
			`ifdef MED_BANDWIDTH_VERSION
				if(i_sap_sdmamode[5])begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else if(~((dfms_waddr[2]||dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 4'd8 > section_w_num) || (sfms_c_cnt + 4'd8 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-4){1'b0}},4'd8};
				end
				else if(~((dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 3'd4 > section_w_num) || (sfms_c_cnt + 3'd4 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`else
				if(i_sap_sdmamode[5])begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else if(~((dfms_waddr[1]||dfms_waddr[0]) || (section_w_cnt + 3'd4 > section_w_num) || (sfms_c_cnt + 3'd4 > sfms_c_withpu)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-3){1'b0}},3'd4};
				end
			`endif
			`endif
				else if(~((dfms_waddr[0]) || (section_w_cnt + 2'd2 > section_w_num)))begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'b1};
				end
			end
		end
		else if(i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHESEQ ||i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2CACHESEQ)begin//dport is cache,w/o Transpose
			if(i_sap_sdmamode[2] || i_sap_sdmamode[1])begin	//with Padding or Upsample
				if(sfms_c_withpu > `SDMA_CACHEDATAWIDTH/8)begin
					if(padding_flag || upsample_flag)begin
						sdp_ldb_num = ($unsigned(sfms_c_withpu - sfms_c_cnt) > `SDMA_CACHEDATAWIDTH/8)?(`SDMA_CACHEDATAWIDTH/8):(sfms_c_withpu - sfms_c_cnt);
					end
					else begin
						sdp_ldb_num = ((sfms_c_withpu - sfms_c_cnt) > (section_w_num - section_w_cnt))?(section_w_num - section_w_cnt):(sfms_c_withpu - sfms_c_cnt);
					end
				end
				else begin
					if(padding_flag || upsample_flag)begin
						sdp_ldb_num = sfms_c_withpu;
					end
					else begin
						sdp_ldb_num = ((sfms_c_withpu - sfms_c_cnt) > (section_w_num - section_w_cnt))?(section_w_num - section_w_cnt):(sfms_c_withpu - sfms_c_cnt);
					end
				end
			end
			else begin	//w/o Padding or Upsample
				if(i_sap_sdmamode[5])begin
					sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-2){1'b0}},2'd2};
				end
				else begin
					sdp_ldb_num = i_sap_num_of_remain_bytes;
				end
			end
		end
		else begin //Transpose
			sdp_ldb_num = {{(`SDMA_SECTION_DINNUMDATAWIDTH-1){1'b0}},1'b1};
		end
	end
	else begin
		sdp_ldb_num = {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		section_w_cnt <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};
	end
	else begin
		if(cur_state == WDATA || cur_state == PARALLELRW)begin
			section_w_cnt <= (dfms_waddr_inc_flag && ~(padding_flag || upsample_flag))?(section_w_cnt + sdp_ldb_num):((i_sap_sdp_outputsectiondone || i_sap_sdp_parallelinoutsectiondone)?{(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}}:section_w_cnt);
		end
		else begin
			section_w_cnt <= {(`SDMA_SECTION_DINNUMDATAWIDTH){1'b0}};	
		end
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		dfms_waddr 	<= {(`SDMA_ADDRWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				if(i_sap_en)begin
					dfms_waddr <= i_sap_dstfmsaddr;
				end
				else begin
					dfms_waddr <= {(`SDMA_ADDRWIDTH){1'b0}};
				end
			end
			RDATA:begin
				dfms_waddr <= dfms_waddr;
			end
			WDATA,PARALLELRW:begin
				if(dfms_waddr_inc_flag)begin
					if(i_sap_sdpmode == `SDMA_SDP_MODE_AHB2AHBSEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_AHB2CACHESEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2AHBSEQ
					|| i_sap_sdpmode == `SDMA_SDP_MODE_CACHE2CACHESEQ)begin
						dfms_waddr <= (i_sap_sdmamode[5])?(dfms_waddr + 1'd1):(dfms_waddr + sdp_ldb_num);
					end
					else begin //Transpose
						if(sfms_y_wrap_flag)begin
							dfms_waddr <= dfms_waddr;
						end
						else if(sfms_x_wrap_flag)begin
							dfms_waddr <= i_sap_dstfmsaddr + trans_fms_stride1_idx + i_sap_dstfmsstride1;
						end
						else if(sfms_c_wrap_flag)begin
							dfms_waddr <= i_sap_dstfmsaddr + trans_fms_stride1_idx + trans_fms_stride2_idx + i_sap_dstfmsstride2;
						end
						else begin
							dfms_waddr <= dfms_waddr + i_sap_dstfmsstride3;
						end
					end
				end
				else begin
					dfms_waddr <= dfms_waddr;
				end
			end
			BADDRSWITCH:begin
				dfms_waddr <= dfms_waddr;
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		dfms_waddr_r <= {(`SDMA_ADDRWIDTH){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				dfms_waddr_r <= {(`SDMA_ADDRWIDTH){1'b0}};
			end
			RDATA:begin
				dfms_waddr_r <= dfms_waddr_r;
			end
			WDATA,PARALLELRW:begin
				dfms_waddr_r <= (dfms_waddr_inc_flag)?dfms_waddr:((i_sap_sdp_outputsectiondone || i_sap_sdp_parallelinoutsectiondone)?{(`SDMA_ADDRWIDTH){1'b0}}:dfms_waddr_r);
			end
			BADDRSWITCH:begin
				dfms_waddr_r <= dfms_waddr_r;
			end
			default:begin
				dfms_waddr_r <= dfms_waddr_r;
			end
		endcase
	end
end

always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		dport_wen <= {(`SDMA_CACHEDATAWIDTH/8){1'b0}};
	end
	else begin
		case(cur_state)
			IDLE:begin
				dport_wen <= {(`SDMA_CACHEDATAWIDTH/8){1'b0}};
			end
			RDATA:begin
				dport_wen <= {(`SDMA_CACHEDATAWIDTH/8){1'b0}};
			end
			WDATA,PARALLELRW:begin
				dport_wen <= (dfms_waddr_inc_flag)?(i_sap_sdmamode[5]?{{(`SDMA_CACHEDATAWIDTH/8-1){1'b0}},1'b1}:sdp_ldb):((i_sap_sdp_outputsectiondone || i_sap_sdp_parallelinoutsectiondone)?{(`SDMA_CACHEDATAWIDTH/8){1'b0}}:dport_wen);
			end
			BADDRSWITCH:begin
				dport_wen <= {(`SDMA_CACHEDATAWIDTH/8){1'b0}};
			end
			default:begin
				dport_wen <= {(`SDMA_CACHEDATAWIDTH/8){1'b0}};
			end
		endcase
	end
end

//------------------------------------------------------------------------------

//----------------------------------SUB MODULE INSTANCE-------------------------
sdma_sap_padding_indicator U_SDMA_SAP_PADDING_INDICATOR_0(
  .i_sap_pi_paddingen		   ((cur_state == PARALLELRW || cur_state == WDATA) && i_sap_sdmamode[2]),
  .i_sap_pi_paddingleftx       (i_sap_paddingleftx),
  .i_sap_pi_paddingrightx      (i_sap_paddingrightx),
  .i_sap_pi_paddinglefty       (i_sap_paddinglefty),
  .i_sap_pi_paddingrighty      (i_sap_paddingrighty),
  .i_sap_pi_upsampleen		   (i_sap_sdmamode[1]),
  .i_sap_pi_insertzeronumtotalx(i_sap_insertzeronumtotalx),
  .i_sap_pi_insertzeronumtotaly(i_sap_insertzeronumtotaly),
  .i_sap_pi_srcfmsc            (i_sap_srcfmsc),
  .i_sap_pi_srcfmsx            (i_sap_srcfmsx),
  .i_sap_pi_srcfmsy            (i_sap_srcfmsy),
  .i_sap_pi_paddingaxisbefore  (i_sap_paddingaxisbefore),
  .i_sap_pi_sfmsccnt           (sfms_c_cnt),
  .i_sap_pi_sfmsxcnt           (sfms_x_cnt),
  .i_sap_pi_sfmsycnt           (sfms_y_cnt),
  .o_sap_pi_padding_flag       (padding_flag)
);

sdma_sap_upsample_indicator U_SDMA_SAP_UPSAMPLE_INDICATOR_0(
  .i_sap_ui_upsampleen	 ((cur_state == PARALLELRW || cur_state == WDATA) && i_sap_sdmamode[1]),
  .i_sap_ui_paddingen	 ((cur_state == PARALLELRW || cur_state == WDATA) && i_sap_sdmamode[2]),
  .i_sap_ui_paddingflag  (padding_flag),
  .i_sap_ui_upsampleidxx (i_sap_upsampleidxx),
  .i_sap_ui_upsampleidxy (i_sap_upsampleidxy),
  .i_sap_ui_upsamplexcnt (upsample_x_cnt),
  .i_sap_ui_upsampleycnt (upsample_y_cnt),
  .o_sap_ui_upsampleflag (upsample_flag)
);
//------------------------------------------------------------------------------


//----------------------------------OUTPUT LOGIC--------------------------------
assign 	o_sap_sport_ren 		= sport_ren;
assign	o_sap_sport_raddr		= sfms_raddr;
assign	o_sap_sdp_ldb_num		= sdp_ldb_num;
assign	o_sap_padding_flag		= padding_flag;
assign  o_sap_upsample_flag		= upsample_flag;
assign  o_sap_dport_wen			= dport_wen;
assign	o_sap_dport_waddr		= dfms_waddr_r;
assign  o_sap_sigmnt1			= {clk,3'd0,o_sap_padding_flag,o_sap_upsample_flag,cur_state};
assign	o_sap_sigmnt2			= {clk,2'd0,o_sap_sdp_ldb_num};
//------------------------------------------------------------------------------

endmodule
