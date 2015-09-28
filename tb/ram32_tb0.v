// Ram32_tb0.v - Testbench para o módulo Ram32

`include "./src/Ram32.v"

module Ram32_TB0;
    reg [6:0] addr;   // Endereço a ser lido/escrito
    wire [31:0] data_out;
    reg [31:0] data_in; // Valor a ser escrito
    reg wre;

    reg clock;
    reg reset;

    Ram ram (
        .clock(clock),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out),
        .wre(wre),
        .instr_load(1'b0),
        .data_load(1'b0)
    );

    initial begin
        $dumpfile("ram32_tb0.vcd");
        $dumpvars;

        $display("Data\t\tAddr\tWrite");
        $monitor("%d\t%d\t%d\t%d", data_in, data_out, addr, wre); 

        #500 $finish;
    end

    initial begin
        #4 wre = 1'b1;
        addr[6:0] = 7'b0000000;
        data_in[31:0] = 32'hBBBBBBBB;

        #10 addr[6:0] = 7'b0000001;
        data_in[31:0] = 32'hAAAAAAAA;

        #10 wre = 1'b0;
        addr[6:0] = 7'b0000000;

        #500 $finish;
    end 

    initial begin
        clock <= 0;
        reset <= 1;
        #1 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock <= ~clock;
    end
endmodule
