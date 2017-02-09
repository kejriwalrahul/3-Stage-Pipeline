all: Code/processor.v Code/fetch.v Code/decoder.v Code/regfile.v Code/execute.v
	mkdir -p bin
	iverilog Code/processor.v -o bin/processor.out

clean:
	rm -f bin/* 
	rm -r bin