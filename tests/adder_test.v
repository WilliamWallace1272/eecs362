`timescale 1 ns / 10 ps

module adder_test();
    reg [0:31] A;
    reg [0:31] B;
    reg cin;
    wire [0:31] Sum;
    wire cout;

    adder_n #(.BITS(32)) ADDER_32 (
        .A(A),
        .B(B),
        .cin(cin),
        .Sum(Sum),
        .cout(cout));

    initial begin
        $monitor("A=%x, B=%x, cin=%b, Sum=%x, cout=%b", A, B, cin, Sum, cout);
        #0 A=32'h00000000; B=32'h00000000; cin=1'b0;
        #1 A=32'h00000001; B=32'h00000001; cin=1'b0;
        #1 A=32'h00000010; B=32'h00000010; cin=1'b1;
        #1 A=32'hffffffff; B=32'h00000000; cin=1'b1;
        #1 A=32'h0fffffff; B=32'hf0000000; cin=1'b0;
        #1 A=32'h000ff000; B=32'hf0000000; cin=1'b1;
        #1 A=32'hbeef0000; B=32'h00dead00; cin=1'b1;
    end
endmodule
