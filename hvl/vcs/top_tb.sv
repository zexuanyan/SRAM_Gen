module top_tb;
    //---------------------------------------------------------------------------------
    // Waveform generation.
    //---------------------------------------------------------------------------------
    initial begin
        $fsdbDumpfile("dump.fsdb");
        if ($test$plusargs("NO_DUMP_ALL_ECE411")) begin
            $fsdbDumpvars(0, dut, "+all");
            $fsdbDumpoff();
        end else begin
            $fsdbDumpvars(0, "+all");
        end
    end

    //---------------------------------------------------------------------------------
    // TODO: Declare cache port signals:
    //---------------------------------------------------------------------------------

    logic           clk0,csb0,web0; // web0: 0 for write, 1 for read
    logic   [3:0]   addr0;
    logic   [31:0]  wmask0;
    logic   [255:0] din0,dout0;

    //---------------------------------------------------------------------------------
    // TODO: Generate a clock:
    //---------------------------------------------------------------------------------

    always #1ns clk0 = ~clk0;

    //---------------------------------------------------------------------------------
    // TODO: Write a task to generate reset:
    //---------------------------------------------------------------------------------

    task reset();
        clk0 = 1'b0;
        csb0 = 1'b0;
        web0 = 1'b1;
        wmask0 = '0;
        din0 = '0;
        addr0 = '0;
    endtask

    //---------------------------------------------------------------------------------
    // TODO: Instantiate the DUT and physical memory:
    //---------------------------------------------------------------------------------

    mp_cache_data_array dut(.*);
    //---------------------------------------------------------------------------------
    // TODO: Write tasks to test various functionalities:
    //---------------------------------------------------------------------------------

    task write(
        input   logic   [3:0]   addr,
        input   logic   [31:0]  wmask,
        input   logic   [255:0] din
    );

        web0 = 1'b0;
        addr0 = addr;
        wmask0 = wmask;
        din0 = din;

        @(posedge clk0);
        
    endtask

    task read(
        input   logic   [3:0]   addr
    );

        web0 = 1'b1;
        addr0 = addr;
        wmask0 = '0;
        din0 = '0;

        @(posedge clk0);
        
    endtask

    //---------------------------------------------------------------------------------
    // TODO: Main initial block that calls your tasks, then calls $finish
    //---------------------------------------------------------------------------------

    initial begin
        reset();
        write('0, '1, '1);
        write('1, '1, '1);
        repeat (5) @(posedge clk0);
        $finish;
    end

endmodule : top_tb
