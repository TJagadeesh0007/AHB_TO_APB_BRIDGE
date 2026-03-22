module top();
import uvm_pkg::*;
import test_pkg::*;
bit clock=0;
always #5 clock=~clock;
ahb_if if0(clock);
apb_if if1(clock);
	rtl_top DUV(.Hclk(clock),
		    .Hresetn(if0.Hresetn),
		    .Htrans(if0.Htrans),
		    .Hsize(if0.Hsize),
		    .Hreadyin(if0.Hreadyin),
		    .Hwdata(if0.Hwdata),
		    .Haddr(if0.Haddr),
		    .Hwrite(if0.Hwrite),
		    .Hrdata(if0.Hrdata),
//		    .Hresp(if0.Hresp),
		    .Hreadyout(if0.Hreadyout),
		    .Prdata(if1.Prdata),
		    .Pselx(if1.Pselx),
		    .Pwrite(if1.Pwrite),
		    .Penable(if1.Penable),
		    .Paddr(if1.Paddr),
		    .Pwdata(if1.Pwdata));


initial
	begin
		uvm_config_db #(virtual ahb_if)::set(null,"*","ahb_if",if0);
		uvm_config_db #(virtual apb_if)::set(null,"*","apb_if",if1);

		run_test();
	end

property reset_con;
	@(posedge clock) $fell(if0.Hresetn) |-> if0.Hrdata==0 || if0.Hwdata==0;
endproperty

property master_trans;
	@(posedge clock) disable iff(!       if0.Hresetn) 
				$rose(if0.Hreadyout) |=> if0.Hwrite or !if0.Hwrite;
endproperty

property slave_trans;
	@(posedge clock) if1.Pselx |-> (if1.Pwrite ##[0:100] if1.Penable) or (!if1.Pwrite ##[0:100] if1.Penable) ;

endproperty

assert property(reset_con);
assert property(master_trans);
assert property(slave_trans);

endmodule
