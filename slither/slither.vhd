LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
LIBRARY work;
USE work.comum.all;

----------------------
ENTITY slither IS 
	PORT (
				  clk: 					IN STD_LOGIC; --ok 				
				  rst:	 				IN STD_LOGIC;	--ok
				  
				  -- BOTOES DE MOVIMENTAÇÃO
				  bot_start_blue:		IN STD_LOGIC; --ok
				  bot_mov_blue:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- bit0 para direita, bit1 para cima, bit2 para esquerda e bit3 para baixo --k
				  bot_start_green:	IN STD_LOGIC; --ok
				  bot_mov_green:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- bit0 para direita, bit1 para cima, bit2 para esquerda e bit3 para baixo --k
				  bot_start_yellow:	IN STD_LOGIC; --ok
				  bot_mov_yellow:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- bit0 para direita, bit1 para cima, bit2 para esquerda e bit3 para baixo --k
				  bot_start_pink:		IN STD_LOGIC; --ok
				  bot_mov_pink:		IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- bit0 para direita, bit1 para cima, bit2 para esquerda e bit3 para baixo --k
				  
				  -- LEDS DE ESTADO
				  led1 : out std_logic;
				  led2 : out std_logic;
				  led3 : out std_logic;
					
				  -- 7-SEG DE VIDAS
				  saida_lcd_blue		: out std_logic_vector(6 downto 0);
				  saida_lcd_green		: out std_logic_vector(6 downto 0);
				  saida_lcd_yellow	: out std_logic_vector(6 downto 0);
				  saida_lcd_pink		: out std_logic_vector(6 downto 0);
				  
					-- Modulo VGA
					red, green, blue 				: out std_logic_vector (3 downto 0);
					Hsync, Vsync     				: out std_logic
			);
END ENTITY;

ARCHITECTURE arch OF slither IS 

	-- Signals
	signal size_p1, size_p2, size_p3, size_p4				: natural range INITIAL_LENGTH to MAX_SNAKE_LENGTH;
	signal x_tela_inicial : telaInicialX;
	signal y_tela_inicial : telaInicialY;
	signal x_tela_final : telaFinalX;
	signal y_tela_final : telaFinalY;
	SIGNAL EstadoCobraBlue: ESTADO_COBRA;
	SIGNAL EstadoCobraGreen: ESTADO_COBRA;
	SIGNAL EstadoCobraYellow: ESTADO_COBRA;
	SIGNAL EstadoCobraPink: ESTADO_COBRA;
	SIGNAL MORREU_Blue: STD_LOGIC;
	SIGNAL MORREU_Green: STD_LOGIC;
	SIGNAL MORREU_Yellow: STD_LOGIC;
	SIGNAL MORREU_Pink: STD_LOGIC;
	SIGNAL VIDAS_Blue:  NATURAL RANGE 0 TO INITIAL_LIVES;
	SIGNAL VIDAS_Green:  NATURAL RANGE 0 TO INITIAL_LIVES;
	SIGNAL VIDAS_Yellow:  NATURAL RANGE 0 TO INITIAL_LIVES;
	SIGNAL VIDAS_Pink:  NATURAL RANGE 0 TO INITIAL_LIVES;
	signal pos_aleatoria_x_blue: natural RANGE 1 TO 63;
	signal pos_aleatoria_y_blue: natural RANGE 1 TO 47;
	signal pos_aleatoria_x_green: natural RANGE 1 TO 63;
	signal pos_aleatoria_y_green: natural RANGE 1 TO 47;
	signal pos_aleatoria_x_yellow: natural RANGE 1 TO 63;
	signal pos_aleatoria_y_yellow: natural RANGE 1 TO 47;
	signal pos_aleatoria_x_pink: natural RANGE 1 TO 63;
	signal pos_aleatoria_y_pink: natural RANGE 1 TO 47;
	signal tick: std_logic;
	signal estado_jogo : ESTADO := ESPERANDO;
	signal POS_X_COBRA_BLUE : posicao_X_type;
	signal POS_Y_COBRA_BLUE : posicao_Y_type;
	signal POS_X_COBRA_GREEN : posicao_X_type;
	signal POS_Y_COBRA_GREEN : posicao_Y_type;
	signal POS_X_COBRA_YELLOW : posicao_X_type;
	signal POS_Y_COBRA_YELLOW : posicao_Y_type;
	signal POS_X_COBRA_PINK : posicao_X_type;
	signal POS_Y_COBRA_PINK : posicao_Y_type;
	signal TAMANHOBLUE : NATURAL RANGE 0 TO MAX_SNAKE_LENGTH;
	signal TAMANHOGREEN : NATURAL RANGE 0 TO MAX_SNAKE_LENGTH;
	signal TAMANHOYELLOW : NATURAL RANGE 0 TO MAX_SNAKE_LENGTH;
	signal TAMANHOPINK : NATURAL RANGE 0 TO MAX_SNAKE_LENGTH;
	signal new_food_position_x :  natural range 0 to X_RESOLUTION -1;
	signal new_food_position_y :  natural range 0 to Y_RESOLUTION -1;
	signal clear_food_position : FOODS_POSITION;
	signal food_array_out_x : FOOD_ARRAY_X_TYPE;
	signal food_array_out_y : FOOD_ARRAY_Y_TYPE;
	signal food_index : natural range 0 to FOOD_ARRAY_SIZE;
	signal perdeu_vida_blue : STD_LOGIC := '0';
	signal perdeu_vida_green : STD_LOGIC := '0';
	signal perdeu_vida_yellow : STD_LOGIC := '0';
	signal perdeu_vida_pink : STD_LOGIC := '0';
	signal aumentaBlue : std_logic := '0';
	signal aumentaGreen : std_logic := '0';
	signal aumentaYellow : std_logic := '0';
	signal aumentaPink : std_logic := '0';
	signal posicao_x_morte_blue : posicao_X_type;
	signal posicao_y_morte_blue : posicao_Y_type;
	signal posicao_x_morte_green : posicao_X_type;
	signal posicao_y_morte_green : posicao_Y_type;
	signal posicao_x_morte_yellow : posicao_X_type;
	signal posicao_y_morte_yellow : posicao_Y_type;
	signal posicao_x_morte_pink : posicao_X_type;
	signal posicao_y_morte_pink : posicao_Y_type;
	signal vira_comida_blue : STD_LOGIC;
	signal vira_comida_green : STD_LOGIC;
	signal vira_comida_yellow : STD_LOGIC;
	signal vira_comida_pink : STD_LOGIC;
	signal verificou_aumentou_tamanho_blue : STD_LOGIC;
	signal verificou_aumentou_tamanho_green : STD_LOGIC;
	signal verificou_aumentou_tamanho_yellow : STD_LOGIC;
	signal verificou_aumentou_tamanho_pink : STD_LOGIC;
	signal bot_mov_blue_processado : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal bot_mov_green_processado : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal bot_mov_yellow_processado : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal bot_mov_pink_processado : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	BEGIN
	
	--TELA INICIAL
	x_tela_inicial(0) <= 18;
	x_tela_inicial(1) <= 19;
	x_tela_inicial(2) <= 20;
	x_tela_inicial(3) <= 22;
	x_tela_inicial(4) <= 27;
	x_tela_inicial(5) <= 28;
	x_tela_inicial(6) <= 29;
	x_tela_inicial(7) <= 31;
	x_tela_inicial(8) <= 32;
	x_tela_inicial(9) <= 33;
	x_tela_inicial(10) <= 34;
	x_tela_inicial(11) <= 35;
	x_tela_inicial(12) <= 37;
	x_tela_inicial(13) <= 40;
	x_tela_inicial(14) <= 42;
	x_tela_inicial(15) <= 43;
	x_tela_inicial(16) <= 44;
	x_tela_inicial(17) <= 45;
	x_tela_inicial(18) <= 47;
	x_tela_inicial(19) <= 48;
	x_tela_inicial(20) <= 49;
	
LINHA6 : FOR i in 0 to 20 generate
   y_tela_inicial(i) <= 6;						
end generate LINHA6;

	x_tela_inicial(21) <= 17;
	x_tela_inicial(22) <= 22;
	x_tela_inicial(23) <= 28;
	x_tela_inicial(24) <= 33;
	x_tela_inicial(25) <= 37;
	x_tela_inicial(26) <= 40;
	x_tela_inicial(27) <= 42;
	x_tela_inicial(28) <= 47;
	x_tela_inicial(29) <= 50;
	
LINHA7 : FOR i in 21 to 29 generate
   y_tela_inicial(i) <= 7;						
end generate LINHA7;
	
	x_tela_inicial(30) <= 18;
	x_tela_inicial(31) <= 19;
	x_tela_inicial(32) <= 22;
	x_tela_inicial(33) <= 28;
	x_tela_inicial(34) <= 33;
	x_tela_inicial(35) <= 37;
	x_tela_inicial(36) <= 38;
	x_tela_inicial(37) <= 39;
	x_tela_inicial(38) <= 40;
	x_tela_inicial(39) <= 42;
	x_tela_inicial(40) <= 43;
	x_tela_inicial(41) <= 44;
	x_tela_inicial(42) <= 47;
	x_tela_inicial(43) <= 48;
	x_tela_inicial(44) <= 49;
	
LINHA8 : FOR i in 30 to 44 generate
   y_tela_inicial(i) <= 8;						
end generate LINHA8;

	x_tela_inicial(45) <= 20;
	x_tela_inicial(46) <= 22;
	x_tela_inicial(47) <= 28;
	x_tela_inicial(48) <= 33;
	x_tela_inicial(49) <= 37;
	x_tela_inicial(50) <= 40;
	x_tela_inicial(51) <= 42;
	x_tela_inicial(52) <= 47;
	x_tela_inicial(53) <= 49;
	
LINHA9 : FOR i in 45 to 53 generate
   y_tela_inicial(i) <= 9;						
end generate LINHA9;

	x_tela_inicial(54) <= 17;
	x_tela_inicial(55) <= 18;
	x_tela_inicial(56) <= 19;
	x_tela_inicial(57) <= 22;
	x_tela_inicial(58) <= 23;
	x_tela_inicial(59) <= 24;
	x_tela_inicial(60) <= 25;
	x_tela_inicial(61) <= 27;
	x_tela_inicial(62) <= 28;
	x_tela_inicial(63) <= 29;
	x_tela_inicial(64) <= 33;
	x_tela_inicial(65) <= 37;
	x_tela_inicial(66) <= 40;
	x_tela_inicial(67) <= 42;
	x_tela_inicial(68) <= 43;
	x_tela_inicial(69) <= 44;
	x_tela_inicial(70) <= 45;
	x_tela_inicial(71) <= 47;
	x_tela_inicial(72) <= 50;
	
LINHA10 : FOR i in 54 to 72 generate
   y_tela_inicial(i) <= 10;						
end generate LINHA10;

	x_tela_inicial(73) <= 47;
	x_tela_inicial(74) <= 48;
	x_tela_inicial(75) <= 49;
	
LINHA14 : FOR i in 73 to 75 generate
   y_tela_inicial(i) <= 14;						
end generate LINHA14;

	x_tela_inicial(76) <= 46;
	x_tela_inicial(77) <= 47;
	x_tela_inicial(78) <= 48;
	x_tela_inicial(79) <= 50;
	
LINHA15 : FOR i in 76 to 79 generate
   y_tela_inicial(i) <= 15;						
end generate LINHA15;

	x_tela_inicial(80) <= 45;
	x_tela_inicial(81) <= 46;
	x_tela_inicial(82) <= 47;
	x_tela_inicial(83) <= 48;
	x_tela_inicial(84) <= 49;
	x_tela_inicial(85) <= 50;
	x_tela_inicial(86) <= 51;
	
LINHA16 : FOR i in 80 to 86 generate
   y_tela_inicial(i) <= 16;						
end generate LINHA16;

	x_tela_inicial(87) <= 45;
	x_tela_inicial(88) <= 46;
	x_tela_inicial(89) <= 47;
	x_tela_inicial(90) <= 48;
	x_tela_inicial(91) <= 49;
	x_tela_inicial(92) <= 50;
	x_tela_inicial(93) <= 51;
	
LINHA17 : FOR i in 87 to 93 generate
   y_tela_inicial(i) <= 17;						
end generate LINHA17;

	x_tela_inicial(94) <= 21;
	x_tela_inicial(95) <= 22;
	x_tela_inicial(96) <= 23;
	x_tela_inicial(97) <= 24;
	x_tela_inicial(98) <= 31;
	x_tela_inicial(99) <= 32;
	x_tela_inicial(100) <= 33;
	x_tela_inicial(101) <= 34;
	x_tela_inicial(102) <= 35;
	x_tela_inicial(103) <= 36;
	x_tela_inicial(104) <= 44;
	x_tela_inicial(105) <= 45;
	x_tela_inicial(106) <= 46;
	x_tela_inicial(107) <= 47;
	
LINHA18 : FOR i in 94 to 107 generate
   y_tela_inicial(i) <= 18;						
end generate LINHA18;

	x_tela_inicial(108) <= 21;
	x_tela_inicial(109) <= 24;
	x_tela_inicial(110) <= 25;
	x_tela_inicial(111) <= 30;
	x_tela_inicial(112) <= 31;
	x_tela_inicial(113) <= 36;
	x_tela_inicial(114) <= 37;
	x_tela_inicial(115) <= 42;
	x_tela_inicial(116) <= 43;
	x_tela_inicial(117) <= 46;
	x_tela_inicial(118) <= 47;
	x_tela_inicial(119) <= 51;
	
LINHA19 : FOR i in 108 to 119 generate
   y_tela_inicial(i) <= 19;						
end generate LINHA19;

	x_tela_inicial(120) <= 20;
	x_tela_inicial(121) <= 25;
	x_tela_inicial(122) <= 26;
	x_tela_inicial(123) <= 27;
	x_tela_inicial(124) <= 29;
	x_tela_inicial(125) <= 30;
	x_tela_inicial(126) <= 37;
	x_tela_inicial(127) <= 38;
	x_tela_inicial(128) <= 41;
	x_tela_inicial(129) <= 42;
	x_tela_inicial(130) <= 46;
	x_tela_inicial(131) <= 47;
	x_tela_inicial(132) <= 48;
	x_tela_inicial(133) <= 49;
	x_tela_inicial(134) <= 50;
	x_tela_inicial(135) <= 51;
	
LINHA20 : FOR i in 120 to 135 generate
   y_tela_inicial(i) <= 20;						
end generate LINHA20;

	x_tela_inicial(136) <= 27;
	x_tela_inicial(137) <= 28;
	x_tela_inicial(138) <= 29;
	x_tela_inicial(139) <= 38;
	x_tela_inicial(140) <= 39;
	x_tela_inicial(141) <= 40;
	x_tela_inicial(142) <= 41;
	
LINHA21 : FOR i in 136 to 142 generate
   y_tela_inicial(i) <= 21;						
end generate LINHA21;

	x_tela_inicial(143) <= 13;
	x_tela_inicial(144) <= 14;
	x_tela_inicial(145) <= 15;
	x_tela_inicial(146) <= 17;
	x_tela_inicial(147) <= 18;
	x_tela_inicial(148) <= 19;
	x_tela_inicial(149) <= 21;
	x_tela_inicial(150) <= 22;
	x_tela_inicial(151) <= 23;
	x_tela_inicial(152) <= 25;
	x_tela_inicial(153) <= 26;
	x_tela_inicial(154) <= 27;
	x_tela_inicial(155) <= 29;
	x_tela_inicial(156) <= 30;
	x_tela_inicial(157) <= 31;
	x_tela_inicial(158) <= 37;
	x_tela_inicial(159) <= 38;
	x_tela_inicial(160) <= 39;
	x_tela_inicial(161) <= 41;
	x_tela_inicial(162) <= 42;
	x_tela_inicial(163) <= 43;
	x_tela_inicial(164) <= 45;
	x_tela_inicial(165) <= 46;
	x_tela_inicial(166) <= 47;
	x_tela_inicial(167) <= 49;
	x_tela_inicial(168) <= 50;
	x_tela_inicial(169) <= 51;
	x_tela_inicial(170) <= 53;
	x_tela_inicial(171) <= 54;
	x_tela_inicial(172) <= 55;
	
LINHA29 : FOR i in 143 to 172 generate
   y_tela_inicial(i) <= 29;						
end generate LINHA29;

	x_tela_inicial(173) <= 13;
	x_tela_inicial(174) <= 15;
	x_tela_inicial(175) <= 17;
	x_tela_inicial(176) <= 19;
	x_tela_inicial(177) <= 21;
	x_tela_inicial(178) <= 25;
	x_tela_inicial(179) <= 29;
	x_tela_inicial(180) <= 37;
	x_tela_inicial(181) <= 42;
	x_tela_inicial(182) <= 45;
	x_tela_inicial(183) <= 47;
	x_tela_inicial(184) <= 49;
	x_tela_inicial(185) <= 51;
	x_tela_inicial(186) <= 54;

LINHA30 : FOR i in 173 to 186 generate
   y_tela_inicial(i) <= 30;						
end generate LINHA30;

	x_tela_inicial(187) <= 13;
	x_tela_inicial(188) <= 14;
	x_tela_inicial(189) <= 15;
	x_tela_inicial(190) <= 17;
	x_tela_inicial(191) <= 18;
	x_tela_inicial(192) <= 21;
	x_tela_inicial(193) <= 22;
	x_tela_inicial(194) <= 25;
	x_tela_inicial(195) <= 26;
	x_tela_inicial(196) <= 27;
	x_tela_inicial(197) <= 29;
	x_tela_inicial(198) <= 30;
	x_tela_inicial(199) <= 31;
	x_tela_inicial(200) <= 37;
	x_tela_inicial(201) <= 38;
	x_tela_inicial(202) <= 39;
	x_tela_inicial(203) <= 42;
	x_tela_inicial(204) <= 45;
	x_tela_inicial(205) <= 46;
	x_tela_inicial(206) <= 47;
	x_tela_inicial(207) <= 49;
	x_tela_inicial(208) <= 50;
	x_tela_inicial(209) <= 54;
	
LINHA31 : FOR i in 187 to 209 generate
   y_tela_inicial(i) <= 31;						
end generate LINHA31;

	x_tela_inicial(210) <= 13;
	x_tela_inicial(211) <= 17;
	x_tela_inicial(212) <= 19;
	x_tela_inicial(213) <= 21;
	x_tela_inicial(214) <= 27;
	x_tela_inicial(215) <= 31;
	x_tela_inicial(216) <= 39;
	x_tela_inicial(217) <= 42;
	x_tela_inicial(218) <= 45;
	x_tela_inicial(219) <= 47;
	x_tela_inicial(220) <= 49;
	x_tela_inicial(221) <= 51;
	x_tela_inicial(222) <= 54;

LINHA32 : FOR i in 210 to 222 generate
   y_tela_inicial(i) <= 32;						
end generate LINHA32;

	x_tela_inicial(223) <= 13;
	x_tela_inicial(224) <= 17;
	x_tela_inicial(225) <= 19;
	x_tela_inicial(226) <= 21;
	x_tela_inicial(227) <= 22;
	x_tela_inicial(228) <= 23;
	x_tela_inicial(229) <= 25;
	x_tela_inicial(230) <= 26;
	x_tela_inicial(231) <= 27;
	x_tela_inicial(232) <= 29;
	x_tela_inicial(233) <= 30;
	x_tela_inicial(234) <= 31;
	x_tela_inicial(235) <= 37;
	x_tela_inicial(236) <= 38;
	x_tela_inicial(237) <= 39;
	x_tela_inicial(238) <= 42;
	x_tela_inicial(239) <= 45;
	x_tela_inicial(240) <= 47;
	x_tela_inicial(241) <= 49;
	x_tela_inicial(242) <= 51;
	x_tela_inicial(243) <= 54;
	
LINHA33 : FOR i in 223 to 243 generate
   y_tela_inicial(i) <= 33;						
end generate LINHA33;

	--tela final
	
	x_tela_final(0) <= 13;
	x_tela_final(1) <= 14;
	x_tela_final(2) <= 15;
	x_tela_final(3) <= 16;
	x_tela_final(4) <= 17;
	x_tela_final(5) <= 18;
	x_tela_final(6) <= 19;
	x_tela_final(7) <= 20;
	x_tela_final(8) <= 21;
	x_tela_final(9) <= 22;
	x_tela_final(10) <= 23;
	x_tela_final(11) <= 24;
	x_tela_final(12) <= 29;
	x_tela_final(13) <= 35;
	x_tela_final(14) <= 53;
FIM_LINHA10 : FOR i in 0 to 14 generate
   y_tela_final(i) <= 10;						
end generate FIM_LINHA10;

	x_tela_final(15) <= 13;
	x_tela_final(16) <= 29;
	x_tela_final(17) <= 35;
	x_tela_final(18) <= 36;
	x_tela_final(19) <= 52;
	x_tela_final(20) <= 53;
FIM_LINHA11 : FOR i in 15 to 20 generate
   y_tela_final(i) <= 11;						
end generate FIM_LINHA11;

	x_tela_final(21) <= 13;
	x_tela_final(22) <= 29;
	x_tela_final(23) <= 35;
	x_tela_final(24) <= 37;
	x_tela_final(25) <= 51;
	x_tela_final(26) <= 53;
FIM_LINHA12 : FOR i in 21 to 26 generate
   y_tela_final(i) <= 12;						
end generate FIM_LINHA12;

	x_tela_final(27) <= 13;
	x_tela_final(28) <= 29;
	x_tela_final(29) <= 35;
	x_tela_final(30) <= 38;
	x_tela_final(31) <= 50;
	x_tela_final(32) <= 53;
FIM_LINHA13 : FOR i in 27 to 32 generate
   y_tela_final(i) <= 13;						
end generate FIM_LINHA13;

	x_tela_final(33) <= 13;
	x_tela_final(34) <= 29;
	x_tela_final(35) <= 35;
	x_tela_final(36) <= 39;
	x_tela_final(37) <= 49;
	x_tela_final(38) <= 53;
FIM_LINHA14 : FOR i in 33 to 38 generate
   y_tela_final(i) <= 14;						
end generate FIM_LINHA14;

	x_tela_final(39) <= 13;
	x_tela_final(40) <= 29;
	x_tela_final(41) <= 35;
	x_tela_final(42) <= 40;
	x_tela_final(43) <= 48;
	x_tela_final(44) <= 53;
FIM_LINHA15 : FOR i in 39 to 44 generate
   y_tela_final(i) <= 15;						
end generate FIM_LINHA15;

	x_tela_final(45) <= 13;
	x_tela_final(46) <= 29;
	x_tela_final(47) <= 35;
	x_tela_final(48) <= 41;
	x_tela_final(49) <= 47;
	x_tela_final(50) <= 53;
FIM_LINHA16 : FOR i in 45 to 50 generate
   y_tela_final(i) <= 16;						
end generate FIM_LINHA16;

	x_tela_final(51) <= 13;
	x_tela_final(52) <= 29;
	x_tela_final(53) <= 35;
	x_tela_final(54) <= 42;
	x_tela_final(55) <= 46;
	x_tela_final(56) <= 53;
FIM_LINHA17 : FOR i in 51 to 56 generate
   y_tela_final(i) <= 17;						
end generate FIM_LINHA17;

	x_tela_final(57) <= 13;
	x_tela_final(58) <= 29;
	x_tela_final(59) <= 35;
	x_tela_final(60) <= 43;
	x_tela_final(61) <= 45;
	x_tela_final(62) <= 53;
FIM_LINHA18 : FOR i in 57 to 62 generate
   y_tela_final(i) <= 18;						
end generate FIM_LINHA18;

	x_tela_final(63) <= 13;
	x_tela_final(64) <= 29;
	x_tela_final(65) <= 35;
	x_tela_final(66) <= 44;
	x_tela_final(67) <= 53;
FIM_LINHA19 : FOR i in 63 to 67 generate
   y_tela_final(i) <= 19;						
end generate FIM_LINHA19;

	x_tela_final(68) <= 13;
	x_tela_final(69) <= 29;
	x_tela_final(70) <= 35;
	x_tela_final(71) <= 53;
FIM_LINHA20 : FOR i in 68 to 71 generate
   y_tela_final(i) <= 20;						
end generate FIM_LINHA20;

	x_tela_final(72) <= 13;
	x_tela_final(73) <= 14;
	x_tela_final(74) <= 15;
	x_tela_final(75) <= 16;
	x_tela_final(76) <= 17;
	x_tela_final(77) <= 29;
	x_tela_final(78) <= 35;
	x_tela_final(79) <= 53;
FIM_LINHA21 : FOR i in 72 to 79 generate
   y_tela_final(i) <= 21;						
end generate FIM_LINHA21;

	x_tela_final(80) <= 13;
	x_tela_final(81) <= 29;
	x_tela_final(82) <= 35;
	x_tela_final(83) <= 53;
FIM_LINHA22 : FOR i in 80 to 83 generate
   y_tela_final(i) <= 22;						
end generate FIM_LINHA22;

	x_tela_final(84) <= 13;
	x_tela_final(85) <= 29;
	x_tela_final(86) <= 35;
	x_tela_final(87) <= 53;
FIM_LINHA23 : FOR i in 84 to 87 generate
   y_tela_final(i) <= 23;						
end generate FIM_LINHA23;

	x_tela_final(88) <= 13;
	x_tela_final(89) <= 29;
	x_tela_final(90) <= 35;
	x_tela_final(91) <= 53;
FIM_LINHA24 : FOR i in 88 to 91 generate
   y_tela_final(i) <= 24;						
end generate FIM_LINHA24;

	x_tela_final(92) <= 13;
	x_tela_final(93) <= 29;
	x_tela_final(94) <= 35;
	x_tela_final(95) <= 53;
FIM_LINHA25 : FOR i in 92 to 95 generate
   y_tela_final(i) <= 25;						
end generate FIM_LINHA25;

	x_tela_final(96) <= 13;
	x_tela_final(97) <= 29;
	x_tela_final(98) <= 35;
	x_tela_final(99) <= 53;
FIM_LINHA26 : FOR i in 96 to 99 generate
   y_tela_final(i) <= 26;						
end generate FIM_LINHA26;

	x_tela_final(100) <= 13;
	x_tela_final(101) <= 29;
	x_tela_final(102) <= 35;
	x_tela_final(103) <= 53;
FIM_LINHA27 : FOR i in 100 to 103 generate
   y_tela_final(i) <= 27;						
end generate FIM_LINHA27;

	x_tela_final(104) <= 13;
	x_tela_final(105) <= 29;
	x_tela_final(106) <= 35;
	x_tela_final(107) <= 53;
FIM_LINHA28 : FOR i in 104 to 107 generate
   y_tela_final(i) <= 28;						
end generate FIM_LINHA28;

	x_tela_final(108) <= 13;
	x_tela_final(109) <= 29;
	x_tela_final(110) <= 35;
	x_tela_final(111) <= 53;
FIM_LINHA29 : FOR i in 108 to 111 generate
   y_tela_final(i) <= 29;						
end generate FIM_LINHA29;

	x_tela_final(112) <= 13;
	x_tela_final(113) <= 29;
	x_tela_final(114) <= 35;
	x_tela_final(115) <= 53;
FIM_LINHA30 : FOR i in 112 to 115 generate
   y_tela_final(i) <= 30;						
end generate FIM_LINHA30;

	x_tela_final(116) <= 13;
	x_tela_final(117) <= 29;
	x_tela_final(118) <= 35;
	x_tela_final(119) <= 53;
FIM_LINHA31 : FOR i in 116 to 119 generate
   y_tela_final(i) <= 31;						
end generate FIM_LINHA31;

----------------------------------------------------------------------------------------------------------------------------------

	--Controlador de Leds

	led1 <= '1' when  estado_jogo = ESPERANDO else
			  '0';
	led2 <= '1' when  estado_jogo = JOGANDO else
			  '0';
	led3 <= '1' when  estado_jogo = ACABOU else
			  '0';
	
	--ENTIDADES-----------------------------------------------------------------------------------------------------------------
	
	TICK_ENTITY		:	work.gerador_tick port map (  clk => clk,
																	estado_jogo => estado_jogo,
																	tick => tick												
																						); 
																						
	FSM_JOGO_ENTITY	:	work.FSM_jogo port map (
																	clk => clk,
																	rst => rst,
																	EstadoCobraBlue => EstadoCobraBlue,
																	EstadoCobraGreen => EstadoCobraGreen,
																	EstadoCobraYellow => EstadoCobraYellow,
																	EstadoCobraPink => EstadoCobraPink,
																	bot_start_blue => bot_start_blue,
																	bot_start_green => '0',
																	bot_start_yellow => '0',
																	bot_start_pink => '0',
																	estado_jogo => estado_jogo
																											);
																											
	BOTOES_ENTITY : work.BOTOES port map (
															tick => tick,
															bot_mov_blue => bot_mov_blue,
															bot_mov_green => bot_mov_green,
															bot_mov_yellow => bot_mov_yellow,
															bot_mov_pink => bot_mov_pink,
															bot_mov_blue_processado => bot_mov_blue_processado,
															bot_mov_green_processado => bot_mov_green_processado,
															bot_mov_yellow_processado => bot_mov_yellow_processado,
															bot_mov_pink_processado => bot_mov_pink_processado
																												);
	
	GERADOR_COBRA_ENTITY  :  work.GERADOR_COBRA port map (	 		Tick			 => tick,
																						pos_cobra_x_blue 		=> pos_aleatoria_x_blue,
																						pos_cobra_y_blue 		=> pos_aleatoria_y_blue,
																						pos_cobra_x_green 	=> pos_aleatoria_x_green,
																						pos_cobra_y_green 	=> pos_aleatoria_y_green,
																						pos_cobra_x_yellow 	=> pos_aleatoria_x_yellow,
																						pos_cobra_y_yellow	=> pos_aleatoria_y_yellow,
																						pos_cobra_x_pink 		=> pos_aleatoria_x_pink,
																						pos_cobra_y_pink 		=> pos_aleatoria_y_pink
																																			);
																																			
	VIDAS_DISPLAY_ENTITY : work.vidas_display port map (
																			vidas_blue 			=>VIDAS_Blue, 
																			vidas_green 		=>VIDAS_Green,
																			vidas_yellow 		=>VIDAS_Yellow,
																			vidas_pink 			=>VIDAS_Pink,
																			saida_lcd_blue 	=>saida_lcd_blue,
																			saida_lcd_green 	=>saida_lcd_green,
																			saida_lcd_yellow 	=>saida_lcd_yellow,
																			saida_lcd_pink 	=>saida_lcd_pink
	
																						);
	
																		
	COBRA_BLUE_ENTITY :	entity work.cobra 	port map(	clk =>clk,
																			tick =>tick,
																			meu_estado =>EstadoCobraBlue,
																			estado_jogo =>estado_jogo, 
																			aumenta => aumentaBlue,
																			posicao_aleatoria_X =>pos_aleatoria_x_blue,
																			posicao_aleatoria_Y =>pos_aleatoria_y_blue,
																			VIDAS =>VIDAS_Blue,
																			TAMANHO =>TAMANHOBLUE,
																			POSICAO_X =>POS_X_COBRA_BLUE,
																			POSICAO_Y =>POS_Y_COBRA_BLUE,
																			POSICAO_X_morte =>posicao_x_morte_blue,
																			POSICAO_Y_morte =>posicao_y_morte_blue,
																			MORREU_SIGNAL =>MORREU_Blue,
																			VIRA_COMIDA => vira_comida_blue,
																			verificou_aumentou_tamanho => verificou_aumentou_tamanho_blue
																								);
																				
	FSM_COBRA_BLUE_ENTITY 	:	entity work.FSM_cobra 	port map(	clk => clk,
																						rst => rst,
																						verify_morreu => MORREU_Blue,
																						bot_start => bot_start_blue,
																						perdeu_vida => perdeu_vida_blue,
																						bot_mov => bot_mov_blue_processado,
																						VIDAS => VIDAS_Blue,
																						ESTADO_JOGO => estado_jogo,
																						SNAKE_STATE => EstadoCobraBlue
																												);
	
																		
	COBRA_GREEN_ENTITY :	entity work.cobra 	port map(	clk =>clk,
																			tick =>tick,
																			meu_estado =>EstadoCobraGreen,
																			estado_jogo =>estado_jogo, 
																			aumenta => aumentaGreen,
																			posicao_aleatoria_X =>pos_aleatoria_x_green,
																			posicao_aleatoria_Y =>pos_aleatoria_y_green,
																			VIDAS =>VIDAS_Green,
																			TAMANHO =>TAMANHOGREEN,
																			POSICAO_X =>POS_X_COBRA_GREEN,
																			POSICAO_Y =>POS_Y_COBRA_GREEN,
																			POSICAO_X_morte =>posicao_x_morte_green,
																			POSICAO_Y_morte =>posicao_y_morte_green,
																			MORREU_SIGNAL =>MORREU_Green,
																			VIRA_COMIDA => vira_comida_green,
																			verificou_aumentou_tamanho => verificou_aumentou_tamanho_green
																								);
																				
	FSM_COBRA_GREEN_ENTITY 	:	entity work.FSM_cobra 	port map(	clk => clk,
																						rst => rst,
																						verify_morreu => MORREU_Green,
																						bot_start => bot_start_green,
																						perdeu_vida => perdeu_vida_green,
																						bot_mov => bot_mov_green_processado,
																						VIDAS => VIDAS_Green,
																						ESTADO_JOGO => estado_jogo,
																						SNAKE_STATE => EstadoCobraGreen
																												);
																												
	
																		
	COBRA_YELLOW_ENTITY :	entity work.cobra 	port map(	clk =>clk,
																			tick =>tick,
																			meu_estado =>EstadoCobraYellow,
																			estado_jogo =>estado_jogo, 
																			aumenta => aumentaYellow,
																			posicao_aleatoria_X =>pos_aleatoria_x_yellow,
																			posicao_aleatoria_Y =>pos_aleatoria_y_yellow,
																			VIDAS =>VIDAS_Yellow,
																			TAMANHO =>TAMANHOYELLOW,
																			POSICAO_X =>POS_X_COBRA_YELLOW,
																			POSICAO_Y =>POS_Y_COBRA_YELLOW,
																			POSICAO_X_morte =>posicao_x_morte_yellow,
																			POSICAO_Y_morte =>posicao_y_morte_yellow,
																			MORREU_SIGNAL =>MORREU_Yellow,
																			VIRA_COMIDA => vira_comida_yellow,
																			verificou_aumentou_tamanho => verificou_aumentou_tamanho_yellow
																								);
																				
	FSM_COBRA_YELLOW_ENTITY 	:	entity work.FSM_cobra 	port map(	clk => clk,
																						rst => rst,
																						verify_morreu => MORREU_Yellow,
																						bot_start => bot_start_yellow,
																						perdeu_vida => perdeu_vida_yellow,
																						bot_mov => bot_mov_yellow_processado,
																						VIDAS => VIDAS_Yellow,
																						ESTADO_JOGO => estado_jogo,
																						SNAKE_STATE => EstadoCobraYellow
																												);
	
																		
	COBRA_PINK_ENTITY :	entity work.cobra 	port map(	clk =>clk,
																			tick =>tick,
																			meu_estado =>EstadoCobraPink,
																			estado_jogo =>estado_jogo, 
																			aumenta => aumentaPink,
																			posicao_aleatoria_X =>pos_aleatoria_x_pink,
																			posicao_aleatoria_Y =>pos_aleatoria_y_pink,
																			VIDAS =>VIDAS_Pink,
																			TAMANHO =>TAMANHOPINK,
																			POSICAO_X =>POS_X_COBRA_PINK,
																			POSICAO_Y =>POS_Y_COBRA_PINK,
																			POSICAO_X_morte =>posicao_x_morte_pink,
																			POSICAO_Y_morte =>posicao_y_morte_pink,
																			MORREU_SIGNAL =>MORREU_Pink,
																			VIRA_COMIDA => vira_comida_pink,
																			verificou_aumentou_tamanho => verificou_aumentou_tamanho_pink
																								);
																				
	FSM_COBRA_PINK_ENTITY 	:	entity work.FSM_cobra 	port map(	clk => clk,
																						rst => rst,
																						verify_morreu => MORREU_Pink,
																						bot_start => bot_start_pink,
																						perdeu_vida => perdeu_vida_pink,
																						bot_mov => bot_mov_pink_processado,
																						VIDAS => VIDAS_Pink,
																						ESTADO_JOGO => estado_jogo,
																						SNAKE_STATE => EstadoCobraPink
																												);
	
	GERADOR_COMIDA_ENTITY : entity work.GERADOR_COMIDA port map(
																						tick => tick,
																						estado_jogo => estado_jogo,
																						pos_comida_x => new_food_position_x,
																						pos_comida_y => new_food_position_y
																																			);
		
	TABULEIRO_ENTITY : entity work.tabuleiro port map(
																		clk 						=> clk,
																		tick 						=> tick,
																		estado_jogo				=> estado_jogo,
																		green_snake_x 			=> posicao_x_morte_green,
																		green_snake_y 			=> posicao_y_morte_green,
																		green_size 				=> TAMANHOGREEN,
																		green_dead 				=> MORREU_Green,
																		yellow_snake_x 		=> posicao_x_morte_yellow,
																		yellow_snake_y 		=> posicao_y_morte_yellow,
																		yellow_size			   => TAMANHOYELLOW,
																		yellow_dead 			=> MORREU_Yellow,
																		blue_snake_x 			=> posicao_x_morte_blue,
																		blue_snake_y 			=> posicao_y_morte_blue,
																		blue_size 				=> TAMANHOBLUE,
																		blue_dead 				=> MORREU_Blue,
																		pink_snake_x 			=> posicao_x_morte_pink,
																		pink_snake_y 			=> posicao_y_morte_pink,
																		pink_size 				=> TAMANHOPINK,
																		pink_dead 				=> MORREU_Pink,
																		new_food_position_x 	=> new_food_position_x,
																		new_food_position_y	=> new_food_position_y,
																		clear_food_position 	=> clear_food_position,
																		food_array_out_x 		=> food_array_out_x,
																		food_array_out_y 		=> food_array_out_y,
																		food_index 				=> food_index
																																				);
																																				
	COLISAO_ENTITY : entity work.Controle_Colisao port map(
																				clk 						=> clk,
																				rst						=> rst,
																				estado_jogo				=> estado_jogo,
																				verificou_aumentou_tamanho_blue=>verificou_aumentou_tamanho_blue,
																				verificou_aumentou_tamanho_green=>verificou_aumentou_tamanho_green,
																				verificou_aumentou_tamanho_yellow=>verificou_aumentou_tamanho_yellow,
																				verificou_aumentou_tamanho_pink=>verificou_aumentou_tamanho_pink,
																				POS_X_COBRA_BLUE 	 	=> POS_X_COBRA_BLUE,
																				POS_Y_COBRA_BLUE 	 	=> POS_Y_COBRA_BLUE,
																				POS_X_COBRA_GREEN	 	=> POS_X_COBRA_GREEN,
																				POS_Y_COBRA_GREEN  	=> POS_Y_COBRA_GREEN,
																				POS_X_COBRA_YELLOW 	=> POS_X_COBRA_YELLOW,
																				POS_Y_COBRA_YELLOW 	=> POS_Y_COBRA_YELLOW,
																				POS_X_COBRA_PINK 	 	=> POS_X_COBRA_PINK,
																				POS_Y_COBRA_PINK 	 	=> POS_Y_COBRA_PINK,
																				VETOR_X_COMIDAS 	 	=> food_array_out_x,
																				VETOR_Y_COMIDAS 	 	=> food_array_out_y,
																				POSICAO_COMIDA  	 	=> clear_food_position,
																				AUMENTA_COBRA_BLUE 	=> aumentaBlue,
																				AUMENTA_COBRA_GREEN 	=> aumentaGreen,
																				AUMENTA_COBRA_YELLOW => aumentaYellow,
																				AUMENTA_COBRA_PINK 	=> aumentaPink,
																				PERDE_VIDA_BLUE 		=> perdeu_vida_blue,
																				PERDE_VIDA_GREEN 		=> perdeu_vida_green,
																				PERDE_VIDA_YELLOW 	=> perdeu_vida_yellow,
																				PERDE_VIDA_PINK 		=> perdeu_vida_pink,
																				ESTADO_COBRA_BLUE		=> EstadoCobraBlue,
																				ESTADO_COBRA_GREEN	=> EstadoCobraGreen,
																				ESTADO_COBRA_YELLOW	=> EstadoCobraYellow,
																				ESTADO_COBRA_PINK		=> EstadoCobraPink
																																						);
	
	
	--  display VGA
	vga: entity work.DisplayVGA PORT MAP ( clk => clk,
														Hsync => Hsync,
														Vsync => Vsync,
														red => red,
														green => green,
														blue => blue,
														x_tela_inicial => x_tela_inicial,
														y_tela_inicial => y_tela_inicial,
														x_tela_final => x_tela_final,
														y_tela_final => y_tela_final,
														x_snake_p1 => POS_X_COBRA_BLUE,
														y_snake_p1 => POS_Y_COBRA_BLUE,
														x_snake_p2 => POS_X_COBRA_GREEN,
														y_snake_p2 => POS_Y_COBRA_GREEN,
														x_snake_p3 => POS_X_COBRA_YELLOW,
														y_snake_p3 => POS_Y_COBRA_YELLOW,
														x_snake_p4 => POS_X_COBRA_PINK,
														y_snake_p4 => POS_Y_COBRA_PINK,
														estado_jogo => estado_jogo,
														size_p1 => TAMANHOBLUE,
														size_p2 => TAMANHOGREEN,
														size_p3 => TAMANHOYELLOW,
														size_p4 => TAMANHOPINK,
														food_array_out_x => food_array_out_x,
														food_array_out_y => food_array_out_y,
														food_index => food_index);

 END ARCHITECTURE;