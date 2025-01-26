Controlador e Indicador de Nível
Este repositório contém a implementação de um sistema de controle e indicação de nível utilizando VHDL. O objetivo do projeto é controlar o nível de um tanque em um sistema embarcado, ajustando o sinal de controle com base em um controlador PID.

🛠️ Funcionalidades
Controle de Nível: Ajuste automático do nível do tanque utilizando um controlador PID.
Sensor de Nível: Simulação ou integração com sensores, como o HCSR04, para medir o nível.
Indicador: Exibição do nível atual do tanque e status do controle.
🧰 Tecnologias Utilizadas
VHDL: Linguagem de descrição de hardware.
Simulação: Testbench para simulação e validação.
FPGA: Implementação projetada para plataformas como Altera ou Xilinx.
📂 Estrutura do Projeto
bash
Copiar
Editar
Controlador_Indicador_Nivel/
├── src/                      # Código-fonte em VHDL
│   ├── controle.vhd          # Módulo do controlador PID
│   ├── HCSR04.vhd            # Módulo de simulação do sensor
├── testbench/                # Arquivos de teste
│   ├── tb_controle.vhd       # Testbench do controlador
├── docs/                     # Documentação adicional
├── README.md                 # Este arquivo
⚙️ Como Utilizar
Clone este repositório:

bash
Copiar
Editar
git clone https://github.com/erickdiias/Controlador_Indicador_Nivel.git
cd Controlador_Indicador_Nivel
Abra o projeto em uma ferramenta como Quartus Prime.

Faça a simulação do sistema utilizando os arquivos de testbench disponíveis.

Ajuste os valores do controlador PID no arquivo controle.vhd, se necessário.

🚀 Melhorias Futuras
Integração com hardware real, como o HCSR04 para medir níveis em um tanque físico.
Implementação de interface gráfica para monitoramento do nível.
Aprimoramento do controlador PID para sistemas não lineares.
📝 Licença
Este projeto está sob a licença MIT. Sinta-se à vontade para utilizá-lo e modificá-lo.
