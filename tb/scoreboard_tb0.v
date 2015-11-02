// Scoreboard_tb0.v - Testbench para o módulo Scoreboard

`include "./src/Scoreboard.v"

module tb_scoreboard();
    reg clock;
    reg reset;

    reg  [4:0] readaddress;
    wire [7:0] readvalue;

    reg [4:0] addrpending;
    reg [1:0] func_unit;
    reg       enablewrite;

    reg [4:0] addrclear;
    reg       enableclear;

    reg [5:0] i;

    integer cur_time;

    Scoreboard s(.clock(clock),
                 .reset(reset),
                 .ass_addr(readaddress),
                 .ass_data(readvalue),
                 .writeaddr(addrpending),
                 .registerstage(func_unit),
                 .enablewrite(enablewrite),
                 .clearaddr(addrclear),
                 .enableclear(enableclear));

    initial begin
        #1
        $dumpfile("scoreboard_tb0.vcd");
        $dumpvars;        

        $display("\tTime\tClock\tRegister\tPending\t\tUnit\tData position");
        $monitor("%d\t%d\t%d\t\t%b\t\t%d\t%b", cur_time, clock, readaddress, readvalue[7], readvalue[6:5], readvalue[4:0]);

        #51 $finish;
    end

    initial begin
        readaddress <= 5'b0;
        #4
        // register 0, memory operation
        addrpending <= 5'd0;
        func_unit   <= 2'd1;
        enablewrite <= 1'b1;
        #7
        enablewrite <= 0;
        #25
        // here the register has gone through
        // the whole execution state, and has been
        // written
        addrclear <= 5'd0;
        enableclear <= 1;
        #28
        enableclear <= 0;        

    end

    initial begin
        cur_time = $time;
        enablewrite <= 0;
        enableclear <= 0;
        clock <= 0;
        reset <= 1;
        #1 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock = ~clock;
        cur_time = $time;
    end

endmodule