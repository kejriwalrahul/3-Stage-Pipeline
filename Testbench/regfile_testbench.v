/*
	Module written by Bharat Sai
	CS13B005

	Register File Testbench 
*/

`include "../Code/regfile.v"

module regfile_TestBench(
		output clk,
		output rst,

		output[3:0] srcReg1,
		output[3:0] srcReg2,
		output[3:0] nextDestReg,
		
		output[3:0] destReg,
		output[15:0] destVal,
		output storeNow,
		input storeDone,
		
		input[15:0] srcRegVal1,
		input[15:0] srcRegVal2,
		input inuse1,
		input inuse2
	);

	reg clk, rst, storeNow;
	reg[ 3:0] srcReg1, srcReg2, nextDestReg, destReg;
	reg[15:0] destVal;

	RegisterFile R(clk, rst, 
		srcReg1, srcReg2, nextDestReg, 
		destReg, destVal, storeNow, storeDone, 
		srcRegVal1, srcRegVal2, inuse1, inuse2);

	always begin
		#5 clk = ~clk;
	end

	initial begin
		$dumpfile("regfile.vcd");
    	$dumpvars(0, regfile_TestBench);

		$monitor($time,, {"clk: %b,rst: %b, srcReg1: %x, srcReg2: %x, nextDestReg: %x,", 
			" destReg: %x, destVal: %d, storeNow: %b, storeDone: %b,",
			" srcRegVal1: %x, srcRegVal2: %x, inuse1: %b, inuse2: %b",
            "\nRegs:",
			" 0:%x %b, 1:%x %b, 2:%x %b, 3:%x %b, 4:%x %b,",
			" 5:%x %b, 6:%x %b, 7:%x %b, 8:%x %b,",
			" 9:%x %b, 10:%x %b, 11:%x %b, 12:%x %b,",
            " 13:%x %b, 14:%x %b, 15:%x %b"},
			clk, rst,
			srcReg1, srcReg2, nextDestReg, 
			destReg, destVal, storeNow, storeDone, 
			srcRegVal1, srcRegVal2, inuse1, inuse2,
            R.r[0], R.inuse[0], R.r[1], R.inuse[1], R.r[2], R.inuse[2], R.r[3], R.inuse[3], R.r[4], R.inuse[4], 
			R.r[5], R.inuse[5], R.r[6], R.inuse[6], R.r[7], R.inuse[7], R.r[8], R.inuse[8], 
			R.r[9], R.inuse[9], R.r[10], R.inuse[10], R.r[11], R.inuse[11], R.r[12], R.inuse[12], 
			R.r[13], R.inuse[13], R.r[14], R.inuse[14], R.r[15], R.inuse[15]);

		// Begin testcases
		#0
		srcReg1 = 0;
		srcReg2 = 1;
		nextDestReg = 2;
		destReg = 3;
		destVal = 256;
		storeNow = 1;

		#10
		srcReg1 = 2;
		
		#10
		srcReg2 = 3;

		#10
        nextDestReg = 4;

		#10
		destReg = 5;

		#10
        destVal = 128;

		#10
        storeNow = 0;

		#10
		rst = 1;

		#10
		srcReg1 = 0;
		srcReg2 = 1;
		nextDestReg = 2;
		destReg = 3;
		destVal = 256;
		storeNow = 1;

		#20 $finish;
	end


	/*
		System Verilog Assertions
		-------------------------

		Added by Rahul Kejriwal, CS14B023		
	*/


	/*
		Assert lookup of registers
	*/
	property P1;
      @(posedge clk)
			srcRegVal1 == R.r[srcReg1] and 
			srcRegVal2 == R.r[srcReg2] and 
			inuse1     == R.inuse[srcReg1] and
			inuse2 	   == R.inuse[srcReg2];
	endproperty

	RegLookup:
		assert property(P1)
		else $display("Failure at RegLookup");

	/*
		Assert inuse set and reset 
	*/
	property P2;
      reg[7:0] next_dest;
      reg[7:0] dest;
      
      @(posedge clk) (1, next_dest=nextDestReg, dest=destReg) 
      		##1 ((dest == next_dest or R.inuse[dest] == 0) and 
      		(R.inuse[next_dest] == 1));
	endproperty

	InuseSetReset:
		assert property(P2)
		else $display("Failure at InuseSetReset");

	/*
		Assert writing of register
	*/
	property P4;
      @(posedge clk) $rose(storeDone) |-> R.r[destReg] == destVal;
	endproperty

	WriteAtSignal:
		assert property(P4)
		else $display("Failure at WriteAtSignal");
	
	/*
		Assert reset properties
	*/
	property P5;
		@(posedge clk) $rose(rst) |->
			srcRegVal1 == 16'b0
			and srcRegVal2 == 16'b0
			and inuse1 == 0
			and inuse2 == 0
			and storeDone == 0;
	endproperty

	ResetSignals:
		assert property(P5)
		else $display("Failure at ResetSignals");
	
	/*
		Assert Reset of registers and inuse bits 
	*/
	property ResetProp(i);
		@(posedge clk) $rose(rst) |-> R.r[i] == 0 and R.inuse[i] == 0;
	endproperty

	generate
		for(genvar i=0; i<16; i++)
			assert property(ResetProp(i))
			else $display("Failure at ResetProp(%d)",i);
	endgenerate
	
	/*
    	Assert eventual storeDone after storeNow
    */
	property P7;
      @(posedge storeNow) ##[1:$] $rose(storeDone);
    endproperty
              
	EventualStoreDone:
		assert property(P7)
        else $display("Failure at EventualStoreDone");
          
endmodule