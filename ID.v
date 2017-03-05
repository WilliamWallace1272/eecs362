`timescale 1ns / 1ps

module i_decode (input clk, input reg_lock, input [0:31] instruction,input we,input [0:4] WriteReg, input [0:31] WriteData, input [0:31] pc_plus_four,output [0:8] ctrl_reg, output [0:5] alu_ctrl_reg,output [0:31] busA_reg,output [0:31] busB_reg, output [0:31] imm_ext_reg, output [0:2] dmem_info_reg, output jump_or_branch, output [0:31]target, output reg_lock_if, output [0:4] write_reg, output [0:4] regA, output [0:4] regB);
   // regwrite is from mem/wb register
   
    wire [0:8] ctrl_signals;
    wire [0:5] alu_ctrl;
    wire [0:4] rs,rt,rd,rw1,rw2;
    wire [0:31] busA1, busB1, imm_ext;
    wire [0:2] dmem_info;
    
    
    control CONTROL(.op_code(instruction[0:5]), .func_code(instruction[26:31]), .ctrl_signals(ctrl_signals), .alu_ctrl(alu_ctrl));

    reg_file REG_FILE(.clk(clk), .we(we), .wrAddr(WriteReg),.wrData(WriteData), .rdAddrA(rs), 
                                .rdDataA(busA1), .rdAddrB(rt), .rdDataB(busB1));
    wire [0:31] jmp_target, branch_target, norm_jmp, target;
    wire zero, jump_or_branch;
   
    adder_n ADDER_JMP_TARGET(.A(pc_plus_four), .B({{6{instruction[6]}}, instruction[6:31]}), .cin(1'b0), .Sum(norm_jmp));
    
    adder_n ADDER_BRANCH_TARGET(.A(pc_plus_four), .B({{16{instruction[16]}}, instruction[16:31]}), .cin(1'b0), .Sum(branch_target));

    assign jmp_target = (instruction[0:4] == 5'b01001) ? busA1 : norm_jmp;
    assign target = ctrl_signals[6] ? jmp_target : branch_target;
    assign jump_or_branch = ctrl_signals[6] || (ctrl_signals[5] && zero);
    assign zero = (instruction[5] == (|busA1));


    assign dmem_info = instruction[3:5]; // dmem_info 0 is un/signed load. bits 1 and 2 are for size; 
    assign rs = instruction[6:10];
    assign rt = instruction[11:15];
    assign rd = instruction[16:20];
    assign rw1 = ctrl_signals[0] ? rd : rt;
    
    

    assign imm_ext = {{16{instruction[16] & ctrl_signals[7]}}, instruction[16:31]};
    
    //TODO : add jump/link/branch logic here
    reg reg_lock_if;
    reg [0:31] counter;
   

    reg [0:2] dmem_info_reg;
    reg [0:8] ctrl_reg;
    reg [0:5] alu_ctrl_reg;
    reg [0:31] busA_reg, busB_reg, imm_ext_reg;
    reg [0:4] write_reg, regA, regB;
    wire [0:31] temp_count;
    adder_n ADDER_1(.A(counter), .B(-1), .cin(0), .Sum(temp_count));
    always @(posedge clk) begin
        if (!reg_lock)
        begin
            if (instruction[0:5] == 6'h03)
                begin
                    counter <= 32'h00000003;
                    reg_lock_if <= 1;
                end
            else if(instruction[0:2] == 3'b100)
            begin
                    counter <= 32'h0000000a;
                    reg_lock_if <= 1;
            end

            if (counter == 32'h0000000a)
            begin
                counter <= 1;
                ctrl_reg <= ctrl_signals;
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA1; // pure A and B registers
                busB_reg <= busB1;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= rw1;
            end

            if (counter == 3) //initial
            begin
            
                counter <= temp_count;
                ctrl_reg <= ctrl_signals;
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA1; // pure A and B registers
                busB_reg <= busB1;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= 5'b11111;
                
            end

            else if (counter > 0) // pass along a nop
            begin
                counter <= temp_count;
                ctrl_reg <= 9'b000000000;
                alu_ctrl_reg <= 6'h15;
                busA_reg <= busA1; // pure A and B registers
                busB_reg <= busB1;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext; // if control is all 0 than we should be good
                dmem_info_reg <= dmem_info;
                write_reg <= 5'b00000;
                
            end

           else  
            begin
                reg_lock_if <= 0;
                ctrl_reg <= ctrl_signals;
                alu_ctrl_reg <= alu_ctrl;
                busA_reg <= busA1; // pure A and B registers
                busB_reg <= busB1;
                regA <= rs;
                regB <= rt;
                imm_ext_reg <= imm_ext;
                dmem_info_reg <= dmem_info;
                write_reg <= rw1;
        
            end
        end
    end

endmodule

