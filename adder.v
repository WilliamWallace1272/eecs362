module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) ^ (cin & (a ^ b));
endmodule 

module adder_n(A, B, cin, Sum, cout);
    parameter BITS=32;
    input [(BITS-1):0] A, B;
    input cin;
    output [(BITS-1):0] Sum;
    output cout;

    wire [(BITS):0] carry;

    genvar i;
    generate
        for (i=0; i<BITS; i=i+1) begin: ADDER_LOOP
            full_adder ADDER_i (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i]),
                .sum(Sum[i]),
                .cout(carry[i+1]));
        end
    endgenerate

    assign cout = carry[BITS];
    assign carry[0] = cin;
endmodule
