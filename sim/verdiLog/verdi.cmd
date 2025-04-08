debImport "-sv" "-f" "./f.list"
debLoadSimResult /home/wx/Project/SDMA/sim/TB_sdma_top.fsdb
wvCreateWindow
verdiDockWidgetSetCurTab -dock widgetDock_<Message>
nsMsgSwitchTab -tab cmpl
verdiDockWidgetSetCurTab -dock windowDock_nWave_2
debExit
