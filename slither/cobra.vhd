LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
USE work.comum.all;

----------------------
ENTITY cobra IS 
    PORT (
		  clk: IN STD_LOGIC;
        tick: IN STD_LOGIC;
        meu_estado: IN ESTADO_COBRA; -- estado da cobra
        estado_jogo: IN ESTADO; 
        aumenta: IN STD_LOGIC; --sinal de aumentar a cobra
       -- perde_vida: IN STD_LOGIC;
        
        posicao_aleatoria_X: IN NATURAL RANGE 0 TO X_RESOLUTION-1; 
        posicao_aleatoria_Y: IN NATURAL RANGE 0 TO Y_RESOLUTION-1;
        
        VIDAS: OUT NATURAL RANGE 0 TO INITIAL_LIVES; -- numero de vidas
        TAMANHO: OUT NATURAL RANGE 0 TO MAX_SNAKE_LENGTH; -- tamanho da cobra
        POSICAO_X: OUT posicao_X_type; -- posicao de cada parte da cobra
        POSICAO_Y: OUT posicao_Y_type; -- posicao de cada parte da cobra
		  
		  POSICAO_X_morte: OUT posicao_X_type; -- Posicao em que morreu
		  POSICAO_Y_morte: OUT posicao_Y_type; -- Posicao em que morreu
		  
        MORREU_SIGNAL: OUT STD_LOGIC; -- sinal de que a cobra esta no ESTADO MORREU, para a a maquina de estado da cobra interpretar
		  VIRA_COMIDA: OUT STD_LOGIC; -- sinal que deve gerar comida para YURI
		  verificou_aumentou_tamanho : OUT STD_LOGIC

    );
END ENTITY;

ARCHITECTURE cobra OF cobra IS 
    
    SIGNAL tam_signal: NATURAL RANGE 0 TO MAX_SNAKE_LENGTH;
    SIGNAL pos_X_signal: posicao_X_type;
    SIGNAL pos_Y_signal: posicao_Y_type;
    SIGNAL vida_signal: NATURAL RANGE 0 TO INITIAL_LIVES;
	 
    BEGIN
    
    TAMANHO <= tam_signal;
    VIDAS <= vida_signal;
    POSICAO_X <= pos_X_signal;
    POSICAO_Y <= pos_Y_signal;
    
    PROCESS(tick)
	 variable perdi_vida : STD_LOGIC := '0';
            BEGIN
               IF rising_edge(tick) THEN
                        IF estado_jogo = JOGANDO THEN
									                      
										  verificou_aumentou_tamanho <= '0';
                                MORREU_SIGNAL<='0'; -- limpa este sinal
										  VIRA_COMIDA <= '0'; -- limpa este sinal
                                
                                IF aumenta = '1' THEN -- recebi um sinal que peguei uma comida
										  verificou_aumentou_tamanho <= '1';
                                        IF tam_signal < MAX_SNAKE_LENGTH THEN -- se posso crescer ainda...  
                                                tam_signal <= tam_signal+1; -- cresco!!!!!
                                        END IF;
                                END IF;
                            
                                
                                IF meu_estado = PARADA THEN
										                         
												perdi_vida := '0';
                                
                                ELSIF meu_estado = MORREU THEN
													if perdi_vida = '0' then
														FOR I in 0 to (MAX_SNAKE_LENGTH-1) loop -- loop para colocar a cobra em outro lugar
															 IF I = 0 THEN
																	pos_X_signal(0) <= posicao_aleatoria_X; --cabeÃ§a vai para lugar aleatorio
																	pos_Y_signal(0) <= posicao_aleatoria_Y; --cabeÃ§a vai para lugar aleatorio
															 ELSE 
																	pos_X_signal(I) <= X_RESOLUTION;  --limpa o resto por precauÃ§ao
																	pos_Y_signal(I) <= Y_RESOLUTION;   --limpa o resto por precauÃ§ao
															 END IF;
														end loop;
														perdi_vida := '1';
														vida_signal <= vida_signal - 1;
													end if;
                                        tam_signal <= INITIAL_LENGTH; -- se morri, reinicia o tamanho da cobra
                                        --vida_signal <= vida_signal - 1;-- perco uma vida xx
                                        
                                        MORREU_SIGNAL<='1'; -- a cobra morreu
                                        VIRA_COMIDA<='1'; 
													 
													 POSICAO_X_morte <= pos_X_signal;
													 POSICAO_Y_morte <= pos_Y_signal;
													 
                                    
                                ELSIF meu_estado = DESAPARECE THEN --morri para sempre
                    
													 VIRA_COMIDA<='1'; 
													 
													 POSICAO_X_morte <= pos_X_signal;
													 POSICAO_Y_morte <= pos_Y_signal;
													 
                                        tam_signal <= 0; -- nÃ£o existe mais cobra
                                        --vida_signal <= vida_signal - 1;-- perco uma vida xx
                                        
                                        FOR I in 0 to (MAX_SNAKE_LENGTH-1) loop -- limpo a cobra da tela
                                                pos_X_signal(I) <= X_RESOLUTION;  --limpa o resto por precauÃ§ao
                                                pos_Y_signal(I) <= Y_RESOLUTION;   --limpa o resto por precauÃ§ao
                                        end loop;
                                    
                                ELSE --ESTOU ME MEXENDO
													perdi_vida := '0';
													FOR I in 1 to (MAX_SNAKE_LENGTH-1) loop -- SHIFT DE POSICOES
														 exit when I = tam_signal ;
														 pos_X_signal(I) <= pos_X_signal(I-1); -- (x)
														 pos_Y_signal(I) <= pos_Y_signal(I-1); -- (y)
													end loop;
											  
													IF meu_estado = SUBINDO THEN
											  
														 pos_Y_signal(0) <= (pos_Y_signal(0)-1); -- soma posicao y
											  
													ELSIF meu_estado = DESCENDO THEN
											  
														 pos_Y_signal(0) <= (pos_Y_signal(0)+1); -- decrementa posicao y
														 
													ELSIF meu_estado = ESQUERDA THEN
											  
														 pos_X_signal(0) <= (pos_X_signal(0)-1); -- decrementa posicao x
														 
													ELSIF meu_estado = DIREITA THEN
														 
														 pos_X_signal(0) <= (pos_X_signal(0)+1); -- soma posicao x
														 
													END IF;
												
                                END IF;
                            
                        ELSIF estado_jogo = ESPERANDO THEN --seta os parametros iniciais da cobra no estado ESPERANDO do jogo
									 perdi_vida := '0';
									 vida_signal <= INITIAL_LIVES;
                            tam_signal <= INITIAL_LENGTH;
                            --vida_signal <= INITIAL_LIVES;
                            FOR I in 0 to (MAX_SNAKE_LENGTH-1) loop 
                                    IF I = 0 THEN
                                                pos_X_signal(0) <= posicao_aleatoria_X; --cabeÃ§a vai para lugar aleatorio
                                                pos_Y_signal(0) <= posicao_aleatoria_Y; --cabeÃ§a vai para lugar aleatorio
                                            ELSE 
                                                pos_X_signal(I) <= X_RESOLUTION;  --limpa o resto por precauÃ§ao
                                                pos_Y_signal(I) <= Y_RESOLUTION;  --limpa o resto por precauÃ§ao
                                            END IF;
                            END LOOP;
                        ELSIF estado_jogo = ACABOU THEN
                        
                        --PARA A COBRA, A PRINCIPIO NAO FAZ NADA--
                        
                        END IF;
                    
                
                END IF;
    END PROCESS;
    

 END;