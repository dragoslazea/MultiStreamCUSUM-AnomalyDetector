onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fp_greater_than_opt

do {wave.do}

view wave
view structure
view signals

do {fp_greater_than.udo}

run -all

quit -force
