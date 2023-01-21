LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY key2pulselength IS
  GENERIC (max_length : integer := 20000);
  PORT (key    : IN std_logic_vector(7 DOWNTO 0);
        pulse_length : OUT INTEGER RANGE 0 TO max_length
       );
END key2pulselength;

architecture bhv of key2pulselength is 

		constant key_tab : std_logic_vector := X"0D";
		constant key_q 	 : std_logic_vector := X"15";
		constant key_w   : std_logic_vector := X"1D";
		constant key_e 	 : std_logic_vector := X"24";		
		constant key_r 	 : std_logic_vector := X"2D";		
		constant key_t 	 : std_logic_vector := X"2C";		
		constant key_y 	 : std_logic_vector := X"35";		
		constant key_u 	 : std_logic_vector := X"3C";		
		constant key_i 	 : std_logic_vector := X"43";		
		constant key_o 	 : std_logic_vector := X"44";		
		constant key_p 	 : std_logic_vector := X"4D";		
		constant key_sp1 : std_logic_vector := X"54";		
		constant key_sp2 : std_logic_vector := X"5B";		
		constant key_1 	 : std_logic_vector := X"16";
		constant key_3   : std_logic_vector := X"26";
		constant key_4 	 : std_logic_vector := X"25";		
		constant key_6 	 : std_logic_vector := X"36";		
		constant key_7 	 : std_logic_vector := X"3D";		
		constant key_8 	 : std_logic_vector := X"3E";		
		constant key_0 	 : std_logic_vector := X"45";		
		constant key_sp3 : std_logic_vector := X"4E";		
		constant key_sp4 : std_logic_vector := X"5D";

  FUNCTION key2frequency (n: std_logic_vector (7 DOWNTO 0)) RETURN integer IS
    VARIABLE res : integer;
  BEGIN
    CASE n IS          
	    WHEN X"0D" => RETURN 440;
	    WHEN X"16" => RETURN 466;
	    WHEN X"15" => RETURN 493;
	    WHEN X"1D" => RETURN 523;
	    WHEN X"26" => RETURN 554;
	    WHEN X"24" => RETURN 587;
	    WHEN X"25" => RETURN 622;
	    WHEN X"2D" => RETURN 659;
	    WHEN X"2C" => RETURN 698;
	    WHEN X"36" => RETURN 739;
	    WHEN X"35" => RETURN 783;
	    WHEN X"3D" => RETURN 830;
	    WHEN X"3C" => RETURN 880;
	    WHEN X"3E" => RETURN 932;
	    WHEN X"43" => RETURN 987;
	    WHEN X"44" => RETURN 1046;
	    WHEN X"45" => RETURN 1108;
	    WHEN X"4D" => RETURN 1174;
	    WHEN X"4E" => RETURN 1244;
	    WHEN X"54" => RETURN 1318;
	    WHEN X"5B" => RETURN 1396;
	    WHEN X"5D" => RETURN 1479;
	    WHEN OTHERS => RETURN 0;			
    END CASE;
  END key2frequency;

begin 
	pulse_length <= key2frequency(key);
end;
	
