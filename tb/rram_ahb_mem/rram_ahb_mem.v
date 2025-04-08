// +FHDR------------------------------------------------------------------------
// UESTC SICE IoTSIS KWS&SV Group.
// IoTSIS Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME:   rram_ahb_mem.v
// AUTHOR   :   Hengxin Wang 
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR          DESCRIPTION
// 1.0      2025.1.22   Hengxin Wang    First release
// -----------------------------------------------------------------------------
// KEYWORDS : RRAM AHB
// -----------------------------------------------------------------------------
// PURPOSE : RRAM MEM
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME           RANGE           			DESCRIPTION                     DEFAULT     UNITS
// -----------------------------------------------------------------------------
// REUSE ISSUES
//  Reset Strategy      :   Asynchronous, active low system level reset
//  Clock Domains       :   ahb_hclk, rram_clk
//  Critical Timing     :   
//  Test Features       :   
//  Asynchronous I/F    :   
//  Instantiations      :   
//  Synthesizable (y/n) :   Y
//  Other Considerations:   none
// -FHDR------------------------------------------------------------------------

`timescale 1ns / 1ps
`include "/home/wx/Project/SDMA/src/vhead/nsdm.vh"

module rram_ahb_mem 
#(
// +PARAMETER DECLARATION--------------------------------------------------------
	parameter	AHB_DATA_WIDTH			= 32    ,				// AHB data bitwidth
	parameter	AHB_ADDR_WIDTH			= 32    ,				// AHB address width
	parameter	RRAM_DATA_WIDTH			= 32    ,				// RRAM data bitwidth
	parameter	RRAM_ADDR_WIDTH			= 32    ,				// RRAM address width
	parameter   RRAM_BMASK_WIDTH        = 4     ,
    parameter   PORT_BMASK_WIDTH    	= 4             ,   // Port Byte mask
	parameter	AHB_ADDR_OFFSET			= 32'h0000_0000 ,	// AHB slave start address 
	parameter	SCLK_OR_NOT				= 0	            	// Relation between ahb_hclk and port_clk (1: same-delete fifo, 0: non-same, must be sync clock)
// -PARAMETER DECLARATION--------------------------------------------------------
)
(
	// +INPUT PORT DECLARATION-------------------------------------------------------
	input              						i_ahb_hclk        ,			// AHB Clock input (high-speed clock)   
	input              						i_ahb_hrst_n      ,			// AHB Reset asynchronous Active low
	// RRAM INPUTS
	input								    i_rram_clk        ,	// RRAM Input clock (low-speed clock)
	input								    i_rram_rst_n      ,	// RRAM input reset (active low)
	input		[RRAM_BMASK_WIDTH-1:0]		i_rram_mena       ,	// RRAM Input write/read enable (i.e. SRAM timing)
	input								    i_rram_mwea       ,	// RRAM Input write/read mode (i.e. SRAM timing)
	input		[RRAM_ADDR_WIDTH-1:0]		i_rram_maddr      ,	// RRAM Input address (i.e. SRAM timing)
	input		[RRAM_DATA_WIDTH-1:0]		i_rram_mwdata     ,	// RRAM Input write data (i.e. SRAM timing)
	// -INPUT PORT DECLARATION-------------------------------------------------------

	// +OUTPUT PORT DECLARATION------------------------------------------------------	
	// RRAM OUTPUTS
	output								    o_rram_mready     ,	// RRAM Input write/read ready (delay 1 cycle after rram_mena, 1'b0: master can't process the next data)
	output								    o_rram_merror     ,	// RRAM Input write/read error (delay n cycle after rram_mena, sync with rram_ready, 1'b1:error, 1'b0:normal)
	output		[RRAM_DATA_WIDTH-1:0]		o_rram_mrdata     ,	// RRAM Output read data (delay n cycle after rram_mena, sync with rram_ready)
	output		[RRAM_BMASK_WIDTH-1:0]	    o_rram_mrdata_vld	// RRAM Output read data valid (delay n cycle after rram_mena, sync with rram_ready)
	// -OUTPUT PORT DECLARATION------------------------------------------------------
);


/*Parameters and Variables*/
// +INTERNAL Localparam DECLARATION----------------------------------------------

    localparam AHB_HTRANS_IDLE      = 2'b00;    // o_ahb_mhtrans IDLE state define
    localparam AHB_HTRANS_BUSY      = 2'b01;    // o_ahb_mhtrans BUSY state define
    localparam AHB_HTRANS_NONSEQ    = 2'b10;    // o_ahb_mhtrans NONSEQ state define
    localparam AHB_HTRANS_SEQ       = 2'b11;    // o_ahb_mhtrans SEQ state define

    localparam AHB_HBRUST_SINGLE    = 3'b000;
    localparam AHB_HBRUST_INCR      = 3'b001;
    localparam AHB_HBRUST_WRAP4     = 3'b010;
    localparam AHB_HBRUST_INCR4     = 3'b011;
    localparam AHB_HBRUST_WRAP8     = 3'b100;
    localparam AHB_HBRUST_INCR8     = 3'b101;
    localparam AHB_HBRUST_WRAP16    = 3'b110;
    localparam AHB_HBRUST_INCR16    = 3'b111;

    localparam AHB_HWRITE_READ      = 1'b0;
    localparam AHB_HWRITE_WRITE     = 1'b0;

    localparam AHB_HSIZE_8_BIT      = 3'b000;
    localparam AHB_HSIZE_16_BIT     = 3'b001;
    localparam AHB_HSIZE_32_BIT     = 3'b010;
    localparam AHB_HSIZE_64_BIT     = 3'b011;
    localparam AHB_HSIZE_128_BIT    = 3'b100;
    localparam AHB_HSIZE_256_BIT    = 3'b101;
    localparam AHB_HSIZE_512_BIT    = 3'b110;
    localparam AHB_HSIZE_1024_BIT   = 3'b111;

    localparam AHB_HREADY_OK        = 1'b1;
    localparam AHB_HREADY_DELAY     = 1'b0;

    localparam AHB_HRESP_OKAY       = 2'b00;
    localparam AHB_HRESP_ERROR      = 2'b01;
    localparam AHB_HRESP_RETRY      = 2'b10;
    localparam AHB_HRESP_SPLIT      = 2'b11;
// -INTERNAL Localparam DECLARATION----------------------------------------------
    
// +INTERNAL Special Variables DECLARATION----------------------------------------------
// +INTERNAL Special Variables DECLARATION----------------------------------------------

// +INTERNAL Register DECLARATION-----------------------------------------------------
// -INTERNAL Register DECLARATION-----------------------------------------------------
    
// +INTERNAL Wire DECLARATION----------------------------------------------------

	wire	[AHB_ADDR_WIDTH-1:0]		m_ahb_mhaddr      ;	// Master address bus
	wire	[2:0] 					    m_ahb_mhburst     ;	// Master burst type signals (just be 3'b000 in wujian100, single transfer)
	wire	[3:0] 					    m_ahb_mhprot      ;	// Master protection control signal (this version: keeping 4'b0011)
	wire	[2:0] 					    m_ahb_mhsize      ;	// Master transfer size signal (this version: only 8b/16b/32b?DMA?E902?)
	wire	[1:0] 					    m_ahb_mhtrans     ;	// Master transfer type signal
	wire	[AHB_DATA_WIDTH-1:0]		m_ahb_mhwdata     ;	// Master write data bus
	wire	    					    m_ahb_mhwrite     ;	// Master write enable signal

	// AHB OUTPUTS 
	wire  		[AHB_DATA_WIDTH-1:0]		s_ahb_hrdata    ;
	wire   		        				s_ahb_hready      	;
	wire  		[1:0]					s_ahb_hresp       	;
	// Port OUTPUTS (w/o AHB_ADDR_OFFSET)
	wire  		[PORT_BMASK_WIDTH-1:0]	s_port_ena        	;
	wire  								s_port_wea        	;
	wire  		[AHB_ADDR_WIDTH-1:0]		s_port_addr   	;
	wire  		[AHB_DATA_WIDTH-1:0]		s_port_wdata  	;
	wire  								s_port_wdata_vld   	;


	// SRAM OUTPUTS (w/o AHB_ADDR_OFFSET)
	wire  		[PORT_BMASK_WIDTH-1:0]		p2s_sram_ena	;			// SRAM Output write/read enable (i.e. SRAM timing)
	wire  									p2s_sram_wea	;			// SRAM Output write/read mode (i.e. SRAM timing)
	wire  		[AHB_ADDR_WIDTH-1:0]		p2s_sram_addr	;			// SRAM Output address (i.e. SRAM timing)
	wire  		[AHB_DATA_WIDTH-1:0]		p2s_sram_wdata	;			// SRAM Output write data (i.e. SRAM timing)
	
	// Port OUTPUTS (From ahb2port) (w/o AHB_ADDR_OFFSET)
	wire  		[AHB_DATA_WIDTH-1:0]		p2s_port_rdata	;			// Port Output read data
	wire  									p2s_port_ready	;			// Port Output write/read ready (always be 1) (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
	wire  									p2s_port_error	;			// Port Output write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)

	wire    	[AHB_DATA_WIDTH-1 : 0]  	mem_rdata;	

// -INTERNAL Wire DECLARATION----------------------------------------------------

/*Input Assign && Output Assign----------------------------------------------------------------------------------------------------*/
// +INTERNAL Assign DECLARATION--------------------------------------------------
// -INTERNAL Assign DECLARATION--------------------------------------------------
    
/*Main Circuit----------------------------------------------------------------------------------------------------*/
	ahb_rram_master #(
	// +PARAMETER DECLARATION--------------------------------------------------------
		.AHB_DATA_WIDTH		    (   AHB_DATA_WIDTH		    ),				// AHB data bitwidth
		.AHB_ADDR_WIDTH		    (   AHB_ADDR_WIDTH		    ),				// AHB address width
		.RRAM_DATA_WIDTH	    (   RRAM_DATA_WIDTH	    	),				// RRAM data bitwidth
		.RRAM_ADDR_WIDTH	    (   RRAM_ADDR_WIDTH	    	),				// RRAM address width
		.RRAM_BMASK_WIDTH       (   RRAM_BMASK_WIDTH       	)
	// -PARAMETER DECLARATION--------------------------------------------------------
	) u0_ahb_rram_master (
		// +INPUT PORT DECLARATION-------------------------------------------------------
		// AHB INPUTS
		.i_ahb_hclk        		(	i_ahb_hclk		),  	// Clock input
		.i_ahb_hrst_n      		(	i_ahb_hrst_n	),	// Reset asynchronous (active low)
		.i_ahb_mhgrant     		(	1'b1			),	// Master grant signal (active high, this version: 1'b1)
		.i_ahb_mhrdata     		(	s_ahb_hrdata	),	// Master read data bus
		.i_ahb_mhready     		(	s_ahb_hready	),	// Master response ready signal (active high)
		.i_ahb_mhresp      		(	s_ahb_hresp		),	// Master response error signal (1:error, 0:OKAY) ({mhready,mhresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)
		// RRAM INPUTS
		.i_rram_clk        		(	i_rram_clk     	),	// RRAM Input clock (low-speed clock)
		.i_rram_rst_n      		(	i_rram_rst_n   	),	// RRAM input reset (active low)
		.i_rram_mena       		(	i_rram_mena    	),	// RRAM Input write/read enable (i.e. SRAM timing)
		.i_rram_mwea       		(	i_rram_mwea    	),	// RRAM Input write/read mode (i.e. SRAM timing)
		.i_rram_maddr      		(	i_rram_maddr   	),	// RRAM Input address (i.e. SRAM timing)
		.i_rram_mwdata     		(	i_rram_mwdata  	),	// RRAM Input write data (i.e. SRAM timing)
		// -INPUT PORT DECLARATION-------------------------------------------------------

		// +OUTPUT PORT DECLARATION------------------------------------------------------	
		// AHB OUTPUTS
		.o_ahb_mhaddr  			(	m_ahb_mhaddr  	),	// Master address bus
		.o_ahb_mhburst 			(	m_ahb_mhburst 	),	// Master burst type signals (just be 3'b000 in wujian100, single transfer)
		.o_ahb_mhprot  			(	m_ahb_mhprot  	),	// Master protection control signal (this version: keeping 4'b0011)
		.o_ahb_mhsize  			(	m_ahb_mhsize  	),	// Master transfer size signal (this version: only 8b/16b/32b?DMA?E902?)
		.o_ahb_mhtrans 			(	m_ahb_mhtrans 	),	// Master transfer type signal
		.o_ahb_mhwdata 			(	m_ahb_mhwdata 	),	// Master write data bus
		.o_ahb_mhwrite 			(	m_ahb_mhwrite 	),	// Master write enable signal
		// RRAM OUTPUTS
		.o_rram_mready    		(	o_rram_mready    			),	// RRAM Input write/read ready (delay 1 cycle after rram_mena, 1'b0: master can't process the next data)
		.o_rram_merror    		(	o_rram_merror    			),	// RRAM Input write/read error (delay n cycle after rram_mena, sync with rram_ready, 1'b1:error, 1'b0:normal)
		.o_rram_mrdata    		(	o_rram_mrdata    			),	// RRAM Output read data (delay n cycle after rram_mena, sync with rram_ready)
		.o_rram_mrdata_vld		(	o_rram_mrdata_vld			)	// RRAM Output read data valid (delay n cycle after rram_mena, sync with rram_ready)
		// -OUTPUT PORT DECLARATION------------------------------------------------------
	);

	ahb_port_slave #(
	// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH			(	AHB_DATA_WIDTH				),	// Port data bitwidth
		.ADDR_WIDTH			(	AHB_ADDR_WIDTH				),	// Port address width
		.PORT_BMASK_WIDTH	(	PORT_BMASK_WIDTH		),   // Port Byte mask
		.AHB_ADDR_OFFSET	(	AHB_ADDR_OFFSET		),	// AHB slave start address 
		.SCLK_OR_NOT		(	SCLK_OR_NOT			),	// Relation between ahb_hclk and port_clk (1: same-delete fifo, 0: non-same, must be sync clock)
		.FIFO_DEPTH			(	2				)	// FIFO depth
	// -PARAMETER DECLARATION--------------------------------------------------------
	) u0_ahb_port_slave (
	// +INPUT PORT DECLARATION-------------------------------------------------------
		// AHB INPUTS (w/ AHB_ADDR_OFFSET)
		.ahb_hclk        (	i_ahb_hclk	),			// AHB Clock input (high-speed clock)   
		.ahb_hrst_n      (	i_ahb_hrst_n	),			// AHB Reset asynchronous Active low       
		.ahb_hsel        (	m_ahb_mhtrans == AHB_HTRANS_NONSEQ	),			// AHB Slave select signal
		.ahb_haddr       (	m_ahb_mhaddr	),			// AHB Address bus
		.ahb_hprot       (	m_ahb_mhprot	),			// AHB Protection control signals (this version: keeping 4'b0011, don't used)
		.ahb_hsize       (	m_ahb_mhsize	),			// AHB Transfer size signals (this version: all mode supported)
		.ahb_htrans      (	m_ahb_mhtrans	),			// AHB Transfer type signals (this version: without BUSY & SEQ due to loss of burst)
		.ahb_hwdata      (	m_ahb_mhwdata	),			// AHB Write data bus
		.ahb_hwrite      (	m_ahb_mhwrite	),			// AHB Write enable signal
		.ahb_hburst      (	m_ahb_mhburst	),			// AHB Burst transfer type (this version: keeping 3'b000?) 
		.ahb_hreadyin    (	1'b1	),       // AHB Bus hready signal input
		
		// Port INPUTS 
		.port_clk        (	i_rram_clk	),			// Port Input clock (low-speed clock)
		.port_rst_n      (	i_rram_rst_n	),			// Port input reset (active low)
		.port_rdata      (	p2s_port_rdata	),			// Port Input data
		.port_ready      (	p2s_port_ready	),			// Port Input write/read ready (delay 1 cycle after port_ena,1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
		.port_error      (	p2s_port_error	),			// Port Input write/read error (delay n cycle after port_ena,sync with port_ready, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
	// -INPUT PORT DECLARATION-------------------------------------------------------

	// +OUTPUT PORT DECLARATION------------------------------------------------------
		// AHB OUTPUTS 
		.ahb_hrdata      	(	s_ahb_hrdata     	),			// AHB Read data bus
		.ahb_hready      	(	s_ahb_hready     	),			// AHB Transfer ready signal (active high)
		.ahb_hresp       	(	s_ahb_hresp      	),			// AHB Transfer response signals (1:error, 0:OKAY) ({hready,hresp}=2'b10:normal, 2'b00:more cycle needed, 2'b01:first cycle of error, 2'b11: second cycle of error & mhtrans is also set to IDLE by master)

		// Port OUTPUTS (w/o AHB_ADDR_OFFSET)
		.port_ena        	(	s_port_ena       	),			// Port Output write/read enable (i.e. SRAM timing)
		.port_wea        	(	s_port_wea       	),			// port Output write/read mode (i.e. SRAM timing)
		.port_addr       	(	s_port_addr      	),			// Port Output address (i.e. SRAM timing)
		.port_wdata      	(	s_port_wdata     	),			// Port Output write data (delay n-cycle after port_ena that n >= 1, and not after next port_ena) 
		.port_wdata_vld  	(	s_port_wdata_vld 	) 	        // Port Output valid of write data (delay n-cycle after port_ena that n >= 1, and not after next port_ena) 
	// -OUTPUT PORT DECLARATION------------------------------------------------------
	);  

	ahb_port2sram #(
	// +PARAMETER DECLARATION--------------------------------------------------------
		.DATA_WIDTH				(	AHB_DATA_WIDTH						),				// data bitwidth
		.ADDR_WIDTH				(	AHB_ADDR_WIDTH						),				// address width
     	.PORT_BMASK_WIDTH    	(	PORT_BMASK_WIDTH					)                // Port Byte mask
	// -PARAMETER DECLARATION--------------------------------------------------------
	) u_ahb_port2sram_sreg (
	// +INPUT PORT DECLARATION-------------------------------------------------------
		.clk					(	i_rram_clk							),				// Input clock (low-speed clock)
		.rst_n					(	i_rram_rst_n						),				// input reset (active low)

		// Port INPUTS (From ahb2port) (w/o AHB_ADDR_OFFSET)
		.port_ena				(	s_port_ena			),			// Port Input write/read enable (i.e. SRAM timing)
		.port_wea				(	s_port_wea					),			// port Input write/read mode (i.e. SRAM timing)
		.port_addr				(	s_port_addr					),			// Port Input address (i.e. SRAM timing)
		.port_wdata				(	s_port_wdata				),			// Port Output write data (delay n-cycle)
		.port_wdata_vld			(	s_port_wdata_vld			),		// Port Output valid of write data (delay n-cycle)

		// SRAM INPUTS (w/o AHB_ADDR_OFFSET)
		.sram_rdata				(	mem_rdata				),			// Port Output read data
		.sram_ready				(	1'b1			),			// 
		.sram_error				(	1'b0			),			// 

	// -INPUT PORT DECLARATION-------------------------------------------------------

	// +OUTPUT PORT DECLARATION------------------------------------------------------
		// SRAM OUTPUTS (w/o AHB_ADDR_OFFSET)
		.sram_ena				(	p2s_sram_ena			),			// Port Input write/read enable (i.e. SRAM timing)
		.sram_wea				(	p2s_sram_wea			),			// port Input write/read mode (i.e. SRAM timing)
		.sram_addr				(	p2s_sram_addr			),			// Port Input address (i.e. SRAM timing)
		.sram_wdata				(	p2s_sram_wdata			),			// Port Input write data (i.e. SRAM timing)


		// SRAM OUTPUTS (while port_ena_bypass=1, feedback sram_ready & sram_error by LUT, don't use Sequential logic)
		.port_ena_bypass		(		),	// 
		.port_wea_bypass		(		),	// 
		.port_addr_bypass		(		),	// 
		
		// Port OUTPUTS (From ahb2port) (w/o AHB_ADDR_OFFSET)
		.port_rdata				(	p2s_port_rdata			),			// Port Output read data
		.port_ready				(	p2s_port_ready			),			// Port Output write/read ready (always be 1) (sync with port_ena, 1'b0: sub-module can't process the next data, sub-module R/W are equivalent to SRAM timing if keeping 1'b1)
		.port_error				(	p2s_port_error			)			// Port Output write/read error (sync with port_rdata_vld, 1'b1:error, 1'b0:normal, sub-module don't have error if keeping 1'b0)
	// -OUTPUT PORT DECLARATION------------------------------------------------------
	);

	`ifdef HIGH_BANDWIDTH_VERSION
	unaligned_ahbram_hb #(
        .OUTER_ADDR_SIZE	(	16				)		// Physical address
	) u0_fms_bram(
        .clka		(	i_rram_clk		),
        .ena		(	p2s_sram_ena	),
        .wea		(	p2s_sram_wea	),
        .addra		(	p2s_sram_addr	),
        .dina		(	p2s_sram_wdata	),
        .douta		(	mem_rdata		)
    );
	`else
	unaligned_ahbram #(
        .OUTER_ADDR_SIZE	(	16				)		// Physical address
	) u0_fms_bram(
        .clka		(	i_rram_clk		),
        .ena		(	p2s_sram_ena	),
        .wea		(	p2s_sram_wea	),
        .addra		(	p2s_sram_addr	),
        .dina		(	p2s_sram_wdata	),
        .douta		(	mem_rdata		)
    );
	`endif
	

endmodule
