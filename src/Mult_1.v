`ifndef MULT_ONE
`define MULT_ONE

module Mult_1 (
    input clock,
    input reset,

    input m0_m1_oper,

    input [31:0] m0_m1_rega, // First value to be multiplied
    input [31:0] m0_m1_regb, // Second value to be multiplied
    input [4:0] m0_m1_regdest,

    input m0_m1_ispositive,
    input m0_m1_iszero,

    output reg m1_m2_oper,

    output reg [31:0] m1_m2_rega,
    output reg [31:0] m1_m2_regb,    
    output reg [4:0] m1_m2_regdest,

    output reg m1_m2_ispositive,
    output reg m1_m2_iszero
);


always @(posedge clock or negedge reset) begin
    if (~reset) begin
        m1_m2_oper <= 1'b0;
        m1_m2_rega <= 32'h0000_0000;
        m1_m2_regb <= 32'h0000_0000;
        m1_m2_regdest <= 5'b00000;
        m1_m2_ispositive <= 1'b0;
        m1_m2_iszero <= 1'b0;
    end else if (~m0_m1_oper) begin
        m1_m2_oper <= 1'b0;
        m1_m2_rega <= 32'h0000_0000;
        m1_m2_regb <= 32'h0000_0000;
        m1_m2_regdest <= 5'b00000;
        m1_m2_ispositive <= 1'b0;
        m1_m2_iszero <= 1'b0;
    end else begin
        m1_m2_oper <= 1'b1;
        m1_m2_regdest <= m0_m1_regdest;
        m1_m2_iszero <= m0_m1_iszero;
        m1_m2_ispositive <= m0_m1_ispositive;

        if ($signed(m0_m1_rega) < 32'sh0000_0000) begin
            m1_m2_rega <= ~m0_m1_rega + 32'h0000_0001;
        end else begin
            m1_m2_rega <= m0_m1_rega;
        end

        if ($signed(m0_m1_regb) < 32'sh0000_0000) begin
            m1_m2_regb <= ~m0_m1_regb + 32'h0000_0001;
        end else begin
            m1_m2_regb <= m0_m1_regb;
        end

    end
end



endmodule

`endif