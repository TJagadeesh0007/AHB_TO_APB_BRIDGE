 package test_pkg;

 //  import uvm_pkg.sv
	import uvm_pkg::*;
  // include uvm_macros.sv
`include "uvm_macros.svh"


`include "ahb_config.sv"
`include "apb_config.sv"
`include "env_config.sv"

`include "ahb_xtn.sv"
`include "ahb_sequence.sv"
`include "ahb_driver.sv"
`include "ahb_monitor.sv"
`include "ahb_sequencer.sv"
`include "ahb_agent.sv"
`include "ahb_magent_top.sv"
`include "apb_xtn.sv"
`include "apb_sequencer.sv"                                                            
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"
`include "apb_sagent_top.sv"

// `include "ram_virtual_sequencer.sv"
// `include "ram_virtual_seqs.sv"
`include "sb.sv"

`include "env.sv"


`include "test.sv"
endpackage









