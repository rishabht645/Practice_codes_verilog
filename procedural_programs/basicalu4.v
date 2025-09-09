module alu4 (
    input [1:0] control,
    input [7:0] a,b,
    output reg [15:0] out
);
    parameter add = 2'b00, sub = 2'b01, mul = 2'b10, div = 2'b11;
    always @(*) begin
        case (control)
           add : out = a+b;
           sub : out = a-b;
           mul : out = a*b;
           div : out = a/b;
        endcase
    end
endmodule

//testbench for 4-bit ALU
module tb_alu4;
    reg [1:0] control;
    reg [7:0] a,b;
    wire [15:0] out;
    alu4 uut (.control(control), .a(a), .b(b), .out(out));
    initial begin
        $monitor("control=%b, a=%d, b=%d => out=%d", control, a, b, out);
        a = 8'd15; b = 8'd3; control = 2'b00; #10; // add
        a = 8'd15; b = 8'd3; control = 2'b01; #10; // sub
        a = 8'd15; b = 8'd3; control = 2'b10; #10; // mul
        a = 8'd15; b = 8'd3; control = 2'b11; #10; // div
        a = 8'd20; b = 8'd4; control = 2'b00; #10; // add
        a = 8'd20; b = 8'd4; control = 2'b01; #10; // sub
        a = 8'd20; b = 8'd4; control = 2'b10; #10; // mul
        a = 8'd20; b = 8'd4; control = 2'b11; #10; // div
        $finish;
    end
endmodule
