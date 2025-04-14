library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixel_pusher is
    Port ( 
        clk     : in  std_logic;
        en      : in  std_logic;
        vs      : in  std_logic;
        pixel   : in  std_logic_vector (7 downto 0);
        hcount  : in  std_logic_vector (9 downto 0);
        vid     : in  std_logic;
        R       : out std_logic_vector (4 downto 0);
        G       : out std_logic_vector (5 downto 0);
        B       : out std_logic_vector (4 downto 0);
        addr    : out std_logic_vector (17 downto 0)
    );
end pixel_pusher;

architecture pixel_behavior of pixel_pusher is
    signal addr_counter : unsigned(17 downto 0) := (others => '0');
    
    constant IMAGE_WIDTH : integer := 480;
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if vs = '0' then
                addr_counter <= (others => '0');
            elsif en = '1' and vid = '1' and unsigned(hcount) < IMAGE_WIDTH then
                addr_counter <= addr_counter + 1;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and vid = '1' and unsigned(hcount) < IMAGE_WIDTH then
                R <= pixel(7 downto 5) & "00";    
                G <= pixel(4 downto 2) & "000";   
                B <= pixel(1 downto 0) & "000";   
            else
                R <= (others => '0');
                G <= (others => '0');
                B <= (others => '0');
            end if;
        end if;
    end process;
    
    addr <= std_logic_vector(addr_counter);

end pixel_behavior;