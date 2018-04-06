transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/laoc2-pratica1 {E:/laoc2-pratica1/ramlpm.v}
vlog -vlog01compat -work work +incdir+E:/laoc2-pratica1 {E:/laoc2-pratica1/pratica1.v}
vlog -vlog01compat -work work +incdir+E:/laoc2-pratica1 {E:/laoc2-pratica1/bcd_7seg.v}
vlog -vlog01compat -work work +incdir+E:/laoc2-pratica1 {E:/laoc2-pratica1/memory.v}

