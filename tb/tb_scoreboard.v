`include "Scoreboard.v"

module tb_scoreboard();
    reg clk;
    reg reset;

    reg  [4:0] readaddress;
    wire [7:0] readvalue;

    reg [4:0] writepending;
    reg [1:0] stage;
    reg       enablewrite;

    reg [4:0] writeclear;
    reg       enableclear;

    reg [4:0] i;

    Scoreboard s(.clock(clk),
                 .reset(reset),
                 .ass_addr(readaddress),
                 .ass_data(readvalue),
                 .writeaddr(writepending),
                 .registerstage(stage),
                 .enablewrite(enablewrite),
                 .clearaddr(writeclear),
                 .enableclear(enableclear));

    initial begin
        clk = 0;
        reset = 0;
        #1
        reset = 1;
        #1
        reset = 0;
        #50
        $finish;
    end

    always begin
        #4
        clk <= ~clk;
        $display("Clock: %d\n", clk);
        for (i=0; i<32; i=i+1) begin
            readaddress = i;
            $display("%b\n", readvalue);
        end
    end

endmodule