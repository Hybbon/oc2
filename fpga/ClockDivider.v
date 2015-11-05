`ifndef CLOCKDIVIDER_V
`define CLOCKDIVIDER_V

module ClockDivider (
    input in,
    input reset,
    input [4:0] divider,
    output out
);

reg [31:0] sum;

assign out = sum[divider];

always @(posedge in or negedge in or negedge reset) begin
    if (~reset) begin
        sum = 32'h0000_0000;
    end else begin
        sum = sum + 32'h0000_0001; 
    end
end

endmodule

`endif