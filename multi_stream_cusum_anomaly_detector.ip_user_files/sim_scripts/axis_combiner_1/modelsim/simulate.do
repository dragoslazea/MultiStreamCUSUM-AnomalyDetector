onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L xpm -L axis_infrastructure_v1_1_0 -L axis_combiner_v1_1_10 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.axis_combiner_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {axis_combiner_1.udo}

run -all

quit -force