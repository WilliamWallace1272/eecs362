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



module inst_fetch (input branch, input jump, input zero, output instruction, input clk);
    parameter SIZE=4096;

    reg [0:31] pc;
    wire [0: 31] instr, jmp_target, pc_plus_four, sign_ext, br_target, pc_next, pc_or_br;

    imem #(.SIZE(SIZE)) IMEM(.addr(pc), .instr(instr));
    assign jmp_target = {pc[0:4], instr[0:25], 2'b00};
    adder_n ADDER_PLUS_FOUR (.A(pc), .B(32'h4), .cin(1'b0), .Sum(pc_plus_four));
//    assign pc_plus_four = pc + 4;
    assign sign_ext = {{14{instr[0]}}, instr[0:15], 2'b00};
    adder_n ADDER_BR_TARGET (.A(pc_plus_four), .B(sign_ext), .cin(1'b0), .Sum(br_target));
//    assign br_target = pc_plus_four + sign_ext;
    assign pc_or_br = (branch && zero) ? br_target : pc_plus_four;
    assign pc_next  = jump ? jmp_target : pc_or_br;
    
    always @ (posedge clk)
    begin
        pc <= pc_next;
    end

    assign instruction = instr;
endmodule

    
