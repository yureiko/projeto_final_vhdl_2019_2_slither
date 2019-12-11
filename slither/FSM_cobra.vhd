---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY work;
USE work.comum.all;
---------------------------------------------

ENTITY FSM_cobra IS
	PORT (
		clk: 				IN STD_LOGIC;
		rst:	 			IN STD_LOGIC;
		verify_morreu: IN STD_LOGIC;
		bot_start:		IN STD_LOGIC;
		perdeu_vida: 	IN STD_LOGIC;
		bot_mov:			IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- bit0 para direita, bit1 para cima, bit2 para esquerda e bit3 para baixo 
		VIDAS:			IN NATURAL RANGE 0 TO INITIAL_LIVES; -- numero de vidas
		ESTADO_JOGO:  	IN	ESTADO;
		SNAKE_STATE:	OUT ESTADO_COBRA
	);
END ENTITY;
---------------------------------------------
ARCHITECTURE Behavior OF FSM_cobra IS	
	signal pr_state: ESTADO_COBRA := PARADA;
	signal nx_state: ESTADO_COBRA := PARADA;
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
	
	FSM_cobra_process:	process(clk)
	begin
		
		case pr_state is 
			when PARADA => --muda de estado caso algum botão de movimento seja pressionado ou se outra combra colidir com a cabeça da cobra
				if ESTADO_JOGO = JOGANDO then
					if bot_mov(1) = '1' then 
						nx_state <= SUBINDO;
					elsif bot_mov(3) = '1' then
						nx_state <= DESCENDO;
					elsif bot_mov(0) = '1' then
						nx_state <= DIREITA;
					elsif bot_mov(2) = '1' then
						nx_state <= ESQUERDA;
					elsif perdeu_vida = '1' AND VIDAS > 0 then
						nx_state <= MORREU;
					elsif perdeu_vida = '1' AND VIDAS <= 0 then
						nx_state <= DESAPARECE;
					else
						nx_state <= PARADA;
					end if;
				else
					nx_state <= PARADA;
				end if;
				
			when MORREU => --muda de estado para parada após receber o sinal que o estado foi lido pela cobra
				if ESTADO_JOGO = JOGANDO then
					if verify_morreu = '1' then
						nx_state <= PARADA;
					else
						nx_state <= MORREU;
					end if;
				else
					nx_state <= PARADA;
				end if;
			
			when ESQUERDA => -- muda de estado quando botão para cima ou para baixo é pressionado ou quando há alguma colisão 
				if ESTADO_JOGO = JOGANDO then
					if perdeu_vida = '1' AND VIDAS > 0 then
						nx_state <= MORREU;
					elsif perdeu_vida = '1' AND VIDAS <= 0 then
						nx_state <= DESAPARECE;
					elsif bot_mov(1) = '1' then 
						nx_state <= SUBINDO;
					elsif bot_mov(3) = '1' then
						nx_state <= DESCENDO;
					else
						nx_state <= ESQUERDA;
					end if;
				else
					nx_state <= PARADA;
				end if;
				
			when DIREITA => -- muda de estado quando botão para cima ou para baixo é pressionado ou quando há alguma colisão 
				if ESTADO_JOGO = JOGANDO then
					if perdeu_vida = '1' AND VIDAS > 0 then
						nx_state <= MORREU;
					elsif perdeu_vida = '1' AND VIDAS <= 0 then
						nx_state <= DESAPARECE;
					elsif bot_mov(1) = '1' then 
						nx_state <= SUBINDO;
					elsif bot_mov(3) = '1' then
						nx_state <= DESCENDO;
					else
						nx_state <= DIREITA;
					end if;
				else
					nx_state <= PARADA;
				end if;
				
			when SUBINDO => -- muda de estado quando botão para esquerda ou para direita é pressionado ou quando há alguma colisão 
				if ESTADO_JOGO = JOGANDO then
					if perdeu_vida = '1' AND VIDAS > 0 then
						nx_state <= MORREU;
					elsif perdeu_vida = '1' AND VIDAS <= 0 then
						nx_state <= DESAPARECE;
					elsif bot_mov(2) = '1' then 
						nx_state <= ESQUERDA;
					elsif bot_mov(0) = '1' then
						nx_state <= DIREITA;
					else
						nx_state <= SUBINDO;
					end if;
				else
					nx_state <= PARADA;
				end if;
				
			when DESCENDO => -- muda de estado quando botão para esquerda ou para direita é pressionado ou quando há alguma colisão 
				if ESTADO_JOGO = JOGANDO then
					if perdeu_vida = '1' AND VIDAS > 0 then
						nx_state <= MORREU;
					elsif perdeu_vida = '1' AND VIDAS <= 0 then
						nx_state <= DESAPARECE;
					elsif bot_mov(2) = '1' then 
						nx_state <= ESQUERDA;
					elsif bot_mov(0) = '1' then
						nx_state <= DIREITA;
					else
						nx_state <= DESCENDO;
					end if;
				else
					nx_state <= PARADA;
				end if;	
				
			when DESAPARECE => -- nesse estado a cobra só volta caso o jogo acabe ou seja reiniciado
				if 	ESTADO_JOGO = ACABOU or ESTADO_JOGO = ESPERANDO then
					nx_state <= PARADA;
				else	
					nx_state <= DESAPARECE;
				end if;
			when others =>
				nx_state <= PARADA;			
			end case;
	end process FSM_cobra_process;
	
END ARCHITECTURE;