// Ram32_tb0.v - Testbench para o módulo Ram32

`include "../src/Ram32.v"

module Ram32_TB0;
    reg [7:0] addr; // Endereço a ser lido/escrito
    wire [31:0] data; // Fio auxiliar - inout só interage com fios
                      // (Definido como Z para leitura, definido como o valor
                      // a ser escrito para escrita)
    reg [31:0] data_r; // Valor a ser escrito
    reg wre;

    Ram ram (
        .addr(addr),
        .data(data),
        .wre(wre)
    );

    // Permite o uso da interface bidirecional (inout)
    assign data[31:0] = wre ? data_r[31:0] : 32'hZZZZZZZZ;

    initial begin
        $dumpfile("ram32_tb0.vcd");
        $dumpvars;

        $display("Data\t\tAddr\tWrite");
        $monitor("%d\t%d\t%d", data, addr, wre); 

        #500 $finish;
    end

    initial begin
        wre <= 1'b1;
        addr[7:0] <= 8'h00;
        data_r[31:0] <= 32'hBBBBBBBB;

        #10 addr[7:0] <= 8'h01;
        data_r[31:0] <= 32'hAAAAAAAA;

        #10 wre <= 1'b0;
        addr[7:0] <= 8'h00;

        #500 $finish;
    end 
endmodule
