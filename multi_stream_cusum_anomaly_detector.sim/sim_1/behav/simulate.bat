@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xsim testbench_multi_stream_cusum_detector_behav -key {Behavioral:sim_1:Functional:testbench_multi_stream_cusum_detector} -tclbatch testbench_multi_stream_cusum_detector.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
