@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xsim testbench_1_sensor_id_from_file_behav -key {Behavioral:sim_1:Functional:testbench_1_sensor_id_from_file} -tclbatch testbench_1_sensor_id_from_file.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
