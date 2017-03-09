module datapath_test();
    wire [0:31] instr;
    reg clk;
    parameter IMEMFILE = "fib_inst.hex";
    parameter DMEMFILE = "fib_data.hex";
    reg [8*80-1:0] filename;
    integer i, j, f; 

    datapath DATAPATH (
        .clk(clk),
        .instruction(instr));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        j = 0;
       $monitor("the instruction is %x\n", instr);
        for (i = 0; i < DATAPATH.DMEM.SIZE; i = i+1)  
            DATAPATH.DMEM.mem[i] = 8'h00;

        if (!$value$plusargs("instrfile=%s",filename)) begin
            filename = IMEMFILE;
        end
        $readmemh(filename, DATAPATH.INST_FETCH.IMEM.mem);

        if (!$value$plusargs("datafile=%s",filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DATAPATH.DMEM.mem);

        f = $fopen("output.txt", "w");

        DATAPATH.INST_FETCH.pc = 32'h0000;
        #27  $display("opcode: %x r2: %x", instr[0:5], DATAPATH.REG_FILE.regfile[2]);
            
    end
    

    always begin
        #1 clk = ~clk;
        j = j + 1;
        if(j > 100000) 
        begin
            for(j = 0; j < 100; j = j + 1)
                $fwrite(f, "%d\n", DATAPATH.DMEM.mem[16'h2000 + j]);
            $fclose(f);
            $finish;
        end
        if (clk == 1'b0)
        begin
            $display("op: %x, func: %x, ctrl: %b, pc: %x", DATAPATH.instr[0:5], DATAPATH.instr[26:31], DATAPATH.ctrl_signals, DATAPATH.INST_FETCH.pc);  
        end
        if (instr == 32'h44000300)
        begin
            $display("DMEM -> addr: %x, wdata: %x", DATAPATH.alu_out, DATAPATH.busB1);
            for(j = 0; j < 100; j = j + 1)
                $fwrite(f, "%d\n", DATAPATH.DMEM.mem[16'h2000 + j]);
            $fclose(f);
            #10 $finish;
        end
        if (instr[0:5] == 6'h02 || instr[0:5] == 6'h03 || instr[0:5] == 6'h12 || instr[0:5] == 6'h13 || instr[0:5] == 6'h04 || instr[0:5] == 6'h05)
            $display("branch: %x, jump: %x, zero: %x, jmp_target: %x, reg_jmp: %x\n", DATAPATH.branch, DATAPATH.jump, DATAPATH.zero, DATAPATH.INST_FETCH.jmp_target, DATAPATH.INST_FETCH.reg_jmp);
        if (instr[0:5] == 6'h24 || instr[0:5] == 6'h20)
            $display("lbu: %x, out of memory: %x, datasize: %x, op: %x", DATAPATH.busW2, DATAPATH.mem_out, DATAPATH.data_size, instr[0:5]);
        if (instr[0:5] == 6'h00 && instr[26:31] == 6'h2a)
            $display("rs1: %x, rs1val: %x, rs2: %x rs2val: %x, rd: %x", instr[6:10], DATAPATH.busA2, instr[11:15], DATAPATH.busB2, instr[16:20]);
        if (instr[0:5] == 6'h0f)
            $display("imm: %x", instr[16:31]);
    end
endmodule
