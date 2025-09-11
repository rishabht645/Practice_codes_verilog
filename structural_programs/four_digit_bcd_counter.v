module bcdcount(
    input clk, reset, enable, output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset | (count==9&enable)) count<=0;
        else begin
            if (enable) count <= count+1;
            else count<=count;
        end
    end
endmodule




module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    wire [3:0] w0,w1,w2,w3;
    bcdcount B0(.clk(clk),.reset(reset),.enable(1'b1),.count(w0));
    bcdcount B1(.clk(clk),.reset(reset),.enable(ena[1]),.count(w1));
    bcdcount B2(.clk(clk),.reset(reset),.enable(ena[2]),.count(w2));
    bcdcount B3(.clk(clk),.reset(reset),.enable(ena[3]),.count(w3));
    assign q = {w3,w2,w1,w0};
    assign ena[1] = w0==4'd9, ena[2] = (w0==4'd9)&(w1==4'd9), ena[3] = (w0==4'd9)&(w1==4'd9)&(w2==4'd9);

endmodule

//testbench
module tb();
    reg clk, reset; wire [15:0] q; wire [3:1] ena;
    top_module DUT(.clk(clk),.reset(reset),.ena(ena),.q(q));
    initial begin
        clk=0; reset=1; #10;
        reset=0; #2000;
        $finish;
    end
    always #5 clk = ~clk;
    initial begin
        $dumpfile("four_digit_bcd_counter.vcd");
        $dumpvars(0,tb);
    end
endmodule   


