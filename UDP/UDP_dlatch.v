primitive dlatch(q, clk, clr, d);
    input clk, clr, d;
    output reg q;

    table
        //clk clr d : q : q_next
        ? 1 ? : ? : 0;
        1 0 0 : ? : 0;
        1 0 1 : ? : 1;
        0 0 ? : ? : -;
    endtable
endprimitive

//testbench
module test;
    reg clk, clr, d; wire q;
    dlatch D(q, clk, clr, d);
    initial begin
        $monitor("clk=%b, clr=%b, d=%b => q=%b", clk, clr, d, q);
        clk = 0; clr = 0; d = 0; #5;
        clk = 1; clr = 0; d = 1; #5;
        clk = 0; clr = 0; d = 0; #5;
        clk = 1; clr = 1; d = 1; #5;
        clk = 0; clr = 0; d = 1; #5;
        clk = 1; clr = 0; d = 0; #5;
    end
endmodule