module Ram (
    input    [17:0]    addr,
    inout    [15:0]    data,
    input              wre,
    input              oute,
    input              hb_mask,
    input              lb_mask,
    input              chip_en
);

    reg     [15:0]    memory    [0:262143];
    reg     [15:0]    d;
    wire    [15:0]    q;

    assign q = memory[addr];
    assign data[7:0]  = (!chip_en && !oute && !lb_mask) ? q[7:0] : 8'hZZ;
    assign data[15:8] = (!chip_en && !oute && !hb_mask) ? q[15:8] : 8'hZZ;

    always @(chip_en or wre or hb_mask or lb_mask or addr or data or d) begin
        if (!chip_en && !wre) begin
            d[15:0] = memory[addr]; 
            if (!hb_mask) begin
                d[15:8] = data[15:8];
            end 
            if (!lb_mask) begin
                d[7:0] = data[7:0];
            end 
            memory[addr] = d[15:0];
        end 
    end
    
endmodule
