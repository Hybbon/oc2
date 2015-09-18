module emaula(

	input[17:0]		SW, // Switches
	input[3:0]		KEY, // Keys
	output[0:6]		HEX0 // Display de 7 segmentos 0
);

	reg[2:0] register;

	displayDecoder DP7(.entrada(register),.saida(HEX0));
				  
	always@(negedge KEY[0])begin //quando aperta fica baixo
		register = SW[2:0];//pegando apenas os três primeiros Switches
	end
    
endmodule


/*
// diferença entre negedge e posedge
// simulação apenas, pois a KEY é '1' normalmente e '0' quando pressionada
module emaula(

	input[17:0]		SW, // Switches
	input[3:0]		KEY, // Keys
	output[0:6]		HEX0 // Display de 7 segmentos 0
);

	reg[2:0] register;

	displayDecoder DP7(.entrada(register),.saida(HEX0));
				  
	always@(posedge KEY[0])begin
		register = SW[2:0];
	end
    
endmodule
*/


/*
//erro comum, escrever em registrador em "dois lugares no código"
module emaula(

	input[17:0]		SW, // Switches
	input[3:0]		KEY, // Keys
	output[0:6]		HEX0 // Display de 7 segmentos 0
);

	reg[2:0] register;

	displayDecoder DP7(.entrada(register),.saida(HEX0));
				  
	always@(negedge KEY[0])begin
		register = SW[2:0];
	end
	
	always@(negedge KEY[0])begin
		register = SW[2:0];
	end
    
endmodule
*/

/*
// simula corretamente mas não sintetiza corretamente
module emaula(

	input[17:0]		SW, // Switches
	input[3:0]		KEY, // Keys
	output[0:6]		HEX0 // Display de 7 segmentos 0
);

	reg[2:0] register;
	reg[2:0] register1; //novo

	displayDecoder DP7(.entrada(register),.saida(HEX0));
				  
	always@(negedge KEY[0])begin
		register = SW[2:0];//pegando apenas os três primeiros Switches
	end
	
	always@(negedge KEY[0])begin
		register1 = SW[17:15];//pegando apenas os três ultimos Switches
	end
    
endmodule
*/