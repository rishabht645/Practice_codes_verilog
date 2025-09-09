module ram_1 (
    input [9:0] add_bus, inout [7:0] data,  input rd,wr,cs,clk
);
    reg [7:0] mem [1023:0]; reg [7:0] d_out;

    assign data = (cs && rd)? d_out:8'bz;       

    always @(posedge clk ) begin
        if (cs && rd && !wr) d_out = mem[add_bus];
    end

    always @(posedge clk ) begin
        if (cs && wr && !rd) mem[add_bus] = data;

    end
endmodule
