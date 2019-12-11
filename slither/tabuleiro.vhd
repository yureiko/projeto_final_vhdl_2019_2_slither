library ieee;
use ieee.std_logic_1164.all;
library work;
use work.comum.all;

entity tabuleiro is
	
port(
		clk						: 	in	std_logic;				--variÃ¡vel de clk, controla o fluxo de comida
		tick						: 	in	std_logic;				--variÃ¡vel de tick, controla o fluxo de comida
		estado_jogo				:  in ESTADO;
		
--variaveis que sÃ³ sÃ£o utilizadas na implementaÃ§ao da cobra virando comida	
		green_snake_x			:	in posicao_X_type;
		green_snake_y			:	in posicao_Y_type;
		green_size				:	in natural range 0 to MAX_SNAKE_LENGTH-1;
		green_dead				:	in std_logic;
		
		yellow_snake_x			:	in posicao_X_type;
		yellow_snake_y			:	in posicao_Y_type;
		yellow_size				:	in natural range 0 to MAX_SNAKE_LENGTH-1;
		yellow_dead				:	in std_logic;
		
		blue_snake_x			:	in posicao_X_type;
		blue_snake_y			:	in posicao_Y_type;
		blue_size				:	in natural range 0 to MAX_SNAKE_LENGTH-1;
		blue_dead				:	in std_logic;
		
		pink_snake_x			:	in posicao_X_type;
		pink_snake_y			:	in posicao_Y_type;
		pink_size				:	in natural range 0 to MAX_SNAKE_LENGTH-1;
		pink_dead				:	in std_logic;
		
		new_food_position_x	:	in natural range 0 to X_RESOLUTION -1;				--recebe a coordenada para inserir uma comida no tabuleiro
		new_food_position_y	:	in natural range 0 to Y_RESOLUTION -1;				--recebe a coordenada para inserir uma comida no tabuleiro
		
		clear_food_position	: 	in FOODS_POSITION;								--recebe a coordeneda para limpar uma comida do tabuleiro

		--SAIDAS

		food_array_out_x		: 	out FOOD_ARRAY_X_TYPE;									--vetor de comidas com MAX_FOOD posiÃ§oes, contÃ©m as coordenadas
		food_array_out_y		: 	out FOOD_ARRAY_Y_TYPE;									--vetor de comidas com MAX_FOOD posiÃ§oes, contÃ©m as coordenadas

		food_index				: 	out natural range 0 to FOOD_ARRAY_SIZE				--vetor que contÃ©m a quantidade de comidas do vetor
			 
);
end entity;

architecture tabuleiro_a of tabuleiro is

signal food_array_x 			: FOOD_ARRAY_X_TYPE;
signal food_array_y 			: FOOD_ARRAY_Y_TYPE;

signal food_count				: NATURAL range 0 to FOOD_ARRAY_SIZE;

signal flag_food				: std_logic_vector(FOOD_ARRAY_SIZE downto 0);		--sinalizador que a comida ja existe no vetor

signal estado, prox_estado : natural range 0 to 4*SIZE_DEAD + 10 := 0;
signal read_enable			: std_logic;
signal clear_food_position_signal	: 	FOODS_POSITION;

begin

--Verifica se a nova comida ja existe no vetor de comidas
flag_food(0) <= '0';
FOOD_ARRAY_FIND: for i in 1 to FOOD_ARRAY_SIZE  generate
							flag_food(i) <= 	'1' when food_array_x(i-1) = new_food_position_x and food_array_y(i-1) = new_food_position_y 
													and new_food_position_y  /= 0 and new_food_position_x /= 0
													else
													flag_food(i-1);
						end generate FOOD_ARRAY_FIND;		
						
process(clk)
begin

if rising_edge(clk) then

	if prox_estado = 1 then 
		if read_enable = '1' and estado_jogo = JOGANDO then
			estado <= prox_estado; --troca o estado
		end if;
	else
			estado <= prox_estado; --troca o estado
	end if;
end if;

end process;


process(tick, estado)
begin
if rising_edge(tick) then
	read_enable <= '1';
end if;

if estado > 0 then
	read_enable <= '0';
end if;

end process;		
	
--processo que insere e remove comidas do vetor de comidas
process(all)
begin
	
case estado is
		when 0 =>	
		
			if read_enable = '1' then			
					prox_estado <= 1;			
			end if;

		when 4*SIZE_DEAD + 10 =>			
					prox_estado <= 0;
		when others => 
					prox_estado <= estado + 1;
end case;

if rising_edge(clk) then
		if estado = 0 then
			clear_food_position_signal <= clear_food_position;
		end if;
		
		--estados de 1 a 5 removem as comidas selecionadas
		if estado = 1 and food_count > 0 and clear_food_position_signal(0) /= -1 then
			REMOVE_FOOD_0:	for i in 0 to FOOD_ARRAY_SIZE -1 loop
									if i >= clear_food_position_signal(0) then
										food_array_x(i) <= food_array_x(i+1);				--desloca o vetor para as posicoes menos significativas
										food_array_y(i) <= food_array_y(i+1);
									end if;
								end loop REMOVE_FOOD_0;
			food_count <= food_count -1;														--decrementa o contador de comidas	
			clear_food_position_signal(0) <= -1;
			
		elsif estado = 2 and food_count > 0 and clear_food_position_signal(1) /= -1 then			
				REMOVE_FOOD_1:	for i in 0 to FOOD_ARRAY_SIZE -1 loop
										if i >= clear_food_position_signal(1) then			--desloca o vetor para as posicoes menos significativas
											food_array_x(i) <= food_array_x(i+1);
											food_array_y(i) <= food_array_y(i+1);
										end if;
									end loop REMOVE_FOOD_1;
				food_count <= food_count -1;														--decrementa o contador de comidas
				clear_food_position_signal(1) <= -1;
			
		elsif estado = 3 and food_count > 0 and clear_food_position_signal(2) /= -1 then 				
				REMOVE_FOOD_2:	for i in 0 to FOOD_ARRAY_SIZE -1 loop
										if i >= clear_food_position_signal(2) then				
											food_array_x(i) <= food_array_x(i+1);				--desloca o vetor para as posicoes menos significativas
											food_array_y(i) <= food_array_y(i+1);
										end if;
									end loop REMOVE_FOOD_2;
				food_count <= food_count -1;														--decrementa o contador de comidas
				clear_food_position_signal(2) <= -1;
			
		elsif estado = 4 and food_count > 0 and clear_food_position_signal(3) /= -1 then
				REMOVE_FOOD_3:	for i in 0 to FOOD_ARRAY_SIZE -1 loop
										if i >= clear_food_position_signal(3) then
											food_array_x(i) <= food_array_x(i+1);				--desloca o vetor para as posicoes menos significativas
											food_array_y(i) <= food_array_y(i+1);
										end if;
									end loop REMOVE_FOOD_3;	
				food_count <= food_count -1;														--decrementa o contador de comidas
				clear_food_position_signal(3) <= -1;
			
		elsif estado = 5 then
			if food_count < MAX_FOOD  and flag_food(FOOD_ARRAY_SIZE) = '0' then 		--insere caso tenha espaÃ§o e caso a comida nao exista
				food_array_x(food_count) <= new_food_position_x;							--insere comida na ultima posicao valida
				food_array_y(food_count) <= new_food_position_y;							--insere comida na ultima posicao valida
				
				food_count <= food_count +1;														--incrementa o contador de comidas
			end if;
		end if;

		--estados que inserem comidas vindas da morte das cobras
SNAKE_FOOD: for i in 0 to SIZE_DEAD loop				
		if estado = i*4 + 6 and food_count < FOOD_ARRAY_SIZE and green_dead = '1' and (2*i + 1) < green_size then
	
				food_array_x(food_count) <= green_snake_x(2*i + 1);
				food_array_y(food_count) <= green_snake_y(2*i + 1);
				food_count <= food_count + 1;

		
		elsif estado = i*4 + 7 and food_count < FOOD_ARRAY_SIZE and yellow_dead = '1'  and (2*i + 1) < yellow_size then
			
				food_array_x(food_count) <= yellow_snake_x(2*i + 1);
				food_array_y(food_count) <= yellow_snake_y(2*i + 1);
				food_count <= food_count + 1;

			
		elsif estado = i*4 + 8 and food_count < FOOD_ARRAY_SIZE and blue_dead = '1'  and (2*i + 1) < blue_size then
	
				food_array_x(food_count) <= blue_snake_x(2*i + 1);
				food_array_y(food_count) <= blue_snake_y(2*i + 1);
				food_count <= food_count + 1;

											
		elsif estado = i*4 + 9 and food_count < FOOD_ARRAY_SIZE  and pink_dead = '1'  and (2*i + 1) < pink_size then
	
				food_array_x(food_count) <= pink_snake_x(2*i + 1);
				food_array_y(food_count) <= pink_snake_y(2*i + 1);
				food_count <= food_count + 1;

		end if;
		
		--ultimo estado -> atualiza saída
		if estado = 4*SIZE_DEAD + 10 then
			food_index <= food_count;				--envia contador de comidas para a saÃ­da
			food_array_out_x <= food_array_x;	--envia vetores de comidas para a saÃ­da
			food_array_out_y <= food_array_y;
		end if;
		
		end loop SNAKE_FOOD;
end if;		
end process;

	
end architecture;