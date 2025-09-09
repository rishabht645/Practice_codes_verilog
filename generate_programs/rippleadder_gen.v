module adder16bit (
    input [N-1:0] a, b, input cin,
    output [N-1:0] sum, output [N:0] carry, output cout
);
    parameter N = 16;
    assign carry[0] = cin;
    assign cout = carry[N];
    genvar i; 
    generate
        for (i=0; i<N; i=i+1) begin : label
            wire t1, t2, t3, t4;
            and #(0) G1(t1, a[i], b[i]);
            and #(0) G2(t2, carry[i], b[i]);
            and #(0) G3(t3, a[i], carry[i]);
            or  #(0) G4(carry[i+1], t1, t2, t3);
            xor #(0) G5a(t4, a[i], b[i]);
            xor #(0) G5b(sum[i], t4, carry[i]);
        end
    endgenerate   
endmodule

module addertest;
    reg [N-1:0] A,B; reg cin;
    wire [N:0] carry;
    wire [N-1:0] sum;
    wire cout;
    parameter N = 16;

    adder16bit uut(.a(A),.b(B),.cin(cin),.sum(sum),.carry(carry),.cout(cout));
    initial begin
        $dumpfile("test2.vcd");
        $dumpvars(0, addertest);
        $monitor("A=%h,B=%h, sum=%h, cout=%b", A,B,sum,cout);
        #5 cin = 1'b0; A = 16'h0; B = 16'h0;
        #5 A = 16'hFFFF; B = 16'h1;
        #5 A = 16'h7FFF; B = 16'h0001; 
        #5 A = 16'hFF2A; B = 16'hAAAA;
        #5 $finish;
    end
endmodule