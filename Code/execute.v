/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module for execution and result storage 
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
		output storeNow,
		input storeDone,

		output[ 7:0] memAddrLoadStore,
		output[15:0] memValueStore,

		input[15:0] memValueLoad,
		input valueReady,
		output readReq,
		output writeReq,

		output[15:0] ProcessorStatusWord,
	
		output powerdown
	);

	reg[ 3:0] destRegStore;
	reg[ 7:0] memAddrLoadStore;
	reg[15:0] destVal, memValueStore;

	reg[15:0] LastComputedValue;
	reg[15:0] ProcessorStatusWord;

	reg readReq, storeNow, writeReq;
	reg[15:0] val1, val2;
	reg powerdown;

	initial begin
		destRegStore 		= 4'b0;
		memAddrLoadStore	= 8'b0;
		memValueStore		= 16'b0;
		destVal				= 16'b0;
		
		LastComputedValue   = 16'b0;
		ProcessorStatusWord = 16'b0;		
		
		readReq = 0;
		storeNow = 0;
		val1 = 16'b0;
		val2 = 16'b0;
		powerdown = 0;
	end

	always @(posedge rst) begin
		destRegStore 		= 4'b0;
		memAddrLoadStore	= 8'b0;
		memValueStore		= 16'b0;
		destVal		        = 16'b0;
		
		LastComputedValue   = 16'b0;
		ProcessorStatusWord = 16'b0;
		
		readReq = 0;
		storeNow = 0;
		val1 = 16'b0;
		val2 = 16'b0;
	end

	always @(posedge clk) begin
		// Write Sync Signal for register writes
		storeNow = 0;
		writeReq = 0;
		
		#1
		ProcessorStatusWord = 16'b0;

		// Checking if src1 was being computed
		#1 if(used1)
			val1 = LastComputedValue;
		else
			val1 = srcVal1;			

		// Checking if src2 was being computed
		if(used2)
			val2 = LastComputedValue;
		else
			val2 = srcVal2;			

		// Execute appropriate action for the opcode
		#0 case(opcode)
			// NOP
			 0: begin
			 		// Doing nothing
			 		$display("Doing nothing");
			 	end 

			// HLT
			 1: begin
			 		$display("HLTing");
			 		powerdown = 1;
			 	end

			// ADD
			 2: begin
			        {ProcessorStatusWord[15],destVal} = val1 + val2;
				 	
				    if(val1[15] == val2[15] && destVal[15] != val1[15])
			 			ProcessorStatusWord[14] = 1;
			 	end

			// SUB
			 3: begin
				 	{ProcessorStatusWord[15],destVal} = val1 - val2;
				 	
				    if(val1[15] != val2[15] && destVal[15] != val1[15])
				 		ProcessorStatusWord[14] = 1;
			 	end 
			 
			// MUL
			 4: begin
				 	{ProcessorStatusWord[15],destVal} = val1 * val2;
				 							 	
			 	end

			// SL
			 5: begin
				 	{ProcessorStatusWord[15],destVal} = val1 << val2;		 	
			 	end

			// SR
			 6: begin
			 		{ProcessorStatusWord[15],destVal} = val1 >> val2;
			 	end
			 
			// AND
			 7: begin
			 		destVal = val1 & val2;
			 	end

			// OR
			 8: begin
			 		destVal = val1 | val2;
			 	end
			 
			// NOT
			 9: begin
			 		// ignores val2
				 	destVal = ~val1;
				end
			
			// XOR
			10: begin
					destVal = val1 ^ val2;
				end

			// LOAD
			14: begin
					memAddrLoadStore = memAddr;
					readReq = 1'b1;
				end

			// STORE
			15: begin
					memAddrLoadStore = memAddr;
					memValueStore = val1;
					writeReq = 1;
				end

			default:begin
						$display("Failure in execute unit!");
						powerdown = 1;
					end
		endcase

		// Set register address to write to and send signal to write to reg file
		if(opcode >= 2 && opcode <= 10) begin
			destRegStore = destReg;
			storeNow = 1;

		 	if(destVal == 0)
				ProcessorStatusWord[13] = 1;	
			
			#1 LastComputedValue = destVal;
		end
	end

	// Sent signal to read mem location. Waiting for signal that value is ready.
	always @(posedge valueReady) begin
		readReq = 1'b0;
		destVal = memValueLoad;
		if(destVal == 0)
			ProcessorStatusWord[13] = 1;		

		destRegStore = destReg;
		storeNow = 1;			
		#1 LastComputedValue = destVal;
	end

endmodule
