module muxproc (
    input in0, in1, sel,
    output reg out
);
    always @(*) begin
        if (sel)
        out = in1;
        else 
        out = in0;
    end
endmodule

//testbench for 2x1 mux
module tb_muxproc;
    reg in0, in1, sel;
    wire out; 
    muxproc uut (.in0(in0), .in1(in1), .sel(sel), .out(out));
    initial begin
        $monitor("in0=%b, in1=%b, sel=%b => out=%b", in0, in1, sel, out);
        in0 = 0; in1 = 0; sel = 0; #10;
        in0 = 0; in1 = 1; sel = 0; #10;
        in0 = 1; in1 = 0; sel = 0; #10;
        in0 = 1; in1 = 1; sel = 0; #10;
        in0 = 0; in1 = 0; sel = 1; #10;
        in0 = 0; in1 = 1; sel = 1; #10;
        in0 = 1; in1 = 0; sel = 1; #10;
        in0 = 1; in1 = 1; sel = 1; #10;
        $finish;
    end
endmodule

