/*
	Module written by Rahul Kejriwal
	CS14B023

	Synchronous module to fetch instructions
*/

module fetchInstruction(
		input clk,
		input rst,

		output[7:0] instr_addr,
		input[15:0] instr,

		output[15:0] curr_instr
	);

	reg[ 7:0] instr_addr;

	// Insturction Register
	reg[15:0] instr;
	// Program Counter
	reg[ 7:0] prog_ctr;


	initial begin
 		instr_addr 	= 8'b0;
 		prog_ctr	= 8'b0;
 		instr 		= 16'b0;		
	end

 	always @(posedge rst) begin
 		instr_addr 	= 8'b0;
 		prog_ctr	= 8'b0;
 		instr 		= 16'b0;
 	end

endmodule