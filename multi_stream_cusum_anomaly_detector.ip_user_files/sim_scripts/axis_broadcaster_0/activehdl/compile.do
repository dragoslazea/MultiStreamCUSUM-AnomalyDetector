vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/axis_infrastructure_v1_1_0
vlib activehdl/axis_broadcaster_v1_1_11

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap axis_infrastructure_v1_1_0 activehdl/axis_infrastructure_v1_1_0
vmap axis_broadcaster_v1_1_11 activehdl/axis_broadcaster_v1_1_11

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axis_infrastructure_v1_1_0  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/hdl/tdata_axis_broadcaster_0.v" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/hdl/tuser_axis_broadcaster_0.v" \

vlog -work axis_broadcaster_v1_1_11  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../ipstatic/hdl/axis_broadcaster_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic/hdl" "+incdir+../../../ipstatic/hdl" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/hdl/top_axis_broadcaster_0.v" \
"../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/sim/axis_broadcaster_0.v" \

vlog -work xil_defaultlib "glbl.v"

