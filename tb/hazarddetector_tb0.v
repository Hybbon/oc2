// Mult_tb0.v - Testbench para o módulo composto Mult

`include "./src/HazardDetector.v"

module HazardDetector_TB0;

    reg iss_ass_pending_a;
    reg [4:0] iss_ass_row_a;
    reg iss_check_a;
    reg iss_ass_pending_b;
    reg [4:0] iss_ass_row_b;
    reg iss_check_b;

    reg iss_ass_writereg;
    reg [31:0] sb_haz_column;

    wire iss_stalled;

    reg id_check_a = 1'b0;
    reg id_check_b = 1'b0;
    reg id_ass_waw_write_check = 1'b0;

    HazardDetector HZ(
        .iss_ass_pending_a(iss_ass_pending_a),
        .iss_ass_row_a(iss_ass_row_a),
        .iss_check_a(iss_check_a),

        .iss_ass_pending_b(iss_ass_pending_b),
        .iss_ass_row_b(iss_ass_row_b),
        .iss_check_b(iss_check_b),

        .id_check_a(id_check_a),
        .id_check_b(id_check_b),
        .id_ass_waw_write_check(id_ass_waw_write_check),

        .iss_ass_writereg(iss_ass_writereg),
        .sb_haz_column(sb_haz_column),
        .iss_stalled(iss_stalled)
    );

    initial begin
        $dumpfile("mult_tb0.vcd");
        $dumpvars;

        $display("A1P\tA1R\tA2P\tA2R\tChkA\tChkB\tColumn\t\tWreg\tIssSt");
        $monitor("%b\t%b\t%b\t%b\t%b\t%b\t%h\t%b\t%b",
            iss_ass_pending_a, iss_ass_row_a, iss_ass_pending_b, iss_ass_row_b,
            iss_check_a, iss_check_b, sb_haz_column, iss_ass_writereg, iss_stalled);

        #500 $finish;
    end

    initial begin
        iss_check_a = 1'b1;
        iss_check_b = 1'b1;
        iss_ass_pending_a = 1'b0;
        iss_ass_pending_b = 1'b0;
        iss_ass_row_a = 5'b00000;
        iss_ass_row_b = 5'b00000;
        sb_haz_column = 32'h0000_4000;
        iss_ass_writereg = 1'b0;
        #5 iss_ass_row_a = 5'b00100;
        #5 iss_ass_row_a = 5'b00001;
        #5 iss_ass_row_b = 5'b10000;
        #5 iss_ass_pending_b = 1'b1;
        #5 iss_ass_row_b = 5'b00001;
        #5 iss_ass_pending_b = 1'b0;
        #5 iss_ass_row_b = 5'b10000;
        #5 iss_check_b = 1'b0;
        #5 iss_check_b = 1'b1;
        #5 iss_check_b = 1'b0;
        #5 iss_ass_writereg = 1'b1;
        #5 sb_haz_column = 32'h0000_0000;

        #500 $finish;
    end
endmodule
