OC2 - Trabalho Prático 2
========================

O segundo TP consiste basicamente de transformar nosso processador não-superescalar do TP1 em um superescalar I4. Para entender em mais detalhes como vai funcionar, leiam a documentação, mas basicamente precisamos adicionar um Scoreboard, dividir a Execute em vários pedaços (Issue, unidades funcionais X, M e Y), adicionar funcionalidade de multiplicação (bloco Y) e implementar uma unidade de detecção de hazard. Percebam que não é necessário fazer encaminhamento.

Tarefas
-------

### Scoreboard ###

O scoreboard é uma das partes mais tranquilas de se implementar, por incrível que pareça, porque ele é um módulo independente. (A coisa mais chata desse trabalho é mexer em código já existente, porque é tudo uma bagunça absurda.) Sua estrutura é relativamente simples:

|     | P | F | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|
| R0  |   |   |   |   |   |   |   |
| R1  |   |   |   |   |   |   |   |
| ... |   |   |   |   |   |   |   |
| R30 |   |   |   |   |   |   |   |
| R31 |   |   |   |   |   |   |   |

P é uma coluna de apenas um bit que indica que o registrador está pendente (ou seja, ainda não realizou writeback). F é uma coluna que indica qual é a unidade funcional realizando escrita no registrador em questão, se ele está pendente. As colunas de 4 a 0 contém um bit. Esse bit será 1 na coluna x, linha Ry se existem dados de uma instrução que salva em Ry nas unidades funcionais do caminho de dados faltando x ciclos para o estágio de Writeback. (Se dados estão em writeback no momento, a coluna 0 deve conter um bit 1).

### Estágio de issue e divisão das unidades funcionais ###

Como é possível ver na especificação do trabalho, o I4 não contém um estágio Execute por assim dizer. Em vez disso, temos o estágio de Issue, que é responsável por receber uma instrução e encaminhar essa instrução para a unidade funcional mais apropriada. Além disso, é nesse estágio que o Scoreboard é escrito (quando alguma instrução que escreve em registrador alcança o Issue) e lido (para detecção de hazard de dados).

A funcionalidade do processador será dividida em três partes, como visto em sala de aula:

- X: Basicamente toda a funcionalidade anterior do processador, com exceção de instruções de load e store. ALU, branches, jump, etc. Contém apenas um estágio "real" (X0), nos outros três ciclos os dados são apenas encaminhados para a frente.
- Y: Multiplicação de inteiros, dividida em quatro estágios.
- M: Load e store, com dois estágios. No primeiro estágio, calcula-se o endereço de acesso. No segundo, a operação é, de fato, efetuada.

Após a execução, essas unidades funcionais devem, caso necessário, enviar dados para o Writeback. Não existe a possibilidade de hazard estrutural no Writeback, já que o processador dispara em ordem e todas as unidades funcionais levam o mesmo número de ciclos para ser processadas.

### Unidade funcional Y: Multiplicação ###

A única nova funcionalidade real do processador, essa unidade funcional deve ser capaz de realizar a multiplicação de dois números inteiros. Serão salvos apenas os 32 bits menos significativos da operação. O funcionamento da unidade funcional é dividido em quatro estágios e está descrito com minúcia na especificação do trabalho.

### Detecção de Hazard ###

Para processadores mais complexos, detecção de hazards pode ser um grande problema. No caso do MIPS I4, porém, existe apenas um hazard possível, que é o hazard de dados read-after-write. A detecção do mesmo pode ser feita por meio da scoreboard, durante o estágio de Issue. Caso seja constatado hazard, a máquina deve realizar stall no caminho de dados até que o dado desejado esteja disponível.

### Detalhes sobre o projeto para a placa ###

**Modelo: Altera DE2 (EP2C35F672C6)**

- Clock: `KEY[3]`
- Reset: `KEY[2]`
- Seleção de registrador a ser exibido nos displays de 7 segmentos: `KEY[1]` aciona, switches `[4:0]` escolhem

Links úteis
-----------

- [Quartus 2 + ModelSim](http://dl.altera.com) (Importante: baixar no máximo a versão 13.0, devido ao suporte à linha Cyclone II) 
- [DE2](http://wl.altera.com/education/univ/materials/boards/de2/unv-de2-board.html) (é a nossa placa)
- [Curso de Verilog \(Façam isso asap se estiverem com dificuldade na linguagem\)](http://wl.altera.com/education/training/courses/OHDL1120)

**Entrega: 05/11 (Quinta-feira)**
