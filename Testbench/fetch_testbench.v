/*
	Module written by Rahul Kejriwal
	CS14B023

	Fetch unit test bench
*/

`include "../Code/fetch.v"

module fetch_TestBench(
		output clk,
		output rst,

		input[7:0] instr_addr,
		output[15:0] instr,

		input[15:0] curr_instr
	);

	reg clk, rst;
	reg[15:0] instr;

	fetchInstruction I(clk, rst, instr_addr, instr, curr_instr);

	always begin
		#1 clk = ~clk;
	end

	initial begin
		$dumpfile("fetch.vcd");
    	$dumpvars(0,fetch_TestBench);

		clk = 0;
		rst = 0;
		instr = 0;
	
		$monitor($time,, "clk: %b, Address: %b, IR: %b, ISent: %b", clk, instr_addr, curr_instr, instr);
		#550 $finish;
	end

	always @(instr_addr) begin
		instr = instr_addr << 8 | instr_addr ^ 8'b11111111;
	end 
endmodule