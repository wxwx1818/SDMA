// -----------------------------------------------------------------------------
// FILE NAME : sdma_ready_mux.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : mux ready signal
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_ready_mux
(
	//mux ctrl
	input [`SDMA_INST_SRCPORTIDWIDTH-1:0]		i_inst_srcportid,
	input [`SDMA_INST_DSTPORTIDWIDTH-1:0]		i_inst_dstportid,
	//AHB port
	input										i_sdma_ahbready,
	//DCACHE1
	input										i_sdma_dc1ready,
	//DCACHE2
	input										i_sdma_dc2ready,
	//WCACHE1
	input										i_sdma_wc1ready,
	//WCACHE2
	input										i_sdma_wc2ready,
	//mux port
	output reg									o_sdma_sportready,
	output reg									o_sdma_dportready
);


//----------------------------------OUTPUT LOGIC--------------------------------

always@(*)begin
	case(i_inst_srcportid)
		3'b000:begin
			o_sdma_sportready = i_sdma_ahbready;
		end
		3'b100:begin
			o_sdma_sportready = i_sdma_dc1ready;
		end
		3'b101:begin
			o_sdma_sportready = i_sdma_dc2ready;
		end
		3'b110:begin
			o_sdma_sportready = i_sdma_wc1ready;
		end
		3'b111:begin
			o_sdma_sportready = i_sdma_wc2ready;
		end
		default:begin
			o_sdma_sportready = i_sdma_ahbready;
		end
	endcase
end

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
