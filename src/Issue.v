`ifndef ISSUE_V
`define ISSUE_V

`include "./src/Scoreboard.v"
`include "./src/HazardDetector.v"

module Issue(
    input        clock,
    input        reset,

    // Inputs to repeat to execution stage
    input        id_iss_selalushift,
    input        id_iss_selimregb,
    input [2:0]  id_iss_aluop,
    input        id_iss_unsig,
    input [1:0]  id_iss_shiftop,
    input        id_iss_readmem,
    input        id_iss_writemem,
    input [31:0] id_iss_imedext,
    input        id_iss_selwsource,
    input [4:0]  id_iss_regdest,
    input        id_iss_writereg,
    input        id_iss_writeov,

    // Repeated to execution stage
    output reg iss_ex_selalushift,
    output reg iss_ex_selimregb,
    output reg [2:0] iss_ex_aluop,
    output reg iss_ex_unsig,
    output reg [1:0] iss_ex_shiftop,
    output reg [4:0] iss_ex_shiftamt,
    output reg iss_ex_readmem,
    output reg iss_ex_writemem,
    output reg [31:0] iss_ex_imedext,
    output reg iss_ex_selwsource,
    output reg [4:0] iss_ex_regdest,
    output reg iss_ex_writereg,
    output reg iss_ex_writeov,

    input [4:0] id_iss_addra,
    input [4:0] id_iss_addrb,

    input [31:0] id_iss_dataa,
    input [31:0] id_iss_datab,

    output reg [31:0] iss_ex_rega,
    output reg [31:0] iss_ex_regb,

    // Represents number of register operands (1 => 3 registers, 0 => 2 registers)
    input id_iss_selregdest,

    // Opcode and funct, received from Decode in order to find out which func-
    // tional unit should be enabled
    input [5:0] id_iss_op,
    input [5:0] id_iss_funct, 

    // Functional unit to be used
    output iss_am_oper,
    output iss_mem_oper,
    output iss_mul_oper,

    // Issue-related stall
    output iss_stall

);

    wire       a_pending;
    wire       b_pending;

    wire [4:0] ass_row_a;
    wire [4:0] ass_row_b;

    wire [1:0] ass_unit_a;
    wire [1:0] ass_unit_b;

    wire [1:0] registerunit;

    wire [4:0] writeaddr;
    wire       enablewrite;

    Scoreboard SB (.clock(clock),
                   .reset(reset),

                   .ass_addr_a(id_iss_addra),
                   .ass_pending_a(a_pending),
                   .ass_unit_a(ass_unit_a),
                   .ass_row_a(ass_row_a),

                   .ass_addr_b(id_iss_addrb),
                   .ass_pending_b(b_pending),
                   .ass_unit_b(ass_unit_b),
                   .ass_row_b(ass_row_b),

                   .writeaddr(writeaddr),
                   .registerunit(registerunit),
                   .enablewrite(enablewrite)
        );

    HazardDetector HDETECTOR(.ass_pending_a(a_pending),
                             .ass_row_a(ass_row_a),
                             .ass_pending_b(b_pending),
                             .ass_row_b(ass_row_b),
                             .selregdest(id_iss_selregdest),
                             .stalled(iss_stall)
    );

    // 2'b00: AluMisc
    // 2'b01: Mem
    // 2'b10: Mult
    reg [1:0] functional_unit;

    assign iss_am_oper = functional_unit === 2'b00;
    assign iss_mem_oper = functional_unit === 2'b01;
    assign iss_mul_oper = functional_unit === 2'b10;

    always @(posedge clock or negedge reset) begin
        if (~iss_stall) begin
            if (~reset) begin
                iss_ex_selalushift <= 1'b0;
                iss_ex_selimregb <= 1'b0;
                iss_ex_aluop <= 3'b000;
                iss_ex_unsig <= 1'b0;
                iss_ex_shiftop <= 2'b00;
                iss_ex_shiftamt <= 5'b00000;
                iss_ex_readmem <= 1'b0;
                iss_ex_writemem <= 1'b0;
                iss_ex_imedext <= 32'h0000_0000;
                iss_ex_selwsource <= 1'b0;
                iss_ex_regdest <= 5'b00000;
                iss_ex_writereg <= 1'b0;
                iss_ex_writeov <= 1'b0;
                functional_unit <= 2'b11;
                iss_ex_rega <= 32'h0000_0000;
                iss_ex_regb <= 32'h0000_0000;
            end else begin
                iss_ex_selalushift <= id_iss_selalushift;
                iss_ex_selimregb <= id_iss_selimregb;
                iss_ex_aluop <= id_iss_aluop;
                iss_ex_unsig <= id_iss_unsig;
                iss_ex_shiftop <= id_iss_shiftop;
                iss_ex_readmem <= id_iss_readmem;
                iss_ex_writemem <= id_iss_writemem;
                iss_ex_imedext <= id_iss_imedext;
                iss_ex_selwsource <= id_iss_selwsource;
                iss_ex_regdest <= id_iss_regdest;
                iss_ex_writereg <= id_iss_writereg;
                iss_ex_writeov <= id_iss_writeov;
                iss_ex_shiftamt <= id_iss_dataa;
                iss_ex_rega <= id_iss_dataa;
                iss_ex_regb <= id_iss_datab;
                if (id_iss_op === 6'b101011 || id_iss_op === 6'b100011) begin
                    // Load, store
                    functional_unit <= 2'b01;
                end else if (id_iss_op === 6'b000000 && id_iss_funct === 6'b011000) begin
                    functional_unit <= 2'b10;
                end else begin
                    functional_unit <= 2'b00;
                end
            end
        end else begin
            functional_unit <= 2'b11;
        end 
    end

endmodule

`endif
