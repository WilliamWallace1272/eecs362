`timescale 1ns / 1ps

module execute (input clk, input reg_lock, input[0:8] ctrl, input [0:5] alu_ctrl, input [0:31] busA, input [0:31] busB, input [0:31] imm_ext, input [0:2] dmem_info, input [0:4] write_reg, input [0:4] write_reg_mem, input [0:31] write_val_mem, input [0:4] write_reg_wb, input [0:31] write_val_wb, input [0:4] regA, input [0:4] regB, input reg_write_mem, input reg_write_wb, input fp_write, input fp_write_mem, input fp_write_wb,
    output [0:8] ctrl_reg, output [0:31] alu_out_reg, output [0:31] write_data_reg, output [0:2] dmem_info_reg, output [0:4] write_reg_reg, output [0:31] mult_out_reg, output [0:5] alu_ctrl_reg, output [0:4] write_reg_ex, output [0:31] alu_out, output fp_reg_write, output reg_lock_mult);
    
   
    wire [0:31] busB2;   
    wire [0:31] alu_out;
    wire [0:31] busA_forward, busB_forward;
    wire [0:63] full_mult_result;
    wire [0:31] mult_result;
    wire [0:31] final_A;
    wire [0:31] final_B;
    wire [0:5] alu_ctrl_or_counter;
    wire fwdA_mem, fwdA_wb, fwdB_mem, fwdB_wb;
    wire mult_sign;
    wire mult_op;
    assign busB2 = (ctrl[1]) ? imm_ext : busB_forward; 

    
    assign mult_sign = (alu_ctrl == 6'h0e) ? 1 : 0; // 0x0e is signed multiplication

    assign fwdA_mem = ((regA == write_reg_mem) && reg_write_mem && (fp_write == fp_write_mem)) ? 1 : 0;
    assign fwdA_wb  = ((regA == write_reg_wb) && reg_write_wb && (fp_write == fp_write_wb))    ? 1 : 0;
    assign fwdB_mem = ((regB == write_reg_mem) && reg_write_mem && (fp_write == fp_write_mem)) ? 1 : 0;
    assign fwdB_wb  = ((regB == write_reg_wb) && reg_write_wb && (fp_write == fp_write_wb))    ? 1 : 0;

    assign busA_forward = fwdA_mem ? write_val_mem
                                   : fwdA_wb ? write_val_wb
                                             : busA;

    assign busB_forward = fwdB_mem ? write_val_mem
                                   : fwdB_wb ? write_val_wb
                                             : busB;

    alu ALU(.A(final_A), .B(final_B), .func(alu_ctrl_or_counter), .result(alu_out));
   
    assign alu_ctrl_or_counter = (mult_op) ? 6'h22 : alu_ctrl;
    assign final_A = (mult_op) ? counter : busA_forward;
    assign final_B = (mult_op) ? 1 : busB2;

    wire [0:31] temp_count;
    assign temp_count = alu_out;
    reg [0:31] counter;
    reg [0:31] temp_count2;

    assign mult_op = (alu_ctrl == 6'h0e || alu_ctrl == 6'h16) ? 1 : 0;
    booth_mult MULT(.p(full_mult_result), .a(busA), .b(busB), .clk(clk), .sign(mult_sign));    
    
    //assign mult_result = full_mult_result[32:63];
    reg reg_lock_mult;
    always @ *
    begin
      
      if (mult_op == 1 && counter == 0)
      begin
        temp_count2 = 3;
        reg_lock_mult = 1;
      end
      
      else if (mult_op == 1 && temp_count == 0)
      begin
        temp_count2 = 0;
        reg_lock_mult = 0;
      end 
      else if (mult_op == 1 && counter > 0)
      begin
        temp_count2 = 0;
        reg_lock_mult = 1;
      end

      else 
      begin
        temp_count2 = 0;
        reg_lock_mult = 0;
      end
    end

    reg [0:8] ctrl_reg;
    reg [0:31] alu_out_reg;
    reg [0:31] mult_out_reg;
    reg [0:31] write_data_reg;
    reg [0:2] dmem_info_reg;
    reg [0:4] write_reg_reg;
    reg [0:5] alu_ctrl_reg;
    reg fp_reg_write;
    always @(posedge clk) begin
      
      if (temp_count2 == 3)
      begin 
        counter <= 3;
      end

      else if (temp_count  > 0)
      begin
        counter <= temp_count;
      end

      else
      begin 
        counter <= 0;
      end

      if (!reg_lock || !reg_lock_mult)
        begin
            ctrl_reg <= ctrl;
            alu_ctrl_reg <= alu_ctrl;
            alu_out_reg <= alu_out;
            write_data_reg <= busB_forward;
            dmem_info_reg <= dmem_info;
            write_reg_reg <= write_reg;
            mult_out_reg <= full_mult_result[32:63];
            fp_reg_write <= fp_write;
            
        end
      
    end

endmodule

