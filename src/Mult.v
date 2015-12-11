`ifndef MULT_V
`define MULT_V

`include "./src/Mult_0.v"
`include "./src/Mult_1.v"
`include "./src/Mult_2.v"
`include "./src/Mult_3.v"

module Mult (
    input clock,
    input reset,

    input iss_mul_oper, // 1 if an instruction is issued to this functional unit
                        // at this cycle
    input [31:0] iss_mul_rega, // First value to be multiplied
    input [31:0] iss_mul_regb, // Second value to be multiplied
    input [4:0] iss_mul_regdest,

    output [4:0] mul_wb_regdest,
    output mul_wb_writereg,
    output [31:0] mul_wb_wbvalue,

    output mul_wb_oper
);

assign mul_wb_oper = mul_wb_writereg;

wire m0_m1_oper;
wire m1_m2_oper;
wire m2_m3_oper;

wire m0_m1_ispositive;
wire m1_m2_ispositive;
wire m2_m3_ispositive;

wire m0_m1_iszero;
wire m1_m2_iszero;
wire m2_m3_iszero;

wire [31:0] m0_m1_rega;
wire [31:0] m1_m2_rega;

wire [31:0] m0_m1_regb;
wire [31:0] m1_m2_regb;

wire [4:0] m0_m1_regdest;
wire [4:0] m1_m2_regdest;
wire [4:0] m2_m3_regdest;

wire [63:0] m2_m3_multres;


Mult_0 MULT_0(
    .clock(clock),
    .reset(reset),
    
    .mul_m0_oper(iss_mul_oper),
    .mul_m0_rega(iss_mul_rega),
    .mul_m0_regb(iss_mul_regb),
    .mul_m0_regdest(iss_mul_regdest),

    .m0_m1_oper(m0_m1_oper),
    .m0_m1_rega(m0_m1_rega),
    .m0_m1_regb(m0_m1_regb),
    .m0_m1_regdest(m0_m1_regdest),
    .m0_m1_ispositive(m0_m1_ispositive),
    .m0_m1_iszero(m0_m1_iszero)
);

Mult_1 MULT_1(
    .clock(clock),
    .reset(reset),

    .m0_m1_oper(m0_m1_oper),
    .m0_m1_rega(m0_m1_rega),
    .m0_m1_regb(m0_m1_regb),
    .m0_m1_regdest(m0_m1_regdest),
    .m0_m1_ispositive(m0_m1_ispositive),
    .m0_m1_iszero(m0_m1_iszero),

    .m1_m2_oper(m1_m2_oper),
    .m1_m2_rega(m1_m2_rega),
    .m1_m2_regb(m1_m2_regb),    
    .m1_m2_regdest(m1_m2_regdest),
    .m1_m2_ispositive(m1_m2_ispositive),
    .m1_m2_iszero(m1_m2_iszero)
);

Mult_2 MULT_2(
    .clock(clock),
    .reset(reset),

    .m1_m2_oper(m1_m2_oper),
    .m1_m2_rega(m1_m2_rega),
    .m1_m2_regb(m1_m2_regb),
    .m1_m2_regdest(m1_m2_regdest),
    .m1_m2_ispositive(m1_m2_ispositive),
    .m1_m2_iszero(m1_m2_iszero),

    .m2_m3_oper(m2_m3_oper),
    .m2_m3_multres(m2_m3_multres),
    .m2_m3_regdest(m2_m3_regdest),
    .m2_m3_ispositive(m2_m3_ispositive),
    .m2_m3_iszero(m2_m3_iszero)
);

Mult_3 MULT_3(
    .clock(clock),
    .reset(reset),

    .m2_m3_oper(m2_m3_oper),
    .m2_m3_multres(m2_m3_multres),
    .m2_m3_regdest(m2_m3_regdest),
    .m2_m3_ispositive(m2_m3_ispositive),
    .m2_m3_iszero(m2_m3_iszero),

    .m3_mul_regdest(mul_wb_regdest),
    .m3_mul_writereg(mul_wb_writereg),
    .m3_mul_wbvalue(mul_wb_wbvalue)
);

endmodule

`endif