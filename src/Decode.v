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
    //Execute
    output reg              id_ex_selalushift,
    output reg              id_ex_selimregb,
    output reg    [2:0]     id_ex_aluop,
    output reg              id_ex_unsig,
    output reg    [1:0]     id_ex_shiftop,
    output        [4:0]     id_ex_shiftamt,
    output        [31:0]    id_ex_rega,
    output reg              id_ex_readmem,
    output reg              id_ex_writemem,
    output        [31:0]    id_ex_regb,
    output reg    [31:0]    id_ex_imedext,
    output reg              id_ex_selwsource,
    output reg    [4:0]     id_ex_regdest,
    output reg              id_ex_writereg,
    output reg              id_ex_writeov,
    //Registers
    output        [4:0]     id_reg_addra,
    output        [4:0]     id_reg_addrb,
    input         [31:0]    reg_id_dataa,
    input         [31:0]    reg_id_datab,
    input         [31:0]    reg_id_ass_dataa,
    input         [31:0]    reg_id_ass_datab
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
    assign id_ex_rega = reg_id_dataa;
    assign id_ex_regb = reg_id_datab;
    assign id_ex_shiftamt = reg_id_dataa;
    assign id_if_selpctype = selpctype;
    assign id_if_pcindex = {if_id_nextpc[31:28],if_id_instruc[25:0]<<2'b10};
    assign id_if_pcimd2ext = if_id_nextpc + $signed({{16{if_id_instruc[15]}},if_id_instruc[15:0]}<<2'b10);

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
            id_ex_selalushift <= 1'b0;
            id_ex_selimregb <= 1'b0;
            id_ex_aluop <= 3'b000;
            id_ex_unsig <= 1'b0;
            id_ex_unsig <= 2'b00;
            id_ex_readmem <= 1'b0;
            id_ex_writemem <= 1'b0;
            id_ex_selwsource <= 1'b0;
            id_ex_regdest <= 5'b00000;
            id_ex_writereg <= 1'b0;
            id_ex_writeov <= 1'b0;
            id_ex_imedext <= 32'h0000_0000;
        end else begin
            id_ex_selalushift <= selalushift;
            id_ex_selimregb <= selimregb;
            id_ex_aluop <= aluop;
            id_ex_unsig <= unsig;
            id_ex_shiftop <= shiftop;
            id_ex_readmem <= readmem;
            id_ex_writemem <= writemem;
            id_ex_selwsource <= selwsource;
            id_ex_regdest <= (selregdest) ? if_id_instruc[15:11] : if_id_instruc[20:16];
            id_ex_writereg <= writereg;
            id_ex_writeov <= writeov;
            id_ex_imedext <= $signed(if_id_instruc[15:0]);
        end
    end

endmodule
