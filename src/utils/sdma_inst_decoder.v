// -----------------------------------------------------------------------------
// FILE NAME : sdma_inst_decoder.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2025-1-13
// -----------------------------------------------------------------------------
// DESCRIPTION : Decode instruction and dispatch it to different sub-module.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_inst_decoder
(
	input  	[`SDMA_INSTWIDTH - 1:0]				   		i_sid_inst,
	output  [`SDMA_INST_SDMAMODEWIDTH - 1:0]  			o_sid_sdmamode,
	output  [`SDMA_INST_SRCPORTIDWIDTH - 1:0]  			o_sid_srcportid,
	output  [`SDMA_INST_DSTPORTIDWIDTH - 1:0]  			o_sid_dstportid,
	output  [`SDMA_INST_SRCFMSADDRWIDTH - 1:0]  		o_sid_srcfmsaddr,
	output  [`SDMA_INST_DSTFMSADDRWIDTH - 1:0]  		o_sid_dstfmsaddr,
	output  [`SDMA_INST_SRCFMSMOVELENGTHWIDTH - 1:0]  	o_sid_srcfmsmovelength,
	output  [`SDMA_INST_SRCFMS2ADDRWIDTH - 1:0]  		o_sid_srcfms2addr,
	output  [`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH - 1:0]o_sid_srcfms1concatelength,
	output  [`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH - 1:0]o_sid_srcfms2concatelength,
	output  [`SDMA_INST_SRCFMS2MOVELENGTHWIDTH - 1:0]  	o_sid_srcfms2movelength,
	output  [`SDMA_INST_SRCFMSCWIDTH - 1:0]  			o_sid_srcfmsc,
	output  [`SDMA_INST_SRCFMSXWIDTH - 1:0]  			o_sid_srcfmsx,
	output  [`SDMA_INST_SRCFMSYWIDTH - 1:0]  			o_sid_srcfmsy,
	output  [`SDMA_INST_DSTFMSSTRIDE3WIDTH - 1:0]  		o_sid_dstfmsstride3,
	output  [`SDMA_INST_DSTFMSSTRIDE2WIDTH - 1:0]  		o_sid_dstfmsstride2,
	output  [`SDMA_INST_DSTFMSSTRIDE1WIDTH - 1:0]  		o_sid_dstfmsstride1,
	output	[`SDMA_INST_PADDINGAXISBEFOREWIDTH - 1:0]	o_sid_paddingaxisbefore,
	output  [`SDMA_INST_PADDINGLEFTXWIDTH - 1:0]  		o_sid_paddingleftx,
	output  [`SDMA_INST_PADDINGRIGHTXWIDTH - 1:0]  		o_sid_paddingrightx,
	output  [`SDMA_INST_PADDINGLEFTYWIDTH - 1:0]  		o_sid_paddinglefty,
	output  [`SDMA_INST_PADDINGRIGHTYWIDTH - 1:0]  		o_sid_paddingrighty,
	output  [`SDMA_INST_INSERTZERONUMWIDTH - 1:0]  		o_sid_insertzeronum,
	output  [`SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1:0] o_sid_insertzeronumtotalx,
	output  [`SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1:0] o_sid_insertzeronumtotaly,
	output	[`SDMA_INST_UPSAMPLEIDXXWIDTH - 1:0]		o_sid_upsampleidxx,
	output	[`SDMA_INST_UPSAMPLEIDXYWIDTH - 1:0]		o_sid_upsampleidxy,
	output  [`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0]  	o_sid_cropfmsstride2,
	output  [`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0]  	o_sid_cropfmsstride1,
	output  [`SDMA_INST_CROPFMSCWIDTH - 1:0]  			o_sid_cropfmsc,
	output  [`SDMA_INST_CROPFMSXWIDTH - 1:0]  			o_sid_cropfmsx,
	output  [`SDMA_INST_CROPFMSYWIDTH - 1:0]  			o_sid_cropfmsy,
	output  [`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0]  	o_sid_cropfms2stride2,
	output  [`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0]  	o_sid_cropfms2stride1,
	output  [`SDMA_INST_CROPFMSCWIDTH - 1:0]  			o_sid_cropfms2c,
	output  [`SDMA_INST_CROPFMSXWIDTH - 1:0]  			o_sid_cropfms2x,
	output  [`SDMA_INST_CROPFMSYWIDTH - 1:0]  			o_sid_cropfms2y,
	output	[`SDMA_INST_SRCFMSCYCSADDRWIDTH - 1:0]		o_sid_srcfmscycsaddr,
	output  [`SDMA_INST_SRCFMSCYCEADDRWIDTH - 1:0]		o_sid_srcfmscyceaddr,
	output  [`SDMA_INST_SRCFMSCYCALIGNENAWIDTH - 1:0]	o_sid_srcfmscycalignena,
	output	[`SDMA_INST_SHUFFLEIDXWIDTH -1:0]			o_sid_shuffleidx
);


//----------------------------------OUTPUT LOGIC--------------------------------
assign o_sid_sdmamode = i_sid_inst[`SDMA_INST_SDMAMODESTART + `SDMA_INST_SDMAMODEWIDTH - 1 : `SDMA_INST_SDMAMODESTART];
assign o_sid_srcportid = i_sid_inst[`SDMA_INST_SRCPORTIDSTART + `SDMA_INST_SRCPORTIDWIDTH - 1 : `SDMA_INST_SRCPORTIDSTART];
assign o_sid_dstportid = i_sid_inst[`SDMA_INST_DSTPORTIDSTART + `SDMA_INST_DSTPORTIDWIDTH - 1 : `SDMA_INST_DSTPORTIDSTART];
assign o_sid_srcfmsaddr = i_sid_inst[`SDMA_INST_SRCFMSADDRSTART + `SDMA_INST_SRCFMSADDRWIDTH - 1 : `SDMA_INST_SRCFMSADDRSTART];
assign o_sid_dstfmsaddr = i_sid_inst[`SDMA_INST_DSTFMSADDRSTART + `SDMA_INST_DSTFMSADDRWIDTH - 1 : `SDMA_INST_DSTFMSADDRSTART];
assign o_sid_srcfmsmovelength = i_sid_inst[`SDMA_INST_SRCFMSMOVELENGTHSTART + `SDMA_INST_SRCFMSMOVELENGTHWIDTH - 1 : `SDMA_INST_SRCFMSMOVELENGTHSTART];
assign o_sid_srcfms2addr = i_sid_inst[`SDMA_INST_SRCFMS2ADDRSTART + `SDMA_INST_SRCFMS2ADDRWIDTH - 1 : `SDMA_INST_SRCFMS2ADDRSTART];
assign o_sid_srcfms1concatelength = i_sid_inst[`SDMA_INST_SRCFMS1CONCATELENGTHSTART + `SDMA_INST_SRCFMS1CONCATELENGTHWIDTH - 1 : `SDMA_INST_SRCFMS1CONCATELENGTHSTART];
assign o_sid_srcfms2concatelength = i_sid_inst[`SDMA_INST_SRCFMS2CONCATELENGTHSTART + `SDMA_INST_SRCFMS2CONCATELENGTHWIDTH - 1 : `SDMA_INST_SRCFMS2CONCATELENGTHSTART];
assign o_sid_srcfms2movelength = i_sid_inst[`SDMA_INST_SRCFMS2MOVELENGTHSTART + `SDMA_INST_SRCFMS2MOVELENGTHWIDTH - 1 : `SDMA_INST_SRCFMS2MOVELENGTHSTART];
assign o_sid_srcfmsc = i_sid_inst[`SDMA_INST_SRCFMSCSTART + `SDMA_INST_SRCFMSCWIDTH - 1 : `SDMA_INST_SRCFMSCSTART];
assign o_sid_srcfmsx = i_sid_inst[`SDMA_INST_SRCFMSXSTART + `SDMA_INST_SRCFMSXWIDTH - 1 : `SDMA_INST_SRCFMSXSTART];
assign o_sid_srcfmsy = i_sid_inst[`SDMA_INST_SRCFMSYSTART + `SDMA_INST_SRCFMSYWIDTH - 1 : `SDMA_INST_SRCFMSYSTART];
assign o_sid_dstfmsstride3 = i_sid_inst[`SDMA_INST_DSTFMSSTRIDE3START + `SDMA_INST_DSTFMSSTRIDE3WIDTH - 1 : `SDMA_INST_DSTFMSSTRIDE3START];
assign o_sid_dstfmsstride2 = i_sid_inst[`SDMA_INST_DSTFMSSTRIDE2START + `SDMA_INST_DSTFMSSTRIDE2WIDTH - 1 : `SDMA_INST_DSTFMSSTRIDE2START];
assign o_sid_dstfmsstride1 = i_sid_inst[`SDMA_INST_DSTFMSSTRIDE1START + `SDMA_INST_DSTFMSSTRIDE1WIDTH - 1 : `SDMA_INST_DSTFMSSTRIDE1START];
assign o_sid_paddingaxisbefore = i_sid_inst[`SDMA_INST_PADDINGAXISBEFORESTART + `SDMA_INST_PADDINGAXISBEFOREWIDTH - 1 : `SDMA_INST_PADDINGAXISBEFORESTART];
assign o_sid_paddingleftx = i_sid_inst[`SDMA_INST_PADDINGLEFTXSTART + `SDMA_INST_PADDINGLEFTXWIDTH - 1 : `SDMA_INST_PADDINGLEFTXSTART];
assign o_sid_paddingrightx = i_sid_inst[`SDMA_INST_PADDINGRIGHTXSTART + `SDMA_INST_PADDINGRIGHTXWIDTH - 1 : `SDMA_INST_PADDINGRIGHTXSTART];
assign o_sid_paddinglefty = i_sid_inst[`SDMA_INST_PADDINGLEFTYSTART + `SDMA_INST_PADDINGLEFTYWIDTH - 1 : `SDMA_INST_PADDINGLEFTYSTART];
assign o_sid_paddingrighty = i_sid_inst[`SDMA_INST_PADDINGRIGHTYSTART + `SDMA_INST_PADDINGRIGHTYWIDTH - 1 : `SDMA_INST_PADDINGRIGHTYSTART];
assign o_sid_insertzeronum = i_sid_inst[`SDMA_INST_INSERTZERONUMSTART + `SDMA_INST_INSERTZERONUMWIDTH - 1 : `SDMA_INST_INSERTZERONUMSTART];
assign o_sid_insertzeronumtotalx = i_sid_inst[`SDMA_INST_INSERTZERONUMTOTALXSTART + `SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1 : `SDMA_INST_INSERTZERONUMTOTALXSTART];
assign o_sid_insertzeronumtotaly = i_sid_inst[`SDMA_INST_INSERTZERONUMTOTALYSTART + `SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1 : `SDMA_INST_INSERTZERONUMTOTALYSTART];
assign o_sid_upsampleidxx = i_sid_inst[`SDMA_INST_UPSAMPLEIDXXSTART + `SDMA_INST_UPSAMPLEIDXXWIDTH - 1 : `SDMA_INST_UPSAMPLEIDXXSTART];
assign o_sid_upsampleidxy = i_sid_inst[`SDMA_INST_UPSAMPLEIDXYSTART + `SDMA_INST_UPSAMPLEIDXYWIDTH - 1 : `SDMA_INST_UPSAMPLEIDXYSTART];
assign o_sid_cropfmsstride2 = i_sid_inst[`SDMA_INST_CROPFMSSTRIDE2START + `SDMA_INST_CROPFMSSTRIDE2WIDTH - 1 : `SDMA_INST_CROPFMSSTRIDE2START];
assign o_sid_cropfmsstride1 = i_sid_inst[`SDMA_INST_CROPFMSSTRIDE1START + `SDMA_INST_CROPFMSSTRIDE1WIDTH - 1 : `SDMA_INST_CROPFMSSTRIDE1START];
assign o_sid_cropfmsc = i_sid_inst[`SDMA_INST_CROPFMSCSTART + `SDMA_INST_CROPFMSCWIDTH - 1 : `SDMA_INST_CROPFMSCSTART];
assign o_sid_cropfmsx = i_sid_inst[`SDMA_INST_CROPFMSXSTART + `SDMA_INST_CROPFMSXWIDTH - 1 : `SDMA_INST_CROPFMSXSTART];
assign o_sid_cropfmsy = i_sid_inst[`SDMA_INST_CROPFMSYSTART + `SDMA_INST_CROPFMSYWIDTH - 1 : `SDMA_INST_CROPFMSYSTART];
assign o_sid_cropfms2stride2 = i_sid_inst[`SDMA_INST_CROPFMS2STRIDE2START + `SDMA_INST_CROPFMS2STRIDE2WIDTH - 1 : `SDMA_INST_CROPFMS2STRIDE2START];
assign o_sid_cropfms2stride1 = i_sid_inst[`SDMA_INST_CROPFMS2STRIDE1START + `SDMA_INST_CROPFMS2STRIDE1WIDTH - 1 : `SDMA_INST_CROPFMS2STRIDE1START];
assign o_sid_cropfms2c = i_sid_inst[`SDMA_INST_CROPFMS2CSTART + `SDMA_INST_CROPFMS2CWIDTH - 1 : `SDMA_INST_CROPFMS2CSTART];
assign o_sid_cropfms2x = i_sid_inst[`SDMA_INST_CROPFMS2XSTART + `SDMA_INST_CROPFMS2XWIDTH - 1 : `SDMA_INST_CROPFMS2XSTART];
assign o_sid_cropfms2y = i_sid_inst[`SDMA_INST_CROPFMS2YSTART + `SDMA_INST_CROPFMS2YWIDTH - 1 : `SDMA_INST_CROPFMS2YSTART];
assign o_sid_srcfmscycsaddr = i_sid_inst[`SDMA_INST_SRCFMSCYCSADDRSTART + `SDMA_INST_SRCFMSCYCSADDRWIDTH - 1 : `SDMA_INST_SRCFMSCYCSADDRSTART];
assign o_sid_srcfmscyceaddr = i_sid_inst[`SDMA_INST_SRCFMSCYCEADDRSTART + `SDMA_INST_SRCFMSCYCEADDRWIDTH - 1 : `SDMA_INST_SRCFMSCYCEADDRSTART];
assign o_sid_srcfmscycalignena = i_sid_inst[`SDMA_INST_SRCFMSCYCALIGNENASTART + `SDMA_INST_SRCFMSCYCALIGNENAWIDTH - 1 : `SDMA_INST_SRCFMSCYCALIGNENASTART];
assign o_sid_shuffleidx	= i_sid_inst[`SDMA_INST_SHUFFLEIDXSTART + `SDMA_INST_SHUFFLEIDXWIDTH - 1 : `SDMA_INST_SHUFFLEIDXSTART];
//------------------------------------------------------------------------------


endmodule
