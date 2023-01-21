LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pulselength2nextvalue IS
  GENERIC (max_length : integer := 20000);
  PORT  (clk           : IN std_logic;
         reset         : IN std_logic;
         sine_complete : IN std_logic;
         pulse_length  : IN INTEGER RANGE 0 TO max_length;
         next_value    : OUT std_logic
  );
END pulselength2nextvalue;

architecture bhv of pulselength2nextvalue is
begin
	process (reset, clk)
		variable temp_pulse_length : integer RANGE 0 TO max_length;
		variable cnt : integer RANGE 0 TO max_length;
	begin
		if reset = '0' then
			cnt := 0;
			temp_pulse_length := 0;
			next_value <= '0';

		elsif rising_edge(clk) then
			if (temp_pulse_length /= 0 and cnt = 0) then
				temp_pulse_length := pulse_length;
				next_value <= '1';
				cnt := cnt + 1;
				
			
			elsif (cnt = temp_pulse_length and sine_complete = '0') then
				next_value <= '1';
				cnt := 0;

 			elsif sine_complete = '1' then
				next_value <= '0';
				temp_pulse_length := pulse_length;
				cnt := 0;
			
			else
				next_value <= '0';
				cnt := cnt + 1;
			
			end if;
		temp_pulse_length := pulse_length;
			
		end if;
	end process;
end; 
