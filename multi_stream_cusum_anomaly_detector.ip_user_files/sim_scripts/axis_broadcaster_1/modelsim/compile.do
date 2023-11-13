vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm
vlib msim/axis_infrastructure_v1_1_0
vlib msim/axis_broadcaster_v1_1_11

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm
vmap axis_infrastructure_v1_1_0 msim/axis_infrastructure_v1_1_0
vmap axis_broadcaster_v1_1_11 msim/axis_broadcaster_v1_1_11

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axis_infrastructure_v1_1_0 -64 -incr "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/tdata_axis_broadcaster_1.v" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/tuser_axis_broadcaster_1.v" \

vlog -work axis_broadcaster_v1_1_11 -64 -incr "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../ipstatic/hdl/axis_broadcaster_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/top_axis_broadcaster_1.v" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/sim/axis_broadcaster_1.v" \

vlog -work xil_defaultlib "glbl.v"

