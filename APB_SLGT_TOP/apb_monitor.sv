class apb_monitor extends uvm_monitor;
`uvm_component_utils(apb_monitor)
virtual apb_if.apb_mon_mp vif;
apb_xtn xtn;
apb_config apb_cfg;
uvm_analysis_port #(apb_xtn)apb_mon;


function new(string name="apb_monitor",uvm_component parent);
	super.new(name,parent);
	apb_mon=new("apb_mon",this);

endfunction
function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
			`uvm_fatal(get_full_name,"getting the inetrface in the monitor")
				
endfunction

function void connect_phase(uvm_phase phase);
	vif=apb_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	forever 
		collect_data();
endtask

task collect_data();
		xtn=apb_xtn::type_id::create("xtn");
		repeat(2)
		@(vif.apb_mon_cb);

		while(vif.apb_mon_cb.Penable ===1'b0)
		@(vif.apb_mon_cb);
		xtn.Pwrite=vif.apb_mon_cb.Pwrite;
		xtn.Paddr=vif.apb_mon_cb.Paddr;
		xtn.Pselx=vif.apb_mon_cb.Pselx;
		xtn.Penable=vif.apb_mon_cb.Penable;
		if(vif.apb_mon_cb.Pwrite === 1'b1)
			xtn.Pwdata=vif.apb_mon_cb.Pwdata;
		else
						xtn.Prdata=vif.apb_mon_cb.Prdata;
			`uvm_info("APB MON","PRINTING FROM APB MONITOR",UVM_LOW) 
			apb_mon.write(xtn);
endtask

endclass
