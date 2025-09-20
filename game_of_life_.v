module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q); 
    integer i,j; 
    reg [15:0] r [15:0]; 
    
    integer neighbours;
    integer prev_j, next_j, prev_i, next_i;
    
    always @(posedge clk ) begin 
        if (load) begin
            q <= data;

            for (j=0; j<16; j=j+1) begin
                r[j] <= data[255-16*j-:16];
            end 
        end
        else begin
            for (j=0; j<16; j=j+1) begin
                for (i=0; i<16; i=i+1) begin

                    prev_j = (j == 0) ? 15 : j - 1;
                    next_j = (j == 15) ? 0 : j + 1;
                    prev_i = (i == 0) ? 15 : i - 1;
                    next_i = (i == 15) ? 0 : i + 1;
                    

                    neighbours = r[prev_j][prev_i] + r[prev_j][i] + r[prev_j][next_i] +
                               r[j][prev_i] + r[j][next_i] +
                               r[next_j][prev_i] + r[next_j][i] + r[next_j][next_i];
                    

                    if (neighbours < 2) begin
                        r[j][i] <= 1'b0;
                    end
                    else if (neighbours > 3) begin
                        r[j][i] <= 1'b0;
                    end
                    else if (neighbours == 2) begin
                        r[j][i] <= r[j][i]; 
                    end
                    else if (neighbours == 3) begin
                        r[j][i] <= 1'b1; 
                    end
                end
            end
            
            end
            
            q <= {r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7],
                  r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]};
        end

endmodule

module gol_test;
    reg clk,load; reg [255:0] data; wire [255:0] q;
    top_module T(clk, load, data, q);

    task display_matrix;
    integer i;
    begin
        $display("256-bit Vector as 16x16 Matrix:");
        for (i = 0; i < 16; i = i + 1) begin
            $display($time, " Row %2d: %16b", i, q[255-i*16 -: 16]);
        end
    end
    endtask

    initial begin
        clk = 0; load = 1; data = 32'b0; data[50] = 1'b1; data[51] = 1'b1; data[52] = 1'b1; data[53] = 1'b1; 
        data[67] = 1'b1; data[68] = 1'b1; data[35] = 1'b1; data[36] = 1'b1;
        #15 load = 0;
    end
    always #10 clk = ~clk;
    initial begin
            #360 $finish;
        end 

    always @(posedge clk) begin
    display_matrix;
    end

endmodule