
`timescale 1ns/100ps

/*typedef enum logic [5:0] {
  ALU_SLL       = 6'h04,
  ALU_SRL       = 6'h06,
  ALU_SRA       = 6'h07,
  ALU_NOP       = 6'h15,
  ALU_ADD       = 6'h20,
  ALU_ADDU      = 6'h21,
  ALU_SUB       = 6'h22,
  ALU_SUBU      = 6'h23,
  ALU_AND       = 6'h24,
  ALU_OR        = 6'h25,
  ALU_XOR       = 6'h26,
  ALU_SEQ       = 6'h28,
  ALU_SNE       = 6'h29,
  ALU_SLT       = 6'h2a,
  ALU_SGT       = 6'h2b,
  ALU_SLE       = 6'h2c,
  ALU_SGE       = 6'h2d,
  MOVFP2I       = 6'h34,
  MOVI2FP       = 6'h35
} ALU_FUNC;*/

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






