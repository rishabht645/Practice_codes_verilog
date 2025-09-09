module top_module( 
    input [2:0] in,
    output [1:0] out ); integer count,i; 
    initial count = 0;
    always @* begin
        
        for (i=0;i<3;i=i+1) 
            if (in[i]) count = count+1;
    end
    assign out = count;
endmodule