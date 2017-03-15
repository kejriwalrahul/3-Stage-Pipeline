/*
	Interface written by Rahul Kejriwal
	CS14B023 
*/

/*
	Issues:
		1. Clk ##1?
*/

interface DecoderChecker(
		logic clk, rst,

		// logic from Fetch Instruction unit
		logic[15:0] instr,

		// Ports from RegFile
		logic[15:0] srcRegVal1,
		logic[15:0] srcRegVal2,
		logic inuse1,
		logic inuse2,

		// Ports to Regfile
		logic[ 3:0] srcReg1,
		logic[ 3:0] srcReg2,
		logic[ 3:0] nextDestReg,

		// Ports to Execute unit
		logic[ 3:0] opcode,
		logic[ 3:0] destReg,
		logic[15:0] srcVal1,
		logic[15:0] srcVal2,
		logic[ 7:0] memAddr, 
		logic used1,
		logic used2  
	);
	
	/*
		Assert correct opcode is forwarded
	*/
	property P1;
		reg[15:0] old_instr;
		
		@(posedge clk) (1, old_instr = instr) ##1 opcode == old_instr[15:12]; 
	endproperty

	OpcodeForward:
		assert property(P1)
		else $display("Failure at OpcodeForward");


	/*
		Assert forwarding of fetched data for non-LOAD/STORE instructions 
	*/
	property P2;
		reg[3:0] new_dest_reg, new_src_reg_1, new_src_reg_2;
		
		@(posedge clk) (1, new_dest_reg  = instr[15:12], 
						   new_src_reg_1 = instr[7:4],
						   new_src_reg_2 = instr[3:0])
			##1 (	nextDestReg == new_dest_reg  and destReg == new_dest_reg 
					and srcReg1 == new_src_reg_1 and srcReg2 == new_src_reg_2
					and srcVal1 ==  /* Implementation Left*/
				)
	endproperty

	NonLoadStoreDecode:
		assert property(P2);
		else $display("Failure at NonLoadStoreDecode");


	/*
		Assert forwarding of fetched data for LOAD instructions
	*/
	property P3;
		reg[3:0] new_dest_reg;
		reg[7:0] new_mem_addr;
		
		@(posedge clk) (1, new_dest_reg = instr[ 3:0],
						   new_mem_addr = instr[11:4])
			##1 (	nextDestReg == new_dest_reg and destReg == new_dest_reg
					and memAddr == new_mem_addr
				)
	endproperty

	LoadDecode:
		assert property(P3);
		else $display("Failure at LoadDecode");


	/*
		Assert forwarding of fetched data for STORE instructions
	*/
	property P4;
		reg[3:0] new_src_reg_1;
		reg[7:0] new_mem_addr;

		@(posedge clk) (1, new_src_reg_1 = instr[ 3:0],
						   new_mem_addr  = instr[11:4])
			##1 (	srcReg1 == new_src_reg_1 and memAddr == new_mem_addr
					and srcVal1 == /*Implementation Left*/ and used1 == /*Implementation Left*/ 
				)
	endproperty

	StoreDecode:
		assert property(P4);
		else $display("Failure at StoreDecode");

endinterface

bind decode_TestBench DecoderChecker BoundDecoder(
	clk, rst, 
	instr, 
	srcRegVal1, srcRegVal2, inuse1, inuse2, 
	srcReg1, srcReg2, nextDestReg, 
	opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2  
);