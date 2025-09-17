module mips32 (
    input write, clk, reset, input [4:0] sr1,sr2,wr,
    input [31:0] writereg, 
    output [31:0] readreg1,readreg2
);
    reg [31:0] regbank [31:0];  integer i;
    assign readreg1 = regbank[sr1];
    assign readreg2 = regbank[sr2];

    always @(posedge clk ) begin
        if (reset) begin
            for (i =0 ;i<32 ;i=i+1 ) begin
                regbank[i] <= 0;
            end
        end
        else begin
            if (write) regbank[wr] = writereg;
        end
    end
endmodule

module reg_test;
    reg clk,write,reset;
    reg [4:0] sr1,sr2,wr; 
    reg [31:0] writereg; 
    wire [31:0] readreg1,readreg2;
    integer i;

    mips32 M(write, clk, reset, sr1,sr2,wr,writereg,readreg1,readreg2);
    initial begin
        clk=0;
    end
    always #5 clk = ~clk;
    initial begin
        #1 reset = 1; write = 0;
        #5 reset = 0;
    end
    initial begin
        #7 for (i=0;i<32 ;i=i+1 ) begin
            wr = i; writereg = i*10; write = 1;
            #10 write = 0; 
        end
                   
    #20 for (i = 0;i<32 ;i=i+2 ) begin
        sr1=i; sr2=i+1;
        #5;
        $display("reg[%2d] = %d, reg[%2d] = %d", sr1, readreg1, sr2, readreg2);
    end
    $dumpfile("regbank.vcd");
    $dumpvars(0,reg_test);
    #1000 $finish;
    end
endmodule