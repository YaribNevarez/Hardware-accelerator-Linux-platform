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
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7z010clg400-1
  set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.cache/wt [current_project]
  set_property parent.project_path /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.xpr [current_project]
  set_property ip_repo_paths {
  /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.cache/ip
  /home/yarib/ZYBO_projects/Hardware/ip_repo/ESPI_1.0
} [current_project]
  set_property ip_output_repo /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.cache/ip [current_project]
  add_files -quiet /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.runs/synth_1/ccc_design_wrapper.dcp
  read_xdc -ref ccc_design_processing_system7_0_0 -cells inst /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_processing_system7_0_0/ccc_design_processing_system7_0_0.xdc
  set_property processing_order EARLY [get_files /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_processing_system7_0_0/ccc_design_processing_system7_0_0.xdc]
  read_xdc -prop_thru_buffers -ref ccc_design_rst_processing_system7_0_100M_0 /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_rst_processing_system7_0_100M_0/ccc_design_rst_processing_system7_0_100M_0_board.xdc
  set_property processing_order EARLY [get_files /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_rst_processing_system7_0_100M_0/ccc_design_rst_processing_system7_0_100M_0_board.xdc]
  read_xdc -ref ccc_design_rst_processing_system7_0_100M_0 /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_rst_processing_system7_0_100M_0/ccc_design_rst_processing_system7_0_100M_0.xdc
  set_property processing_order EARLY [get_files /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_rst_processing_system7_0_100M_0/ccc_design_rst_processing_system7_0_100M_0.xdc]
  read_xdc -prop_thru_buffers -ref ccc_design_axi_gpio_0_1 -cells U0 /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_axi_gpio_0_1/ccc_design_axi_gpio_0_1_board.xdc
  set_property processing_order EARLY [get_files /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_axi_gpio_0_1/ccc_design_axi_gpio_0_1_board.xdc]
  read_xdc -ref ccc_design_axi_gpio_0_1 -cells U0 /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_axi_gpio_0_1/ccc_design_axi_gpio_0_1.xdc
  set_property processing_order EARLY [get_files /home/yarib/ZYBO_projects/Hardware/ccc-hw/ccc-hw.srcs/sources_1/bd/ccc_design/ip/ccc_design_axi_gpio_0_1/ccc_design_axi_gpio_0_1.xdc]
  read_xdc /home/yarib/ZYBO_projects/Hardware/ZYBO-master/Resources/XDC/ZYBO_Master.xdc
  link_design -top ccc_design_wrapper -part xc7z010clg400-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force ccc_design_wrapper_opt.dcp
  report_drc -file ccc_design_wrapper_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file ccc_design_wrapper.hwdef}
  place_design 
  write_checkpoint -force ccc_design_wrapper_placed.dcp
  report_io -file ccc_design_wrapper_io_placed.rpt
  report_utilization -file ccc_design_wrapper_utilization_placed.rpt -pb ccc_design_wrapper_utilization_placed.pb
  report_control_sets -verbose -file ccc_design_wrapper_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force ccc_design_wrapper_routed.dcp
  report_drc -file ccc_design_wrapper_drc_routed.rpt -pb ccc_design_wrapper_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file ccc_design_wrapper_timing_summary_routed.rpt -rpx ccc_design_wrapper_timing_summary_routed.rpx
  report_power -file ccc_design_wrapper_power_routed.rpt -pb ccc_design_wrapper_power_summary_routed.pb
  report_route_status -file ccc_design_wrapper_route_status.rpt -pb ccc_design_wrapper_route_status.pb
  report_clock_utilization -file ccc_design_wrapper_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force ccc_design_wrapper.mmi }
  write_bitstream -force ccc_design_wrapper.bit 
  catch { write_sysdef -hwdef ccc_design_wrapper.hwdef -bitfile ccc_design_wrapper.bit -meminfo ccc_design_wrapper.mmi -file ccc_design_wrapper.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

