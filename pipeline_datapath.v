module pipeline_datapath (input clk, output [0:31] instr);
   
    assign instr = instruction;
    wire [0:31] instruction, pc_plus_four_id, pc_plus_four_if,
                alu_out_mem,alu_out_ex,alu_non_reg_ex,mult_out_ex, 
                mem_out_mem,
                write_mem_ex,
                busA_id, busB_id, 
                target_id,
                write_data_wb,
                imm_ext_id;
    wire [0:5] alu_ctrl_id, alu_ctrl_ex;
    wire [0:4] write_reg_wb, write_reg_id, write_reg_ex, write_reg_mem, regA_id, regB_id; 
    wire [0:8] ctrl_id, ctrl_ex, ctrl_mem;
    wire [0:2] dmem_info_id, dmem_info_ex, dmem_info_mem;
     
    //should be wires once connected
    wire reg_lock_if, reg_lock_if1;
    reg reg_lock_id, reg_lock_ex, reg_lock_mem, reg_lock_wb;
    wire jump_or_branch_id;

    initial begin
     //   reg_lock_if <= 0;
        reg_lock_id <= 0;
        reg_lock_ex <= 0;
        reg_lock_mem <= 0;
        reg_lock_wb <= 0;
    end
         



    i_fetch I_FETCH(.clk(clk),.reg_lock(reg_lock_if), .target(target_id), .jump_or_branch(jump_or_branch_id), .instr(instruction), .pc_plus_four(pc_plus_four_if));
   
    assign reg_lock_if = reg_lock_if1;
    i_decode I_DECODE(
        //inputs
        .clk(clk), .reg_lock(reg_lock_id), .instruction(instruction), .we(reg_write_wb), 
        .WriteReg(write_reg_wb), .WriteData(write_data_wb), .pc_plus_four(pc_plus_four_if),
        .write_reg_ex(write_reg_id), .write_reg_mem(write_reg_ex), .write_val_ex(alu_non_reg_ex),
        .write_val_mem(alu_out_ex), .fp_we(fp_reg_write_wb), .fp_write_ex(fp_reg_write_id),
        .fp_write_mem(fp_reg_write_ex),
        //outputs
        .ctrl_reg(ctrl_id), .alu_ctrl_reg(alu_ctrl_id), .busA_reg(busA_id),.busB_reg(busB_id), 
        .imm_ext_reg(imm_ext_id), .dmem_info_reg(dmem_info_id),.jump_or_branch(jump_or_branch_id) , 
        .target(target_id), .reg_lock_if(reg_lock_if1), .write_reg(write_reg_id), .regA(regA_id),
        .regB(regB_id), .fp_reg_write(fp_reg_write_id));
        


    execute EXECUTE (
        //inputs
        .clk(clk), .reg_lock(reg_lock_ex), .ctrl(ctrl_id), .alu_ctrl(alu_ctrl_id), 
        .busA(busA_id), .busB(busB_id), .imm_ext(imm_ext_id), .dmem_info(dmem_info_id),.write_reg(write_reg_id), 
        .write_reg_mem(write_reg_ex), .write_val_mem(alu_out_ex), .write_reg_wb(write_reg_mem), 
        .write_val_wb(write_data_wb), .regA(regA_id), .regB(regB_id), .reg_write_mem(ctrl_ex[3]), 
        .reg_write_wb(ctrl_mem[3]), .fp_write(fp_reg_write_id), .fp_write_mem(fp_reg_write_ex),
        .fp_write_wb(fp_reg_write_mem),
        //outputs
        .ctrl_reg(ctrl_ex), .alu_out_reg(alu_out_ex), .write_data_reg(write_mem_ex), 
        .dmem_info_reg(dmem_info_ex), .write_reg_reg(write_reg_ex), .mult_out_reg(mult_out_ex), 
        .alu_ctrl_reg(alu_ctrl_ex), .alu_out(alu_non_reg_ex), .fp_reg_write(fp_reg_write_ex));

    mem_stage MEM_STAGE (
        //inputs
        .clk(clk), .reg_lock(reg_lock_mem), .ctrl(ctrl_ex), .alu_out(alu_out_ex), .write_data(write_mem_ex),
        .dmem_info(dmem_info_ex), .write_reg(write_reg_ex), .mult_out(mult_out_ex), .alu_ctrl(alu_ctrl_ex),
        .fp_write(fp_reg_write_ex),
        //outputs
        .ctrl_reg(ctrl_mem), .mem_out_reg(mem_out_mem), .alu_out_reg(alu_out_mem), 
        .dmem_info_reg(dmem_info_mem),.write_reg_reg(write_reg_mem), .fp_reg_write(fp_reg_write_mem));

    write_back WRITE_BACK (
        //inputs 
        .clk(clk), .ctrl(ctrl_mem), .mem_out(mem_out_mem), .alu_out(alu_out_mem), 
        .dmem_info(dmem_info_mem), .write_reg(write_reg_mem), .fp_write(fp_reg_write_mem),
        //outputs
        .write_data(write_data_wb), .write_reg_wb(write_reg_wb), .reg_write(reg_write_wb),
        .fp_reg_write(fp_reg_write_wb));
    
    

endmodule
