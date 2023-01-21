library ieee;
use ieee.std_logic_1164.all;
entity showkey is
port (
	reset 		: in std_logic;
	kbclock 	: in std_logic;
	kbdata		: in std_logic;
	dig0, dig1 	: out std_logic_vector (6 downto 0);
	scancode	: out std_logic_vector (7 downto 0);
	byte_read	: out std_logic
	);
end showkey;

  

architecture bhv of showkey is
	signal data_cnt: integer range 0 to 10;
	signal pre_dig0: std_logic_vector (3 downto 0);
	signal pre_dig1: std_logic_vector (3 downto 0);
	signal pre_scancode: std_logic_vector (7 downto 0);

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
	process (reset, kbclock)
	begin
		if reset = '0' then
			data_cnt <= 0;	--it has to count 11 bits, so 11 clock cycles
			dig0 <="0000000";
			dig1 <= "0000000";
			byte_read <= '0';
			scancode <= "00000000";

 
		elsif falling_edge(kbclock) then
			if (data_cnt = 0) then 
				byte_read <= '0';
				data_cnt <= data_cnt + 1;
			elsif (data_cnt >= 1 and data_cnt <= 4) then
				pre_dig0(data_cnt - 1) <= kbdata;
				pre_scancode(data_cnt -1) <= kbdata;
				data_cnt <= data_cnt + 1;
			elsif (data_cnt >= 5 and data_cnt <= 8) then
				pre_dig1(data_cnt - 5) <= kbdata;
				pre_scancode (data_cnt -1) <= kbdata;
				data_cnt <= data_cnt + 1;
			elsif (data_cnt = 9) then
				data_cnt <= data_cnt + 1;
			elsif (data_cnt = 10) then
				data_cnt <= 0;
				scancode <= pre_scancode;
				dig0 <= hex2display(pre_dig0);
				dig1 <= hex2display(pre_dig1);
				byte_read <= '1';
			end if;

		end if;
	end process;

end;

--kbclock is continuosly high till pressing the key on keyboard
--byte_read is 1 when 11 bits are received; it's 0 at the beggining
--dig 1 and dig0 are for hex notation of MSB
--scancode works when previous input is 0 and current is 1
--kbd data works after one clock cycle
--kbc clock line is low for 60 ns, then kbd data comes
--both kbd clock and data have to be high; kbd clock waits till is gets high
--after first falling egde of the clock, first data bit can be uploaded
--generating kb clock line takes up to 10 ms
--we need 11 cycles to transfer one element
--after pressing the key, the kb clock line is generetaed and after 10 ms you can 
