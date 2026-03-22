class apb_driver extends uvm_driver #(apb_xtn);
`uvm_component_utils(apb_driver)
virtual apb_if.apb_drv_mp vif;
apb_config apb_cfg;

function new(string name="apb_driver",uvm_component parent);
	super.new(name,parent);
endfunction
function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
			`uvm_fatal(get_full_name,"getting the inetrface in the apb driver")
				
endfunction

function void connect_phase(uvm_phase phase);
	vif=apb_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
//	forever
//	begin	
	send_to_dut();
//	end	
endtask
task send_to_dut();
	apb_xtn xtn=apb_xtn::type_id::create("xtn");
	forever begin
		wait(vif.apb_drv_cb.Pselx ===(1||2||4||8))
			if(vif.apb_drv_cb.Pwrite==0)
				begin
					wait(vif.apb_drv_cb.Penable ==1)
					vif.apb_drv_cb.Prdata<= $urandom;
				end
			repeat(2)
				@(vif.apb_drv_cb);
	end
			//	xtn.print();
endtask
endclass
