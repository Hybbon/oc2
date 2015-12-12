`ifndef MEM_V
`define MEM_V

`include "./src/Mem_0.v"
`include "./src/Mem_1.v"

module Mem (
    input clock,
    input reset,

    // Operation signal
    input iss_mem_oper,

    // Read or write?
    input iss_mem_readmem,
    input iss_mem_writemem,

    // LOAD $regb, IMM($rega)
    // STORE $regb, IMM($rega)
    // Register value and immediate value, to be added in order to form the
    // full address.
    input [31:0] iss_mem_rega,
    input [31:0] iss_mem_imedext,

    // Value to be written
    input [31:0] iss_mem_regb,

    // Determines whether to write back data from Memory or Execute
    // (unnecessary)
    // input                   iss_mem_selwsource,

    // Forwarded to Writeback
    input [4:0] iss_mem_regdest,
    input iss_mem_writereg,
    // Data to be saved: yet to be determined. There's no reason to have that
    // as an input anymore (you could get it from Execute before)
    // input         [31:0]    iss_mem_wbvalue,

    output [4:0] mem_wb_regdest,
    output mem_wb_writereg,
    output [31:0] mem_wb_wbvalue,

    // Used for ram initialization - asynch, global
    input mem_ram_load,

    output mem_wb_oper
);

    assign mem_wb_oper = mem_wb_writereg;

    wire m0_m1_oper;
    wire m0_m1_readmem;
    wire m0_m1_writemem;
    wire m0_m1_writereg;

    wire [31:0] m0_m1_data_addr;
    wire [31:0] m0_m1_regb;
    wire [4:0] m0_m1_regdest;

    Mem_0 MEM_0 (
        .clock(clock),
        .reset(reset),

        .mem_m0_oper(iss_mem_oper),
        .mem_m0_readmem(iss_mem_readmem),
        .mem_m0_writemem(iss_mem_writemem),
        .mem_m0_rega(iss_mem_rega),
        .mem_m0_imedext(iss_mem_imedext),
        .mem_m0_regb(iss_mem_regb),
        .mem_m0_regdest(iss_mem_regdest),
        .mem_m0_writereg(iss_mem_writereg),

        .m0_m1_oper(m0_m1_oper),
        .m0_m1_readmem(m0_m1_readmem),
        .m0_m1_writemem(m0_m1_writemem),
        .m0_m1_data_addr(m0_m1_data_addr),
        .m0_m1_regb(m0_m1_regb),
        .m0_m1_regdest(m0_m1_regdest),
        .m0_m1_writereg(m0_m1_writereg)
    );

    Mem_1 MEM_1 (
        .clock(clock),
        .reset(reset),
        .mem_ram_load(mem_ram_load),

        .m0_m1_oper(m0_m1_oper),
        .m0_m1_readmem(m0_m1_readmem),
        .m0_m1_writemem(m0_m1_writemem),
        .m0_m1_data_addr(m0_m1_data_addr),
        .m0_m1_regb(m0_m1_regb),
        .m0_m1_regdest(m0_m1_regdest),
        .m0_m1_writereg(m0_m1_writereg),

        .m1_mem_regdest(mem_wb_regdest),
        .m1_mem_writereg(mem_wb_writereg),
        .m1_mem_wbvalue(mem_wb_wbvalue)
    );

endmodule

`endif
