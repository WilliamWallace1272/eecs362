`timescale 1ns/100ps

module alu(A, B, func, result);
    input [0:31] A, B;
    input [0:5] func;
    output [0:31] result;

    reg  arithmetic, carry_in;
    reg [0:31] adder_B, out;
    wire [0:31] lshift, rshift, adder_result;
    wire carry_out;

    shift_left SHIFTL (.a(A), .b(B[27:31]), .result(lshift));
    shift_right SHIFTR (.a(A), .b(B[27:31]), .arithmetic(arithmetic), .result(rshift));
    adder_n ADDER (.A(A), .B(adder_B), .cin(carry_in), .Sum(adder_result), .cout(carry_out));

    always @* begin
        case (func)
            6'h04: //SLL
                out = lshift;
            6'h06: //SRL
                begin
                    arithmetic = 0;
                    out = rshift;
                end
            6'h07: //SRA
                begin
                    arithmetic = 1;
                    out = rshift;
                end
            6'h15: //NOP
                out = 32'h00000000;
            6'h16: //lhi
                out = B;
            6'h20: //ADD
                begin
                    carry_in = 0;
                    adder_B = B;
                    out = adder_result;
                end
            6'h21: //ADDU
                begin
                    carry_in = 0;
                    adder_B = B;
                    out = adder_result;
                end
            6'h22: //SUB
                begin
                    carry_in = 1;
                    adder_B = ~B;
                    out = adder_result;
                end
            6'h23: //SUBU
                begin
                    carry_in = 1;
                    adder_B = ~B;
                    out = adder_result;
                end
            6'h24: //AND
                out = A & B;
            6'h25: //OR
                out = A | B;
            6'h26: //XOR
                out = A ^ B;
            6'h28: //SEQ
                if ((A ^ B) == 32'h00000000)
                    out = 32'h00000001;
                else
                        out = 32'h00000000;
            6'h29: //SNE
                if ((A ^ B) == 32'h00000000)
                    out = 32'h00000000;
                else
                    out = 32'h00000001;
            6'h2a: //SLT
                begin 
                    carry_in = 1;
                    adder_B = ~B;
                    if(adder_result[0])
                        out = 32'h00000001;
                    else
                        out = 32'h00000000;
                end
            6'h2b: //SGT
                begin
                    carry_in = 1;
                    adder_B = ~B;
                    if(~adder_result[0] && (| adder_result))
                        out = 32'h00000001;
                    else
                        out = 32'h00000000;
                end
            6'h2c: //SLE
                begin
                    carry_in = 1;
                    adder_B = ~B;
                    if((adder_result[0]) | ((A ^ B) == 32'h00000000))
                        out = 32'h00000001;
                    else
                        out = 32'h00000000;
                end
            6'h2d: //SGE
                begin
                    carry_in = 1;
                    adder_B = ~B;
                    if((~adder_result[0]) | ((A ^ B) == 32'h00000000))
                        out = 32'h00000001;
                    else
                        out = 32'h00000000;
                end
            6'h34: //MOVFP2I
                out = A;
            6'h35: //MOVI2FP
                out = A;
            default: 
                out = 32'h00000000;
        endcase
    end

    assign result = out;
endmodule

module shift_right (a, b, arithmetic, result);
    input [31:0] a;
    input [4:0] b;
    input arithmetic;
    output [31:0] result;
    
    reg [31:0] s0, s1, s2, s3, s4;
    reg shift_in;

    always @* begin
        shift_in = arithmetic && a[31];
    
        if (b[0])
            begin
                s0[30:0] = a[31:1];
                s0[31] = shift_in;
            end
        else
            s0 = a;

        if (b[1])
            begin
                s1[29:0] = s0[31:2];
                s1[30] = shift_in;
                s1[31] = shift_in;
            end
        else
            s1 = s0;

        if (b[2])
            begin
                s2[27:0] = s1[31:4];
                begin : SHIFT1
                    integer i;
                    for (i = 28; i < 32; i=i+1)
                        s1[i] = shift_in;
                end
            end
        else
            s2 = s1;
    
        if (b[3])
            begin
                s3[23:0] = s2[31:8];
                begin : SHIFT2
                    integer i;
                    for (i = 24; i < 32; i=i+1) 
                        s3[i] = shift_in;
                end
            end
        else
            s3 = s2;

        if (b[4])
            begin
                s4[15:0] = s3[31:16];
                begin : SHIFT3
                    integer i;
                    for (i = 16; i < 32; i=i+1)
                        s4[i] = shift_in;
                end
            end
        else
            s4 = s3;
    end
    
    assign result = s4;
endmodule


module shift_left (a, b, result);
    input [31:0] a;
    input [4:0] b;
    output [31:0] result;

    reg [31:0] s0, s1, s2, s3, s4;
    reg shift_in;

    always @* begin
        shift_in = 'b0;

        if (b[0])
            begin
                s0[31:1] = a[30:0];
                s0[0] = shift_in;
            end
        else
            s0 = a;

        if (b[1])
            begin
                s1[31:2] = s0[29:0];
                s1[0] = shift_in;
                s1[1] = shift_in;
            end
        else
            s1 = s0;

        if (b[2])
            begin
                s2[31:4] = s1[27:0];
                begin : SHIFT1
                    integer i;
                    for (i = 0; i < 4; i=i+1)
                        s1[i] = shift_in;
                end
            end
        else
            s2 = s1;

        if (b[3])
            begin
                s3[31:8] = s2[23:0];
                begin : SHIFT2
                    integer i;
                    for (i = 0; i < 8; i=i+1)
                        s3[i] = shift_in;
                end
            end
        else
            s3 = s2;

        if (b[4])
            begin
                s4[31:16] = s3[15:0];
                    begin : SHIFT3
                    integer i;
                    for (i = 0; i < 16; i=i+1)
                        s4[i] = shift_in;
                end
            end
        else
            s4 = s3;
    end

    assign result = s4;
endmodule






