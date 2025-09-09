module mux2to1 (
  input [1:0] in,
  input sel,
  output out
);
  wire t1, t2;
  wire sel_n;   

  not G0(sel_n, sel);        
  and #(0) G1(t1, in[0], sel_n);  
  and #(0) G2(t2, in[1], sel);    
  or  #(0) G3(out, t1, t2);       
endmodule

//structural description of mux4to1
module mux4to1 (
  input [3:0] in4,
  input [1:0] sel4,
  output out4
);
  wire [1:0] t;

  mux2to1 M0(.in(in4[1:0]), .sel(sel4[0]), .out(t[0]));
  mux2to1 M1(.in(in4[3:2]), .sel(sel4[0]), .out(t[1]));
  mux2to1 M2(.in(t), .sel(sel4[1]), .out(out4));
endmodule

//structural description of mux16to1
module mux16to1 (
  input [15:0] in16,
  input [3:0] sel16,
  output out16
);
  wire [3:0] t;
  mux4to1 M0(.in4(in16[3:0]), .sel4(sel16[1:0]), .out4(t[0]));
  mux4to1 M1(.in4(in16[7:4]), .sel4(sel16[1:0]), .out4(t[1]));
  mux4to1 M2(.in4(in16[11:8]), .sel4(sel16[1:0]), .out4(t[2]));
  mux4to1 M3(.in4(in16[15:12]), .sel4(sel16[1:0]), .out4(t[3]));
  mux4to1 M4(.in4(t), .sel4(sel16[3:2]), .out4(out16));
endmodule

//testbench for mux16to1
`timescale 10ns/1ns
module muxtest;
reg [15:0] A;     reg [3:0] S;     wire F;

mux16to1 M (.in16(A), .sel16(S), .out16(F));

initial
begin
    $dumpfile ("mux16to1.vcd");
    $dumpvars (0,muxtest);
    $monitor ($time," A=%h, S=%h, F=%b", A,S,F);
    #5 A=16'h3f0a; S=4'h0;
    #5 S=4'h1;
    #5 S=4'h6;
    #5 S=4'hc;
    #5 $finish;
end
endmodule

 
