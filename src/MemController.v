module MemControler (
    input               clock,
    input               reset,
    //Fetch
    input               if_mc_en,
    input     [17:0]    if_mc_addr,
    output    [31:0]    mc_if_data,
    //Memory
    input               mem_mc_rw,
    input               mem_mc_en,
    input     [17:0]    mem_mc_addr,
    inout     [31:0]    mem_mc_data,
    //Ram
    output    [17:0]    mc_ram_addr,
    output              mc_ram_wre,
    inout     [15:0]    mc_ram_data
);

    //High part -> step 0
    //Low part -> step 1

    wire    [15:0]    to_ram_data;
    reg               step;
    reg     [15:0]    first_half;

    assign mc_ram_addr = (!mem_mc_en & if_mc_en) ? {if_mc_addr>>1} + step : {mem_mc_addr>>1} + step;
    assign mc_ram_wre = !(!(!mem_mc_en & if_mc_en) & mem_mc_rw);
    assign mc_ram_data = !(mc_ram_wre) ? (to_ram_data) : 16'bZZ;
    assign mem_mc_data = (mc_ram_wre) ? {first_half,mc_ram_data} : 32'bZZZZ;
    assign mc_if_data = /*(!mem_mc_en & if_mc_en & step) ?*/ {first_half,mc_ram_data}/* : 32'bXXXX*/;
    assign to_ram_data = (step) ? mem_mc_data[15:0] : mem_mc_data[31:16];

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            step <= 1'b0;
        end else begin
            if (if_mc_en | mem_mc_en) begin
                step <= ~step;
            end
            if (~step) begin
                if ((!mem_mc_en & if_mc_en) | mc_ram_wre) begin //Sending to Fetch or Ram
                    first_half <= mc_ram_data;
                end
            end
        end
    end

endmodule
