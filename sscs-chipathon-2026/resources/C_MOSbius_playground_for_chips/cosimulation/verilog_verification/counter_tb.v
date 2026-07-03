`timescale 1ns/1ns

module counter_tb;
    reg clk = 0;
    wire [3:0] count;

    /* Make a reset pulse and specify dump file */
    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        #0 clk = 0;
        #2 clk = 1;
        #1024 $finish;
    end

    /* Make a regular pulsing clock. */
    always #1 clk = !clk;

    counter  co(.clk(clk), .count(count));
endmodule
