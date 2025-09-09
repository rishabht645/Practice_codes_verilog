module add (out, a,b);
    input [15:0] a,b; output reg [15:0] out;
    always @(*) begin
        out = a + b;
    end
endmodule

module pipo1 (dout, din,clk,ld);
    input [15:0] din; input clk, ld; output reg [15:0] dout;
    always @(posedge clk ) begin
        if (ld) dout <= din;
    end
endmodule

module pipo2 (dout, clk,clr,ld,din);
    input clk, clr, ld; input [15:0] din; output reg [15:0] dout;
    always @(posedge clk ) begin
        if (clr) dout <= 16'b0;
        else if (ld) dout <= din;
    end
endmodule

module dcount (dout, clk,dec,ld,din);
    input clk, dec, ld; input [15:0] din; output reg [15:0] dout;
    always @(posedge clk ) begin
        if (ld) dout <= din;
        else if (dec) dout <= dout - 1;
    end
endmodule

module eqzb (eqz, in);
    input [15:0] in; output eqz;
    assign eqz = (in == 0);
endmodule

module multiplier (result,eqz, lda,ldb,ldp,clrp,dec,clk,data_in);
    input lda, ldb, ldp, clrp, dec, clk; input [15:0] data_in; output eqz; output [15:0] result;
    wire [15:0] t1,t2,t3, bout, bus;
    assign bus=data_in; assign result = t2;
    add add(t3,t1,t2);
    pipo1 A(t1,bus, clk, lda);
    pipo2 P(t2,clk, clrp, ldp, t3);
    dcount B(bout,clk, dec, ldb, bus);
    eqzb Comp(eqz, bout);
endmodule

module fsm_control (lda,ldb,ldp,clrp,dec,done, clk,start,eqz);
    input clk, start, eqz; output reg lda, ldb, ldp, clrp, dec, done;
    reg [2:0] state;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4;
    always @(posedge clk ) begin
        case (state)
          s0 : #2 if (start) state <= s1;
          s1 : state <= s2;
          s2 : state <= s3; 
          s3 : #2 if(eqz) state <=s4;
          s4 : state <= s4;
      default: state <= s0;
        endcase
    end

    always @(state) begin
        case (state)
        s0 : #1 begin lda = 0; ldb = 0; ldp = 0; clrp = 0; dec = 0; done = 0;end
        s1 : #1 begin lda = 1; end
        s2 : #1 begin lda = 0; ldb = 1; clrp = 1; end
        s3 : #1 begin ldb = 0; clrp = 0; ldp = 1; dec = 1; end
        s4 : #1 begin ldp = 0; dec = 0; done = 1; end 
    default: #1 begin lda = 0; ldb = 0; ldp = 0; clrp = 0; dec = 0; done = 0; end
        endcase
    end
endmodule

module mul_test;
    reg clk, start; reg [15:0] data_in; wire [15:0] result; wire done;
    multiplier M(result,eqz, lda,ldb,ldp,clrp,dec,clk,data_in);
    fsm_control F(lda,ldb,ldp,clrp,dec,done, clk,start,eqz);
initial begin 
 clk=1'b0;
 #3 start=1'b1;
 #100 $finish;
 end

always #5 clk=~clk;

initial begin 
#17 data_in=17;
#10 data_in=5;
end
initial begin
$monitor ($time," %d %b",M.t2,done);
$dumpfile("mul.vcd");
$dumpvars(0,mul_test);
end
endmodule 











