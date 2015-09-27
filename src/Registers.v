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
    output [31:0] reg_out_data
);

   reg [31:0] registers [31:0];

	assign reg_out_data = registers[reg_out_id];
    assign ass_dataa = registers[addra];
    assign ass_datab = registers[addrb];

    reg [5:0] i;
    generate
        always @(posedge clock or negedge reset) begin
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
