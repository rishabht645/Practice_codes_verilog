//primitive sum
primitive udp_sum(sum,a,b,cin);
    input a,b,cin;
    output sum;
    table
        //a b c : sum
          0 0 0 : 0;
          0 0 1 : 1;
          0 1 0 : 1;
          0 1 1 : 0;
          1 0 0 : 1;
          1 0 1 : 0;
          1 1 0 : 0;
          1 1 1 : 1;
    endtable
endprimitive
//primitive carry
primitive udp_carry(cout,a,b,cin);
    input a,b,cin;
    output cout;
    table
        //a b c : cout
          0 0 ? : 0;
          0 ? 0 : 0;
          ? 0 0 : 0;
          ? 1 1 : 1;
          1 ? 1 : 1;
          1 1 ? : 1;
    endtable
endprimitive

module fulladder (
    input a,b,cin, output sum,cout
);
    udp_sum U1(sum,a,b,cin);
    udp_carry U2(.a(a),.b(b),.cin(cin),.cout(cout));
endmodule

module test;
    reg a,b,cin; wire sum,cout;
    fulladder S(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
    $monitor("a=%b, b=%b, cin=%b => sum=%b, cout=%b", a,b,cin,sum,cout);
    a = 0; b = 1; cin = 1; #5;
    a = 1; b = 1; cin = 1; #5;
    a = 0; b = 0; cin = 1; #5;
    end
endmodule
