// -----------------------------------------------------------------------------
// FILE NAME : sdma_ahb_sigmux.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-12-31
// -----------------------------------------------------------------------------
// DESCRIPTION : Mux ren, wen, raddr, waddr of sdma to ena, wea, addr of ahb.
// Write and Read request from sdma are non-concurrent.
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/sdma_params.vh"
module sdma_ahb_sigmux
(
	input	[`SDMA_AHBDATAWIDTH/8-1:0]		i_sas_sdmaren,
	input	[`SDMA_AHBDATAWIDTH/8-1:0]		i_sas_sdmawen,
	input	[`SDMA_ADDRWIDTH-1:0]			i_sas_sdmaraddr,
	input	[`SDMA_ADDRWIDTH-1:0]			i_sas_sdmawaddr,
	output	[`SDMA_AHBDATAWIDTH/8-1:0]		o_sas_ahbena,
	output									o_sas_ahbwea,
	output	[`SDMA_ADDRWIDTH-1:0]			o_sas_ahbaddr
);

//----------------------------------OUTPUT LOGIC--------------------------------
assign o_sas_ahbena  = o_sas_ahbwea?(i_sas_sdmawen):i_sas_sdmaren;
assign o_sas_ahbwea  = |(i_sas_sdmawen);
assign o_sas_ahbaddr = o_sas_ahbwea?(i_sas_sdmawaddr):i_sas_sdmaraddr;
//------------------------------------------------------------------------------

endmodule
