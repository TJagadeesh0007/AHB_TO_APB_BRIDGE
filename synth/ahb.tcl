remove_design -all
set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

analyze -format verilog ../Bridge_rtl/ahb_apb_top.v ../Bridge_rtl/ahb_slave.v ../Bridge_rtl/apb_controller.v 

elaborate rtl_top

link
#create_clock -period 10 -name clk [get -ports clk]

check_design

current_design rtl_top

compile_ultra

write_file -f verilog -hier -output apb_report.v


#redirect timing_report.txt {report_timing -path full}


 

