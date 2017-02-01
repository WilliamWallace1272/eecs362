//`timescale 1 ns / 10 ps

module alu_test();
    reg [0:31] A;
    reg [0:31] B, zero, one;
    reg [0:5] func;
    
    wire [0:31] result;
  
    reg [0:31] answer;
    alu ALU_32(
        .A(A),
        .B(B),
        .func(func),
        .result(result));

    initial begin
               
        $monitor("A=%x, B=%x,func=%x, result=%x", A, B, func,result);
        #0 A=$random %32; B=$random %32; zero = 32'h00000000; one = 32'h00000001;func=6'h04;
        #1 answer = A<<B[27:31]; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h06;
        #1 answer = A>>B[27:31]; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        
        #1 func = 6'h06;
        #1 answer = A>>B[27:31]; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h15;
        #1 answer = 32'h00000000; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h20;
        #1 answer = A+B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h21;
        #1 answer = A+B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h22;
        #1 answer = A-B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
    
        #1 func = 6'h23;
        #1 answer = A-B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h24;
        #1 answer = A&B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h25;
        #1 answer = A|B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h26;
        #1 answer = A^B; if (result != answer) $display("ERROR result should be %x is %x",answer, result);

        #1 func = 6'h28;
        #1 answer = (A==B ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h29;
        #1 answer = (A!=B ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h2a;
        #1 answer = ($signed(A)<$signed(B) ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);

        #1 func = 6'h2b;
        #1 answer = ($signed(A)>$signed(B) ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);
        #1 func = 6'h2c;
        #1 answer = ($signed(A)<=$signed(B) ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);

        #1 func = 6'h2d;
        #1 answer = ($signed(A)>=$signed(B) ? one : zero); if (result != answer) $display("ERROR result should be %x is %x",answer, result);
    end
endmodule
