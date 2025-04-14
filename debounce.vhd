--library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--entity
entity debounce is
    Port ( clk    : in  std_logic;          
           btn    : in  std_logic;           
           dbnc   : out std_logic
              );         
end debounce;

--architecture
architecture behavior_debounce of debounce is
    -- 2.5 million ticks for 20ms debounce time at 125 MHz
    constant DEBOUNCE_CNT_MAX : integer := 2500000;
    
    signal debounce_cnt : integer range 0 to DEBOUNCE_CNT_MAX := 0;
    signal dbnc_reg : std_logic := '0';
    signal stable_btn : std_logic := '0'; 

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn = stable_btn then
                if debounce_cnt < DEBOUNCE_CNT_MAX then
                    debounce_cnt <= debounce_cnt + 1;
                else
                    dbnc_reg <= stable_btn;
                end if;
            else
                debounce_cnt <= 0;
                stable_btn <= btn;  
            end if;
        end if;
    end process;
            dbnc <= dbnc_reg;
end behavior_debounce;