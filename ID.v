`timescale 1ns / 1ps

module i_decode (input clk, input reg_lock, input [0:31] instruction,input we,input [0:4] WriteReg, input [0:31] WriteData, input [0:31] pc_plus_four, input [0:4] write_reg_ex, input [0:4] write_reg_mem, input [0:31] write_val_ex, input [0:31] write_val_mem, input fp_we,
output [0:8] ctrl_reg, output [0:5] alu_ctrl_reg,output [0:31] busA_reg,output [0:31] busB_reg, output [0:31] imm_ext_reg, output [0:2] dmem_info_reg, output jump_or_branch, output [0:31]target, output reg_lock_if, output [0:4] write_reg, output [0:4] regA, output [0:4] regB, output fp_reg_write);
   // regwrite is from mem/wb register
   
    wire [0:8] ctrl_signals;
    wire [0:5] alu_ctrl;
    wire [0:4] rs,rt,rd,rw1,rw2;
    wire [0:31] busA1, busB1, imm_ext, busA2, busB2, busA3, busB3, fp_busA, fp_busB;
    wire [0:2] dmem_info;
    
    
    control CONTROL(.op_code(instruction[0:5]), .func_code(instruction[26:31]), .ctrl_signals(ctrl_signals), .alu_ctrl(alu_ctrl));

    reg_file REG_FILE(.clk(clk), .we(we), .wrAddr(WriteReg),.wrData(WriteData), .rdAddrA(rs), 
                                .rdDataA(busA1), .rdAddrB(rt), .rdDataB(busB1));
    reg_file FP_REG_FILE(.clk(clk), .we(fp_we), .wrAddr(WriteReg), .wrData(WriteData), .rdAddrA(rs),
                                .rdDataA(fp_busA), .rdAddrB(rt), .rdDataB(fp_busB));

    wire [0:31] jmp_target, branch_target, norm_jmp, target;
    wire zero, jump_or_branch;
   
    adder_n ADDER_JMP_TARGET(.A(pc_plus_four), .B({{6{instruction[6]}}, instruction[6:31]}), .cin(1'b0), .Sum(norm_jmp));
    
    adder_n ADDER_BRANCH_TARGET(.A(pc_plus_four), .B({{16{instruction[16]}}, instruction[16:31]}), .cin(1'b0), .Sum(branch_target));


    wire [0:31] jmp_bus;
    wire fwd_br_ex, fwd_br_mem;
    assign fwd_br_ex = (rs == write_reg_ex) ? 1 : 0;
    assign fwd_br_mem = (rs == write_reg_mem) ? 1 : 0;
    assign jmp_bus = fwd_br_ex ? write_val_ex
                                  : fwd_br_mem ? write_val_mem
                                                  : busA1;
    assign jmp_target = (instruction[0:4] == 5'b01001) ? jmp_bus : norm_jmp;
    assign target = ctrl_signals[6] ? jmp_target : branch_target;
    assign jump_or_branch = ctrl_signals[6] || (ctrl_signals[5] && zero);
    assign zero = (instruction[5] == (|jmp_bus));


    assign dmem_info = instruction[3:5]; // dmem_info 0 is un/signed load. bits 1 and 2 are for size; 
    assign rs = instruction[6:10];
    assign rt = instruction[11:15];
    assign rd = instruction[16:20];
    assign rw1 = ctrl_signals[0] ? rd : rt;
    assign rw2 = ctrl_signals[8] ? 6'b111111 : rw1;
    
    assign busA2 = ctrl_signals[8] ? pc_plus_four : busA1;
    assign busB2 = ctrl_signals[8] ? 32'h04 : busB1;

    assign busA3 = ((instruction[0:5] == 6'b000000 && instruction[26:31] == 6'h34) || instruction[0:5] == 6'h01) 
                    ? fp_busA : busA2;
    assign busB3 = ((instruction[0:5] == 6'b000000 && instruction[26:31] == 6'h34) || instruction[0:5] == 6'h01) 
                    ? fp_busB : busB2;

    assign fp_write = ((instruction[0:5] == 6'b000000 && instruction[26:31] == 6'h35) 
                      || instruction[0:5] == 6'h01);

    assign imm_ext = {{16{instruction[16] & ctrl_signals[7]}}, instruction[16:31]};
    
    //TODO : add jump/link/branch logic here
    reg reg_lock_if, fp_reg_write;
    reg [0:31] counter;
    
    wire [0:31] new_count;
    assign new_count = 1;

    reg [0:2] dmem_info_reg;
    reg [0:8] ctrl_reg;
    reg [0:5] alu_ctrl_reg;
    reg [0:31] busA_reg, busB_reg, imm_ext_reg;
    reg [0:4] write_reg, regA, regB;
    wire [0:31] temp_count;
    reg [0:31] temp_count2;
    adder_n ADDER_1(.A(counter), .B(-1), .cin(0), .Sum(temp_count));

    always @ *
    begin
        if (counter != 0)
        begin
            temp_count2 = 0;
            reg_lock_if = 0;
        end
        else if (instruction[0:5] == 6'h03)
        begin
            temp_count2 = 32'h3;
            reg_lock_if = 1;
        end
        else if (instruction[0:2] == 3'b100)
        begin
            temp_count2 = 32'h0000000a;
            reg_lock_if = 1;
        end
        else 
        begin
            temp_count2 = 0;
            reg_lock_if = 0;
        end
    end

    always @(posedge clk) begin
        if (!reg_lock)
        begin
       /*     if (instruction[0:5] == 6'h03)
                begin
                    counter <= 32'h00000003;
                    reg_lock_if <= 1;
                end
            else if(instruction[0:2] == 3'b100)
            begin
                    counter <= 32'h0000000a;
                    reg_lock_if <= 1;
            end*/

            if (temp_count2 == 32'h0000000a)
            begin
                counter <= 1;
                ctrl_reg <= ctrl_signals;
                $display("counter is %x", counter);
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA3; // pure A and B registers
                busB_reg <= busB3;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= rw1;
                fp_reg_write <= fp_write;
            end

            if (temp_count2 == 3) //initial
            begin
            
                counter <= 2;
                ctrl_reg <= ctrl_signals;
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA3; // pure A and B registers
                busB_reg <= busB3;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= 5'b11111;
                fp_reg_write <= fp_write;
                
            end

            else if (counter > 0) // pass along a nop
            begin
                counter <= temp_count;
                ctrl_reg <= 9'b000000000;
                alu_ctrl_reg <= 6'h15;
                busA_reg <= busA3; // pure A and B registers
                busB_reg <= busB3;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext; // if control is all 0 than we should be good
                dmem_info_reg <= dmem_info;
                write_reg <= 5'b00000;
                fp_reg_write <= fp_write;
            end

           else  
            begin
                ctrl_reg <= ctrl_signals;
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA3; // pure A and B registers
                busB_reg <= busB3;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= rw1;
                fp_reg_write <= fp_write;
            end
        end
    end

endmodule

