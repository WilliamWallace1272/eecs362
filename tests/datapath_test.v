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
        #0  $display("memwr: %b, data_size: %b  \n", DATAPATH.memwr, DATAPATH.DMEM.dsize);
            
    end
    

    always
        #1 clk = ~clk;
endmodule
