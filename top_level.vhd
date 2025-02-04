--
--
--
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk                 : in std_logic;
        rst                 : in std_logic;
        echo                : in std_logic;
        botao_calibracao    : in std_logic;
        status_calibracao   : out std_logic;
        trigger             : out std_logic;
        ENA                 : out std_logic;
        IN1                 : out std_logic;
        AN                  : out std_logic_vector(3 downto 0);
        display             : out std_logic_vector(6 downto 0)
    );
end entity;

architecture main of top_level is

    signal distancia : std_logic_vector(31 downto 0);

    signal digit_0, digit_1, digit_2, digit_3 : integer range 0 to 9;

begin
    HCSR04_inst: entity work.HCSR04
        port map(
            Trigger  => trigger,
            Echo     => echo,
            Distance => distancia,
            clk      => clk,
            reset    => rst
        );

    distance_calc_inst: entity work.Distancia_Calc
        port map(
            clk     => clk,
            reset   => rst,
            digit_0 => digit_0,
            digit_1 => digit_1,
            digit_2 => digit_2,
            digit_3 => digit_3,
            distancia_int => to_integer(unsigned(distancia))
        );
    
    display_inst: entity work.Display
        port map(
            clk     => clk,
            reset   => rst,
            digit_0 => digit_0,
            digit_1 => digit_1,
            digit_2 => digit_2,
            digit_3 => digit_3,
            AN      => AN,
            display => display
        );

    controle_inst: entity work.Controle
        generic map(
            setpoint    => 50, -- Valor desejado de 0% a 100%
            kp          => 1,        -- Ganho proporcional
            ki          => 0,        -- Ganho integral
            kd          => 0         -- Ganho derivativo
        )
        port map(
            clk     => clk,
            rst     => rst,
            distancia           => distancia, -- Valor medido
            botao_calibracao    => botao_calibracao,
            status_calibracao   => status_calibracao,
            ENA     => ENA,
            IN1     => IN1
        );

end architecture;
