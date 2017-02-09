/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module
*/

module decodeAndFetchOperands(
		input clk,
		input rst,

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

	/*
		Zero all registers at start
	*/
	initial begin
		srcReg1 	= 4'b0; 	
		srcReg2 	= 4'b0; 	
		nextDestReg = 4'b0; 	
	
		opcode 		= 4'b0;
		destReg		= 4'b0;
		srcVal1		= 16'b0;
		srcVal2		= 16'b0;
		memAddr		= 8'b0;
		used1		= 0;
		used2		= 0;		
	end

	/*
		Zero all registers on reset
	*/
	always @(posedge rst) begin
		srcReg1 	= 4'b0; 	
		srcReg2 	= 4'b0; 	
		nextDestReg = 4'b0; 	
	
		opcode 		= 4'b0;
		destReg		= 4'b0;
		srcVal1		= 16'b0;
		srcVal2		= 16'b0;
		memAddr		= 8'b0;
		used1		= 0;
		used2		= 0;
	end

	/*
		Operation Logic
	*/
	always @(posedge clk) begin
		opcode 		= instr[ 0+:4];

		// If LOAD instruction
		if(opcode == 4'b1110) begin
			memAddr		= instr[ 4+:8];
			nextDestReg = instr[12+:4];
			destReg 	= instr[12+:4];
		end
		// If STORE instruction
		else if(opcode == 4'b1111) begin
			memAddr		= instr[ 4+:8];
			nextDestReg = instr[12+:4];
			destReg 	= instr[12+:4];			

			// Send addr to regfile
			srcReg1 	= instr[12+:4];
		end
		// For other instructions
		else begin
			nextDestReg = instr[ 4+:4];
			destReg 	= instr[ 4+:4];
			srcReg1 	= instr[ 8+:4];
			srcReg2 	= instr[12+:4];
		end
	end

	/*
		On Feedback from Register File
	*/
	always @(srcRegVal1 or srcRegVal2 or inuse1 or inuse2) begin
		srcVal1 = srcRegVal1;
		srcVal2 = srcRegVal2;
		used1   = inuse1;
		used2   = inuse2;
	end

endmodule