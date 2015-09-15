module Ram (
    input    [6:0]    addr      // Endereço a ser acessado
    inout    [31:0]   data      // Dados lidos/a ser escritos
    input             wre       // 0: Leitura, 1: Escrita
);

    reg     [31:0]    memory    [0:127];
    wire    [31:0]    q;

    assign q = memory[addr];
    assign data[31:0]  = wre ? 32'hZZZZZZZZ : q[31:0];

    always @(wre or addr or data) begin
        if (wre)
           memory[addr] = data[31:0];
    end
    
endmodule
