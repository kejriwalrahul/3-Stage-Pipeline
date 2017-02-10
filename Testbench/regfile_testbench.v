/*
	Module written by Rahul Kejriwal
	CS14B023

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

		clk = 0;
		rst = 0;
		storeNow = 0;
		srcReg1 = 0;
		srcReg2 = 0;
		nextDestReg = 0;
		destReg = 0;
		destVal = 0;

		$monitor($time,, {"clk: %b, srcReg1: %x, srcReg2: %x, nextDestReg: %x,", 
			"\n destReg: %x, destVal: %x, storeNow: %b, storeDone: %b",
			"\nsrcRegVal1: %x, srcRegVal2: %x, inuse1: %b, inuse2: %b"}, 
			clk, 
			srcReg1, srcReg2, nextDestReg, 
			destReg, destVal, storeNow, storeDone, 
			srcRegVal1, srcRegVal2, inuse1, inuse2);

		// Begin testcases
		#5 
		srcReg1 = 0;
		srcReg2 = 1;
		nextDestReg = 2;
		destReg = 3;
		destVal = 256;
		storeNow = 1;

		#50 $finish;
	end

endmodule