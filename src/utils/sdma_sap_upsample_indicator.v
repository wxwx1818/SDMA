// -----------------------------------------------------------------------------
// FILE NAME : sdma_sap_upsample_indicator.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-1-16
// -----------------------------------------------------------------------------
// DESCRIPTION : Indicate when the upsample of dst fms happened. 
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_sap_upsample_indicator
(
	input													i_sap_ui_upsampleen,
	input													i_sap_ui_paddingen,
	input													i_sap_ui_paddingflag,
	input		[`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0]			i_sap_ui_upsampleidxx,
	input		[`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0]			i_sap_ui_upsampleidxy,
	input  		[`SDMA_INST_INSERTZERONUMWIDTH-1:0]  		i_sap_ui_upsamplexcnt,
	input		[`SDMA_INST_INSERTZERONUMWIDTH-1:0]  		i_sap_ui_upsampleycnt,
	output 													o_sap_ui_upsampleflag
);

//----------------------------------OUTPUT LOGIC--------------------------------
wire [`SDMA_INST_UPSAMPLEIDXXWIDTH-1:0] upsampleidxx;
wire [`SDMA_INST_UPSAMPLEIDXYWIDTH-1:0] upsampleidxy;

assign	upsampleidxx = i_sap_ui_paddingen?(i_sap_ui_upsampleidxx):{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
assign	upsampleidxy = i_sap_ui_paddingen?(i_sap_ui_upsampleidxy):{(`SDMA_INST_INSERTZERONUMWIDTH){1'b0}};
assign	o_sap_ui_upsampleflag = i_sap_ui_upsampleen && ~i_sap_ui_paddingflag && ~((i_sap_ui_upsamplexcnt == upsampleidxx) && (i_sap_ui_upsampleycnt == upsampleidxy));
//------------------------------------------------------------------------------

endmodule
