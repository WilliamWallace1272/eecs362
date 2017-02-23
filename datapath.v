`timescale 1ns/1ps

module datapath (input clk, output instruction);

    wire [0:31] instr;
    assign instruction = instr;

    wire branch, jump, zero;
    wire regwr, regdst, extop, alusrc, memwr, memtoreg;
    wire [0:5]  rs, rt, rd, rw;
    wire [0:31] busA, busB, busW;
    wire [0:31] imm_ext, b_or_imm, alu_out, mem_out;

    inst_fetch INST_FETCH(.branch(branch), .jump(jump), .zero(zero), .instruction(instr), .clk(clk));
    reg_file REG_FILE(.clk(clk), .we(regwr), .wrAddr(rw), .wrData(busW), .rdAddrA(rs), 
                      .rdDataA(busA), .rdAddrB(rt), .rdDataB(busB));
    alu ALU(.A(busA), .B(b_or_imm), .func(alu_ctrl), .result(alu_out));
    dmem DMEM(.addr(alu_out), .rData(mem_out), .wData(busB), .writeEnable(memwr), .dsize(data_size), .clk(clk));

endmodule
