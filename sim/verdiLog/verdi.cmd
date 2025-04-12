debImport "-sv" "-f" "./f.list"
debLoadSimResult /home/wx/Project/SDMA/sim/TB_sdma_top.fsdb
wvCreateWindow
srcHBSelect "TB_sdma_top.U_RRAM_AHB_MEM_0" -win $_nTrace1
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0" -win $_nTrace1
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0.U_SDMA_TOP_CTRL_0" -win $_nTrace1
srcSetScope -win $_nTrace1 "TB_sdma_top.U_SDMA_TOP_0.U_SDMA_TOP_CTRL_0" -delim \
           "."
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {U_SDMA_TOP_CTRL_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst_vld" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst\[639:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_sscready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_ssctransferdone" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sscen" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sdmamode\[6:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcportid\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstportid\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsmovelength\[20:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms1concatelength\[20:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2concatelength\[20:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2movelength\[20:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsc\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsx\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsy\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride3\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride1\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingaxisbefore\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingleftx\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrightx\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddinglefty\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrighty\[5:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronum\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotalx\[10:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotaly\[10:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxx\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxy\[2:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride1\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsc\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsx\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsy\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride2\[16:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride1\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2c\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2x\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2y\[12:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycsaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscyceaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycalignena\[0:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_shuffleidx\[0:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt1\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt2\[9:0\]"
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 51)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 51)}
wvZoom -win $_nWave2 0.000000 208247.422680
wvSetCursor -win $_nWave2 134592.902050 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvZoom -win $_nWave2 132446.021403 144997.015950
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
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_CTRL_0}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0"
wvGetSignalSetScope -win $_nWave2 \
           "/TB_sdma_top/U_SDMA_TOP_0/U_RRAM_ADDR_CYC_ALIGN_0"
wvGetSignalSetScope -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0"
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_CTRL_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst\[639:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_sscready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_ssctransferdone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sscen} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sdmamode\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcportid\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstportid\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsmovelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms1concatelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2concatelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2movelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxx\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxy\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscyceaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycalignena\[0:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_shuffleidx\[0:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt1\[9:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt2\[9:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/cur_state\[1:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sdmamode\[6:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 52 53 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"U_SDMA_TOP_CTRL_0" \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/clk} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/rst_n} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_en} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst_vld} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_inst\[639:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_sscready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/i_stc_ssctransferdone} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sscen} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_ready} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sdmamode\[6:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcportid\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstportid\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsmovelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2addr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms1concatelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2concatelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfms2movelength\[20:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride3\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_dstfmsstride1\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingaxisbefore\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingleftx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrightx\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddinglefty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_paddingrighty\[5:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronum\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotalx\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_insertzeronumtotaly\[10:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxx\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_upsampleidxy\[2:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsstride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsc\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsx\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfmsy\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride2\[16:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2stride1\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2c\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2x\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_cropfms2y\[12:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycsaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscyceaddr\[31:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_srcfmscycalignena\[0:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_shuffleidx\[0:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt1\[9:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sigmnt2\[9:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/cur_state\[1:0\]} \
{/TB_sdma_top/U_SDMA_TOP_0/U_SDMA_TOP_CTRL_0/o_stc_sdmamode\[6:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 52 53 )} 
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
wvGetSignalClose -win $_nWave2
wvSetCursor -win $_nWave2 133177.582148 -snap {("U_SDMA_TOP_CTRL_0" 52)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 50 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 50 )} 
wvSetRadix -win $_nWave2 -format Bin
wvZoom -win $_nWave2 132978.518000 134451.592697
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 134056.163843 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvSetCursor -win $_nWave2 134700.999079 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvSetCursor -win $_nWave2 136084.123933 -snap {("U_SDMA_TOP_CTRL_0" 51)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 136873.813462 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 51 )} 
wvSelectSignal -win $_nWave2 {( "U_SDMA_TOP_CTRL_0" 51 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSetCursor -win $_nWave2 138219.556563 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvSetCursor -win $_nWave2 139079.336878 -snap {("U_SDMA_TOP_CTRL_0" 50)}
wvScrollUp -win $_nWave2 37
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_CTRL_0}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 0)}
wvSelectGroup -win $_nWave2 {G2}
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G2" 0)}
wvRenameGroup -win $_nWave2 {G2} {U_SDMA_TOP_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/i_clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[639:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1rdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1rvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1ena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1wdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2rdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2rvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2ena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2wdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt1\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt2\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt3\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt4\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt5\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt6\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt7\[9:0\]"
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 62)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 62)}
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
wvSetCursor -win $_nWave2 133173.019933 -snap {("U_SDMA_TOP_0" 20)}
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
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectGroup -win $_nWave2 {G3}
wvSelectGroup -win $_nWave2 {U_SDMA_TOP_0}
wvScrollDown -win $_nWave2 0
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_CTRL_0" 53)}
debReload
srcHBSelect "TB_sdma_top.U_SDMA_TOP_0" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 0)}
wvRenameGroup -win $_nWave2 {G3} {U_SDMA_TOP_0}
wvAddSignal -win $_nWave2 "/TB_sdma_top/U_SDMA_TOP_0/i_clk" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_rst_n" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_en" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst_vld" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_inst\[639:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_ahbrvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbaddr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_ahbwea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_dc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_dc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc1rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_wc2rvld\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2ena\[63:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wdata\[511:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_wc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1rdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc1rvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1ena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1wdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc1wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2ready" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2rdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/i_sdma_bc2rvld\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2addr\[31:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2ena\[15:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2wdata\[127:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_bc2wea" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt1\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt2\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt3\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt4\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt5\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt6\[9:0\]" \
           "/TB_sdma_top/U_SDMA_TOP_0/o_sdma_sigmnt7\[9:0\]"
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 0)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 62)}
wvSetPosition -win $_nWave2 {("U_SDMA_TOP_0" 62)}
wvSetCursor -win $_nWave2 135191.634585 -snap {("U_SDMA_TOP_0" 60)}
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 136144.869282 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 138163.483934 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 140630.679620 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 147508.922139 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 149228.482768 -snap {("U_SDMA_TOP_0" 58)}
wvSetCursor -win $_nWave2 153564.766095 -snap {("U_SDMA_TOP_0" 58)}
wvSetCursor -win $_nWave2 158125.339939 -snap {("U_SDMA_TOP_0" 58)}
wvSetCursor -win $_nWave2 162312.096255 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 140555.916114 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 118201.627929 -snap {("U_SDMA_TOP_0" 57)}
wvSetCursor -win $_nWave2 140630.679620 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 154237.637646 -snap {("U_SDMA_TOP_0" 59)}
wvSetCursor -win $_nWave2 161340.170682 -snap {("U_SDMA_TOP_0" 59)}
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
debExit
