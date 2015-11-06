// Registers_tb0.v - Testbench para o módulo Registers

`include "./src/Registers.v"

module Registers_TB0;

    reg clock;
    reg reset;

    reg  [4:0]  addra;
    wire [31:0] dataa;
    wire [31:0] ass_dataa;
    reg  [4:0]  addrb;
    wire [31:0] datab;
    wire [31:0] ass_datab;
    reg        enc;
    reg  [4:0]  addrc;
    reg  [31:0] datac;

    Registers REGISTERS (
        .clock(clock),
        .reset(reset),
        .addra(addra),
        .dataa(dataa),
        .ass_dataa(ass_dataa),
        .addrb(addrb),
        .datab(datab),
        .ass_datab(ass_datab),
        .enc(enc),
        .addrc(addrc),
        .datac(datac)// ,
        // .reg_out_id(),
        // .reg_out_data(),
        // .addr_iss_a(),
        // .ass_data_iss_a(),
        // .addr_iss_b(),
        // .ass_data_iss_b(),
        // .reg_out_0(),
        // .reg_out_1(),
        // .reg_out_2(),
        // .reg_out_3(),
        // .reg_out_4()
    );

    initial begin
        $dumpfile("registers_tb0.vcd");
        $dumpvars;

        $display("Clock\tAddrA\t\tA\t\tA_async\tAddrB\t  B\tB_async\tAddrC");
        $monitor("%d\t%d\t%d\t%d\t%d", clock, addra, dataa, ass_dataa, addrb, datab, ass_datab, addrc); 

        #500 $finish;
    end

    initial begin
        addra <= 5'd1;
        addrb <= 5'd2;
        #4 enc <= 1'b1;
        addrc <= 5'd1;
        datac <= 32'd20;
        #10  enc <= 1'b1;
        addrc <= 5'd2;
        datac <= 32'd109;
        #16 enc <= 1'b0;
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