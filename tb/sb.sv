class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)
ahb_xtn axtn;
apb_xtn bxtn;
ahb_xtn mcov;
apb_xtn scov;
uvm_tlm_analysis_fifo #(ahb_xtn)fi_ahb;
uvm_tlm_analysis_fifo #(apb_xtn)fi_apb;

covergroup ahb_cover;
	option.per_instance = 1;
	HADDR:  coverpoint axtn.Haddr{bins min1 = {[32'h8000_0000: 32'h8000_03FF],[32'h8400_0000: 32'h8400_03FF],[32'h8800_0000: 32'h8800_03FF],[32'h8c00_0000: 32'h8c00_03FF]};}

	HSIZE: coverpoint axtn.Hsize{bins min2 = {0,1,2};}

	HTRANS: coverpoint mcov.Htrans {bins min3 = {0,1,2,3};}

/*	HBURST: coverpoint mcov.Hburst  {bins min4 = {0,1};
					 bins med4 = {3,7,5};
					 bins max4 = {2,6,4};}*/

	HWRITE: coverpoint mcov.Hwrite{bins min5 = {0,1};}

/*	HWDATA: coverpoint mcov.Hwdata{bins min6 = {[0:7]};
			//		bins min4={[16:23]};
			//  	     bins med6 = {[8:15]};
			//	     bins max6 = {[16:31]};}

//	HRDATA: coverpoint mcov.Hrdata{bins min7 = {[0:7]};
			  	     bins med7 = {[8:15]};
				     bins max7 = {[16:31]};} */

	HRESETN: coverpoint mcov.Hresetn{bins min8 = {[0:1]};}

	HREADYIN: coverpoint mcov.Hreadyin{bins min8 = {[0:1]};}

	HREADYOUT: coverpoint mcov.Hreadyout{bins min8 = {[0:1]};}

//	HRESP: coverpoint mcov.Hresp{bins min8 = {[0:1]};}

//	CROSS: cross HADDR,HSIZE,HTRANS,HWRITE,HRESETN,HREADYIN,HREADYOUT,HRESP;

endgroup

covergroup scg;
	option.per_instance = 1;
	

	PADDR:  coverpoint scov.Paddr{bins min1 = {[32'h8000_0000: 32'h8000_03FF]};
				     bins med1 = {[32'h8400_0000: 32'h8400_03FF]};
				     bins max1 = {[32'h8800_0000: 32'h8800_03FF]};
				     bins maxx1 = {[32'h8c00_0000: 32'h8c00_03FF]};}


	PWRITE: coverpoint scov.Pwrite{bins min2 = {[0:1]};}

/*	PRDATA: coverpoint scov.Prdata{bins min3 = {[0:7]};
			  	     bins med3 = {[8:15]};
				     bins max3 = {[16:32]};}

//	PWDATA: coverpoint scov.Pwdata{bins min4 = {[0:7]};
			  	     bins med4 = {[8:15]};
				     bins max4 = {[16:32]};}*/

	PRESETN: coverpoint scov.Presetn{bins min5 = {[0:1]};}

	PENABLE: coverpoint scov.Penable{bins min6 = {[0:1]};}

	PSELX: coverpoint scov.Pselx{bins min7 = {1,2,4,8};}

//	CROSS: cross PADDR,PWRITE,PRESETN,PENABLE,PSELX;

endgroup

function new(string name="scoreboard",uvm_component parent);
	super.new(name,parent);
	fi_ahb=new("fi_ahb",this);
	fi_apb=new("fi_apb",this);
	ahb_cover=new();
	scg=new();
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
		forever
			begin
				fork
					begin
						fi_ahb.get(axtn);
						 axtn.print();
						$display("SBBBBBBBBBBBBBBBBBBB");
						mcov=axtn;
						ahb_cover.sample();
					end
			
					begin
				
								fi_apb.get(bxtn);
								$display("SBBBBBBBBBBBBBBBBBBB");
								bxtn.print();
								scov=bxtn;
								scg.sample();
					end
						
					//	disable A;
				join
								check_data(axtn,bxtn);
			end
	endtask
  

task compare_data(input int Hdata,Pdata,Haddr,Paddr);
      $display("start of comparre_data");

    if(Haddr==Paddr)
      begin
          `uvm_info(get_type_name(),"addr matched",UVM_LOW)
          if(Hdata==Pdata)
          `uvm_info(get_type_name(),"data matched",UVM_LOW)
          else
          `uvm_info(get_type_name(),"data unmatched",UVM_LOW)
          end
    else
    `uvm_info(get_type_name(),"addr unmatched",UVM_LOW)
endtask


 task check_data(ahb_xtn mxtn,apb_xtn sxtn);
    $display("start of check_data");
    if(mxtn.Hwrite==1)
      begin
       $display("inside write");
      if(mxtn.Hsize==2'b00)
        begin 
          if(mxtn.Haddr[1:0]==2'b00)
            begin
            compare_data(mxtn.Hwdata[7:0],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
          else if(mxtn.Haddr[1:0]==2'b01)
            begin
            compare_data(mxtn.Hwdata[15:8],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
          else if(mxtn.Haddr[1:0]==2'b10)
            begin
            compare_data(mxtn.Hwdata[23:16],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
          else
            begin
            compare_data(mxtn.Hwdata[31:24],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
        end


       if(mxtn.Hsize==2'b01)
        begin
          if(mxtn.Haddr[1:0]==2'b00)
            begin
            compare_data(mxtn.Hwdata[15:0],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
          else
            begin
            compare_data(mxtn.Hwdata[31:16],sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
        end
      if(mxtn.Hsize==2'b10)
        begin
          if(mxtn.Haddr[1:0]==2'b00)
            begin
            compare_data(mxtn.Hwdata,sxtn.Pwdata,mxtn.Haddr,sxtn.Paddr);
            end
        end
    end
  endtask

	function void report_phase(uvm_phase phase);
	//	`uvm_info(get_type_name(), $sformatf("Number of data verified : %0d", data_verified_count), UVM_LOW);
            //    `uvm_info(get_type_name(),$sformatf("coverage of wr_data is %0f",mcov.$get_coverage()),UVM_LOW)
                 `uvm_info(get_type_name(),$sformatf("coverage of rd_data is %0f",$get_coverage()),UVM_LOW)
	
	endfunction

	



endclass
