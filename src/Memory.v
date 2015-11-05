`ifndef MEMORY_V
`define MEMORY_V

`include "./src/Mem_0.v"
`include "./src/Mem_1.v"

module Memory (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_mem_readmem,
    input                   ex_mem_writemem,
    input         [31:0]    ex_mem_regb,
    input                   ex_mem_selwsource,
    input         [4:0]     ex_mem_regdest,
    input                   ex_mem_writereg,
    input         [31:0]    ex_mem_wbvalue,
    //Writeback
    output reg    [4:0]     mem_wb_regdest,
    output reg              mem_wb_writereg,
    output reg    [31:0]    mem_wb_wbvalue,
    // Used for ram initialization
    input mem_ram_load
);

    wire [6:0] addr_mem_0;
    wire wre_mem_0;

    Mem_0 data_ram_0 (
        .clock(clock),
        .reset(reset),
        .ex_mem_wbvalue(ex_mem_wbvalue),
        .ex_mem_readmem(ex_mem_readmem),
        .ex_mem_writemem(ex_mem_writemem),
        .addr_out(addr_mem_0),
        .wre_out(wre_mem_0)
    );

    Mem_1 data_ram_1 (
        .clock(clock),
        .reset(reset),
        .addr(addr_mem_0),
        .data_in(ex_mem_regb),
        .wre(wre_mem_0),
        .instr_load(1'b0),
        .data_load(mem_ram_load),
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue)
        .ex_mem_regdest(ex_mem_regdest),
        .ex_mem_writereg(ex_mem_writereg),
        .ex_mem_selwsource(ex_mem_selwsource),
        .ex_mem_wbvalue(ex_mem_wbvalue)
    );

endmodule

`endif
