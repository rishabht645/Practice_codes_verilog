module register  (
    output reg [15:0] out, input [15:0] in, input a15,lda,sfta,clra,clk
);
    always @(posedge clk ) begin
        if (clra) out <= 16'b0;
        else if (lda) out <= in;
        else if (sfta)  out <= {a15,out[15:1]};
    end
endmodule

module registerM (
    output reg [15:0] mout, input [15:0] m_in, input ldm,clk
);
    always @(posedge clk ) begin
        if (ldm) mout <= m_in;
    end
endmodule

module dff (
    output reg q_out, input d,clk,clrff
);
    always @(posedge clk ) begin
        if (clrff) q_out <= 0;
        else q_out <= d;
    end
endmodule

module alu (
    output reg [15:0] aluout, input [15:0] in1,in2, input addsub
);
    always @(*) begin
        if (addsub) aluout <= in1 + in2;
        else aluout <= in1 - in2;
    end
endmodule

module counter (
    output reg [4:0] count, input ldc,dec, clk
);
    always @(posedge clk ) begin
        if (ldc) count <= 5'b10000;
        else if (dec) count <= count - 1;
    end
endmodule

module twoscomp (
    output reg [31:0] actual_result, input [31:0] result
);
    initial begin
            #250 if (result[31]) actual_result <= (~(result) + 1);
            else actual_result <= result;
    end
endmodule

module data_path (actual_result,result,q0,qm1,count,lda,ldq,ldm,clra,clrq,clrff,sfta,sftq,addsub,data_in,ldc,dec,clk);
    output q0,qm1; output [4:0] count; input lda,ldq,ldm,clra,clrq,clrff,sfta,sftq,addsub,clk,ldc,dec; wire [15:0] aluout;input [15:0]data_in;
    wire [15:0] mout; wire [15:0] a,q; wire q_out; wire [4:0] count; output [31:0] result,actual_result; 
    assign q0 = q[0], qm1 = q_out; assign result = {a,q}; 
    register A(a, aluout,a[15], lda, sfta, clra, clk);
    register Q(q, data_in,a[0], ldq, sftq, clrq, clk);
    registerM M(mout, data_in, ldm, clk);
    dff D(q_out,q[0],clk,clrff);
    alu alu(aluout, a, mout,addsub);
    counter C(count, ldc, dec, clk); 
    twoscomp T(actual_result, result); 
endmodule

module control_path (st,lda,ldq,ldm,done,clra,clrq,clrff,sfta,sftq,addsub,ldc,dec,q0,qm1,clk,start,count);
    reg [2:0] state; output reg lda,ldq,ldm,done,clra,clrq,clrff,sfta,sftq,addsub,ldc,dec; input q0,qm1,clk,start; input [4:0] count;
    parameter s0 = 0,s1 = 1, s2 = 2,s3 = 3, s4 = 4, s5 = 5, s6 = 6; output [2:0] st; assign st = state;
    always @(posedge clk ) begin
        case (state)
                s0 : state <= (start) ? s1:s0;
                s1 : state <= s2;
                s2 : #2 if ({q0,qm1} == 2'b01) state <= s3;
                     else if ({q0,qm1} == 2'b10) state <= s4;
                     else if (q0^qm1 == 0) state <= s5;
                s3 : state <= s5;
                s4 : state <= s5;
                s5 : #2 if ({q0,qm1} == 2'b01 && count !==0) state <= s3;
                     else if ({q0,qm1} == 2'b10 && count !==0) state <= s4;
                     else if (q0^qm1 == 0 && count !==0) state <= s5;
                     else if (count == 0) state <= s6;
                s6 : state <= s6;
            default: state <= s0;
        endcase
    end

    always @(state) begin
        case (state)
                s0 : begin lda=0;ldq=0;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=0;ldc=0;dec=0; end
                s1 : begin lda=0;ldq=0;ldm=1;done=0;clra=1;clrq=1;clrff=1;sfta=0;sftq=0;addsub=0;ldc=1;dec=0; end
                s2 : begin lda=0;ldq=1;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=0;ldc=0;dec=0; end
                s3 : begin lda=1;ldq=0;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=1;ldc=0;dec=0; end
                s4 : begin lda=1;ldq=0;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=0;ldc=0;dec=0; end
                s5 : begin lda=0;ldq=0;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=1;sftq=1;addsub=0;ldc=0;dec=1; end
                s6 : begin lda=0;ldq=0;ldm=0;done=1;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=0;ldc=0;dec=0; end
            default: begin lda=0;ldq=0;ldm=0;done=0;clra=0;clrq=0;clrff=0;sfta=0;sftq=0;addsub=0;ldc=0;dec=0; end
        endcase
    end
endmodule



module mul_testbench;
    reg clk,start; reg [15:0] data_in; wire [4:0] count; wire [31:0] result,actual_result; wire [2:0] st;
    data_path DP(actual_result,result,q0,qm1,count,lda,ldq,ldm,clra,clrq,clrff,sfta,sftq,addsub,data_in,ldc,dec,clk);
    control_path CP(st,lda,ldq,ldm,done,clra,clrq,clrff,sfta,sftq,addsub,ldc,dec,q0,qm1,clk,start,count);

    initial begin
        clk = 0;
        #3 start = 1;
        #300 $finish;
    end
    always #5 clk = ~clk;
    initial begin
        $dumpfile("booth_mul.vcd");
        $dumpvars(0,mul_testbench);
        #17 data_in = 3;
        #10 data_in = -30;
        $monitor($time, "%d %b", actual_result,done);
    end
endmodule
