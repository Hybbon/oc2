module Writeback (
    //Memory
    input    [4:0]     mem_wb_regdest,
    input              mem_wb_writereg,
    input    [31:0]    mem_wb_wbvalue,
    //Registers
    output              wb_reg_en,
    output    [4:0]     wb_reg_addr,
    output    [31:0]    wb_reg_data
);

    assign wb_reg_en = mem_wb_writereg;
    assign wb_reg_addr = mem_wb_regdest;
    assign wb_reg_data = mem_wb_wbvalue;

endmodule
