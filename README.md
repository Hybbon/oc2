OC2 - Trabalho Prático 1
========================

Coletei aqui as informações principais do trabalho. Enquanto a gente não para e senta pra fazer isso, façam o curso de verilog da Altera (link no final, na seção de links).

Tarefas
-------

1. Dividir a memória existente (que usa palavras de 16 bits) em duas memórias de palavras de 32 bits: uma para os dados e uma para as instruções (cada uma com 128 palavras) **[Feito]**
2. Adaptar as instruções `lw` e `sw` para a nova memória **[Feito]**
3. Instanciar o processador para uso na FPGA (mais detalhes abaixo)

### Detalhes sobre o projeto para a placa ###

- Clock: `KEY[3]`
- Reset: `KEY[2]`
- Seleção de registrador a ser exibido nos displays de 7 segmentos: `KEY[1]` aciona, switches `[4:0]` escolhem

Links úteis
-----------

- [Quartus 2 + ModelSim](http://dl.altera.com) (Importante: baixar no máximo a versão 13.0, devido ao suporte à linha Cyclone II) 
- [DE2](http://wl.altera.com/education/univ/materials/boards/de2/unv-de2-board.html) (é a nossa placa)
- [DE2-115](http://wl.altera.com/education/univ/materials/boards/de2-115/) (não é a nossa placa)
- [Curso de Verilog \(Façam isso asap se estiverem com dificuldade na linguagem\)](http://wl.altera.com/education/training/courses/OHDL1120)

**Entrega: 22/09 (Terça-feira)**
