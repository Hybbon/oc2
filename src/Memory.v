`ifndef MEMORY_V
`define MEMORY_V

`include "./Ram32.v"

module Memory (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_mem_readmem,
    input                   ex_mem_writemem,
    input         [31:0]    ex_mem_regb,
    input                   ex_mem_selwsource,
    input         [4:0]     ex_mem_regdest,
    input                   ex_mem_writereg,
    input         [31:0]    ex_mem_wbvalue,
    //Writeback
    output reg    [4:0]     mem_wb_regdest,
    output reg              mem_wb_writereg,
    output reg    [31:0]    mem_wb_wbvalue
);


    wire [6:0] data_addr;
    wire [31:0] data_data; // lol
    wire data_wre;

    assign data_addr = ex_mem_wbvalue[8:2];
    assign data_wre = (!ex_mem_readmem & ex_mem_writemem);
    assign data_data = data_wre ? ex_mem_regb : 32'hZZZZ_ZZZZ;

    Ram data_ram (
        .addr(data_addr),
        .data(data_data),
        .wre(data_wre)
    );

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            mem_wb_regdest <= 5'b00000;
            mem_wb_writereg <= 1'b0;
            mem_wb_wbvalue <= 32'h0000_0000;
        end else begin
            mem_wb_regdest <= ex_mem_regdest;
            mem_wb_writereg <= ex_mem_writereg;
            if (ex_mem_selwsource==1'b1) begin
                mem_wb_wbvalue <= data_data;
            end else begin
                mem_wb_wbvalue <= ex_mem_wbvalue;
            end
        end
    end

endmodule

`endif
