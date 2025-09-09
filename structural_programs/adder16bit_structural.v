module fulladder (
    input a, b, cin,
    output sum, cout
);
    wire a1, a2, a3, w1;

    and #(0) G1(a1, a, b);
    and #(0) G2(a2, cin, b);
    and #(0) G3(a3, a, cin);
    or  #(0) G4(cout, a1, a2, a3);
    xor #(0) G5a(w1, a, b);
    xor #(0) G5b(sum, w1, cin);
endmodule

module adder4bit (
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);
   wire [2:0] t;

   fulladder F0(a[0], b[0], cin, sum[0], t[0] );
   fulladder F1(a[1], b[1], t[0], sum[1], t[1] );
   fulladder F2(a[2], b[2], t[1], sum[2], t[2] );
   fulladder F3(a[3], b[3], t[2], sum[3], cout );
endmodule

module adder16bit (
    input [15:0] a, b,
    output [15:0] sum, 
    output cout, carry, zero, sign, parity, overflow
);
    assign carry = cout; 
    assign zero = sum == 16'h0000 ? 1'b1 : 1'b0;
    assign sign = sum[15];
    assign parity = ~^sum;
    assign overflow = (a[15] & b[15] & ~sum[15]) | (~a[15] & ~b[15] & sum[15]);

    wire [2:0] c;
    adder4bit A0(a[3:0], b[3:0], 1'b0, sum[3:0], c[0]);
    adder4bit A1(a[7:4], b[7:4], c[0], sum[7:4], c[1]);
    adder4bit A2(a[11:8], b[11:8], c[1], sum[11:8], c[2]);
    adder4bit A3(a[15:12], b[15:12], c[2], sum[15:12], cout);
endmodule

module addertest;
    reg [15:0] A,B;
    wire [15:0] Y;
    wire carry, zero, sign, parity, overflow;

    adder16bit uut(A, B, Y, cout, carry, zero, sign, parity, overflow);
    initial begin
        $dumpfile("test2.vcd");
        $dumpvars(0, addertest);
        $monitor("A=%h, B=%h, Y=%h, cout=%b, carry=%b, zero=%b, sign=%b, parity=%b, overflow=%b", A, B, Y, cout, carry, zero, sign, parity, overflow);
        #5 A = 16'h0; B = 16'h0;
        #5 A = 16'hFFFF; B = 16'h1;
        #5 A = 16'h7FFF; B = 16'h0001; 
        #5 A = 16'hFF2A; B = 16'hAAAA;
        #5 $finish;
    end
endmodule






















