// -----------------------------------------------------------------------------
// FILE NAME : sdma_top_ctrl.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-18
// -----------------------------------------------------------------------------
// DESCRIPTION : Top control of sdma. The module receives instructions and decode them.
// And indicate the work state of sdma.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_top_ctrl
(
	input												clk,
	input												rst_n,
	input												i_stc_en,
	input												i_stc_inst_vld,
	input  	[`SDMA_INSTWIDTH-1:0]						i_stc_inst,
	input												i_stc_sscready,
	input												i_stc_ssctransferdone,
	output	reg											o_stc_sscen,
	output	reg											o_stc_ready,
	output  [`SDMA_INST_SDMAMODEWIDTH - 1:0]  			o_stc_sdmamode,
	output  [`SDMA_INST_SRCPORTIDWIDTH - 1:0]  			o_stc_srcportid,
	output  [`SDMA_INST_DSTPORTIDWIDTH - 1:0]  			o_stc_dstportid,
	output  [`SDMA_INST_SRCFMSADDRWIDTH - 1:0]  		o_stc_srcfmsaddr,
	output  [`SDMA_INST_DSTFMSADDRWIDTH - 1:0]  		o_stc_dstfmsaddr,
	output  [`SDMA_INST_SRCFMSMOVELENGTHWIDTH - 1:0]  	o_stc_srcfmsmovelength,
	output  [`SDMA_INST_SRCFMS2ADDRWIDTH - 1:0]  		o_stc_srcfms2addr,
	output  [`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH - 1:0]o_stc_srcfms1concatelength,
	output  [`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH - 1:0]o_stc_srcfms2concatelength,
	output  [`SDMA_INST_SRCFMS2MOVELENGTHWIDTH - 1:0]  	o_stc_srcfms2movelength,
	output  [`SDMA_INST_SRCFMSCWIDTH - 1:0]  			o_stc_srcfmsc,
	output  [`SDMA_INST_SRCFMSXWIDTH - 1:0]  			o_stc_srcfmsx,
	output  [`SDMA_INST_SRCFMSYWIDTH - 1:0]  			o_stc_srcfmsy,
	output  [`SDMA_INST_DSTFMSSTRIDE3WIDTH - 1:0]  		o_stc_dstfmsstride3,
	output  [`SDMA_INST_DSTFMSSTRIDE2WIDTH - 1:0]  		o_stc_dstfmsstride2,
	output  [`SDMA_INST_DSTFMSSTRIDE1WIDTH - 1:0]  		o_stc_dstfmsstride1,
	output	[`SDMA_INST_PADDINGAXISBEFOREWIDTH - 1:0]	o_stc_paddingaxisbefore,
	output  [`SDMA_INST_PADDINGLEFTXWIDTH - 1:0]  		o_stc_paddingleftx,
	output  [`SDMA_INST_PADDINGRIGHTXWIDTH - 1:0]  		o_stc_paddingrightx,
	output  [`SDMA_INST_PADDINGLEFTYWIDTH - 1:0]  		o_stc_paddinglefty,
	output  [`SDMA_INST_PADDINGRIGHTYWIDTH - 1:0]  		o_stc_paddingrighty,
	output  [`SDMA_INST_INSERTZERONUMWIDTH - 1:0]  		o_stc_insertzeronum,
	output  [`SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1:0] o_stc_insertzeronumtotalx,
	output  [`SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1:0] o_stc_insertzeronumtotaly,
	output	[`SDMA_INST_UPSAMPLEIDXXWIDTH - 1:0]		o_stc_upsampleidxx,
	output	[`SDMA_INST_UPSAMPLEIDXYWIDTH - 1:0]		o_stc_upsampleidxy,		
	output  [`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0]  	o_stc_cropfmsstride2,
	output  [`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0]  	o_stc_cropfmsstride1,
	output  [`SDMA_INST_CROPFMSCWIDTH - 1:0]  			o_stc_cropfmsc,
	output  [`SDMA_INST_CROPFMSXWIDTH - 1:0]  			o_stc_cropfmsx,
	output  [`SDMA_INST_CROPFMSYWIDTH - 1:0]  			o_stc_cropfmsy,
	output  [`SDMA_INST_CROPFMS2STRIDE2WIDTH - 1:0]  	o_stc_cropfms2stride2,
	output  [`SDMA_INST_CROPFMS2STRIDE1WIDTH - 1:0]  	o_stc_cropfms2stride1,
	output  [`SDMA_INST_CROPFMSCWIDTH - 1:0]  			o_stc_cropfms2c,
	output  [`SDMA_INST_CROPFMSXWIDTH - 1:0]  			o_stc_cropfms2x,
	output  [`SDMA_INST_CROPFMSYWIDTH - 1:0]  			o_stc_cropfms2y,
	output  [`SDMA_INST_SRCFMSCYCSADDRWIDTH - 1:0]		o_stc_srcfmscycsaddr,
	output	[`SDMA_INST_SRCFMSCYCEADDRWIDTH - 1:0]		o_stc_srcfmscyceaddr,
	output	[`SDMA_INST_SRCFMSCYCALIGNENAWIDTH - 1:0]   o_stc_srcfmscycalignena,
	output	[`SDMA_INST_SHUFFLEIDXWIDTH - 1:0]			o_stc_shuffleidx,
	output	[9:0]										o_stc_sigmnt1,
	output	[9:0]										o_stc_sigmnt2
);

//----------------------------------STATE---------------------------------------
localparam 	[1:0]	IDLE 	 	= 2'b00;
localparam  [1:0]	SDMACONFIG	= 2'b01;
localparam 	[1:0]	SDMAWORK 	= 2'b10;

//------------------------------------------------------------------------------

//----------------------------------VARIABLES-----------------------------------
reg		[1:0]							cur_state;
reg		[1:0]							next_state;
reg		[`SDMA_INSTWIDTH-1:0]			executing_inst;
//------------------------------------------------------------------------------

//----------------------------------STATE TRANSFER------------------------------
always@(*)begin
	case(cur_state)
		IDLE:begin
			if(i_stc_en && i_stc_inst_vld && i_stc_sscready)begin
				next_state = SDMACONFIG;
			end
			else begin
				next_state = IDLE;
			end
		end
		SDMACONFIG:begin
			next_state = SDMAWORK;
		end
		SDMAWORK:begin
			if(i_stc_ssctransferdone)begin
				next_state = IDLE;
			end
			else begin
				next_state = SDMAWORK;
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
		executing_inst <= {(`SDMA_INSTWIDTH){1'b0}};
	end
	else begin
		if((cur_state == IDLE) && i_stc_en && i_stc_inst_vld && i_stc_sscready)begin
			executing_inst <= i_stc_inst;
		end
		else if((cur_state == SDMAWORK) && i_stc_ssctransferdone)begin
			executing_inst <= {(`SDMA_INSTWIDTH){1'b0}};
		end
		else begin
			executing_inst <= executing_inst;
		end
	end
end
//------------------------------------------------------------------------------

//----------------------------------SUBMODULE INSTANCE--------------------------
sdma_inst_decoder U_SDMA_INST_DECODER_0(
  .i_sid_inst                 (executing_inst[`SDMA_INSTWIDTH-1:0]),
  .o_sid_sdmamode             (o_stc_sdmamode[`SDMA_INST_SDMAMODEWIDTH-1:0]),
  .o_sid_srcportid            (o_stc_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .o_sid_dstportid            (o_stc_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .o_sid_srcfmsaddr           (o_stc_srcfmsaddr[`SDMA_INST_SRCFMSADDRWIDTH-1:0]),
  .o_sid_dstfmsaddr           (o_stc_dstfmsaddr[`SDMA_INST_DSTFMSADDRWIDTH-1:0]),
  .o_sid_srcfmsmovelength     (o_stc_srcfmsmovelength[`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0]),
  .o_sid_srcfms2addr          (o_stc_srcfms2addr[`SDMA_INST_SRCFMS2ADDRWIDTH-1:0]),
  .o_sid_srcfms1concatelength (o_stc_srcfms1concatelength[`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0]),
  .o_sid_srcfms2concatelength (o_stc_srcfms2concatelength[`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0]),
  .o_sid_srcfms2movelength    (o_stc_srcfms2movelength[`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0]),
  .o_sid_srcfmsc              (o_stc_srcfmsc[`SDMA_INST_SRCFMSCWIDTH-1:0]),
  .o_sid_srcfmsx              (o_stc_srcfmsx[`SDMA_INST_SRCFMSXWIDTH-1:0]),
  .o_sid_srcfmsy              (o_stc_srcfmsy[`SDMA_INST_SRCFMSYWIDTH-1:0]),
  .o_sid_dstfmsstride3        (o_stc_dstfmsstride3[`SDMA_INST_DSTFMSSTRIDE3WIDTH-1:0]),
  .o_sid_dstfmsstride2        (o_stc_dstfmsstride2[`SDMA_INST_DSTFMSSTRIDE2WIDTH-1:0]),
  .o_sid_dstfmsstride1        (o_stc_dstfmsstride1[`SDMA_INST_DSTFMSSTRIDE1WIDTH-1:0]),
  .o_sid_paddingaxisbefore    (o_stc_paddingaxisbefore[`SDMA_INST_PADDINGAXISBEFOREWIDTH-1:0]),
  .o_sid_paddingleftx         (o_stc_paddingleftx[`SDMA_INST_PADDINGLEFTXWIDTH-1:0]),
  .o_sid_paddingrightx        (o_stc_paddingrightx[`SDMA_INST_PADDINGRIGHTXWIDTH-1:0]),
  .o_sid_paddinglefty         (o_stc_paddinglefty[`SDMA_INST_PADDINGLEFTYWIDTH-1:0]),
  .o_sid_paddingrighty        (o_stc_paddingrighty[`SDMA_INST_PADDINGRIGHTYWIDTH-1:0]),
  .o_sid_insertzeronum        (o_stc_insertzeronum[`SDMA_INST_INSERTZERONUMWIDTH-1:0]),
  .o_sid_insertzeronumtotalx  (o_stc_insertzeronumtotalx[`SDMA_INST_INSERTZERONUMTOTALXWIDTH-1:0]),
  .o_sid_insertzeronumtotaly  (o_stc_insertzeronumtotaly[`SDMA_INST_INSERTZERONUMTOTALYWIDTH-1:0]),
  .o_sid_upsampleidxx		  (o_stc_upsampleidxx[`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0]),
  .o_sid_upsampleidxy		  (o_stc_upsampleidxy[`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0]),
  .o_sid_cropfmsstride2		  (o_stc_cropfmsstride2[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]),
  .o_sid_cropfmsstride1       (o_stc_cropfmsstride1[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]),
  .o_sid_cropfmsc             (o_stc_cropfmsc[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_sid_cropfmsx             (o_stc_cropfmsx[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_sid_cropfmsy             (o_stc_cropfmsy[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .o_sid_cropfms2stride2	  (o_stc_cropfms2stride2[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]),
  .o_sid_cropfms2stride1      (o_stc_cropfms2stride1[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]),
  .o_sid_cropfms2c            (o_stc_cropfms2c[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_sid_cropfms2x            (o_stc_cropfms2x[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_sid_cropfms2y            (o_stc_cropfms2y[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .o_sid_srcfmscycsaddr		  (o_stc_srcfmscycsaddr[`SDMA_INST_SRCFMSCYCSADDRWIDTH-1:0]),
  .o_sid_srcfmscyceaddr		  (o_stc_srcfmscyceaddr[`SDMA_INST_SRCFMSCYCEADDRWIDTH-1:0]),
  .o_sid_srcfmscycalignena	  (o_stc_srcfmscycalignena[`SDMA_INST_SRCFMSCYCALIGNENAWIDTH-1:0]),
  .o_sid_shuffleidx			  (o_stc_shuffleidx[`SDMA_INST_SHUFFLEIDXWIDTH-1:0])
);

//------------------------------------------------------------------------------

//----------------------------------OUTPUT LOGIC--------------------------------
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		o_stc_sscen <= 1'b0;
		o_stc_ready <= 1'b1;
	end
	else begin
		if((cur_state == IDLE) && i_stc_en && i_stc_inst_vld && i_stc_sscready)begin
			o_stc_sscen <= 1'b1;
			o_stc_ready <= 1'b0;
		end
		else if((cur_state == SDMAWORK) && i_stc_ssctransferdone)begin
			o_stc_sscen <= 1'b0;
			o_stc_ready <= 1'b1;
		end
		else begin
			o_stc_sscen <= o_stc_sscen;
			o_stc_ready <= o_stc_ready;
		end
	end
end

assign o_stc_sigmnt1 = {clk,o_stc_sdmamode,cur_state};
assign o_stc_sigmnt2 = {clk,6'd0,{o_stc_srcportid[2],o_stc_dstportid[2],o_stc_sdmamode[3]}};
//------------------------------------------------------------------------------

endmodule
