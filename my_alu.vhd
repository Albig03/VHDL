library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity my_alu is
    Port (
        A       : in  std_logic_vector(3 downto 0);  
        B       : in  std_logic_vector(3 downto 0); 
        opcode  : in  std_logic_vector(3 downto 0); 
        result  : out std_logic_vector(3 downto 0) 
    );
end my_alu;

architecture behavior of my_alu is
    signal A_int, B_int : unsigned(3 downto 0);
    signal res : unsigned(3 downto 0);
    
begin
    process(A, B, opcode)
    begin
        A_int <= unsigned(A);
        B_int <= unsigned(B);

        case opcode is
            when "0000" => res <= A_int + B_int;              -- A + B
            when "0001" => res <= A_int - B_int;              -- A - B
            when "0010" => res <= A_int + 1;                  -- A + 1
            when "0011" => res <= A_int - 1;                  -- A - 1
            when "0100" => res <= 0 - A_int;   -- 0 - A (with unsigned)
            when "0101" => if A_int > B_int then res <= "0001"; else res <= "0000"; end if;  -- A > B comparison
            when "0110" => res <= shift_left(A_int, 1);       -- A << 1 (logical left shift)
            when "0111" => res <= shift_right(A_int, 1);      -- A >> 1 (logical right shift)

            when "1000" => res <= A_int(3) & A_int(3 downto 1);      -- A >>> 1 (arithmetic right shift) (concat) Unsigned handle as LRS
            when "1001" => res <= not A_int;                  -- not A
            when "1010" => res <= A_int and B_int;            -- A and B
            when "1011" => res <= A_int or B_int;             -- A or B
            when "1100" => res <= A_int xor B_int;            -- A xor B
            when "1101" => res <= A_int xnor B_int;           -- A xnor B
            when "1110" => res <= A_int nand B_int;           -- A nand B
            when "1111" => res <= A_int nor B_int;            -- A nor B
            
            when others => res <= (others => '0');  
        end case;

        result <= std_logic_vector(res);
    end process;
end behavior;
