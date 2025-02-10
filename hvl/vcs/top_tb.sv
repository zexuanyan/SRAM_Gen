module top_tb;

    `include "rand.svh"
    //---------------------------------------------------------------------------------
    // Waveform generation.
    //---------------------------------------------------------------------------------
    initial begin
        $fsdbDumpfile("dump.fsdb");
        if ($test$plusargs("NO_DUMP_ALL_ECE411")) begin
            $fsdbDumpvars(0, dut_pl, "+all");
            $fsdbDumpoff();
        end else begin
            $fsdbDumpvars(0, "+all");
        end
    end

    //---------------------------------------------------------------------------------
    // TODO: Declare cache port signals:
    //---------------------------------------------------------------------------------

    RandReq random_request = new();
    logic           clk,csb0,web0; // web0: 0 for write, 1 for read
    logic   [3:0]   addr0;
    logic   [31:0]  wmask0;
    logic   [255:0] din0, dout0_pl, dout0_py, dout0_golden;
    integer         i;

    //---------------------------------------------------------------------------------
    // TODO: Generate a clock:
    //---------------------------------------------------------------------------------

    always #1ns clk = ~clk;

    //---------------------------------------------------------------------------------
    // TODO: Write a task to generate reset:
    //---------------------------------------------------------------------------------

    task reset();
        clk = 1'b0;
        csb0 = 1'b0;
        web0 = 1'b1;
        wmask0 = '0;
        din0 = '0;
        addr0 = '0;
    endtask

    //---------------------------------------------------------------------------------
    // TODO: Instantiate the DUT and physical memory:
    //---------------------------------------------------------------------------------

    mp_cache_data_array_pl  dut_pl(
        .*,
        .dout0(dout0_pl)
    );

    mp_cache_data_array_py  dut_py(
        .*,
        .dout0(dout0_py)
    );

    mp_cache_data_array     golden(
        .*,
        .clk0(clk),
        .dout0(dout0_golden)
    );

    //---------------------------------------------------------------------------------
    // TODO: Write tasks to test various functionalities:
    //---------------------------------------------------------------------------------

    // assertion stuff
    always @(posedge clk) begin : assertions
        pl_eq_golden: assert (dout0_pl === dout0_golden) else begin
            $display("dout0_pl = %x, dout0_golden = %x", dout0_pl, dout0_golden);
            $fatal("\033[31mAssertion failed: dout0_pl != dout0_golden\033[0m");
        end

        py_eq_golden: assert (dout0_py === dout0_golden) else begin
            $display("dout0_py = %x, dout0_golden = %x", dout0_py, dout0_golden);
            $fatal("\033[31mAssertion failed: dout0_py != dout0_golden\033[0m");
        end
    end : assertions

    task read_write(
        input   logic           r_w,
        input   logic   [3:0]   addr,
        input   logic   [31:0]  wmask,
        input   logic   [255:0] din

    );
        // 1 for writing, 0 for reading
        if (r_w) begin
            web0 = 1'b0;
            addr0 = addr;
            wmask0 = wmask;
            din0 = din;
        end else begin
            web0 = 1'b1;
            addr0 = addr;
            wmask0 = '0;
            din0 = '0;
        end

    endtask


    task write(
        input   logic   [3:0]   addr,
        input   logic   [31:0]  wmask,
        input   logic   [255:0] din
    );

        web0 = 1'b0;
        addr0 = addr;
        wmask0 = wmask;
        din0 = din;

        @(posedge clk);
        
    endtask

    task read(
        input   logic   [3:0]   addr
    );

        web0 = 1'b1;
        addr0 = addr;
        wmask0 = '0;
        din0 = '0;

        @(posedge clk);
        
    endtask

    //---------------------------------------------------------------------------------
    // TODO: Main initial block that calls your tasks, then calls $finish
    //---------------------------------------------------------------------------------

    initial begin
        reset();
        write('0, '1, '1);
        write('1, '1, '1);

        for (i = 0; i < 100000; i++) begin
            random_request.randomize();
            read_write(random_request.r_w, random_request.rand_addr, 
                       random_request.rand_wmask, random_request.rand_din);
            if (i%1000 == 0)
                $display("processing %d inst", i);
            @(posedge clk);
        end
        repeat (5) @(posedge clk);
        $display("\033[32mSimulation Passed!\033[0m");
        $finish;
    end

endmodule : top_tb
