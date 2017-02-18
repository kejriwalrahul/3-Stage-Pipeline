/*
	Module written by Rahul Kejriwal
	CS14B023

	Currently, asynchronous RegisterFile that uses clk only for modifications to inuse bits.
*/

module RegisterFile(
		input clk,
		input rst,

		input[3:0] srcReg1,
		input[3:0] srcReg2,
		input[3:0] nextDestReg,
		
		input[3:0] destReg,
		input[15:0] destVal,
		input storeNow,
		output storeDone,
		
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

	reg storeDone;

	/*
		For loop initialization
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

		srcRegVal1 = 16'b0;
		srcRegVal2 = 16'b0;
		inuse1 = 0;
		inuse2 = 0;
		
		storeDone = 0;
		$monitor($time,, {"Regs:",
			"\n 0:%x %b, 1:%x %b, 2:%x %b, 3:%x %b, 4:%x %b,",
			"\n 5:%x %b, 6:%x %b, 7:%x %b, 8:%x %b,",
			"\n 9:%x %b, 10:%x %b, 11:%x %b, 12:%x %b,",
			"\n 13:%x %b, 14:%x %b, 15:%x %b"}, 
			r[0], inuse[0], r[1], inuse[1], r[2], inuse[2], r[3], inuse[3], r[4], inuse[4], 
			r[5], inuse[5], r[6], inuse[6], r[7], inuse[7], r[8], inuse[8], r[9], inuse[9], 
			r[10], inuse[10], r[11], inuse[11], r[12], inuse[12], r[13], inuse[13], r[14], inuse[14], r[15], inuse[15]);
	end

	/*
		Initialize all registers and inuse bits to 0 on reset.
	*/
	always @(posedge rst) begin
		for(i=0; i<16; i++) begin
			r[i] = 16'b0;
			inuse[i] = 1'b0;
		end		

		srcRegVal1 = 16'b0;
		srcRegVal2 = 16'b0;
		inuse1 = 0;
		inuse2 = 0;
		storeDone = 0;
	end

	/*
		When any input changes, recompute outputs for 'Decode & Fetch Operand' stage
	*/
	always @(srcReg1 or srcReg2 or nextDestReg) begin
		srcRegVal1 = r[srcReg1];
		srcRegVal2 = r[srcReg2];
		inuse1 	   = inuse[srcReg1];
		inuse2 	   = inuse[srcReg2];
	end

	/*
		Set inuse at posedge
	*/
	always @(posedge clk) begin
		
		for(i=0;i<16;i++)
			inuse[i] = 1'b0;
		
		inuse[nextDestReg] = 1'b1;
	end

	/*
		Issue: [FIXED] Consider 2 instruction - 
			I1:	add R3, R1, R2
			I2:	add R3, R4, R5

			I1 will reset inuse[R3] and I2 will set inuse[R3] leading to ??
	
		Fix: Done
	*/
	always @(posedge storeNow) begin
		storeDone = 0;
		r[destReg] = destVal;
		storeDone = 1;
	end

endmodule