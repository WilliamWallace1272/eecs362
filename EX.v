`timescale 1ns / 1ps

module execute (input clk, input reg_lock, input[0:8] ctrl, input [0:5] alu_ctrl, input [0:31] busA, input [0:31] busB, input [0:31] imm_ext, input [0:2] dmem_info, output [0:8] ctrl_reg, output [0:31] alu_out_reg, output [0:31] write_data_reg, output [0:2] dmem_info_reg);
    
   
    wire [0:31] busB2;   
    wire [0:31] alu_out;
    
    assign busB2 = (ctrl[1]) ? busB : imm_ext; 


    alu ALU(.A(busA), .B(busB2), .func(alu_ctrl), .result(alu_out));
    


    reg [0:8] ctrl_reg;
    reg [0:31] alu_out_reg;
    reg [0:31] write_data_reg;
    reg [0:2] dmem_info_reg;
    always @(posedge clk) begin
        if (!reg_lock)
        begin
            ctrl_reg <= ctrl;
            alu_out_reg <= alu_out;
            write_data_reg <= busB;
            dmem_info_reg <= dmem_info;
        end

    end

endmodule

