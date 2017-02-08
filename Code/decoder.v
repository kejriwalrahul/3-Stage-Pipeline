/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module
*/

module decodeAndFetchOperands(
		input clk,

		// Input from Fetch Instruction unit
		input[15:0] instr,

		// Input ports from RegFile
		input[15:0] srcRegVal1,
		input[15:0] srcRegVal2,
		input inuse1,
		input inuse2,

		// Output ports to RegFile
		output[ 3:0] srcReg1,
		output[ 3:0] srcReg2,
		output[ 3:0] nextDestReg,

		// Output ports to Execute unit
		output[ 3:0] opcode,
		output[ 3:0] destReg,
		output[15:0] srcVal1,
		output[15:0] srcVal2,
		output[ 7:0] memAddr, 
		output used1,
		output used2
	);


	/*
		Declare all outputs as registers
	*/
	reg[ 3:0] srcReg1, srcReg2, nextDestReg;

	reg[ 3:0] opcode, destReg;
	reg[15:0] srcVal1, srcVal2;
	reg[ 7:0] memAddr;
	reg used1, used2;

	always @(posedge clk) begin
		nextDestReg = instr[8+:4]
		srcReg1 = instr[4+:4]
		srcReg2 = instr[0+:4]
	

	end

	always @(srcRegVal1 or srcRegVal2 or inuse1 or inuse2) begin

	end

endmodule