`ifndef REGISTERS_V
`define REGISTERS_V

module Registers (
    input                   clock,
    input                   reset,
    input         [4:0]     addra,
    output reg    [31:0]    dataa,
    output        [31:0]    ass_dataa,
    input         [4:0]     addrb,
    output reg    [31:0]    datab,
    output        [31:0]    ass_datab,
    input                   enc,
    input         [4:0]     addrc,
    input         [31:0]    datac,
	input [4:0] reg_out_id,
    output [31:0] reg_out_data,

    // registers for issue stage
    input         [4:0]     addr_iss_a,
    input         [4:0]     addr_iss_b,
    output        [31:0]    ass_data_iss_a,
    output        [31:0]    ass_data_iss_b,

    output [31:0] reg_out_0,
    output [31:0] reg_out_1,
    output [31:0] reg_out_2,
    output [31:0] reg_out_3,
    output [31:0] reg_out_4
);

    reg [31:0] registers [31:0];

    assign reg_out_0 = registers[0];
    assign reg_out_1 = registers[1];
    assign reg_out_2 = registers[2];
    assign reg_out_3 = registers[3];
    assign reg_out_4 = registers[4];

	assign reg_out_data = registers[reg_out_id];
    assign ass_dataa = registers[addra];
    assign ass_datab = registers[addrb];

    assign ass_data_iss_a = registers[addr_iss_a];
    assign ass_data_iss_b = registers[addr_iss_b];

    reg [5:0] i;
    generate
        always @(negedge clock or negedge reset) begin
            if (~reset) begin
                for (i=0; i<32; i=i+1) begin: Reg
                    registers[i] <= 32'h0000_0000;
                end
            end else begin
                dataa <= registers[addra];
                datab <= registers[addrb];
                if (enc) begin
                    registers[addrc] <= datac;
                end
            end
        end
    endgenerate

endmodule

`endif
