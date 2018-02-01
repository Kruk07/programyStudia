LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use textio.all;

ENTITY controller_tb IS
END controller_tb;
 
ARCHITECTURE behavior OF controller_tb IS 
--ROM
	 -- component delcaration for ROM look-up 
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
	
   signal clk : std_logic := '0';
   -- clock period 
   constant clk_period : time := 20 ns;

	signal data_out_66 : std_logic_vector(8 downto 0);
	-- access address
	signal address : std_logic_vector(4 downto 0) := (others => '0');

	signal readwrite : std_logic := '1'; --1 read; 0 write;
	signal tosave : std_logic_vector(8 downto 0) := (others => '0');
	
	
-- PC
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
	
	signal rst : std_logic := '0';
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
BEGIN

	 -- instance of ROM lookup for constant X"66" input
	 rom_66 : entity work.rom_for_crc8(const_66) 
	 port map (
	 		 address => address,
			 readwrite => readwrite,
			 tosave => tosave,
			 data_out => data_out_66
		  );
		  
		  
		  	-- instantiate UUT
   uut: PC PORT MAP (
          clk => clk,
          rst => rst,
		  skipcond => skipcond,
		  jump => jump,
		  jumpadress => jumpadress,
          q   => qq
        );
		
	uut2: registers PORT MAP (
		
			clk => clk,
           readwrite => readwrite2,
		   towrite =>towrite2,
		   typeregister => typeregister2,
             q => q2
	
	); 
   

   -- Clock process definitions
   clk_process :process
	  variable wait_done : natural := 0;
   begin
	   if wait_done = 0
		then
		   wait for clk_period * 0.2;
			wait_done := 1;
	   end if;
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- input your code here
				   wait for clk_period * 0.2;
			address<=('0','0','0','0','0');
			data_in<=X"66";
			rst <= '1';

		 wait for clk_period;
			assert data_out_66 = "000100000" report "LOAD 00000" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		address <= std_logic_vector(unsigned(qq));	
		  
		wait for clk_period;
			assert data_out_66 = "000100000" report "LOAD 00000" severity note;
			--assert data_out_66 = "001000001" report "STORE 00001" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
			  address <= std_logic_vector(unsigned(qq));
			  
		  		wait for clk_period;
			--assert data_out_66 = "001100010" report "ADD 00010" severity note;
			assert data_out_66 = "001000001" report "STORE 00001" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));
		  		  --jump <= '1' ;
				  --jumpadress <= "00001";
		  		wait for clk_period;
				assert data_out_66 = "001100010" report "ADD 00010" severity note;
			--assert data_out_66 = "010000011" report "SUBT 00011" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));
		  
		  		wait for clk_period;
				assert data_out_66 = "010000011" report "SUBT 00011" severity note;
			--assert data_out_66 = "010100100" report "INPUT AC" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));
		  
		  		wait for clk_period;
				assert data_out_66 = "010100100" report "INPUT AC" severity note;
			--assert data_out_66 = "011000101" report "OUTPUT AC" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));
		  
		  		wait for clk_period;
				assert data_out_66 = "011000101" report "OUTPUT AC" severity note;
			--assert data_out_66 = "011100110" report "HALT " severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));
		  
		  		wait for clk_period;
			--assert data_out_66 = "100000111" report "SKIPCOND" severity note;
			assert data_out_66 = "011100110" report "HALT " severity note;
		  --address <=std_logic_vector(unsigned(address)+1);
		  address <= std_logic_vector(unsigned(qq));	
		  
		  		wait for clk_period;
				assert data_out_66 = "100000111" report "SKIPCOND" severity note;
			--assert data_out_66 = "100101000" report "JUMP X " severity note;
		  --address <=std_logic_vector(unsigned(address)+1);	

		  address <= std_logic_vector(unsigned(qq));
		  
		  		  		wait for clk_period;
						assert data_out_66 = "100101000" report "JUMP X " severity note;
			--assert data_out_66 = "000001001" report "END" severity note;
		  --address <=std_logic_vector(unsigned(address)+1);	
		  address <= std_logic_vector(unsigned(qq));	 

			wait for clk_period;
				
				readwrite2 <= '0';
				towrite2 <= "010101010";
				typeregister2 <= "001";
				
			wait for clk_period;
				typeregister2 <= "000";
				readwrite2 <= '1';
				towrite2 <= "000001000";
				
				wait for clk_period*3;
				typeregister2 <= "010";
				wait for clk_period*1;
				typeregister2 <= "001";
		      assert false report "end of test" severity note;
      wait;
   end process;

END;
