/**
 * Testbench 0 - Esqueleto e ALU
 * Este testbench básico realiza testes aritméticos, realizando várias adições.
 * Sua função principal é garantir que o esqueleto dos testbenches esteja fun-
 * cionando corretamente, assim como testar instruções básicas da ALU, necessá-
 * rias para o bom funcionamento de qualquer outro programa. São monitorados os
 * sinais de entrada da ALU, do opcode e da saída desse módulo
 */

`include "./src/Mips.v"

module Mips_TB;
    reg clock, reset;

    reg [4:0] reg_out_id;
    wire [31:0] reg_out_data;

    Mips mips(
        .clock(clock),
        .reset(reset),
        .reg_out_id(reg_out_id),
        .reg_out_data(reg_out_data),
        .fetch_ram_load(1'b0),
        .mem_ram_load(1'b0)
    );

    initial begin
        #10 $readmemh("../tb/mips_tb0_arith_basic.hex", mips.FETCH.instr_ram.memory);

        $dumpfile("mips_tb0.vcd");
        $dumpvars;

        $display("\t\tA\tB\tOut\tAluOP");
        $monitor("\t%d%d%d\t%d", mips.EXECUTE.id_ex_rega, mips.EXECUTE.mux_imregb, mips.EXECUTE.aluout, mips.EXECUTE.id_ex_aluop);

        #500 $finish;
    end

    initial begin
        clock <= 0;
        reset <= 1;
        #2 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock <= ~clock;
    end

endmodule