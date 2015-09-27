`include "./src/Mips.v"
`include "./fpga/displayDecoder.v"

module mips_synth(
    input [3:1] KEY,
    input [6:0] SW,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3,
    output [0:6] HEX4,
    output [0:6] HEX5,
    output [0:6] HEX6,
    output [0:6] HEX7
);

    wire [31:0] reg_out_data;

    Mips mips(
        .clock(KEY[3]),
        .reset(KEY[2]),
        .reg_out_id(SW[4:0]),
        .reg_out_data(reg_out_data),
        .fetch_ram_load(SW[5]),
        .mem_ram_load(SW[6])
    );

    DisplayDecoder dd7(
        .in(reg_out_data[31:28]),
        .out(HEX7)
    );

    DisplayDecoder dd6(
        .in(reg_out_data[27:24]),
        .out(HEX6)
    );

    DisplayDecoder dd5(
        .in(reg_out_data[23:20]),
        .out(HEX5)
    );

    DisplayDecoder dd4(
        .in(reg_out_data[19:16]),
        .out(HEX4)
    );

    DisplayDecoder dd3(
        .in(reg_out_data[15:12]),
        .out(HEX3)
    );

    DisplayDecoder dd2(
        .in(reg_out_data[11:8]),
        .out(HEX2)
    );    

    DisplayDecoder dd1(
        .in(reg_out_data[7:4]),
        .out(HEX1)
    );

    DisplayDecoder dd0(
        .in(reg_out_data[3:0]),
        .out(HEX0)
    );

    

endmodule