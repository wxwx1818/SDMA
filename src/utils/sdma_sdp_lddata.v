// -----------------------------------------------------------------------------
// FILE NAME : sdma_sdp_lddata.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-1-18
// -----------------------------------------------------------------------------
// DESCRIPTION : Load data from data_buffer according to ldb_num. 
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_sdp_lddata
(
	input  		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]		i_sdp_l_doutcnt,
	input  		[`SDMA_CACHEDATAWIDTH-1:0]				i_sdp_l_databuffer,
	input  		[`SDMA_SECTION_DINNUMDATAWIDTH-1:0]		i_sdp_l_ldbnum,
	output reg	[`SDMA_CACHEDATAWIDTH-1:0]				o_sdp_l_lddataany
);

//----------------------------------OUTPUT LOGIC--------------------------------

always @(*) begin
    case (i_sdp_l_ldbnum)
	    7'd0: begin
			o_sdp_l_lddataany  = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd1: begin
		if(i_sdp_l_doutcnt < 64)
				o_sdp_l_lddataany  = {{(`SDMA_CACHEDATAWIDTH - 8){1'b0}},i_sdp_l_databuffer[i_sdp_l_doutcnt*8+:8]};
	    else 
				o_sdp_l_lddataany  = {(`SDMA_CACHEDATAWIDTH){1'b0}};	
	    end
	    7'd2: begin
		if(i_sdp_l_doutcnt < 63)
				o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 16){1'b0}},i_sdp_l_databuffer[i_sdp_l_doutcnt*8+:16]};
	    else 
				o_sdp_l_lddataany  = {(`SDMA_CACHEDATAWIDTH){1'b0}};
		end
	    7'd3: begin
		if (i_sdp_l_doutcnt < 62)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 24){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 24]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd4: begin
		if (i_sdp_l_doutcnt < 61)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 32){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 32]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd5: begin
		if (i_sdp_l_doutcnt < 60)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 40){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 40]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd6: begin
		if (i_sdp_l_doutcnt < 59)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 48){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 48]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd7: begin
		if (i_sdp_l_doutcnt < 58)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 56){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 56]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd8: begin
		if (i_sdp_l_doutcnt < 57)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 64){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 64]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd9: begin
		if (i_sdp_l_doutcnt < 56)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 72){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 72]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd10: begin
		if (i_sdp_l_doutcnt < 55)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 80){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 80]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd11: begin
		if (i_sdp_l_doutcnt < 54)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 88){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 88]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd12: begin
		if (i_sdp_l_doutcnt < 53)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 96){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 96]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd13: begin
		if (i_sdp_l_doutcnt < 52)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 104){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 104]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd14: begin
		if (i_sdp_l_doutcnt < 51)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 112){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 112]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd15: begin
		if (i_sdp_l_doutcnt < 50)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 120){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 120]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd16: begin
		if (i_sdp_l_doutcnt < 49)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 128){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 128]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd17: begin
		if (i_sdp_l_doutcnt < 48)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 136){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 136]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd18: begin
		if (i_sdp_l_doutcnt < 47)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 144){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 144]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd19: begin
		if (i_sdp_l_doutcnt < 46)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 152){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 152]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd20: begin
		if (i_sdp_l_doutcnt < 45)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 160){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 160]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd21: begin
		if (i_sdp_l_doutcnt < 44)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 168){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 168]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd22: begin
		if (i_sdp_l_doutcnt < 43)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 176){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 176]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd23: begin
		if (i_sdp_l_doutcnt < 42)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 184){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 184]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd24: begin
		if (i_sdp_l_doutcnt < 41)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 192){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 192]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd25: begin
		if (i_sdp_l_doutcnt < 40)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 200){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 200]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd26: begin
		if (i_sdp_l_doutcnt < 39)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 208){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 208]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd27: begin
		if (i_sdp_l_doutcnt < 38)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 216){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 216]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd28: begin
		if (i_sdp_l_doutcnt < 37)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 224){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 224]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd29: begin
		if (i_sdp_l_doutcnt < 36)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 232){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 232]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd30: begin
		if (i_sdp_l_doutcnt < 35)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 240){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 240]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd31: begin
		if (i_sdp_l_doutcnt < 34)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 248){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 248]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd32: begin
		if (i_sdp_l_doutcnt < 33)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 256){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 256]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd33: begin
		if (i_sdp_l_doutcnt < 32)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 264){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 264]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd34: begin
		if (i_sdp_l_doutcnt < 31)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 272){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 272]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd35: begin
		if (i_sdp_l_doutcnt < 30)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 280){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 280]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd36: begin
		if (i_sdp_l_doutcnt < 29)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 288){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 288]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd37: begin
		if (i_sdp_l_doutcnt < 28)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 296){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 296]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd38: begin
		if (i_sdp_l_doutcnt < 27)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 304){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 304]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd39: begin
		if (i_sdp_l_doutcnt < 26)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 312){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 312]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd40: begin
		if (i_sdp_l_doutcnt < 25)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 320){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 320]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd41: begin
		if (i_sdp_l_doutcnt < 24)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 328){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 328]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd42: begin
		if (i_sdp_l_doutcnt < 23)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 336){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 336]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd43: begin
		if (i_sdp_l_doutcnt < 22)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 344){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 344]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd44: begin
		if (i_sdp_l_doutcnt < 21)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 352){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 352]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd45: begin
		if (i_sdp_l_doutcnt < 20)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 360){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 360]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd46: begin
		if (i_sdp_l_doutcnt < 19)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 368){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 368]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd47: begin
		if (i_sdp_l_doutcnt < 18)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 376){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 376]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd48: begin
		if (i_sdp_l_doutcnt < 17)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 384){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 384]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd49: begin
		if (i_sdp_l_doutcnt < 16)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 392){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 392]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd50: begin
		if (i_sdp_l_doutcnt < 15)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 400){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 400]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd51: begin
		if (i_sdp_l_doutcnt < 14)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 408){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 408]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd52: begin
		if (i_sdp_l_doutcnt < 13)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 416){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 416]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd53: begin
		if (i_sdp_l_doutcnt < 12)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 424){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 424]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd54: begin
		if (i_sdp_l_doutcnt < 11)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 432){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 432]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd55: begin
		if (i_sdp_l_doutcnt < 10)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 440){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 440]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd56: begin
		if (i_sdp_l_doutcnt < 9)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 448){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 448]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd57: begin
		if (i_sdp_l_doutcnt < 8)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 456){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 456]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd58: begin
		if (i_sdp_l_doutcnt < 7)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 464){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 464]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd59: begin
		if (i_sdp_l_doutcnt < 6)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 472){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 472]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd60: begin
		if (i_sdp_l_doutcnt < 5)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 480){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 480]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd61: begin
		if (i_sdp_l_doutcnt < 4)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 488){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 488]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd62: begin
		if (i_sdp_l_doutcnt < 3)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 496){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 496]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd63: begin
		if (i_sdp_l_doutcnt < 2)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 504){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 504]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end
	    7'd64: begin
		if (i_sdp_l_doutcnt < 1)
		    o_sdp_l_lddataany = {{(`SDMA_CACHEDATAWIDTH - 512){1'b0}}, i_sdp_l_databuffer[i_sdp_l_doutcnt * 8 +: 512]};
		else
		    o_sdp_l_lddataany = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end 
	    default: begin
			o_sdp_l_lddataany  = {(`SDMA_CACHEDATAWIDTH){1'b0}};
	    end 
    endcase
end
//------------------------------------------------------------------------------

endmodule
