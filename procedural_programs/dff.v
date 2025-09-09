module dff (
    input d, clk, clr,
    output reg q, qnot
);
    always @(negedge clk ) begin
        if (~clr) 
        q = 1'b0;
        else
        q = d;
        qnot = ~d;
    end
endmodule

//testbench for dff
`timescale 10ns/1ns
module dfftest;
    reg d, clk, clr;
    wire q, qnot;
    dff D (.d(d), .clk(clk), .clr(clr), .q(q), .qnot(qnot));

    initial clk=1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile ("dff.vcd");
        $dumpvars (0,dfftest);
        $monitor ($time," d=%b, clk=%b, clr=%b => q=%b, qnot=%b", d, clk, clr, q, qnot);
        d=0; clr=1; #10;
        d=1; clr=1; #10;
        d=0; clr=1; #10;
        d=1; clr=1; #10;
        $finish;
    end
endmodule