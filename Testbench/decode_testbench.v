/*
	Module written by Bharat Sai
	CS13B005

	decoder file Test Bench
*/

`include "../Code/decoder.v"

module decode_TestBench(
		output clk,
		output rst,

		// output from Fetch Instruction unit
		output[15:0] instr,

		// output ports from RegFile
		output[15:0] srcRegVal1,
		output[15:0] srcRegVal2,
		output inuse1,
		output inuse2,

		// input ports to RegFile
		input[ 3:0] srcReg1,
		input[ 3:0] srcReg2,
		input[ 3:0] nextDestReg,

		// input ports to Execute unit
		input[ 3:0] opcode,
		input[ 3:0] destReg,
		input[15:0] srcVal1,
		input[15:0] srcVal2,
		input[ 7:0] memAddr, 
		input used1,
		input used2
	);

	reg clk, rst;
	reg[15:0] instr;

	reg[15:0] srcRegVal1;
	reg[15:0] srcRegVal2;
	reg inuse1;
	reg inuse2;
	
	decodeAndFetchOperands daf(clk, rst, 
		instr, 
		srcRegVal1, srcRegVal2, inuse1, inuse2, 
		srcReg1, srcReg2, nextDestReg, 
		opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2);

	initial begin
		srcRegVal1 = 0;
		srcRegVal2 = 0;
		inuse1 = 0;
		inuse2 = 0;
	end

	always begin
		#5 clk = ~clk;
	end

	initial begin
		$dumpfile("decode.vcd");
    	$dumpvars(0,decode_TestBench);

		clk = 2;
		rst = 0;
		instr = 0;
	
		$monitor($time,, "clk: %b, rst: %b, Instruction: %b, Opcode: %b, MemAddr: %b, srcReg1: %b, srcReg2: %b, srcRegVal1: %b, srcRegVal2: %b, inuse1: %d, inuse2: %d ", 
			clk, rst, instr, opcode, memAddr, srcReg1, srcReg2, srcRegVal1, srcRegVal2, inuse1, inuse2);
		
		// sample ins
		#5 
		instr = 16'b0010001100110001;                       
		srcRegVal1 = 40;
		srcRegVal2 = 50;
		inuse1 =0;
		inuse2=0;
		rst = 0;
		
		#10
		instr = 16'b0010001100111000;                    //changing op code.

		#10
		instr = 16'b0010001100101000;                    //changing dest reg.

		#10
		instr = 16'b0010100000101000;                    //changing srcReg1.

		#10
		instr = 16'b0100001000101000;                    //changing srcReg2. from next combos of above 4.

		#10
		instr = 16'b0100001000111100;

		#10
		instr = 16'b0100001100110100;

		#10
		instr = 16'b1100001100111100;

		#10
		instr = 16'b1100111111001100;

		#10
		instr = 16'b1110110011101100;

		#10
		instr = 16'b1100111011101100;

		#10
		instr = 16'b1110011001101100;
		
		#10
		instr = 16'b1110011111101000;

		#10
		instr = 16'b1111010111101010;

		#10
		instr = 16'b1101010101100010;

		#10
        srcRegVal1 = 50;

		#10
        srcRegVal2 = 80;

		#10
		rst = 1;

		#10
        inuse1 = 1;

		#10
		instr = 16'b0010100000101000;

		#10
        inuse2 = 1;

		#10
		instr = 16'b0100001000101000;

		#10
		rst = 1;

		#10					                   
		instr = 16'b1110011111101110;			//load 

		#10                                                         
		instr = 16'b1111011111101110;

		#10                                                         
		instr = 16'b1111011101101110;

		#10                                                         
		instr = 16'b1101111101101110;                                                      

		#10                                                     
		instr = 16'b1110011111101111;			//store

		#10                                                         
		instr = 16'b1111011111101111;

		#10                                                         
		instr = 16'b1111011101101111;
		
		#10                                                         
		instr = 16'b1110011111101111;

		#10
		rst = 1;
				
		#10 
		$finish;
	end

	/*
		System Verilog Assertions
		-------------------------

		Added by Rahul Kejriwal, CS14B023
	*/


	/*
		Assert correct opcode is forwarded
	*/
	property P1;		
		@(posedge clk) (!$rose(rst)) |-> opcode == instr[15:12]; 
	endproperty

	OpcodeForward:
		assert property(P1)
		else $display("Failure at OpcodeForward");

	/*
		Assert forwarding of fetched data for non-LOAD/STORE instructions 
	*/
	property P2;
		@(posedge clk) (!$rose(rst) and instr[15:12] != 4'b1110 and instr[15:12] != 4'b1111) |->
					   (nextDestReg == instr[11:8] and destReg == instr[11:8]  
					   and srcReg1 == instr[ 7:4] and srcReg2 == instr[ 3:0]);
	endproperty

	NonLoadStoreDecode:
		assert property(P2)
		else $display("Failure at NonLoadStoreDecode");

	/*
		Assert forwarding of fetched data for LOAD instructions
	*/
	property P3;
		@(posedge clk) (!$rose(rst) and instr[15:12] == 4'b1110) |->
					   (nextDestReg == instr[ 3:0] and destReg == instr[ 3:0]
					   and memAddr == instr[11:4]);
	endproperty

	LoadDecode:
		assert property(P3)
		else $display("Failure at LoadDecode");

	/*
		Assert forwarding of fetched data for STORE instructions
	*/
	property P4;
		@(posedge clk)  (!$rose(rst)) |->
						(instr[15:12] == 4'b1111) |->
						(srcReg1 == instr[ 3:0] and memAddr == instr[11:4]);
	endproperty

	StoreDecode:
		assert property(P4)
		else $display("Failure at StoreDecode");

	/*
		Assert forwarding of fetched data from Register File
	*/
	property P5;
		@(posedge clk) (!$rose(rst)) |->
					   (srcVal1 == srcRegVal1 and srcVal2 == srcRegVal2
					   and used1 == inuse1 and used2 == inuse2);
	endproperty

	RegFileDataForward:
		assert property(P5)
		else $display("Failure at RegFileDataForward");

	/*
		Assert reset properties
	*/
	property P6;
		@(posedge clk) $rose(rst) |-> (srcReg1 == 4'b0					
					and srcReg2 == 4'b0 	
					and nextDestReg == 4'b0 	
					and opcode	== 4'b0
					and destReg	== 4'b0
					and srcVal1 == 16'b0
					and srcVal2 == 16'b0
					and memAddr == 8'b0
					and used1	== 0
					and used2	== 0);
	endproperty

	ResetProperty:
		assert property(P6)
		else $display("Failure at ResetProperty");

endmodule
