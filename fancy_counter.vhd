--library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--entity
entity fancy_counter is
    Port ( clk     : in  std_logic;      
           rst     : in  std_logic;       
           en      : in  std_logic;        
           clk_en  : in  std_logic;        
           updn    : in  std_logic;      
           dir     : in  std_logic;       
           ld      : in  std_logic;      
           val     : in  std_logic_vector(3 downto 0); 
           cnt     : out std_logic_vector(3 downto 0)  
         );
end fancy_counter;

--architecture
architecture behavior_fancy_counter of fancy_counter is
    signal counter     : unsigned(3 downto 0) := (others => '0'); 
    signal max_value   : unsigned(3 downto 0) := (others => '0'); 
    signal direction   : std_logic := '1';  

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter    <= (others => '0');  
                direction  <= '1';              
                max_value  <= (others => '0');  
            elsif (en = '1' and clk_en = '1') then
                if ld = '1' then
                    counter   <= unsigned(val); 
                    max_value <= unsigned(val);
                elsif updn = '1' then
                    direction <= dir; 
                else
                    if direction = '1' then 
                        if counter = max_value then
                            counter <= (others => '0'); 
                        else
                            counter <= counter + 1; 
                        end if;
                    else 
                        if counter = "0000" then
                            counter <= max_value; 
                        else
                            counter <= counter - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    cnt <= std_logic_vector(counter); 

end behavior_fancy_counter;