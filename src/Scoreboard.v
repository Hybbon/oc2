`ifndef SCOREBOARD_V
`define SCOREBOARD_V

module Scoreboard (
    input            clock,
    input            reset,

    // Issue stage asynchronous read interface
    input      [4:0] iss_ass_addr_a,      // requested register
    output           iss_ass_pending_a,   // register status
    output     [1:0] iss_ass_unit_a,      // register functional unit
    output     [4:0] iss_ass_row_a,       // register execution stage

    input      [4:0] iss_ass_addr_b,      // requested register
    output           iss_ass_pending_b,   // register status
    output     [1:0] iss_ass_unit_b,      // register functional unit
    output     [4:0] iss_ass_row_b,       // register execution stage

    // Decode stage asynchronous read interface
    input      [4:0] id_ass_addr_a,      // requested register
    output           id_ass_pending_a,   // register status
    output     [1:0] id_ass_unit_a,      // register functional unit
    output     [4:0] id_ass_row_a,       // register execution stage

    input      [4:0] id_ass_addr_b,      // requested register
    output           id_ass_pending_b,   // register status
    output     [1:0] id_ass_unit_b,      // register functional unit
    output     [4:0] id_ass_row_b,       // register execution stage

    // Issue stage synchronous write interface
    input      [4:0] writeaddr,     // register to become pending
    input      [1:0] registerunit,  // which functional unit it is going to
    // 2'b00: AluMisc
    // 2'b01: Mem
    // 2'b10: Mult
    input            enablewrite,  // prevent incorrect write (e.g. during stalls)

    // Writeback structural hazard prevention asynchronous interface
    output [31:0] sb_haz_column
);

    reg [7:0] rows[31:0];
    reg [5:0] i;

    // outputs requested register data
    assign iss_ass_pending_a = rows[iss_ass_addr_a][7];
    assign iss_ass_unit_a    = rows[iss_ass_addr_a][6:5];
    assign iss_ass_row_a     = rows[iss_ass_addr_a][4:0];

    assign iss_ass_pending_b = rows[iss_ass_addr_b][7];
    assign iss_ass_unit_b    = rows[iss_ass_addr_b][6:5];
    assign iss_ass_row_b     = rows[iss_ass_addr_b][4:0];

    assign id_ass_pending_a = rows[id_ass_addr_a][7];
    assign id_ass_unit_a    = rows[id_ass_addr_a][6:5];
    assign id_ass_row_a     = rows[id_ass_addr_a][4:0];

    assign id_ass_pending_b = rows[id_ass_addr_b][7];
    assign id_ass_unit_b    = rows[id_ass_addr_b][6:5];
    assign id_ass_row_b     = rows[id_ass_addr_b][4:0];

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
                    rows[i][7:5] = 3'b0ZZ;
                end
            end

            // writes registers claimed on issue stage
            if(enablewrite) begin
                // the corresponding register becomes pending
                // and we write its functional unity
                rows[writeaddr][7] = 1'b1;
                rows[writeaddr][6:5] = registerunit;
                case (registerunit)
                    2'b00: rows[writeaddr][1] = 1'b1; // am
                    2'b01: rows[writeaddr][2] = 1'b1; // mem
                    2'b10: rows[writeaddr][4] = 1'b1; // mult
                    // The two below should hopefully never happen
                    2'b11: rows[writeaddr][4] = 1'b1;
                    default: rows[writeaddr][4] = 1'b1;
                endcase
            end

        end
    end

    // Returns a given column of the Scoreboard, depending on the functional
    // unit to be written. I have no idea how generate statements work.
    assign sb_haz_column =
    registerunit === 2'b00 ?
    {
        rows[0][2],
        rows[1][2],
        rows[2][2],
        rows[3][2],
        rows[4][2],
        rows[5][2],
        rows[6][2],
        rows[7][2],
        rows[8][2],
        rows[9][2],
        rows[10][2],
        rows[11][2],
        rows[12][2],
        rows[13][2],
        rows[14][2],
        rows[15][2],
        rows[16][2],
        rows[17][2],
        rows[18][2],
        rows[19][2],
        rows[20][2],
        rows[21][2],
        rows[22][2],
        rows[23][2],
        rows[24][2],
        rows[25][2],
        rows[26][2],
        rows[27][2],
        rows[28][2],
        rows[29][2],
        rows[30][2],
        rows[31][2]
    } // am
    : ( registerunit === 2'b01 ?
    {
        rows[0][3],
        rows[1][3],
        rows[2][3],
        rows[3][3],
        rows[4][3],
        rows[5][3],
        rows[6][3],
        rows[7][3],
        rows[8][3],
        rows[9][3],
        rows[10][3],
        rows[11][3],
        rows[12][3],
        rows[13][3],
        rows[14][3],
        rows[15][3],
        rows[16][3],
        rows[17][3],
        rows[18][3],
        rows[19][3],
        rows[20][3],
        rows[21][3],
        rows[22][3],
        rows[23][3],
        rows[24][3],
        rows[25][3],
        rows[26][3],
        rows[27][3],
        rows[28][3],
        rows[29][3],
        rows[30][3],
        rows[31][3]
    } : ( registerunit === 2'b10 ?
        32'h0000_0000 : 32'hXXXX_XXXX
    ));
endmodule

`endif
