// -----------------------------------------------------------------  
//            ALL RIGHTS RESERVED                                     
// ----------------------------------------------------------------- 
// Filename      : TB_sdma_data_path.v                                              
// Created On    : 2025-01-09 21:03:54                                                
// ----------------------------------------------------------------- 
// Description:  Verilog testbench fiel Auto Generator Scripts       
// Version : v0-first generate tb file use python script             
// ----------------------------------------------------------------- 
`timescale 1ns/1ps
module TB_sdma_data_path();

//parameter

//input
reg                                   clk;
reg                                   rst_n;
reg                                   i_sdp_en;
reg                                   i_sdp_transfer_pending;
reg   [`SDMA_SDP_DINNUMDATAWIDTH-1:0]	i_sdp_num_of_remain_bytes;
reg   [`SDMA_CACHEDATAWIDTH/8-1:0]    i_sdp_num_of_remain_bytes_tmcode;
reg                                   i_sdp_mode_vld;
reg   [2:0]                           i_sdp_mode;
reg   [`SDMA_CACHEDATAWIDTH/8-1:0]    i_sdp_din_strb;
reg                                   i_sdp_din_vld;
reg   [`SDMA_CACHEDATAWIDTH-1:0]      i_sdp_din;
reg                                   i_sdp_dout_ready;

//output
wire                                o_sdp_din_ready;
wire                                o_sdp_dout_vld;
wire   [`SDMA_CACHEDATAWIDTH-1:0]   o_sdp_dout;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdp_dout_ldb;
wire								o_sdp_dout_section_done;

//inout

always #1 clk = ~clk;
integer i ;
task sdp_test_mode_ahb2cacheseq;
	begin
		#2
		i_sdp_dout_ready = 1;
		i_sdp_mode = `SDMA_SDP_MODE_AHB2CACHESEQ;
		i_sdp_mode_vld = 1;
		i_sdp_transfer_pending = 1;
		i_sdp_num_of_remain_bytes = 64;
		i_sdp_num_of_remain_bytes_tmcode = {64{1'b1}};
		for(i=0;i<16;i=i+1)begin
			i_sdp_din_vld = 1;
			i_sdp_din_strb = {32{1'b1}};
			i_sdp_din = {32{1'b1}};
			while(~o_sdp_din_ready)begin
				#2;
			end
			#2;
		end
		#4
		i_sdp_transfer_pending = 0;
		i_sdp_en = 0;
		i_sdp_num_of_remain_bytes = 3;
		i_sdp_num_of_remain_bytes_tmcode = 3'b111;
		i_sdp_din_vld = 1;
		i_sdp_din_strb = 2'b11;
		i_sdp_din = 2'b00;
		while(~o_sdp_din_ready)begin
			#2;
		end
		#2
		i_sdp_din_vld = 1;
		i_sdp_din_strb = 1'b1;
		i_sdp_din = 1'b0;
	end
endtask

sdma_data_path U_SDMA_DATA_PATH_0(
  .clk                              (clk),
  .rst_n                            (rst_n),
  .i_sdp_en                         (i_sdp_en),
  .i_sdp_transfer_pending           (i_sdp_transfer_pending),
  .i_sdp_num_of_remain_bytes        (i_sdp_num_of_remain_bytes[`SDMA_SDP_DINNUMDATAWIDTH-1:0]),
  .i_sdp_num_of_remain_bytes_tmcode (i_sdp_num_of_remain_bytes_tmcode[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdp_mode_vld                   (i_sdp_mode_vld),
  .i_sdp_mode                       (i_sdp_mode[2:0]),
  .i_sdp_din_strb                   (i_sdp_din_strb[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdp_din_vld                    (i_sdp_din_vld),
  .i_sdp_din                        (i_sdp_din[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdp_dout_ready                 (i_sdp_dout_ready),
  .o_sdp_din_ready                  (o_sdp_din_ready),
  .o_sdp_dout_vld                   (o_sdp_dout_vld),
  .o_sdp_dout                       (o_sdp_dout[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdp_dout_ldb                   (o_sdp_dout_ldb[`SDMA_CACHEDATAWIDTH/8-1:0]),
  o_sdp_dout_section_done			(o_sdp_dout_section_done)
  );

initial begin
  clk = 0;
  rst_n = 0;
  i_sdp_en = 0;
  i_sdp_transfer_pending = 0;
  i_sdp_num_of_remain_bytes = 0;
  i_sdp_num_of_remain_bytes_tmcode = 0;
  i_sdp_mode_vld = 0;
  i_sdp_mode = 0;
  i_sdp_din_strb = 0;
  i_sdp_din_vld = 0;
  i_sdp_din = 0;
  i_sdp_dout_ready = 0;
  #2  
  rst_n = 1;
  i_sdp_en = 1;
  sdp_test_mode_ahb2cacheseq;
end



initial begin
    $fsdbDumpfile("TB_sdma_data_path.fsdb");
    $fsdbDumpvars(0,TB_sdma_data_path);
    $fsdbDumpMDA();
    #50000 $finish;
end




endmodule

