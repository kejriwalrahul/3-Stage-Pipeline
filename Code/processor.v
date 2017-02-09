/*
	Module written by Rahul Kejriwal
	CS14B023

	Top Level Module for the Processor
*/

module Processor(
		input clk,
		input rst,

		output[7:0] instr_addr,
		input[15:0] instr,

		output[ 7:0] memAddrLoadStore,
		output[15:0] memStoreVal,
		input[ 15:0] memLoadVal
	);
	
	reg[15:0] PSW;

	// Fetch Unit	
	fetchInstruction(clk, rst, instr_addr, instr, curr_instr);	
	
	// Decode Unit
	decodeAndFetchOperands(clk, rst,
		curr_instr, 
		srcRegVal1, srcRegVal2, inuse1, inuse2,
		srcReg1, srcReg2, nextDestReg,
		opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2);
	
	// Register File
	RegisterFile(clk, rst
		srcReg1, srcReg2, nextDestReg,
		destRegStore, destVal,
		srcRegVal1, srcRegVal2, inuse1, inuse2);
	
	//Execute Unit
	executeAndStoreBack(clk, rst
		opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2,
		destRegStore, destVal, memAddrLoadStore, memStoreVal, memLoadVal, pswWire);

	initial begin
		PSW = 16'b0;
	end

	always @(rst) begin
		PSW = 16'b0;
	end

	always @(posedge clk) begin
		PSW = pswWire;
	end
endmodule