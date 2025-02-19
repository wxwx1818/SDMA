// -----------------------------------------------------------------------------
// FILE NAME : src_data_buf.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : Store data read from src port for further transfer. Support 
// multiple valid datawidth(8b/32b/512b) mode to accommodate different ports.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/sdma_params.vh"
module sdma_sport_mux
(
	//mux ctrl
	input [`SDMA_INST_SRCPORTIDWIDTH-1:0]		i_inst_srcportid,
	//AHB port
	input										i_sdma_ahbready,
	input  [`SDMA_AHBDATAWIDTH-1:0]				i_sdma_ahbrdata,
	input  [`SDMA_AHBDATAWIDTH/8-1:0]			i_sdma_ahbrvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_ahbraddr,
	output [`SDMA_AHBDATAWIDTH/8-1:0]			o_sdma_ahbren,
	//DCACHE1
	input										i_sdma_dc1ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc1rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc1raddr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc1ren,
	//DCACHE2
	input										i_sdma_dc2ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dc2rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc2raddr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc2ren,
	//WCACHE1
	input										i_sdma_wc1ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc1rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc1rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc1raddr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc1ren,
	//WCACHE2
	input										i_sdma_wc2ready,
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_wc2rdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_wc2rvld,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc2raddr,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc2ren,
	//mux port
	output reg									o_sdma_sportready,
	output reg [`SDMA_CACHEDATAWIDTH-1:0]		o_sdma_sportrdata,
	output reg [`SDMA_CACHEDATAWIDTH/8-1:0]		o_sdma_sportrvld,
	input [`SDMA_ADDRWIDTH-1:0]					i_sdma_sportraddr,
	input [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_sportren
);


//----------------------------------OUTPUT LOGIC--------------------------------
assign o_sdma_ahbraddr = (i_inst_srcportid == 3'b000)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_dc1raddr = (i_inst_srcportid == 3'b100)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_dc2raddr = (i_inst_srcportid == 3'b101)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_wc1raddr = (i_inst_srcportid == 3'b110)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_wc2raddr = (i_inst_srcportid == 3'b111)?i_sdma_sportraddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_ahbren   = (i_inst_srcportid == 3'b000)?i_sdma_sportren[`SDMA_AHBDATAWIDTH/8-1:0]:{(`SDMA_AHBDATAWIDTH/8){1'b0}};
assign o_sdma_dc1ren   = (i_inst_srcportid == 3'b100)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_dc2ren   = (i_inst_srcportid == 3'b101)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_wc1ren   = (i_inst_srcportid == 3'b110)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_wc2ren   = (i_inst_srcportid == 3'b111)?i_sdma_sportren:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};

always@(*)begin
	case(i_inst_srcportid)
		3'b000:begin
			o_sdma_sportready = i_sdma_ahbready;
			o_sdma_sportrdata = i_sdma_ahbrdata;
			o_sdma_sportrvld  = i_sdma_ahbrvld;
		end
		3'b100:begin
			o_sdma_sportready = i_sdma_dc1ready;
			o_sdma_sportrdata = i_sdma_dc1rdata;
			o_sdma_sportrvld  = i_sdma_dc1rvld;
		end
		3'b101:begin
			o_sdma_sportready = i_sdma_dc2ready;
			o_sdma_sportrdata = i_sdma_dc2rdata;
			o_sdma_sportrvld  = i_sdma_dc2rvld;
		end
		3'b110:begin
			o_sdma_sportready = i_sdma_wc1ready;
			o_sdma_sportrdata = i_sdma_wc1rdata;
			o_sdma_sportrvld  = i_sdma_wc1rvld;
		end
		3'b111:begin
			o_sdma_sportready = i_sdma_wc2ready;
			o_sdma_sportrdata = i_sdma_wc2rdata;
			o_sdma_sportrvld  = i_sdma_wc2rvld;
		end
		default:begin
			o_sdma_sportready = i_sdma_ahbready;
			o_sdma_sportrdata = i_sdma_ahbrdata;
			o_sdma_sportrvld  = i_sdma_ahbrvld;
		end
	endcase
end

//------------------------------------------------------------------------------


endmodule
