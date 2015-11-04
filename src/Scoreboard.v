`ifndef SCOREBOARD_V
`define SCOREBOARD_V

module Scoreboard(
    input            clock,
    input            reset,

    // inputs from issue stage, this is asynchronous
    input      [4:0] ass1_addr,      // requested register
    output           ass1_pending,   // register status
    output     [1:0] ass1_unit,      // register functional unit
    output     [4:0] ass1_row,       // register execution stage

    input      [4:0] ass2_addr,      // requested register
    output           ass2_pending,   // register status
    output     [1:0] ass2_unit,      // register functional unit
    output     [4:0] ass2_row,       // register execution stage

    // inputs from issue stage
    input      [4:0] writeaddr,     // register to become pending
    input      [1:0] registerunit,  // which functional unit it is going to
    input            enablewrite   // prevent incorrect write (e.g. during stalls)
);

    reg [7:0] rows[31:0];
    reg [5:0] i;

    // outputs requested register data
    assign ass1_pending = rows[ass1_addr][7];
    assign ass1_unit    = rows[ass1_addr][6:5];
    assign ass1_row     = rows[ass1_addr][4:0];
    
    assign ass2_pending = rows[ass2_addr][7];
    assign ass2_unit    = rows[ass2_addr][6:5];
    assign ass2_row     = rows[ass2_addr][4:0];

    always @(posedge clock or negedge reset) begin
        if(~reset) begin

            for (i=0; i<32; i=i+1) begin
                rows[i] <= 8'b0ZZ00000;
            end

        end else begin

            for (i=0; i<32; i=i+1) begin
                // updates the positions of the data
                rows[i][4:0] = rows[i][4:0] >> 1;
                if(rows[i][4:0] == 5'b00000) begin
                    // register is not pending anymore
                    rows[i][7:5]  = 3'b0ZZ;
                end
            end

            // writes registers claimed on issue stage
            if(enablewrite) begin
                // the corresponding register becomes pending
                // and we write its functional unity
                rows[writeaddr][7] = 1'b1;
                rows[writeaddr][6:5] = registerunit;
                rows[writeaddr][4] = 1'b1;
            end

        end
    end

endmodule

`endif
