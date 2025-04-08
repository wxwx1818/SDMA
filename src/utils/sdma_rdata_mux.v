// -----------------------------------------------------------------------------
// FILE NAME : sdma_rdata_mux.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : mux rdata and rvld
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_rdata_mux
(
	//mux ctrl
	input [`SDMA_INST_SRCPORTIDWIDTH-1:0]		i_inst_srcportid,
	//AHB port
	input  [`SDMA_AHBDATAWIDTH-1:0]				i_sdma_ahbrdata,
	input  [`SDMA_AHBDATAWIDTH/8-1:0]			i_sdma_ahbrvld,
	//DCACHE1
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc1rvld,
	//DCACHE2
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc2rvld,
	//WCACHE1
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc1rvld,
	//WCACHE2
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc2rvld,
	//mux port
	output reg [`SDMA_CACHEDATAWIDTH-1:0]		o_sdma_sportrdata,
	output reg [`SDMA_CACHEDATAWIDTH/8-1:0]		o_sdma_sportrvld
);


//----------------------------------OUTPUT LOGIC--------------------------------
always@(*)begin
	case(i_inst_srcportid)
		3'b000:begin
			o_sdma_sportrdata = {{(`SDMA_CACHEDATAWIDTH - `SDMA_AHBDATAWIDTH){1'b0}},i_sdma_ahbrdata};
			o_sdma_sportrvld  = {{(`SDMA_CACHEDATAWIDTH/8 - `SDMA_AHBDATAWIDTH/8){1'b0}},i_sdma_ahbrvld};
		end
		3'b100:begin
			o_sdma_sportrdata = i_sdma_dc1rdata;
			o_sdma_sportrvld  = i_sdma_dc1rvld;
		end
		3'b101:begin
			o_sdma_sportrdata = i_sdma_dc2rdata;
			o_sdma_sportrvld  = i_sdma_dc2rvld;
		end
		3'b110:begin
			o_sdma_sportrdata = i_sdma_wc1rdata;
			o_sdma_sportrvld  = i_sdma_wc1rvld;
		end
		3'b111:begin
			o_sdma_sportrdata = i_sdma_wc2rdata;
			o_sdma_sportrvld  = i_sdma_wc2rvld;
		end
		default:begin
			o_sdma_sportrdata = {{(`SDMA_CACHEDATAWIDTH - `SDMA_AHBDATAWIDTH){1'b0}},i_sdma_ahbrdata};
			o_sdma_sportrvld  = {{(`SDMA_CACHEDATAWIDTH/8 - `SDMA_AHBDATAWIDTH/8){1'b0}},i_sdma_ahbrvld};
		end
	endcase
end

//------------------------------------------------------------------------------


endmodule
