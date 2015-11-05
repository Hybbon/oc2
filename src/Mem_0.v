`ifndef MEM_ZERO
`define MEM_ZERO

module Mem_0 (
    input clock,
    input reset,
    
    input mem_m0_oper,
    input mem_m0_readmem,
    input mem_m0_writemem,
    input [31:0] mem_m0_rega,
    input [31:0] mem_m0_imedext,
    input [31:0] mem_m0_regb,
    input [4:0] mem_m0_regdest,
    input mem_m0_writereg,

    output reg m0_m1_oper,
    output reg m0_m1_readmem,
    output reg m0_m1_writemem,
    output reg [31:0] m0_m1_data_addr,
    output reg [31:0] m0_m1_regb,
    output reg [4:0] m0_m1_regdest,
    output reg m0_m1_writereg
);

    always @(posedge clock or negedge reset) begin
        if (~reset || ~mem_m0_oper) begin
            m0_m1_oper <= 1'b0;
            m0_m1_readmem <= 1'b0;
            m0_m1_writemem <= 1'b0;
            m0_m1_data_addr <= 32'h0000_0000;
            m0_m1_regb <= 32'h0000_0000;
            m0_m1_regdest <= 5'b00000;
            m0_m1_writereg <= 1'b0;
        end else begin
            m0_m1_oper <= 1'b1;
            m0_m1_readmem <= mem_m0_readmem;
            m0_m1_writemem <= mem_m0_writemem;
            m0_m1_data_addr <= mem_m0_rega + mem_m0_imedext;
            m0_m1_regb <= mem_m0_regb;
            m0_m1_regdest <= mem_m0_regdest;
            m0_m1_writereg <= mem_m0_writereg;
        end
    end

endmodule

`endif