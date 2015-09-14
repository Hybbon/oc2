module top (
    input clock,
    input reset
);
    wire    [17:0]    addr;
    wire    [15:0]    data;
    wire              wre;
    wire              oute;
    wire              hb_mask;
    wire              lb_mask;
    wire              chip_en;

    Mips MIPS(.clock(clock),.reset(reset),.addr(addr),.data(data),.wre(wre),.oute(oute),
              .hb_mask(hb_mask),.lb_mask(lb_mask),.chip_en(chip_en));

    Ram RAM(.addr(addr),.data(data),.wre(wre),.oute(oute),.hb_mask(hb_mask),
            .lb_mask(lb_mask),.chip_en(chip_en));

endmodule
