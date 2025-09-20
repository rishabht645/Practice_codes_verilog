module bcdcounter9 (
    input clk,reset,enable, output reg [3:0] count
);
    always @(posedge clk ) begin
        if (reset | (enable & count ==9)) count <=0;
        else begin
            if (enable) count <= count +1;
            else count <= count;
        end
    end
endmodule

module bcdcounter5 (
    input clk,reset,enable, output reg [3:0] count
);
    always @(posedge clk ) begin
        if (reset | (enable & count ==5)) count <=0;
        else begin
            if (enable) count <= count +1;
            else count <= count;
        end
    end
endmodule

module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    wire [4:1] enable;
    bcdcounter9 B0(.clk(clk),.reset(reset),.enable(ena),.count(ss[3:0]));
    bcdcounter5 B1(.clk(clk),.reset(reset),.enable(enable[1]),.count(ss[7:4]));
    bcdcounter9 B2(.clk(clk),.reset(reset),.enable(enable[2]),.count(mm[3:0]));
    bcdcounter5 B3(.clk(clk),.reset(reset),.enable(enable[3]),.count(mm[7:4]));

    assign enable = {(ena&&mm==8'h59&&ss==8'h59),(ena&&ss==8'h59&&mm[3:0]==9),(ena && ss==8'h59),(ena && ss[3:0]==9)};


    always @(posedge clk) begin
        if(reset) begin
        	hh <= 8'h;    //hh=
            pm <= 0;
        end
        else begin
            if(enable[4] && (mm == 8'h59) && (ss == 8'h59)) begin    //if mm=59 and ss=59
                if(hh == 8'h)  hh <= 8'h1; //hh changes:AM->1AM or PM->1PM  
            	else if(hh == 8'h11) begin  //if hh=11, PM->AM or AM->PM
            		hh[3:0] <= hh[3:0] + 1'h1; //hh=
               		pm <= ~pm;
                end 
                else begin
                    if(hh[3:0] == 4'h9) begin
                        hh[3:0] <= 4'h0;
                        hh[7:4] <= hh[7:4] + 1'h1;
                    end
                    else hh[3:0] = hh[3:0] + 1'h1;
                end
            end
            else hh <= hh;
        end
    end


endmodule


