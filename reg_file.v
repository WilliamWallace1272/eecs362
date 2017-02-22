`timescale 1ns / 1ps

module reg_file (input clk, input we, input [0:4] wrAddr, input [0:31] wrData,
                 input [0:4] rdAddrA, output [0:31] rdDataA, input [0:4] rdAddrB,
                 output [0:31] rdDataB);
    reg [0:31] regfile [0:31];

    assign rdDataA = regfile[rdAddrA];
    assign rdDataB = regfile[rdAddrB];

    always @(posedge clk) begin
        if (write)
        begin
            if (wrAddr == 32'h0) 
                regfile[wrAddr] <= 32'h0;
            else
                regfile[wrAddr] <= wrData;
        end
    end
endmodule
