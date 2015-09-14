/*
Módulo auxiliar para automatização de testes
http://stackoverflow.com/questions/13904794/assert-statement-in-verilog
*/

module assert(input clk, input test);
    always @(posedge clk)
    begin
        if (test !== 1)
        begin
            $display("ASSERTION FAILED in %m");
            $finish;
        end
    end
endmodule
