module mult_test();
    reg [31:0] instruction;
    reg clk;
    parameter IMEMFILE = "instr.hex";
    parameter DMEMFILE = "data.hex";
    reg [8*80-1:0] filename;
    

    datapath DATAPATH (
        .clk(clk),
        .instruction(instruction));

    initial begin
       $monitor("the instruction is %x", instruction);
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
    end
    

    always
        #1 clk = ~clk;
endmodule
