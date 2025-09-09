module updowncount (
    input mode, clk, clr, ld,
    input [7:0] d_in,
    output reg [7:0] count
);
    always @(posedge clk) begin
        if (clr) count <= 8'b0;
        else if (ld) count <= d_in;
        else if (mode) count <= count + 1;
        else count <= count - 1;
    end
endmodule

//testbench for updowncounter

module test_updown;
    reg mode, clk, clr, ld;
    reg [7:0] d_in;
    wire [7:0] count;

    updowncount U(mode, clk, clr, ld, d_in, count);
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("updowncounter8.vcd");
        $dumpvars(0, test_updown);
       $monitor($time, " mode = %b, clr=%b, ld=%b,d_in=%d => count = %d", mode, clr, ld, d_in, count); 

       mode = 1'b1; clr = 1'b1; ld = 1'b0; d_in = 8'd100; #20;
       clr = 1'b0; #100;
       mode = 1'b0; #100;
       ld = 1'b1; #100;
       clr = 1'b1; #20;
       $finish;

    end
endmodule 

