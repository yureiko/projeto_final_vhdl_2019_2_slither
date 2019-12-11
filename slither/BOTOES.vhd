---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY work;
USE work.comum.all;
---------------------------------------------

ENTITY BOTOES IS
	PORT (
		tick: 				IN STD_LOGIC;
		bot_mov_blue					:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_green					:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_yellow					:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_pink					:		IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_blue_processado		:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_green_processado	:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_yellow_processado	:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		bot_mov_pink_processado		:		OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

	);
END ENTITY;
---------------------------------------------
ARCHITECTURE arch OF BOTOES IS	
BEGIN

	process(tick)
	begin
	if rising_edge(tick) then
		bot_mov_blue_processado <= bot_mov_blue;
		bot_mov_green_processado <= bot_mov_green;
		bot_mov_yellow_processado <= bot_mov_yellow;
		bot_mov_pink_processado <= bot_mov_pink;
	end if;
	end process;

END ARCHITECTURE;