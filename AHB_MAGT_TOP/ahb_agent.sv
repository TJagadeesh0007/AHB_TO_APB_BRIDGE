class ahb_agent extends uvm_agent;
`uvm_component_utils(ahb_agent)
	ahb_sequencer seqrh;
	ahb_driver    drvh;
	ahb_monitor   monh;
	ahb_config   ahb_cfg;

	function new(string name="ahb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
			`uvm_fatal(get_full_name,"getting the config in ahb agent")
			monh=ahb_monitor::type_id::create("monh",this);
	               if(ahb_cfg.is_active==UVM_ACTIVE)
				seqrh=ahb_sequencer::type_id::create("seqrh",this);
				drvh=ahb_driver::type_id::create("drvh",this);
	endfunction

	function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
	               if(ahb_cfg.is_active==UVM_ACTIVE)
				drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction
endclass
