# Controlador e Indicador de Nível

Este repositório implementa um sistema de controle e indicação de nível de líquido em um tanque utilizando descrição em VHDL. O projeto inclui um controlador PID para regular o nível e um sensor simulado para medir o nível do tanque.

## Funcionalidades

- **Controle PID:** Ajuste automático do nível com base nos parâmetros \(K_p\), \(K_i\) e \(K_d\).
- **Simulação de Sensor:** Integração com um sensor de distância HCSR04 simulado para medir o nível do tanque.
- **Testbench:** Arquivos para validação do sistema através de simulações.

## Estrutura do Repositório

```plaintext
Controlador_Indicador_Nivel/
├── src/                      # Código-fonte em VHDL
│   ├── controle.vhd          # Módulo principal do controlador PID
│   ├── HCSR04.vhd            # Simulação do sensor HCSR04
├── testbench/                # Arquivos de teste
│   ├── tb_controle.vhd       # Testbench para o controlador
├── docs/                     # Documentação adicional (em desenvolvimento)
├── README.md                 # Este arquivo
```

## Tecnologias Utilizadas

- **VHDL:** Linguagem de descrição de hardware para FPGA.
- **Ferramentas de Simulação:** Quartus Prime ou ModelSim.
- **Hardware:** Projetado para implementação em FPGA (compatível com Altera ou Xilinx).

## Como Usar

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/erickdiias/Controlador_Indicador_Nivel.git
   cd Controlador_Indicador_Nivel
   ```

2. **Abra em uma IDE compatível:**
   Utilize ferramentas como [Quartus Prime](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/overview.html) ou ModelSim para compilar e simular os módulos VHDL.

3. **Realize os testes:**
   Execute os arquivos de testbench na pasta `testbench/` para validar o comportamento do sistema.

4. **Ajuste os parâmetros:**
   Modifique os valores de \(K_p\), \(K_i\) e \(K_d\) no arquivo `controle.vhd` para obter a resposta desejada.

## Ajuste de Parâmetros PID

Os valores iniciais de \(K_p\), \(K_i\) e \(K_d\) podem ser ajustados conforme o comportamento do sistema:

- **Proporcional (Kp):** Controla a intensidade da resposta ao erro.
- **Integral (Ki):** Elimina o erro acumulado ao longo do tempo.
- **Derivativo (Kd):** Reduz as oscilações e melhora a estabilidade.

Recomenda-se iniciar com os seguintes valores:

```plaintext
Kp = 5.0
Ki = 1.5
Kd = 0.1
```

Teste diferentes combinações para otimizar o controle do nível do tanque.

## Melhorias Futuras

- Integração com sensores físicos, como o HCSR04.
- Interface gráfica para monitoramento em tempo real.
- Controle avançado para sistemas com níveis variáveis ou dinâmicos.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE). Você é livre para utilizá-lo e modificá-lo conforme necessário.

---

Se tiver dúvidas ou sugestões, sinta-se à vontade para abrir uma _issue_ ou entrar em contato. 😊

