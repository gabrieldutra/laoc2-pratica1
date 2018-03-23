onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ramlpm/clock
add wave -noupdate /ramlpm/wren
add wave -noupdate /ramlpm/address
add wave -noupdate /ramlpm/data
add wave -noupdate /ramlpm/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2760 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 200ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/ramlpm/clock 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 200ps -dutycycle 50 -starttime 0ps -endtime 2000ps sim:/ramlpm/clock 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 500ps -dutycycle 50 -starttime 0ps -endtime 2000ps sim:/ramlpm/wren 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 400ps -dutycycle 50 -starttime 100ps -endtime 2000ps sim:/ramlpm/wren 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 400ps -dutycycle 50 -starttime 100ps -endtime 2000ps sim:/ramlpm/wren 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 400ps -dutycycle 50 -starttime 50ps -endtime 2000ps sim:/ramlpm/wren 
wave create -driver freeze -pattern counter -startvalue 00000 -endvalue 000001 -type Range -direction Up -period 1000ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 2000ps sim:/ramlpm/address 
wave create -driver freeze -pattern counter -startvalue 00000 -endvalue 000001 -type Range -direction Up -period 600ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 2000ps sim:/ramlpm/address 
wave create -driver freeze -pattern counter -startvalue 00000 -endvalue 00001 -type Range -direction Up -period 1150ps -step 1 -repeat forever -range 4 0 -starttime 0ps -endtime 2000ps sim:/ramlpm/address 
WaveExpandAll -1
wave create -driver freeze -pattern random -initialvalue zzzzzzzz -period 200ps -random_type Uniform -seed 5 -range 7 0 -starttime 0ps -endtime 2000ps sim:/ramlpm/data 
WaveExpandAll -1
WaveCollapseAll -1
wave clipboard restore
