// UDP Definition (in separate file or same file)
primitive udp_and (out, in1, in2);
    output out;
    input in1, in2;
    
    table
        // in1 in2 : out
           0   ?  :  0;
           ?   0  :  0;
           1   1  :  1;
    endtable
endprimitive

// Module that instantiates UDP
module test_module;
    reg a, b;
    wire y;
    
    // Instantiate UDP - similar to gate instantiation
    udp_and u1(y, a, b);  // instance_name(output, input1, input2)
    
    initial begin
        $monitor("a=%b,b=%b,y=%b", a,b,y);
        a = 0; b = 0; #5;
        a = 0; b = 1; #5;
        a = 1; b = 0; #5;
        a = 1; b = 1; #5;
        $finish;
    end
endmodule

