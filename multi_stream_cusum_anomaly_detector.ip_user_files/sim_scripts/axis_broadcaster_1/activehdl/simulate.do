onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+axis_broadcaster_1 -L xil_defaultlib -L xpm -L axis_infrastructure_v1_1_0 -L axis_broadcaster_v1_1_11 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axis_broadcaster_1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {axis_broadcaster_1.udo}

run -all

endsim

quit -force
