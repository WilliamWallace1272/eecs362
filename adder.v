module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) ^ (cin & (a ^ b));
endmodule 

module adder_n(A, B, cin, Sum, cout);
    parameter BITS=32;
    input [0:(BITS-1)] A, B;
    input cin;
    output [0:(BITS-1)] Sum;
    output cout;

    wire [0:(BITS)] carry;

    genvar i;
    generate
        for (i=0; i<BITS; i=i+1) begin: ADDER_LOOP
            full_adder ADDER_i (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i+1]),
                .sum(Sum[i]),
                .cout(carry[i]));
        end
    endgenerate

    assign cout = carry[0];
    assign carry[BITS] = cin;
endmodule
