`ifndef EXECUTE_V
`define EXECUTE_V

`include "./src/Alu.v"
`include "./src/Shifter.v"

module Execute (
    input                   clock,
    input                   reset,
    //Decode
    input                   id_ex_selalushift,
    input                   id_ex_selimregb,
    input         [2:0]     id_ex_aluop,
    input                   id_ex_unsig,
    input         [1:0]     id_ex_shiftop,
    input         [4:0]     id_ex_shiftamt,
    input         [31:0]    id_ex_rega,
    input                   id_ex_readmem,
    input                   id_ex_writemem,
    input         [31:0]    id_ex_regb,
    input         [31:0]    id_ex_imedext,
    input                   id_ex_selwsource,
    input         [4:0]     id_ex_regdest,
    input                   id_ex_writereg,
    input                   id_ex_writeov,
    //Fetch
    output reg              ex_if_stall,
    //Memory
    output reg              ex_mem_readmem,
    output reg              ex_mem_writemem,
    output reg    [31:0]    ex_mem_regb,
    output reg              ex_mem_selwsource,
    output reg    [4:0]     ex_mem_regdest,
    output reg              ex_mem_writereg,
    output reg    [31:0]    ex_mem_wbvalue
);

    wire    [31:0]    aluout;
    wire              aluov;
    wire    [31:0]    result;
    wire    [31:0]    mux_imregb;

    assign mux_imregb = (id_ex_selimregb) ? id_ex_imedext : id_ex_regb;

    Alu ALU(.a(id_ex_rega),.b(mux_imregb),.aluout(aluout),.op(id_ex_aluop),.unsig(id_ex_unsig),.overflow(aluov));
    Shifter SHIFTER(.in(id_ex_regb),.shiftop(id_ex_shiftop),.shiftamt(id_ex_shiftamt),.result(result));
    
    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            ex_if_stall <= 1'b0;
            ex_mem_readmem <= 1'b0;
            ex_mem_writemem <= 1'b0;
            ex_mem_regb <= 32'h0000_0000;
            ex_mem_selwsource <= 1'b0;
            ex_mem_regdest <= 5'b00000;
            ex_mem_writereg <= 1'b0;
            ex_mem_wbvalue <= 32'h0000_0000;
        end else begin
            ex_if_stall <= id_ex_readmem | id_ex_writemem;
            ex_mem_readmem <= id_ex_readmem;
            ex_mem_writemem <= id_ex_writemem;
            ex_mem_regb <= id_ex_regb;
            ex_mem_selwsource <= id_ex_selwsource;
            ex_mem_regdest <= id_ex_regdest;
            ex_mem_writereg <= (!aluov | id_ex_writeov) & id_ex_writereg;
            ex_mem_wbvalue <= (id_ex_selalushift) ? result : aluout;
        end
    end

 endmodule

`endif
