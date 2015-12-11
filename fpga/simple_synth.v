`include "./fpga/DisplayDecoder.v"
`include "./fpga/ClockDivider.v"

module simple_synth (
    input CLOCK_50,
    input [3:0] KEY,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3,
    output [0:6] HEX4,
    output [0:6] HEX5,
    output [0:6] HEX6,
    output [0:6] HEX7,
    output [7:0] LEDG
);

    wire clock;
    wire reset;

    assign reset = KEY[0];

    ClockDivider cd (
        .in(CLOCK_50),
        .reset(reset),
        .divider(5'd24),
        .out(clock)
    );

    assign LEDG[0] = clock;

    reg [31:0] val;

    always@(posedge clock or negedge reset) begin
        if (~reset) begin
            val <= 32'h0000_0000;
        end else begin
            val <= val + 32'h0000_0001;
        end
    end

    wire [3:0] dd7_in;
    wire [3:0] dd6_in;
    wire [3:0] dd5_in;
    wire [3:0] dd4_in;
    wire [3:0] dd3_in;
    wire [3:0] dd2_in;
    wire [3:0] dd1_in;
    wire [3:0] dd0_in;

    assign dd7_in = val[31:28];
    assign dd6_in = val[27:24];
    assign dd5_in = val[23:20];
    assign dd4_in = val[19:16];
    assign dd3_in = val[15:12];
    assign dd2_in = val[11:8];
    assign dd1_in = val[7:4];
    assign dd0_in = val[3:0];

    wire [0:6] hex0out;
    wire [0:6] hex1out;
    wire [0:6] hex2out;
    wire [0:6] hex3out;
    wire [0:6] hex4out;
    wire [0:6] hex5out;
    wire [0:6] hex6out;
    wire [0:6] hex7out;

    DisplayDecoder dd7(
        .in(dd7_in),
        .out(hex7out)
    );

    DisplayDecoder dd6(
        .in(dd6_in),
        .out(hex6out)
    );

    DisplayDecoder dd5(
        .in(dd5_in),
        .out(hex5out)
    );

    DisplayDecoder dd4(
        .in(dd4_in),
        .out(hex4out)
    );

    DisplayDecoder dd3(
        .in(dd3_in),
        .out(hex3out)
    );

    DisplayDecoder dd2(
        .in(dd2_in),
        .out(hex2out)
    );    

    DisplayDecoder dd1(
        .in(dd1_in),
        .out(hex1out)
    );

    DisplayDecoder dd0(
        .in(dd0_in),
        .out(hex0out)
    );

    assign HEX0 = hex0out;
    assign HEX1 = hex1out;
    assign HEX2 = hex2out;
    assign HEX3 = hex3out;
    assign HEX4 = hex4out;
    assign HEX5 = hex5out;
    assign HEX6 = hex6out;
    assign HEX7 = hex7out;
    

endmodule