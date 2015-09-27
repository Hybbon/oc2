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
        $readmemh("../tb/mips_synth_tb0.hex", mips.FETCH.instr_ram.memory);

        $dumpfile("mips_synth_tb0.vcd");
        $dumpvars;

        $display("\t\t$s1\t$s2\t&12\t&16");
        $monitor("\t%d%d%d\t%d",
            mips.REGISTERS.registers[17],
            mips.REGISTERS.registers[18],
            mips.MEMORY.data_ram.memory[3],
            mips.MEMORY.data_ram.memory[4]
        );

        #2000 $writememh("mips_synth_tb0_data_out.hex", mips.MEMORY.data_ram.memory);
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