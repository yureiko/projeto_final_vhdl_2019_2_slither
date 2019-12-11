Library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
LIBRARY work;
USE work.comum.all;

entity DisplayVGA is

    port (
	    clk            				: in std_logic;
	    red, green, blue 			: out std_logic_vector (3 downto 0);
	    Hsync, Vsync     			: out std_logic;
		
		x_snake_p1, x_snake_p2, x_snake_p3, x_snake_p4		: in posicao_X_type;
		y_snake_p1, y_snake_p2, y_snake_p3, y_snake_p4		: in posicao_Y_type;
		
		x_tela_inicial : in telaInicialX;
		y_tela_inicial : in telaInicialY;
		
		x_tela_final : in telaFinalX;
		y_tela_final : in telaFinalY;
		
		estado_jogo : in ESTADO;
		
		food_array_out_x		: 	in FOOD_ARRAY_X_TYPE;
		food_array_out_y		: 	in FOOD_ARRAY_Y_TYPE;									
		food_index				: 	in natural range 0 to FOOD_ARRAY_SIZE;
		
		size_p1, size_p2, size_p3, size_p4 			: in natural range 0 to MAX_SNAKE_LENGTH

    );
end;

architecture DisplayVGA of DisplayVGA is
	signal reset:     STD_LOGIC;
	signal start:     STD_LOGIC;
	signal y_control: natural range 0 to 900;
	signal x_control: natural range 0 to 900;
	signal video_on:  STD_LOGIC;
begin
	
	start <= '1';
	reset <= '0';
	
	vga_sync: entity work.sync_mod PORT MAP ( clk => clk, 
															reset => reset,
															start => start,
															y_control => y_control,
															x_control => x_control,
															h_s => Hsync,
															v_s => Vsync,
															video_on => video_on);
   
   process (video_on)
		variable x_screen, y_screen : natural;
		variable print_pixel : std_logic;
   begin
		if video_on = '1' then
			
			x_screen := x_control;
			y_screen := y_control;
			print_pixel := '0';
			
			if(estado_jogo = ESPERANDO) then
				DISPLAY_TELA_INICIAL: for i in 0 to 244 loop
					-- TELA INICIAL
					if (x_screen >= (x_tela_inicial(i)*10 + 1)) and (x_screen <= (x_tela_inicial(i)*10 + 9)) and 
						(y_screen >= (y_tela_inicial(i)*10 + 1)) and (y_screen <= (y_tela_inicial(i)*10 + 9)) then
						if (y_screen <= 110) then
							red <= (others => '1');
							green <= (others => '0');
							blue <= (others => '0');
							print_pixel := '1';
						elsif (y_screen >110 AND y_screen <= 220) then
							red <= (others => '0');
							green <= (others => '1');
							blue <= (others => '0');
							print_pixel := '1';
						else
							red <= (others => '1');
							green <= (others => '1');
							blue <= (others => '1');
							print_pixel := '1';
						end if;			
					end if;
				end loop DISPLAY_TELA_INICIAL;
			
			elsif(estado_jogo = JOGANDO) then
			
				DISPLAY_FOOD: for i in 0 to (FOOD_ARRAY_SIZE - 1) loop
					-- Food
					exit when i = food_index;
					if (x_screen >= (food_array_out_x(i)*10 + 1)) and (x_screen <= (food_array_out_x(i)*10 + 9)) and
						(y_screen >= (food_array_out_y(i)*10 + 1)) and (y_screen <= (food_array_out_y(i)*10 + 9)) then
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '0');
						print_pixel := '1';
					end if;
				end loop DISPLAY_FOOD;
			
				DISPLAY_PLAYER1: for i in 0 to (MAX_SNAKE_LENGTH - 1) loop  --alterar tamanho da cobra
					-- Snake Player 1 BLUE
					exit when i = size_p1;
					if (x_screen >= (x_snake_p1(i)*10 + 1)) and x_screen <= (x_snake_p1(i)*10 + 9) and 
						(y_screen >= (y_snake_p1(i)*10 + 1)) and (y_screen <= (y_snake_p1(i)*10 + 9)) then
						red <= (others => '0');
						green <= (others => '0');
						blue <= (others => '1');
						print_pixel := '1';
					end if;
				end loop DISPLAY_PLAYER1;

				DISPLAY_PLAYER2: for i in 0 to (MAX_SNAKE_LENGTH - 1) loop
					-- Snake Player 2 GREEN
					exit when i = size_p2;
					if (x_screen >= (x_snake_p2(i)*10 + 1)) and (x_screen <= (x_snake_p2(i)*10 + 9)) and 
						(y_screen >= (y_snake_p2(i)*10 + 1)) and (y_screen <= (y_snake_p2(i)*10 + 9)) then
						red <= (others => '0');
						green <= (others => '1');
						blue <= (others => '0');
						print_pixel := '1';
					end if;
				end loop DISPLAY_PLAYER2;
				
				DISPLAY_PLAYER3: for i in 0 to (MAX_SNAKE_LENGTH - 1) loop
					-- Snake Player 3 YELLOW
					exit when i = size_p3;
					if (x_screen >= (x_snake_p3(i)*10 + 1)) and x_screen <= (x_snake_p3(i)*10 + 9) and 
						(y_screen >= (y_snake_p3(i)*10 + 1)) and (y_screen <= (y_snake_p3(i)*10 + 9)) then
						red <= (others => '1');
						green <= (others => '1');
						blue <= (others => '0');
						print_pixel := '1';
					end if;
				end loop DISPLAY_PLAYER3;

				DISPLAY_PLAYER4: for i in 0 to (MAX_SNAKE_LENGTH - 1) loop
					-- Snake Player 4 PINK
					exit when i = size_p4;
					if (x_screen >= (x_snake_p4(i)*10 + 1)) and (x_screen <= (x_snake_p4(i)*10 + 9)) and 
						(y_screen >= (y_snake_p4(i)*10 + 1)) and (y_screen <= (y_snake_p4(i)*10 + 9)) then
						red <= (others => '1');
						green <= (others => '0');
						blue <= (others => '1');
						print_pixel := '1';
					end if;
				end loop DISPLAY_PLAYER4;
			
			else
			
				DISPLAY_TELA_FINAL: for i in 0 to 119 loop
					-- TELA INICIAL
					if (x_screen >= (x_tela_final(i)*10 + 1)) and (x_screen <= (x_tela_final(i)*10 + 9)) and 
						(y_screen >= (y_tela_final(i)*10 + 1)) and (y_screen <= (y_tela_final(i)*10 + 9)) then
						red <= (others => '1');
						green <= (others => '1');
						blue <= (others => '1');
						print_pixel := '1';
					end if;
				end loop DISPLAY_TELA_FINAL;
			end if;
				
			if print_pixel = '0' then
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '0');			
			end if;
			
		else 
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
		end if;
   end process;
end architecture;