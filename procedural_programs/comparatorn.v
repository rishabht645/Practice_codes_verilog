module compn (a,b, lt, gt, et);
    parameter n = 16;
    input [n-1:0] a,b;
    output reg lt, gt, et;

    always @(*) begin
        lt = 0; gt = 0; et = 0;
        if (a<b) lt = 1;
        else if (a>b) gt = 1;
        else 
        et = 1;
    end
endmodule
//testbench for n-bit comparator
module tb_compn;
    parameter n = 16;
    reg [n-1:0] a,b;
    //wire lt, gt, et;
    compn #(n) uut (a, b, lt, gt, et);
    initial begin
        $monitor("a=%d, b=%d => lt=%b, gt=%b, et=%b", a, b, lt, gt, et);
        a = 16'd10; b = 16'd20; #10; // a<b
        a = 16'd30; b = 16'd20; #10; // a>b
        a = 16'd15; b = 16'd15; #10; // a==b
        $finish;
    end
endmodule