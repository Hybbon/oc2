`ifndef MEM_ZERO
`define MEM_ZERO

module Mem_0 (
    input clock,
    input reset,
    input [6:0] addr, // Endereço a ser lido/escrito
    input ex_mem_readmem,
    input ex_mem_writemem,
    output [6:0] addr_out,
    output wre_out
);

    reg [6:0] addr_reg;

    assign wre_out = (!ex_mem_readmem & ex_mem_writemem);

    always @(posedge clock or negedge reset) begin
        addr_reg = addr;
    end

endmodule

`endif