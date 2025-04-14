library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_div4 is
    Port ( 
        clk     : in  std_logic;
        rst     : in  std_logic;
        clk_en  : out std_logic
    );
end clock_div4;

architecture behavior_clock_div of clock_div4 is
    signal count : unsigned(2 downto 0) := (others => '0'); 
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= (others => '0');
            else
                if count = "100" then  
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
    
    clk_en <= '1' when count = "000" else '0'; 
end behavior_clock_div;