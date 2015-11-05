`ifndef CLOCKDIVIDER_V
`define CLOCKDIVIDER_V

module ClockDivider (
    input in,
    input [4:0] divider,
    output out
);

reg [31:0] sum;

assign out = sum[divider];

always @(posedge in or negedge in) begin
    out = out + 32'h0000_0001;
end

`endif