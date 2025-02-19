// -----------------------------------------------------------------  
//            ALL RIGHTS RESERVED                                     
// ----------------------------------------------------------------- 
// Filename      : TB_sdma_top.v                                              
// Created On    : 2025-01-21 21:47:31                                                
// ----------------------------------------------------------------- 
// Description:  Verilog testbench fiel Auto Generator Scripts       
// Version : v0-first generate tb file use python script             
// ----------------------------------------------------------------- 
`include "/home/wx/Project/SDMA/src/vhead/sdma_params.vh"
`timescale 1ns/1ps
module TB_sdma_top();

//SDMA ctrl port input
reg                                 sdma_clk;
reg                                 sdma_rst_n;
reg                                 i_sdma_en;
reg                                 i_sdma_inst_vld;
wire   [`SDMA_INSTWIDTH-1:0]        i_sdma_inst;
//SDMA ctrl port output
wire                                o_sdma_ready;
//SDMA w/r port input
wire                                sdma_ahbready;
wire   [`SDMA_AHBDATAWIDTH-1:0]     sdma_ahbrdata;
wire   [`SDMA_AHBDATAWIDTH/8-1:0]   sdma_ahbrvld;
reg                                 i_sdma_dc1ready;
reg    [`SDMA_CACHEDATAWIDTH-1:0]   i_sdma_dc1rdata;
reg    [`SDMA_CACHEDATAWIDTH/8-1:0] i_sdma_dc1rvld;
reg                                 i_sdma_dc2ready;
reg    [`SDMA_CACHEDATAWIDTH-1:0]   i_sdma_dc2rdata;
reg    [`SDMA_CACHEDATAWIDTH/8-1:0] i_sdma_dc2rvld;
reg                                 i_sdma_wc1ready;
reg    [`SDMA_CACHEDATAWIDTH-1:0]   i_sdma_wc1rdata;
reg    [`SDMA_CACHEDATAWIDTH/8-1:0] i_sdma_wc1rvld;
reg                                 i_sdma_wc2ready;
reg    [`SDMA_CACHEDATAWIDTH-1:0]   i_sdma_wc2rdata;
reg    [`SDMA_CACHEDATAWIDTH/8-1:0] i_sdma_wc2rvld;
//SDMA w/r port output
wire   [`SDMA_ADDRWIDTH-1:0]        sdma_ahbraddr;
wire   [`SDMA_AHBDATAWIDTH/8-1:0]   sdma_ahbren;
wire   [`SDMA_AHBDATAWIDTH-1:0]     sdma_ahbwdata;
wire   [`SDMA_AHBDATAWIDTH/8-1:0]   sdma_ahbwen;
wire   [`SDMA_AHBDATAWIDTH/8-1:0]	sdma_ahbena;
wire								sdma_ahbrea;
wire   [`SDMA_ADDRWIDTH-1:0]		sdma_ahbaddr;
wire   [`SDMA_ADDRWIDTH-1:0]        sdma_ahbwaddr;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_dc1raddr;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_dc1ren;
wire   [`SDMA_CACHEDATAWIDTH-1:0]   o_sdma_dc1wdata;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_dc1wen;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_dc1waddr;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_dc2raddr;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_dc2ren;
wire   [`SDMA_CACHEDATAWIDTH-1:0]   o_sdma_dc2wdata;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_dc2wen;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_dc2waddr;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_wc1raddr;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_wc1ren;
wire   [`SDMA_CACHEDATAWIDTH-1:0]   o_sdma_wc1wdata;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_wc1wen;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_wc1waddr;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_wc2raddr;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_wc2ren;
wire   [`SDMA_CACHEDATAWIDTH-1:0]   o_sdma_wc2wdata;
wire   [`SDMA_CACHEDATAWIDTH/8-1:0] o_sdma_wc2wen;
wire   [`SDMA_ADDRWIDTH-1:0]        o_sdma_wc2waddr;

//rram_ahb other signals
reg									ahb_clk;
reg									ahb_rst_n;
wire								ahb_error;

//SDMA Instruction
reg [`SDMA_INST_SDMAMODEWIDTH - 1:0] 			sdmamode;
reg [`SDMA_INST_SRCPORTIDWIDTH - 1:0] 			srcportid;
reg [`SDMA_INST_DSTPORTIDWIDTH - 1:0] 			dstportid;
reg [`SDMA_INST_SRCFMSADDRWIDTH - 1:0]			srcfmsaddr;
reg [`SDMA_INST_DSTFMSADDRWIDTH - 1:0] 			dstfmsaddr;
reg [`SDMA_INST_SRCFMSMOVELENGTHWIDTH - 1:0] 	srcfmsmovelength;
reg [`SDMA_INST_SRCFMS2ADDRWIDTH - 1:0] 		srcfms2addr;
reg [`SDMA_INST_SRCFMS1CONCATELENGTHWIDTH - 1:0]srcfms1concatelength;
reg [`SDMA_INST_SRCFMS2CONCATELENGTHWIDTH - 1:0]srcfms2concatelength;
reg [`SDMA_INST_SRCFMS2MOVELENGTHWIDTH - 1:0] 	srcfms2movelength;
reg [`SDMA_INST_SRCFMSCWIDTH - 1:0] 			srcfmsc;
reg [`SDMA_INST_SRCFMSXWIDTH - 1:0] 			srcfmsx;
reg [`SDMA_INST_SRCFMSYWIDTH - 1:0] 			srcfmsy;
reg [`SDMA_INST_DSTFMSSTRIDE3WIDTH - 1:0] 		dstfmsstride3;
reg [`SDMA_INST_DSTFMSSTRIDE2WIDTH - 1:0] 		dstfmsstride2;
reg [`SDMA_INST_DSTFMSSTRIDE1WIDTH - 1:0] 		dstfmsstride1;
reg [`SDMA_INST_PADDINGAXISBEFOREWIDTH - 1:0] 	paddingaxisbefore;
reg [`SDMA_INST_PADDINGLEFTXWIDTH - 1:0] 		paddingleftx;
reg [`SDMA_INST_PADDINGRIGHTXWIDTH - 1:0] 		paddingrightx;
reg [`SDMA_INST_PADDINGLEFTYWIDTH - 1:0] 		paddinglefty;
reg [`SDMA_INST_PADDINGRIGHTYWIDTH - 1:0] 		paddingrighty;
reg [`SDMA_INST_INSERTZERONUMWIDTH - 1:0] 		insertzeronum;
reg [`SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1:0] insertzeronumtotalx;
reg [`SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1:0] insertzeronumtotaly;
reg [`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0] 		cropfmsstride1;
reg [`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0] 		cropfmsstride2;
reg [`SDMA_INST_CROPFMSCWIDTH - 1:0] 			cropfmsc;
reg [`SDMA_INST_CROPFMSXWIDTH - 1:0] 			cropfmsx;
reg [`SDMA_INST_CROPFMSYWIDTH - 1:0] 			cropfmsy;
reg [`SDMA_INST_CROPFMSSTRIDE1WIDTH - 1:0] 		cropfms2stride1;
reg [`SDMA_INST_CROPFMSSTRIDE2WIDTH - 1:0] 		cropfms2stride2;
reg [`SDMA_INST_CROPFMSCWIDTH - 1:0] 			cropfms2c;
reg [`SDMA_INST_CROPFMSXWIDTH - 1:0] 			cropfms2x;
reg [`SDMA_INST_CROPFMSYWIDTH - 1:0] 			cropfms2y;

assign i_sdma_inst = {	cropfms2y,
						cropfms2x,
						cropfms2c,
						cropfms2stride1,
						cropfms2stride2,
						cropfmsy,
						cropfmsx,
						cropfmsc,
						cropfmsstride1,
						cropfmsstride2,
						insertzeronumtotaly,
						insertzeronumtotalx,
						insertzeronum,
						paddingrighty,
						paddinglefty,
						paddingrightx,
						paddingleftx,
						paddingaxisbefore,
						dstfmsstride1,
						dstfmsstride2,
						dstfmsstride3,
						srcfmsy,
						srcfmsx,
						srcfmsc,
						srcfms2movelength,
						srcfms2concatelength,
						srcfms1concatelength,
						srcfms2addr,
						srcfmsmovelength,
						dstfmsaddr,
						srcfmsaddr,
						dstportid,
						srcportid,
						sdmamode};
always #1 ahb_clk  = ~ahb_clk;
always #1 sdma_clk = ~sdma_clk;


initial begin
  	init();
	//Move_AHB2DC1();
	//Transpose_AHB2AHB();
	//Crop_AHB2AHB();
	//Padding_AHB2AHB();
	//Upsample_AHB2AHB();
	//Concate_AHB2AHB();
	Transpose_AHB2DC1();
end

initial begin
    $fsdbDumpfile("TB_sdma_top.fsdb");
    $fsdbDumpvars(0,TB_sdma_top);
    $fsdbDumpMDA();
    #100000 $finish;
end
//----------------------------------------TESTCASE---------------------------------
task init();
begin
	ahb_clk = 0;
	ahb_rst_n = 0;
	sdma_clk = 0;
	sdma_rst_n = 0;
	i_sdma_en = 0;
	i_sdma_inst_vld = 0;
	i_sdma_dc1ready = 1;
	i_sdma_dc1rdata = 0;
	i_sdma_dc1rvld = 0;
	i_sdma_dc2ready = 1;
	i_sdma_dc2rdata = 0;
	i_sdma_dc2rvld = 0;
	i_sdma_wc1ready = 1;
	i_sdma_wc1rdata = 0;
	i_sdma_wc1rvld = 0;
	i_sdma_wc2ready = 1;
	i_sdma_wc2rdata = 0;
	i_sdma_wc2rvld = 0;
	sdmamode = 'b000000;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd0;
	srcfmsmovelength = 'd0;
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd0;
	srcfmsx = 'd0;
	srcfmsy = 'd0;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'd0;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2  
	sdma_rst_n = 1;
	ahb_rst_n  = 1;
	i_sdma_en  = 1;		
end
endtask

//testcase1, move fms from AHB to DCache1.Pass!
task Move_AHB2DC1();
	sdmamode = 'b100000;
	srcportid = 'b000;
	dstportid = 'b100;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd0;
	srcfmsmovelength = 'd95;
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd0;
	srcfmsx = 'd0;
	srcfmsy = 'd0;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'd0;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase2, transpose fms from AHB to AHB.Pass!
task Transpose_AHB2AHB();
	sdmamode = 'b101000;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd100;
	srcfmsmovelength = 'd96; //YCX->CYX     Y4*C4*X6->Y4*C4*X6
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd4;
	srcfmsx = 'd6;
	srcfmsy = 'd4;
	dstfmsstride3 = 'd24;
	dstfmsstride2 = 'd4;
	dstfmsstride1 = 'd1;
	paddingaxisbefore = 'b110;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase3, crop fms from AHB to AHB. Pass!
task Crop_AHB2AHB();
	sdmamode = 'b100001;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd100;
	srcfmsmovelength = 'd8; //Croped fms:Y2*C2*X2
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd0;
	srcfmsx = 'd0;
	srcfmsy = 'd0;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'd0;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd18;
	cropfmsstride1 = 'd2;
	cropfmsc = 'd2;
	cropfmsx = 'd2;
	cropfmsy = 'd2;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase4, padding fms from AHB to AHB. Pass!
task Padding_AHB2AHB();
	sdmamode = 'b100100;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd100;
	srcfmsmovelength = 'd96; //Source fms:Y4*C4*X6
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd4;
	srcfmsx = 'd6;
	srcfmsy = 'd4;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'b000;
	paddingleftx = 'd2;
	paddingrightx = 'd1;
	paddinglefty = 'd3;
	paddingrighty = 'd4;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase5, upsample fms from AHB to AHB. Pass! 
task Upsample_AHB2AHB();
	sdmamode = 'b100010;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd200;
	srcfmsmovelength = 'd96; //Source fms:Y4*C4*X6
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd4;
	srcfmsx = 'd6;
	srcfmsy = 'd4;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'b000;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd1;
	insertzeronumtotalx = 'd5;
	insertzeronumtotaly = 'd3;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase6, concate fms from AHB to AHB. Pass!
task Concate_AHB2AHB();
	sdmamode = 'b110000;
	srcportid = 'b000;
	dstportid = 'b000;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd200;
	srcfmsmovelength = 'd96; //Source fms:Y4*C4*X6
	srcfms2addr = 'd100;
	srcfms1concatelength = 'd4;
	srcfms2concatelength = 'd4;
	srcfms2movelength	 = 'd96;
	srcfmsc = 'd8;
	srcfmsx = 'd6;
	srcfmsy = 'd4;
	dstfmsstride3 = 'd0;
	dstfmsstride2 = 'd0;
	dstfmsstride1 = 'd0;
	paddingaxisbefore = 'b000;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask

//testcase7, transpose fms from AHB to DCACHE1.
task Transpose_AHB2DC1();
	sdmamode = 'b101000;
	srcportid = 'b000;
	dstportid = 'b100;
	srcfmsaddr = 'd0;
	dstfmsaddr = 'd100;
	srcfmsmovelength = 'd96; //YCX->CYX     Y4*C4*X6->Y4*C4*X6
	srcfms2addr = 'd0;
	srcfms1concatelength = 'd0;
	srcfms2concatelength = 'd0;
	srcfms2movelength	 = 'd0;
	srcfmsc = 'd4;
	srcfmsx = 'd6;
	srcfmsy = 'd4;
	dstfmsstride3 = 'd24;
	dstfmsstride2 = 'd4;
	dstfmsstride1 = 'd1;
	paddingaxisbefore = 'b110;
	paddingleftx = 'd0;
	paddingrightx = 'd0;
	paddinglefty = 'd0;
	paddingrighty = 'd0;
	insertzeronum = 'd0;
	insertzeronumtotalx = 'd0;
	insertzeronumtotaly = 'd0;
	cropfmsstride2 = 'd0;
	cropfmsstride1 = 'd0;
	cropfmsc = 'd0;
	cropfmsx = 'd0;
	cropfmsy = 'd0;
	cropfms2stride2 = 'd0;
	cropfms2stride1 = 'd0;
	cropfms2c = 'd0;
	cropfms2x = 'd0;
	cropfms2y = 'd0;
	#2
	i_sdma_inst_vld = 1;
	#2
	i_sdma_inst_vld = 0;
endtask



//---------------------------------------------------------------------------------

//----------------------------------------MODULE INSTANCE--------------------------
sdma_top U_SDMA_TOP_0(
  .clk             (sdma_clk),
  .rst_n           (sdma_rst_n),
  .i_sdma_en       (i_sdma_en),
  .i_sdma_inst_vld (i_sdma_inst_vld),
  .i_sdma_inst     (i_sdma_inst[`SDMA_INSTWIDTH-1:0]),
  .i_sdma_ahbready (sdma_ahbready),
  .i_sdma_ahbrdata (sdma_ahbrdata[`SDMA_AHBDATAWIDTH-1:0]),
  .i_sdma_ahbrvld  (sdma_ahbrvld[`SDMA_AHBDATAWIDTH/8-1:0]),
  .i_sdma_dc1ready (i_sdma_dc1ready),
  .i_sdma_dc1rdata (i_sdma_dc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc1rvld  (i_sdma_dc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_dc2ready (i_sdma_dc2ready),
  .i_sdma_dc2rdata (i_sdma_dc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_dc2rvld  (i_sdma_dc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc1ready (i_sdma_wc1ready),
  .i_sdma_wc1rdata (i_sdma_wc1rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc1rvld  (i_sdma_wc1rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .i_sdma_wc2ready (i_sdma_wc2ready),
  .i_sdma_wc2rdata (i_sdma_wc2rdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .i_sdma_wc2rvld  (i_sdma_wc2rvld[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_ready    (o_sdma_ready),
  .o_sdma_ahbraddr (sdma_ahbraddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_ahbren   (sdma_ahbren[`SDMA_AHBDATAWIDTH/8-1:0]),
  .o_sdma_ahbwdata (sdma_ahbwdata[`SDMA_AHBDATAWIDTH-1:0]),
  .o_sdma_ahbwen   (sdma_ahbwen[`SDMA_AHBDATAWIDTH/8-1:0]),
  .o_sdma_ahbwaddr (sdma_ahbwaddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc1raddr (o_sdma_dc1raddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc1ren   (o_sdma_dc1ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc1wdata (o_sdma_dc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_dc1wen   (o_sdma_dc1wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc1waddr (o_sdma_dc1waddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc2raddr (o_sdma_dc2raddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_dc2ren   (o_sdma_dc2ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc2wdata (o_sdma_dc2wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_dc2wen   (o_sdma_dc2wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_dc2waddr (o_sdma_dc2waddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc1raddr (o_sdma_wc1raddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc1ren   (o_sdma_wc1ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc1wdata (o_sdma_wc1wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc1wen   (o_sdma_wc1wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc1waddr (o_sdma_wc1waddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc2raddr (o_sdma_wc2raddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sdma_wc2ren   (o_sdma_wc2ren[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc2wdata (o_sdma_wc2wdata[`SDMA_CACHEDATAWIDTH-1:0]),
  .o_sdma_wc2wen   (o_sdma_wc2wen[`SDMA_CACHEDATAWIDTH/8-1:0]),
  .o_sdma_wc2waddr (o_sdma_wc2waddr[`SDMA_ADDRWIDTH-1:0]));

sdma_ahb_sigmux U_SDMA_AHB_SIGMUX_0(
  .i_sas_sdmaren   (sdma_ahbren[`SDMA_AHBDATAWIDTH/8-1:0]),
  .i_sas_sdmawen   (sdma_ahbwen[`SDMA_AHBDATAWIDTH/8-1:0]),
  .i_sas_sdmaraddr (sdma_ahbraddr[`SDMA_ADDRWIDTH-1:0]),
  .i_sas_sdmawaddr (sdma_ahbwaddr[`SDMA_ADDRWIDTH-1:0]),
  .o_sas_ahbena    (sdma_ahbena[`SDMA_AHBDATAWIDTH/8-1:0]),
  .o_sas_ahbwea    (sdma_ahbwea),
  .o_sas_ahbaddr   (sdma_ahbaddr[`SDMA_ADDRWIDTH-1:0])
);

rram_ahb_mem 
#(
  .AHB_DATA_WIDTH(32),
  .AHB_ADDR_WIDTH(32),
  .RRAM_DATA_WIDTH(32),
  .RRAM_ADDR_WIDTH(32),
  .RRAM_BMASK_WIDTH(4),
  .PORT_BMASK_WIDTH(4),
  .AHB_ADDR_OFFSET(32'h0000_0000),
  .SCLK_OR_NOT(1)
 )U_RRAM_AHB_MEM_0(
  .i_ahb_hclk		 (ahb_clk),
  .i_ahb_hrst_n		 (ahb_rst_n),
  .i_rram_clk        (ahb_clk),
  .i_rram_rst_n      (ahb_rst_n),
  .i_rram_mena       (sdma_ahbena),
  .i_rram_mwea       (sdma_ahbwea),
  .i_rram_maddr      (sdma_ahbaddr),
  .i_rram_mwdata     (sdma_ahbwdata),
  .o_rram_mready     (sdma_ahbready),
  .o_rram_merror     (ahb_error),
  .o_rram_mrdata     (sdma_ahbrdata),
  .o_rram_mrdata_vld (sdma_ahbrvld)
);

//-------------------------------------------------------------------------------
endmodule
