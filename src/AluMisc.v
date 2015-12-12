`ifndef ALUMISC_V
`define ALUMISC_V

`include "./src/Alu.v"
`include "./src/Shifter.v"

// shorthand: am

module AluMisc (

    ////////////
    // INPUTS //
    ////////////

    input clock,
    input reset,

    input iss_am_oper, // Enables this funcional unit (mutually exclusive
                       // regarding the other two main functional units'
                       // signals)

    // Whether to save the ALU's or the Shifter's output
    input                   iss_am_selalushift,

    // Whether to use an immediate value or a register as the second operand
    input                   iss_am_selimregb,

    // ALU operation to be performed
    input         [2:0]     iss_am_aluop,

    // Whether or not to perform an unsigned operation
    input                   iss_am_unsig,

    // Shifter operation to be performed
    input         [1:0]     iss_am_shiftop,

    // Amount to be shifted
    input         [4:0]     iss_am_shiftamt,

    // First register (always an operand)
    input         [31:0]    iss_am_rega,

    // Second register (not necessarily an operand, an immediate value may be
    // used instead)
    input         [31:0]    iss_am_regb,

    // Immediate value (may be used as operand)
    input         [31:0]    iss_am_imedext,

    // Destination register
    input         [4:0]     iss_am_regdest,

    // Whether or not the instruction writes to the ARF
    input                   iss_am_writereg,

    // If true, the instruction will write to the ARF even if an overflow
    // happens.
    input                   iss_am_writeov, 

    /////////////
    // OUTPUTS //
    /////////////

    // Register to be written
    output reg    [4:0]     am_wb_regdest,

    // Whether or not a write should be performed (takes overflows into account
    // or not, depending on iss_am_writeov)
    output reg              am_wb_writereg,

    // Value to be written
    output reg    [31:0]    am_wb_wbvalue,

    output reg am_wb_oper
);

    wire    [31:0]    aluout;
    wire              aluov;
    wire    [31:0]    result;
    wire    [31:0]    mux_imregb;

    // wire to which the second operand (register or immediate) is assigned
    assign mux_imregb = (iss_am_selimregb) ? iss_am_imedext : iss_am_regb;

    Alu ALU(.a(iss_am_rega),.b(mux_imregb),.aluout(aluout),.op(iss_am_aluop),.unsig(iss_am_unsig),.overflow(aluov));
    Shifter SHIFTER(.in(iss_am_regb),.shiftop(iss_am_shiftop),.shiftamt(iss_am_shiftamt),.result(result));

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            am_wb_oper <= 1'b0;  
            am_wb_regdest <= 5'b00000;
            am_wb_writereg <= 1'b0;
            am_wb_wbvalue <= 32'h0000_0000;
        end else if (~iss_am_oper) begin
            am_wb_oper <= 1'b0;  
            am_wb_regdest <= 5'b00000;
            am_wb_writereg <= 1'b0;
            am_wb_wbvalue <= 32'h0000_0000;
        end else begin
            am_wb_oper <= 1'b1;
            am_wb_regdest <= iss_am_regdest;
            am_wb_writereg <= (!aluov | iss_am_writeov) & iss_am_writereg;
            am_wb_wbvalue <= (iss_am_selalushift) ? result : aluout;
        end
    end

endmodule

`endif
