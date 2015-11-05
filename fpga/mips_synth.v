`include "./src/Mips.v"
`include "./fpga/DisplayDecoder.v"
`include "./fpga/ClockDivider.v"

module mips_synth(
    input [3:2] KEY,
    input [17:0] SW,
    input CLOCK_50,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3,
    output [0:6] HEX4,
    output [0:6] HEX5,
    output [0:6] HEX6,
    output [0:6] HEX7,
    output [8:0] LEDG,
    output [17:0] LEDR
);

    wire reset;
    assign reset = KEY[2];

    wire display_mode;
    assign display_mode = SW[17];

    wire [31:0] reg_out_data;

    wire [31:0] reg_out_0;
    wire [31:0] reg_out_1;
    wire [31:0] reg_out_2;
    wire [31:0] reg_out_3;
    wire [31:0] reg_out_4;

    ClockDivider cd (
        .in(CLOCK_50),
        .reset(reset),
        .divider(5'd24),
        .out(clock)
    );

    assign LEDG[0] = clock;

    Mips mips(
        .clock(clock),
        .reset(reset),
        .reg_out_id(SW[4:0]),
        .reg_out_data(reg_out_data),
        .fetch_ram_load(SW[5]),
        .mem_ram_load(SW[6]),
        .reg_out_0(reg_out_0),
        .reg_out_1(reg_out_1),
        .reg_out_2(reg_out_2),
        .reg_out_3(reg_out_3),
        .reg_out_4(reg_out_4)
    );


    wire [3:0] dd7_in;
    assign dd7_in = display_mode ? reg_out_data[31:28] : 4'hF;

    wire [3:0] dd6_in;
    assign dd6_in = display_mode ? reg_out_data[27:24] : 4'hF;

    wire [3:0] dd5_in;
    assign dd5_in = display_mode ? reg_out_data[23:20] : 4'hF;

    wire [3:0] dd4_in;
    assign dd4_in = display_mode ? reg_out_data[19:16] : reg_out_4[3:0];

    wire [3:0] dd3_in;
    assign dd3_in = display_mode ? reg_out_data[15:12] : reg_out_3[3:0];

    wire [3:0] dd2_in;
    assign dd2_in = display_mode ? reg_out_data[11:8] : reg_out_2[3:0];

    wire [3:0] dd1_in;
    assign dd1_in = display_mode ? reg_out_data[7:4] : reg_out_1[3:0];

    wire [3:0] dd0_in;
    assign dd0_in = display_mode ? reg_out_data[3:0] : reg_out_0[3:0];


    DisplayDecoder dd7(
        .in(dd7_in),
        .out(HEX7)
    );

    DisplayDecoder dd6(
        .in(dd6_in),
        .out(HEX6)
    );

    DisplayDecoder dd5(
        .in(dd5_in),
        .out(HEX5)
    );

    DisplayDecoder dd4(
        .in(dd4_in),
        .out(HEX4)
    );

    DisplayDecoder dd3(
        .in(dd3_in),
        .out(HEX3)
    );

    DisplayDecoder dd2(
        .in(dd2_in),
        .out(HEX2)
    );    

    DisplayDecoder dd1(
        .in(dd1_in),
        .out(HEX1)
    );

    DisplayDecoder dd0(
        .in(dd0_in),
        .out(HEX0)
    );

    

endmodule