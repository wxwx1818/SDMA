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
module sdma_dport_mux
(
	//mux ctrl
	input  [`SDMA_INST_DSTPORTIDWIDTH-1:0] 		i_inst_dstportid,
	//AHB port
	input										i_sdma_ahbready,
	output [`SDMA_AHBDATAWIDTH-1:0]				o_sdma_ahbwdata,
	output [`SDMA_AHBDATAWIDTH/8-1:0]			o_sdma_ahbwen,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_ahbwaddr,
	//DCACHE1
	input										i_sdma_dc1ready,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc1wdata,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc1wen,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc1waddr,
	//DCACHE2
	input										i_sdma_dc2ready,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_dc2wdata,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_dc2wen,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_dc2waddr,
	//WCACHE1
	input										i_sdma_wc1ready,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc1wdata,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc1wen,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc1waddr,
	//WCACHE2
	input										i_sdma_wc2ready,
	output [`SDMA_CACHEDATAWIDTH-1:0]			o_sdma_wc2wdata,
	output [`SDMA_CACHEDATAWIDTH/8-1:0]			o_sdma_wc2wen,
	output [`SDMA_ADDRWIDTH-1:0]				o_sdma_wc2waddr,
	//mux port
	input  [`SDMA_CACHEDATAWIDTH-1:0]			i_sdma_dportwdata,
	input  [`SDMA_CACHEDATAWIDTH/8-1:0]			i_sdma_dportwen,
	input  [`SDMA_ADDRWIDTH-1:0]				i_sdma_dportwaddr,
	output reg									o_sdma_dportready
);

//----------------------------------OUTPUT LOGIC--------------------------------
assign o_sdma_ahbwdata = (i_inst_dstportid == 3'b000)?i_sdma_dportwdata[`SDMA_AHBDATAWIDTH-1:0]:{(`SDMA_AHBDATAWIDTH){1'b0}};
assign o_sdma_dc1wdata = (i_inst_dstportid == 3'b100)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_dc2wdata = (i_inst_dstportid == 3'b101)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_wc1wdata = (i_inst_dstportid == 3'b110)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};
assign o_sdma_wc2wdata = (i_inst_dstportid == 3'b111)?i_sdma_dportwdata:{(`SDMA_CACHEDATAWIDTH){1'b0}};

assign o_sdma_ahbwen   = (i_inst_dstportid == 3'b000)?i_sdma_dportwen[`SDMA_AHBDATAWIDTH/8-1:0]:{(`SDMA_AHBDATAWIDTH/8){1'b0}};
assign o_sdma_dc1wen   = (i_inst_dstportid == 3'b100)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_dc2wen   = (i_inst_dstportid == 3'b101)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_wc1wen   = (i_inst_dstportid == 3'b110)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};
assign o_sdma_wc2wen   = (i_inst_dstportid == 3'b111)?i_sdma_dportwen:{(`SDMA_CACHEDATAWIDTH/8){1'b0}};

assign o_sdma_ahbwaddr = (i_inst_dstportid == 3'b000)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_dc1waddr = (i_inst_dstportid == 3'b100)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_dc2waddr = (i_inst_dstportid == 3'b101)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_wc1waddr = (i_inst_dstportid == 3'b110)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};
assign o_sdma_wc2waddr = (i_inst_dstportid == 3'b111)?i_sdma_dportwaddr:{(`SDMA_ADDRWIDTH){1'b0}};

always@(*)begin
	case(i_inst_dstportid)
		3'b000:begin
			o_sdma_dportready = i_sdma_ahbready;
		end
		3'b100:begin
			o_sdma_dportready = i_sdma_dc1ready;
		end
		3'b101:begin
			o_sdma_dportready = i_sdma_dc2ready;
		end
		3'b110:begin
			o_sdma_dportready = i_sdma_wc1ready;
		end
		3'b111:begin
			o_sdma_dportready = i_sdma_wc2ready;
		end
		default:begin
			o_sdma_dportready = i_sdma_ahbready;
		end
	endcase
end
//------------------------------------------------------------------------------
endmodule
