module displayDecoder(

    input [2:0]      SW,
    output [0:6] HEX0
);

	 reg  [0:6] saida;
	 wire [2:0] entrada;
	 
	 assign HEX0 = saida;
	 assign entrada = SW;

    always@(entrada)begin //sempre que mudar a entrada
        case(entrada[2:0])
        3'b000:saida = 7'b0000001; // 0
        3'b001:saida = 7'b1001111; // 1
        3'b010:saida = 7'b0010010; // 2
        3'b011:saida = 7'b0000110; // 3
        3'b100:saida = 7'b1001100; // 4
        3'b101:saida = 7'b0100100; // 5
        3'b110:saida = 7'b0100000; // 6
        3'b111:saida = 7'b0001111; // 7
        default: saida = 7'b0000000;
        endcase
    end
    
endmodule
