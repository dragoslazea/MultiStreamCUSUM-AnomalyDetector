onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo32x16_opt

do {wave.do}

view wave
view structure
view signals

do {fifo32x16.udo}

run -all

quit -force
