----------------------------------------------------------------------------------
-- Design Name: 
-- Module Name:    ALU - ALU_counter_arch 
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


entity ALU is
	generic ( NBit : natural := 9 );
   port  ( 
			add: in STD_LOGIC;
			subt: in STD_LOGIC;
           first : in  STD_LOGIC_VECTOR(NBit-1 downto 0);
		   second : in  STD_LOGIC_VECTOR(NBit-1 downto 0);
            result : out  signed( NBit-1 downto 0)
				 );
end ALU;

architecture ALU_arch of ALU is

BEGIN
  PROCESS(add,subt,first,second)
  BEGIN
	if (add = '1') then
		result <= signed(first) + signed(second);
	end if;
	if (subt = '1') then
		result <= signed(first) - signed(second);
	end if;
  END PROCESS;
END ALU_arch;

