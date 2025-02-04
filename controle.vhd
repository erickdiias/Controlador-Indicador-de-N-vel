library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controle is
    generic(
        setpoint            : integer range 0 to 100 := 50;
        Kp                  : integer := 0;
        Ki                  : integer := 0;
        Kd                  : integer := 0
    );
    Port (
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        distancia           : in  STD_LOGIC_VECTOR(31 downto 0);
        botao_calibracao    : in  std_logic;
        status_calibracao   : out std_logic;
        ENA                 : out std_logic;   -- PWM para motor
        IN1                 : out std_logic    -- Direção do motor
    );
end entity;

architecture main of Controle is
    signal erro             : signed(31 downto 0) := (others => '0');
    signal erro_anterior    : signed(31 downto 0) := (others => '0');
    signal integral         : signed(31 downto 0) := (others => '0');
    signal derivada         : signed(31 downto 0) := (others => '0');

    signal calibracao_ok    : std_logic := '0';

    signal output_PID       : integer := 0;
    signal output_PWM       : integer := 0;

    signal nivel_atual      : integer := 0;
    signal nivel_vazio      : integer := 0;

    constant NIVEL_MAX      : integer := 100;
    constant NIVEL_MIN      : integer := 20;

    function calibrar_distancia (DISTANCIA: integer) return integer is
    begin
        if DISTANCIA >= NIVEL_MIN then
            return 0;
        elsif DISTANCIA <= NIVEL_MAX then
            return 100;
        else
            return (DISTANCIA * 100) / NIVEL_MIN;
        end if;
    end function;
begin

    nivel_atual <= calibrar_distancia(to_integer(unsigned(distancia)));

    process(clk, rst, calibracao_ok)
    begin
        if rst = '1' then
            calibracao_ok <= '0';
            nivel_vazio <= 0;
        elsif rising_edge(clk) then
            if botao_calibracao = '1' and calibracao_ok = '0' then
                nivel_vazio <= nivel_atual;
                calibracao_ok <= '1';
            end if;
        end if;

        status_calibracao <= calibracao_ok;

    end process;
    
    -- PID Controle Processo
    process(clk, rst)
    begin
        if rst = '1' then
            erro <= (others => '0');
            erro_anterior <= (others => '0');
            integral <= (others => '0');
            derivada <= (others => '0');
            output_PID <= 0;
        elsif rising_edge(clk) then
            if calibracao_ok = '1' then
                erro <= to_signed(setpoint - (nivel_atual - nivel_vazio), 32);
                integral <= integral + erro;
                derivada <= erro - erro_anterior;
                output_PID <= (to_integer(erro) * Kp) + (to_integer(integral) * Ki) + (to_integer(derivada) * Kd);

                if output_PID < 0 then
                    output_PWM <= 0;
                elsif output_PID > 255 then
                    output_PWM <= 255;
                else
                    output_PWM <= output_PID;
                end if;

                erro_anterior <= erro; -- Atualiza erro anterior
            end if;
        end if;
    end process;

    -- Geração do PWM
    process(clk, rst)
        variable pwm_counter : integer := 0;
    begin
        if rst = '1' then
            pwm_counter := 0;
            ENA <= '0';
        elsif rising_edge(clk) then
            if pwm_counter < 255 then
                pwm_counter := pwm_counter + 1;
            else
                pwm_counter := 0;
            end if;

            if pwm_counter < output_PWM then
                ENA <= '1';
            else
                ENA <= '0';
            end if;
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            IN1 <= '0';
        elsif rising_edge(clk) then
            IN1 <= '1';
        end if;
    end process;

end architecture;
