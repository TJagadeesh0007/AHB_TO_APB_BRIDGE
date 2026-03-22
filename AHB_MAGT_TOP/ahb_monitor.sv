class ahb_monitor extends uvm_monitor;
`uvm_component_utils(ahb_monitor)
virtual ahb_if.ahb_mon_mp vif;
ahb_config ahb_cfg;
uvm_analysis_port #(ahb_xtn)ahb_mon;


function new(string name="ahb_monitor",uvm_component parent);
	super.new(name,parent);
	ahb_mon=new("ahb_mon",this);
endfunction
function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
			`uvm_fatal(get_full_name,"getting the inetrface in the monitor")
				
endfunction

function void connect_phase(uvm_phase phase);
	vif=ahb_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(2) @(vif.ahb_mon_cb);
		forever
			collect_data();
endtask

task collect_data();
ahb_xtn	xtn;
xtn=ahb_xtn::type_id::create("xtn");
		while(vif.ahb_mon_cb.Hreadyout!==1)
			@(vif.ahb_mon_cb);
		while(vif.ahb_mon_cb.Htrans!==2'b11 && vif.ahb_mon_cb.Htrans!==2'b10)
			@(vif.ahb_mon_cb);
		xtn.Haddr=vif.ahb_mon_cb.Haddr;
		xtn.Hwrite=vif.ahb_mon_cb.Hwrite;
		xtn.Htrans=vif.ahb_mon_cb.Htrans;
		xtn.Hsize=vif.ahb_mon_cb.Hsize;
		xtn.Hreadyin=vif.ahb_mon_cb.Hreadyin;
			@(vif.ahb_mon_cb);
			while(vif.ahb_mon_cb.Hreadyout!==1)
		@(vif.ahb_mon_cb);
	if(xtn.Hwrite==1'b1)
		xtn.Hwdata=vif.ahb_mon_cb.Hwdata;
	
	else
		xtn.Hrdata=vif.ahb_mon_cb.Hrdata;
	`uvm_info("MAS MON","PRINTIG FROM MASTER MONITOR",UVM_LOW)
	xtn.print();
	ahb_mon.write(xtn);
	

endtask


	
endclass
