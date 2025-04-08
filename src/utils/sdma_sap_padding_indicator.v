// -----------------------------------------------------------------------------
// FILE NAME : sdma_sap_padding_indicator.v
// AUTHOR : WangXu
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2024-1-15
// -----------------------------------------------------------------------------
// DESCRIPTION : Indicate when the padding of dst fms happened. 
// -----------------------------------------------------------------------------
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"
module sdma_sap_padding_indicator
(
	input													i_sap_pi_paddingen,
	input  		[`SDMA_INST_PADDINGLEFTXWIDTH - 1:0]  		i_sap_pi_paddingleftx,
	input  		[`SDMA_INST_PADDINGRIGHTXWIDTH - 1:0]  		i_sap_pi_paddingrightx,
	input  		[`SDMA_INST_PADDINGLEFTYWIDTH - 1:0]  		i_sap_pi_paddinglefty,
	input  		[`SDMA_INST_PADDINGRIGHTYWIDTH - 1:0]  		i_sap_pi_paddingrighty,
	input													i_sap_pi_upsampleen,
	input  		[`SDMA_INST_INSERTZERONUMTOTALXWIDTH - 1:0] i_sap_pi_insertzeronumtotalx,
	input  		[`SDMA_INST_INSERTZERONUMTOTALYWIDTH - 1:0] i_sap_pi_insertzeronumtotaly,
	input  		[`SDMA_INST_SRCFMSCWIDTH - 1:0]  			i_sap_pi_srcfmsc,
	input  		[`SDMA_INST_SRCFMSXWIDTH - 1:0]  			i_sap_pi_srcfmsx,
	input  		[`SDMA_INST_SRCFMSYWIDTH - 1:0]  			i_sap_pi_srcfmsy,	
	input  		[`SDMA_INST_PADDINGAXISBEFOREWIDTH - 1:0]	i_sap_pi_paddingaxisbefore,
	input		[`SDMA_INST_SRCFMSCWIDTH - 1:0]				i_sap_pi_sfmsccnt,
	input		[`SDMA_INST_SRCFMSXWIDTH - 1:0]				i_sap_pi_sfmsxcnt,
	input		[`SDMA_INST_SRCFMSYWIDTH - 1:0]				i_sap_pi_sfmsycnt,
	output 	reg												o_sap_pi_padding_flag
);

//----------------------------------VARIABLES-----------------------------------

reg	[`SDMA_INST_SRCFMSXWIDTH - 1:0]		x_padding_cnt_1stage;
reg	[`SDMA_INST_SRCFMSXWIDTH - 1:0]		x_padding_cnt_2stage;
reg	[`SDMA_INST_SRCFMSXWIDTH - 1:0]		x_padding_cnt_3stage;
reg	[`SDMA_INST_SRCFMSYWIDTH - 1:0]		y_padding_cnt_1stage;
reg	[`SDMA_INST_SRCFMSYWIDTH - 1:0]		y_padding_cnt_2stage;
reg	[`SDMA_INST_SRCFMSYWIDTH - 1:0]		y_padding_cnt_3stage;


//------------------------------------------------------------------------------


//----------------------------------OUTPUT LOGIC--------------------------------
always@(*)begin
	case(i_sap_pi_paddingaxisbefore[2:0])
		3'b000:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_paddingrighty;
			end
		end
		3'b111:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_paddingrighty;
			end		
		end
		3'b001:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsx + i_sap_pi_paddingrighty;
			end
		end
		3'b110:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_paddingrighty;
			end	
		end
		3'b010:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsc + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_paddingrighty;
			end	
		end
		3'b101:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsy + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsc + i_sap_pi_paddingrighty;
			end	
		end
		default:begin
			if(i_sap_pi_upsampleen)begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_insertzeronumtotalx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_insertzeronumtotaly + i_sap_pi_paddingrighty;
			end
			else begin
				x_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSXWIDTH-`SDMA_INST_PADDINGLEFTXWIDTH){1'b0}},i_sap_pi_paddingleftx};
				x_padding_cnt_2stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx;
				x_padding_cnt_3stage = i_sap_pi_paddingleftx + i_sap_pi_srcfmsx + i_sap_pi_paddingrightx;
				y_padding_cnt_1stage = {{(`SDMA_INST_SRCFMSYWIDTH-`SDMA_INST_PADDINGLEFTYWIDTH){1'b0}},i_sap_pi_paddinglefty};
				y_padding_cnt_2stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy;
				y_padding_cnt_3stage = i_sap_pi_paddinglefty + i_sap_pi_srcfmsy + i_sap_pi_paddingrighty;
			end
		end
	endcase
end

always@(*)begin
	if(i_sap_pi_paddingen)begin
		case(i_sap_pi_paddingaxisbefore[2:0])
			3'b000:begin 
				o_sap_pi_padding_flag = (i_sap_pi_sfmsxcnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsxcnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsxcnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsycnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsycnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsycnt < y_padding_cnt_3stage)); 
			end
			3'b111:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsycnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsycnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsycnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsxcnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsxcnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsxcnt < y_padding_cnt_3stage));
			end
			3'b001:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsccnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsccnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsccnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsxcnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsxcnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsxcnt < y_padding_cnt_3stage));	
			end
			3'b110:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsxcnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsxcnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsxcnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsccnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsccnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsccnt < y_padding_cnt_3stage));	
			end
			3'b010:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsccnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsccnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsccnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsycnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsycnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsycnt < y_padding_cnt_3stage));
			end
			3'b101:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsycnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsycnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsycnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsccnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsccnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsccnt < y_padding_cnt_3stage));	
			end
			default:begin
				o_sap_pi_padding_flag = (i_sap_pi_sfmsxcnt < x_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsxcnt>= x_padding_cnt_2stage)&&(i_sap_pi_sfmsxcnt < x_padding_cnt_3stage))
									  ||(i_sap_pi_sfmsycnt < y_padding_cnt_1stage)
									  ||((i_sap_pi_sfmsycnt>= y_padding_cnt_2stage)&&(i_sap_pi_sfmsycnt < y_padding_cnt_3stage));
			end
		endcase
	end
	else begin
		o_sap_pi_padding_flag = 1'b0;
	end
end

//------------------------------------------------------------------------------

endmodule
