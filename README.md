##### Instale o virtualbox
* [https://www.virtualbox.org/wiki/Downloads]

##### Baixe a vm appliance (~2.3GB)
* [https://mega.nz/#!6tZVhS5A](https://mega.nz/#!6tZVhS5A!Lm6q8igAOPvCW7ZfzkqGatMg3mO5A9Ll_W8lzLnyNc0)

##### Baixe o md5 da vm (~50B)
* [https://mega.nz/#!uhQ2EByB](https://mega.nz/#!uhQ2EByB!HG27fOAnBWC16qPDP4JDTj67hGpERxqSZ1VfmwNvxuc)

##### Importe a appliance no virtualbox
####### ATENÇÃO: Marque a opção "Reinicialize o endereço MAC" antes de importar!
* Abra o virtualbox;
* Clique em "Arquivo" -> "Importar Appliance" ou aperte Ctrl + I;
* Selecione o arquivo baixado "desafio-tsi.ova" e clique em "Próximo >";
* Marque a opção "Reinicialize o endereço MAC de todas as placas de rede" e clique em "Importar";
* Caso ocorra algum erro, encaminhe um printscreen da tela com os detalhes para "fabiosammy@gmail.com";

##### Rode a vm e teste o desafio
* Rode a vm criada;
* Abra um terminal(Iniciar -> Acessórios -> LXTerminal ou Ctrl + Alt + T);
* Entre na pasta worms com o comando `cd ~/worms/`;
* Garanta que o desafio esta atualizado com o comando `git pull && bundle install` (Faça isso diariamente);
* Remova um arquivo de exemplo da maquina `rm -v players/player_1.js`
* Copie um script para codificar `cp -v players/cpu.js players/seu_nome.js`;
* Copie um segundo script para poder batalhar `cp -v players/cpu.js players/playerB.js`;
* Execute o jogo com `ruby Worms.rb`;
* Você poderá acompanhar um debug no terminal;
* Feche a janela do jogo, altere o arquivo `players/seu_nome.js` e vença o seu inimigo `playerB.js`;

##### Detalhes sobre o desafio
* Você deverá criar um player que recebe o parâmetro "params", maiores detalhes sobre o parâmetro no arquivo "players/cpu.js";
* Você deverá programar o script js para efetuar ações contra os demais inimigos;
* Você poderá criar até 5 scripts para batalharem entre si;
* Após criar um script, você deverá editá-lo com o intuito de destruir todos os inimigos;
* O jogo é baseado em rodadas, você tem até 5 segundos para efetuar movimentos, e atirar, para que o próximo jogador batalhe;
* O ultimo jogador a ficar, ou com maior vida restante, vence a partida;
