`timescale 1ns/100ps

module control(op_code, func_code, ctrl_signals, alu_ctrl);
    input [0:5] op_code;
    input [0:5] func_code;
    output [0:6] ctrl_signals;
    output [0:5] alu_ctrl;


    reg  temp_alu_ctrl, temp_ctrl_signals;
    reg [0:31] adder_B, out;
    wire [0:31] lshift, rshift, adder_result;
    wire carry_out;


    always @* begin
        case (op_code)
            6'h04, 6'h06, 6'h07, 6'h15, 6'h20, 6'h21, 6'h22, 6'h23, 6'h24, 6'h25, 6'h26, 6'h28, 6'h29, 6'h2a, 6'h2b, 6'h2c, 6'h2d: // not including the floating point shitttt
            begin
                temp_ctrl_signals = 7'b1001000;
                temp_alu_ctrl = func_code;
            end
            default: 
        ;
            endcase
    
    end
    
    assign alu_ctrl = temp_alu_ctrl;
    assign ctrl_signals = temp_ctrl_signals;
endmodule

