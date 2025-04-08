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
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module nnu_general_moving
#(
	parameter        TGT_WMEM_SUB_SADDR_ENA            = 1,    			   // if 1: out_addr = in_addr - SADDR
    parameter        TGT_WMEM_SADDR                    = 32'h0000_0000,    // Target Weight Memory Start Address
    parameter        TGT_WMEM_EADDR                    = 32'h0000_0FFF,    // Target Weight Memory End Address (i.e. TGT_WMEM_SADDR + Byte Number of Weight Memory - 1)
    parameter        TGT_BMEM_SUB_SADDR_ENA            = 1,    			   // if 1: out_addr = in_addr - SADDR
    parameter        TGT_BMEM_SADDR                    = 32'h0000_1000,    // Target Bias Memory Start Address
    parameter        TGT_BMEM_EADDR                    = 32'h0000_13FF	   // Target Bias Memory End Address (i.e. TGT_BMEM_SADDR + Byte Number of Bias Memory - 1)
)
(
	input										i_clk,
	input										i_rst_n,
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
	output 										o_sdma_wc2wea,
	//BCACHE1
    input                                       i_sdma_bc1ready,
    input  [`SDMA_CACHEDATAWIDTH/4-1:0]         i_sdma_bc1rdata,
    input  [`SDMA_CACHEDATAWIDTH/32-1:0]        i_sdma_bc1rvld,
    output [`SDMA_ADDRWIDTH-1:0]                o_sdma_bc1addr,
    output [`SDMA_CACHEDATAWIDTH/32-1:0]        o_sdma_bc1ena,
    output [`SDMA_CACHEDATAWIDTH/4-1:0]         o_sdma_bc1wdata,
    output                                      o_sdma_bc1wea,
    //BCACHE2
    input                                       i_sdma_bc2ready,
    input  [`SDMA_CACHEDATAWIDTH/4-1:0]         i_sdma_bc2rdata,
    input  [`SDMA_CACHEDATAWIDTH/32-1:0]        i_sdma_bc2rvld,
    output [`SDMA_ADDRWIDTH-1:0]                o_sdma_bc2addr,
    output [`SDMA_CACHEDATAWIDTH/32-1:0]        o_sdma_bc2ena,
    output [`SDMA_CACHEDATAWIDTH/4-1:0]         o_sdma_bc2wdata,
    output                                      o_sdma_bc2wea,
	//signal mnt
	output [9:0]								o_sdma_sigmnt1,
	output [9:0]								o_sdma_sigmnt2,
	output [9:0]								o_sdma_sigmnt3,
	output [9:0]								o_sdma_sigmnt4,
	output [9:0]								o_sdma_sigmnt5,
	output [9:0]								o_sdma_sigmnt6,
	output [9:0]								o_sdma_sigmnt7
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
wire [`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0]	inst_upsampleidxx;
wire [`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0]	inst_upsampleidxy;
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
//2025.03.22 added
wire [`SDMA_INST_SRCFMSCYCSADDRWIDTH-1:0] inst_srcfmscycsaddr;
wire [`SDMA_INST_SRCFMSCYCEADDRWIDTH-1:0] inst_srcfmscyceaddr;
wire [`SDMA_INST_SRCFMSCYCALIGNENAWIDTH-1:0] inst_srcfmscycalignena;
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

//2025.03.12 added
wire								sdma_ready_old;
assign	o_sdma_ready = sdma_ready_old & (~i_sdma_inst_vld);

//2025.03.17 added
wire								virtual_wc1ready;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	virtual_wc1rdata;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	virtual_wc1rvld;
wire  [`SDMA_ADDRWIDTH-1:0]			virtual_wc1addr;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	virtual_wc1ena;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	virtual_wc1wdata;
wire 								virtual_wc1wea;
			
wire								virtual_wc2ready;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	virtual_wc2rdata;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	virtual_wc2rvld;
wire  [`SDMA_ADDRWIDTH-1:0]			virtual_wc2addr;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	virtual_wc2ena;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	virtual_wc2wdata;
wire 								virtual_wc2wea;

wire								convert_bc1ready;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	convert_bc1rdata;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	convert_bc1rvld;
wire  [`SDMA_ADDRWIDTH-1:0]			convert_bc1addr;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	convert_bc1ena;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	convert_bc1wdata;
wire 								convert_bc1wea;
			
wire								convert_bc2ready;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	convert_bc2rdata;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	convert_bc2rvld;
wire  [`SDMA_ADDRWIDTH-1:0]			convert_bc2addr;
wire  [`SDMA_CACHEDATAWIDTH/8-1:0]	convert_bc2ena;
wire  [`SDMA_CACHEDATAWIDTH-1:0]	convert_bc2wdata;
wire 								convert_bc2wea;

wire								align_ahbready;
wire  [`SDMA_AHBDATAWIDTH-1:0]		align_ahbrdata;
wire  [`SDMA_AHBDATAWIDTH/8-1:0]	align_ahbrvld;
wire  [`SDMA_ADDRWIDTH-1:0]			align_ahbaddr;
wire  [`SDMA_AHBDATAWIDTH/8-1:0]	align_ahbena;
wire  [`SDMA_AHBDATAWIDTH-1:0]		align_ahbwdata;
wire 								align_ahbwea;


//------------------------------------------------------------------------------

//----------------------------------SUBMODULE INSTANCE--------------------------
sdma_top_ctrl U_SDMA_TOP_CTRL_0(
  .clk                        (i_clk),
  .rst_n                      (i_rst_n),
  .i_stc_en                   (i_sdma_en),
  .i_stc_inst_vld             (i_sdma_inst_vld),
  .i_stc_inst                 (i_sdma_inst[`SDMA_INSTWIDTH-1:0]),
  .i_stc_sscready             (ssc_ready),
  .i_stc_ssctransferdone	  (ssc_transfer_done),
  .o_stc_sscen                (ssc_en),
  .o_stc_ready                (sdma_ready_old),
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
  .o_stc_upsampleidxx		  (inst_upsampleidxx[`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0]),
  .o_stc_upsampleidxy		  (inst_upsampleidxy[`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0]),
  .o_stc_cropfmsstride2		  (inst_cropfmsstride2[`SDMA_INST_CROPFMSSTRIDE2WIDTH-1:0]),
  .o_stc_cropfmsstride1       (inst_cropfmsstride1[`SDMA_INST_CROPFMSSTRIDE1WIDTH-1:0]),
  .o_stc_cropfmsc             (inst_cropfmsc[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_stc_cropfmsx             (inst_cropfmsx[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_stc_cropfmsy             (inst_cropfmsy[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .o_stc_cropfms2stride2	  (inst_cropfms2stride2[`SDMA_INST_CROPFMS2STRIDE2WIDTH-1:0]),
  .o_stc_cropfms2stride1      (inst_cropfms2stride1[`SDMA_INST_CROPFMS2STRIDE1WIDTH-1:0]),
  .o_stc_cropfms2c            (inst_cropfms2c[`SDMA_INST_CROPFMSCWIDTH-1:0]),
  .o_stc_cropfms2x            (inst_cropfms2x[`SDMA_INST_CROPFMSXWIDTH-1:0]),
  .o_stc_cropfms2y            (inst_cropfms2y[`SDMA_INST_CROPFMSYWIDTH-1:0]),
  .o_stc_srcfmscycsaddr		  (inst_srcfmscycsaddr[`SDMA_INST_SRCFMSCYCSADDRWIDTH-1:0]),
  .o_stc_srcfmscyceaddr		  (inst_srcfmscyceaddr[`SDMA_INST_SRCFMSCYCEADDRWIDTH-1:0]),
  .o_stc_srcfmscycalignena	  (inst_srcfmscycalignena[`SDMA_INST_SRCFMSCYCALIGNENAWIDTH-1:0]),
  .o_stc_sigmnt1			  (o_sdma_sigmnt1),
  .o_stc_sigmnt2			  (o_sdma_sigmnt2)
);

sdma_section_ctrl U_SDMA_SECTION_CTRL_0(
  .clk                                (i_clk),
  .rst_n                              (i_rst_n),
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
  .o_ssc_ready						  (ssc_ready),
  .o_ssc_sigmnt1					  (o_sdma_sigmnt3),
  .o_ssc_sigmnt2					  (o_sdma_sigmnt4)
);

sdma_addr_path U_SDMA_ADDR_PATH_0(
  .clk                                (i_clk),
  .rst_n                              (i_rst_n),
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
  .i_sap_upsampleidxx				  (inst_upsampleidxx[`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0]),
  .i_sap_upsampleidxy				  (inst_upsampleidxy[`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0]),
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
  .o_sap_upsample_flag				  (sap_upsampleflag),
  .o_sap_sigmnt1					  (o_sdma_sigmnt5),
  .o_sap_sigmnt2					  (o_sdma_sigmnt6)
);

sdma_data_path U_SDMA_DATA_PATH_0(
  .clk                                (i_clk),
  .rst_n                              (i_rst_n),
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
  .o_sdp_parallelinout_empty		  (sdp_parallelinoutempty),
  .o_sdp_sigmnt1					  (o_sdma_sigmnt7)
);

sdma_addr_mux U_SDMA_ADDR_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_sportraddr (sport_raddr[`SDMA_ADDRWIDTH-1:0]),
  .i_sdma_sportren   (sport_ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_dportwaddr (dport_waddr[`SDMA_ADDRWIDTH-1:0]),
  .i_sdma_dportwen   (dport_wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_ahbaddr    (align_ahbaddr),
  .o_sdma_ahbwea     (align_ahbwea),
  .o_sdma_ahbena     (align_ahbena),
  .o_sdma_dc1addr    (o_sdma_dc1addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc1wea     (o_sdma_dc1wea),
  .o_sdma_dc1ena     (o_sdma_dc1ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc2addr    (o_sdma_dc2addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc2wea     (o_sdma_dc2wea),
  .o_sdma_dc2ena     (o_sdma_dc2ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc1addr    (virtual_wc1addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc1wea     (virtual_wc1wea),
  .o_sdma_wc1ena     (virtual_wc1ena[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc2addr    (virtual_wc2addr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc2wea     (virtual_wc2wea),
  .o_sdma_wc2ena     (virtual_wc2ena[`SDMA_CACHEDATAWIDTH/8-1:0])
);

sdma_ready_mux U_SDMA_READY_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_ahbready   (align_ahbready),
  .i_sdma_dc1ready   (i_sdma_dc1ready),
  .i_sdma_dc2ready   (i_sdma_dc2ready),
  .i_sdma_wc1ready   (virtual_wc1ready),
  .i_sdma_wc2ready   (virtual_wc2ready),
  .o_sdma_sportready (sport_ready),
  .o_sdma_dportready (dport_ready)
);

sdma_rdata_mux U_SDMA_RDATA_MUX_0(
  .i_inst_srcportid  (inst_srcportid[`SDMA_INST_SRCPORTIDWIDTH-1:0]),
  .i_sdma_ahbrdata   (align_ahbrdata),
  .i_sdma_ahbrvld    (align_ahbrvld),
  .i_sdma_dc1rdata   (i_sdma_dc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc1rvld    (i_sdma_dc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_dc2rdata   (i_sdma_dc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc2rvld    (i_sdma_dc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc1rdata   (virtual_wc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc1rvld    (virtual_wc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc2rdata   (virtual_wc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc2rvld    (virtual_wc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_sportrdata (sport_rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_sportrvld  (sport_rvld[`SDMA_CACHEDATAWIDTH/8-1:0])
);

sdma_wdata_mux U_SDMA_WDATA_MUX_0(
  .i_inst_dstportid  (inst_dstportid[`SDMA_INST_DSTPORTIDWIDTH-1:0]),
  .i_sdma_dportwdata (dport_wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_ahbwdata   (align_ahbwdata),
  .o_sdma_dc1wdata   (o_sdma_dc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_dc2wdata   (o_sdma_dc2wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc1wdata   (virtual_wc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc2wdata   (virtual_wc2wdata[`SDMA_CACHEDATAWIDTH-1:0])
);

rram_addr_demux #(
  .RRAM_DATA_WIDTH            (512),              
  .RRAM_ADDR_WIDTH            (32),               
  .RRAM_PARAL_NUM             (64),               
  .RRAM_TGT0_SUB_SADDR_ENA    (1),                
  .RRAM_TGT0_SADDR            (32'h0000_0000),    
  .RRAM_TGT0_EADDR            (32'h0000_0FFF),    
  .RRAM_TGT1_SUB_SADDR_ENA    (1),                
  .RRAM_TGT1_SADDR            (32'h0000_1000),    
  .RRAM_TGT1_EADDR            (32'h0000_13FF),
  .RRAM_RDCNT_WIDTH			  (8)
) VIRTUAL_WC1_ADDR_DEMUX(
  .i_clk                      (i_clk),       
  .i_arst_n                   (i_rst_n),     
  .o_rram_s0_rdata            (virtual_wc1rdata), 
  .o_rram_s0_rdata_vld        (virtual_wc1rvld),
  .o_rram_s0_ready            (virtual_wc1ready),
  .o_rram_s0_error			  (),

  .i_rram_s0_ena              (virtual_wc1ena),    
  .i_rram_s0_wea              (virtual_wc1wea),    
  .i_rram_s0_addr             (virtual_wc1addr),   
  .i_rram_s0_wdata            (virtual_wc1wdata),  
  
  .i_rram_t0_rdata            (i_sdma_wc1rdata),
  .i_rram_t0_rdata_vld        (i_sdma_wc1rvld),
  .i_rram_t0_ready            (i_sdma_wc1ready),
  .i_rram_t0_error            (1'b0),

  .o_rram_t0_ena              (o_sdma_wc1ena),
  .o_rram_t0_wea              (o_sdma_wc1wea),
  .o_rram_t0_addr             (o_sdma_wc1addr),
  .o_rram_t0_wdata            (o_sdma_wc1wdata),

  .i_rram_t1_rdata            (convert_bc1rdata),
  .i_rram_t1_rdata_vld        (convert_bc1rvld),
  .i_rram_t1_ready            (convert_bc1ready),
  .i_rram_t1_error            (1'b0),

  .o_rram_t1_ena              (convert_bc1ena),
  .o_rram_t1_wea              (convert_bc1wea),
  .o_rram_t1_addr             (convert_bc1addr),
  .o_rram_t1_wdata            (convert_bc1wdata)
);

rram_width_reducer #(
    .RRAM0_DATA_WIDTH(512),
    .RRAM0_PARAL_NUM(64),
    .RRAM1_DATA_WIDTH(128),
    .RRAM1_PARAL_NUM(16),
    .RRAMX_ADDR_WIDTH(32)
) BC1_CONVERTER(
  .i_clk(i_clk),
  .i_arst_n(i_rst_n),

  .o_rram_d0_rdata(convert_bc1rdata),
  .o_rram_d0_rdata_vld(convert_bc1rvld),
  .o_rram_d0_ready(convert_bc1ready),
  .o_rram_d0_error(),
  .i_rram_d0_ena(convert_bc1ena),
  .i_rram_d0_wea(convert_bc1wea),
  .i_rram_d0_addr(convert_bc1addr),
  .i_rram_d0_wdata(convert_bc1wdata),

  .i_rram_d1_rdata(i_sdma_bc1rdata),
  .i_rram_d1_rdata_vld(i_sdma_bc1rvld),
  .i_rram_d1_ready(i_sdma_bc1ready),
  .i_rram_d1_error(1'b0),
  .o_rram_d1_ena(o_sdma_bc1ena),
  .o_rram_d1_wea(o_sdma_bc1wea),
  .o_rram_d1_addr(o_sdma_bc1addr),
  .o_rram_d1_wdata(o_sdma_bc1wdata)
);

rram_addr_demux #(
  .RRAM_DATA_WIDTH            (512),              
  .RRAM_ADDR_WIDTH            (32),               
  .RRAM_PARAL_NUM             (64),               
  .RRAM_TGT0_SUB_SADDR_ENA    (TGT_WMEM_SUB_SADDR_ENA),                
  .RRAM_TGT0_SADDR            (TGT_WMEM_SADDR),    
  .RRAM_TGT0_EADDR            (TGT_WMEM_EADDR),    
  .RRAM_TGT1_SUB_SADDR_ENA    (TGT_BMEM_SUB_SADDR_ENA),                
  .RRAM_TGT1_SADDR            (TGT_BMEM_SADDR),    
  .RRAM_TGT1_EADDR            (TGT_BMEM_EADDR),
  .RRAM_RDCNT_WIDTH			  (8)
) VIRTUAL_WC2_ADDR_DEMUX(
  .i_clk                      (i_clk),       
  .i_arst_n                   (i_rst_n),     
  .o_rram_s0_rdata            (virtual_wc2rdata), 
  .o_rram_s0_rdata_vld        (virtual_wc2rvld),
  .o_rram_s0_ready            (virtual_wc2ready),
  .o_rram_s0_error			  (),

  .i_rram_s0_ena              (virtual_wc2ena),    
  .i_rram_s0_wea              (virtual_wc2wea),    
  .i_rram_s0_addr             (virtual_wc2addr),   
  .i_rram_s0_wdata            (virtual_wc2wdata),  
  
  .i_rram_t0_rdata            (i_sdma_wc2rdata),
  .i_rram_t0_rdata_vld        (i_sdma_wc2rvld),
  .i_rram_t0_ready            (i_sdma_wc2ready),
  .i_rram_t0_error            (1'b0),

  .o_rram_t0_ena              (o_sdma_wc2ena),
  .o_rram_t0_wea              (o_sdma_wc2wea),
  .o_rram_t0_addr             (o_sdma_wc2addr),
  .o_rram_t0_wdata            (o_sdma_wc2wdata),

  .i_rram_t1_rdata            (convert_bc2rdata),
  .i_rram_t1_rdata_vld        (convert_bc2rvld),
  .i_rram_t1_ready            (convert_bc2ready),
  .i_rram_t1_error            (1'b0),

  .o_rram_t1_ena              (convert_bc2ena),
  .o_rram_t1_wea              (convert_bc2wea),
  .o_rram_t1_addr             (convert_bc2addr),
  .o_rram_t1_wdata            (convert_bc2wdata)
);

rram_width_reducer #(
    .RRAM0_DATA_WIDTH(512),
    .RRAM0_PARAL_NUM(64),
    .RRAM1_DATA_WIDTH(128),
    .RRAM1_PARAL_NUM(16),
    .RRAMX_ADDR_WIDTH(32)
) BC2_CONVERTER(
  .i_clk(i_clk),
  .i_arst_n(i_rst_n),

  .o_rram_d0_rdata(convert_bc2rdata),
  .o_rram_d0_rdata_vld(convert_bc2rvld),
  .o_rram_d0_ready(convert_bc2ready),
  .o_rram_d0_error(),
  .i_rram_d0_ena(convert_bc2ena),
  .i_rram_d0_wea(convert_bc2wea),
  .i_rram_d0_addr(convert_bc2addr),
  .i_rram_d0_wdata(convert_bc2wdata),

  .i_rram_d1_rdata(i_sdma_bc2rdata),
  .i_rram_d1_rdata_vld(i_sdma_bc2rvld),
  .i_rram_d1_ready(i_sdma_bc2ready),
  .i_rram_d1_error(1'b0),
  .o_rram_d1_ena(o_sdma_bc2ena),
  .o_rram_d1_wea(o_sdma_bc2wea),
  .o_rram_d1_addr(o_sdma_bc2addr),
  .o_rram_d1_wdata(o_sdma_bc2wdata)
);

rram_addr_cyc_align#(
	.RRAM_ADDR_WIDTH(32),	
	.RRAM_DATA_WIDTH(128),	
	.RRAM_PARAL_NUM(16)
	)U_RRAM_ADDR_CYC_ALIGN_0(
  .i_rram_d0_rd_aca_ena (inst_srcfmscycalignena),
  .i_rram_d0_wr_aca_ena (1'b0),
  .i_rram_d1_saddr      (inst_srcfmscycsaddr),
  .i_rram_d1_eaddr      (inst_srcfmscyceaddr),
  .i_rram_d0_ena        (align_ahbena),
  .i_rram_d0_wea        (align_ahbwea),
  .i_rram_d0_addr       (align_ahbaddr),
  .i_rram_d0_wdata      (align_ahbwdata),
  .i_rram_d1_rdata      (i_sdma_ahbrdata),
  .i_rram_d1_rdata_vld  (i_sdma_ahbrvld),
  .i_rram_d1_ready      (i_sdma_ahbready),
  .i_rram_d1_error      (1'b0),
  .o_rram_d0_rdata      (align_ahbrdata),
  .o_rram_d0_rdata_vld  (align_ahbrvld),
  .o_rram_d0_ready      (align_ahbready),
  .o_rram_d0_error		(),
  .o_rram_d1_ena        (o_sdma_ahbena),
  .o_rram_d1_wea        (o_sdma_ahbwea),
  .o_rram_d1_addr       (o_sdma_ahbaddr),
  .o_rram_d1_wdata      (o_sdma_ahbwdata)
);

endmodule
