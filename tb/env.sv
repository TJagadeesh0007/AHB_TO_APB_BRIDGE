class env extends uvm_env;
`uvm_component_utils(env)
ahb_magent_top amgt;
apb_sagent_top asgt;
scoreboard sb;
env_config e_cfg;
ahb_config ahb_cfg;
apb_config apb_cfg;
function new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
		`uvm_fatal(get_full_name,"getting the configs in env")
		amgt=ahb_magent_top::type_id::create("amgt",this);
		uvm_config_db #(ahb_config)::set(this,"*","ahb_config",e_cfg.ahb_cfg);
		asgt=apb_sagent_top::type_id::create("asgt",this);
		uvm_config_db #(apb_config)::set(this,"*","apb_config",e_cfg.apb_cfg);
	if(e_cfg.has_sb)	
	sb=scoreboard::type_id::create("sb",this);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
		super.start_of_simulation_phase(phase);
		uvm_top.print_topology();
endfunction

function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		amgt.agent.monh.ahb_mon.connect(sb.fi_ahb.analysis_export);
		//for(int i=0;i<4;i++)
		asgt.agent.monh.apb_mon.connect(sb.fi_apb.analysis_export);
endfunction
endclass



