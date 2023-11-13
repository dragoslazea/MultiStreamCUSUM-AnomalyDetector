proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.cache/wt [current_project]
  set_property parent.project_path C:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.xpr [current_project]
  set_property ip_output_repo C:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet C:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.runs/synth_1/basys3_multi_stream_cusum.dcp
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/axis_broadcaster_0.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/axis_broadcaster_0.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_adder_subtracter/fp_adder_subtracter.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_adder_subtracter/fp_adder_subtracter.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_0/axis_combiner_0.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_0/axis_combiner_0.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_greater_than/fp_greater_than.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_greater_than/fp_greater_than.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_1/axis_combiner_1.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_1/axis_combiner_1.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_2/axis_combiner_2.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_2/axis_combiner_2.dcp]
  add_files -quiet c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/axis_broadcaster_1.dcp
  set_property netlist_only true [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/axis_broadcaster_1.dcp]
  read_xdc -mode out_of_context -ref fifo64x16 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16_ooc.xdc]
  read_xdc -ref fifo64x16 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16/fifo64x16.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo64x16/fifo64x16/fifo64x16.xdc]
  read_xdc -mode out_of_context -ref axis_broadcaster_0 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/axis_broadcaster_0_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_0/axis_broadcaster_0_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_adder_subtracter -cells U0 c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_adder_subtracter/fp_adder_subtracter_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_adder_subtracter/fp_adder_subtracter_ooc.xdc]
  read_xdc -mode out_of_context -ref fifo32x16 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16_ooc.xdc]
  read_xdc -ref fifo32x16 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16/fifo32x16.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fifo32x16/fifo32x16/fifo32x16.xdc]
  read_xdc -mode out_of_context -ref axis_combiner_0 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_0/axis_combiner_0_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_0/axis_combiner_0_ooc.xdc]
  read_xdc -mode out_of_context -ref fp_greater_than -cells U0 c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_greater_than/fp_greater_than_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/fp_greater_than/fp_greater_than_ooc.xdc]
  read_xdc -mode out_of_context -ref axis_combiner_1 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_1/axis_combiner_1_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_1/axis_combiner_1_ooc.xdc]
  read_xdc -mode out_of_context -ref axis_combiner_2 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_2/axis_combiner_2_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_combiner_2/axis_combiner_2_ooc.xdc]
  read_xdc -mode out_of_context -ref axis_broadcaster_1 -cells inst c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/axis_broadcaster_1_ooc.xdc
  set_property processing_order EARLY [get_files c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/axis_broadcaster_1_ooc.xdc]
  link_design -top basys3_multi_stream_cusum -part xc7a35tcpg236-1
  write_hwdef -file basys3_multi_stream_cusum.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force basys3_multi_stream_cusum_opt.dcp
  catch { report_drc -file basys3_multi_stream_cusum_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force basys3_multi_stream_cusum_placed.dcp
  catch { report_io -file basys3_multi_stream_cusum_io_placed.rpt }
  catch { report_utilization -file basys3_multi_stream_cusum_utilization_placed.rpt -pb basys3_multi_stream_cusum_utilization_placed.pb }
  catch { report_control_sets -verbose -file basys3_multi_stream_cusum_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force basys3_multi_stream_cusum_routed.dcp
  catch { report_drc -file basys3_multi_stream_cusum_drc_routed.rpt -pb basys3_multi_stream_cusum_drc_routed.pb -rpx basys3_multi_stream_cusum_drc_routed.rpx }
  catch { report_methodology -file basys3_multi_stream_cusum_methodology_drc_routed.rpt -rpx basys3_multi_stream_cusum_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file basys3_multi_stream_cusum_timing_summary_routed.rpt -rpx basys3_multi_stream_cusum_timing_summary_routed.rpx }
  catch { report_power -file basys3_multi_stream_cusum_power_routed.rpt -pb basys3_multi_stream_cusum_power_summary_routed.pb -rpx basys3_multi_stream_cusum_power_routed.rpx }
  catch { report_route_status -file basys3_multi_stream_cusum_route_status.rpt -pb basys3_multi_stream_cusum_route_status.pb }
  catch { report_clock_utilization -file basys3_multi_stream_cusum_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force basys3_multi_stream_cusum_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

