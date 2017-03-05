module pipeline_datapath (input clk, output [0:31] instr);
   
    assign instr = instruction;
    wire [0:31] instruction, pc_plus_four_id, pc_plus_four_if,
                alu_out_mem,alu_out_ex, 
                mem_out_mem,
                write_mem_ex,
                busA_id, busB_id, 
                target_id,
                write_data_wb,
                imm_ext_id;
    wire [0:5] alu_ctrl_id;
    wire [0:4] write_reg_wb; 
    wire [0:8] ctrl_id, ctrl_ex, ctrl_mem;
    wire [0:2] dmem_info_id, dmem_info_ex, dmem_info_mem;
     
    wire reg_lock_if, reg_lock_if1,reg_lock_id, reg_lock_ex, reg_lock_mem, reg_lock_wb, jump_or_branch_id;

    i_fetch I_FETCH(.clk(clk),.reg_lock(reg_lock_if), .target(target_id), .jump_or_branch(jump_or_branch_id), .instr(instruction), .pc_plus_four(pc_plus_four_if));
   
    assign reg_lock_if = reg_lock_if1;
    i_decode I_DECODE(
        //inputs
        .clk(clk), .reg_lock(reg_lock_id), .instruction(instruction), .we(reg_write_wb), 
        .WriteReg(write_reg_wb), .WriteData(write_data_wb), .pc_plus_four(pc_plus_four_if), // inputs
        //outputs
        .ctrl_reg(ctrl_id), .alu_ctrl_reg(alu_ctrl_id), .busA_reg(busA_id),.busB_reg(busB_id), 
        .imm_ext_reg(imm_ext_id), .dmem_info_reg(dmem_info_id),.jump_or_branch(jump_or_branch_id) , 
        .target(target_id), .reg_lock_if(reg_lock_if1));
        


    execute EXECUTE (
        //inputs
        .clk(clk), .reg_lock(reg_lock_ex), .ctrl(ctrl_id), .alu_ctrl(alu_ctrl_id), 
        .busA(busA_id), .busB(busB_id), .imm_ext(imm_ext_id), .dmem_info(dmem_info_id), 
        //outputs
        .ctrl_reg(ctrl_ex), .alu_out_reg(alu_out_ex), .write_data_reg(write_mem_ex), .dmem_info_reg(dmem_info_ex));

    mem_stage MEM_STAGE (
        //inputs
        .clk(clk), .reg_lock(reg_lock_mem), .ctrl(ctrl_ex), .alu_out(alu_out_ex), .write_data(write_mem_ex),
        .dmem_info(dmem_info_ex),
        //outputs
        .ctrl_reg(ctrl_mem), .mem_out_reg(mem_out_mem), .alu_out_reg(alu_out_mem), .dmem_info_reg(dmem_info_mem));

    write_back WRITE_BACK (
        //inputs 
        .clk(clk), .ctrl(ctrl_mem), .mem_out(mem_out_mem), .alu_out(alu_out_mem), 
        .dmem_info(dmem_info_mem),
        //outputs
        .write_data(write_data_wb), .write_reg(write_reg_wb), .reg_write(reg_write_wb));
    
    

endmodule
