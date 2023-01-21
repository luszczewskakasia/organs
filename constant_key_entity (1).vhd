LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY constantkey IS
  PORT (
    reset      : IN std_logic;
    clk        : IN std_logic; -- 50MHz clokc
    scancode   : IN std_logic_vector(7 DOWNTO 0);
    byte_read  : IN std_logic;
    dig2, dig3 : OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display dig2 en dig3 (resp high & low).
    key        : OUT std_logic_vector(7 DOWNTO 0)    
    );
END constantkey;

architecture behavior of constantkey is
	signal previous_byteread : std_logic;
  FUNCTION hex2display (n:std_logic_vector(3 DOWNTO 0)) RETURN std_logic_vector IS
    VARIABLE res : std_logic_vector(6 DOWNTO 0);
  BEGIN
    CASE n IS          --        gfedcba; low active
	    WHEN "0000" => RETURN NOT "0111111";
	    WHEN "0001" => RETURN NOT "0000110";
	    WHEN "0010" => RETURN NOT "1011011";
	    WHEN "0011" => RETURN NOT "1001111";
	    WHEN "0100" => RETURN NOT "1100110";
	    WHEN "0101" => RETURN NOT "1101101";
	    WHEN "0110" => RETURN NOT "1111101";
	    WHEN "0111" => RETURN NOT "0000111";
	    WHEN "1000" => RETURN NOT "1111111";
	    WHEN "1001" => RETURN NOT "1101111";
	    WHEN "1010" => RETURN NOT "1110111";
	    WHEN "1011" => RETURN NOT "1111100";
	    WHEN "1100" => RETURN NOT "0111001";
	    WHEN "1101" => RETURN NOT "1011110";
	    WHEN "1110" => RETURN NOT "1111001";
	    WHEN OTHERS => RETURN NOT "1110001";			
    END CASE;
  END hex2display;

  
begin	
	process(clk,reset)
		variable pre_key :std_logic_vector (7 downto 0);
		variable previous_byteread : std_logic;
		
	type states is (init, pressed, realeased);
		variable state :states;

		begin
			if reset ='0' then
				dig2 <= (others => '0');
				dig3 <= (others => '0');				
				previous_byteread := '1';
		
			elsif rising_edge(clk) then
				if (previous_byteread = '0') then
					if (byte_read = '1') then --key realeased
						if (scancode /= "00000000") then
							case state is
								when init =>
									pre_key := scancode;
									state := pressed;
								when pressed =>
									if (scancode = "11110000") then
										pre_key := (others => '0');
										state := realeased;
									else
										pre_key := scancode;
									end if;
								when realeased =>
									pre_key:=(others => '0');
									state := init;
							end case;
						end if;
					end if;
				end if;
			
			previous_byteread := byte_read;
			dig2 <= hex2display(pre_key(3 downto 0));
			dig3 <= hex2display(pre_key(7 downto 4));
			key <= pre_key;
			
			end if;
		end process;
end;
			
