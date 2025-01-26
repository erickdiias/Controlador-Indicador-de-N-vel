library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Distancia_Calc is
    Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            digit_0 : out integer range 0 to 9;
            digit_1 : out integer range 0 to 9;
            digit_2 : out integer range 0 to 9;
            digit_3 : out integer range 0 to 9;
            distancia_int : in integer
        );
end Distancia_Calc;

architecture Behavioral of Distancia_Calc is

begin
    process(clk,reset)
        begin
            if reset = '1' then
                digit_0 <= 0;
                digit_1 <= 0;
                digit_2 <= 0;
                digit_3 <= 0;
            elsif clk'event and clk = '1' then
                digit_0 <= distancia_int mod 10;           -- Unidade
                digit_1 <= (distancia_int / 10) mod 10;    -- Dezena
                digit_2 <= (distancia_int / 100) mod 10;   -- Centena
                digit_3 <= (distancia_int / 1000) mod 10;  -- Milhar
        end if;
    end process;

end Behavioral;
