/*
	Module written by Rahul Kejriwal
	CS14B023

	TestBench for the Processor
*/

`include "Code/processor.v"

module processor_TestBench(
		output clk,
		output rst,

		input[7:0] instr_addr,
		output[15:0] instr,

		input[ 7:0] memAddrLoadStore,
		input[15:0] memStoreVal,
		output[ 15:0] memLoadVal,

		output valueReady,
		input readReq,
		input writeReq,

		input powerdown
	);

	reg clk, rst, valueReady;
	reg[15:0] instr, memLoadVal;

	// Memory contents
	reg[15:0] memory[0:255];

	integer i;

	Processor P(clk, rst, instr_addr, instr,
		memAddrLoadStore, memStoreVal, memLoadVal,
		valueReady, readReq, writeReq, 
		powerdown);

	always begin
		#2 clk = ~clk;
	end

	initial begin
		$dumpfile("processor.vcd");
    	$dumpvars(0,processor_TestBench);
		$monitor($time,, "Memlocval: %d", memory[130]);

		clk = 0;
		rst = 0;
		valueReady = 0;

		// Not in use at start
		instr = 0;
		memLoadVal = 0;
	
		// Initialize memory
		for(i=0;i<255;i++)
			memory[i] = 0;

		// Define memory mapping here
		memory[0] = 16'b0000000000000000;
		memory[1] = 16'b1110100000000001;
		memory[2] = 16'b1110100000010010;
		memory[3] = 16'b0010001100100001;
		memory[4] = 16'b1111100000100011;
		memory[5] = 16'b1110100000000100;
		memory[6] = 16'b1110100000010101;
		memory[7] = 16'b0011011001000101;
		memory[8] = 16'b1111100000100110;
		memory[9] = 16'b1110100000000111;
		memory[10] = 16'b1110100000011000;
		memory[11] = 16'b0100100101111000;
		memory[12] = 16'b1111100000101001;
		memory[13] = 16'b0101100101111000;
		memory[14] = 16'b1111100000101001;
		memory[15] = 16'b0110100101111000;
		memory[16] = 16'b1111100000101001;
		memory[17] = 16'b0111100101111000;
		memory[18] = 16'b1111100000101001;
		memory[19] = 16'b1000100101111000;
		memory[20] = 16'b1111100000101001;
		memory[21] = 16'b1001100101111000;
		memory[22] = 16'b1111100000101001;
		memory[23] = 16'b1010100101111000;
		memory[24] = 16'b1111100000101001;
		memory[25] = 16'b0010001100010001;
		memory[26] = 16'b0010010000110011;
		memory[27] = 16'b1111100000100100;
		memory[28] = 16'b1110100000100001;
		memory[29] = 16'b1111100000100001;
		memory[30] = 16'b1010000100010001;
		memory[31] = 16'b1111100000100001;
		memory[32] = 16'b1110100000100001;
		memory[33] = 16'b0001000000000000;
	
		memory[128] = 1;
		memory[129] = 2;
	end

	always @(instr_addr) begin
		instr = memory[instr_addr];
	
		if(instr_addr == 33)
			$finish;
	end

	always @(posedge readReq) begin
		valueReady = 0;
		memLoadVal = memory[memAddrLoadStore];
		valueReady = 1;
	end

	always @(posedge writeReq) begin
		$display("Writing %d to %d", memStoreVal, memAddrLoadStore);
		memory[memAddrLoadStore] = memStoreVal;
	end

	always @(posedge powerdown) begin
		$finish;
	end

endmodule
