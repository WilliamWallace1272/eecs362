module datapath_test();
    wire [0:31] instr;
    reg clk;
    parameter IMEMFILE = "fib_inst.hex";
    parameter DMEMFILE = "fib_data.hex";
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


        DATAPATH.INST_FETCH.pc = 32'h0;
        #0  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #1  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("ALU result: %x, busA: %x, busB: %x, busW: %x, rw: %x  \n", DATAPATH.alu_out, DATAPATH.busA2, DATAPATH.busB2, DATAPATH.busW2, DATAPATH.rw2);
        #2  $display("branch: %x, jump: %x, zero: %x, br_target: %x, pc_or_br: %x  \n", DATAPATH.branch, DATAPATH.jump, DATAPATH.zero, DATAPATH.INST_FETCH.br_target, DATAPATH.INST_FETCH.sign_ext);
            
    end
    

    always
        #1 clk = ~clk;
endmodule
