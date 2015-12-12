OC2 - Trabalho Prático 3
========================

Nosso terceiro trabalho prático consiste na adaptação do I4 anterior para um I2O2, dessa vez com encaminhamento de dados.

Tarefas
-------

### Adaptação do scoreboard ###

Para evitar hazards WAW, o processador deve realizar stall conservador no Decode caso a instrução nova escreva num endereço que está, no momento, sendo escrito. É preciso modificar o scoreboard para checar um novo endereço, portanto. Além disso, para permitir o encaminhamento de dados, é preciso, também, fazer com que o scoreboard coloque o bit de escrita em posições diferentes, a depender da unidade funcional sendo escrita.

Finalmente, como a nova máquina tem unidades funcionais que demoram números diferentes de ciclos para escrita, é preciso sempre conferir o scoreboard a cada nova escrita para evitar o hazard estrutural do Writeback (duas instruções não podem acabar escrevendo ao mesmo tempo no writeback, isso causaria sérios problemas). No caso, é necessário avaliar a coluna inteira, a depender da unidade funcional que vai executar a escrita.

### Adaptação das unidades funcionais ###

Não é mais necessário ter estágios inúteis de forwarding. Esses estágios podem ser removidos com segurança.

### Detalhes sobre o projeto para a placa ###

**Modelo: Altera DE2 (EP2C35F672C6)**

- Clock: CLOCK\_50 limitado para 1 Hz.
- Reset: `KEY[2]`
- Seleção de registrador a ser exibido nos displays de 7 segmentos: switches `[4:0]` escolhem

Para carregar o programa padrão para a memória, acione o switch 5 e ative o reset. Para carregar os dados padrão para a memória, acione o switch 6 e ative o reset. (Obviamente, para carregar os dois, acione os dois de uma vez, não um de cada vez.)

Links úteis
-----------

- [Quartus 2 + ModelSim](http://dl.altera.com) (Importante: baixar no máximo a versão 13.0, devido ao suporte à linha Cyclone II) 
- [DE2](http://wl.altera.com/education/univ/materials/boards/de2/unv-de2-board.html) (é a nossa placa)
- [Curso de Verilog \(Façam isso asap se estiverem com dificuldade na linguagem\)](http://wl.altera.com/education/training/courses/OHDL1120)

**Entrega: 13/12 (Domingo)**
