class ahb_xtn extends uvm_sequence_item;
`uvm_object_utils(ahb_xtn)
	bit Hresetn;
   rand bit[31:0]Haddr;
   rand	bit Hwrite;
   rand	bit[1:0]Htrans;
   rand	bit[2:0]Hsize;
	bit[31:0]Hrdata;
   rand	bit[31:0]Hwdata;
	bit Hreadyin;
	bit Hreadyout;
   rand	bit[2:0]Hburst;
	bit[1:0]Hresp;
	rand bit[9:0] len;

	constraint c1{Hsize inside{[0:2]};}
	constraint c2{(Hsize == 1) -> (Haddr%2==0);
	    		(Hsize == 2) -> (Haddr%4==0);}

	constraint c3{ Haddr inside
				{[32'h8000_0000:32'h8000_03FF],
				 [32'h8400_0000:32'h8400_03FF],
				 [32'h8800_0000:32'h8800_03FF],
				 [32'h8c00_0000:32'h8c00_03FF]};}

//	constraint c3{ Haddr inside {[0:1000]};}

	constraint c4{(Haddr%1024)+(len*(2**Hsize)) <=1023;}
	constraint c5{(Hburst==2)  ->(len==4);
			(Hburst==3) ->(len==4);
		       (Hburst==4)  ->(len==8);
			(Hburst==5)->(len==8);
		       (Hburst==6)  ->(len==16);
			(Hburst==7)->(len==16);}

function new(string name="ahb_xtn");
	super.new(name);
endfunction

function void do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("Haddr",this.Haddr,32,UVM_DEC);
	printer.print_field("Hwrite",this.Hwrite,1,UVM_BIN);
	printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
	printer.print_field("Hsize",this.Hsize,3,UVM_DEC);
	printer.print_field("Hrdata",this.Hrdata,32,UVM_DEC);
	printer.print_field("Hwdata",this.Hwdata,32,UVM_DEC);
	printer.print_field("Hreadyin",this.Hreadyin,1,UVM_BIN);
	printer.print_field("Hreadyout",this.Hreadyout,1,UVM_BIN);
	printer.print_field("Hburst",this.Hburst,3,UVM_DEC);
	printer.print_field("Hresp",this.Hresp,2,UVM_DEC);
	printer.print_field("Hresetn",this.Hresetn,1,UVM_DEC);
endfunction

       

endclass
