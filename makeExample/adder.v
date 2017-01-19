module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) ^ (cin & (a ^ b));
endmodule // fa

// Simple n-bit ripple-carry adder
module adder_n(A, B, cin, Sum, cout);
    parameter BITS=32;
    input [0:(BITS-1)] A, B;
    input cin;
    output [0:(BITS-1)] Sum;
    output cout;

    // Carry will need WIDTH+1 bits total
    wire [0:(BITS)] carry;

    // Generate WIDTH full adders and wire them appropriately
    genvar i;
    generate
        for (i=0; i<BITS; i=i+1) begin: ADDER_LOOP
            // Carry-out of previous wired to carry-in of next
            // (MSB is 0, LSB is 31, carry[31] feeds cin[30])
            // This is an endianness issue.
            full_adder FA (
                .a(A[i]),
                .b(B[i]),
                .cin(carry[i+1]),
                .sum(Sum[i]),
                .cout(carry[i]));
        end
    endgenerate
    // cin & cout wiring
    assign cout = carry[0];
    assign carry[BITS] = cin;
endmodule
