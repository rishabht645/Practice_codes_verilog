module top_module( 
    input [N-1:0] in,
    output [N-1:0] out
);
    parameter N = 8;
	genvar i;
    generate
        for (i=0; i<=N-1; i=i+1) begin: label
        assign out[i] = in[N-1-i];
        end
    endgenerate

endmodule

module testbenchie;
    parameter N = 8;
    reg [N-1:0] in; wire [N-1:0] out;
    top_module T(in,out);
        initial begin
        in = 8'b11110000;
        $monitor("in=%b, out=%b", in,out);
    end
endmodule