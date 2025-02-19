// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   sync_fifo.v
// AUTHOR   :   Hengxin Wang
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2024.1.31   Hengxin Wang    First release
// 1.1      2025.1.22   Hengxin Wang    Update 
// -----------------------------------------------------------------------------
// KEYWORDS : Synchronous FIFO
// -----------------------------------------------------------------------------
// PURPOSE : Synchronous FIFO with;
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE               DESCRIPTION         DEFAULT     UNITS
// DATA_WIDTH       [INF,1]             width of the data   32          bit
// FIFO_DEPTH       [2^32,1]            depth of the fifo   32          
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   clk
//  Critical Timing     :   None
//  Test Features       :   None
//  Asynchronous I/F    :   Y
//  Instantiations      :   None
//  Synthesizable (y/n) :   Y
//  Other Considerations:
// -FHDR------------------------------------------------------------------------


`timescale 1ns / 1ps

module sync_fifo #( // First Word Fall Through Mode!!!
    // +PARAMETER DECLARATION--------------------------------------------------------
    parameter DATA_WIDTH            = 8	            ,
    parameter FIFO_DEPTH            = 2	            ,
    parameter ALMOST_EMPTY_ENABLE   = 0             ,
    parameter ALMOST_FULL_ENABLE    = 0             ,
    parameter UNDERFLOW_ENABLE      = 0             ,
    parameter OVERFLOW_ENABLE       = 0             ,
    parameter ALMOST_FULL_NUM       = FIFO_DEPTH-1  ,
    parameter ALMOST_EMPTY_NUM      = 1             
    // -PARAMETER DECLARATION--------------------------------------------------------
)
(
    // +INPUT PORT DECLARATION-------------------------------------------------------
    input                           i_wr_clk				,
    input                           i_wr_rst_n			,
    input							i_wr_en				,
    input       [DATA_WIDTH-1:0]	i_wr_data		    ,
    
    input                           i_rd_clk				,
    input                           i_rd_rst_n			,
    input                           i_rd_en				,
    // -INPUT PORT DECLARATION-------------------------------------------------------
    
    // +OUTPUT PORT DECLARATION------------------------------------------------------
    output      [DATA_WIDTH-1:0]    o_rd_data			,
    output        					o_rd_data_vld		,
    output                          o_fifo_full			,
    output                          o_fifo_empty		,
    output                          o_fifo_almost_full	,
    output                          o_fifo_almost_empty	,
    output reg						o_overflow			,
    output  						o_underflow	
    // -OUTPUT PORT DECLARATION------------------------------------------------------
);

/*Parameters and Variables*/
// +INTERNAL Localparam DECLARATION----------------------------------------------
localparam  FIFO_CNT_WIDTH 	        =   $clog2(FIFO_DEPTH);
// -INTERNAL Localparam DECLARATION----------------------------------------------

// +INTERNAL Special Variables DECLARATION----------------------------------------------
genvar   gen_i;
// +INTERNAL Special Variables DECLARATION----------------------------------------------

// +INTERNAL Register DECLARATION-----------------------------------------------------
reg     [FIFO_DEPTH*DATA_WIDTH-1 : 0]   fifo;
reg     [FIFO_CNT_WIDTH:0]              read_ptr;
reg     [FIFO_CNT_WIDTH:0]              write_ptr;
// -INTERNAL Register DECLARATION-----------------------------------------------------

// +INTERNAL Wire DECLARATION----------------------------------------------------
wire    [FIFO_CNT_WIDTH:0]            fifo_cnt;
// +INTERNAL Wire DECLARATION----------------------------------------------------

/*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
// +INTERNAL Assign DECLARATION--------------------------------------------------
generate
    assign o_fifo_full              = (fifo_cnt == FIFO_DEPTH);
    assign o_fifo_empty             = (fifo_cnt == {(FIFO_CNT_WIDTH+1){1'b0}});
    if (ALMOST_FULL_ENABLE) begin
        assign o_fifo_almost_full   = (fifo_cnt >= ALMOST_FULL_NUM);
    end
    if (ALMOST_EMPTY_ENABLE) begin
        assign o_fifo_almost_empty  = (fifo_cnt <= ALMOST_EMPTY_NUM);
    end
    if (UNDERFLOW_ENABLE) begin
        assign o_underflow          = i_rd_en && o_fifo_empty;
    end
endgenerate

assign o_rd_data        = i_rd_en ? fifo[(DATA_WIDTH*read_ptr[0 +: FIFO_CNT_WIDTH]) +: DATA_WIDTH] : {DATA_WIDTH{1'b0}};
assign o_rd_data_vld    = i_rd_en && ~o_fifo_empty;

assign fifo_cnt         = (write_ptr[FIFO_CNT_WIDTH] == read_ptr[FIFO_CNT_WIDTH]) ? 
                        (write_ptr[FIFO_CNT_WIDTH-1 : 0] - read_ptr[FIFO_CNT_WIDTH-1 : 0]) : 
                        (write_ptr[FIFO_CNT_WIDTH-1 : 0] - read_ptr[FIFO_CNT_WIDTH-1 : 0] + FIFO_DEPTH);
// -INTERNAL Assign DECLARATION--------------------------------------------------

/* Read/write ptr part----------------------------------------------------------------------------------------------------*/
// write_ptr logic
always@(posedge i_wr_clk or negedge i_wr_rst_n) begin
    if(~i_wr_rst_n) begin
        write_ptr       <= {(FIFO_CNT_WIDTH+1){1'b0}};
    end else begin
        if(i_wr_en && ~o_fifo_full) begin
            write_ptr <= write_ptr + 1'b1;
        end
    end
end

// read_ptr logic
always@(posedge i_rd_clk or negedge i_rd_rst_n) begin
    if(~i_rd_rst_n) begin
        read_ptr       <= {(FIFO_CNT_WIDTH+1){1'b0}};
    end else begin
        if(i_rd_en && ~o_fifo_empty) begin
            read_ptr <= read_ptr + 1'b1;
        end
    end
end

/* fifo write part----------------------------------------------------------------------------------------------------*/
// fifo read/write logic
generate
    for (gen_i = 0; gen_i < FIFO_DEPTH; gen_i = gen_i+1) begin
        always@(posedge i_wr_clk or negedge i_wr_rst_n) begin
            if(~i_wr_rst_n) begin
                fifo[gen_i*DATA_WIDTH +: DATA_WIDTH] <= {DATA_WIDTH{1'b0}};
            end else begin
                if(i_wr_en && ~o_fifo_full && write_ptr[0 +: FIFO_CNT_WIDTH] == gen_i) begin
                    fifo[gen_i*DATA_WIDTH +: DATA_WIDTH] <= i_wr_data;
                end
            end
        end
    end
endgenerate

/* fifo state signal part----------------------------------------------------------------------------------------------------*/
// overflow logic
generate
    if (OVERFLOW_ENABLE) begin
        always@(posedge i_wr_clk or negedge i_wr_rst_n) begin
            if(~i_wr_rst_n) begin
                o_overflow <= 1'b0;
            end else begin
                if(i_wr_en && o_fifo_full) begin
                    o_overflow <= 1'b1;
                end else begin
                    o_overflow <= 1'b0;
                end
            end
        end
    end
endgenerate

endmodule
