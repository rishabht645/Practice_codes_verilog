module mux16 (
    input [15:0] in,
    input [3:0] sel,
    output y
);
    assign y = in[sel];
endmodule

//testbench
`timescale 10ns/1ns
module muxtest;
reg [15:0] A;     reg [3:0] S;     wire F;

mux16 M (.in(A), .sel(S), .y(F));

initial
begin
    $monitor ($time," A=%b, S=%b, F=%b", A,S,F);
    #5 A=16'h3f0a; S=4'h0;
    #5 S=4'h1;
    #5 S=4'h6;
    #5 S=4'hc;
    #5 $finish;
end
endmodule
