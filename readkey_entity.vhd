LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY readkey IS
  PORT (
    clk        : IN std_logic; -- high freq. clock (~ 50 MHz)
    reset      : IN std_logic;
    kbdata     : IN STD_LOGIC; -- low freq. clk (~ 20 kHz) serial data from the keyboard
    kbclock    : IN STD_LOGIC; -- clock from the keyboard
	  key        : OUT std_logic_vector(7 DOWNTO 0);
	  -- I/O check via 7-segment displays    
    dig0, dig1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- show key pressed on display
    dig2, dig3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- show key pressed on display; after processed by constant key
   );
END readkey;

architecture bhv of readkey is
	signal scancode   : std_logic_vector(7 DOWNTO 0);
	signal byte_read  : std_logic;
	
	
	begin 
		sk:entity work.showkey port map (
			reset => reset,
			kbclock => kbclock,
			kbdata => kbdata,
			dig0 => dig0,
			dig1 => dig1,
			scancode => scancode,
			byte_read => byte_read
		);
	
		ck:entity work.constantkey port map (
			byte_read => byte_read,
			clk => clk,
			reset => reset,
			scancode => scancode,
			dig2 => dig2,
			dig3 => dig3,
			key => key
		);
	end;