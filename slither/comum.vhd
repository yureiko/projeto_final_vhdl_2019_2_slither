LIBRARY ieee;
USE ieee.std_logic_1164.all;

package comum is
	
	CONSTANT MAX_SNAKE_LENGTH	: NATURAL 	:= 14;												--maximo comprimento da cobra
	CONSTANT INITIAL_LIVES		: NATURAL	:= 3;													--vidas iniciais
	CONSTANT INITIAL_LENGTH		: NATURAL	:= 2;													--comprimento inicial da cobra
	CONSTANT SIZE_DEAD			: NATURAL 	:= 3;													--quantas comidas a cobra gera quando morre
	CONSTANT MAX_FOOD				: NATURAL 	:= 15;												--maxima comida gerada aleatoriamente
	
	CONSTANT	X_RESOLUTION		: NATURAL 	:= 64;
	CONSTANT	Y_RESOLUTION		: NATURAL 	:= 48;
	
	CONSTANT X_LEFT_CORNER		: NATURAL   := 0;
	CONSTANT X_RIGHT_CORNER		: NATURAL 	:=	X_RESOLUTION-1;
	CONSTANT Y_UP_CORNER			: NATURAL	:= 0;
	CONSTANT Y_DOWN_CORNER		: NATURAL   := Y_RESOLUTION-1;
	
	CONSTANT FOOD_ARRAY_SIZE	: NATURAL 	:=(MAX_FOOD + (MAX_SNAKE_LENGTH)) - 1;	--tamanho total do vetor de comidas
	CONSTANT TIMETICK_MS			: NATURAL   := 100;
	
   TYPE ESTADO_COBRA IS (PARADA, MORREU, ESQUERDA, DIREITA, SUBINDO, DESCENDO, DESAPARECE );
	TYPE ESTADO IS(ESPERANDO , JOGANDO, ACABOU);
	
	TYPE posicao_X_type IS ARRAY(MAX_SNAKE_LENGTH-1 DOWNTO 0) OF NATURAL RANGE 0 TO X_RESOLUTION; 
	TYPE posicao_Y_type IS ARRAY(MAX_SNAKE_LENGTH-1 DOWNTO 0) OF NATURAL RANGE 0 TO Y_RESOLUTION;
	
	TYPE FOOD_ARRAY_X_TYPE is array (FOOD_ARRAY_SIZE downto 0) OF NATURAL RANGE 0 TO X_RESOLUTION-1; 
	TYPE FOOD_ARRAY_Y_TYPE is array (FOOD_ARRAY_SIZE downto 0) OF NATURAL RANGE 0 TO Y_RESOLUTION-1;
	
	type telaInicialX is array (244 downto 0) of integer range 0 to X_RESOLUTION-1;
	type telaInicialY is array (244 downto 0) of integer range 0 to Y_RESOLUTION-1;

	type telaFinalX is array (119 downto 0) of integer range 0 to X_RESOLUTION-1;
	type telaFinalY is array (119 downto 0) of integer range 0 to Y_RESOLUTION-1;	
	
	TYPE FOOD_INDEX_REMOVE is array(FOOD_ARRAY_SIZE downto 0) of integer range -1 to FOOD_ARRAY_SIZE;
	
	TYPE POSICAO_X_COMIDAS_TYPE is array (3 downto 0) OF NATURAL RANGE 0 TO X_RESOLUTION-1;
	TYPE POSICAO_Y_COMIDAS_TYPE is array (3 downto 0) OF NATURAL RANGE 0 TO Y_RESOLUTION-1;	
	
	TYPE FOODS_POSITION is array (3 downto 0) of integer range -1 to FOOD_ARRAY_SIZE;
	
end package comum;
