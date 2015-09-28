/**
 * Testbench 1 - Load e Store
 * Esse testbench pretende testar a funcionalidade das instruções lw e sw não-
 * -extensivamente.
 */

`include "./src/Mips.v"

module Mips_TB;
    reg clock, reset;

    reg [4:0] reg_out_id;
    wire [31:0] reg_out_data;

    wire fetch_ram_load;
    wire mem_ram_load;

    assign fetch_ram_load = 1'b0;
    assign mem_ram_load = 1'b0;

    Mips mips(
        .clock(clock),
        .reset(reset),
        .reg_out_id(reg_out_id),
        .reg_out_data(reg_out_data),
        .fetch_ram_load(fetch_ram_load),
        .mem_ram_load(mem_ram_load)
    );
    
    initial begin
        #10 $readmemh("../tb/mips_tb1_load_store.hex", mips.FETCH.instr_ram.memory);
        #10 $readmemh("../tb/mips_tb1_load_store_data.hex", mips.MEMORY.data_ram.memory);

        $dumpfile("mips_tb1.vcd");
        $dumpvars;

        $display("\t\t$s2\t$s3\t&8\t&12");
        $monitor("\t%d%d%d\t%d",
            mips.REGISTERS.registers[18],
            mips.REGISTERS.registers[19],
            mips.MEMORY.data_ram.memory[2],
            mips.MEMORY.data_ram.memory[3]
        );

        #2000 $writememh("mips_tb1_load_store_data_out.hex", mips.MEMORY.data_ram.memory);
        #3000 $finish;
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