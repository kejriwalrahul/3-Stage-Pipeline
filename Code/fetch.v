/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module to fetch instructions
*/

module fetchInstruction(
		input clk,
		input rst,

		output[7:0] prog_ctr,
		input[15:0] instr,

		output[15:0] curr_instr
	);

	// Program Counter
	reg[ 7:0] prog_ctr;
	// Instruction Register
	reg[15:0] curr_instr;

	initial begin
 		prog_ctr	= 8'b0;
 		curr_instr	= 16'b0;		
	end

 	always @(posedge rst) begin
 		prog_ctr	= 8'b0;
 		curr_instr	= 16'b0;
 	end

 	always @(posedge clk) begin
	 	curr_instr = instr;
 		prog_ctr += 1;
 	end
endmodule