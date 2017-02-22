module mult_test();
    reg [31:0] A;
    reg [31:0] B;  
    wire [63:0] result;
    reg sign;
    reg clk;

    booth_mult MULT_32 (
        .p(result),
        .a(A),
        .b(B),
        .clk(clk),
        .sign(sign));

integer i; reg[63:0] answer; 

    initial begin
        $monitor("A=%x, B=%x, sign = %b, result=%x", A, B,sign, result);
        #0 A=$random%32; B=$random%32; clk = 0; sign = 1;
        for(i = 0; i < 3; i=i+1)
        begin
            #8 answer = $signed(A)*$signed(B);
               if (result != answer) $display("ERROR result should be %x, is %x", answer, result);
            #0 A=$random%32; B=$random%32;
        end
        #10 sign = 0;
        for(i = 0; i < 3; i=i+1)
        begin
            #8 answer = A*B;
               if (result != answer) $display("ERROR result should be %x, is %x", answer, result);
            #0 A=$random%32; B=$random%32;
        end
    end

    always
        #1 clk = ~clk;
endmodule
