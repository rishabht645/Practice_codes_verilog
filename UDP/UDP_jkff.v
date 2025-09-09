primitive jkff(q, j,k,clk,clr);
    input j,k,clk,clr; output reg q;
    table
        //j k clk clr q q_next
        ? ? ? 1   : ? : 0;
        ? ? ? (10): ? : -;
        0 0 (10) 0: ? : -;
        0 1 (10) 0: ? : 0;
        1 0 (10) 0: ? : 1;
        1 1 (10) 0: 0 : 1;
        1 1 (10) 0: 1 : 0;
        ? ? (0?) 0: ? : -;
        ? ? ?    0: ? : -;

    endtable
endprimitive

module test_jk;
    reg j,k,clk,clr; wire q;
    jkff J(q,j,k,clk,clr);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("test_jk.vcd");
        $dumpvars(0, test_jk);
        $monitor($time,"j=%b, k=%b, clk=%b, clr=%b => q=%b", j,k,clk,clr,q);
        #2j = 0; k = 0; clr = 1; #5;
        j = 0; k = 0; clr = 0; #5;
        j = 1; k = 0; clr = 0; #5;
        j = 1; k = 0; clr = 0; #5;
        j = 0; k = 1; clr = 0; #5;
        j = 1; k = 1; clr = 0; #5;
        j = 0; k = 0; clr = 0; #5;
        $finish;
    end
endmodule 
