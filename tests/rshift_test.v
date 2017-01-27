module rshift_test();
    reg [31:0] A;
    reg [31:0] B;
    reg arithmetic;
    wire [31:0] result;

    shift_right RSHIFT (
        .a(A),
        .b(B[4:0]),
        .arithmetic(arithmetic),
        .result(result));

    initial begin
        $monitor("A=%x, B=%x, arithmetic=%b, result=%x", A, B, arithmetic, result);
        #0 A=32'h10000000; B=32'h00000001; arithmetic=1'b0;
        #1 A=32'hf0000001; B=32'h00000001; arithmetic=1'b0;
        #1 A=32'hf0000030; B=32'h00000010; arithmetic=1'b1;
        #1 A=32'hf0ffffff; B=32'h00000011; arithmetic=1'b1;
        #1 A=32'hf0ffffff; B=32'hf0000011; arithmetic=1'b0;
        #1 A=32'h000ff000; B=32'hf0000015; arithmetic=1'b1;
        #1 A=32'hbeef0000; B=32'h00dead03; arithmetic=1'b1;
    end
endmodule
