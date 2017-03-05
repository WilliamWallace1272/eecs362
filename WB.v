`timescale 1ns / 1ps

module write_back (input clk, input [0:8] ctrl, input [0:31] mem_out, input [0:31] alu_out, input [0:2] dmem_info, input [0:4] write_reg, output [0:31] write_data, output[0:4] write_reg_wb, output reg_write);  
   

    assign reg_write = ctrl[3];
    assign write_reg_wb = write_reg; 
    assign write_data = ctrl[2] ?
                        dmem_info[0] ?
                            dmem_info[1] ?
                                mem_out //should actually load fp's which we're ignoring
                                : dmem_info[2] ?
                                    {{16{1'b0}}, mem_out[16:31]}
                                    : {{24{1'b0}}, mem_out[24:31]}
                            : dmem_info[1] ?
                                mem_out
                                : dmem_info[2] ?
                                    {{16{mem_out[16]}}, mem_out[16:31]}
                                    : {{24{mem_out[24]}}, mem_out[24:31]}
                        : alu_out;                            
    

endmodule

