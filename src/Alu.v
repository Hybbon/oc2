`ifndef ALU_V
`define ALU_V

module Alu (
    input     [31:0]    a,
    input     [31:0]    b,
    output    [31:0]    aluout,
    input     [2:0]     op,
    input               unsig,
    output              overflow
);

    reg    [31:0]    aluout_reg;
    reg              overflow_reg;
    
    assign aluout = aluout_reg;
    assign overflow = overflow_reg;

    always @(*) begin
        case (op)
            3'b000:  aluout_reg = a & b;
            3'b001:  aluout_reg = a | b;
            3'b010:  aluout_reg = a + b;
            3'b100:  aluout_reg = ~(a | b);
            3'b101:  aluout_reg = a ^ b;
            3'b110:  aluout_reg = a - b;
            default: aluout_reg = 32'hXXXX_XXXX;
        endcase
        if ((op==3'b010 & a[31]==0 & b[31]==0 & aluout_reg[31]==1) ||
            (op==3'b010 & a[31]==1 & b[31]==1 & aluout_reg[31]==0) ||
            (op==3'b110 & a[31]==0 & b[31]==1 & aluout_reg[31]==1) ||
            (op==3'b110 & a[31]==1 & b[31]==0 & aluout_reg[31]==0)) begin
            overflow_reg <= 1'b1;
        end else begin
            overflow_reg <= 1'b0;
        end
    end

endmodule

`endif
