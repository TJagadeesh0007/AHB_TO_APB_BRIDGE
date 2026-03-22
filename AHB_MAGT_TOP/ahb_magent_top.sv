class ahb_magent_top extends uvm_env;
`uvm_component_utils(ahb_magent_top)
ahb_agent agent;
//int no_of_agents=1;

function new(string name="ahb_magent_top",uvm_component parent);
	super.new(name,parent);
endfunction
	
function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	//	agent=new [no_of_agents];
		//	foreach(agent[i])
				agent=ahb_agent::type_id::create("agent",this);
endfunction
endclass
