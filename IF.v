`timescale 1ns/1ps

module imem(addr, instr);
    parameter SIZE=1; //8192
    parameter OFFSET=0;

    input [0:31] addr;
    output [0:31] instr;
    reg [0:7] mem[0:(SIZE-1)];

    wire [0:31] phys_addr;

    assign phys_addr = addr - OFFSET;
    assign instr = {mem[phys_addr],mem[phys_addr+1],mem[phys_addr+2],mem[phys_addr+3]};
endmodule // imem



module i_fetch (input clk, input reg_lock, input [0:31] target , input jump_or_branch, input reg_lock_mult, output [0:31] instr, output [0:31] pc_plus_four);

    wire [0:31] instruction, plus_four, pc_next;

    reg [0:31] pc;

    imem IMEM(.addr(pc), .instr(instruction));


    adder_n ADDER_PLUS_FOUR (.A(pc), .B(32'h4), .cin(1'b0), .Sum(plus_four));
    
    assign pc_next  = jump_or_branch ? target : plus_four;
   
    reg [0:31] instr, pc_plus_four;
    always @ (posedge clk )
    begin
        if (!reg_lock && !reg_lock_mult)
        begin
            instr <= instruction;
            pc <= pc_next;
            pc_plus_four <= plus_four;
        end
    end

endmodule

    
