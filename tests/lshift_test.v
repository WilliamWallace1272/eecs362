module lshift_test();
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] result;

    shift_left LSHIFT (
        .a(A),
        .b(B[4:0]),
        .result(result));

    initial begin
        $monitor("A=%x, B=%x, result=%x", A, B, result);
        #0 A=32'h10000000; B=32'h00000001; 
        #1 A=32'hf0000001; B=32'h00000001; 
        #1 A=32'hf0000030; B=32'h00000010; 
        #1 A=32'hf0ffffff; B=32'h00000011; 
        #1 A=32'hf0ffffff; B=32'hf0000011; 
        #1 A=32'h000ff000; B=32'hf0000015; 
        #1 A=32'hbeef0000; B=32'h00dead03; 
    end
endmodule
