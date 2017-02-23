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




clean:
	rm -f run* a.out;
