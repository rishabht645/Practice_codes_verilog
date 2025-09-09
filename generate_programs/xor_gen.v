module xorN (

    input [N-1:0] a,b,
    output [N-1:0] f
);
    parameter N = 16;
    genvar p;
    generate
        for (p=0; p<N; p=p+1) begin : label
            xor X(f[p], a[p], b[p]);
        end
    endgenerate
endmodule

module generate_test;
parameter N = 16;
reg [N-1:0] a, b;
wire [N-1:0] out;

xorN G (.f(out), .a(a), .b(b));

initial
   begin
      $monitor ("a: %b, b: %b, out: %b", a, b, out);

      a = 16'haaaa;   b = 16'h00ff;
      #10 a = 16'h0f0f;   b = 16'h3333;
      #20 $finish;
   end
endmodule
