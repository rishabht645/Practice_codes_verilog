module mux_d (in1,in2,clk,sel,q);
    input in1,in2,clk,sel; output reg q; wire mux_out;
    assign mux_out = (sel) ? in1:in2;
    always @(posedge clk ) begin
        q <= mux_out;
    end
endmodule


module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q
    wire t;
	mux_d M0(.in1(SW[0]),.in2(LEDR[2]),.clk(KEY[0]),.sel(KEY[1]),.q());
    mux_d M1(.in1(SW[1]),.in2(LEDR[0]),.clk(KEY[0]),.sel(KEY[1]),.q());
    mux_d M2(.in1(SW[2]),.in2(t),.clk(KEY[0]),.sel(KEY[1]),.q());
    assign t = LEDR[1] ^ LEDR[2];
endmodule
