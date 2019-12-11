LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.comum.all;
-------------------------------------------

ENTITY vidas_display IS
    PORT (
		  vidas_blue: IN NATURAL RANGE 0 TO INITIAL_LIVES;
		  vidas_green: IN NATURAL RANGE 0 TO INITIAL_LIVES;
		  vidas_yellow: IN NATURAL RANGE 0 TO INITIAL_LIVES;
		  vidas_pink: IN NATURAL RANGE 0 TO INITIAL_LIVES;
		   
		  saida_lcd_blue: OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --abcdefg
		  saida_lcd_green: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  saida_lcd_yellow: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  saida_lcd_pink: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		  );
END ENTITY;
-------------------------------------------
ARCHITECTURE vidas_display OF vidas_display IS

SIGNAL not_saida_lcd_blue, not_saida_lcd_green, not_saida_lcd_yellow, not_saida_lcd_pink: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

	 not_saida_lcd_blue <=  "0111111" when vidas_blue = 0 else
									"0000110" when vidas_blue = 1 else
						         "1011011" when vidas_blue = 2 else
									"1001111" when vidas_blue = 3 else
									"1100110" when vidas_blue = 4 else
									"1101101" when vidas_blue = 5 else
									"1111101" when vidas_blue = 6 else
									"0000111" when vidas_blue = 7 else
									"1111111" when vidas_blue = 8 else
									"1100111" when vidas_blue = 9 else
									"0000000";
									
	not_saida_lcd_green <=  "0111111" when vidas_green = 0 else
									"0000110" when vidas_green = 1 else
						         "1011011" when vidas_green = 2 else
									"1001111" when vidas_green = 3 else
									"1100110" when vidas_green = 4 else
									"1101101" when vidas_green = 5 else
									"1111101" when vidas_green = 6 else
									"0000111" when vidas_green = 7 else
									"1111111" when vidas_green = 8 else
									"1100111" when vidas_green = 9 else
									"0000000";	
									
	not_saida_lcd_yellow <= "0111111" when vidas_yellow = 0 else
									"0000110" when vidas_yellow = 1 else
						         "1011011" when vidas_yellow = 2 else
									"1001111" when vidas_yellow = 3 else
									"1100110" when vidas_yellow = 4 else
									"1101101" when vidas_yellow = 5 else
									"1111101" when vidas_yellow = 6 else
									"0000111" when vidas_yellow = 7 else
									"1111111" when vidas_yellow = 8 else
									"1100111" when vidas_yellow = 9 else
									"0000000";		
		
	not_saida_lcd_pink <=   "0111111" when vidas_pink = 0 else
									"0000110" when vidas_pink = 1 else
						         "1011011" when vidas_pink = 2 else
									"1001111" when vidas_pink = 3 else
									"1100110" when vidas_pink = 4 else
									"1101101" when vidas_pink = 5 else
									"1111101" when vidas_pink = 6 else
									"0000111" when vidas_pink = 7 else
									"1111111" when vidas_pink = 8 else
									"1100111" when vidas_pink = 9 else
									"0000000";		
	
	 saida_lcd_blue  <=  NOT(not_saida_lcd_blue);
	 saida_lcd_green <=  NOT(not_saida_lcd_green);
	 saida_lcd_yellow <= NOT(not_saida_lcd_yellow);
	 saida_lcd_pink   <= NOT(not_saida_lcd_pink);
	 
END ARCHITECTURE;