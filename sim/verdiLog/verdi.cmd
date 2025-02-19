debImport "-sv" "-f" "./f.list"
debLoadSimResult /home/wx/Project/SDMA/sim/TB_sdma_top.fsdb
wvCreateWindow
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {U_SDMA_TOP_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]"
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 46)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 46)}
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvZoom -win $_nWave2 0.000000 51568.198395
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 10832.706884 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 12939.066556 -snap {("U_SDMA_TOP_0" 21)}
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 13841.792129 31896.303603
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 146859.162618 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 143698.635445 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 144330.740880 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 146859.162618 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 150230.391602 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 160554.780366 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 169193.554637 -snap {("U_SDMA_TOP_0" 10)}
wvZoom -win $_nWave2 140327.406461 158447.762251
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 145263.914767 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 147167.146885 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 152876.843239 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 160066.831240 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 168525.640653 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 176561.509595 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 182694.146419 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 185443.259479 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 189672.664185 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 192633.247480 -snap {("U_SDMA_TOP_0" 19)}
wvSetCursor -win $_nWave2 172559.712024 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 178480.878613 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 186516.747555 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 192014.973674 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 197090.259322 -snap {("U_SDMA_TOP_0" 7)}
wvSetCursor -win $_nWave2 200473.783087 -snap {("U_SDMA_TOP_0" 7)}
wvSetCursor -win $_nWave2 187151.158261 -snap {("U_SDMA_TOP_0" 7)}
wvSetCursor -win $_nWave2 183767.634496 -snap {("U_SDMA_TOP_0" 7)}
wvSetCursor -win $_nWave2 171290.890612 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 160082.968140 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 151412.688492 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 167907.366847 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 169810.598965 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 178903.819084 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 182710.283320 -snap {("U_SDMA_TOP_0" 7)}
wvSetCursor -win $_nWave2 146971.813550 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 155430.622963 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 163466.491905 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 168541.777553 -snap {("U_SDMA_TOP_0" 20)}
wvZoom -win $_nWave2 142530.938608 156699.444375
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 146170.200995 214956.177934
wvScrollUp -win $_nWave2 7
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 \
           15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 \
           37 38 39 40 41 42 43 44 45 46 )} 
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 0)}
wvSelectGroup -win $_nWave2 {G2}
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0.U_SDMA_DATA_PATH_0" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G2" 0)}
wvRenameGroup -win $_nWave2 {G2} {U_SDMA_DATA_PATH_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done"
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 18)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 18)}
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 16556.799701 -snap {("U_SDMA_DATA_PATH_0" 9)}
wvSetCursor -win $_nWave2 17459.897866 -snap {("U_SDMA_DATA_PATH_0" 9)}
wvSetCursor -win $_nWave2 18764.372994 -snap {("U_SDMA_DATA_PATH_0" 9)}
wvSetCursor -win $_nWave2 9432.358617 -snap {("U_SDMA_DATA_PATH_0" 14)}
wvSetCursor -win $_nWave2 10736.833745 -snap {("U_SDMA_DATA_PATH_0" 11)}
wvSetCursor -win $_nWave2 15352.668813 -snap {("U_SDMA_DATA_PATH_0" 9)}
wvSetCursor -win $_nWave2 16456.455460 -snap {("U_SDMA_DATA_PATH_0" 9)}
wvScrollUp -win $_nWave2 49
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 0)}
wvSelectGroup -win $_nWave2 {G3}
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0.U_SDMA_ADDR_PATH_0" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 0)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvRenameGroup -win $_nWave2 {G3} {U_SDMA_ADDR_PATH_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag"
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetCursor -win $_nWave2 12944.407039 -snap {("U_SDMA_ADDR_PATH_0" 45)}
debReload
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 10435.801024 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 14449.570648 -snap {("U_SDMA_ADDR_PATH_0" 46)}
wvZoom -win $_nWave2 12844.062798 14850.947610
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 82
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 0)}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
debReload
wvSetCursor -win $_nWave2 49090.364014 -snap {("U_SDMA_TOP_0" 14)}
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 48153.525006 54149.294656
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 48980.758633 51779.659126
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 14 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 14 )} 
wvSetRadix -win $_nWave2 -format UDec
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 200426.589957 -snap {("U_SDMA_TOP_0" 14)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 12 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 14 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 14 )} 
wvScrollUp -win $_nWave2 4
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvScrollDown -win $_nWave2 76
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 49649.350837 -snap {("U_SDMA_ADDR_PATH_0" 46)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 46 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DPORT_MUX_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0"
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_DATA_PATH_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/dfms_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/dfms_waddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 47 48 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_DATA_PATH_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/dfms_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/dfms_waddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 47 48 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 199903.965211 -snap {("U_SDMA_ADDR_PATH_0" 48)}
wvZoom -win $_nWave2 198074.778602 201994.464194
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 48)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvScrollUp -win $_nWave2 100
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 0)}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoom -win $_nWave2 200126.109318 203785.626137
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 4
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
debReload
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 157506.030948 -snap {("U_SDMA_TOP_0" 22)}
wvSetCursor -win $_nWave2 148964.489140 -snap {("U_SDMA_TOP_0" 10)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 153406.090880 -snap {("U_SDMA_TOP_0" 8)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 22 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 20 )} 
wvSetCursor -win $_nWave2 156822.707603 -snap {("U_SDMA_TOP_0" 20)}
wvZoom -win $_nWave2 140422.947331 152039.444191
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 8
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_0" 1 )} 
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvScrollDown -win $_nWave2 47
wvScrollDown -win $_nWave2 19
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 43 )} 
wvZoom -win $_nWave2 144244.524096 152107.477478
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 218029.201852 -snap {("U_SDMA_ADDR_PATH_0" 42)}
wvSetCursor -win $_nWave2 156731.429614 -snap {("U_SDMA_ADDR_PATH_0" 42)}
wvSetCursor -win $_nWave2 220965.622079 -snap {("U_SDMA_ADDR_PATH_0" 42)}
wvSetCursor -win $_nWave2 151592.694217 -snap {("U_SDMA_ADDR_PATH_0" 42)}
wvSetCursor -win $_nWave2 143884.591121 -snap {("U_SDMA_ADDR_PATH_0" 43)}
wvSetCursor -win $_nWave2 150491.536632 -snap {("U_SDMA_ADDR_PATH_0" 36)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 47
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvScrollDown -win $_nWave2 47
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 8 )} 
wvSetCursor -win $_nWave2 153060.904331 -snap {("U_SDMA_DATA_PATH_0" 8)}
wvZoom -win $_nWave2 151959.746746 170312.373164
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 221377.117146 -snap {("U_SDMA_DATA_PATH_0" 14)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 131935.438352 153781.890807
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 146854.052385 172859.457495
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollDown -win $_nWave2 3
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 28
wvScrollUp -win $_nWave2 11
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 221852.092024 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 223673.039428 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 221245.109557 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 43 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 43 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 43)}
wvGetSignalOpen -win $_nWave2
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 45 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 45 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 148407.213406 -snap {("U_SDMA_ADDR_PATH_0" 45)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 150531.652044 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 148103.722172 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 145979.283535 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 147193.248470 -snap {("U_SDMA_ADDR_PATH_0" 43)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 )} 
wvSetCursor -win $_nWave2 151442.125746 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 163278.283870 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 180273.792972 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 210926.407602 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 160243.371531 -snap {("U_SDMA_ADDR_PATH_0" 45)}
wvSetCursor -win $_nWave2 149621.178342 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 39 )} 
wvSetCursor -win $_nWave2 142944.371195 -snap {("U_SDMA_ADDR_PATH_0" 39)}
wvSetCursor -win $_nWave2 146586.266002 -snap {("U_SDMA_ADDR_PATH_0" 39)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 44 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0"
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/sfms_raddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 46 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/sfms_raddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_ADDR_PATH_0" 46 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 46)}
wvGetSignalClose -win $_nWave2
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 44)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 44)}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 45)}
debReload
wvSetCursor -win $_nWave2 158118.932893 -snap {("U_SDMA_ADDR_PATH_0" 48)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvZoom -win $_nWave2 146282.774769 165402.722508
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 148507.159644 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 150292.245939 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 152690.955648 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 155257.017198 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 156651.615866 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 159050.325575 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 160779.627923 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 162787.850005 -snap {("U_SDMA_ADDR_PATH_0" 44)}
wvSetCursor -win $_nWave2 157097.887440 -snap {("U_SDMA_ADDR_PATH_0" 49)}
wvSetCursor -win $_nWave2 159217.677415 -snap {("U_SDMA_ADDR_PATH_0" 49)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 47
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_ADDR_PATH_0}
wvSetPosition -win $_nWave2 {("U_SDMA_ADDR_PATH_0" 0)}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 156195.050826 -snap {("U_SDMA_TOP_0" 22)}
wvZoom -win $_nWave2 157533.865547 184756.431548
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
debReload
wvSetCursor -win $_nWave2 164248.771671 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 19379.448882 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 27639.541848 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 166472.642854 -snap {("U_SDMA_TOP_0" 20)}
wvSetCursor -win $_nWave2 147728.585739 -snap {("U_SDMA_TOP_0" 11)}
wvSetCursor -win $_nWave2 27321.845965 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 49878.253680 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 39711.985414 -snap {("U_SDMA_TOP_0" 10)}
wvSetCursor -win $_nWave2 31451.892448 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 28592.629498 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 20014.840648 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 37488.114230 -snap {("U_SDMA_TOP_0" 8)}
wvSetCursor -win $_nWave2 38758.897764 -snap {("U_SDMA_TOP_0" 8)}
wvScrollUp -win $_nWave2 7
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvScrollDown -win $_nWave2 47
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 30498.804798 -snap {("U_SDMA_DATA_PATH_0" 15)}
wvSetCursor -win $_nWave2 147728.585739 -snap {("U_SDMA_DATA_PATH_0" 18)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 15 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 15)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 9 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 9)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/U_SDMA_SAP_PADDING_INDICATOR_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DPORT_MUX_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0"
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/data_buffer\[0:63\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/sfms_raddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_ADDR_PATH_0"
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 10 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_0" \
{/TB_sdma_top/U_SDMA_TOP_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbraddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbren\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwen\[3:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2waddr\[31:0\]} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_TOP_0"
wvAddSignal -win $_nWave2 -group {"U_SDMA_DATA_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_mode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_strb\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_din\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/data_buffer\[0:63\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_dout_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_paddingflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/i_sdp_upsampleflag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_din_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_dout\[511:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_input_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_output_section_done} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_DATA_PATH_0/o_sdp_parallelinout_section_done} \
}
wvAddSignal -win $_nWave2 -group {"U_SDMA_ADDR_PATH_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_transfer_pending} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_num_of_remain_bytes\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_concate_fms_switch_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdpmode\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdmamode\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_inputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_outputsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sdp_parallelinoutsectiondone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_sport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/i_sap_dport_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sdp_ldb_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_ren\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_cnt\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/sfms_raddr_inc_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/section_r_num\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_sport_raddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_wen\[63:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_dport_waddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_padding_flag} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_ADDR_PATH_0/o_sap_upsample_flag} \
}
wvCollapseGroup -win $_nWave2 "U_SDMA_ADDR_PATH_0"
wvAddSignal -win $_nWave2 -group {"G4" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 10 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 10)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 17790.969465 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 21285.624182 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 25097.974781 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 34311.155397 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 42571.248363 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 46383.598963 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSetCursor -win $_nWave2 54008.300163 -snap {("U_SDMA_DATA_PATH_0" 10)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 9 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 8 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_DATA_PATH_0" 8 )} 
debReload
wvScrollUp -win $_nWave2 52
wvSelectGroup -win $_nWave2 {U_SDMA_DATA_PATH_0}
wvSetPosition -win $_nWave2 {("U_SDMA_DATA_PATH_0" 0)}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 226199.468916 -snap {("U_SDMA_TOP_0" 6)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
debExit
