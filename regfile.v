/*
	Module written by Rahul Kejriwal
	CS14B023

	Currently, asynchronous RegisterFile that does not use clk.
*/

module RegisterFile(
	input[3:0] srcReg1,
	input[3:0] srcReg2,
	input[3:0] nextDestReg,
	
	input[3:0] destReg,
	input[15:0] destVal,
	
	output[15:0] srcRegVal1,
	output[15:0] srcRegVal2,
	output inuse1,
	output inuse2
);
	
	// Array of Registers 
	reg[15:0] r[0:15];
	reg inuse[0:15];

	// Declare outputs as regs
	reg[15:0] srcRegVal1, srcRegVal2;
	reg inuse1, inuse2;

	/*
		For loop initialization
		
		Possible issue: What does this synthesize to?
	*/
	integer i;

	/*
		Initialize all registers and inuse bits to 0.
	*/
	initial begin
		for(i=0; i<16; i++) begin
			r[i] = 16'b0;
			inuse[i] = 1'b0;
		end
	end

	/*
		When any input changes, recompute outputs for 'Decode & Fetch Operand' stage
	*/
	always @(srcReg1 or srcReg2 or nextDestReg) begin
		srcRegVal1 = r[srcReg1];
		srcRegVal2 = r[srcReg2];
		inuse1 	   = inuse[srcReg1];
		inuse2 	   = inuse[srcReg2];
		inuse[nextDestReg] = 1'b1;
	end

	/*
		Issue: Consider 2 instruction - 
			I1:	add R3, R1, R2
			I2:	add R3, R4, R5

			I1 will reset inuse[R3] and I2 will set inuse[R3] leading to ??
	
		Fix: Unimplemented
	*/
	always @(destReg) begin
		r[destReg] = destVal;
		inuse[destReg] = 1'b0;
	end

endmodule