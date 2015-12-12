// Mult_tb0.v - Testbench para o módulo composto Mult

`include "./src/AluMisc.v"

module AluMisc_TB0;
    reg clock;
    reg reset;

    reg oper;

    reg [31:0] op_a;
    reg [31:0] op_b;
    reg [31:0] imm;
    reg [2:0] aluop;

    reg imm_or_reg;

    wire [4:0] am_wb_regdest;
    wire am_wb_writereg;
    wire [31:0] res;
    wire oper_out;

    AluMisc ALUMISC (
        .clock(clock),
        .reset(reset),

        .iss_am_oper(oper),

        .iss_am_selalushift(1'b0), // possível bug
        .iss_am_selimregb(imm_or_reg),
        .iss_am_aluop(aluop),
        .iss_am_unsig(1'b0),
        .iss_am_shiftop(2'b00),
        .iss_am_shiftamt(5'b00000),
        .iss_am_rega(op_a),        
        .iss_am_regb(op_b),
        .iss_am_imedext(imm),
        .iss_am_writereg(1'b1),
        .iss_am_writeov(1'b1),

        .am_wb_regdest(am_wb_regdest),
        .am_wb_writereg(am_wb_writereg),
        .am_wb_wbvalue(res),

        .am_wb_oper(oper_out)
    );

    initial begin
        $dumpfile("alumisc_tb0.vcd");
        $dumpvars;

        $display("Clock\t\tOper\tA\tB\tRes");
        $monitor("%d\t%d\t%d\t%d\t%d", clock, oper, op_a, op_b, res); 

        #500 $finish;
    end

    initial begin
        oper = 1'b0;
        imm_or_reg = 1'b0;
        imm = 32'h0001_0000;
        aluop = 3'b010;
        #2 op_a = 32'h0000_0002;
        op_b = 32'hFFFF_FFFD;
        #2 oper = 1'b1;
        #8 oper = 1'b0;
        #3 aluop = 3'b110;
        #3 oper = 1'b1;
        #6 oper = 1'b0;



        #500 $finish;
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
