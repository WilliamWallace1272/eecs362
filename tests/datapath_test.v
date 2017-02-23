module datapath_test();
    wire [0:31] instr;
    reg clk;
    parameter IMEMFILE = "quick_inst.hex";
    parameter DMEMFILE = "quick_data.hex";
    reg [8*80-1:0] filename;
    integer i; 

    datapath DATAPATH (
        .clk(clk),
        .instruction(instr));

    initial begin
        clk = 0;
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


        DATAPATH.INST_FETCH.pc = 32'h1000;
//        #17  $display("branch: %b, jump: %b, zero: %b  \n", DATAPATH.branch, DATAPATH.jump, DATAPATH.zero);
            
    end
    

    always begin
        #1 clk = ~clk;
        if (instr == 32'h44000300)
        begin
            $display("DMEM -> addr: %x, wdata: %x", DATAPATH.alu_out, DATAPATH.busB1);
            $finish;
        end
        if (instr == 32'h0c00029c || instr == 32'h4be00000)
            $display("branch: %x, jump: %x, zero: %x, jmp_target: %x, reg_jmp: %x\n", DATAPATH.branch, DATAPATH.jump, DATAPATH.zero, DATAPATH.INST_FETCH.jmp_target, DATAPATH.INST_FETCH.reg_jmp);
    end
endmodule
