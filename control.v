`timescale 1ns/100ps

module control(op_code, func_code, ctrl_signals, alu_ctrl);
    input [0:5] op_code;
    input [0:5] func_code;
    output [0:8] ctrl_signals; // 0 RegDst 1ALUSrc 2MemtoReg 3RegWrite 4MemWrite 5Branch 6Jump 7ExtOp 8JReg
    output [0:5] alu_ctrl;


    reg  temp_alu_ctrl, temp_ctrl_signals;
    reg [0:31] adder_B, out;
    wire [0:31] lshift, rshift, adder_result;
    wire carry_out;


    always @* begin
        case (op_code)
            6'h00:
                begin
                    temp_ctrl_signals = (func_code == 6'h15) ? 9'b000000000 : 9'b100100000;
                    temp_alu_ctrl = func_code;
                end
            6'h01:
                begin
                end
            6'h02: // j
                begin
                    temp_ctrl_signals = 9'b000000100; // dcs here if wondering 
                    temp_alu_ctrl = 6'b000000;
                end
            6'h03: //jal
                begin 
                    temp_ctrl_signals = 9'b000100101;
                    temp_alu_ctrl = 6'h20;
                end
            6'h04, 6'h05:
                begin 
                    temp_ctrl_signals = 9'b000001000;
                    temp_alu_ctrl = 6'b000000;
                end
            6'h09, 6'h0b,6'h0c,6'h0d,6'h0e: // immediate add/sub and logicals not unsigned
                begin 
                    temp_ctrl_signals = 9'b010100000;
                    temp_alu_ctrl = op_code + 6'h18; // translation of opcode to the right function code 
                end
            6'h08, 6'h0a:// signed immediate add and sub
                begin
                    temp_ctrl_signals = 9'b010100010;
                    temp_alu_ctrl = op_code + 6'h18;
                end
            6'h0f:// lhi
                begin 
                    temp_ctrl_signals = 9'b010100000;
                    temp_alu_ctrl = 6'h16;
                end
            6'h12://jr
                begin 
                    temp_ctrl_signals = 9'b000000100;
                    temp_alu_ctrl = 6'h00;
                end
            6'h13: //jalr
                begin
                    temp_ctrl_signals = 9'b000000101;
                    temp_alu_ctrl = 6'h00;
                end
            6'h14, 6'h16, 6'h17, 6'h18, 6'h19, 6'h1a, 6'h1b,6'h1c,6'h1d:// set instructions w/immediates 
                begin 
                    temp_ctrl_signals = 9'b010100010; 
                    temp_alu_ctrl = op_code + 6'h10;
                end
            6'h20,6'h21,6'h22,6'h23,6'h24,6'h25: //loads
                begin 
                    temp_ctrl_signals = 9'b011100010;
                    temp_alu_ctrl = 6'h20;
                end
            6'h28, 6'h29, 6'h2b: // stores
                begin 
                    temp_ctrl_signals = 9'b010010010;
                    temp_alu_ctrl = 6'h20;
                end
            default: 
        ;
            endcase
    
    end
    
    assign alu_ctrl = temp_alu_ctrl;
    assign ctrl_signals = temp_ctrl_signals;
endmodule

