class env_config extends uvm_object;
	`uvm_object_utils(env_config)
	int no_of_ahb_agents;
	int no_of_apb_agents;
	ahb_config  ahb_cfg;
	apb_config  apb_cfg;
// bit has_src_agent;
// bit has_dst_agent;
bit has_sb;


	function new(string name="env_config");
		super.new(name);
	endfunction
endclass

