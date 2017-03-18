// Code your testbench here
// or browse Examples
/*
	Module written by Debanjan Ghatak
	CS16S033

	Execution unit test bench
*/





module execute_TestBench(
		output clk,
		output rst,

		output[ 3:0] opcode,
		output[ 3:0] destReg,
		output[15:0] srcVal1,
		output[15:0] srcVal2,
		output[ 7:0] memAddr, 
		output used1,
		output used2,

		input[ 3:0] destRegStore,
		input[15:0] destVal,
		input storeNow,
		output storeDone,

		input[ 7:0] memAddrLoadStore,
		input[15:0] memValueStore,

		output[15:0] memValueLoad,
		output valueReady,
		input readReq,
		input writeReq,

		input[15:0] ProcessorStatusWord,
	
		input powerdown
	);

	reg clk, rst;
	reg[ 3:0] opcode;
 	reg[ 3:0] destReg;
	reg[15:0] srcVal1;
	reg[15:0] srcVal2;
	reg[ 7:0] memAddr;
	reg used1;
	reg used2, storeDone, valueReady;
	reg[15:0] memValueLoad;

	executeAndStoreBack E(clk, rst, opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2, destRegStore, destVal, storeNow, storeDone, memAddrLoadStore, memValueStore, memValueLoad, valueReady, readReq, writeReq, ProcessorStatusWord, powerdown);

	always begin
		#3 clk = ~clk;
	end

	initial begin
		$dumpfile("execute.vcd");
    	$dumpvars(0,execute_TestBench);

	clk=0;
	rst=0;

	$monitor($time,, "clk: %b, opcode: %b, destReg: %b, srcVal1: %b ,srcVal2: %b,memAddr: %b,used1: %b,used2:,destRegStore: %b,destVal: %b,storeNow: %b,storeDone: %b,memAddrLoadStore: %b,memValueStore: %b,memValueLoad: %b,valueReady: %b,readReq: %b, writeReq: %b,ProcessorStatusWord: %b,powerdown: %b", clk, opcode, destReg, srcVal1, srcVal2, memAddr, used1, used2, destRegStore, destVal, storeNow, storeDone, memAddrLoadStore, memValueStore, memValueLoad, valueReady, readReq, writeReq, ProcessorStatusWord, powerdown);

        #5
	opcode=2;
	srcVal1=24;
	srcVal2=30;
	destReg=12;
	used1=0;
	used2=0;

	#6
	//for generating carry during addition
	opcode=2;
	srcVal1=49152;
	srcVal2=65535;
	destReg=68;
	used1=0;
	used2=0;

	#6
	//for generating overflow during addition
	opcode=2;
	srcVal1=65535;
	srcVal2=32768;
	destReg=69;
	used1=0;
	used2=0;

	#6
	//for setting zero status flag bit
	opcode=2;
	srcVal1=0;
	srcVal2=0;
	destReg=70;
	used1=0;
	used2=0;
	
	#6
	opcode=3;
	srcVal1=25;
	srcVal2=9;
	destReg=13;
	used1=0;
	used2=0;

	#6
	//for generating carry during substraction
	opcode=3;
	srcVal1=32768;
	srcVal2=56;
	destReg=71;
	used1=0;
	used2=0;

	#6
	//for generating overflow during substraction
	opcode=3;
	srcVal1=32768;
	srcVal2=1;
	destReg=72;
	used1=0;
	used2=0;

	#6
	opcode=5;
	srcVal1=24;
	srcVal2=5;
	destReg=11;
	used1=0;
	used2=0;

	#6
	opcode=7;
	srcVal1=56;
	srcVal2=32;
	destReg=5;
	used1=0;
	used2=0;

	#6
	opcode=9;
	srcVal1=11;
	destReg=14;
	used1=0;
	used2=0;

	#6
	opcode=15;
	memAddr=180;
	srcVal1=45;
	used1=0;
	used2=0;

	#6
	opcode=2;
	srcVal1=15;
	srcVal2=14;
	destReg=2;
	used1=1;
	used2=1;

	#6
	opcode=8;
	srcVal1=11;
	srcVal2=21;
	destReg=31;
	used1=0;
	used2=0;

	#6
	opcode=9;
	srcVal1=10;
	used1=1;
	used2=1;

	#6
	opcode=10;
	srcVal1=101;
	srcVal2=32;
	destReg=67;
	used1=0;
	used2=0;

	//loading value
	#6
	opcode=14;
	memAddr=26;
	destReg=80;

	//storing value
	#6
	opcode=15;
	memAddr=45;
	srcVal1=789;
	
	#550 $finish;
       end
  /* we are assuming srcVal1 and srcVal2 are correctly copied to val1 and val2 */
property P1;
     reg[15:0] val1,val2;
     
     @(posedge clk) (1, val1=srcVal1, val2=srcVal2);
         
				
	endproperty

	Initialise:
  assert property(P1)
    
    else $display("Failure at initialisation");
  
    	property P2;
		
		
          @(posedge clk) (opcode == 4'b0010) |->
          
          ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 + executeAndStoreBack.val2 );
				
endproperty

	ADD_NO:
    assert property(P2)
      else $display("Failure at ADD without overflow");
  
property P3;
		
		
        @(posedge clk) (opcode == 4'b0010 and executeAndStoreBack.val1[15] == executeAndStoreBack.val2[15] && destVal[15] != executeAndStoreBack.val1[15]) |->
        
        ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 + executeAndStoreBack.val2 and ProcessorStatusWord[14] == 1);
				
endproperty

	ADD_O:
      assert property(P3)
      else $display("Failure at ADD with overflow");
  
      property P4;
		
		
        @(posedge clk) (opcode == 4'b0011) |->
          
        ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 - executeAndStoreBack.val2 );
				
endproperty

	SUB_NO:
        assert property(P4)
          else $display("Failure at SUB without overflow");
  
property P5;
		
		
  @(posedge clk) (opcode == 4'b0011 and executeAndStoreBack.val1[15] != executeAndStoreBack.val2[15] && destVal[15] != executeAndStoreBack.val1[15]) |->
        
  ##0 ({ProcessorStatusWord[15],destVal}== executeAndStoreBack.val1 - executeAndStoreBack.val2 and ProcessorStatusWord[14] == 1);
				
endproperty

	SUB_O:
          assert property(P5)
            else $display("Failure at SUB with overflow");
  
       property P6;
		
		
         @(posedge clk) (opcode == 4'b0100) |->
          
         ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 * executeAndStoreBack.val2 );
				
endproperty

	MUL:
            assert property(P6)
              else $display("Failure at MUL");
              
    property P7;
		
		
      @(posedge clk) (opcode == 4'b0101) |->
          
      ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 << executeAndStoreBack.val2 );
				
endproperty

	SL:
              assert property(P7)
                else $display("Failure at SL");   
                
   property P8;
		
		
     @(posedge clk) (opcode == 4'b0110) |->
          
     ##0 (	{ProcessorStatusWord[15],destVal} == executeAndStoreBack.val1 >> executeAndStoreBack.val2 );
				
endproperty

	SR:
                assert property(P8)
                  else $display("Failure at SR");   
                  
   property P9;
		
		
     @(posedge clk) (opcode == 4'b0111) |->
          
     ##0 ( destVal== (executeAndStoreBack.val1 & executeAndStoreBack.val2));
				
endproperty

	AND:
                  assert property(P9)
                    else $display("Failure at AND");  
                    
   property P10;
		
		
     @(posedge clk) (opcode == 4'b1000) |->
          
     ##0 ( destVal== (executeAndStoreBack.val1 | executeAndStoreBack.val2));
				
endproperty

	OR:
                    assert property(P10)
                      else $display("Failure at OR"); 
                      
   property P11;
		
		
     @(posedge clk) (opcode == 4'b1001) |->
          
     ##0 ( destVal== ~(executeAndStoreBack.val1));
				
endproperty

	NEG:
                      assert property(P11)
                        else $display("Failure at NEG"); 
                        
   property P12;
		
		
     @(posedge clk) (opcode == 4'b1010) |->
          
     ##0 ( destVal== (executeAndStoreBack.val1 ^ executeAndStoreBack.val2));
				
endproperty

	XOR:
                        assert property(P12)
                          else $display("Failure at XOR");  
                          
 	 property P13;	
		
       @(posedge clk) (opcode == 4'b1110) |->
          
       ##0 ( memAddrLoadStore == memAddr and readReq == 1'b1);
				
endproperty

	LOAD:
                          assert property(P13)
                        else $display("Failure at LOAD");  
        
         property P14;	
		
           @(posedge clk) (opcode == 4'b1111) |->
          
           ##0 ( memAddrLoadStore == memAddr and memValueStore == executeAndStoreBack.val1 and writeReq == 1);
				
endproperty

	STORE:
                            assert property(P14)
                              else $display("Failure at STORE");   
                          
    property P15;	
		
     @(posedge clk) (opcode != 4'b0000 and opcode != 4'b0001 and opcode != 4'b1110 and opcode != 4'b1111 ) |->
          
           ##0 ( destRegStore == destReg and storeNow == 1 and executeAndStoreBack.LastComputedValue == destVal);
				
                endproperty

	NON_LOAD_STORE:
                              assert property(P15)
                              else $display("Failure at NON_LOAD_STORE");                                          
        
                              
      property P16;	
		
           @(posedge clk) (opcode != 4'b0000 and opcode != 4'b0001 and opcode != 4'b1110 and opcode != 4'b1111 and {ProcessorStatusWord[15], destVal} == 0) |->
          
           ##0 (ProcessorStatusWord[13] == 1);
				
                endproperty

	NON_LOAD_STORE_if:
                                assert property(P16)
                                else $display("Failure at NON_LOAD_STORE_if"); 
                                
    property P17;	
		
      @(posedge valueReady)
          
      ##1 ( destVal == memValueLoad and readReq == 1 and destRegStore == destReg and storeNow == 1 and executeAndStoreBack.LastComputedValue == destVal);
      
     // ##1(executeAndStoreBack.LastComputedValue == destVal);
                endproperty

	VAL_READY:
                                  assert property(P17)
                                    else $display("Failure at VAL_READY");                                          
        
                              
      property P18;	
		
        @(posedge valueReady) (destVal == 0) |->
          
           ##0 (ProcessorStatusWord[13] == 1);
				
                endproperty

	VAL_READYIF:
                                    assert property(P18)
                                  else $display("Failure at VAL_READYIF"); 
                                
                       
endmodule
