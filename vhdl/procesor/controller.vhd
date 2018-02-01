
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use STD.textio.all;
entity controller is
  port(
	clk:     in std_logic;
	pusher:  in std_logic := '1';
	reset : in std_logic;
	driver : out std_logic := '0'

  );
  
end controller;

architecture Flow of controller is
  type stan is (FETCH,FETCH2, DECODE, EXECUTE, EXECUTE2,EXECUTE3, STORE, FINISH);
  signal stan_teraz : stan := FETCH;
  signal stan_potem : stan := FETCH;
  signal state : std_logic_vector(2 downto 0) := (others => '0');
  
  
  type cmd_type is (NOPS, LOADS, STORES, ADDS, SUBTS,INPUTS,OUTPUTS,HALTS,SKIPCONDS,JUMPS); --typ polecenia MARIE
  signal current_cmd : cmd_type := NOPS;
  signal typenum : std_logic_vector(3 downto 0) := (others => '0');
  
  signal casedelay: std_logic_vector (2 downto 0) := (others => '0');
  
  signal sign : std_logic_vector(4 downto 0) := (others => '0'); -- potrzebne do wykrycia znaku przy porównywaniu
  type sign_type is (BIGGER,EQUAL,LOWER,NOP);
  signal current_sign : sign_type := NOP;
  
  --ROM
  component rom_for_crc8
    Port ( address  : in  STD_LOGIC_VECTOR (4 downto 0) ;
		readwrite : in std_logic;
		tosave : in STD_LOGIC_VECTOR (8 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0)
			);
	 end component;
 		-- input
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
	-- clock stuff
	
   signal clkforPC : std_logic := '0';


	signal data_out_66 : std_logic_vector(8 downto 0);
	-- access address
	signal address : std_logic_vector(4 downto 0) := (others => '0');

	signal readwrite : std_logic := '1'; --1 read; 0 write;
	signal tosave : std_logic_vector(8 downto 0) := (others => '0');
	   
  
  
  
  --PC
  	     COMPONENT PC
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
		 skipcond : IN std_logic;
		 jump: IN std_logic;
		 jumpadress: IN unsigned(4 downto 0);
         q : INOUT  unsigned(4 downto 0)
        );
    END COMPONENT;
  
  	signal rst : std_logic := '1';
	signal skipcond : std_logic := '0';
   -- input/output signal
    signal qq : unsigned(4 downto 0) := (others => '0');
	signal jump: std_logic := '0';
	signal jumpadress: unsigned(4 downto 0) := (others => '0');
  
  -- Registers

	     COMPONENT registers
    PORT ( clk : in  STD_LOGIC;
           readwrite : in  STD_LOGIC; --1 read 0 write
		   towrite: in std_logic_vector( 8 downto 0);
		   typeregister : in  std_logic_vector(2 downto 0);
             q : out  std_logic_vector( 8 downto 0)
				 );
    END COMPONENT;
	
	
	signal readwrite2 : std_logic :='0';
	signal towrite2 : std_logic_vector (8 downto 0) := "000000000";
	signal typeregister2: std_logic_vector(2 downto 0) :="000";
	signal q2 : std_logic_vector (8 downto 0) := "000000000";
  
 --ALU 
      COMPONENT ALU
   port  ( 
			add: in STD_LOGIC;
			subt: in STD_LOGIC;
           first : in  STD_LOGIC_VECTOR(8 downto 0);
		   second : in  STD_LOGIC_VECTOR(8 downto 0);
            result : out  signed( 8 downto 0)
				 );
    END COMPONENT;
    
   -- input signals
   signal add : std_logic := '0';
   signal subt : std_logic := '0';
   signal first : std_logic_vector(8 downto 0);
   signal second : std_logic_vector(8 downto 0);
   -- input/output signal
   signal result : signed(8 downto 0);
  
  
begin

	 -- instance of ROM lookup for constant X"66" input
	 uutram : entity work.rom_for_crc8(const_66) 
	 port map (
	 		 address => address,
			 readwrite => readwrite,
			 tosave => tosave,
			 data_out => data_out_66
		  );
		  
		  
		  		  	-- instantiate UUT
   uutpc: PC PORT MAP (
          clk => clkforPC,
          rst => rst,
		  skipcond => skipcond,
		  jump => jump,
		  jumpadress => jumpadress,
          q   => qq
        );

	uutregisters: registers PORT MAP (
		
			clk => clk,
           readwrite => readwrite2,
		   towrite =>towrite2,
		   typeregister => typeregister2,
             q => q2
	
	); 
	
	   uutalu: ALU PORT MAP (
		add => add,
		subt => subt,
		first => first,
		second => second,
		result => result
			);
		
state_advance: process(clk, reset)
begin
	if rising_edge(reset)then
		stan_teraz <= FETCH;
	end if;
  if rising_edge(clk) then
     stan_teraz <= stan_potem;
  end if;
end process;

next_state: process(stan_teraz,pusher)

begin

   case stan_teraz is
     when FETCH => --pobierz instrukcje
			state <="001";
			typeregister2 <= "000";
			readwrite<='1';
			--skipcond <= '0';
				if pusher= '1' then
				
					clkforPC <= '1';
					address <= std_logic_vector(unsigned(qq));	
					stan_potem <= FETCH2;
				end if;
				driver<='0';
				
	when FETCH2 => --przetworz instrukcje
			state <="001";
				if pusher= '1' then
					clkforPC <= '0';
					
					readwrite2 <= '0';
					towrite2 <= data_out_66;
					typeregister2 <= "100"; --zapisz do rejestru ir
					typenum <= data_out_66(8 downto 5);
					
					stan_potem <= DECODE;
				end if;
				driver<='0';
	  when DECODE => --zdekoduj informacje
	  			state <="010";
				typeregister2 <= "000";
	  			if pusher= '1' then
					clkforPC <= '0';
					case typenum is 
						when "0001" => current_cmd <= LOADS;
							--assert false report "WCZYTANO: LOAD" severity note;
							casedelay <= "111";
							
							stan_potem <= EXECUTE;
						when "0010" =>current_cmd <= STORES;
							--assert false report "WCZYTANO: STORE" severity note;	
							stan_potem <= EXECUTE;							
						when "0011" =>current_cmd <= ADDS;
							--assert false report "WCZYTANO: ADD" severity note;	
							address <= data_out_66(4 downto 0);
							stan_potem <= EXECUTE;							
						when "0100" =>current_cmd <= SUBTS;
							--assert false report "WCZYTANO: SUBT" severity note;
							address <= data_out_66(4 downto 0);
							stan_potem <= EXECUTE;
						when "0101" =>current_cmd <= INPUTS;
							--assert false report "WCZYTANO: INPUTS" severity note;
							stan_potem <= EXECUTE;							
						when "0110" =>current_cmd <= OUTPUTS;
							--assert false report "WCZYTANO: OUTPUTS" severity note;
							stan_potem <= EXECUTE;							
						when "0111" =>current_cmd <= HALTS;
							--assert false report "WCZYTANO: HALT" severity note;
							stan_potem <= EXECUTE;							
						when "1000" =>current_cmd <= SKIPCONDS;
							--assert false report "WCZYTANO: SKIPCOND" severity note;
							sign <= data_out_66(4 downto 0);
							stan_potem <= EXECUTE;							
						when "1001" =>current_cmd <= JUMPS;
							--assert false report "WCZYTANO: JUMP" severity note;		
							stan_potem <= EXECUTE;							
						when others =>current_cmd <= NOPS;
							--assert false report "NIEZNANE POLECENIE" severity note;	
							stan_potem <= FETCH;							
					end case;
					

				end if;
				driver<='0';
	  when EXECUTE => --wykonaj informacje
	  			state <="011";
	  	  		if pusher= '1' then
				case current_cmd is 
						when LOADS => 
							--assert false report "LOAD- DO MAR LADUJE ADRES" severity note;
							
							readwrite2 <= '0';
						    towrite2 <= data_out_66;
							typeregister2 <= "010"; --zapisz do rejestru mar
							stan_potem <= EXECUTE2;
							address <= data_out_66(4 downto 0);
						when STORES =>
							--assert false report "STORE- DO MAR ZAPISUJE ADRES" severity note;	
							readwrite2 <= '0';
						    towrite2 <= data_out_66;
							typeregister2 <= "010"; --zapisz do rejestru mar
							address <= data_out_66(4 downto 0);
							stan_potem <= EXECUTE2;							
						when ADDS =>
							--assert false report "ADD- POBRANA LICZBE Z ADRESU WKLADAM DO SECOND" severity note;	
							add<= '1';
							second <= data_out_66;
							readwrite2 <= '1';
							typeregister2 <= "001"; --pobierz ac
							stan_potem <= EXECUTE2;							
						when SUBTS =>
							--assert false report "WYKONAC- SUBT" severity note;
							subt<= '1';
							second <= data_out_66;
							readwrite2 <= '1';
							typeregister2 <= "001"; --pobierz ac
							stan_potem <= EXECUTE2;			
						when INPUTS =>
							--assert false report "WYKONAC- INPUTS" severity note;
							stan_potem <= STORE;							
						when OUTPUTS =>
							--assert false report "OUTPUT- POBIERZ AC" severity note;
							readwrite2 <= '1';
						    --towrite2 <= data_out_66;
							typeregister2 <= "001"; --pobierz ac
							stan_potem <= EXECUTE2;							
						when HALTS =>
							--assert false report "WYKONAC- HALTS" severity note;
							stan_potem <= FINISH;							
						when SKIPCONDS =>
							--assert false report "SKIPCOND- WARUNKI" severity note;		
							case sign is
								when "01000" => current_sign <= BIGGER; stan_potem <= EXECUTE2;		--AC >0
								when "00100" => current_sign <= EQUAL; stan_potem <= EXECUTE2; --AC = 0
								when "00000" => current_sign <= LOWER; stan_potem <= EXECUTE2; --AC<0
								when others =>  current_sign <= NOP; stan_potem <= FETCH; --blad, pomijamy instrukcje
							end case;
								
							stan_potem <= EXECUTE2;							
						when JUMPS =>
							--assert false report "JUMP - PRZESKOK" severity note;
							jump <= '1';
							jumpadress <= unsigned(data_out_66(4 downto 0));
							clkforPC <= '1';
							stan_potem <= EXECUTE2;							
						when others =>
							--assert false report "O DZIWO TUTAJ DOSZLO" severity note;	
							stan_potem <= FETCH;							
					end case;

				end	if	;
				driver<='0';
				
	  when EXECUTE2 => 
	  	  			state <="011";
	  	  		if pusher= '1' then
				case current_cmd is 
						when LOADS => 
							--assert false report "LOAD- DO MBR LADUJE ZAWARTOSC PAMIECI" severity note;
							
							readwrite2 <= '0';
						    towrite2 <= data_out_66;
							typeregister2 <= "011"; --zapisz do rejestru mbr
							stan_potem <= EXECUTE3;
						when STORES =>
							--assert false report "STORE- POBIERZ AC" severity note;	
							readwrite2 <= '1';
						    --towrite2 <= data_out_66;
							typeregister2 <= "001"; --pobierz ac
							stan_potem <= EXECUTE3;
							--stan_potem <= STORE;							
						when ADDS =>
							--assert false report "ADD- DODANIE AC" severity note;
							first <= q2;
							stan_potem <= EXECUTE3;							
						when SUBTS =>
							--assert false report "WYKONAC- SUBT" severity note;
							first <= q2;
							stan_potem <= EXECUTE3;	
						when INPUTS =>
							--assert false report "WYKONAC- INPUTS" severity note;
							stan_potem <= STORE;							
						when OUTPUTS =>
							--assert false report "OUTPUT- WLOZYC DO REJESTRU OUTPUT AC" severity note;
							readwrite2 <= '0';
						    towrite2 <= q2;
							typeregister2 <= "110"; --zapisz do rejestru OUTREG
							stan_potem <= EXECUTE3;													
						when SKIPCONDS =>
							--assert false report "WYKONAC- SKIPCONDS" severity note;		
							readwrite2 <= '1';
							typeregister2 <= "001"; --pobierz ac
							stan_potem <= EXECUTE3;							
						when JUMPS =>
							--assert false report "ZAKONCZENIE JUMPA" severity note;	
							clkforPC <= '0';
							stan_potem <= EXECUTE3;							
						when others =>
							--assert false report "O DZIWO TUTAJ DOSZLO" severity note;	
							stan_potem <= FETCH;							
					end case;

				end	if	;
				driver<='0';
	  
	  	  when EXECUTE3 => 
	  	  			state <="011";
	  	  		if pusher= '1' then
				case current_cmd is 
						when LOADS => 
							--assert false report "LOAD- DO AC LADUJE MBR" severity note;
							
							readwrite2 <= '0';
						    towrite2 <= data_out_66;
							typeregister2 <= "001"; --zapisz do rejestru AC
							stan_potem <= FETCH;
							current_cmd <=NOPS;
						when STORES =>
							--assert false report "STORE- ZAPIS AC DO MBR" severity note;	
							readwrite2 <= '0';
						    towrite2 <= q2;
							typeregister2 <= "011"; --zapisz do rejestru MBR
							stan_potem <= STORE;							
						when ADDS =>
							--assert false report "ZAPIS WYNIKU DO AC" severity note;	
							readwrite2 <= '0';
						    towrite2 <= std_logic_vector(result);
							add <= '0';
							typeregister2 <= "001"; --zapisz do rejestru AC
							stan_potem <= FETCH;
							current_cmd <=NOPS;							
						when SUBTS =>
							--assert false report "WYKONAC- SUBT" severity note;
							readwrite2 <= '0';
						    towrite2 <= std_logic_vector(result);
							subt <= '0';
							typeregister2 <= "001"; --zapisz do rejestru AC
							stan_potem <= FETCH;
							current_cmd <=NOPS;							
						when INPUTS =>
							--assert false report "WYKONAC- INPUTS" severity note;
							stan_potem <= STORE;
							current_cmd <=NOPS;							
						when OUTPUTS =>
							--assert false report "WYPISZ NA EKRAN" severity note;
							readwrite2 <= '1';
							typeregister2 <= "000";
						   for i in q2'LENGTH-1 downto 0  loop
								report 	  std_logic'image(q2(i));
						   end loop;
							stan_potem <= FETCH;	
							current_cmd <=NOPS;							
						when SKIPCONDS =>
							--assert false report "WYKONAC- SKIPCONDS" severity note;	
							case current_sign is
								when BIGGER => 
									if (to_integer(signed(q2)) > 0) then
										--assert false report "BIGGER" severity note;	
										clkforPC<='1';
										--skipcond <= '1';
									else
										--assert false report "LOWEREQUAL" severity note;
									
									end if;
								--AC >0 
								when EQUAL => 
									if (to_integer(signed(q2)) = 0) then
										--assert false report "EQUAL" severity note;	
										clkforPC<='1';	
									else
										--assert false report "NOTEQUAL" severity note;
										
									end if;
								--AC = 0
								when LOWER =>
									if (to_integer(signed(q2)) < 0) then
										--assert false report "LOWER" severity note;	
										clkforPC<='1';
									else
										--assert false report "BIGGEREQUAL" severity note;
									
									end if;
								--AC<0
								when others =>  current_sign <= NOP; stan_potem <= FETCH; --blad, pomijamy instrukcje
							end case;	
							current_sign <= NOP;
							stan_potem <= STORE;
							--current_cmd <=NOPS;
						when JUMPS =>
							--assert false report "ZAKONCZENIE JUMPA" severity note;	
							jump <= '0';
							jumpadress <= "00000";
							stan_potem <= FETCH;	
							current_cmd <=NOPS;							
						when others =>
							--assert false report "O DZIWO TUTAJ DOSZLO" severity note;	
							stan_potem <= FETCH;	
							current_cmd <=NOPS;							
					end case;

				end	if	;
				driver<='0';
	  
	  when STORE => --zapisz do ram
				state <="100";
	  	  		if pusher= '1' then
					case current_cmd is
						when STORES =>
							typeregister2 <= "000";
							readwrite <= '0';
							tosave <= q2;
							stan_potem <= FETCH;
							
						when SKIPCONDS =>
							clkforPC<='0';
							address <= std_logic_vector(unsigned(qq));	
							stan_potem <= FETCH;
						when others =>stan_potem <= FETCH; -- assert false report "error" severity note; 					
					end case;
				end	if	;	
				driver<='0';
	  when FINISH =>
				state <= "111";
				stan_potem <= FINISH;
				
   end case;
end process;

end Flow;

