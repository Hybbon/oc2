`ifndef MULT_TWO
`define MULT_TWO

module Mult_2 (
    input clock,
    input reset,

    input m1_m2_oper,

    input [31:0] m1_m2_rega, // First value to be multiplied
    input [31:0] m1_m2_regb, // Second value to be multiplied
    input [4:0] m1_m2_regdest,

    input m1_m2_ispositive,
    input m1_m2_iszero,

    output reg m2_m3_oper,

    output reg [63:0] m2_m3_multres,
    output reg [4:0] m2_m3_regdest,

    output reg m2_m3_ispositive,
    output reg m2_m3_iszero
);

always @(posedge clock or negedge reset) begin
    if (~reset) begin
        m2_m3_oper <= 1'b0;
        m2_m3_multres <= 64'h00000000_00000000;
        m2_m3_regdest <= 5'b00000;
        m2_m3_ispositive <= 1'b0;
        m2_m3_iszero <= 1'b0;
    end else if (~m1_m2_oper) begin
        m2_m3_oper <= 1'b0;
        m2_m3_multres <= 64'h00000000_00000000;
        m2_m3_regdest <= 5'b00000;
        m2_m3_ispositive <= 1'b0;
        m2_m3_iszero <= 1'b0;
    end else begin
        m2_m3_oper <= 1'b1;
        m2_m3_multres <= m1_m2_rega * m1_m2_regb;
        m2_m3_regdest <= m1_m2_regdest;
        m2_m3_ispositive <= m1_m2_ispositive;
        m2_m3_iszero <= m1_m2_iszero;
    end
end

endmodule

`endif