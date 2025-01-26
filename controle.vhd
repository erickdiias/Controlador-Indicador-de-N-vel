library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle is
    Port (
        clk              : in  STD_LOGIC;
        reset            : in  STD_LOGIC;
        setpoint         : in  INTEGER RANGE 0 TO 100;
        feedback         : in  STD_LOGIC_VECTOR(31 downto 0);
        botao_calibracao : in  STD_LOGIC;
        flag             : out std_logic;
        pwm_output       : out STD_LOGIC
    );
end entity;

architecture Behavioral of controle is
    signal error         : signed(31 downto 0);
    signal integral      : INTEGER := 0;
    signal derivative    : signed(31 downto 0);
    signal last_error    : signed(31 downto 0) := (others => '0');
    signal pid_output    : INTEGER := 0;
    signal pwm_counter   : INTEGER := 0;
    constant PWM_PERIOD  : INTEGER := 1000;
    constant Kp          : INTEGER := 0;
    constant Ki          : INTEGER := 200;
    constant Kd          : INTEGER := 0;

    signal calibracao_ok : std_logic := '0';
    signal nivel_atual   : integer := 0;
    signal nivel_vazio   : integer := 0;

    constant NIVEL_MAX   : integer := 0;
    constant NIVEL_MIN   : integer := 20;

    function calibrar_distancia (DISTANCIA: integer) return integer is
    begin
        if DISTANCIA > NIVEL_MIN then
            return 0;
        elsif DISTANCIA < NIVEL_MAX then
            return 100;
        else
            return (DISTANCIA * 100) / NIVEL_MIN;
        end if;
    end function;
begin

    nivel_atual <= calibrar_distancia(to_integer(unsigned(feedback)));

    process(clk, reset, botao_calibracao, calibracao_ok)
    begin
        if reset = '1' then
            calibracao_ok <= '0';
            nivel_vazio <= 0;
        elsif rising_edge(clk) then
            if botao_calibracao = '1' and calibracao_ok = '0' then
                nivel_vazio <= nivel_atual;
                calibracao_ok <= '1';
            end if;
        end if;
    end process;
    
    flag <= calibracao_ok;
    
    -- PID Control Process
    process(clk, reset)
    begin
        if reset = '1' then
            integral <= 0;
            last_error <= (others => '0');
        elsif rising_edge(clk) then
            if calibracao_ok = '1' then
                -- Converte o setpoint e calcula o erro
                error <= to_signed(setpoint, 32) - to_signed(nivel_atual - nivel_vazio, 32);

                -- Integral calculation com limitação
                integral <= integral + to_integer(error);
                if integral > 255 then
                    integral <= 255;
                elsif integral < 0 then
                    integral <= 0;
                end if;

                -- Derivative calculation
                derivative <= error - last_error;
                last_error <= error;

                -- PID output calculation com limitação
                pid_output <= (to_integer(error) * Kp) + (integral * Ki) + (to_integer(derivative) * Kd);
                if pid_output > PWM_PERIOD then
                    pid_output <= PWM_PERIOD;
                elsif pid_output < 0 then
                    pid_output <= 0;
                end if;
            end if;
        end if;
    end process;

    -- PWM Generation Process
    process(clk, reset)
    begin
        if reset = '1' then
            pwm_counter <= 0;
            pwm_output <= '0';
        elsif rising_edge(clk) then
            if pwm_counter < PWM_PERIOD then
                pwm_counter <= pwm_counter + 1;
            else
                pwm_counter <= 0;
            end if;

            if pwm_counter < pid_output then
                pwm_output <= '1';
            else
                pwm_output <= '0';
            end if;
        end if;
    end process;

end architecture;
