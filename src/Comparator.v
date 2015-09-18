`ifndef COMPARATOR_V
`define COMPARATOR_V

module Comparator (
    input     [31:0]    a,
    input     [31:0]    b,
    input     [2:0]     op,
    output              compout
);

    reg compout_reg;

    assign compout = compout_reg;

    always @(*) begin
        case (op)
            3'b000:  compout_reg <= a == b;
            3'b001:  compout_reg <= $signed(a) >= $signed(b);
            3'b010:  compout_reg <= $signed(a) <= $signed(b);
            3'b011:  compout_reg <= $signed(a) > $signed(b);
            3'b100:  compout_reg <= $signed(a) < $signed(b);
            3'b101:  compout_reg <= a !=b;
            default: compout_reg <= 1'bX;
        endcase
    end

endmodule

`endif
