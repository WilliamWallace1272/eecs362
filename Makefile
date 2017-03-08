adder_test:
	iverilog adder.v tests/adder_test.v -o run_adder;

alu_test:
	iverilog adder.v alu.v tests/alu_test.v -o run_alu;

lshift_test:
	iverilog adder.v alu.v tests/lshift_test.v -o run_lshift;

rshift_test:
	iverilog adder.v alu.v tests/rshift_test.v -o run_rshift;

mult_test:
	iverilog mult.v tests/mult_test.v -o run_mult;

datapath_test:
	iverilog datapath.v adder.v mult.v alu.v control.v inst_fetch.v reg_file.v tests/datapath_test.v -o run_datapath;

ID:
	iverilog ID.v control.v reg_file.v adder.v

EX:
	iverilog EX.v mult.v alu.v adder.v

MEM: 
	iverilog MEM.v alu.v adder.v

WB:
	iverilog WB.v

IF:
	iverilog IF.v adder.v

pipeline:
	iverilog alu.v ID.v mult.v EX.v MEM.v WB.v IF.v control.v reg_file.v adder.v -o pipeline

pipeline_test:
	iverilog mult.v pipeline_datapath.v alu.v ID.v EX.v MEM.v WB.v IF.v control.v reg_file.v adder.v tests/pipeline_test.v -o run_pipeline
clean:
	rm -f run* a.out;
