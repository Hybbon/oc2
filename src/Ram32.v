// Ram32.v - RAM de 128 palavras de 32 bits cada
// (Adaptação do módulo Ram.v)

`ifndef RAM32_V
`define RAM32_V

module Ram (
    input    [6:0]    addr,     // Endereço a ser lido/escrito
    inout    [31:0]   data,     // Dados lidos/a ser escritos
    input             wre,      // 0: Leitura, 1: Escrita
    input    instr_load,      // Preenche a memória com instruções
    input    data_load,
    input    reset
);

    reg     [31:0]    memory    [0:127];
    wire    [31:0]    q;

    assign q = memory[addr];

    // [!] Sobre interfaces bidirecionais (inout)
    // Interfaces do tipo inout devem ser usadas interna e externamente como
    // wires (nets), NUNCA como regs. Externamente, elas são legíveis quando o
    // fio externo está definido como Z, e o interno como o valor de saída. O
    // contrário ocorre na entrada: para escrever em uma interface bidirecional,
    // é preciso definir o fio externo como o valor a ser escrito e definir o
    // interno como Z.
    assign data[31:0]  = wre ? 32'hZZZZZZZZ : q[31:0];


    always @(wre or addr or data or instr_load or data_load or reset) begin
        if (wre)
           memory[addr] = data[31:0];
        if (instr_load == 1'b1) begin
            memory[0] = 32'h00000000;
            memory[1] = 32'h00000000;
            memory[2] = 32'h20100000;
            memory[3] = 32'h20081414;
            memory[4] = 32'h20094141;
            memory[5] = 32'h00000000;
            memory[6] = 32'h00000000;
            memory[7] = 32'h00000000;
            memory[8] = 32'hae08000c;
            memory[9] = 32'h00000000;
            memory[10] = 32'h00000000;
            memory[11] = 32'h00000000;
            memory[12] = 32'hae090010;
            memory[13] = 32'h00000000;
            memory[14] = 32'h00000000;
            memory[15] = 32'h00000000;
            memory[16] = 32'h8e11000c;
            memory[17] = 32'h00000000;
            memory[18] = 32'h00000000;
            memory[19] = 32'h00000000;
            memory[20] = 32'h8e120010;
            memory[21] = 32'h00000000;
            memory[22] = 32'h00000000;
            memory[23] = 32'h00000000;
            memory[24] = 32'h02329820;

            // memory[0] = 32'h00000000;
            // memory[1] = 32'h00000000;
            // memory[2] = 32'h8c100008;
            // memory[3] = 32'h200a000c;
            // memory[4] = 32'h200b0004;
            // memory[5] = 32'h200114b8;
            // memory[6] = 32'h2008000c;
            // memory[7] = 32'h00000000;
            // memory[8] = 32'h00000000;
            // memory[9] = 32'h00000000;
            // memory[10] = 32'h01014804;
            // memory[11] = 32'h00000000;
            // memory[12] = 32'h00000000;
            // memory[13] = 32'h00000000;
            // memory[14] = 32'h21290820;
            // memory[15] = 32'h00000000;
            // memory[16] = 32'h00000000;
            // memory[17] = 32'h00000000;
            // memory[18] = 32'hac090064;
            // memory[19] = 32'h00000000;
            // memory[20] = 32'h00000000;
            // memory[21] = 32'h00000000;
            // memory[22] = 32'h00000000;
            // memory[23] = 32'h00000000;
            // memory[24] = 32'h00000000;
            // memory[25] = 32'h2011000f;
            // memory[26] = 32'h00000000;
        end 
        if (data_load == 1'b1) begin
            memory[0] = 32'h00000000;
            memory[1] = 32'h00000001;
            memory[2] = 32'h00000002;
            memory[3] = 32'h00000003;
            memory[4] = 32'h00000004;
            memory[5] = 32'h00000005;
            memory[6] = 32'h00000006;
            memory[7] = 32'h00000007;
            memory[8] = 32'h00000008;
            memory[9] = 32'h00000009;
            memory[10] = 32'h00000010;
            memory[11] = 32'h00000011;
            memory[12] = 32'h00000012;
            memory[13] = 32'h00000013;
            memory[14] = 32'h00000014;
            memory[15] = 32'h00000015;
            memory[16] = 32'h00000016;
            memory[17] = 32'h00000017;
            memory[18] = 32'h00000018;
            memory[19] = 32'h00000019;
            memory[20] = 32'h00000020;
            memory[21] = 32'h00000021;
            memory[22] = 32'h00000022;
            memory[23] = 32'h00000023;
            memory[24] = 32'h00000024;
            memory[25] = 32'h00000025;
            memory[26] = 32'h00000026;
            memory[27] = 32'h00000027;
            memory[28] = 32'h00000028;
            memory[29] = 32'h00000029;
            memory[30] = 32'h00000030;
            memory[31] = 32'h00000031;
            memory[32] = 32'h00000032;
            memory[33] = 32'h00000033;
            memory[34] = 32'h00000034;
            memory[35] = 32'h00000035;
            memory[36] = 32'h00000036;
            memory[37] = 32'h00000037;
            memory[38] = 32'h00000038;
            memory[39] = 32'h00000039;
            memory[40] = 32'h00000040;
            memory[41] = 32'h00000041;
            memory[42] = 32'h00000042;
            memory[43] = 32'h00000043;
            memory[44] = 32'h00000044;
            memory[45] = 32'h00000045;
            memory[46] = 32'h00000046;
            memory[47] = 32'h00000047;
            memory[48] = 32'h00000048;
            memory[49] = 32'h00000049;
            memory[50] = 32'h00000050;
            memory[51] = 32'h00000051;
            memory[52] = 32'h00000052;
            memory[53] = 32'h00000053;
            memory[54] = 32'h00000054;
            memory[55] = 32'h00000055;
            memory[56] = 32'h00000056;
            memory[57] = 32'h00000057;
            memory[58] = 32'h00000058;
            memory[59] = 32'h00000059;
            memory[60] = 32'h00000060;
            memory[61] = 32'h00000061;
            memory[62] = 32'h00000062;
            memory[63] = 32'h00000063;
            memory[64] = 32'h00000064;
            memory[65] = 32'h00000065;
            memory[66] = 32'h00000066;
            memory[67] = 32'h00000067;
            memory[68] = 32'h00000068;
            memory[69] = 32'h00000069;
            memory[70] = 32'h00000070;
            memory[71] = 32'h00000071;
            memory[72] = 32'h00000072;
            memory[73] = 32'h00000073;
            memory[74] = 32'h00000074;
            memory[75] = 32'h00000075;
            memory[76] = 32'h00000076;
            memory[77] = 32'h00000077;
            memory[78] = 32'h00000078;
            memory[79] = 32'h00000079;
            memory[80] = 32'h00000080;
            memory[81] = 32'h00000081;
            memory[82] = 32'h00000082;
            memory[83] = 32'h00000083;
            memory[84] = 32'h00000084;
            memory[85] = 32'h00000085;
            memory[86] = 32'h00000086;
            memory[87] = 32'h00000087;
            memory[88] = 32'h00000088;
            memory[89] = 32'h00000089;
            memory[90] = 32'h00000090;
            memory[91] = 32'h00000091;
            memory[92] = 32'h00000092;
            memory[93] = 32'h00000093;
            memory[94] = 32'h00000094;
            memory[95] = 32'h00000095;
            memory[96] = 32'h00000096;
            memory[97] = 32'h00000097;
            memory[98] = 32'h00000098;
            memory[99] = 32'h00000099;
            memory[100] = 32'h00000100;
            memory[101] = 32'h00000101;
            memory[102] = 32'h00000102;
            memory[103] = 32'h00000103;
            memory[104] = 32'h00000104;
            memory[105] = 32'h00000105;
            memory[106] = 32'h00000106;
            memory[107] = 32'h00000107;
            memory[108] = 32'h00000108;
            memory[109] = 32'h00000109;
            memory[110] = 32'h00000110;
            memory[111] = 32'h00000111;
            memory[112] = 32'h00000112;
            memory[113] = 32'h00000113;
            memory[114] = 32'h00000114;
            memory[115] = 32'h00000115;
            memory[116] = 32'h00000116;
            memory[117] = 32'h00000117;
            memory[118] = 32'h00000118;
            memory[119] = 32'h00000119;
            memory[120] = 32'h00000120;
            memory[121] = 32'h00000121;
            memory[122] = 32'h00000122;
            memory[123] = 32'h00000123;
            memory[124] = 32'h00000124;
            memory[125] = 32'h00000125;
            memory[126] = 32'h00000126;
            memory[127] = 32'h00000127;
        end
    end
   
endmodule

`endif
