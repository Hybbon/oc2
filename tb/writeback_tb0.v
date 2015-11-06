// Writeback_tb0.v - Testbench para  uso de memória no módulo Writeback

`include "./src/Writeback.v"
`include "./src/Registers.v"

module Writeback_TB0;

    reg clock;
    reg reset;

    // inputs
    reg [4:0]  mem_wb_regdest;
    reg        mem_wb_writereg;
    reg [31:0] mem_wb_wbvalue;

    // interfaces
    wire        wb_reg_en;
    wire [4:0]  wb_reg_addr;
    wire [31:0] wb_reg_data;

    Writeback WRITEBACK (
        .mul_wb_oper(1'b0),
        .am_wb_oper(1'b0),
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue),
        .mem_wb_oper(1'b1),
        .wb_reg_en(wb_reg_en),
        .wb_reg_addr(wb_reg_addr),
        .wb_reg_data(wb_reg_data)
    );

    Registers REGISTERS(
        .clock(clock),
        .reset(reset),
        .enc(wb_reg_en),
        .addrc(wb_reg_addr),
        .datac(wb_reg_data)
    );

    initial begin
        $dumpfile("registers_tb0.vcd");
        $dumpvars;

        $display("Clock\tRegister\tEnable\tValue\tARF Addr\tARF Data");
        $monitor("%d\t%d\t%d\t%d\t%d\t%d", clock, mem_wb_regdest, mem_wb_writereg, mem_wb_wbvalue, wb_reg_addr, REGISTERS.registers[10]); 

        #50 $finish;
    end

    initial begin
        mem_wb_regdest  <= 5'd10;
        mem_wb_writereg <= 1'b1;
        mem_wb_wbvalue  <= 32'd37;
        #5
        mem_wb_writereg <= 1'b0;
        #15
        mem_wb_writereg <= 1'b1;
        mem_wb_wbvalue  <= 32'd90;
        #30
        mem_wb_writereg <= 1'b0;
        #50 $finish;
    end 

    initial begin
        clock <= 0;
        reset <= 1;
        #1 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock <= ~clock;
    end
    
endmodule