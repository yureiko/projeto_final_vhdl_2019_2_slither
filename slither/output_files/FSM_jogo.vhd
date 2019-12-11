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
				estado_jogo			:	  OUT ESTADO;	
				
	);
END ENTITY;
---------------------------------------------
ARCHITECTURE arch OF FSM_jogo IS	
	signal pr_state: ESTADO_COBRA := PARADA;
	signal nx_state: ESTADO_COBRA;
BEGIN

	SNAKE_STATE <= pr_state; 
	
	change_state_process:
	process(clk,rst)
	begin
		if rst = '1' then 
			pr_state <= PARADA;
		elsif rising_edge(clk) then
			pr_state <= nx_state;
		end if;
	end process change_state_process;
END ARCHITECTURE;