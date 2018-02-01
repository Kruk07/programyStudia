LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY ALU_tb IS
END ALU_tb;
 
ARCHITECTURE behavior OF ALU_tb IS 
 
    -- UUT (Unit Under Test)
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

   -- set clock period 
   constant clk_period : time := 20 ns;
 
BEGIN
	-- instantiate UUT
   uut: ALU PORT MAP (
		add => add,
		subt => subt,
		first => first,
		second => second,
		result => result
			);
   
   -- clock management process
   -- no sensitivity list, but uses 'wait'

 

   -- stimulating process
   stim_proc: PROCESS
   BEGIN		
      -- let it run 
      wait for 100 ns;
		first <= "000000001";
		second <= "000000010";
		add <= '1';
	  wait for 100 ns;
	    add <= '0';
		subt <= '1';
     wait for 100 ns;
      wait;
   END PROCESS;	
END;
