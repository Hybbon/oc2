`ifndef MEM_ONE
`define MEM_ONE

`include "./src/Ram32.v"

module Mem_1 (
    input clock,
    input reset,
    input mem_ram_load,

    input m0_m1_oper,
    input m0_m1_readmem,
    input m0_m1_writemem,
    input [31:0] m0_m1_data_addr,
    input [31:0] m0_m1_regb,
    input [4:0] m0_m1_regdest,
    input m0_m1_writereg,

    output reg [4:0] m1_mem_regdest,
    output reg m1_mem_writereg,
    output reg [31:0] m1_mem_wbvalue
);
    
    wire [6:0] data_addr;
    assign data_addr = m0_m1_data_addr[8:2];

    wire data_wre;
    assign data_wre = !m0_m1_readmem & m0_m1_writemem;

    wire [31:0] data_data_out;

    Ram data_ram (
        .clock(clock),
        .reset(reset),
        .addr(data_addr),
        .data_in(m0_m1_regb),
        .data_out(data_data_out),
        .wre(data_wre),
        .instr_load(1'b0),
        .data_load(mem_ram_load)
    );

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            m1_mem_regdest <= 5'b00000;
            m1_mem_writereg <= 1'b0;
            m1_mem_wbvalue <= 32'h0000_0000;
        end else if (~m0_m1_oper) begin
            m1_mem_regdest <= 5'b00000;
            m1_mem_writereg <= 1'b0;
            m1_mem_wbvalue <= 32'h0000_0000;
        end else begin
            m1_mem_regdest <= m0_m1_regdest;
            m1_mem_writereg <= m0_m1_writereg;
            m1_mem_wbvalue <= data_data_out;
        end
    end
   
endmodule

`endif
