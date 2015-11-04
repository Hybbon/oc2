`ifndef HAZARDDETECTOR_V
`define HAZARDDETECTOR_V

module HazardDetector (
    input ass1_pending,
    input [4:0] ass1_row,

    input ass2_pending,
    input [4:0] ass2_row,

    output stalled 
);

assign stalled = ass1_pending && !(ass1_row[0]) ||
                 ass2_pending && !(ass2_row[0]) ||
                 ass1_row[4:1] != 0 || ass2_row[4:1] != 0; // Redundant

endmodule

`endif