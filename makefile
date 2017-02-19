all: Code/processor.v Code/fetch.v Code/decoder.v Code/regfile.v Code/execute.v
	iverilog Code/processor_testbench.v
	./a.out

clean:
	rm -f a.out *.vcd