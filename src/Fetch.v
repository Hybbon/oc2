`ifndef FETCH_V
`define FETCH_V

`include "./Ram32.v"

module Fetch (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_if_stall,
    //Decode
    output reg    [31:0]    if_id_nextpc,
    output reg    [31:0]    if_id_instruc,
    input                   id_if_selpcsource,
    input         [31:0]    id_if_rega,
    input         [31:0]    id_if_pcimd2ext,
    input         [31:0]    id_if_pcindex,
    input         [1:0]     id_if_selpctype
);

    reg    [31:0]   pc;

    wire [6:0] instr_addr;
    wire [31:0] instr_data;
    wire instr_wre = 1'b0;

    assign instr_addr = pc[8:2];

    Ram instr_ram (
        .addr(instr_addr),
        .data(instr_data),
        .wre(instr_wre)
    );

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            if_id_instruc <= 32'h0000_0000;
            pc <= 32'h0000_0000;
        end else begin
            if (ex_if_stall) begin
                if_id_instruc <= 32'h0000_0000;
                if_id_nextpc <= pc;
            end else begin
                if_id_instruc <= instr_data;
                if (id_if_selpcsource) begin
                    case (id_if_selpctype)
                        2'b00: pc <= id_if_pcimd2ext;
                        2'b01: pc <= id_if_rega;
                        2'b10: pc <= id_if_pcindex;
                        2'b11: pc <= 32'h0000_0040;
                        default: pc <= 32'hXXXX_XXXX;
                    endcase
                    case (id_if_selpctype)
                        2'b00: if_id_nextpc <= id_if_pcimd2ext;
                        2'b01: if_id_nextpc <= id_if_rega;
                        2'b10: if_id_nextpc <= id_if_pcindex;
                        2'b11: if_id_nextpc <= 32'h0000_0040;
						default: if_id_nextpc <= 32'hXXXX_XXXX;
                        //default: pc <= 32'hXXXX_XXXX;
                    endcase
                end else begin
                    pc <= pc + 32'h0000_0004;
                end
            end
        end
    end

endmodule

`endif
