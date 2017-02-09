/*
	Module written by Rahul Kejriwal
	CS14B023

	Top Level Module for the Processor
*/

`include "fetch.v"
`include "decoder.v"
`include "regfile.v"
`include "execute.v"

module Processor(
		input clk,
		input rst,

		output[7:0] instr_addr,
		input[15:0] instr,

		output[ 7:0] memAddrLoadStore,
		output[15:0] memStoreVal,
		input[ 15:0] memLoadVal,

		input valueReady,
		output readReq,

		output powerdown
	);
	
	reg[15:0] PSW;

	wire[15:0] curr_instr, srcRegVal1, srcRegVal2, srcVal1, srcVal2, destVal, pswWire;
	wire[ 3:0] srcReg1, srcReg2, opcode, destReg, nextDestReg, destRegStore;
	wire[ 7:0] memAddr;

	// Fetch Unit	
	fetchInstruction I(clk, rst, instr_addr, instr, curr_instr);	
	
	// Decode Unit
	decodeAndFetchOperands D(clk, rst, 
		curr_instr, 
		srcRegVal1, srcRegVal2, inuse1, inuse2,
		srcReg1, srcReg2, nextDestReg,
		opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2);
	
	// Register File
	RegisterFile R(clk, rst,
		srcReg1, srcReg2, nextDestReg,
		destRegStore, destVal, storeNow, storeDone,
		srcRegVal1, srcRegVal2, inuse1, inuse2);
	
	//Execute Unit
	executeAndStoreBack E(clk, rst,
		opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2,
		destRegStore, destVal, storeNow, storeDone,
		memAddrLoadStore, memStoreVal,
		memLoadVal, valueReady, readReq,
		pswWire, 
		powerdown);

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