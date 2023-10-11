@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto b5e0caa818be4012a4951313943c4a17 -m64 --debug typical --relax --mt 2 -L xbip_utils_v3_0_7 -L axi_utils_v2_0_3 -L xbip_pipe_v3_0_3 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_3 -L xbip_dsp48_multadd_v3_0_3 -L xbip_bram18k_v3_0_3 -L mult_gen_v12_0_12 -L floating_point_v7_1_3 -L xil_defaultlib -L axis_infrastructure_v1_1_0 -L fifo_generator_v13_1_3 -L axis_data_fifo_v1_1_12 -L axis_combiner_v1_1_10 -L axis_broadcaster_v1_1_11 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot testbench_multi_stream_cusum_detector_behav xil_defaultlib.testbench_multi_stream_cusum_detector xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
