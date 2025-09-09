module counter4 (
    input clk, reset,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset)
        count <= 0;
        else
        count <= count+1'b1;
    end
endmodule

//testbench for 4-bit counter
module tb_counter4;
    reg clk, reset;
    wire [7:0] count;
    counter4 uut (.clk(clk), .reset(reset), .count(count));
    initial begin
        $dumpfile("tb_counter4.vcd");
        $dumpvars(0,tb_counter4);
        $monitor($time , "reset=%b, count=%d", reset, count);
        clk = 0; reset = 1; #10;
        reset = 0; #180;

        $finish;
    end
    always #5 clk = ~clk; // clock generator
endmodule