`timescale 1ns / 1ps

module mem_stage (input clk, input reg_lock, input[0:8] ctrl, input [0:31] alu_out, input [0:31] write_data, input [0:2] dmem_info,input [0:4] write_reg, input[0:31] mult_out, input[0:5] alu_ctrl, input fp_write,input reg_lock_mult,
    output [0:8] ctrl_reg, output [0:31] mem_out_reg, output [0:31] alu_out_reg, output [0:2] dmem_info_reg, output [0:4] write_reg_reg, output fp_reg_write);  
   
    wire [0:31] mem_out;
    wire [0:31] mult_or_alu;
    dmem DMEM(.addr(alu_out), .rData(mem_out), .wData(write_data), .writeEnable(ctrl[4]), .dsize(dmem_info[1:2]), .clk(clk)); 

    assign mult_or_alu = (alu_ctrl == 6'h0e || alu_ctrl == 6'h16) ? mult_out : alu_out;
    reg [0:8] ctrl_reg;
    reg [0:31] mem_out_reg;
    reg [0:31] alu_out_reg;
    reg [0:4] write_reg_reg;
    reg [0:2] dmem_info_reg;
    reg fp_reg_write;
    always @(posedge clk) begin
        if (!reg_lock && !reg_lock_mult)
        begin
            ctrl_reg <= ctrl;
            alu_out_reg <= mult_or_alu;
            dmem_info_reg <= dmem_info;
            write_reg_reg <= write_reg;
            mem_out_reg <= mem_out;
            fp_reg_write <= fp_write;
        end
    end
endmodule

module dmem(addr, rData, wData, writeEnable, dsize, clk);
    parameter SIZE=32768;

    input [0:31] addr, wData;
    input 	writeEnable, clk;
    input [0:1] dsize; // equivalent to bytes-1 ( 3=Word, 1=Halfword, 0=Byte)
    output [0:31] rData;
    reg [0:7] 	 mem[0:(SIZE-1)];

    // Write
    always @ (posedge clk) begin
        if (writeEnable) begin
            $display("writing to mem at %x val %x size %2d", addr, wData, dsize);
            case (dsize)
              2'b11: begin
                 // word
                 {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= wData[0:31];
              end
              2'b10: begin
                 // bad
                 $display("Invalid dsize: %x", dsize);
              end
              2'b01: begin
                 // halfword
                 {mem[addr], mem[addr+1]} <= wData[16:31];
              end
              2'b00: begin
                 // byte
                 mem[addr] <= wData[24:31];
              end
              default: $display("Invalid dsize: %x", dsize);
            endcase
        end
    end
    // Read
    assign rData = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
endmodule // dmem
