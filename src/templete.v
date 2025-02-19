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
`include "/home/wx/Project/SDMA/src/vhead/"
module templete
(
	input				clk,
	input				rst_n,
	input				mode_vld,
	input  [3:0]		mode,
	input				din_vld,
	input  [511:0]		din,
	output				dout_vld,
	output [511:0]		dout
);

//----------------------------------STATE---------------------------------------
localparam IDLE = 'd0;

//------------------------------------------------------------------------------

//----------------------------------VARIABLES-----------------------------------
reg		[]		cur_state;
reg		[]		next_state;
//------------------------------------------------------------------------------

//----------------------------------STATE TRANSFER------------------------------
//------------------------------------------------------------------------------

//----------------------------------REGISTER VALUE LOGIC------------------------
always@(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		cur_state <= IDLE;
	end
	else begin
		cur_state <= next_state;
	end
end
//------------------------------------------------------------------------------

//----------------------------------OUTPUT LOGIC--------------------------------
//------------------------------------------------------------------------------


endmodule
