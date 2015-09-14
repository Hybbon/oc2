module Ram32_TB0;
    reg [7:0] addr;
    reg [31:0] data;
    reg wre;
    reg chip_en = 1'b0;

    Ram ram (
        .addr(addr),
        .data(data),
        .wre(wre),
        .chip_en(chip_en)
    );

initial begin
        $dumpfile("ram32_tb0.vcd");
        $dumpvars;

        $display("\t\tData\tAddr\tWrite");
        $monitor("\t%d", data); 

        #500 $finish;
    end_

    initial begin
        wre <= 1'b1;
        addr <= 8'd0;
        data <= 32'd455556;
    end 
endmodule
