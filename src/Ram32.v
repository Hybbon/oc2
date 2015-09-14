module Ram (
    input    [7:0]    addr,
    inout    [31:0]    data,
    input              wre,
    input              chip_en
);

    reg     [31:0]    memory    [0:255];
    wire    [31:0]    q;

    assign q = memory[addr];
    assign data[31:0]  = (!chip_en) ? q[31:0] : 32'hZZZZZZZZ;

    always @(chip_en or wre or addr or data) begin
        if (!chip_en && !wre) begin
            memory[addr] = data[31:0];
        end 
    end
    
endmodule
