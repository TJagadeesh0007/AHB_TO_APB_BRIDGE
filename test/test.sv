class test extends uvm_test;
`uvm_component_utils(test)
env envh;
env_config e_cfg;
ahb_config ahb_cfg;
apb_config apb_cfg;
single_seq1 seq1;
//wrap_seq seq2;	


	int no_of_ahb_agents=1;
      	int no_of_apb_agents=1;
	bit has_sb=1;


function new(string name="test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	e_cfg=env_config::type_id::create("e_cfg");
	ahb_cfg=ahb_config::type_id::create("ahb_cfg");
	apb_cfg=apb_config::type_id::create("apb_cfg");
	

		if(no_of_ahb_agents)
		if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_if",ahb_cfg.vif))
			`uvm_fatal(get_full_name,"getting the inetrface in the test")
 				ahb_cfg.is_active=UVM_ACTIVE;
		if(no_of_apb_agents)
			if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_if",apb_cfg.vif))
			`uvm_fatal(get_full_name,"getting the inetrface in the test in apb")
 				apb_cfg.is_active=UVM_ACTIVE;


		e_cfg.ahb_cfg=ahb_cfg;
		e_cfg.apb_cfg=apb_cfg;
		e_cfg.no_of_ahb_agents=no_of_ahb_agents;
		e_cfg.no_of_apb_agents=no_of_apb_agents;
		e_cfg.has_sb=has_sb;

	uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);

	envh=env::type_id::create("envh",this);

endfunction

endclass

class test1 extends test;
	`uvm_component_utils(test1)

function new(string name="test1",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	seq1=single_seq1::type_id::create("seq1");
	phase.raise_objection(this);
	seq1.start(envh.amgt.agent.seqrh);
	#1000;
	phase.drop_objection(this);
endtask
endclass
		

class test2 extends test;
	`uvm_component_utils(test2)
increment_seq seq2;	


function new(string name="test2",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
//	repeat(2)begin
	seq2=increment_seq::type_id::create("seq2");
	phase.raise_objection(this);
	seq2.start(envh.amgt.agent.seqrh);
	phase.drop_objection(this);
//	end
endtask
endclass



class test3 extends test;
	`uvm_component_utils(test3)
wrap_seq seq2;	

function new(string name="test3",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
//	repeat(2)begin
	seq2=wrap_seq::type_id::create("seq2");
	phase.raise_objection(this);
	seq2.start(envh.amgt.agent.seqrh);
	phase.drop_objection(this);
//	end
endtask
endclass


class test4 extends test;
	`uvm_component_utils(test4)
increment_seq1 seq3;	


function new(string name="test4",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
//	repeat(2)begin
	seq3=increment_seq1::type_id::create("seq3");
	phase.raise_objection(this);
	seq3.start(envh.amgt.agent.seqrh);
	
	phase.drop_objection(this);
//	end
endtask
endclass


