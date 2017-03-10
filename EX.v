`timescale 1ns / 1ps

module execute (input clk, input reg_lock, input[0:8] ctrl, input [0:5] alu_ctrl, input [0:31] busA, input [0:31] busB, input [0:31] imm_ext, input [0:2] dmem_info, input [0:4] write_reg, input [0:4] write_reg_mem, input [0:31] write_val_mem, input [0:4] write_reg_wb, input [0:31] write_val_wb, input [0:4] regA, input [0:4] regB, input reg_write_mem, input reg_write_wb,  output [0:8] ctrl_reg, output [0:31] alu_out_reg, output [0:31] write_data_reg, output [0:2] dmem_info_reg, output [0:4] write_reg_reg, output [0:31] mult_out_reg, output [0:5] alu_ctrl_reg, output [0:4] write_reg_ex, output [0:31] alu_out);
    
   
    wire [0:31] busB2;   
    wire [0:31] alu_out;
    wire [0:31] busA_forward, busB_forward;
    wire [0:63] full_mult_result;
    wire [0:31] mult_result;
    wire fwdA_mem, fwdA_wb, fwdB_mem, fwdB_wb;
    wire mult_sign;
    assign busB2 = (ctrl[1]) ? imm_ext : busB_forward; 

    assign mult_sign = (alu_ctrl == 6'h0e) ? 1 : 0; // 0x0e is signed multiplication

    assign fwdA_mem = ((regA == write_reg_mem) && reg_write_mem) ? 1 : 0;
    assign fwdA_wb  = ((regA == write_reg_wb) && reg_write_wb)   ? 1 : 0;
    assign fwdB_mem = ((regB == write_reg_mem) && reg_write_mem) ? 1 : 0;
    assign fwdB_wb  = ((regB == write_reg_wb) && reg_write_wb)   ? 1 : 0;

    assign busA_forward = fwdA_mem ? write_val_mem
                                   : fwdA_wb ? write_val_wb
                                             : busA;

    assign busB_forward = fwdB_mem ? write_val_mem
                                   : fwdB_wb ? write_val_wb
                                             : busB;

    alu ALU(.A(busA_forward), .B(busB2), .func(alu_ctrl), .result(alu_out));
   


    booth_mult MULT(.p(full_mult_result), .a(busA), .b(busB), .clk(clk), .sign(mult_sign));    
    
    //assign mult_result = full_mult_result[32:63];


    reg [0:8] ctrl_reg;
    reg [0:31] alu_out_reg;
    reg [0:31] mult_out_reg;
    reg [0:31] write_data_reg;
    reg [0:2] dmem_info_reg;
    reg [0:4] write_reg_reg;
    reg [0:5] alu_ctrl_reg;
    always @(posedge clk) begin
        if (!reg_lock)
        begin
            ctrl_reg <= ctrl;
            alu_ctrl_reg <= alu_ctrl;
            alu_out_reg <= alu_out;
            write_data_reg <= busB_forward;
            dmem_info_reg <= dmem_info;
            write_reg_reg <= write_reg;
            mult_out_reg <= full_mult_result[32:63];
        end

    end

endmodule

