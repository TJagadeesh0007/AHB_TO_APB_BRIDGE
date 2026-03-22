class base_seq extends uvm_sequence#(ahb_xtn);
`uvm_object_utils(base_seq)
int len=4;
	function new(string name="base_seq");
		super.new(name);
	endfunction
endclass

class single_seq1 extends base_seq;
	`uvm_object_utils(single_seq1)
		function new(string name="single_seq");
			super.new(name);
		endfunction

	task body();
		req=ahb_xtn::type_id::create("req");
			repeat(50);
			begin
			start_item(req);
			assert(req.randomize() with {Hburst==3'b000;Hwrite==1;Htrans==2'b10;});
			finish_item(req);
			end
			$display("=================SEQ==================");
			req.print();
	endtask

endclass

class increment_seq extends base_seq;
 	`uvm_object_utils(increment_seq)
		function new(string name="increment_seq");
			super.new(name);
		endfunction
	bit [2:0]hburst;
	bit [1:0]htrans;
	bit [2:0]hsize;
  	bit [31:0]haddr;
	bit hwrite;


	task body();
			req=ahb_xtn::type_id::create("req");

			begin
			start_item(req);
			assert(req.randomize() with {Hburst inside{3,5,7};Hwrite==1;Htrans==2'b10;});
			finish_item(req);
			$display("=================SEQ==================");
			req.print();
		
			hburst=req.Hburst;
			htrans=req.Htrans;
			hsize=req.Hsize;
			haddr=req.Haddr;
			hwrite=req.Hwrite;
			
			for(int i=1;i<8;i++)
			begin
			start_item(req);
			assert(req.randomize() with {Hburst==hburst;Hwrite==Hwrite;Htrans==2'b11;
							Haddr==haddr+2**hsize;Hsize==hsize;});
			finish_item(req);
			haddr=req.Haddr;

			req.print();
			end
		end

		endtask	

endclass  


class wrap_seq extends base_seq;
 	`uvm_object_utils(wrap_seq)
		function new(string name="wrap_seq");
			super.new(name);
		endfunction
	bit [2:0]hburst;
	bit [1:0]htrans;
	bit [2:0]hsize;
  	bit [31:0]haddr;
	bit hwrite;
	bit [31:0] start_addr,wrap_addr ;
	bit [9:0] len;


	task body();
			req=ahb_xtn::type_id::create("req");

			begin
			start_item(req);
			assert(req.randomize() with {Hburst inside {2,4,6};Hwrite==1;Htrans==2'b10;});
			finish_item(req);
			req.print;
		
			hburst=req.Hburst;
			htrans=req.Htrans;
			hsize=req.Hsize;
			haddr=req.Haddr;
			hwrite=req.Hwrite;
			len=req.len;

				$display("current %0d",haddr);
			start_addr=int'((haddr/((2**hsize)*(len+1))))*((2**hsize)*(len+1));
				$display("start_addr %0d",start_addr);
			wrap_addr=start_addr+((2**hsize)*(len+1));
				$display("wrap_addr %0d",wrap_addr);

			for(int i=1;i<len+1;i++)
			begin
			$display("=================SEQ==================");

			haddr=req.Haddr+2**hsize;
			start_item(req);
			if(haddr>=wrap_addr)
			haddr=start_addr;
			assert(req.randomize() with {Hburst==hburst;Hwrite==hwrite;Htrans==2'b11;Hsize==hsize;Haddr==req.Haddr;});
			finish_item(req);
		
			req.print();
			end
		end

		endtask	

endclass  

class increment_seq1 extends base_seq;
 	`uvm_object_utils(increment_seq1)
		function new(string name="increment_seq1");
			super.new(name);
		endfunction
	bit [2:0]hburst;
	bit [1:0]htrans;
	bit [2:0]hsize;
  	bit [31:0]haddr;
	bit hwrite;


	task body();
			req=ahb_xtn::type_id::create("req");

			begin
			start_item(req);
			assert(req.randomize() with {Hburst==3'b011;Hwrite==1;Htrans==2'b10; Haddr inside {[32'h8800_0000:32'h8800_03FF]};});
			finish_item(req);
			$display("=================SEQ==================");
			hburst=req.Hburst;
			htrans=req.Htrans;
			hsize=req.Hsize;
			haddr=req.Haddr;
			hwrite=req.Hwrite;
			
			for(int i=1;i<16;i++)
			begin
			start_item(req);
			assert(req.randomize() with {Hburst==hburst;Hwrite==hwrite;Htrans==2'b11;
							Haddr==haddr+2**hsize;Hsize==hsize;});
			finish_item(req);
			haddr=req.Haddr;

		//	req.print();
			end
		end

		endtask	

endclass



		
