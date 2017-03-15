/*
	Interface written by Rahul Kejriwal
	CS14B023 
*/

/*
	Issues:
		1. Clk ##1?
		2. always @(srcReg1 or srcReg2 or nextDestReg)
				when a = a + b
					 a = a + b
		3. access r and inuse
*/

interface RegisterFileChecker(
		logic clk,
		logic rst,

		// logic Ports from Decoder
		logic[3:0] srcReg1,
		logic[3:0] srcReg2,
		logic[3:0] nextDestReg,
		
		// logic Ports from Execute
		logic[3:0] destReg,
		logic[15:0] destVal,
		logic storeNow,
		logic storeDone,
		
		// Output ports to Decoder
		logic[15:0] srcRegVal1,
		logic[15:0] srcRegVal2,
		logic inuse1,
		logic inuse2
	);
	
	/*
		Assert lookup of registers
	*/
	property P1;
		@(srcReg1 or srcReg2 or nextDestReg) 
			##1 
			/*To Do: Fix usage of r and inuse*/
			srcRegVal1 == r[srcReg1] and 
			srcRegVal2 == r[srcReg2] and 
			inuse1     == inuse[srcReg1] and
			inuse2 	   == inuse[srcReg2]
	endproperty

	RegLookup:
		assert property(P1)
		else $display("Failure at RegLookup");


	/*
		Assert inuse set and reset 
	*/
	property P2;
		@(posedge clk) /* Loop inside? */ 
	endproperty

	InuseSetReset:
		assert property(P2);
		else $display("Failure at InuseSetReset");


	/*
		Assert no inuse change at non-clk-edge 
	*/
	property P3;
		/*To Do: No clue*/
	endproperty

	NoChangeInuseWoutClk:
		assert property(P3);
		else $display("Failure at NoChangeInuseWoutClk");


	/*
		Assert writing of register
	*/
	property P4;
		/*To Do: Fix usage of r and inuse*/	
		@(posedge storeNow) r[destReg] == destVal
	endproperty

	WriteAtSignal:
		assert property(P4);
		else $display("Failure at WriteAtSignal");

endinterface

bind registerFile_TestBench RegisterFileChecker BoundDecoder(
		clk, rst,
		srcReg1, srcReg2, nextDestReg,
		destReg, destVal, storeNow, storeDone,
		srcRegVal1, srcRegVal2, inuse1, inuse2
);