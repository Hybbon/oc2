`ifndef MEM_ZERO
`define MEM_ZERO

module Mem_0 (
    input clock,
    input reset,
    input ex_mem_readmem,
    input ex_mem_writemem,
    input [31:0] ex_mem_wbvalue,
    output [6:0] addr_out,
    output wre_out
);

    assign addr_out = ex_mem_wbvalue[8:2];
    assign wre_out = (!ex_mem_readmem & ex_mem_writemem);

    always @(posedge clock or negedge reset) begin

    end

endmodule

`endif