-makelib ies/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies/xpm \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/axis_infrastructure_v1_1_0 \
  "../../../ipstatic/hdl/axis_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/tdata_axis_broadcaster_1.v" \
  "../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/tuser_axis_broadcaster_1.v" \
-endlib
-makelib ies/axis_broadcaster_v1_1_11 \
  "../../../ipstatic/hdl/axis_broadcaster_v1_1_vl_rfs.v" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/hdl/top_axis_broadcaster_1.v" \
  "../../../../multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/sim/axis_broadcaster_1.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

