// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   ahb_port_slave.v
// AUTHOR   :   Hengxin Wang
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2024.1.31   Hengxin Wang    First release
// 1.1      2025.1.22   Hengxin Wang    add hsize function
// -----------------------------------------------------------------------------
// KEYWORDS : AHB-Lite, Slave, Synchronous FIFO
// -----------------------------------------------------------------------------
// PURPOSE : Connect a submodule to AHB-Lite bus as a slave between different or same synchronous clock regions;
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME       RANGE               DESCRIPTION                         DEFAULT     UNITS
// DATA_WIDTH       [32,1]              width of the data                   32          bit
// ADDR_WIDTH       [32,1]              width of the addr                   32          bit
// PORT_BMASK_WIDTH                     width of the bytemask               4          bit
// AHB_ADDR_OFFSET  [0xffffffff,0x0]    addr offset in ahb                  0x0         
// SCLK_OR_NOT      1 or 0              if ahb_hclk and port_clk are same   0         
// FIFO_DEPTH       [INF,2]             depth of the FIFO                   2        
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   ahb_hclk, port_clk
//  Critical Timing     :   N/A
//  Test Features       :   None
//  Asynchronous I/F    :   Both
//  Instantiations      :   ahb_port_slave_wo_sfifo, ahb_port_slave_w_sfifo, sync_fifo
//  Synthesizable (y/n) :   Y
//  Other Considerations:   None
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps

module ahb_port_slave #(
// +PARAMETER DECLARATION--------------------------------------------------------
	parameter	DATA_WIDTH			= 32            ,	// Port data bitwidth
	parameter	ADDR_WIDTH			= 32            ,	// Port address width
    parameter   PORT_BMASK_WIDTH    = 4             ,   // Port Byte mask
	parameter	AHB_ADDR_OFFSET		= 32'h0000_0000 ,	// AHB slave start address 
	parameter	SCLK_OR_NOT			= 0	            ,	// Relation between ahb_hclk and port_clk (1: same-delete fifo, 0: non-same, must be sync clock)
	parameter	FIFO_DEPTH			= 2					// FIFO depth
// -PARAMETER DECLARATION--------------------------------------------------------
)
(
// +INPUT PORT DECLARATION-------------------------------------------------------
    // AHB INPUTS (w/ AHB_ADDR_OFFSET)
    input              					ahb_hclk        ,			// AHB Clock input (high-speed clock)   
    input              					ahb_hrst_n      ,			// AHB Reset asynchronous Active low       
    input              					ahb_hsel        ,			// AHB Slave select signal
    input       [ADDR_WIDTH-1:0] 		ahb_haddr       ,			// AHB Address bus
    input       [3:0] 					ahb_hprot       ,			// AHB Protection control signals (this version: keeping 4'b0011, don't used)
    input       [2:0] 					ahb_hsize       ,			// AHB Transfer size signals (this version: all mode supported)
    input       [1:0]					ahb_htrans      ,			// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
    input       [DATA_WIDTH-1:0]		ahb_hwdata      ,			// AHB Write data bus
    input              					ahb_hwrite      ,			// AHB Write enable signal
	input		[2:0]					ahb_hburst      ,			// AHB Burst transfer type (this version: keeping 3'b000?) 
	input                           	ahb_hreadyin    ,       // AHB Bus hready signal input
	
	// Port INPUTS 
	input								port_clk        ,			// Port Input clock (low-speed clock)
	input								port_rst_n      ,			// Port input reset (active low)
	input		[DATA_WIDTH-1:0]		port_rdata      ,			// Port Input data
	input								port_ready      ,			// Port Input write/read ready (delay 1 cycle after port_ena,1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
	input								port_error      ,			// Port Input write/read error (delay n cycle after port_ena,sync with port_ready, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
// -INPUT PORT DECLARATION-------------------------------------------------------

// +OUTPUT PORT DECLARATION------------------------------------------------------
    // AHB OUTPUTS 
    output		[DATA_WIDTH-1:0]		ahb_hrdata      ,			// AHB Read data bus
    output 		        				ahb_hready      ,			// AHB Transfer ready signal (active high)
    output		[1:0]					ahb_hresp       ,			// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)

	// Port OUTPUTS (w/o AHB_ADDR_OFFSET)
	output		[PORT_BMASK_WIDTH-1:0]	port_ena        ,			// Port Output write/read enable (i.e. SRAM timing)
	output								port_wea        ,			// port Output write/read mode (i.e. SRAM timing)
	output		[ADDR_WIDTH-1:0]		port_addr       ,			// Port Output address (i.e. SRAM timing)
	output		[DATA_WIDTH-1:0]		port_wdata      ,			// Port Output write data (delay n-cycle after port_ena that n >= 1, and not after next port_ena) 
	output								port_wdata_vld   	        // Port Output valid of write data (delay n-cycle after port_ena that n >= 1, and not after next port_ena) 
// -OUTPUT PORT DECLARATION------------------------------------------------------
);  
/*Generate logic----------------------------------------------------------------------------------------------------*/
    generate
        if(SCLK_OR_NOT) begin   // same clk
            ahb_port_slave_wo_sfifo #(
                .DATA_WIDTH     	(DATA_WIDTH     ),		// Port data bitwidth
                .ADDR_WIDTH     	(ADDR_WIDTH     ),		// Port address width
    			.PORT_BMASK_WIDTH   (PORT_BMASK_WIDTH),   // Port Byte mask
                .AHB_ADDR_OFFSET	(AHB_ADDR_OFFSET)		// AHB slave start address 
            ) u0_ahb_port_slave_wo_sfifo(
                // AHB INPUTS (w/ AHB_ADDR_OFFSET)
                .ahb_hclk       (ahb_hclk       ),		// AHB Clock input (high-speed clock)   
                .ahb_hrst_n     (ahb_hrst_n     ),		// AHB Reset asynchronous Active low       
                .ahb_hsel       (ahb_hsel       ),		// AHB Slave select signal
                .ahb_haddr      (ahb_haddr      ),		// AHB Address bus
                .ahb_hprot      (ahb_hprot      ),		// AHB Protection control signals (this version: keeping 4'b0011, don't used)
                .ahb_hsize      (ahb_hsize      ),		// AHB Transfer size signals (this version: all mode supported)
                .ahb_htrans     (ahb_htrans     ),		// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
                .ahb_hwdata     (ahb_hwdata     ),		// AHB Write data bus
                .ahb_hwrite     (ahb_hwrite     ),		// AHB Write enable signal
                .ahb_hburst     (ahb_hburst     ),		// AHB Burst transfer type (this version: keeping 3'b000?) 
                .ahb_hreadyin   (ahb_hreadyin   ),      // AHB Bus hready signal input
            
                // AHB OUTPUTS 
                .ahb_hrdata     (ahb_hrdata     ),		// AHB Read data bus
                .ahb_hready     (ahb_hready     ),		// AHB Transfer ready signal (active high)
                .ahb_hresp      (ahb_hresp      ),		// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
            
                // Port INPUTS 
                .port_clk       (port_clk       ),		// Port Input clock (low-speed clock)
                .port_rst_n     (port_rst_n     ),		// Port input reset (active low)
                .port_rdata     (port_rdata     ),		// Port Input data
                .port_ready     (port_ready     ),		// Port Input write/read ready (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
                .port_error     (port_error     ),		// Port Input write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
                
                // Port OUTPUTS (w/o AHB_ADDR_OFFSET)
                .port_ena       (port_ena       ),		// Port Output write/read enable (i.e. SRAM timing)
                .port_wea       (port_wea       ),		// port Output write/read mode (i.e. SRAM timing)
                .port_addr      (port_addr      ),		// Port Output address (i.e. SRAM timing)
                .port_wdata     (port_wdata     ),		// Port Output write data (delay n-cycle)
                .port_wdata_vld (port_wdata_vld )		// Port Output valid of write data (delay n-cycle)
            );
        end else begin          // different clk
            ahb_port_slave_w_sfifo #(
                .DATA_WIDTH     (DATA_WIDTH     ),		// Port data bitwidth
                .ADDR_WIDTH     (ADDR_WIDTH     ),		// Port address width
    			.PORT_BMASK_WIDTH   (PORT_BMASK_WIDTH),   // Port Byte mask
                .AHB_ADDR_OFFSET(AHB_ADDR_OFFSET),		// AHB slave start address 
                .FIFO_DEPTH     (FIFO_DEPTH     )       // FIFO depth
            ) u0_ahb_port_slave_w_sfifo(
                // AHB INPUTS (w/ AHB_ADDR_OFFSET)
                .ahb_hclk       (ahb_hclk       ),		// AHB Clock input (high-speed clock)   
                .ahb_hrst_n     (ahb_hrst_n     ),		// AHB Reset asynchronous Active low       
                .ahb_hsel       (ahb_hsel       ),		// AHB Slave select signal
                .ahb_haddr      (ahb_haddr      ),		// AHB Address bus
                .ahb_hprot      (ahb_hprot      ),		// AHB Protection control signals (this version: keeping 4'b0011, don't used)
                .ahb_hsize      (ahb_hsize      ),		// AHB Transfer size signals (this version: all mode supported)
                .ahb_htrans     (ahb_htrans     ),		// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
                .ahb_hwdata     (ahb_hwdata     ),		// AHB Write data bus
                .ahb_hwrite     (ahb_hwrite     ),		// AHB Write enable signal
                .ahb_hburst     (ahb_hburst     ),		// AHB Burst transfer type (this version: keeping 3'b000?) 
                .ahb_hreadyin   (ahb_hreadyin   ),      // AHB Bus hready signal input
            
                // AHB OUTPUTS 
                .ahb_hrdata     (ahb_hrdata     ),		// AHB Read data bus
                .ahb_hready     (ahb_hready     ),		// AHB Transfer ready signal (active high)
                .ahb_hresp      (ahb_hresp      ),		// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
            
                // Port INPUTS 
                .port_clk       (port_clk       ),		// Port Input clock (low-speed clock)
                .port_rst_n     (port_rst_n     ),		// Port input reset (active low)
                .port_rdata     (port_rdata     ),		// Port Input data
                .port_ready     (port_ready     ),		// Port Input write/read ready (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
                .port_error     (port_error     ),		// Port Input write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
                
                // Port OUTPUTS (w/o AHB_ADDR_OFFSET)
                .port_ena       (port_ena       ),		// Port Output write/read enable (i.e. SRAM timing)
                .port_wea       (port_wea       ),		// port Output write/read mode (i.e. SRAM timing)
                .port_addr      (port_addr      ),		// Port Output address (i.e. SRAM timing)
                .port_wdata     (port_wdata     ),		// Port Output write data (delay n-cycle)
                .port_wdata_vld (port_wdata_vld )		// Port Output valid of write data (delay n-cycle)
            );
        end
    endgenerate
endmodule
