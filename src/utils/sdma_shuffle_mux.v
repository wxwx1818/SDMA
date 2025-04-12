`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"

module sdma_shuffle_mux
(
	input 								i_ssm_shuffleen,
	input								i_ssm_shuffleidx,
	input	[`SDMA_CACHEDATAWIDTH-1:0]	i_ssm_originaldata,
	output	[`SDMA_CACHEDATAWIDTH-1:0]	o_ssm_shuffleddata
);
	
	assign o_ssm_shuffleddata = i_ssm_shuffleen?(i_ssm_shuffleidx?{504'd0,i_ssm_originaldata[7:0]}:{504'd0,i_ssm_originaldata[15:8]}):i_ssm_originaldata;

endmodule
