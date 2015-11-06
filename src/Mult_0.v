`ifndef MULT_ZERO
`define MULT_ZERO

module Mult_0 (
    input clock,
    input reset,

    input mul_m0_oper,

    input [31:0] mul_m0_rega, // First value to be multiplied
    input [31:0] mul_m0_regb, // Second value to be multiplied
    input [4:0] mul_m0_regdest,

    output reg m0_m1_oper,

    output reg [31:0] m0_m1_rega,
    output reg [31:0] m0_m1_regb,
    output reg [4:0] m0_m1_regdest,

    output reg m0_m1_ispositive,
    output reg m0_m1_iszero
);

always @(posedge clock or negedge reset) begin
    if (~reset) begin
        m0_m1_oper <= 1'b0;
        m0_m1_rega <= 32'h0000_0000;
        m0_m1_regb <= 32'h0000_0000;
        m0_m1_regdest <= 5'b00000;
        m0_m1_ispositive <= 1'b0;
        m0_m1_iszero <= 1'b0;
    end else if (~mul_m0_oper) begin
        m0_m1_oper <= 1'b0;
        m0_m1_rega <= 32'h0000_0000;
        m0_m1_regb <= 32'h0000_0000;
        m0_m1_regdest <= 5'b00000;
        m0_m1_ispositive <= 1'b0;
        m0_m1_iszero <= 1'b0;
    end else begin
        m0_m1_oper <= 1'b1;
        m0_m1_rega <= mul_m0_rega;
        m0_m1_regb <= mul_m0_regb;
        m0_m1_regdest <= mul_m0_regdest;
        
        if (mul_m0_rega === 32'h0000_0000 || mul_m0_regb === 32'h0000_0000) begin
            m0_m1_iszero <= 1'b1;
        end else begin
            m0_m1_iszero <= 1'b0;
        end

        if ($signed(mul_m0_rega) < 32'sh0000_0000 || $signed(mul_m0_regb) < 32'sh0000_0000 &&
            !($signed(mul_m0_rega) < 32'sh0000_0000 && $signed(mul_m0_regb) < 32'sh0000_0000)) begin
            m0_m1_ispositive <= 1'b0;
        end else begin
            m0_m1_ispositive <= 1'b1;
        end

    end
end


endmodule

`endif