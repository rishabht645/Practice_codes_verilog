module alu (zout,rs1,rs2,rd,func,addr,clk1,clk2);
    input [3:0] rs1,rs2,rd,func; 
    input [7:0] addr; 
    input clk1,clk2; 
    output [15:0] zout;
    
    reg [15:0] l12_a,l12_b,l23_z,l34_z;
    reg [3:0] l12_rd,l23_rd,l12_func;
    reg [7:0] l12_addr,l23_addr,l34_addr;
    
    reg [15:0] regbank [15:0];
    reg [15:0] memory [255:0];

    assign zout = l34_z;

    //stage 1
    always @(posedge clk1 ) begin
        l12_a <= regbank[rs1];
        l12_b <= regbank[rs2];
        l12_rd <= rd;
        l12_func <= func;
        l12_addr <= addr;
    end

    //stage 2
    always @(posedge clk2 ) begin
        case (l12_func)
                 0 : l23_z <= l12_a + l12_b;
                 1 : l23_z <= l12_a - l12_b;   
                 2 : l23_z <= l12_a * l12_b; 
                 3 : l23_z <= l12_a;
                 4 : l23_z <= l12_b;
                 5 : l23_z <= l12_a & l12_b;
                 6 : l23_z <= l12_a | l12_b;
                 7 : l23_z <= l12_a ^ l12_b;
                 8 : l23_z <= ~l12_a;
                 9 : l23_z <= ~l12_b;
                10 : l23_z <= l12_a >> 1;
                11 : l23_z <= l12_a << 1;
            default: l23_z <= 16'hxxxx;
        endcase
        l23_rd <= l12_rd;
        l23_addr <= l12_addr;
    end

    // stage 3
    always @(posedge clk1 ) begin
        regbank[l23_rd] <= l23_z;
        l34_z <= l23_z;
        l34_addr <= l23_addr;
    end

    // stage 4
    always @(posedge clk2) begin
        memory[l34_addr] <= l34_z;
    end
endmodule

module alu_test;
    wire [15:0] zout; reg [3:0] rs1,rs2,rd,func; reg [7:0] addr; reg clk1,clk2; integer i;
    alu A(zout,rs1,rs2,rd,func,addr,clk1,clk2);
    initial begin
        clk1 = 0; clk2 = 0;
        repeat (20) begin
            #5 clk1 = 1; #5 clk1 = 0;
            #5 clk2 = 1; #5 clk2 = 0;
        end
    end

    initial begin
        for (i=0;i<16 ;i=i+1 ) begin
            A.regbank[i] = i;
        end
    end

    initial begin
        #4 rs1 = 3; rs2 = 5; rd = 10; func = 0; addr = 125;
        #20 rs1 = 3; rs2 = 8; rd = 11; func = 2; addr = 126;
        #20 rs1 = 4; rs2 = 2; rd = 12; func = 4; addr = 127;
        #20 rs1 = 0; rs2 = 1; rd = 13; func = 7; addr = 128;
        #20 rs1 = 5; rs2 = 5; rd = 14; func = 2; addr = 129;
    
        #40 for (i = 125;i<130 ;i=i+1) begin
            $display($time, " memory[%3d] = %3d", i, A.memory[i]);
            end
    end
    
    initial begin
        $dumpfile("alu_pipeline.vcd");
        $dumpvars(0,alu_test);
        $monitor($time, " %d", zout);
        #300 $finish;
    end
endmodule
