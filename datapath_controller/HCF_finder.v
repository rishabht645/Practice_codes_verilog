module pipo (
    output reg [15:0] aout, input [15:0] a, input clk, lda
);
    initial aout = 0;
    always @(posedge clk ) begin
        if (lda) aout <= a;
    end
endmodule

module subtractor (
    output reg [15:0] subout, input [15:0] a, b
);
    always @(*) begin
        subout = a - b;
    end
endmodule

module comp (
    output lt,gt,et, input [15:0] aout, bout
);
    assign lt = aout < bout; assign gt = aout > bout; assign et = (aout == bout);
endmodule

module mux (
    output [15:0] out, input [15:0] in1, in2, input sel
);   
    assign out = sel ? in1:in2;
endmodule

module datapath_hcf (result1,result2, lt,gt,et, lda,ldb,sel1,sel2,sel_in,clk, data_in);
    output [15:0] result1,result2; output lt,gt,et; input lda,ldb,sel1,sel2,sel_in,clk; input [15:0] data_in;
    wire [15:0] aout, bout, a,b,subout, data; assign result1 = aout, result2 = bout;
    pipo A(aout, data, clk, lda);
    pipo B(bout, data, clk, ldb);
    subtractor S(subout, a, b);
    comp C(lt,gt,et,aout,bout);
    mux M0(a, aout, bout, sel1);
    mux M1(b, aout, bout, sel2);
    mux M2(data, subout, data_in, sel_in);
endmodule

module control_hcf (st,lda, ldb, sel1, sel2, sel_in, done, start, lt,gt,et,clk);
    output reg lda,ldb,sel1,sel2,sel_in, done; input start, lt,gt,et,clk; output [2:0] st;
    reg [2:0] state; reg [15:0] aout,bout;
    parameter s0 = 0,s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5; assign st = state;
    always @(posedge clk ) begin
        case (state)
                s0 : if (start) state <= s1;
                s1 : state <= s2;
                s2 : #2 if (et) state <= s5;
                    else if (lt) state <= s3;
                    else if (gt) state <= s4;

                s3 : #2 if (et) state <= s5;
                    else if (lt) state <= s3;
                    else if (gt) state <= s4;

                s4: #2 if (et) state <= s5;
                    else if (lt) state <= s3;
                    else if (gt) state <= s4;              
    
                s5 : state <= s5;
            default: state <= s0;
        endcase
    end

    always @(state) begin
        
        case (state)
                s0 : begin lda = 0; ldb = 0; sel1 = 0; sel2 = 0; sel_in = 0; done = 0; end
                s1 : begin lda = 1; ldb = 0; sel1 = 0; sel2 = 0; sel_in = 0; done = 0; end
                s2 : begin lda = 0; ldb = 1; sel1 = 0; sel2 = 0; sel_in = 0; done = 0; end
                s3 : begin lda = 0; ldb = 1; sel1 = 0; sel2 = 1; sel_in = 1; done = 0; end 
                s4 : begin lda = 1; ldb = 0; sel1 = 1; sel2 = 0; sel_in = 1; done = 0; end
                s5 : begin lda = 0; ldb = 0; sel1 = 0; sel2 = 0; sel_in = 0; done = 1; end
            default: begin lda = 0; ldb = 0; sel1 = 0; sel2 = 0; sel_in = 0; done = 0; end
        endcase 
    end
endmodule

module hcf_testbench;
    wire done; reg [15:0] data_in; reg clk,start; wire [15:0] result1,result2; wire [2:0] st;
    datapath_hcf DH(result1, result2, lt,gt,et, lda,ldb,sel1,sel2,sel_in,clk, data_in);
    control_hcf CH(st,lda, ldb, sel1, sel2, sel_in, done, start, lt,gt,et,clk);
    initial begin
        clk = 0;
        #3 start = 1;
        #100 $finish;
    end
always #5 clk=~clk;
    initial begin
        $dumpfile("hcf_finder.vcd");
        $dumpvars(0,hcf_testbench);
        #17 data_in=7;
        #10 data_in=3;
        $monitor($time, "%d %d %b", result1, result2, done);
    end
endmodule
