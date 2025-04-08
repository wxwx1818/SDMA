`timescale 1ns / 1ps

module unaligned_ahbram_hb #(
        parameter OUTER_ADDR_SIZE = 8		// Physical address
    ) (
        input                               clka,
        input [15:0]                         ena,
        input 							    wea,
        input [OUTER_ADDR_SIZE-1 : 0]       addra,
        input [127 : 0]       				dina,
        output reg [127 : 0]  				douta
    );

    reg     [127:0]  mem [0:2**(OUTER_ADDR_SIZE-4)-1];

	initial
    begin
    	$readmemh("/home/wx/Project/SDMA/tb/rram_ahb_mem/testfms_hb.dat",mem);
    end

	integer i;
    always@(posedge clka)
    begin
		if(wea)begin
			case(ena)
				16'b0000000000000001:begin
					for(i=0;i<16;i=i+1)begin
						if(addra[3:0] == i)begin
							mem[addra[OUTER_ADDR_SIZE-1:4]][i*8+:8] <= dina[7:0];
						end
					end
				end
				16'b0000000000000011:begin
					for(i=0;i<8;i=i+1)begin
						if(addra[3:1] == i)begin
							mem[addra[OUTER_ADDR_SIZE-1:4]][i*16+:16] <= dina[15:0];
						end
					end
				end
				16'b0000000000001111:begin
					for(i=0;i<4;i=i+1)begin
						if(addra[3:2] == i)begin
							mem[addra[OUTER_ADDR_SIZE-1:4]][i*32+:32] <= dina[31:0];
						end
					end
				end
				16'b0000000011111111:begin
					for(i=0;i<2;i=i+1)begin
						if(addra[3] == i)begin
							mem[addra[OUTER_ADDR_SIZE-1:4]][i*64+:64] <= dina[64:0];
						end
					end
				end
				16'b1111111111111111:begin
					mem[addra[OUTER_ADDR_SIZE-1:4]] <= dina;	
				end
				default:begin
					mem[addra[OUTER_ADDR_SIZE-1:4]] <= dina;
				end
			endcase
		end
		else begin
			case(ena)
				16'b0000000000000001:begin
					for(i=0;i<16;i=i+1)begin
						if(addra[3:0] == i)begin
							douta <= {120'b0,mem[addra[OUTER_ADDR_SIZE-1:4]][i*8+:8]};
						end
					end
				end
				16'b0000000000000011:begin
					for(i=0;i<8;i=i+1)begin
						if(addra[3:1] == i)begin
							douta <= {112'b0,mem[addra[OUTER_ADDR_SIZE-1:4]][i*16+:16]};
						end
					end
				end
				16'b0000000000001111:begin
					for(i=0;i<4;i=i+1)begin
						if(addra[3:2] == i)begin
							douta <= {96'b0,mem[addra[OUTER_ADDR_SIZE-1:4]][i*32+:32]};
						end
					end
				end
				16'b0000000011111111:begin
					for(i=0;i<2;i=i+1)begin
						if(addra[3] == i)begin
							douta <= {64'b0,mem[addra[OUTER_ADDR_SIZE-1:4]][i*64+:64]};
						end
					end
				end
				16'b1111111111111111:begin
					douta <= mem[addra[OUTER_ADDR_SIZE-1:4]];
				end
				default:begin
					douta <= mem[addra[OUTER_ADDR_SIZE-1:4]];
				end
			endcase
		end
    end
endmodule
