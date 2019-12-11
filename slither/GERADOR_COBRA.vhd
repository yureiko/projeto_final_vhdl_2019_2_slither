library ieee;
USE ieee.std_logic_1164.all;
library work;
USE work.comum.all;
ENTITY GERADOR_COBRA is
	port(	Tick : IN std_logic;	--Sinal de entrada: tick
			pos_cobra_x_blue 		: out natural RANGE 1 TO 62;
			pos_cobra_y_blue 		: out natural RANGE 1 TO 46;
			pos_cobra_x_green 	: out natural RANGE 1 TO 62;
			pos_cobra_y_green 	: out natural RANGE 1 TO 46;
			pos_cobra_x_yellow 	: out natural RANGE 1 TO 62;
			pos_cobra_y_yellow 	: out natural RANGE 1 TO 46;
			pos_cobra_x_pink 		: out natural RANGE 1 TO 62;
			pos_cobra_y_pink 		: out natural RANGE 1 TO 46
			);--Sinais de saida: posicao x e y das comidas
END ENTITY;
ARCHITECTURE arq_GERADOR_COBRA of GERADOR_COBRA is
	
	TYPE NAT_ARRAY is array (natural range <>) of natural;--instaciamento do vetor de inteiros (30 posicoes,0-29)
	
	SIGNAL NAT_ARRAY_X : NAT_ARRAY (0 TO 60);--vetor de inteiros para posicao x
	SIGNAL NAT_ARRAY_Y : NAT_ARRAY (0 TO 44);--vetor de inteiros para posicao y
	
	SIGNAL POS_X_BLUE 	: natural RANGE 1 TO 62:= 1;
	SIGNAL POS_Y_BLUE 	: natural RANGE 1 TO 46:= 11;
	SIGNAL POS_X_GREEN 	: natural RANGE 1 TO 62:= 1;
	SIGNAL POS_Y_GREEN 	: natural RANGE 1 TO 46:= 12;
	SIGNAL POS_X_YELLOW 	: natural RANGE 1 TO 62:= 15;
	SIGNAL POS_Y_YELLOW 	: natural RANGE 1 TO 46:= 42;
	SIGNAL POS_X_PINK 	: natural RANGE 1 TO 62:= 30;
	SIGNAL POS_Y_PINK 	: natural RANGE 1 TO 46:= 26;
	
	begin
		NAT_ARRAY_X <= (35,59,60,12,21,44,43,49,29,
							57,27,38,34,16,58,19,28,1,
							15,23,11,32,42,52,36,39,56,
							37,17,51,33,55,45,53,54,5 ,
							6 ,9 ,18,8 ,10,2 ,47,7 ,48,
							3 ,50,31,30,4 ,24,13,61,14,
							20,26,25,22,41,40,46);	--declaracao de valores para posicoes X
							
		NAT_ARRAY_Y <= (4 ,3 ,13,19,33,38,30,41,18,
							 1,25,26,16,11,32,21,31,36,
							 17,42,29,5 ,20,23,14,40,12,
							 28,35,45,24,7 ,34,44,15,37,
							 22,8 ,2 ,27,10,6 ,9 ,43,39);	--declaracao de valores para posicoes Y
	
		pos_cobra_x_blue 		<= POS_X_BLUE;
		pos_cobra_y_blue 		<= POS_Y_BLUE;
		pos_cobra_x_green 	<= POS_X_GREEN;
		pos_cobra_y_green 	<= POS_Y_GREEN;
		pos_cobra_x_yellow 	<= POS_X_YELLOW;
		pos_cobra_y_yellow 	<= POS_Y_YELLOW;
		pos_cobra_x_pink 		<= POS_X_PINK;
		pos_cobra_y_pink 		<= POS_Y_PINK;
		
	PROCESS(Tick)
		
		VARIABLE counter_X_blue 	: natural RANGE 0 TO 60 := 1;
		VARIABLE counter_Y_blue 	: natural RANGE 0 TO 44 := 1;
		VARIABLE counter_X_green 	: natural RANGE 0 TO 60 := 15;
		VARIABLE counter_Y_green 	: natural RANGE 0 TO 44 := 15;
		VARIABLE counter_X_yellow 	: natural RANGE 0 TO 60 := 30;
		VARIABLE counter_Y_yellow 	: natural RANGE 0 TO 44 := 30;
		VARIABLE counter_X_pink 	: natural RANGE 0 TO 60 := 50;
		VARIABLE counter_Y_pink 	: natural RANGE 0 TO 44 := 40;	
		
		BEGIN
		IF rising_edge(Tick) THEN		
			counter_x_blue 	:= counter_x_blue + 1;	
			counter_y_blue 	:= counter_y_blue + 1;
			counter_x_green 	:= counter_x_green + 1;	
			counter_y_green 	:= counter_y_green + 1;
			counter_x_yellow 	:= counter_x_yellow + 1;	
			counter_y_yellow 	:= counter_y_yellow + 1;
			counter_x_pink 	:= counter_x_pink + 1;	
			counter_y_pink 	:= counter_y_pink + 1;
	
			POS_X_BLUE 		<= NAT_ARRAY_X(counter_x_blue);	
			POS_Y_BLUE 		<= NAT_ARRAY_Y(counter_y_blue);
			POS_X_GREEN 	<= NAT_ARRAY_X(counter_x_green);	
			POS_Y_GREEN 	<= NAT_ARRAY_Y(counter_y_green);
			POS_X_YELLOW 	<= NAT_ARRAY_X(counter_x_yellow);	
			POS_Y_YELLOW 	<= NAT_ARRAY_Y(counter_y_yellow);
			POS_X_PINK 		<= NAT_ARRAY_X(counter_x_pink);	
			POS_Y_PINK 		<= NAT_ARRAY_Y(counter_y_pink);
			IF counter_x_blue>59 THEN	
				counter_x_blue := 0;	
			END IF;
			IF counter_y_blue>43 THEN	
				counter_y_blue := 0;	
			END IF;
			IF counter_x_green>59 THEN	
				counter_x_green := 0;	
			END IF;
			IF counter_y_green>43 THEN	
				counter_y_green := 0;	
			END IF;
			IF counter_x_yellow>59 THEN	
				counter_x_yellow := 0;	
			END IF;
			IF counter_y_yellow>43 THEN	
				counter_y_yellow := 0;	
			END IF;
			IF counter_x_pink>59 THEN	
				counter_x_pink := 0;	
			END IF;
			IF counter_y_pink>43 THEN	
				counter_y_pink := 0;	
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE;