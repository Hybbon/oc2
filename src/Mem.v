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

    assign mem_wb_oper = m3_wb_oper;
    assign mem_wb_regdest = m3_wb_regdest;
    assign mem_wb_writereg = m3_wb_writereg;
    assign mem_wb_wbvalue = m3_wb_wbvalue;

    wire m0_m1_oper;
    wire m0_m1_readmem;
    wire m0_m1_writemem;
    wire m0_m1_writereg;

    wire [31:0] m0_m1_data_addr;
    wire [31:0] m0_m1_regb;
    wire [4:0] m0_m1_regdest;

    wire m1_m2_oper;
    wire [4:0] m1_m2_regdest;
    wire m1_m2_writereg;
    wire [31:0] m1_m2_wbvalue;

    reg m2_m3_oper;
    reg [4:0] m2_m3_regdest;
    reg m2_m3_writereg;
    reg [31:0] m2_m3_wbvalue;

    reg m3_wb_oper;
    reg [4:0] m3_wb_regdest;
    reg m3_wb_writereg;
    reg [31:0] m3_wb_wbvalue;

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

        .m1_m2_oper(m1_m2_oper),
        .m1_m2_regdest(m1_m2_regdest),
        .m1_m2_writereg(m1_m2_writereg),
        .m1_m2_wbvalue(m1_m2_wbvalue)
    );

    always @(posedge clock or negedge reset) begin
        // AluMisc_2
        if (~reset) begin
            m2_m3_oper <= 1'b0;  
            m2_m3_regdest <= 5'b00000;
            m2_m3_writereg <= 1'b0;
            m2_m3_wbvalue <= 32'h0000_0000;
        end else if (~m1_m2_oper) begin
            m2_m3_oper <= 1'b0;  
            m2_m3_regdest <= 5'b00000;
            m2_m3_writereg <= 1'b0;
            m2_m3_wbvalue <= 32'h0000_0000;
        end else begin
            m2_m3_oper <= 1'b1;
            m2_m3_regdest <= m1_m2_regdest;
            m2_m3_writereg <= m1_m2_writereg;
            m2_m3_wbvalue <= m1_m2_wbvalue;
        end
        // AluMisc_3
        if (~reset) begin
            m3_wb_oper <= 1'b0;
            m3_wb_regdest <= 5'b00000;
            m3_wb_writereg <= 1'b0;
            m3_wb_wbvalue <= 32'h0000_0000;
        end else if (~m2_m3_oper) begin
            m3_wb_oper <= 1'b0;
            m3_wb_regdest <= 5'b00000;
            m3_wb_writereg <= 1'b0;
            m3_wb_wbvalue <= 32'h0000_0000;
        end else begin
            m3_wb_oper <= 1'b1;
            m3_wb_regdest <= m2_m3_regdest;
            m3_wb_writereg <= m2_m3_writereg;
            m3_wb_wbvalue <= m2_m3_wbvalue;
        end
    end
endmodule

`endif
