// -----------------------------------------------------------------------------
// FILE NAME : sdma_wdata_mux.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : mux wdata.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_wdata_mux
(
	//mux ctrl
	input  [`SDMA_INST_DSTPORTIDWIDTH-1:0] 		i_inst_dstportid,
	//mux port
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dportwdata,
	//AHB port
	output [`SDMA_AHBDATAWIDTH-1:0]				o_sdma_ahbwdata,
	//DCACHE1
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc1wdata,
	//DCACHE2
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc2wdata,
	//WCACHE1
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc1wdata,
	//WCACHE2
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc2wdata
);

//----------------------------------OUTPUT LOGIC--------------------------------
assign o_sdma_ahbwdata = (i_inst_dstportid == 3'b000)?i_sdma_dportwdata[`SDMA_AHBDATAWIDTH-1:0]:{(`SDMA_AHBDATAWIDTH){1'b0}};
assign o_sdma_dc1wdata = (i_inst_dstportid == 3'b100)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_dc2wdata = (i_inst_dstportid == 3'b101)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_wc1wdata = (i_inst_dstportid == 3'b110)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_wc2wdata = (i_inst_dstportid == 3'b111)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};

//------------------------------------------------------------------------------
endmodule
