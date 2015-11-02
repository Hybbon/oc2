// Mult_tb0.v - Testbench para o módulo composto Mult

`include "./src/Mult.v"

module Mult_TB0;
    reg clock;
    reg reset;

    reg oper;

    reg [31:0] op_a;
    reg [31:0] op_b;

    wire [4:0] mul_wb_regdest;
    wire mul_wb_writereg;
    wire [31:0] res;
    wire mul_wb_oper;

    Mult MULT (
        .clock(clock),
        .reset(reset),
        
        .iss_mul_oper(oper),
        .iss_mul_rega(op_a),
        .iss_mul_regb(op_b),
        .iss_mul_regdest(5'b00000),

        .mul_wb_regdest(mul_wb_regdest),
        .mul_wb_writereg(mul_wb_writereg),
        .mul_wb_wbvalue(res),
        .mul_wb_oper(mul_wb_oper)
    );

    initial begin
        $dumpfile("mult_tb0.vcd");
        $dumpvars;

        $display("Clock\t\tOper\tA\tB\tRes");
        $monitor("%d\t%d\t%d\t%d\t%d", clock, oper, op_a, op_b, res); 

        #500 $finish;
    end

    initial begin
        oper = 1'b0;
        #2 op_a = 32'h0000_0002;
        op_b = 32'hFFFF_FFFD;
        #2 oper = 1'b1;
        #8 oper = 1'b0;


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
