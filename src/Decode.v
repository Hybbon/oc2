`ifndef DECODE_V
`define DECODE_V

`include "./src/Comparator.v"
`include "./src/Control.v"

module Decode (
    input                   clock,
    input                   reset,

    //Fetch
    input         [31:0]    if_id_instruc,
    input         [31:0]    if_id_nextpc,
    output reg              id_if_selpcsource,
    output        [31:0]    id_if_rega,
    output        [31:0]    id_if_pcimd2ext,
    output        [31:0]    id_if_pcindex,
    output        [1:0]     id_if_selpctype,

    // Issue
    output reg              id_iss_selalushift,
    output reg              id_iss_selimregb,
    output reg    [2:0]     id_iss_aluop,
    output reg              id_iss_unsig,
    output reg    [1:0]     id_iss_shiftop,
    output reg              id_iss_readmem,
    output reg              id_iss_writemem,
    output reg    [31:0]    id_iss_imedext,
    output reg              id_iss_selwsource,
    output reg    [4:0]     id_iss_regdest,  // destination register
    output reg              id_iss_writereg,
    output reg              id_iss_writeov,
    output reg              id_iss_selregdest, // 1 if current instruction has 3 operands

    // Both may be used at Issue to determine which functional unit should be
    // used
    output reg [5:0] id_iss_op,
    output reg [5:0] id_iss_funct,

    // Keeps the current instruction
    input id_stall,

    // Register interface
    // Addresses are obtained asynchronally via Control. They're, then, for-
    // warded to the asynchronous interfaces of the ARF. The ARF sends back,
    // both synchronally and asynchronally.
    output [4:0] id_reg_addra,
    output [4:0] id_reg_addrb,

    input [31:0] reg_id_ass_dataa,
    input [31:0] reg_id_ass_datab,

    output reg [4:0] id_iss_addra,
    output reg [4:0] id_iss_addrb,

    // [Async] Hazard detector and scoreboard interface
    output [4:0] id_hd_ass_addra,
    output id_hd_check_a,
    output [4:0] id_hd_ass_addrb,
    output id_hd_check_b
);

    wire    [1:0]    selbrjumpz;
    wire             compout;
    wire    [1:0]    selpctype;
    wire             selalushift;
    wire             selimregb;
    wire    [2:0]    aluop;
    wire             unsig;
    wire    [1:0]    shiftop;
    wire             readmem;
    wire             writemem;
    wire             selwsource;
    wire             selregdest;
    wire             writereg;
    wire             writeov;
    wire    [2:0]    compop;

    assign id_if_rega = reg_id_ass_dataa;
    assign id_reg_addra = if_id_instruc[25:21];
    assign id_reg_addrb = if_id_instruc[20:16];
    assign id_if_selpctype = selpctype;
    assign id_if_pcindex = {if_id_nextpc[31:28],if_id_instruc[25:0]<<2'b10};
    assign id_if_pcimd2ext = if_id_nextpc + $signed({{16{if_id_instruc[15]}},if_id_instruc[15:0]}<<2'b10);

    assign id_hd_ass_addra = id_reg_addra;
    assign id_hd_ass_addrb = id_reg_addrb;

    assign id_hd_check_a = selbrjumpz === 2'b10 || selbrjumpz === 2'b01 &&
        selpctype !== 2'b01;

    assign id_hd_check_b = selbrjumpz === 2'b10 && (
        compop === 2'b00 || compop === 2'b01
    );

    Comparator COMPARATOR(.a(reg_id_ass_dataa),.b(reg_id_ass_datab),.op(compop),.compout(compout));
    Control CONTROL(.op(if_id_instruc[31:26]),.fn(if_id_instruc[5:0]),
                    .selwsource(selwsource),.selregdest(selregdest),.writereg(writereg),
                    .writeov(writeov),.selimregb(selimregb),.selalushift(selalushift),
                    .aluop(aluop),.shiftop(shiftop),.readmem(readmem),.writemem(writemem),
                    .selbrjumpz(selbrjumpz),.selpctype(selpctype),.compop(compop),
                    .unsig(unsig));

    always @(*) begin
        case (selbrjumpz)
            2'b00:   id_if_selpcsource <= 1'b0;
            2'b01:   id_if_selpcsource <= 1'b1;
            2'b10:   id_if_selpcsource <= compout;
            2'b11:   id_if_selpcsource <= 1'b0;
            default: id_if_selpcsource <= 1'b0;
        endcase
    end

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            id_iss_selalushift <= 1'b0;
            id_iss_selimregb <= 1'b0;
            id_iss_aluop <= 3'b000;
            id_iss_unsig <= 1'b0;
            id_iss_shiftop <= 2'b00;
            id_iss_readmem <= 1'b0;
            id_iss_writemem <= 1'b0;
            id_iss_selwsource <= 1'b0;
            id_iss_regdest <= 5'b00000;
            id_iss_writereg <= 1'b0;
            id_iss_writeov <= 1'b0;
            id_iss_imedext <= 32'h0000_0000;
            id_iss_selregdest <= 1'b0;

            id_iss_op <= 6'b000000;
            id_iss_funct <= 6'b000000;

            id_iss_addra <= 5'b00000;
            id_iss_addrb <= 5'b00000;

        end else begin
            // Fix stalls caused by issue stage
            if (~id_stall) begin
                id_iss_selalushift <= selalushift;
                id_iss_selimregb <= selimregb;
                id_iss_aluop <= aluop;
                id_iss_unsig <= unsig;
                id_iss_shiftop <= shiftop;
                id_iss_readmem <= readmem;
                id_iss_writemem <= writemem;
                id_iss_selwsource <= selwsource;
                id_iss_regdest <= (selregdest) ? if_id_instruc[15:11] : if_id_instruc[20:16];
                id_iss_writereg <= writereg;
                id_iss_writeov <= writeov;
                id_iss_imedext <= $signed(if_id_instruc[15:0]);
                id_iss_selregdest <= selregdest;

                id_iss_op <= if_id_instruc[31:26];
                id_iss_funct <= if_id_instruc[5:0];

                id_iss_addra <= id_reg_addra;
                id_iss_addrb <= id_reg_addrb;
            end
        end
    end

endmodule

`endif
