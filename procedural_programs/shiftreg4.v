module shiftreg (
    input clk, clr, A, output reg E
);
    reg B,C,D;
    always @(posedge clk ) begin
        if (clr) begin
            B<=0; C<=0; D<=0; E<=0;
        end
        else begin
            B <= A;
            C <= B;
            D <= C;
            E <= D;
        end
    end
endmodule

module shift_test;
    reg clk, clr, a; wire e; 
    shiftreg S(clk, clr, a, e);
    initial begin
        clk = 0; #2 clr = 1; #5 clr = 0;
        forever #5 clk = ~clk;
    end
    initial begin #2;
        repeat (2) begin
            #10 a=1; #10 a=0; #10 a=1; #10 a=0;
        end

    end
    initial begin
        $dumpfile("shift_test.vcd");
        $dumpvars(0, shift_test);
        #200 $finish;
    end
endmodule