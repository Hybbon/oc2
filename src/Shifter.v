`ifndef SHIFTER_V
`define SHIFTER_V

module Shifter (
    input     [31:0]     in,
    input     [1:0]      shiftop,
    input     [4:0]      shiftamt,
    output    [31:0]     result
);

    reg    [31:0]    result_reg;

    assign result = result_reg;

    always @(*) begin
        case (shiftop)
            2'b00:   result_reg <= in >> shiftamt;
            2'b01:   result_reg <= $signed(in) >>> shiftamt;
            2'b10:   result_reg <= in << shiftamt;
            default: result_reg <= 32'hXXXX_XXXX;
        endcase
    end

endmodule

`endif
