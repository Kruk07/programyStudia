LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
--use textio.all;

ENTITY controller_testbench IS
END controller_testbench;
 
ARCHITECTURE behavior OF controller_testbench IS 

	 component controller
    Port ( 	clk:     in std_logic;
			pusher:  in std_logic;
			reset : in std_logic;
			driver : out std_logic := '0'
			);
	 end component;

	 signal clk : std_logic := '0';
	 signal pusher: std_logic := '1';
	 signal reset : std_logic := '0';
	 signal driver : std_logic := '0';
	 
	    -- clock period 
   constant clk_period : time := 20 ns;

BEGIN
	 controller_uut : controller
	 port map (
	 		 clk => clk,
			 pusher => pusher,
			 reset => reset,
			 driver => driver
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
		wait for clk_period*100;
				      --assert false report "end of test" severity note;
      wait;
   end process;

END;
