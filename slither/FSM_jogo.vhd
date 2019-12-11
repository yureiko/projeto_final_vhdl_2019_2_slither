---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY work;
USE work.comum.all;
---------------------------------------------
ENTITY FSM_jogo IS
	PORT (
				clk					: 		IN STD_LOGIC;
				rst:	 						IN STD_LOGIC;
				EstadoCobraBlue	:		IN ESTADO_COBRA;
				EstadoCobraGreen	:		IN ESTADO_COBRA;
				EstadoCobraYellow	:		IN ESTADO_COBRA;
				EstadoCobraPink	:		IN ESTADO_COBRA;
				bot_start_blue		:		IN STD_LOGIC;
				bot_start_green	:		IN STD_LOGIC;
				bot_start_yellow	:		IN STD_LOGIC;
				bot_start_pink		:		IN STD_LOGIC;
				estado_jogo			:	  OUT ESTADO
				
	);
END ENTITY;
---------------------------------------------
ARCHITECTURE arch OF FSM_jogo IS	
	signal pr_state: ESTADO := ESPERANDO;
	signal nx_state: ESTADO;
	signal blue_desapareceu 	:	integer range 0 to 1;
	signal green_desapareceu	:	integer range 0 to 1;
	signal yellow_desapareceu	:	integer range 0 to 1;
	signal pink_desapareceu		:	integer range 0 to 1;
BEGIN
	blue_desapareceu <=  1 when EstadoCobraBlue = DESAPARECE else
								0;
	green_desapareceu <=  1 when EstadoCobraGreen = DESAPARECE else
								 0;
	yellow_desapareceu <=  1 when EstadoCobraYellow = DESAPARECE else
								  0;
	pink_desapareceu <=  1 when EstadoCobraPink = DESAPARECE else
								0;
	estado_jogo <= pr_state; 
	
	change_state_process:
	process(clk,rst)
	begin
		if rst = '1' then 
			pr_state <= ESPERANDO;
		elsif rising_edge(clk) then
			pr_state <= nx_state;
		end if;
	end process change_state_process;
	
	FSM_jogo_process:	process(clk)
	begin
		case pr_state is 
			when ESPERANDO =>
				if bot_start_blue = '1' or bot_start_green = '1' or bot_start_yellow = '1' or bot_start_pink = '1' then
					nx_state <= JOGANDO;
				else
					nx_state <= ESPERANDO;
				end if;
			when JOGANDO =>
				if blue_desapareceu + green_desapareceu + yellow_desapareceu + pink_desapareceu >= 3 then
					nx_state <= ACABOU;
				else
					nx_state <= JOGANDO;
				end if;
			when ACABOU =>
				if bot_start_blue = '1' or bot_start_green = '1' or bot_start_yellow = '1' or bot_start_pink = '1' then
					nx_state <= ESPERANDO;
				else
					nx_state <= ACABOU;
				end if;
		end case;
	end process;
END ARCHITECTURE;