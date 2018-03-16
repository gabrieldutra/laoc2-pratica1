onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pratica1/clock
add wave -noupdate /pratica1/address
add wave -noupdate /pratica1/data
add wave -noupdate /pratica1/wren
add wave -noupdate /pratica1/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {12 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/pratica1/clock 
wave create -pattern constant -value 00001 -range 4 0 -starttime 0ps -endtime 1000ps sim:/pratica1/address 
WaveExpandAll -1
wave create -pattern counter -startvalue 00000000 -endvalue 11111111 -type Range -direction Up -period 500ps -step 1 -repeat forever -range 7 0 -starttime 0ps -endtime 1000ps sim:/pratica1/data 
WaveExpandAll -1
wave create -pattern clock -initialvalue HiZ -period 250ps -dutycycle 50 -starttime 50ps -endtime 1000ps sim:/pratica1/wren 
WaveCollapseAll -1
wave clipboard restore
