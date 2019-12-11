library ieee;
USE ieee.std_logic_1164.all;
library work;
USE work.comum.all;
ENTITY gerador_tick is
port(		clk : in std_logic;
			estado_jogo : in ESTADO;
			tick : out std_logic
			);
END ENTITY;
ARCHITECTURE arch of gerador_tick is
signal tick_signal : std_logic;
begin
	PROCESS(clk)
		VARIABLE counter : integer := 0;
		BEGIN
		IF rising_edge(clk) THEN
			--IF (estado_jogo = JOGANDO) then		
				counter := counter + 1;
				IF(counter = 50000*TIMETICK_MS) then
					counter := 0;
					tick_signal <= not tick_signal;
				END IF;
			--ELSE
			--	tick_signal <= '0';
			--END IF;
		END IF;
	END PROCESS;
	tick <= tick_signal;
END ARCHITECTURE;