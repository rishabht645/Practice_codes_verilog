module parityfsm (
    input a, clk, output reg y
);
    reg state;
    parameter even = 0, odd = 1;
    always @(posedge clk) begin
        case (state)
        even   : begin
            y <= a? 1:0; state <= a? odd:even;
        end
        odd   : begin
            y <= a? 0:1; state <= a? even:odd;
        end
            default: state <= even;
        endcase
    end
endmodule

module test_parity;
    reg clk,a; wire y;
    parityfsm P(a,clk,y);
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("test_parity.vcd");
        $dumpvars(0, test_parity);
        a=0; #10 a=1; #10 a=0; #10 a=0; #10 a=1; #10 a=1; #10 a=0; #10 a=1; #10 a=0; #10 a=1; #10 a=0; #10;
        #120 $finish;
    end
endmodule