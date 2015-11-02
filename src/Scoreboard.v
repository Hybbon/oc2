`ifndef SCOREBOARD_V
`define SCOREBOARD_V

module Scoreboard(
    input            clock,
    input            reset,

    // inputs from issue stage, this is asynchronous
    input      [4:0] ass_addr, // requested register
    output     [7:0] ass_data, // register status and position

    // inputs from issue stage
    input      [4:0] writeaddr,     // register to become pending
    input      [1:0] registerstage, // which functional unit it is going to
    input            enablewrite,   // prevent incorrect write (e.g. during stalls)

    // inputs from writeback stage, clears register status
    input      [4:0] clearaddr,     // register to clear
    input            enableclear    // prevent incorrect clear (e.g. during stalls)
);

    reg [7:0] rows[31:0];
    reg [5:0] i;

    // outputs requested register data
    assign ass_data = rows[ass_addr];

    always @(posedge clock or negedge reset) begin
        if(~reset) begin

            for (i=0; i<32; i=i+1) begin
                rows[i] <= 8'b0ZZ00000;
            end

        end else begin

            for (i=0; i<32; i=i+1) begin
                // updates the positions of the data
                rows[i][4:0] = rows[i][4:0] >> 1;
                if(rows[i][7] && rows[i][4:0] == 5'b00000) begin
                    // register still on writeback stage
                    rows[i][0] = 1'b1;
                end
            end

            // clear registers gone through writeback
            if(enableclear) begin
                rows[clearaddr][7:0] = 8'b0ZZ00000;
            end

            // writes registers claimed on issue stage
            if(enablewrite) begin
                // the corresponding register becomes pending
                // and we write its functional unity
                rows[writeaddr][7] = 1'b1;
                rows[writeaddr][6:5] = registerstage;
                rows[writeaddr][4] = 1'b1;
            end

        end
    end

endmodule

`endif
