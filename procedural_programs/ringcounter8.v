module ringcounter(clk, count);
    input clk;
    output reg [7:0] count ;

    initial begin
    count = 8'h80;
    end
    always @(posedge clk ) begin
            
            count <= count << 1;
            count[0] <= count[7]; 
    end
endmodule

//testbench for ring counter
module ring_test;
    reg clk; wire [7:0] count;
    ringcounter R(clk, count);
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    
    end
    initial begin
        $monitor($time, "count = %b", count);
        
        #160 $finish;
    end
endmodule