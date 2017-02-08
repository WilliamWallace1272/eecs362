module mult_test();
    reg [31:0] A;
    reg [31:0] B;  
    wire [63:0] result;

    booth_mult MULT_32 (
        .p(result),
        .x(A),
        .y(B));

integer i; reg[63:0] answer; 

    initial begin
//        $monitor("A=%x, B=%x, result=%x", A, B, result);
        #0 A=$random%32; B=$random%32;
        for(i = 0; i < 1000; i=i+1)
        begin
            #1 answer = $signed(A)*$signed(B);
               if (result != answer) $display("ERROR result should be %x, is %x", answer, result);
            #1 A=$random%32; B=$random%32;
        end
    end
endmodule
