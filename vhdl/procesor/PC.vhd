----------------------------------------------------------------------------------
-- Design Name: 
-- Module Name:    PC - PC_counter_arch 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Additional Comments: kod na podstawie
--		Majewski, Zbysinski "Uklady FPGA w przykladach"
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity PC is
	generic ( NBit : natural := 5 );
   port  ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
		   skipcond: in STD_LOGIC;
		   jump: in std_logic;
		   jumpadress: in unsigned(NBit-1 downto 0);
-- INOUT -- signal 'q' is set from 'inside' the entity, but also read outside as its output
             q : inout  unsigned( NBit-1 downto 0) := "00000"
				 );
end PC;

architecture PC_counter_arch of PC is

BEGIN
  PROCESS(clk, rst)
  BEGIN
	IF rst = '0' THEN 
		q <= ('1','1','1','1', '1');
	ELSIF (clk'event and clk='1') THEN
			if (skipcond='1') then
				q <= q + 2;
			else
				if (jump = '1') then
					--assert false report "TAKI CHUJ- WYKONUJE SE JUMPA!" severity note;
					q <= jumpadress;
				else
					q <= q + 1;
				end if;
			end if;
				
		END IF;
  END PROCESS;
END PC_counter_arch;

