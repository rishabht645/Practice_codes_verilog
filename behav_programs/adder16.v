module adder16 (
    input [15:0] a,b,
    output [15:0] sum,
    output carry
);
    assign {carry,sum} = a + b;

endmodule

module addertest;
    reg [15:0] A,B;
    wire [15:0] Y;
    wire carry;

    adder16 uut(A, B, Y, carry);
    initial begin
        
        $dumpvars(0, addertest);
        $monitor("A=%h, B=%h, Y=%h, carry=%b", A, B, Y, carry);
        #5 A = 16'h0; B = 16'h0;
        #5 A = 16'hFFFF; B = 16'h1;
        #5 A = 16'h7FFF; B = 16'h0001; 
        #5 A = 16'hFF2A; B = 16'hAAAA;
        #5 $finish;
    end
endmodule
