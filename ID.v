`timescale 1ns / 1ps

module i_decode (input clk, input reg_lock, input [0:31] instruction,input we,input [0:4] WriteReg, input [0:31] WriteData, input [0:31] pc,output [0:8] ctrl_reg, output [0:5] alu_ctrl_reg,output [0:31] busA_reg,output [0:31] busB_reg, output [0:31] imm_ext_reg);
   // regwrite is from mem/wb register
    
   
   
   wire [0:8] ctrl_signals;
    wire [0:5] alu_ctrl;
    wire [0:4] rs,rt,rd,rw1,rw2;
    wire [0:31] busA1, busB1, imm_ext, instr;

    assign instruction = instr;
    control CONTROL(.op_code(instr[0:5]), .func_code(instr[26:31]), .ctrl_signals(ctrl_signals), .alu_ctrl(alu_ctrl));

    reg_file REG_FILE(.clk(clk), .we(RegWrite), .wrAddr(WriteReg),.wrData(WriteData), .rdAddrA(rs), 
                                .rdDataA(busA1), .rdAddrB(rt), .rdDataB(busB1));

    assign rs = instr[6:10];
    assign rt = instr[11:15];
    assign rd = instr[16:20];
    assign imm_ext = {{16{instruction[16] & ctrl_signals[7]}}, instruction[16:31]};
    
    //TODO : add jump/link/branch logic here


    reg [0:8] ctrl_reg;
    reg [0:5] alu_ctrl_reg;
    reg [0:31] busA_reg, busB_reg, imm_ext_reg;
    always @(posedge clk) begin
        if (!reg_lock)
        begin
            ctrl_reg <= ctrl_signals;
            alu_ctrl_reg <= alu_ctrl;
            busA_reg <= busA1; // pure A and B registers
            busB_reg <= busB1;
            imm_ext_reg <= imm_ext;
        end

    end

endmodule

