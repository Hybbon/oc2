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
    //Memory Controller
    output                  mem_mc_rw,
    output                  mem_mc_en,
    output        [17:0]    mem_mc_addr,
    inout         [31:0]    mem_mc_data,
    //Writeback
    output reg    [4:0]     mem_wb_regdest,
    output reg              mem_wb_writereg,
    output reg    [31:0]    mem_wb_wbvalue
);

    assign mem_mc_rw = (!ex_mem_readmem & ex_mem_writemem);
    assign mem_mc_en = (ex_mem_readmem | ex_mem_writemem);
    assign mem_mc_addr = ex_mem_wbvalue[17:0];
    assign mem_mc_data = (mem_mc_rw) ? ex_mem_regb : 32'hZZZZ_ZZZZ;

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            mem_wb_regdest <= 5'b00000;
            mem_wb_writereg <= 1'b0;
            mem_wb_wbvalue <= 32'h0000_0000;
        end else begin
            mem_wb_regdest <= ex_mem_regdest;
            mem_wb_writereg <= ex_mem_writereg;
            if (ex_mem_selwsource==1'b1) begin
                mem_wb_wbvalue <= mem_mc_data;
            end else begin
                mem_wb_wbvalue <= ex_mem_wbvalue;
            end
        end
    end

endmodule
