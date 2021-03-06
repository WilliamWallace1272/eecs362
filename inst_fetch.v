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



module inst_fetch (input branch, input jump, input zero, output [0:31] instruction, 
                   input clk, output [0:31] pc_plus_four, input [0:31] reg_jmp);
    parameter SIZE=4096;

    reg [0:31] pc;
    wire [0: 31] instr, jmp_target, pc_plus_four, sign_ext, br_target, pc_next, pc_or_br, norm_jmp;

    imem #(.SIZE(8192)) IMEM(.addr(pc), .instr(instr));

    adder_n ADDER_JMP_TARGET (.A(pc_plus_four), .B({{6{instr[6]}}, instr[6:31]}), .cin(1'b0), .Sum(norm_jmp));
    assign jmp_target = (instr[0:4] == 5'b01001) ? reg_jmp : norm_jmp;


    adder_n ADDER_PLUS_FOUR (.A(pc), .B(32'h4), .cin(1'b0), .Sum(pc_plus_four));
//    assign pc_plus_four = pc + 4;
    assign sign_ext = {{16{instr[16]}}, instr[16:31]};
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

    
