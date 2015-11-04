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
    input [4:0]  id_reg_addra,
    input [4:0]  id_reg_addrb,
    input        id_is_selregdest,

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

    // connect to register file
    output [31:0] is_reg_addra,
    output [31:0] is_reg_addrb,

    // functional unit to connect
    output [1:0] is_ex_func_unit;

    output       is_stall

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

    // register to read from file
    assign is_reg_addra = id_reg_addra;
    assign is_reg_addrb = id_reg_addrb;

    wire       a_pending;
    wire       b_pending;
    // dummy wires, unused
    wire [3:0] ass_unit;
    wire [9:0] ass_row;

    wire [1:0] registerunit;
    wire [4:0] writeaddr_a;
    wire       enablewrite_a;
    wire [4:0] writeaddr_b;
    wire       enablewrite_b;

    Scoreboard SB (.clock(clock),
                   .reset(reset),

                   .ass_addr_a(id_reg_addra),
                   .ass_pending_a(a_pending),
                   .ass_unit_a(ass_unit[3:2]),
                   .ass_row_a(ass_row[9:5]),

                   .ass_addr_b(id_reg_addrb),
                   .ass_pending_b(b_pending),
                   .ass_unit_b(ass_unit[1:0]),
                   .ass_row_b(ass_row[4:0]),

                   .registerunit(registerunit),

                   .writeaddr_a(writeaddr_a),
                   .enablewrite_a(enablewrite_a),
                   
                   .writeaddr_b(writeaddr_b),
                   .enablewrite_b(enablewrite_b)
        );

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            is_ex_selalushift <= 1'b0;
            is_ex_selimregb <= 1'b0;
            is_ex_aluop <= 3'b000;
            is_ex_unsig <= 1'b0;
            is_ex_unsig <= 2'b00;
            is_ex_readmem <= 1'b0;
            is_ex_writemem <= 1'b0;
            is_ex_selwsource <= 1'b0;
            is_ex_regdest <= 5'b00000;
            is_ex_writereg <= 1'b0;
            is_ex_writeov <= 1'b0;
            is_ex_imedext <= 32'h0000_0000;
            is_ex_func_unit <= 2'bZZ;
        end else begin
            if(~a_pending && (~id_is_selregdest or ~b_pending)) begin
                // TODO send to corresponding functional unit
            end else begin
                is_stall <= 1;
                is_ex_func_unit <= 2'bZZ;
            end
        end
    end

endmodule

`endif
