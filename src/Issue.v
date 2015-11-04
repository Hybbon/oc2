`ifndef ISSUE_V
`define ISSUE_V

`include "./src/Scoreboard.v"

module Issue(
    input        clock,
    input        reset,
    // inputs to repeat to execution stage
    input        id_is_selalushift,
    input        id_is_selimregb,
    input [2:0]  id_is_aluop,
    input        id_is_unsig,
    input [1:0]  id_is_shiftop,
    input [4:0]  id_is_shiftamt,
    input [31:0] id_is_rega,
    input        id_is_readmem,
    input        id_is_writemem,
    input [31:0] id_is_regb,
    input [31:0] id_is_imedext,
    input        id_is_selwsource,
    input [4:0]  id_is_regdest,
    input        id_is_writereg,
    input        id_is_writeov,
    input [31:0] reg_id_ass_dataa,
    input [31:0] reg_id_ass_datab,

    output        is_ex_selalushift,
    output        is_ex_selimregb,
    output [2:0]  is_ex_aluop,
    output        is_ex_unsig,
    output [1:0]  is_ex_shiftop,
    output [4:0]  is_ex_shiftamt,
    output [31:0] is_ex_rega,
    output        is_ex_readmem,
    output        is_ex_writemem,
    output [31:0] is_ex_regb,
    output [31:0] is_ex_imedext,
    output        is_ex_selwsource,
    output [4:0]  is_ex_regdest,
    output        is_ex_writereg,
    output        is_ex_writeov,
    output [31:0] id_reg_addra,
    output [31:0] id_reg_addrb,

    output is_stall

);

assign is_ex_selalushift = id_is_selalushift;
assign is_ex_selimregb = id_is_selimregb;
assign is_ex_aluop = id_is_aluop;
assign is_ex_unsig = id_is_unsig;
assign is_ex_shiftop = id_is_shiftop;
assign is_ex_shiftamt = id_is_shiftamt;
assign is_ex_rega = id_is_rega;
assign is_ex_readmem = id_is_readmem;
assign is_ex_writemem = id_is_writemem;
assign is_ex_regb = id_is_regb;
assign is_ex_imedext = id_is_imedext;
assign is_ex_selwsource = id_is_selwsource;
assign is_ex_regdest = id_is_regdest;
assign is_ex_writereg = id_is_writereg;
assign is_ex_writeov = id_is_writeov;
assign is_reg_addra = id_reg_addra;
assign is_reg_addrb = id_reg_addrb;
assign reg_is_dataa = reg_id_dataa;
assign reg_is_datab = reg_id_datab;

wire [4:0] ass_addr;
wire       ass_pending;
wire [1:0] ass_unit;
wire [4:0] ass_row;
wire [4:0] writeaddr;
wire [1:0] registerunit;
wire       enablewrite;

Scoreboard SB (.clock(clock),
               .reset(reset),

               .ass_addr_a(ass_addr_a),
               .ass_pending_a(ass_pending_a),
               .ass_unit_a(ass_unit_a),
               .ass_row_a(ass_row_a),

               .ass_addr_b(ass_addr_b),
               .ass_pending_b(ass_pending_b),
               .ass_unit_b(ass_unit_b),
               .ass_row_b(ass_row_b),

               .registerunit(registerunit),

               .writeaddr_a(writeaddr_a),
               .enablewrite_a(enablewrite_a),
               
               .writeaddr_b(writeaddr_b),
               .enablewrite_b(enablewrite_b)
    );



endmodule

`endif
