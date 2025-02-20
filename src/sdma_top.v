// -----------------------------------------------------------------------------
// FILE NAME : sdma_top.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-19
// -----------------------------------------------------------------------------
// DESCRIPTION : Top level of SDMA.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/sdma_params.vh"
module sdma_top
(
	input										clk,
	input										rst_n,
	//ctrl port
	input										i_sdma_en,
	input  										i_sdma_inst_vld,
	input  [`SDMA_INSTWIDTH-1:0]				i_sdma_inst,
	output 										o_sdma_ready,
	//AHB port
	input										i_sdma_ahbready,
	input  [`SDMA_AHBDATAWIDTH-1:0]				i_sdma_ahbrdata,
	input  [`SDMA_AHBDATAWIDTH/8-1:0]			i_sdma_ahbrvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_ahbaddr,
	output [`SDMA_AHBDATAWIDTH/8-1:0]			o_sdma_ahbena,
	output [`SDMA_AHBDATAWIDTH-1:0]				o_sdma_ahbwdata,
	output 										o_sdma_ahbwea,
	//DCACHE1
	input										i_sdma_dc1ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc1rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc1addr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc1ena,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc1wdata,
	output 										o_sdma_dc1wea,
	//DCACHE2
	input										i_sdma_dc2ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc2rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc2addr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc2ena,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc2wdata,
	output 										o_sdma_dc2wea,
	//WCACHE1
	input										i_sdma_wc1ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc1rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc1addr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc1ena,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc1wdata,
	output 										o_sdma_wc1wea,
	//WCACHE2
	input										i_sdma_wc2ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc2rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc2addr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc2ena,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc2wdata,
	output 										o_sdma_wc2wea
);

//----------------------------------WIRES---------------------------------------
wire 									ssc_en;
wire 									ssc_ready;
wire [`SDMA_INST_SDMAMODEWIDTH-1:0]		inst_sdmamode;
wire [`SDMA_INST_SRCPORTIDWIDTH-1:0]	inst_srcportid;
wire [`SDMA_INST_DSTPORTIDWIDTH-1:0] 	inst_dstportid;
wire [`SDMA_INST_SRCFMSADDRWIDTH-1:0]	inst_srcfmsaddr;
wire [`SDMA_INST_DSTFMSADDRWIDTH-1:0]	inst_dstfmsaddr;
wire [`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0] inst_srcfmsmovelength;
wire [`SDMA_INST_SRCFMS2ADDRWIDTH-1:0] inst_srcfms2addr;
wire [`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0] inst_srcfms1concatelength;
wire [`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0] inst_srcfms2concatelength;
wire [`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0] inst_srcfms2movelength;
wire [`SDMA_INST_SRCFMSCWIDTH-1:0] inst_srcfmsc;
wire [`SDMA_INST_SRCFMSXWIDTH-1:0] inst_srcfmsx;
wire [`SDMA_INST_SRCFMSYWIDTH-1:0] inst_srcfmsy;
wire [`SDMA_INST_DSTFMSSTRIDE3WIDTH-1:0] inst_dstfmsstride3;
wire [`SDMA_INST_DSTFMSSTRIDE2WIDTH-1:0] inst_dstfmsstride2;
wire [`SDMA_INST_DSTFMSSTRIDE1WIDTH-1:0] inst_dstfmsstride1;
wire [`SDMA_INST_PADDINGAXISBEFOREWIDTH-1:0] inst_paddingaxisbefore;
wire [`SDMA_INST_PADDINGLEFTXWIDTH-1:0] inst_paddingleftx;
wire [`SDMA_INST_PADDINGRIGHTXWIDTH-1:0] inst_paddingrightx;
wire [`SDMA_INST_PADDINGLEFTYWIDTH-1:0] inst_paddinglefty;
wire [`SDMA_INST_PADDINGRIGHTYWIDTH-1:0] inst_paddingrighty;
wire [`SDMA_INST_INSERTZERONUMWIDTH-1:0] inst_insertzeronum;
wire [`SDMA_INST_INSERTZERONUMTOTALXWIDTH-1:0] inst_insertzeronumtotalx;
wire [`SDMA_INST_INSERTZERONUMTOTALYWIDTH-1:0] inst_insertzeronumtotaly;
wire [`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0] inst_cropfmsstride2;
wire [`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0] inst_cropfmsstride1;
wire [`SDMA_INST_CROPFMSCWIDTH-1:0] inst_cropfmsc;
wire [`SDMA_INST_CROPFMSXWIDTH-1:0] inst_cropfmsx;
wire [`SDMA_INST_CROPFMSYWIDTH-1:0] inst_cropfmsy;
wire [`SDMA_INST_CROPFMS2STRIDE2WIDTH-1:0] inst_cropfms2stride2;
wire [`SDMA_INST_CROPFMS2STRIDE1WIDTH-1:0] inst_cropfms2stride1;
wire [`SDMA_INST_CROPFMSCWIDTH-1:0] inst_cropfms2c;
wire [`SDMA_INST_CROPFMSXWIDTH-1:0] inst_cropfms2x;
wire [`SDMA_INST_CROPFMSYWIDTH-1:0] inst_cropfms2y;
wire								sdp_inputsectiondone;
wire 								sdp_outputsectiondone;
wire								sdp_parallelinoutsectiondone;
wire								sdp_parallelinoutempty;
wire								ssc_transfer_pending;
wire								ssc_transfer_done;
wire [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] ssc_num_of_remain_bytes;
wire								ssc_concate_fms_switch_flag;
wire								ssc_sapsdpen;
wire								sdp_ready;
wire								sport_ready;
wire								dport_ready;
wire [`SDMA_SECTION_DINNUMDATAWIDTH-1:0] sap_sdp_ldb_num;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sport_ren;
wire [`SDMA_ADDRWIDTH-1:0]			sport_raddr;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	dport_wen;
wire [`SDMA_ADDRWIDTH-1:0]			dport_waddr;
wire								sap_paddingflag;
wire								sap_upsampleflag;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sport_rvld;
wire [`SDMA_CACHEDATAWIDTH-1:0]		sport_rdata;
wire [`SDMA_CACHEDATAWIDTH-1:0]		dport_wdata;
//------------------------------------------------------------------------------

//----------------------------------SUBMODULE INSTANCE--------------------------
sdma_top_ctrl U_SDMA_TOP_CTRL_0(
  .clk                        (clk),
  .rst_n                      (rst_n),
  .i_stc_en                   (i_sdma_en),
  .i_stc_inst_vld             (i_sdma_inst_vld),
  .i_stc_inst                 (i_sdma_inst[`SDMA_INSTWIDTH-1:0]),
  .i_stc_sscready             (ssc_ready),
  .i_stc_ssctransferdone	  (ssc_transfer_done),
  .o_stc_sscen                (ssc_en),
  .o_stc_ready                (o_sdma_ready),
  .o_stc_sdmamode             (inst_sdmamode[`SDMA_INST_SDMAMODEWIDTH-1:0]),
  .o_stc_srcportid            (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .o_stc_dstportid            (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .o_stc_srcfmsaddr           (inst_srcfmsaddr[`SDMA_INST_SRCFMSADDRWIDTH-1:0]),
  .o_stc_dstfmsaddr           (inst_dstfmsaddr[`SDMA_INST_DSTFMSADDRWIDTH-1:0]),
  .o_stc_srcfmsmovelength     (inst_srcfmsmovelength[`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0]),
  .o_stc_srcfms2addr          (inst_srcfms2addr[`SDMA_INST_SRCFMS2ADDRWIDTH-1:0]),
  .o_stc_srcfms1concatelength (inst_srcfms1concatelength[`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0]),
  .o_stc_srcfms2concatelength (inst_srcfms2concatelength[`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0]),
  .o_stc_srcfms2movelength    (inst_srcfms2movelength[`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0]),
  .o_stc_srcfmsc              (inst_srcfmsc[`SDMA_INST_SRCFMSCWIDTH-1:0]),
  .o_stc_srcfmsx              (inst_srcfmsx[`SDMA_INST_SRCFMSXWIDTH-1:0]),
  .o_stc_srcfmsy              (inst_srcfmsy[`SDMA_INST_SRCFMSYWIDTH-1:0]),
  .o_stc_dstfmsstride3        (inst_dstfmsstride3[`SDMA_INST_DSTFMSSTRIDE3WIDTH-1:0]),
  .o_stc_dstfmsstride2        (inst_dstfmsstride2[`SDMA_INST_DSTFMSSTRIDE2WIDTH-1:0]),
  .o_stc_dstfmsstride1        (inst_dstfmsstride1[`SDMA_INST_DSTFMSSTRIDE1WIDTH-1:0]),
  .o_stc_paddingaxisbefore    (inst_paddingaxisbefore[`SDMA_INST_PADDINGAXISBEFOREWIDTH-1:0]),
  .o_stc_paddingleftx         (inst_paddingleftx[`SDMA_INST_PADDINGLEFTXWIDTH-1:0]),
  .o_stc_paddingrightx        (inst_paddingrightx[`SDMA_INST_PADDINGRIGHTXWIDTH-1:0]),
  .o_stc_paddinglefty         (inst_paddinglefty[`SDMA_INST_PADDINGLEFTYWIDTH-1:0]),
  .o_stc_paddingrighty        (inst_paddingrighty[`SDMA_INST_PADDINGRIGHTYWIDTH-1:0]),
  .o_stc_insertzeronum        (inst_insertzeronum[`SDMA_INST_INSERTZERONUMWIDTH-1:0]),
  .o_stc_insertzeronumtotalx  (inst_insertzeronumtotalx[`SDMA_INST_INSERTZERONUMTOTALXWIDTH-1:0]),
  .o_stc_insertzeronumtotaly  (inst_insertzeronumtotaly[`SDMA_INST_INSERTZERONUMTOTALYWIDTH-1:0]),
  .o_stc_cropfmsstride2		  (inst_cropfmsstride2[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]),
  .o_stc_cropfmsstride1       (inst_cropfmsstride1[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]),
  .o_stc_cropfmsc             (inst_cropfmsc[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_stc_cropfmsx             (inst_cropfmsx[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_stc_cropfmsy             (inst_cropfmsy[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .o_stc_cropfms2stride2	  (inst_cropfms2stride2[`SDMA_INST_CROPFMS2STRIDE2WIDTH-1:0]),
  .o_stc_cropfms2stride1      (inst_cropfms2stride1[`SDMA_INST_CROPFMS2STRIDE1WIDTH-1:0]),
  .o_stc_cropfms2c            (inst_cropfms2c[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_stc_cropfms2x            (inst_cropfms2x[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_stc_cropfms2y            (inst_cropfms2y[`SDMA_INST_CROPFMSYWIDTH-1:0])
);

sdma_section_ctrl U_SDMA_SECTION_CTRL_0(
  .clk                                (clk),
  .rst_n                              (rst_n),
  .i_ssc_en                           (ssc_en),
  .i_ssc_concateen                    (inst_sdmamode[4]),
  .i_ssc_srcfmsmovelength             (inst_srcfmsmovelength[`SDMA_INST_SRCFMSMOVELENGTHWIDTH-1:0]),
  .i_ssc_srcfms2movelength            (inst_srcfms2movelength[`SDMA_INST_SRCFMS2MOVELENGTHWIDTH-1:0]),
  .i_ssc_srcfms1concatelength         (inst_srcfms1concatelength[`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH-1:0]),
  .i_ssc_srcfms2concatelength         (inst_srcfms2concatelength[`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH-1:0]),
  .i_ssc_sdp_outputsectiondone        (sdp_outputsectiondone),
  .i_ssc_sdp_parallelinoutsectiondone (sdp_parallelinoutsectiondone),
  .o_ssc_transfer_pending             (ssc_transfer_pending),
  .o_ssc_transfer_done				  (ssc_transfer_done),
  .o_ssc_num_of_remain_bytes          (ssc_num_of_remain_bytes[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]),
  .o_ssc_concate_fms_switch_flag      (ssc_concate_fms_switch_flag),
  .o_ssc_sapsdpen                     (ssc_sapsdpen),
  .o_ssc_ready						  (ssc_ready)
);

sdma_addr_path U_SDMA_ADDR_PATH_0(
  .clk                                (clk),
  .rst_n                              (rst_n),
  .i_sap_en                           (ssc_sapsdpen),
  .i_sap_transfer_pending             (ssc_transfer_pending),
  .i_sap_num_of_remain_bytes          (ssc_num_of_remain_bytes[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]),
  .i_sap_concate_fms_switch_flag      (ssc_concate_fms_switch_flag),
  .i_sap_sdpmode                      ({inst_srcportid[2],inst_dstportid[2],inst_sdmamode[3]}),
  .i_sap_sdmamode                     (inst_sdmamode[`SDMA_INST_SDMAMODEWIDTH-1:0]),
  .i_sap_srcfmsaddr                   (inst_srcfmsaddr[`SDMA_INST_SRCFMSADDRWIDTH-1:0]),
  .i_sap_dstfmsaddr                   (inst_dstfmsaddr[`SDMA_INST_DSTFMSADDRWIDTH-1:0]),
  .i_sap_srcfms2addr                  (inst_srcfms2addr[`SDMA_INST_SRCFMS2ADDRWIDTH-1:0]),
  .i_sap_srcfmsc                      (inst_srcfmsc[`SDMA_INST_SRCFMSCWIDTH-1:0]),
  .i_sap_srcfmsx                      (inst_srcfmsx[`SDMA_INST_SRCFMSXWIDTH-1:0]),
  .i_sap_srcfmsy                      (inst_srcfmsy[`SDMA_INST_SRCFMSYWIDTH-1:0]),
  .i_sap_dstfmsstride3                (inst_dstfmsstride3[`SDMA_INST_DSTFMSSTRIDE3WIDTH-1:0]),
  .i_sap_dstfmsstride2                (inst_dstfmsstride2[`SDMA_INST_DSTFMSSTRIDE2WIDTH-1:0]),
  .i_sap_dstfmsstride1                (inst_dstfmsstride1[`SDMA_INST_DSTFMSSTRIDE1WIDTH-1:0]),
  .i_sap_paddingaxisbefore            (inst_paddingaxisbefore[`SDMA_INST_PADDINGAXISBEFOREWIDTH-1:0]),
  .i_sap_paddingleftx                 (inst_paddingleftx[`SDMA_INST_PADDINGLEFTXWIDTH-1:0]),
  .i_sap_paddingrightx                (inst_paddingrightx[`SDMA_INST_PADDINGRIGHTXWIDTH-1:0]),
  .i_sap_paddinglefty                 (inst_paddinglefty[`SDMA_INST_PADDINGLEFTYWIDTH-1:0]),
  .i_sap_paddingrighty                (inst_paddingrighty[`SDMA_INST_PADDINGRIGHTYWIDTH-1:0]),
  .i_sap_insertzeronum                (inst_insertzeronum[`SDMA_INST_INSERTZERONUMWIDTH-1:0]),
  .i_sap_insertzeronumtotalx          (inst_insertzeronumtotalx[`SDMA_INST_INSERTZERONUMTOTALXWIDTH-1:0]),
  .i_sap_insertzeronumtotaly          (inst_insertzeronumtotaly[`SDMA_INST_INSERTZERONUMTOTALYWIDTH-1:0]),
  .i_sap_cropfmsstride2				  (inst_cropfmsstride2[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]),
  .i_sap_cropfmsstride1               (inst_cropfmsstride1[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]),
  .i_sap_cropfmsc                     (inst_cropfmsc[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .i_sap_cropfmsx                     (inst_cropfmsx[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .i_sap_cropfmsy                     (inst_cropfmsy[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .i_sap_cropfms2stride2			  (inst_cropfms2stride2[`SDMA_INST_CROPFMS2STRIDE2WIDTH-1:0]),
  .i_sap_cropfms2stride1              (inst_cropfms2stride1[`SDMA_INST_CROPFMS2STRIDE1WIDTH-1:0]),
  .i_sap_cropfms2c                    (inst_cropfms2c[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .i_sap_cropfms2x                    (inst_cropfms2x[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .i_sap_cropfms2y                    (inst_cropfms2y[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .i_sap_sdp_ready                    (sdp_ready),
  .i_sap_sdp_inputsectiondone         (sdp_inputsectiondone),
  .i_sap_sdp_outputsectiondone        (sdp_outputsectiondone),
  .i_sap_sdp_parallelinoutsectiondone (sdp_parallelinoutsectiondone),
  .i_sap_sdp_parallelinoutempty		  (sdp_parallelinoutempty),
  .i_sap_sport_ready                  (sport_ready),
  .i_sap_dport_ready                  (dport_ready),
  .o_sap_sdp_ldb_num                  (sap_sdp_ldb_num[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]),
  .o_sap_sport_ren                    (sport_ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sap_sport_raddr                  (sport_raddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sap_dport_wen                    (dport_wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sap_dport_waddr                  (dport_waddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sap_padding_flag	              (sap_paddingflag),
  .o_sap_upsample_flag				  (sap_upsampleflag)
);

sdma_data_path U_SDMA_DATA_PATH_0(
  .clk                                (clk),
  .rst_n                              (rst_n),
  .i_sdp_en                           (ssc_sapsdpen),
  .i_sdp_transfer_pending             (ssc_transfer_pending),
  .i_sdp_num_of_remain_bytes          (ssc_num_of_remain_bytes[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]),
  .i_sdp_mode                         ({inst_srcportid[2],inst_dstportid[2],inst_sdmamode[3]}),
  .i_sdp_din_strb                     (sport_rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdp_din_vld                      (|(sport_rvld)),
  .i_sdp_din                          (sport_rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdp_dout_ready                   (dport_ready),
  .i_sdp_dout_ldb_num                 (sap_sdp_ldb_num[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]),
  .i_sdp_paddingflag 	              (sap_paddingflag),
  .i_sdp_upsampleflag				  (sap_upsampleflag),
  .o_sdp_din_ready                    (sdp_ready),
  .o_sdp_dout                         (dport_wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdp_input_section_done           (sdp_inputsectiondone),
  .o_sdp_output_section_done          (sdp_outputsectiondone),
  .o_sdp_parallelinout_section_done   (sdp_parallelinoutsectiondone),
  .o_sdp_parallelinout_empty		  (sdp_parallelinoutempty)
);

sdma_addr_mux U_SDMA_ADDR_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_sportraddr (sport_raddr[`SDMA_ADDRWIDTH-1:0]),
  .i_sdma_sportren   (sport_ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_dportwaddr (dport_waddr[`SDMA_ADDRWIDTH-1:0]),
  .i_sdma_dportwen   (dport_wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_ahbaddr    (o_sdma_ahbaddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_ahbwea     (o_sdma_ahbwea),
  .o_sdma_ahbena     (o_sdma_ahbena[`SDMA_AHBDATAWIDTH/8-1:0]),
  .o_sdma_dc1addr    (o_sdma_dc1addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc1wea     (o_sdma_dc1wea),
  .o_sdma_dc1ena     (o_sdma_dc1ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc2addr    (o_sdma_dc2addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc2wea     (o_sdma_dc2wea),
  .o_sdma_dc2ena     (o_sdma_dc2ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc1addr    (o_sdma_wc1addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc1wea     (o_sdma_wc1wea),
  .o_sdma_wc1ena     (o_sdma_wc1ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc2addr    (o_sdma_wc2addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc2wea     (o_sdma_wc2wea),
  .o_sdma_wc2ena     (o_sdma_wc2ena[`SDMA_CACHEDATAWIDTH/8-1:0])
);

sdma_ready_mux U_SDMA_READY_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_ahbready   (i_sdma_ahbready),
  .i_sdma_dc1ready   (i_sdma_dc1ready),
  .i_sdma_dc2ready   (i_sdma_dc2ready),
  .i_sdma_wc1ready   (i_sdma_wc1ready),
  .i_sdma_wc2ready   (i_sdma_wc2ready),
  .o_sdma_sportready (sport_ready),
  .o_sdma_dportready (dport_ready)
);

sdma_rdata_mux U_SDMA_RDATA_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_sdma_ahbrdata   (i_sdma_ahbrdata[`SDMA_AHBDATAWIDTH-1:0]),
  .i_sdma_ahbrvld    (i_sdma_ahbrvld[`SDMA_AHBDATAWIDTH/8-1:0]),
  .i_sdma_dc1rdata   (i_sdma_dc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc1rvld    (i_sdma_dc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_dc2rdata   (i_sdma_dc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc2rvld    (i_sdma_dc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc1rdata   (i_sdma_wc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc1rvld    (i_sdma_wc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc2rdata   (i_sdma_wc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc2rvld    (i_sdma_wc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_sportrdata (sport_rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_sportrvld  (sport_rvld[`SDMA_CACHEDATAWIDTH/8-1:0])
);

sdma_wdata_mux U_SDMA_WDATA_MUX_0(
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_dportwdata (dport_wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_ahbwdata   (o_sdma_ahbwdata[`SDMA_AHBDATAWIDTH-1:0]),
  .o_sdma_dc1wdata   (o_sdma_dc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_dc2wdata   (o_sdma_dc2wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc1wdata   (o_sdma_wc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc2wdata   (o_sdma_wc2wdata[`SDMA_CACHEDATAWIDTH-1:0])
);


//------------------------------------------------------------------------------
endmodule
