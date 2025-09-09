primitive tff(q, clk, clr);
    input clk, clr; output reg q;
    table
        //clk clr q q_next
        ?    1 : ? : 0;
        ? (10) : ? : -;
        (10) 0 : 0 : 1;
        (10) 0 : 1 : 0;
        (0?) 0 : ? : -;
    endtable
endprimitive

//testbench
module test;
    reg clk, clr; wire q;
    tff T(q, clk, clr);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("UDP_tff.vcd");
        $dumpvars(0, test);
        $monitor("clk=%b, clr=%b => q=%b", clk, clr, q);
        clr = 1; #5;
        clr = 0; #5;
        clr = 0; #5;
        clr = 0; #5;
        clr = 1; #5;
        clr = 0; #5;
        $finish;
    end
endmodule