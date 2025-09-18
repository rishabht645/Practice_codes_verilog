module machine (
    input [N-1:0] A,B,C,D, input clk, output [N-1:0] F
);
    parameter N = 16;
    reg [N-1:0] L12_x1,L12_x2,L12_D,L23_x3,L23_D,L34_F;

    assign F = L34_F;
    always @(posedge clk ) begin
        L12_x1 <= #4 A + B;
        L12_x2 <= #4 C - D;
        L12_D <= D; //stage 1

        L23_x3 <= #4 L12_x1 + L12_x2;
        L23_D <= L12_D; //stage 2

        L34_F <= #6 L23_x3 * L23_D; //stage 3

    end
endmodule

module test_pipe;
    reg [N-1:0] A,B,C,D; reg clk; wire [N-1:0] F; parameter N = 16;

    machine M(A,B,C,D,clk,F);

    initial begin
        clk = 0;
    end
    always #10 clk = ~clk;

    initial
    begin
        #5   A = 10; B = 12; C = 6;  D = 3;  // F = 75
        #20  A = 10; B = 10; C = 5;  D = 3;  // F = 66
        #20  A = 20; B = 11; C = 1;  D = 4;  // F = 112
        #20  A = 15; B = 10; C = 8;  D = 2;  // F = 62
        #20  A = 8;  B = 15; C = 5;  D = 0;  // F = 0
        #20  A = 10; B = 20; C = 5;  D = 3;  // F = 66
        #20  A = 10; B = 10; C = 30; D = 1;  // F = 49
        #20  A = 30; B = 1;  C = 2;  D = 4;  // F = 116
    end

    initial
    begin
        $dumpfile ("pipe1.vcd");
        $dumpvars (0, test_pipe);
        $monitor ("Time: %d, F = %d", $time, F);
        #300 $finish;
    end
endmodule

