module fsm (
    input a, clk, reset, output reg b
);
    reg [1:0] PS, NS;
    parameter s0=0, s1=1, s2=2, s3=3;

    always @(posedge clk or posedge reset) begin
        if (reset) PS <=0;
        else PS <= NS;
    end

    always @(PS,a) begin
        case (PS)
          s0 : begin b<=0; NS <= a? s0:s1; end
          s1 : begin b<=0; NS <= a? s2:s1; end
          s2 : begin b<=0; NS <= a? s3:s1; end
          s3 : begin b<= a?0:1; NS <= a? s0:s1; end
            default: NS <= s0;
        endcase
    end

endmodule

//testbench for sequence detector
module test_sequence;
   reg clk, a, reset;   wire b;

   fsm SEQ (a, clk, reset, b);

   initial
      begin
         $dumpfile ("sequence.vcd");   $dumpvars (0, test_sequence);
         clk = 1'b0;   reset = 1'b1;
         #15 reset = 1'b0;
      end

   always #5 clk = ~clk;

   initial
      begin
         #12 a = 0;   #10 a = 0;   #10 a = 1;   #10 a = 1;
         #10 a = 0;   #10 a = 1;   #10 a = 1;   #10 a = 0;
         #10 a = 0;   #10 a = 1;   #10 a = 1;   #10 a = 0;
         #10 $finish;
      end
endmodule
