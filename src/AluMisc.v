`ifndef ALUMISC_V
`define ALUMISC_V

// shorthand: am -> a0 -> a1 -> a2 -> a3

module AluMisc (

    ////////////
    // INPUTS //
    ////////////

    input clock,
    input reset,

    input iss_a0_oper, // Enables this funcional unit (mutually exclusive
                       // regarding the other two main functional units'
                       // signals)

    // Whether to save the ALU's or the Shifter's output
    input                   iss_a0_selalushift,

    // Whether to use an immediate value or a register as the second operand
    input                   iss_a0_selimregb,

    // ALU operation to be performed
    input         [2:0]     iss_a0_aluop,

    // Whether or not to perform an unsigned operation
    input                   iss_a0_unsig,

    // Shifter operation to be performed
    input         [1:0]     iss_a0_shiftop,

    // Amount to be shifted
    input         [4:0]     iss_a0_shiftamt,

    // First register (always an operand)
    input         [31:0]    iss_a0_rega,

    // Second register (not necessarily an operand, an immediate value may be
    // used instead)
    input         [31:0]    iss_a0_regb,

    // Immediate value (may be used as operand)
    input         [31:0]    iss_a0_imedext,

    // Whether or not the instruction writes to the ARF
    input                   iss_a0_writereg,

    // If true, the instruction will write to the ARF even if an overflow
    // happens.
    input                   iss_a0_writeov, 

    /////////////
    // OUTPUTS //
    /////////////

    // Register to be written
    output reg    [4:0]     a3_wb_regdest,

    // Whether or not a write should be performed (takes overflows into account
    // or not, depending on iss_a0_writeov)
    output reg              a3_wb_writereg,

    // Value to be written
    output reg    [31:0]    a3_wb_wbvalue,

    output a3_wb_oper
);

    wire    [31:0]    aluout;
    wire              aluov;
    wire    [31:0]    result;
    wire    [31:0]    mux_imregb;

    assign mux_imregb = (iss_a0_selimregb) ? iss_a0_imedext : iss_a0_regb;

    Alu ALU(.a(iss_a0_rega),.b(mux_imregb),.aluout(aluout),.op(iss_a0_aluop),.unsig(iss_a0_unsig),.overflow(aluov));
    Shifter SHIFTER(.in(iss_a0_regb),.shiftop(iss_a0_shiftop),.shiftamt(iss_a0_shiftamt),.result(result));
    
    // Buffers - AM -> A0, A1, A2, A3 -> actual output
    
    reg a0_a1_oper;
    reg [4:0] a0_a1_regdest;
    reg a0_a1_writereg;
    reg [31:0] a0_a1_wbvalue;

    reg a1_a2_oper;
    reg [4:0] a1_a2_regdest;
    reg a1_a2_writereg;
    reg [31:0] a1_a2_wbvalue;

    reg a2_a3_oper;
    reg [4:0] a2_a3_regdest;
    reg a2_a3_writereg;
    reg [31:0] a2_a3_wbvalue;


    always @(posedge clock or negedge reset) begin
        // AluMisc_0
        if (~reset || ~iss_a0_oper) begin
            a0_a1_oper <= 1'b0;  
            a0_a1_regdest <= 5'b00000;
            a0_a1_writereg <= 1'b0;
            a0_a1_wbvalue <= 32'h0000_0000;
        end else begin
            a0_a1_oper <= 1'b1;
            a0_a1_regdest <= iss_a0_regdest;
            a0_a1_writereg <= (!aluov | iss_a0_writeov) & iss_a0_writereg;
            a0_a1_wbvalue <= (iss_a0_selalushift) ? result : aluout;
        end

        // AluMisc_1
        if (~reset || ~a0_a1_oper) begin
            a1_a2_oper <= 1'b0;  
            a1_a2_regdest <= 5'b00000;
            a1_a2_writereg <= 1'b0;
            a1_a2_wbvalue <= 32'h0000_0000;
        end else begin
            a1_a2_oper <= 1'b1;
            a1_a2_regdest <= a0_a1_regdest;
            a1_a2_writereg <= a0_a1_writereg;
            a1_a2_wbvalue <= a0_a1_wbvalue;
        end

        // AluMisc_2
        if (~reset || ~a1_a2_oper) begin
            a2_a3_oper <= 1'b0;  
            a2_a3_regdest <= 5'b00000;
            a2_a3_writereg <= 1'b0;
            a2_a3_wbvalue <= 32'h0000_0000;
        end else begin
            a2_a3_oper <= 1'b1;
            a2_a3_regdest <= a1_a2_regdest;
            a2_a3_writereg <= a1_a2_writereg;
            a2_a3_wbvalue <= a1_a2_wbvalue;
        end

        // AluMisc_3
        if (~reset || ~a2_a3_oper) begin
            a3_wb_oper <= 1'b0;
            a3_wb_regdest <= 5'b00000;
            a3_wb_writereg <= 1'b0;
            a3_wb_wbvalue <= 32'h0000_0000;
        end else begin
            a3_wb_oper <= 1'b1;
            a3_wb_regdest <= a2_a3_regdest;
            a3_wb_writereg <= a2_a3_writereg;
            a3_wb_wbvalue <= a2_a3_wbvalue;
        end
    end


`endif