onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib axis_combiner_2_opt

do {wave.do}

view wave
view structure
view signals

do {axis_combiner_2.udo}

run -all

quit -force
