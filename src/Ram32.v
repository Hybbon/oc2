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
                memory[2] <= 32'h20100000;
                memory[3] <= 32'h20081414;
                memory[4] <= 32'h20094141;
                memory[5] <= 32'h00000000;
                memory[6] <= 32'h00000000;
                memory[7] <= 32'h00000000;
                memory[8] <= 32'hae08000c;
                memory[9] <= 32'h00000000;
                memory[10] <= 32'h00000000;
                memory[11] <= 32'h00000000;
                memory[12] <= 32'hae090010;
                memory[13] <= 32'h00000000;
                memory[14] <= 32'h00000000;
                memory[15] <= 32'h00000000;
                memory[16] <= 32'h8e11000c;
                memory[17] <= 32'h00000000;
                memory[18] <= 32'h00000000;
                memory[19] <= 32'h00000000;
                memory[20] <= 32'h8e120010;
                memory[21] <= 32'h00000000;
                memory[22] <= 32'h00000000;
                memory[23] <= 32'h00000000;
                memory[24] <= 32'h02329820;
                for (i = 25; i < 128; i = i + 1) begin
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
