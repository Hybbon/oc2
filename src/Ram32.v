// Ram32.v - RAM de 128 palavras de 32 bits cada
// (Adaptação do módulo Ram.v)

`ifndef RAM32_V
`define RAM32_V

module Ram (
    input    [6:0]    addr,     // Endereço a ser lido/escrito
    inout    [31:0]   data,     // Dados lidos/a ser escritos
    input             wre       // 0: Leitura, 1: Escrita
);

    reg     [31:0]    memory    [0:127];
    wire    [31:0]    q;

    assign q = memory[addr];

    // [!] Sobre interfaces bidirecionais (inout)
    // Interfaces do tipo inout devem ser usadas interna e externamente como
    // wires (nets), NUNCA como regs. Externamente, elas são legíveis quando o
    // fio externo está definido como Z, e o interno como o valor de saída. O
    // contrário ocorre na entrada: para escrever em uma interface bidirecional,
    // é preciso definir o fio externo como o valor a ser escrito e definir o
    // interno como Z.
    assign data[31:0]  = wre ? 32'hZZZZZZZZ : q[31:0];

    always @(wre or addr or data) begin
        if (wre)
           memory[addr] = data[31:0];
    end
   
endmodule

`endif
