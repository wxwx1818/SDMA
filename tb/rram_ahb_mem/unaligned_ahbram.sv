`timescale 1ns / 1ps

module unaligned_ahbram #(
        parameter OUTER_ADDR_SIZE = 8		// Physical address
    ) (
        input                               clka,
        input [3:0]                         ena,
        input 							    wea,
        input [OUTER_ADDR_SIZE-1 : 0]       addra,
        input [32-1 : 0]       				dina,
        output reg [32-1 : 0]  				douta
    );

    reg     [32-1:0]  mem [2**(OUTER_ADDR_SIZE-2)-1:0];

	initial
    begin
    	$readmemh("/home/wx/Project/SDMA/tb/rram_ahb_mem/testfms.dat",mem);
    end

    always@(posedge clka)
    begin
		if(wea)begin
			case(ena)
				4'b0001:begin
					case(addra[1:0])
						2'b00:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {mem[addra[OUTER_ADDR_SIZE-1:2]][31:8],dina[7:0]};
						end
						2'b01:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {mem[addra[OUTER_ADDR_SIZE-1:2]][31:16],dina[7:0],mem[addra[OUTER_ADDR_SIZE-1:2]][7:0]};	
						end
						2'b10:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {mem[addra[OUTER_ADDR_SIZE-1:2]][31:24],dina[7:0],mem[addra[OUTER_ADDR_SIZE-1:2]][15:0]};
						end
						2'b11:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {dina[7:0],mem[addra[OUTER_ADDR_SIZE-1:2]][23:0]};
						end
					endcase
				end
				4'b0011:begin
					case(addra[1])
						1'b0:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {mem[addra[OUTER_ADDR_SIZE-1:2]][31:16],dina[15:0]};
						end
						1'b1:begin
							mem[addra[OUTER_ADDR_SIZE-1:2]] <= {dina[15:0],mem[addra[OUTER_ADDR_SIZE-1:2]][15:0]};
						end
					endcase
				end
				4'b1111:begin
					mem[addra[OUTER_ADDR_SIZE-1:2]] <= dina;
				end
				default:begin
					mem[addra[OUTER_ADDR_SIZE-1:2]] <= dina;
				end
			endcase
		end
		else begin
			case(ena)
				4'b0001:begin
					case(addra[1:0])
						2'b00:begin
							douta <= {24'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][7:0]};
						end
						2'b01:begin
							douta <= {24'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][15:8]};
						end
						2'b10:begin
							douta <= {24'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][23:16]};
						end
						2'b11:begin
							douta <= {24'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][31:24]};
						end
					endcase
				end
				4'b0011:begin
					case(addra[1])
						1'b0:begin
							douta <= {16'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][15:0]};
						end
						1'b1:begin
							douta <= {16'b0,mem[addra[OUTER_ADDR_SIZE-1:2]][31:16]};
						end
					endcase
				end
				4'b1111:begin
					douta <= mem[addra[OUTER_ADDR_SIZE-1:2]];
				end
				default:begin
					douta <= mem[addra[OUTER_ADDR_SIZE-1:2]];
				end
			endcase
		end
    end
endmodule
