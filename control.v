`timescale 1ns/100ps

module control(op_code, func_code, ctrl_signals, alu_ctrl);
    input [0:5] op_code;
    input [0:5] func_code;
    output [0:7] ctrl_signals;
    output [0:5] alu_ctrl;


    reg  temp_alu_ctrl, temp_ctrl_signals;
    reg [0:31] adder_B, out;
    wire [0:31] lshift, rshift, adder_result;
    wire carry_out;


    always @* begin
        case (op_code)
            6'h00:
                begin
                    temp_ctrl_signals = 8'b10010000;
                    temp_alu_ctrl = func_code;
                end
            6'h01:
            ;
            
            6'h02: // j
                begin
                    temp_ctrl_signals = 8'b00000010; // dcs here if wondering 
                    temp_alu_ctrl = 6'b000000;
                end

            6'h03:
                begin 
                end
            6'h04:
                begin 
                end
            6'h05:
                begin 
                end
            6'h08:
                begin 
                end
            6'h09:
                begin 
                end
            6'h0a:
                begin 
                end
            6'h0b:
                begin 
                end
            6'h0c:
                begin 
                end
            6'h0d:
                begin 
                end
            6'h0e:
                begin 
                end
            6'h0f:
                begin 
                end
            6'h12:
                begin 
                end
            6'h13:
                begin 
                end
            6'h14:
                begin 
                end
            6'h15:
                begin 
                end
            6'h16:
                begin 
                end
            6'h17:
                begin 
                end
            6'18:
                begin 
                end
            6'h19:
                begin 
                end
            6'h1a:
                begin 
                end
            6'h1b:
                begin 
                end
            6'h1c:
                begin 
                end
            6'h1d:
                begin 
                end
            6'h20:
                begin 
                end
            6'h21:
                begin 
                end
            6'h23:
                begin 
                end
            6'h24:
                begin 
                end
            6'h25:
                begin 
                end
            6'h28:
                begin 
                end
            6'h29:
                begin 
                end
            6'h2b:
                begin 
                end
            default: 
        ;
            endcase
    
    end
    
    assign alu_ctrl = temp_alu_ctrl;
    assign ctrl_signals = temp_ctrl_signals;
endmodule

