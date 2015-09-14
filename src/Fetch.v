module Fetch (
    input                   clock,
    input                   reset,
    //Execute
    input                   ex_if_stall,
    //Decode
    output reg    [31:0]    if_id_nextpc,
    output reg    [31:0]    if_id_instruc,
    input                   id_if_selpcsource,
    input         [31:0]    id_if_rega,
    input         [31:0]    id_if_pcimd2ext,
    input         [31:0]    id_if_pcindex,
    input         [1:0]     id_if_selpctype,
    //Memory Controller
    output reg              if_mc_en,
    output        [17:0]    if_mc_addr,
    input         [31:0]    mc_if_data
);

    reg    [31:0]   pc;

    assign if_mc_addr = pc[17:0];

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            if_mc_en <= 1'b0;
            if_id_instruc <= 32'h0000_0000;
            pc <= 32'h0000_0000;
        end else begin
            if_mc_en <= 1'b1;
            if (ex_if_stall) begin
                if_id_instruc <= 32'h0000_0000;
                if_id_nextpc <= pc;
            end else begin
                if_id_instruc <= mc_if_data;
                if (id_if_selpcsource) begin
                    case (id_if_selpctype)
                        2'b00: pc <= id_if_pcimd2ext;
                        2'b01: pc <= id_if_rega;
                        2'b10: pc <= id_if_pcindex;
                        2'b11: pc <= 32'h0000_0040;
                        default: pc <= 32'hXXXX_XXXX;
                    endcase
                    case (id_if_selpctype)
                        2'b00: if_id_nextpc <= id_if_pcimd2ext;
                        2'b01: if_id_nextpc <= id_if_rega;
                        2'b10: if_id_nextpc <= id_if_pcindex;
                        2'b11: if_id_nextpc <= 32'h0000_0040;
						default: if_id_nextpc <= 32'hXXXX_XXXX;
                        //default: pc <= 32'hXXXX_XXXX;
                    endcase
                end else begin
                    pc <= pc + 32'h0000_0004;
                end
            end
        end
    end

endmodule
