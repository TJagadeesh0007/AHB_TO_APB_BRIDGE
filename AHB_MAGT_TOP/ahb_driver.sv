class ahb_driver extends uvm_driver #(ahb_xtn);
`uvm_component_utils(ahb_driver)
virtual ahb_if.ahb_drv_mp vif;
ahb_config ahb_cfg;
ahb_xtn req;
function new(string name="ahb_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
			`uvm_fatal(get_full_name,"getting the inetrface in the driver")
				
endfunction

function void connect_phase(uvm_phase phase);
	vif=ahb_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
			@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.Hresetn<=1'b0;
			@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.Hresetn<=1'b1;
		//	@(vif.ahb_drv_cb);
		
		forever
			begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
			end
endtask

task send_to_dut(ahb_xtn xtn);
			@(vif.ahb_drv_cb);

	while(vif.ahb_drv_cb.Hreadyout!==1)
			@(vif.ahb_drv_cb);
	
	vif.ahb_drv_cb.Haddr<=xtn.Haddr;
	vif.ahb_drv_cb.Hwrite<=xtn.Hwrite;
	vif.ahb_drv_cb.Hburst<=xtn.Hburst;
	vif.ahb_drv_cb.Hsize<=xtn.Hsize;
	vif.ahb_drv_cb.Htrans<=xtn.Htrans;
	vif.ahb_drv_cb.Hreadyin<=1'b1;
		@(vif.ahb_drv_cb);
	while(vif.ahb_drv_cb.Hreadyout!==1)
		@(vif.ahb_drv_cb);
	if(xtn.Hwrite==1)
		vif.ahb_drv_cb.Hwdata<=req.Hwdata;
	
	else
		vif.ahb_drv_cb.Hwdata<=32'b0;
		//	@(vif.ahb_drv_cb);
	`uvm_info("ahb_driver", "data from ahb_driver is  \n %s xtn.sprint()",UVM_LOW)
	xtn.print();
	
			

endtask 

endclass
