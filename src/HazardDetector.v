`ifndef HAZARDDETECTOR_V
`define HAZARDDETECTOR_V

module HazardDetector (
    input ass_pending_a,
    input [4:0] ass_row_a,

    input ass_pending_b,
    input [4:0] ass_row_b,

    input selregdest, // 1 = check both registers, 0 = just check register 1

    output stalled 
);

assign stalled = ass_pending_a && !(ass_row_a[0]) ||
                 ass_pending_b && !(ass_row_b[0]) && selregdest ||
                 ass_row_a[4:1] != 0 || ass_row_b[4:1] != 0 && selregdest; // Redundant

endmodule

`endif