`ifndef MIPS_V
`define MIPS_V

`include "./src/Fetch.v"
`include "./src/Decode.v"
`include "./src/Issue.v"
`include "./src/Mult.v"
`include "./src/AluMisc.v"
`include "./src/Mem.v"
`include "./src/Writeback.v"
`include "./src/Registers.v"

module Mips (
    input clock,
    input reset,
    // Register selection and data output to be displayed in the 7SDs
    input [4:0] reg_out_id,
    output [31:0] reg_out_data,
    // Workaround to initialize the memory modules with data/instructions
    input fetch_ram_load,
    input mem_ram_load,

    output [31:0] reg_out_0,
    output [31:0] reg_out_1,
    output [31:0] reg_out_2,
    output [31:0] reg_out_3,
    output [31:0] reg_out_4
);


    // Stall from the issue stage to Decode and Fetch
    wire              id_stall;
    // Avoid stall deadlock
    wire iss_stall;

    ///////////
    // Fetch //
    ///////////

    wire    [31:0]    if_id_nextpc;
    wire    [31:0]    if_id_instruc;

    wire              id_if_selpcsource;
    wire    [31:0]    id_if_rega;
    wire    [31:0]    id_if_pcimd2ext;
    wire    [31:0]    id_if_pcindex;
    wire    [1:0]     id_if_selpctype;

    Fetch FETCH(
        .clock(clock),
        .reset(reset),

        .id_stall(id_stall),

        .if_id_nextpc(if_id_nextpc),
        .if_id_instruc(if_id_instruc),

        .id_if_selpcsource(id_if_selpcsource),
        .id_if_rega(id_if_rega),
        .id_if_pcimd2ext(id_if_pcimd2ext),
        .id_if_pcindex(id_if_pcindex),
        .id_if_selpctype(id_if_selpctype),

        .fetch_ram_load(fetch_ram_load)
    );

    ////////////
    // Decode //
    ////////////

    wire id_iss_selalushift;
    wire id_iss_selimregb;
    wire [2:0] id_iss_aluop;
    wire id_iss_unsig;
    wire [1:0] id_iss_shiftop;
    wire id_iss_readmem;
    wire id_iss_writemem;
    wire [31:0] id_iss_imedext;
    wire id_iss_selwsource;
    wire [4:0] id_iss_regdest;
    wire id_iss_writereg;
    wire id_iss_writeov;
    wire id_iss_selregdest;

    wire [5:0] id_iss_op;
    wire [5:0] id_iss_funct;

    wire [4:0] id_reg_addra;
    wire [4:0] id_reg_addrb;

    wire [31:0] reg_id_dataa;
    wire [31:0] reg_id_datab;

    wire [31:0] reg_id_ass_dataa;
    wire [31:0] reg_id_ass_datab;

    wire [4:0] id_iss_addra;
    wire [4:0] id_iss_addrb;

    wire [4:0] id_hd_ass_addra;
    wire id_hd_check_a;
    wire [4:0] id_hd_ass_addrb;
    wire id_hd_check_b;

    wire [4:0] id_ass_waw_write_addr;
    wire id_ass_waw_write_writereg;

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

        .id_iss_selalushift(id_iss_selalushift),
        .id_iss_selimregb(id_iss_selimregb),
        .id_iss_aluop(id_iss_aluop),
        .id_iss_unsig(id_iss_unsig),
        .id_iss_shiftop(id_iss_shiftop),
        .id_iss_readmem(id_iss_readmem),
        .id_iss_writemem(id_iss_writemem),
        .id_iss_imedext(id_iss_imedext),
        .id_iss_selwsource(id_iss_selwsource),
        .id_iss_regdest(id_iss_regdest),
        .id_iss_writereg(id_iss_writereg),
        .id_iss_writeov(id_iss_writeov),
        .id_iss_selregdest(id_iss_selregdest),

        .id_iss_op(id_iss_op),
        .id_iss_funct(id_iss_funct),

        .id_stall(id_stall),
        .iss_stall(iss_stall),

        .id_reg_addra(id_reg_addra),
        .id_reg_addrb(id_reg_addrb),

        .reg_id_ass_dataa(reg_id_ass_dataa),
        .reg_id_ass_datab(reg_id_ass_datab),

        .id_iss_addra(id_iss_addra),
        .id_iss_addrb(id_iss_addrb),

        .id_hd_ass_addra(id_hd_ass_addra),
        .id_hd_check_a(id_hd_check_a),
        .id_hd_ass_addrb(id_hd_ass_addrb),
        .id_hd_check_b(id_hd_check_b),

        .id_ass_waw_write_addr(id_ass_waw_write_addr),
        .id_ass_waw_write_writereg(id_ass_waw_write_writereg)
    );

    ///////////
    // Issue //
    ///////////

    // Note: iss_stall has already been defined, above all modules.

    // Issue stage outputs
    wire iss_ex_selalushift;
    wire iss_ex_selimregb;
    wire [2:0] iss_ex_aluop;
    wire iss_ex_unsig;
    wire [1:0] iss_ex_shiftop;
    wire [4:0] iss_ex_shiftamt;
    wire iss_ex_readmem;
    wire iss_ex_writemem;
    wire [31:0] iss_ex_imedext;
    wire iss_ex_selwsource;
    wire [4:0] iss_ex_regdest;
    wire iss_ex_writereg;
    wire iss_ex_writeov;

    wire [31:0] iss_ex_rega;
    wire [31:0] iss_ex_regb;

    wire iss_am_oper;
    wire iss_mem_oper;
    wire iss_mul_oper;

    wire [4:0]  iss_reg_addra;
    wire [4:0]  iss_reg_addrb;
    wire [31:0] reg_iss_dataa;
    wire [31:0] reg_iss_datab;

    Issue ISSUE (
        .clock(clock),
        .reset(reset),

        .id_iss_selalushift(id_iss_selalushift),
        .id_iss_selimregb(id_iss_selimregb),
        .id_iss_aluop(id_iss_aluop),
        .id_iss_unsig(id_iss_unsig),
        .id_iss_shiftop(id_iss_shiftop),
        .id_iss_readmem(id_iss_readmem),
        .id_iss_writemem(id_iss_writemem),
        .id_iss_imedext(id_iss_imedext),
        .id_iss_selwsource(id_iss_selwsource),
        .id_iss_regdest(id_iss_regdest),
        .id_iss_writereg(id_iss_writereg),
        .id_iss_writeov(id_iss_writeov),

        .iss_ex_selalushift(iss_ex_selalushift),
        .iss_ex_selimregb(iss_ex_selimregb),
        .iss_ex_aluop(iss_ex_aluop),
        .iss_ex_unsig(iss_ex_unsig),
        .iss_ex_shiftop(iss_ex_shiftop),
        .iss_ex_shiftamt(iss_ex_shiftamt),
        .iss_ex_readmem(iss_ex_readmem),
        .iss_ex_writemem(iss_ex_writemem),
        .iss_ex_imedext(iss_ex_imedext),
        .iss_ex_selwsource(iss_ex_selwsource),
        .iss_ex_regdest(iss_ex_regdest),
        .iss_ex_writereg(iss_ex_writereg),
        .iss_ex_writeov(iss_ex_writeov),

        .id_iss_addra(id_iss_addra),
        .id_iss_addrb(id_iss_addrb),

        .iss_reg_addra(iss_reg_addra),
        .iss_reg_addrb(iss_reg_addrb),

        .reg_iss_dataa(reg_iss_dataa),
        .reg_iss_datab(reg_iss_datab),

        .iss_ex_rega(iss_ex_rega),
        .iss_ex_regb(iss_ex_regb),

        .id_iss_selregdest(id_iss_selregdest),

        .id_iss_op(id_iss_op),
        .id_iss_funct(id_iss_funct),

        .iss_am_oper(iss_am_oper),
        .iss_mem_oper(iss_mem_oper),
        .iss_mul_oper(iss_mul_oper),

        .id_hd_ass_addra(id_hd_ass_addra),
        .id_hd_check_a(id_hd_check_a),
        .id_hd_ass_addrb(id_hd_ass_addrb),
        .id_hd_check_b(id_hd_check_b),

        .id_ass_waw_write_addr(id_ass_waw_write_addr),
        .id_ass_waw_write_writereg(id_ass_waw_write_writereg),

        .hd_id_stall(id_stall),
        .iss_stall(iss_stall)
    );

    // Alumisc outputs
    wire [4:0] am_wb_regdest;
    wire am_wb_writereg;
    wire [31:0] am_wb_wbvalue;
    wire am_wb_oper;

    AluMisc ALUMISC (
        .clock(clock),
        .reset(reset),

        .iss_am_oper(iss_am_oper),
        .iss_am_selalushift(iss_ex_selalushift),
        .iss_am_selimregb(iss_ex_selimregb),
        .iss_am_aluop(iss_ex_aluop),
        .iss_am_unsig(iss_ex_unsig),
        .iss_am_shiftop(iss_ex_shiftop),
        .iss_am_shiftamt(iss_ex_shiftamt),
        .iss_am_rega(iss_ex_rega),
        .iss_am_regb(iss_ex_regb),
        .iss_am_imedext(iss_ex_imedext),
        .iss_am_regdest(iss_ex_regdest),
        .iss_am_writereg(iss_ex_writereg),
        .iss_am_writeov(iss_ex_writeov),

        .am_wb_regdest(am_wb_regdest),
        .am_wb_writereg(am_wb_writereg),
        .am_wb_wbvalue(am_wb_wbvalue),
        .am_wb_oper(am_wb_oper)
    );

    // Mem outputs
    wire [4:0] mem_wb_regdest;
    wire mem_wb_writereg;
    wire [31:0] mem_wb_wbvalue;
    wire mem_wb_oper;

    Mem MEM (
        .clock(clock),
        .reset(reset),

        .iss_mem_oper(iss_mem_oper),
        .iss_mem_readmem(iss_ex_readmem),
        .iss_mem_writemem(iss_ex_writemem),
        .iss_mem_rega(iss_ex_rega),
        .iss_mem_imedext(iss_ex_imedext),
        .iss_mem_regb(iss_ex_regb),
        .iss_mem_regdest(iss_ex_regdest),
        .iss_mem_writereg(iss_ex_writereg),

        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue),

        .mem_ram_load(mem_ram_load),

        .mem_wb_oper(mem_wb_oper)
    );

    // Mult outputs
    wire [4:0] mul_wb_regdest;
    wire mul_wb_writereg;
    wire [31:0] mul_wb_wbvalue;
    wire mul_wb_oper;

    Mult MULT (
        .clock(clock),
        .reset(reset),

        .iss_mul_oper(iss_mul_oper),
        .iss_mul_rega(iss_ex_rega),
        .iss_mul_regb(iss_ex_regb),
        .iss_mul_regdest(iss_ex_regdest),

        .mul_wb_regdest(mul_wb_regdest),
        .mul_wb_writereg(mul_wb_writereg),
        .mul_wb_wbvalue(mul_wb_wbvalue),

        .mul_wb_oper(mul_wb_oper)
    );

    // Writeback outputs
    wire wb_reg_en;
    wire [4:0] wb_reg_addr;
    wire [31:0] wb_reg_data;

    Writeback WRITEBACK(
        .clock(clock),
        .reset(reset),
        // Mult
        .mul_wb_oper(mul_wb_oper),
        .mul_wb_regdest(mul_wb_regdest),
        .mul_wb_writereg(mul_wb_writereg),
        .mul_wb_wbvalue(mul_wb_wbvalue),

        // AluMisc
        .am_wb_oper(am_wb_oper),
        .am_wb_regdest(am_wb_regdest),
        .am_wb_writereg(am_wb_writereg),
        .am_wb_wbvalue(am_wb_wbvalue),

        // Mem
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue),
        .mem_wb_oper(mem_wb_oper),

        // Register file
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
        .reg_out_data(reg_out_data),
        .reg_out_0(reg_out_0),
        .reg_out_1(reg_out_1),
        .reg_out_2(reg_out_2),
        .reg_out_3(reg_out_3),
        .reg_out_4(reg_out_4),

        // issue stage ports
        .addr_iss_a(iss_reg_addra),
        .ass_data_iss_a(reg_iss_dataa),
        .addr_iss_b(iss_reg_addrb),
        .ass_data_iss_b(reg_iss_datab)
    );

endmodule

`endif
