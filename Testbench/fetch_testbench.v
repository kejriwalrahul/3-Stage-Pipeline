/*
	Module written by Rahul Kejriwal
	CS14B023

	Fetch unit test bench
*/

`include "../Code/fetch.v"

module fetch_TestBench(
		output clk,
		output rst,

		input[7:0] instr_addr,
		output[15:0] instr,

		input[15:0] curr_instr
	);

	reg clk, rst;
	reg[15:0] instr;

	fetchInstruction I(clk, rst, instr_addr, instr, curr_instr);

	always begin
		#1 clk = ~clk;
	end

	initial begin
		$dumpfile("fetch.vcd");
    	$dumpvars(0,fetch_TestBench);

		clk = 0;
		rst = 0;
		instr = 0;
	
		$monitor($time,, "clk: %b, Address: %b, IR: %b, ISent: %b", clk, instr_addr, curr_instr, instr);
		#550 $finish;
	end

	always @(instr_addr) begin
		instr = instr_addr << 8 | instr_addr ^ 8'b11111111;
	end 


	/*
		System Verilog Assertions
		-------------------------
	*/


	/*
		Assert reset conditions
	*/
	property P1;
      @(posedge rst) (instr_addr == 8'b0 and curr_instr	== 16'b0);
	endproperty

	Reset:
  		assert property(P1)
        else $display("Failure at Reset");
    
    /*
    	Assert incrementing of PC mod 2**8
    */
    property P2;
      reg[7:0] prev_progctr;
      
      @(posedge clk) (1,prev_progctr = instr_addr) ##1 (instr_addr == ((prev_progctr + 1)&8'b11111111)); 
	endproperty

	PCIncrement:
        assert property(P2)
          else $display("Failure at PCIncrement");
    
    /*
    	Assert forwarding of retrieved instr
    */
    property P3;
      reg[15:0] old_instr;
      
      @(posedge clk) (1, old_instr = instr) ##1 curr_instr == old_instr;
    endproperty
          
    InstrForward:
          assert property(P3)
            else $display("Failure at InstrForward");  

	/*
		Assert loop back of address to 0 after 255
	*/	        	       
	property P4;
      @(posedge clk) instr_addr == 8'b11111111 |-> ##1 instr_addr == 8'b0;
    endproperty
            
    AddrLoopBack:
        assert property(P4)
        else $display("Failure at AddrLoopBack");
endmodule