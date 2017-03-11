module datapath_test();
    wire [0:31] instr;
    reg clk;
    parameter IMEMFILE = "fptest_inst.hex";
    parameter DMEMFILE = "fptest_data.hex";
    reg [8*80-1:0] filename;
    integer i, j, f; 

    pipeline_datapath DATAPATH (
        .clk(clk),
        .instr(instr));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        j = 0;
       $monitor("the instruction is %x\n", instr);
        for (i = 0; i < DATAPATH.MEM_STAGE.DMEM.SIZE; i = i+1)  
            DATAPATH.MEM_STAGE.DMEM.mem[i] = 8'h00;

        if (!$value$plusargs("instrfile=%s",filename)) begin
            filename = IMEMFILE;
        end
        $readmemh(filename, DATAPATH.I_FETCH.IMEM.mem);

        if (!$value$plusargs("datafile=%s",filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DATAPATH.MEM_STAGE.DMEM.mem);

        f = $fopen("output.txt", "w");
        DATAPATH.I_DECODE.counter = 32'h00000000;
        DATAPATH.I_FETCH.pc = 32'h0000;
        DATAPATH.EXECUTE.write_reg_reg = 1;
        DATAPATH.I_DECODE.write_reg= 1;
        DATAPATH.I_FETCH.instr = 32'h00000015;
        #27  $display("opcode: %x r2: %x", instr[0:5], DATAPATH.I_DECODE.REG_FILE.regfile[2]);
            
    end
    
    always begin
        #1 clk = ~clk;
    end

    always begin
        #1 j = j + 1;
        if(j > 100000) 
        begin
            for(j = 0; j < 100; j = j + 1)
                $fwrite(f, "%x\n", DATAPATH.MEM_STAGE.DMEM.mem[16'h2000 + j]);
            $fclose(f);
            $finish;
        end
        if (clk == 1'b0)
        begin
            $display("op: %x, func: %x, ctrl: %b, pc: %x", DATAPATH.instr[0:5], DATAPATH.instr[26:31], DATAPATH.ctrl_id, DATAPATH.I_FETCH.pc);  
        end
        if (instr == 32'h44000300)
        begin
            $display("DMEM -> addr: %x, wdata: %x\n", DATAPATH.alu_out_ex, DATAPATH.busB_id);
            $display("The program took %d cycles to complete\n", j/2); 
            #10
            for(j = 0; j < 100; j = j + 1)
            begin
                $fwrite(f, "%d", DATAPATH.MEM_STAGE.DMEM.mem[16'h2000 + j]);
                if(j % 4 == 0)
                    $fwrite(f, "\n");
            end
            $fclose(f);
            $finish;
        end
        /*
        if (instr[0:5] == 6'h02 || instr[0:5] == 6'h03 || instr[0:5] == 6'h12 || instr[0:5] == 6'h13 || instr[0:5] == 6'h04 || instr[0:5] == 6'h05)
            $display("branch: %x, jump: %x, zero: %x, jmp_target: %x, reg_jmp: %x\n", DATAPATH.branch, DATAPATH.jump, DATAPATH.zero, DATAPATH.INST_FETCH.jmp_target, DATAPATH.INST_FETCH.reg_jmp);
        if (instr[0:5] == 6'h24 || instr[0:5] == 6'h20)
            $display("lbu: %x, out of memory: %x, datasize: %x, op: %x", DATAPATH.busW2, DATAPATH.mem_out, DATAPATH.data_size, instr[0:5]);
        if (instr[0:5] == 6'h00 && instr[26:31] == 6'h2a)
            $display("rs1: %x, rs1val: %x, rs2: %x rs2val: %x, rd: %x", instr[6:10], DATAPATH.busA2, instr[11:15], DATAPATH.busB2, instr[16:20]);
        if (instr[0:5] == 6'h0f)
            $display("imm: %x", instr[16:31]);
    */
    end

endmodule
