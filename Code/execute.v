/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module for execution and result storgae 
*/

module executeAndStoreBack(
		input clk,
		input rst,

		input[ 3:0] opcode,
		input[ 3:0] destReg,
		input[15:0] srcVal1,
		input[15:0] srcVal2,
		input[ 7:0] memAddr, 
		input used1,
		input used2,

		output[ 3:0] destRegStore,
		output[15:0] destVal,

		output[ 7:0] memAddrLoadStore,
		output[15:0] memValueStore,

		input[15:0] memValueLoad,

		output[15:0] ProcessorStatusWord
	);

	reg[ 3:0] destRegStore;
	reg[ 7:0] memAddrLoadStore;
	reg[15:0] destVal, memValueStore;

	reg[15:0] LastComputedValue;
	reg[15:0] ProcessorStatusWord;

	initial begin
		destRegStore 		= 4'b0;
		memAddrLoadStore	= 8'b0;
		memValueStore		= 16'b0;
		destVal				= 16'b0;
		
		LastComputedValue   = 16'b0;
		ProcessorStatusWord = 16'b0;		
	end

	always @(posedge rst) begin
		destRegStore 		= 4'b0;
		memAddrLoadStore	= 8'b0;
		memValueStore		= 16'b0;
		destVal				= 16'b0;
		
		LastComputedValue   = 16'b0;
		ProcessorStatusWord = 16'b0;
	end

	always @(posedge clk) begin

		reg[15:0] val1, val2;
		ProcessorStatusWord = 16'b0;

		if(used1)
			val1 = LastComputedValue;
		else
			val1 = srcVal1;			

		if(used2)
			val2 = LastComputedValue;
		else
			val2 = srcVal2;			

		case(opcode)
			// NOP
			 0: // Doing nothing

			// HLT
			 1: $finish;
			 
			// ADD
			 2: {ProcessorStatusWord[15],destVal} = val1 + val2;
			 	
			 	if(val1[15] == val2[15] && destVal[15] != val1[15])
			 		ProcessorStatusWord[14] = 1;

			 	if(destVal == 0)
					ProcessorStatusWord[13] = 1;			 	
			 
			// SUB
			 3: {ProcessorStatusWord[15],destVal} = val1 - val2;
			 	
			 	if(val1[15] != val2[15] && destVal[15] != val1[15])
			 		ProcessorStatusWord[14] = 1;

			 	if(destVal == 0)
					ProcessorStatusWord[13] = 1;
			 
			// MUL
			 4: {ProcessorStatusWord[15],destVal} = val1 * val2;
			 	
				// To do: Detect overflow/underflow			 	

			 	if(destVal == 0)
					ProcessorStatusWord[13] = 1;	

			// SL
			 5: {ProcessorStatusWord[15],destVal} = val1 << val2;
			 
			// SR
			 6: {ProcessorStatusWord[15],destVal} = val1 >> val2;
			 
			// AND
			 7: destVal = val1 & val2;
			 
			// OR
			 8: destVal = val1 | val2;
			 
			// NOT
			 9: // ignores val2
			 	destVal = ~val1;
			
			// XOR
			10: destVal = val1 ^ val2;
			
			// Free instruction
			11: // Doing nothing
			
			// Free instruction
			12: // Doing nothing
			
			// Free instruction
			13: // Doing nothing
			
			// LOAD
			14: memAddrLoadStore = memAddr;

			
			// STORE
			15:
			
			
			default: $display("Failure in execute unit!");
		endcase
	end

endmodule