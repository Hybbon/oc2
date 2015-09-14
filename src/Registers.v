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
	input [4:0] addrout,
	output [31:0] regout
);

   reg [31:0] registers [31:0];

	/*assign regout = {registers[31],registers[30],registers[29],registers[28],
					 registers[27],registers[26],registers[25],registers[24],
					 registers[23],registers[22],registers[21],registers[20],
					 registers[19],registers[18],registers[17],registers[16],
					 registers[15],registers[14],registers[13],registers[12],
					 registers[11],registers[10],registers[9],registers[8],
					 registers[7],registers[6],registers[5],registers[4],
					 registers[3],registers[2],registers[1],registers[0]};*/
	assign regout = registers[addrout];
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
