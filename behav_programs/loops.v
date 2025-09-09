// method 1
module whileloop ;
    integer i;
    reg [5:0] data ;
    initial begin
    for (i=0; i<= 10; i = i+1)
    if (i%2==0) begin
        data[i] = 1'b0;
    end
    else 
        data[i] = 1'b1;
    $display("data is: %b", data);
    end
endmodule

//method 2
module oddeven ;
    integer i; reg [5:0] data;
    initial begin
        for (i=0; i<=4; i=i+2)
        data[i] = 1'b0;
        for (i=1; i<=5; i=i+2)
        data[i] = 1'b1;
        $display("data is: %b", data);
    end
endmodule