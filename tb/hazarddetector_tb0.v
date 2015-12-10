// Mult_tb0.v - Testbench para o módulo composto Mult

`include "./src/HazardDetector.v"

module HazardDetector_TB0;

    reg iss_ass_pending_a;
    reg [4:0] iss_ass_row_a;
    reg iss_check_a;
    reg iss_ass_pending_b;
    reg [4:0] iss_ass_row_b;
    reg iss_check_b;
    wire iss_stalled;

    HazardDetector HZ(
        .iss_ass_pending_a(iss_ass_pending_a),
        .iss_ass_row_a(iss_ass_row_a),
        .iss_check_a(iss_check_a),

        .iss_ass_pending_b(iss_ass_pending_b),
        .iss_ass_row_b(iss_ass_row_b),
        .iss_check_b(iss_check_b),

        .iss_stalled(iss_stalled)
    );

    initial begin
        $dumpfile("mult_tb0.vcd");
        $dumpvars;

        $display("A1P\tA1R\tA2P\tA2R\tChkA\tChkB\tIssSt");
        $monitor("%b\t%b\t%b\t%b\t%b\t%b\t%b",
            iss_ass_pending_a, iss_ass_row_a, iss_ass_pending_b, iss_ass_row_b,
            iss_check_a, iss_check_b, iss_stalled);

        #500 $finish;
    end

    initial begin
        iss_check_a = 1'b1;
        iss_check_b = 1'b1;
        iss_ass_pending_a = 1'b0;
        iss_ass_pending_b = 1'b0;
        iss_ass_row_a = 5'b00000;
        iss_ass_row_b = 5'b00000;
        #5 iss_ass_row_a = 5'b00100;
        #5 iss_ass_row_a = 5'b00001;
        #5 iss_ass_row_b = 5'b10000;
        #5 iss_ass_pending_b = 1'b1;
        #5 iss_ass_row_b = 5'b00001;
        #5 iss_ass_pending_b = 1'b0;
        #5 iss_ass_row_b = 5'b10000;
        #5 iss_check_b = 1'b0;
        #5 iss_check_b = 1'b1;

        #500 $finish;
    end
endmodule
