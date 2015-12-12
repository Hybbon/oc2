// Ram32.v - RAM de 128 palavras de 32 bits cada
// (Adaptação do módulo Ram.v)

`ifndef RAM32_V
`define RAM32_V

module Ram (
    input clock,
    input reset,
    input [6:0] addr, // Endereço a ser lido/escrito
    input [31:0] data_in, // Dados a ser escritos
    output [31:0] data_out, // Dados a ser lidos
    input wre, // 0: Leitura, 1: Escrita
    input instr_load, // 1: Preenche a memória com instruções no reset
    input data_load // 1: Preenche a memória com dados no reset
);

    reg [31:0] memory [0:127];
    integer i;

    assign data_out = memory[addr];

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            if (instr_load == 1'b1) begin
                memory[0] <= 32'h00000000;
                memory[1] <= 32'h00000000;
                memory[2] <= 32'h200b0003;
                memory[3] <= 32'h200b0000;
                memory[4] <= 32'h200a0000;
                memory[5] <= 32'h2009000a;
                memory[6] <= 32'h08000008;
                memory[7] <= 32'h200a0014;
                memory[8] <= 32'h2008000a;
                memory[9] <= 32'h200c0028;
                memory[10] <= 32'h11090002;
                memory[11] <= 32'h00000000;
                memory[12] <= 32'h200a0014;
                memory[13] <= 32'h200c003c;
                memory[14] <= 32'h15880002;
                memory[15] <= 32'h00000000;
                memory[16] <= 32'h200a0014;
                memory[17] <= 32'h200c0050;
                memory[18] <= 32'h18000002;
                memory[19] <= 32'h00000000;
                memory[20] <= 32'h200a0014;
                memory[21] <= 32'h200c0064;
                memory[22] <= 32'h1d800002;
                memory[23] <= 32'h00000000;
                memory[24] <= 32'h200a0014;
                memory[25] <= 32'h200c0078;
                memory[26] <= 32'h1120000d;
                memory[27] <= 32'h200c008c;
                memory[28] <= 32'h00000000;
                memory[29] <= 32'h1540000a;
                memory[30] <= 32'h200c00a0;
                memory[31] <= 32'h00000000;
                memory[32] <= 32'h19200007;
                memory[33] <= 32'h200c00b4;
                memory[34] <= 32'h00000000;
                memory[35] <= 32'h1c000004;
                memory[36] <= 32'h200c00c8;
                memory[37] <= 32'h00000000;
                memory[38] <= 32'h08000029;
                memory[39] <= 32'h00000000;
                memory[40] <= 32'h200a0014;
                memory[41] <= 32'h200c00dc;
                for (i = 42; i < 128; i = i + 1) begin
                    memory[i] = 32'h00000000;
                end
            end else if (data_load == 1'b1) begin
                for (i = 0; i < 128; i = i + 1) begin
                    memory[i] = i[31:0];
                end
            end else begin
                for (i = 0; i < 128; i = i + 1) begin
                    memory[i] = 32'h00000000;
                end
            end
        end else if (wre) begin
            memory[addr] <= data_in[31:0];
        end
    end
   
endmodule

`endif
