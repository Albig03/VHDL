library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_ctrl is
    Port ( 
        clk     : in  std_logic;
        en      : in  std_logic;
        hcount  : out std_logic_vector (9 downto 0);
        vcount  : out std_logic_vector (9 downto 0);
        vid     : out std_logic;
        hs      : out std_logic;
        vs      : out std_logic
    );
end vga_ctrl;

architecture vga_behavior of vga_ctrl is
    signal h_counter : unsigned(9 downto 0) := (others => '0');
    signal v_counter : unsigned(9 downto 0) := (others => '0');
    
    constant H_MAX : integer := 799;  
    constant V_MAX : integer := 524;  
    
    constant H_DISPLAY_END : integer := 639;  
    constant V_DISPLAY_END : integer := 479; 
    
    constant H_SYNC_START : integer := 656;
    constant H_SYNC_END : integer := 751;
    
    constant V_SYNC_START : integer := 490;
    constant V_SYNC_END : integer := 491;
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if h_counter = H_MAX then
                    h_counter <= (others => '0');
                    
                    if v_counter = V_MAX then
                        v_counter <= (others => '0');
                    else
                        v_counter <= v_counter + 1;
                    end if;
                else
                    h_counter <= h_counter + 1;
                end if;
            end if;
        end if;
    end process;

    hcount <= std_logic_vector(h_counter);
    vcount <= std_logic_vector(v_counter);
    
    vid <= '1' when (h_counter <= H_DISPLAY_END) and (v_counter <= V_DISPLAY_END) else '0';
    
    hs <= '0' when (h_counter >= H_SYNC_START) and (h_counter <= H_SYNC_END) else '1';
    
    vs <= '0' when (v_counter >= V_SYNC_START) and (v_counter <= V_SYNC_END) else '1';

end vga_behavior;