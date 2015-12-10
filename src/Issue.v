`ifndef ISSUE_V
`define ISSUE_V

`include "./src/Scoreboard.v"
`include "./src/HazardDetector.v"

module Issue (
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

    // Register interaction: register address is received from
    // decode. The issue stage reads the ARF by the same process used by the
    // decode stage.

    // Addresses (necessary for the scoreboard, received synchronally)
    input [4:0] id_iss_addra,
    input [4:0] id_iss_addrb,

    // ARF Communication interface
    // Register address sent to ARF
    output [4:0] iss_reg_addra,
    output [4:0] iss_reg_addrb,
    // Register values received from ARF
    input [31:0] reg_iss_dataa,
    input [31:0] reg_iss_datab,

    // Data values (forwarded to the functional units)
    // Written synchronally to the output registers.
    output reg [31:0] iss_ex_rega,
    output reg [31:0] iss_ex_regb,

    // Represents number of register operands (1 => 3 registers,
    // 0 => 2 registers)
    input id_iss_selregdest,

    // Opcode and funct, received from Decode in order to find out which func-
    // tional unit should be enabled
    input [5:0] id_iss_op,
    input [5:0] id_iss_funct,

    // Functional unit to be used
    output iss_am_oper,
    output iss_mem_oper,
    output iss_mul_oper,

    // Asynchronous interface between Decode, the scoreboard and the hazard
    // detector.
    input [4:0] id_hd_ass_addra,
    input id_hd_check_a,
    input [4:0] id_hd_ass_addrb,
    input id_hd_check_b,

    // Branch-related decode and fetch stall
    output hd_id_stall

);

    wire iss_stall;

    // asynchronous issue stage scoreboard outputs
    wire iss_ass_pending_a;
    wire [1:0] iss_ass_unit_a;
    wire [4:0] iss_ass_row_a;

    wire iss_ass_pending_b;
    wire [1:0] iss_ass_unit_b;
    wire [4:0] iss_ass_row_b;

    // asynchronous issue stage scoreboard outputs
    wire id_ass_pending_a;
    wire [1:0] id_ass_unit_a; // Not actually used
    wire [4:0] id_ass_row_a;

    wire id_ass_pending_b;
    wire [1:0] id_ass_unit_b; // Not actually used
    wire [4:0] id_ass_row_b;

    // synchronous scoreboard inputs
    wire [1:0] registerunit;

    wire [4:0] writeaddr;
    wire       enablewrite;

    Scoreboard SB (
        .clock(clock),
        .reset(reset),

        .iss_ass_addr_a(id_iss_addra),
        .iss_ass_pending_a(iss_ass_pending_a),
        .iss_ass_unit_a(iss_ass_unit_a),
        .iss_ass_row_a(iss_ass_row_a),

        .iss_ass_addr_b(id_iss_addrb),
        .iss_ass_pending_b(iss_ass_pending_b),
        .iss_ass_unit_b(iss_ass_unit_b),
        .iss_ass_row_b(iss_ass_row_b),

        .id_ass_addr_a(id_hd_ass_addra),
        .id_ass_pending_a(id_ass_pending_a),
        .id_ass_unit_a(id_ass_unit_a),
        .id_ass_row_a(id_ass_row_a),

        .id_ass_addr_b(id_hd_ass_addrb),
        .id_ass_pending_b(id_ass_pending_b),
        .id_ass_unit_b(id_ass_unit_b),
        .id_ass_row_b(id_ass_row_b),

        .writeaddr(writeaddr),
        .registerunit(registerunit),
        .enablewrite(enablewrite)
    );

    HazardDetector HDETECTOR (
        .iss_ass_pending_a(iss_ass_pending_a),
        .iss_ass_row_a(iss_ass_row_a),
        .iss_check_a(1'b1),
        .iss_ass_pending_b(iss_ass_pending_b),
        .iss_ass_row_b(iss_ass_row_b),
        .iss_check_b(id_iss_selregdest),
        .iss_stalled(iss_stall),

        .id_ass_pending_a(id_ass_pending_a),
        .id_ass_row_a(id_ass_row_a),
        .id_check_a(id_hd_check_a),
        .id_ass_pending_b(id_ass_pending_b),
        .id_ass_row_b(id_ass_row_b),
        .id_check_b(id_hd_check_b),
        .id_stalled(hd_id_stall)
    );

    // 2'b00: AluMisc
    // 2'b01: Mem
    // 2'b10: Mult
    reg [1:0] functional_unit;

    assign iss_am_oper = functional_unit === 2'b00;
    assign iss_mem_oper = functional_unit === 2'b01;
    assign iss_mul_oper = functional_unit === 2'b10;

    assign iss_reg_addra = id_iss_addra;
    assign iss_reg_addrb = id_iss_addrb;

    always @(posedge clock or negedge reset) begin
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
        end else if (~iss_stall) begin
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
            iss_ex_shiftamt <= reg_iss_dataa;
            iss_ex_rega <= reg_iss_dataa;
            iss_ex_regb <= reg_iss_datab;
            if (id_iss_op === 6'b101011 || id_iss_op === 6'b100011) begin
                // Load, store
                functional_unit <= 2'b01;
            end else if (id_iss_op === 6'b000000 && id_iss_funct === 6'b011000) begin
                functional_unit <= 2'b10;
            end else begin
                functional_unit <= 2'b00;
            end
        end else begin
            functional_unit <= 2'b11;
        end 
    end

endmodule

`endif
