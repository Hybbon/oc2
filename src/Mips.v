`ifndef MIPS_V
`define MIPS_V

`include "./src/Fetch.v"
`include "./src/Decode.v"
`include "./src/Execute.v"
`include "./src/Memory.v"
`include "./src/Writeback.v"
`include "./src/Registers.v"

module Mips (
    input clock,
    input reset,
    input [4:0] reg_out_id,
    output [31:0] reg_out_data
);

    wire              ex_if_stall;
    wire    [31:0]    if_id_nextpc;
    wire    [31:0]    if_id_instruc;
    wire              id_if_selpcsource;
    wire    [31:0]    id_if_rega;
    wire    [31:0]    id_if_pcimd2ext;
    wire    [31:0]    id_if_pcindex;
    wire    [1:0]     id_if_selpctype;
    wire              ex_mem_readmem;
    wire              ex_mem_writemem;
    wire    [31:0]    ex_mem_regb;
    wire              ex_mem_selwsource;
    wire    [4:0]     ex_mem_regdest;
    wire              ex_mem_writereg;
    wire    [31:0]    ex_mem_wbvalue;
    wire    [4:0]     mem_wb_regdest;
    wire              mem_wb_writereg;
    wire    [31:0]    mem_wb_wbvalue;
    wire              id_ex_selalushift;
    wire              id_ex_selimregb;
    wire    [2:0]     id_ex_aluop;
    wire              id_ex_unsig;
    wire    [1:0]     id_ex_shiftop;
    wire    [4:0]     id_ex_shiftamt;
    wire    [31:0]    id_ex_rega;
    wire              id_ex_readmem;
    wire              id_ex_writemem;
    wire    [31:0]    id_ex_regb;
    wire    [31:0]    id_ex_imedext;
    wire              id_ex_selwsource;
    wire    [4:0]     id_ex_regdest;
    wire              id_ex_writereg;
    wire              id_ex_writeov;
    wire    [4:0]     id_reg_addra;
    wire    [4:0]     id_reg_addrb;
    wire    [31:0]    reg_id_dataa;
    wire    [31:0]    reg_id_datab;
    wire    [31:0]    reg_id_ass_dataa;
    wire    [31:0]    reg_id_ass_datab;
    wire              wb_reg_en;
    wire    [4:0]     wb_reg_addr;
    wire    [31:0]    wb_reg_data;

    Fetch FETCH(
        .clock(clock),
        .reset(reset),
        .ex_if_stall(ex_if_stall),
        .if_id_nextpc(if_id_nextpc),
        .if_id_instruc(if_id_instruc),
        .id_if_selpcsource(id_if_selpcsource),
        .id_if_rega(id_if_rega),
        .id_if_pcimd2ext(id_if_pcimd2ext),
        .id_if_pcindex(id_if_pcindex),
        .id_if_selpctype(id_if_selpctype)
    );

    Decode DECODE(
        .clock(clock),
        .reset(reset),
        .if_id_instruc(if_id_instruc),
        .if_id_nextpc(if_id_nextpc),
        .id_if_selpcsource(id_if_selpcsource),
        .id_if_rega(id_if_rega),
        .id_if_pcimd2ext(id_if_pcimd2ext),
        .id_if_pcindex(id_if_pcindex),
        .id_if_selpctype(id_if_selpctype),
        .id_ex_selalushift(id_ex_selalushift),
        .id_ex_selimregb(id_ex_selimregb),
        .id_ex_aluop(id_ex_aluop),
        .id_ex_unsig(id_ex_unsig),
        .id_ex_shiftop(id_ex_shiftop),
        .id_ex_shiftamt(id_ex_shiftamt),
        .id_ex_rega(id_ex_rega),
        .id_ex_readmem(id_ex_readmem),
        .id_ex_writemem(id_ex_writemem),
        .id_ex_regb(id_ex_regb),
        .id_ex_imedext(id_ex_imedext),
        .id_ex_selwsource(id_ex_selwsource),
        .id_ex_regdest(id_ex_regdest),
        .id_ex_writereg(id_ex_writereg),
        .id_ex_writeov(id_ex_writeov),
        .id_reg_addra(id_reg_addra),
        .id_reg_addrb(id_reg_addrb),
        .reg_id_dataa(reg_id_dataa),
        .reg_id_datab(reg_id_datab),
        .reg_id_ass_dataa(reg_id_ass_dataa),
        .reg_id_ass_datab(reg_id_ass_datab)
    );

    Execute EXECUTE(
        .clock(clock),
        .reset(reset),
        .id_ex_selalushift(id_ex_selalushift),
        .id_ex_selimregb(id_ex_selimregb),
        .id_ex_aluop(id_ex_aluop),
        .id_ex_unsig(id_ex_unsig),
        .id_ex_shiftop(id_ex_shiftop),
        .id_ex_shiftamt(id_ex_shiftamt),
        .id_ex_rega(id_ex_rega),
        .id_ex_readmem(id_ex_readmem),
        .id_ex_writemem(id_ex_writemem),
        .id_ex_regb(id_ex_regb),
        .id_ex_imedext(id_ex_imedext),
        .id_ex_selwsource(id_ex_selwsource),
        .id_ex_regdest(id_ex_regdest),
        .id_ex_writereg(id_ex_writereg),
        .id_ex_writeov(id_ex_writeov),
        .ex_if_stall(ex_if_stall),
        .ex_mem_readmem(ex_mem_readmem),
        .ex_mem_writemem(ex_mem_writemem),
        .ex_mem_regb(ex_mem_regb),
        .ex_mem_selwsource(ex_mem_selwsource),
        .ex_mem_regdest(ex_mem_regdest),
        .ex_mem_writereg(ex_mem_writereg),
        .ex_mem_wbvalue(ex_mem_wbvalue)
    );

    Memory MEMORY(
        .clock(clock),
        .reset(reset),
        .ex_mem_readmem(ex_mem_readmem),
        .ex_mem_writemem(ex_mem_writemem),
        .ex_mem_regb(ex_mem_regb),
        .ex_mem_selwsource(ex_mem_selwsource),
        .ex_mem_regdest(ex_mem_regdest),
        .ex_mem_writereg(ex_mem_writereg),
        .ex_mem_wbvalue(ex_mem_wbvalue),
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue)
    );

    Writeback WRITEBACK(
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue),
        .wb_reg_en(wb_reg_en),
        .wb_reg_addr(wb_reg_addr),
        .wb_reg_data(wb_reg_data)
    );

    Registers REGISTERS(
        .clock(clock),
        .reset(reset),
        .addra(id_reg_addra),
        .dataa(reg_id_dataa),
        .ass_dataa(reg_id_ass_dataa),
        .addrb(id_reg_addrb),
        .datab(reg_id_datab),
        .ass_datab(reg_id_ass_datab),
        .enc(wb_reg_en),
        .addrc(wb_reg_addr),
        .datac(wb_reg_data),
        .reg_out_id(reg_out_id),
        .reg_out_data(reg_out_data)
    );

endmodule

`endif
