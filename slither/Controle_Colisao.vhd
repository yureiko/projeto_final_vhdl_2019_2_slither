---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY work;
USE work.comum.all;
---------------------------------------------
ENTITY Controle_Colisao IS
	PORT (
		clk						: IN STD_LOGIC;
		rst						: IN STD_LOGIC;
		estado_jogo 			: IN ESTADO;
		verificou_aumentou_tamanho_blue: IN STD_LOGIC;
		verificou_aumentou_tamanho_green: IN STD_LOGIC;
		verificou_aumentou_tamanho_yellow: IN STD_LOGIC;
		verificou_aumentou_tamanho_pink: IN STD_LOGIC;
		POS_X_COBRA_BLUE		: IN posicao_X_type;
		POS_Y_COBRA_BLUE		: IN posicao_Y_type;
		POS_X_COBRA_GREEN		: IN posicao_X_type;
		POS_Y_COBRA_GREEN		: IN posicao_Y_type;
		POS_X_COBRA_YELLOW	: IN posicao_X_type;
		POS_Y_COBRA_YELLOW	: IN posicao_Y_type;
		POS_X_COBRA_PINK		: IN posicao_X_type;
		POS_Y_COBRA_PINK		: IN posicao_Y_type;
		VETOR_X_COMIDAS 		: IN FOOD_ARRAY_X_TYPE;
		VETOR_Y_COMIDAS 		: IN FOOD_ARRAY_Y_TYPE;
		ESTADO_COBRA_BLUE		: IN ESTADO_COBRA;
		ESTADO_COBRA_GREEN	: IN ESTADO_COBRA;
		ESTADO_COBRA_YELLOW	: IN ESTADO_COBRA;
		ESTADO_COBRA_PINK		: IN ESTADO_COBRA;
		POSICAO_COMIDA			: OUT FOODS_POSITION;
		AUMENTA_COBRA_BLUE	: OUT STD_LOGIC;
		AUMENTA_COBRA_GREEN	: OUT STD_LOGIC;
		AUMENTA_COBRA_YELLOW	: OUT STD_LOGIC;
		AUMENTA_COBRA_PINK	: OUT STD_LOGIC;
		PERDE_VIDA_BLUE	 	: OUT STD_LOGIC;
		PERDE_VIDA_GREEN	 	: OUT STD_LOGIC;
		PERDE_VIDA_YELLOW	 	: OUT STD_LOGIC;
		PERDE_VIDA_PINK	 	: OUT STD_LOGIC	
	);
END ENTITY;
---------------------------------------------
ARCHITECTURE Behavior OF Controle_Colisao IS	
	TYPE POSICAO_X_4COBRAS_TYPE is array (3 downto 0) of posicao_X_type;
	TYPE POSICAO_Y_4COBRAS_TYPE is array (3 downto 0) of posicao_Y_type;
	TYPE ESTADO_4COBRAS_TYPE is array (3 downto 0) of ESTADO_COBRA;
	
	signal pr_state: integer range 0 to 5 := 0;
	signal nx_state: integer range 0 to 5 := 0;
	
	SIGNAL sig_colisao_boa 		: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
	SIGNAl sig_colisao_ruim		: STD_LOGIC_VECTOR(3 DOWNTO 0):="0000"; 
	SIGNAL sig_pos_x_cobras 	: POSICAO_X_4COBRAS_TYPE;
	SIGNAL sig_pos_y_cobras 	: POSICAO_Y_4COBRAS_TYPE;
	SIGNAL sig_vetor_x_food 	: FOOD_ARRAY_X_TYPE;
	SIGNAL sig_vetor_y_food 	: FOOD_ARRAY_Y_TYPE;
	SIGNAL sig_estados_cobras	: ESTADO_4COBRAS_TYPE;
	SIGNAL sig_pos_consumidas 	: FOODS_POSITION := (-1,-1,-1,-1);
	SIGNAL aux_consumidas 		: FOODS_POSITION := (-1,-1,-1,-1);
	
	SIGNAL verificou_aumentou_tamanho_signal : STD_LOGIC_VECTOR(3 downto 0);
	
BEGIN
	sig_pos_x_cobras(0) 	<= POS_X_COBRA_BLUE;
	sig_pos_y_cobras(0) 	<= POS_Y_COBRA_BLUE;
	sig_estados_cobras(0)<=	ESTADO_COBRA_BLUE;
	sig_pos_x_cobras(1) 	<= POS_X_COBRA_GREEN;
	sig_pos_y_cobras(1) 	<= POS_Y_COBRA_GREEN;
	sig_estados_cobras(1)<=	ESTADO_COBRA_GREEN;
	sig_pos_x_cobras(2) 	<= POS_X_COBRA_YELLOW;
	sig_pos_y_cobras(2) 	<= POS_Y_COBRA_YELLOW;
	sig_estados_cobras(2)<=	ESTADO_COBRA_YELLOW;
	sig_pos_x_cobras(3) 	<= POS_X_COBRA_PINK;
	sig_pos_y_cobras(3) 	<= POS_Y_COBRA_PINK;
	sig_estados_cobras(3)<=	ESTADO_COBRA_PINK;
	sig_vetor_x_food 		<= VETOR_X_COMIDAS;
	sig_vetor_y_food 		<= VETOR_Y_COMIDAS;
	
	
	PERDE_VIDA_BLUE 		<= sig_colisao_ruim(0);
	PERDE_VIDA_GREEN 		<= sig_colisao_ruim(1);
	PERDE_VIDA_YELLOW 	<= sig_colisao_ruim(2);
	PERDE_VIDA_PINK 		<= sig_colisao_ruim(3);
	AUMENTA_COBRA_BLUE	<= sig_colisao_boa(0);
	AUMENTA_COBRA_GREEN	<= sig_colisao_boa(1);
	AUMENTA_COBRA_YELLOW	<= sig_colisao_boa(2);
	AUMENTA_COBRA_PINK	<= sig_colisao_boa(3);
	POSICAO_COMIDA			<= sig_pos_consumidas;
	verificou_aumentou_tamanho_signal(0) <= verificou_aumentou_tamanho_blue;
	verificou_aumentou_tamanho_signal(1) <= verificou_aumentou_tamanho_green;
	verificou_aumentou_tamanho_signal(2) <= verificou_aumentou_tamanho_yellow;
	verificou_aumentou_tamanho_signal(3) <= verificou_aumentou_tamanho_pink;
	
	colisao_malefica_process:
	process(clk)
	begin
		if rising_edge(clk) AND estado_jogo = JOGANDO then
			if pr_state = 0 then
				for i in 0 to 3 loop
					if sig_estados_cobras(i) = MORREU or sig_estados_cobras(i) = DESAPARECE then
						sig_colisao_ruim(i) <= '0';
					end if;
				end loop;
			elsif pr_state = 1 then
				for i in 0 to 3 loop
					if (sig_pos_x_cobras(i)(0) = X_LEFT_CORNER or sig_pos_y_cobras(i)(0) = Y_UP_CORNER or
						sig_pos_x_cobras(i)(0) = X_RIGHT_CORNER or sig_pos_y_cobras(i)(0) = Y_DOWN_CORNER) and sig_estados_cobras(0) /= PARADA then
						sig_colisao_ruim(i) <= '1';
					end if;
				end loop;
			elsif pr_state = 2 then
				for i in 0 to 3 loop
					for j in 0 to MAX_SNAKE_LENGTH-1 loop
						if  sig_pos_x_cobras(0)(0) = sig_pos_x_cobras(i)(j) and sig_pos_y_cobras(0)(0) = sig_pos_y_cobras(i)(j) and i/=0 then
							sig_colisao_ruim(0) <= '1';	
						end if;
					end loop;
				end loop;
			elsif pr_state = 3 then
				for i in 0 to 3 loop
					for j in 0 to MAX_SNAKE_LENGTH-1 loop
						if  sig_pos_x_cobras(1)(0) = sig_pos_x_cobras(i)(j) and sig_pos_y_cobras(1)(0) = sig_pos_y_cobras(i)(j) and i/=1 then
							sig_colisao_ruim(1) <= '1';	
						end if;
					end loop;
				end loop;
			elsif pr_state = 4 then
				for i in 0 to 3 loop
					for j in 0 to MAX_SNAKE_LENGTH-1 loop
						if  sig_pos_x_cobras(2)(0) = sig_pos_x_cobras(i)(j) and sig_pos_y_cobras(2)(0) = sig_pos_y_cobras(i)(j) and i/=2 then
							sig_colisao_ruim(2) <= '1';	
						end if;
					end loop;
				end loop;
			elsif pr_state = 5 then
				for i in 0 to 3 loop
					for j in 0 to MAX_SNAKE_LENGTH-1 loop
						if  sig_pos_x_cobras(3)(0) = sig_pos_x_cobras(i)(j) and sig_pos_y_cobras(3)(0) = sig_pos_y_cobras(i)(j) and i/=3 then
							sig_colisao_ruim(3) <= '1';	
						end if;
					end loop;
				end loop;
			end if;
		end if;
	end process colisao_malefica_process;
	
	colisao_comida_process:	
	process(clk)
	variable aux: integer range -1 to FOOD_ARRAY_SIZE;
	begin
		if rising_edge(clk) AND estado_jogo = JOGANDO then
			if pr_state = 0 then
				for i in 0 to 3 loop
					sig_pos_consumidas(i) <= -1;
					if verificou_aumentou_tamanho_signal(i) = '1' then
						sig_colisao_boa(i) 	 <= '0';
					end if;
				end loop;
			elsif pr_state = 1 then
				for i in 0 to FOOD_ARRAY_SIZE loop
					if sig_pos_x_cobras(0)(0) = sig_vetor_x_food(i) and sig_pos_y_cobras(0)(0) = sig_vetor_y_food(i) and 
						sig_vetor_x_food(i) /= 0 and sig_vetor_y_food(i) /= 0 then
						sig_colisao_boa(0) <= '1';
						sig_pos_consumidas(0) <= i;
					end if;
				end loop;
			elsif pr_state = 2 then
				for i in 0 to FOOD_ARRAY_SIZE loop
					if sig_pos_x_cobras(1)(0) = sig_vetor_x_food(i) and sig_pos_y_cobras(1)(0) = sig_vetor_y_food(i) and 
						sig_vetor_x_food(i) /= 0 and sig_vetor_y_food(i) /= 0 then
						sig_colisao_boa(1) <= '1';
						if sig_pos_consumidas(0) < i then
							sig_pos_consumidas(1) <= sig_pos_consumidas(0);
							sig_pos_consumidas(0) <= i;
						else
							sig_pos_consumidas(1) <= i;
						end if;
					end if;
				end loop;
			elsif pr_state = 3 then
				for i in 0 to FOOD_ARRAY_SIZE loop
					if sig_pos_x_cobras(2)(0) = sig_vetor_x_food(i) and sig_pos_y_cobras(2)(0) = sig_vetor_y_food(i) and 
						sig_vetor_x_food(i) /= 0 and sig_vetor_y_food(i) /= 0 then
						sig_colisao_boa(2) <= '1';
						if sig_pos_consumidas(0) < i then
							sig_pos_consumidas(2) <= sig_pos_consumidas(1);
							sig_pos_consumidas(1) <= sig_pos_consumidas(0);
							sig_pos_consumidas(0) <= i;
						elsif sig_pos_consumidas(1) < i then
							sig_pos_consumidas(2) <= sig_pos_consumidas(0);
							sig_pos_consumidas(1) <= i;
						else
							sig_pos_consumidas(2) <= i;
						end if;
					end if;
				end loop;
			elsif pr_state = 4 then
				for i in 0 to FOOD_ARRAY_SIZE loop
					if sig_pos_x_cobras(3)(0) = sig_vetor_x_food(i) and sig_pos_y_cobras(3)(0) = sig_vetor_y_food(i) and 
						sig_vetor_x_food(i) /= 0 and sig_vetor_y_food(i) /= 0 then
						sig_colisao_boa(3) <= '1';
						if sig_pos_consumidas(0) < i then
							sig_pos_consumidas(3) <= sig_pos_consumidas(2);
							sig_pos_consumidas(2) <= sig_pos_consumidas(1);
							sig_pos_consumidas(1) <= sig_pos_consumidas(0);
							sig_pos_consumidas(0) <= i;
						elsif sig_pos_consumidas(1) < i then
							sig_pos_consumidas(3) <= sig_pos_consumidas(2);
							sig_pos_consumidas(2) <= sig_pos_consumidas(1);
							sig_pos_consumidas(1) <= i;
						elsif	sig_pos_consumidas(2) < i then
							sig_pos_consumidas(3) <= sig_pos_consumidas(2);
							sig_pos_consumidas(2) <= i;
						else
							sig_pos_consumidas(3) <= i;
						end if;
					end if;
				end loop;
			end if;
		end if;
	end process colisao_comida_process;

	maquina_estados1:
	process(clk)
	begin
		if rst = '1' then 
			pr_state <= 0;
		elsif rising_edge(clk) then
			pr_state <= nx_state;
		end if;
	end process maquina_estados1;
	
	maquina_estados2:
	process(clk)
	begin
		case(pr_state) is
			when 0 =>
				nx_state <= 1;
			when 1 =>
				nx_state <= 2;
			when 2 =>
				nx_state <= 3;
			when 3 =>
				nx_state <= 4;
			when 4 =>
				nx_state <= 5;
			when 5 =>
				nx_state <= 0;
		end case;
	end process maquina_estados2;
END ARCHITECTURE;