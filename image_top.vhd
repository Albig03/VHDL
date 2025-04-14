library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity image_top is
    Port ( 
        clk     : in  std_logic;  
        rst     : in  std_logic;  
        vga_hs  : out std_logic;  
        vga_vs  : out std_logic;  
        vga_r   : out std_logic_vector (4 downto 0);  
        vga_g   : out std_logic_vector (5 downto 0); 
        vga_b   : out std_logic_vector (4 downto 0) 
    );
end image_top;

architecture top_behavior of image_top is
    component clock_div4
        Port ( 
            clk     : in  std_logic;
            rst     : in  std_logic;
            clk_en  : out std_logic
        );
    end component;
    
    component vga_ctrl
        Port ( 
            clk     : in  std_logic;
            en      : in  std_logic;
            hcount  : out std_logic_vector (9 downto 0);
            vcount  : out std_logic_vector (9 downto 0);
            vid     : out std_logic;
            hs      : out std_logic;
            vs      : out std_logic
        );
    end component;
    
    component pixel_pusher
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
    end component;
    
    component picture2
        Port (
            clka  : in  std_logic;
            addra : in  std_logic_vector (17 downto 0);
            douta : out std_logic_vector (7 downto 0)
        );
    end component;
    
    signal clk_en  : std_logic;
    signal hcount  : std_logic_vector (9 downto 0);
    signal vcount  : std_logic_vector (9 downto 0);
    signal vid     : std_logic;
    signal hs      : std_logic;
    signal vs      : std_logic;
    signal pixel   : std_logic_vector (7 downto 0);
    signal addr    : std_logic_vector (17 downto 0);
    
begin
    clock_divider: clock_div4 port map (
        clk => clk,
        rst => rst,
        clk_en => clk_en
    );
    
    vga_controller: vga_ctrl port map (
        clk => clk,
        en => clk_en,
        hcount => hcount,
        vcount => vcount,
        vid => vid,
        hs => hs,
        vs => vs
    );
    
    image_memory: picture2 port map (
        clka => clk,
        addra => addr,
        douta => pixel
    );
    
    pp: pixel_pusher port map (
        clk => clk,
        en => clk_en,
        vs => vs,
        pixel => pixel,
        hcount => hcount,
        vid => vid,
        R => vga_r,
        G => vga_g,
        B => vga_b,
        addr => addr
    );
    
    vga_hs <= hs;
    vga_vs <= vs;

end top_behavior;