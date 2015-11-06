`ifndef MULT_THREE
`define MULT_THREE

module Mult_3 (
    input clock,
    input reset,

    input m2_m3_oper,

    input [63:0] m2_m3_multres,
    input [4:0] m2_m3_regdest,

    input m2_m3_ispositive,
    input m2_m3_iszero,

    output reg [4:0] m3_mul_regdest,
    output reg m3_mul_writereg,
    output reg [31:0] m3_mul_wbvalue
);

wire [32:0] upper_bits;
wire [31:0] lower_bits;

assign upper_bits = m2_m3_multres[63:31];
assign lower_bits = m2_m3_multres[31:0];

always @(posedge clock or negedge reset) begin
    if (~reset) begin
        m3_mul_regdest <= 5'b00000;
        m3_mul_writereg <= 1'b0;
        m3_mul_wbvalue <= 32'h0000_0000;
    end else if (~m2_m3_oper || upper_bits != 33'h00000_0000) begin
        m3_mul_regdest <= 5'b00000;
        m3_mul_writereg <= 1'b0;
        m3_mul_wbvalue <= 32'h0000_0000;
    end else begin
        m3_mul_regdest <= m2_m3_regdest;
        m3_mul_writereg <= 1'b1;
        if (!m2_m3_ispositive) begin
            m3_mul_wbvalue <= ~lower_bits + 1;
        end else begin
            m3_mul_wbvalue <= lower_bits;
        end
    end
end

endmodule

`endif