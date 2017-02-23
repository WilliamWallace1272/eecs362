`timescale 1ns/1ps

module datapath (input clk, output [0:31] instruction);

    wire [0:31] instr;
    assign instruction = instr;

    wire branch, jump, zero;
    wire regwr, regdst, extop, alusrc, memwr, memtoreg, linkjmp;
    wire [0:1]  data_size;
    wire [0:5]  rs, rt, rd, rw1, rw2;
    wire [0:31] busA1, busA2, busB1, busB2, busW1, busW2;
    wire [0:31] imm_ext, b_or_imm, alu_out, mem_out;
    wire [0:5]  alu_ctrl;
    wire [0:8]  ctrl_signals;

    inst_fetch INST_FETCH(.branch(branch), .jump(jump), .zero(zero), .instruction(instr),
                          .clk(clk), .pc_plus_four(pc_plus_four), .reg_jmp(rs));
    reg_file REG_FILE(.clk(clk), .we(regwr), .wrAddr(rw1), .wrData(busW2), .rdAddrA(rs), 
                      .rdDataA(busA1), .rdAddrB(rt), .rdDataB(busB1));
    alu ALU(.A(busA2), .B(busB2), .func(alu_ctrl), .result(alu_out));
    dmem DMEM(.addr(alu_out), .rData(mem_out), .wData(busB2), .writeEnable(memwr), .dsize(data_size), .clk(clk));
    control CONTROL(.op_code(instr[0:5]), .func_code(instr[26:31]), .ctrl_signals(ctrl_signals), .alu_ctrl(alu_ctrl));

    assign regwr    = ctrl_signals[3];
    assign regdst   = ctrl_signals[0];
    assign extop    = ctrl_signals[7];
    assign alusrc   = ctrl_signals[1];
    assign memwr    = ctrl_signals[4];
    assign memtoreg = ctrl_signals[2];
    assign branch   = ctrl_signals[5];
    assign jump     = ctrl_signals[6];
    assign linkjmp  = ctrl_signals[8];

    assign zero = (instr[31] == (| busA1));
    assign imm_ext = {{16{instr[16] & extop}} , instr[16:31]};
    assign rw1 = regdst ? rd : rt;
    assign rw2 = linkjmp ? 6'b111111 : rw1;
    assign busA2 = linkjmp ? pc_plus_four : busA1;
    assign b_or_imm = alusrc ? imm_ext : busB1;
    assign busB2 = linkjmp ? 32'h00000004 : b_or_imm;
    assign busW1 = memtoreg ? mem_out : alu_out;
    assign data_size = instr[30:31];
    assign busW2 = memtoreg ?
                        instr[29] ?
                            instr[30] ?
                                busW1 //should actually load fp's which we're ignoring
                                : instr[31] ?
                                    {{16{1'b0}}, busW1[16:31]}
                                    : {{24{1'b0}}, busW1[24:31]}
                            : instr[30] ?
                                busW1
                                : instr[31] ?
                                    {{16{busW1[16]}}, busW1[16:31]}
                                    : {{24{busW1[24]}}, busW1[24:31]}
                        : busW1;                            


endmodule


module dmem(addr, rData, wData, writeEnable, dsize, clk);
    parameter SIZE=32768;

    input [0:31] addr, wData;
    input 	writeEnable, clk;
    input [0:1] dsize; // equivalent to bytes-1 ( 3=Word, 1=Halfword, 0=Byte)
    output [0:31] rData;
    reg [0:7] 	 mem[0:(SIZE-1)];

    // Write
    always @ (posedge clk) begin
        if (writeEnable) begin
            $display("writing to mem at %x val %x size %2d", addr, wData, dsize);
            case (dsize)
              2'b11: begin
                 // word
                 {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= wData[0:31];
              end
              2'b10: begin
                 // bad
                 $display("Invalid dsize: %x", dsize);
              end
              2'b01: begin
                 // halfword
                 {mem[addr], mem[addr+1]} <= wData[16:31];
              end
              2'b00: begin
                 // byte
                 mem[addr] <= wData[24:31];
              end
              default: $display("Invalid dsize: %x", dsize);
            endcase
        end
    end
    // Read
    assign rData = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
endmodule // dmem
