module sequencedetector (
    input a,clk, output reg y
);
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
    reg [1:0] state;
    always @(posedge clk) begin
    case (state)
       s0 : begin
            y <= 0; state <= a ? s1:s0;
       end 
       s1 : begin
            y <= 0; state <= a ? s2:s0;
       end 
       s2 : begin
            y <= a? 1:0; state <= a ? s3:s0;

       end 
       s3 : begin
            y <= a? 1:0; state <= a ? s3:s0;
       end 
        default: begin 
            y<=0 ; state <= s0;
       end
    endcase       
    end

endmodule

//testbench for sequence detector
module tb_sequencedetector;
    reg a, clk;
    wire y;
    
    sequencedetector uut (.a(a), .clk(clk), .y(y));
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("tb_sequencedetector.vcd");
        $dumpvars(0,tb_sequencedetector);
        
        // Initial display
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 0; #10; 
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 0; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 0; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 1; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        a = 0; #10;
        $display("Time=%0t, a=%b, y=%b", $time, a, y);
        
        #10 $finish;
    end
endmodule
