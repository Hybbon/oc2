`ifndef WRITEBACK_V
`define WRITEBACK_V

module Writeback (
    input clock,
    input reset,

    // Mult
    input mul_wb_oper,
    input [4:0] mul_wb_regdest,
    input mul_wb_writereg,
    input [31:0] mul_wb_wbvalue,

    // AluMisc
    input am_wb_oper,
    input [4:0] am_wb_regdest,
    input am_wb_writereg,
    input [31:0] am_wb_wbvalue,

    // Mem
    input [4:0] mem_wb_regdest,
    input mem_wb_writereg,
    input [31:0] mem_wb_wbvalue,
    input mem_wb_oper,

    //Registers
    output reg        wb_reg_en,
    output reg [4:0]  wb_reg_addr,
    output reg [31:0] wb_reg_data
);

    // assign wb_reg_en = mem_wb_oper ? mem_wb_writereg : (
    //     am_wb_oper ? am_wb_writereg : (
    //         mul_wb_oper ? mul_wb_writereg : 1'b0
    //     )
    // );
    //
    // assign wb_reg_addr = mem_wb_oper ? mem_wb_regdest : (
    //     am_wb_oper ? am_wb_regdest : (
    //         mul_wb_oper ? mul_wb_regdest : 5'b00000
    //     )
    // );
    //
    // assign wb_reg_data = mem_wb_oper ? mem_wb_wbvalue : (
    //     am_wb_oper ? am_wb_wbvalue : (
    //         mul_wb_oper ? mul_wb_wbvalue : 32'h0000_0000
    //     )
    // );


    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            wb_reg_en <= 1'b0;
            wb_reg_addr <= 5'b00000;
            wb_reg_data <= 32'h0000_0000;
        end else begin
            if (mem_wb_oper) begin
                wb_reg_en <= mem_wb_writereg;
                wb_reg_addr <= mem_wb_regdest;
                wb_reg_data <= mem_wb_wbvalue;
            end else if (am_wb_oper) begin
                wb_reg_en <= am_wb_writereg;
                wb_reg_addr <= am_wb_regdest;
                wb_reg_data <= am_wb_wbvalue;
            end else if (mul_wb_oper) begin
                wb_reg_en <= mul_wb_writereg;
                wb_reg_addr <= mul_wb_regdest;
                wb_reg_data <= mul_wb_wbvalue;
            end else begin
                wb_reg_en <= 1'b0;
                wb_reg_addr <= 5'b00000;
                wb_reg_data <= 32'h0000_0000;
            end
        end
    end

endmodule

`endif
