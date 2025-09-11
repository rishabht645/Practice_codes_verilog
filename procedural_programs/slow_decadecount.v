module slow_decade_counter (
    input clk,slowena,reset, output reg [3:0] q
);
    always @(posedge clk ) begin
        if(reset | (slowena & q==9)) q<=0;
        else begin 
            if (slowena) q <= q+1;
            else q <= q;
        end
    end
endmodule 