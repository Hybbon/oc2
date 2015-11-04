// Mult_tb0.v - Testbench para o módulo composto Mult

`include "./src/HazardDetector.v"

module HazardDetector_TB0;

    reg ass1_pending;
    reg [4:0] ass1_row;
    reg ass2_pending;
    reg [4:0] ass2_row;
    wire stalled;

    HazardDetector HZ(
        .ass1_pending (ass1_pending),
        .ass1_row (ass1_row),

        .ass2_pending (ass2_pending),
        .ass2_row (ass2_row),

        .stalled(stalled)
    );

    initial begin
        $dumpfile("mult_tb0.vcd");
        $dumpvars;

        $display("A1P\tA1R\tA2P\tA2R\tStall?");
        $monitor("%b\t%b\t%b\t%b\t%b", ass1_pending, ass1_row,
                                       ass2_pending, ass2_row,
                                       stalled); 

        #500 $finish;
    end

    initial begin
        ass1_pending = 1'b0;
        ass2_pending = 1'b0;
        ass1_row = 5'b00000;
        ass2_row = 5'b00000;
        #5 ass1_row = 5'b00100;
        #5 ass1_row = 5'b00001;
        #5 ass2_row = 5'b10000;
        #5 ass2_pending = 1'b1;
        #5 ass2_row = 5'b00001;
        #5 ass2_pending = 1'b0;

        #500 $finish;
    end 
endmodule
