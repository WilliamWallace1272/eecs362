`timescale 1ns/1ps

module imem(addr, instr);
    parameter SIZE=4096;
    parameter OFFSET=0;

    input [0:31] addr;
    output [0:31] instr;
    reg [0:7] mem[0:(SIZE-1)];

    wire [0:31] phys_addr;

    assign phys_addr = addr - OFFSET;
    assign instr = {mem[phys_addr],mem[phys_addr+1],mem[phys_addr+2],mem[phys_addr+3]};
endmodule // imem



module i_fetch (input clk, input [0:31] target , input jump_or_branch, output [0:31] instr, output [0:31] pc_plus_four);
    parameter SIZE=4096;

    imem #(.SIZE(8192)) IMEM(.addr(pc), .instr(instr));


    adder_n ADDER_PLUS_FOUR (.A(pc), .B(32'h4), .cin(1'b0), .Sum(pc_plus_four));
    
    assign pc_next  = jump_or_branch ? target : pc_plus_four;
   
    reg [0:31] pc;
    always @ (posedge clk)
    begin
        pc <= pc_next;
    end

endmodule

    
