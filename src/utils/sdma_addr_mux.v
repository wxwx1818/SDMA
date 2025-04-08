// -----------------------------------------------------------------------------
// FILE NAME : sdma_addr_mux.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : mux addr, ren, wen.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_addr_mux
(
	//mux ctrl
	input [`SDMA_INST_SRCPORTIDWIDTH-1:0]		i_inst_srcportid,
	input [`SDMA_INST_DSTPORTIDWIDTH-1:0]		i_inst_dstportid,
	//mux port
	input [`SDMA_ADDRWIDTH-1:0]					i_sdma_sportraddr,
	input [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_sportren,
	input [`SDMA_ADDRWIDTH-1:0]					i_sdma_dportwaddr,
	input [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dportwen,
	//AHB port
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_ahbaddr,
	output 										o_sdma_ahbwea,
	output [`SDMA_AHBDATAWIDTH/8-1:0]			o_sdma_ahbena,
	//DCACHE1
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc1addr,
	output 										o_sdma_dc1wea,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc1ena,
	//DCACHE2
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc2addr,
	output 										o_sdma_dc2wea,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc2ena,
	//WCACHE1
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc1addr,
	output 										o_sdma_wc1wea,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc1ena,
	//WCACHE2
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc2addr,
	output 										o_sdma_wc2wea,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc2ena
);


//----------------------------------OUTPUT LOGIC--------------------------------
wire [`SDMA_ADDRWIDTH-1:0]			sdma_ahbraddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_dc1raddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_dc2raddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_wc1raddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_wc2raddr;

wire [`SDMA_ADDRWIDTH-1:0]			sdma_ahbwaddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_dc1waddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_dc2waddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_wc1waddr;
wire [`SDMA_ADDRWIDTH-1:0]			sdma_wc2waddr;

wire [`SDMA_AHBDATAWIDTH/8-1:0]		sdma_ahbren;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_dc1ren;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_dc2ren;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_wc1ren;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_wc2ren;

wire [`SDMA_AHBDATAWIDTH/8-1:0]		sdma_ahbwen;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_dc1wen;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_dc2wen;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_wc1wen;
wire [`SDMA_CACHEDATAWIDTH/8-1:0]	sdma_wc2wen;

assign sdma_ahbraddr = (i_inst_srcportid == 3'b000)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_dc1raddr = (i_inst_srcportid == 3'b100)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_dc2raddr = (i_inst_srcportid == 3'b101)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_wc1raddr = (i_inst_srcportid == 3'b110)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_wc2raddr = (i_inst_srcportid == 3'b111)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};

assign sdma_ahbwaddr = (i_inst_dstportid == 3'b000)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_dc1waddr = (i_inst_dstportid == 3'b100)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_dc2waddr = (i_inst_dstportid == 3'b101)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_wc1waddr = (i_inst_dstportid == 3'b110)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign sdma_wc2waddr = (i_inst_dstportid == 3'b111)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};

assign sdma_ahbren   = (i_inst_srcportid == 3'b000)?i_sdma_sportren[`SDMA_AHBDATAWIDTH/8-1:0]:{(`SDMA_AHBDATAWIDTH/8){1'b0}};
assign sdma_dc1ren   = (i_inst_srcportid == 3'b100)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_dc2ren   = (i_inst_srcportid == 3'b101)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_wc1ren   = (i_inst_srcportid == 3'b110)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_wc2ren   = (i_inst_srcportid == 3'b111)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};

assign sdma_ahbwen   = (i_inst_dstportid == 3'b000)?i_sdma_dportwen[`SDMA_AHBDATAWIDTH/8-1:0]:{(`SDMA_AHBDATAWIDTH/8){1'b0}};
assign sdma_dc1wen   = (i_inst_dstportid == 3'b100)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_dc2wen   = (i_inst_dstportid == 3'b101)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_wc1wen   = (i_inst_dstportid == 3'b110)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign sdma_wc2wen   = (i_inst_dstportid == 3'b111)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};

assign o_sdma_ahbena  = o_sdma_ahbwea?(sdma_ahbwen):sdma_ahbren;
assign o_sdma_ahbwea  = |(sdma_ahbwen);
assign o_sdma_ahbaddr = o_sdma_ahbwea?(sdma_ahbwaddr):sdma_ahbraddr;

assign o_sdma_dc1ena  = o_sdma_dc1wea?(sdma_dc1wen):sdma_dc1ren;
assign o_sdma_dc1wea  = |(sdma_dc1wen);
assign o_sdma_dc1addr = o_sdma_dc1wea?(sdma_dc1waddr):sdma_dc1raddr;


assign o_sdma_dc2ena  = o_sdma_dc2wea?(sdma_dc2wen):sdma_dc2ren;
assign o_sdma_dc2wea  = |(sdma_dc2wen);
assign o_sdma_dc2addr = o_sdma_dc2wea?(sdma_dc2waddr):sdma_dc2raddr;


assign o_sdma_wc1ena  = o_sdma_wc1wea?(sdma_wc1wen):sdma_wc1ren;
assign o_sdma_wc1wea  = |(sdma_wc1wen);
assign o_sdma_wc1addr = o_sdma_wc1wea?(sdma_wc1waddr):sdma_wc1raddr;


assign o_sdma_wc2ena  = o_sdma_wc2wea?(sdma_wc2wen):sdma_wc2ren;
assign o_sdma_wc2wea  = |(sdma_wc2wen);
assign o_sdma_wc2addr = o_sdma_wc2wea?(sdma_wc2waddr):sdma_wc2raddr;
//------------------------------------------------------------------------------

endmodule
