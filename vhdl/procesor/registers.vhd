----------------------------------------------------------------------------------
-- Design Name: 
-- Module Name:    registers - registers_counter_arch 
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


entity registers is
	generic ( NBit : natural := 9 );
   port  ( clk : in  STD_LOGIC;
           readwrite : in  STD_LOGIC; --1 read 0 write
		   towrite: in std_logic_vector( NBit-1 downto 0);
		   typeregister : in  std_logic_vector(2 downto 0);
             q : out  std_logic_vector( NBit-1 downto 0)
				 );
end registers;

architecture registers_arch of registers is
	signal ac : std_logic_vector(8 downto 0) := "000000000"; --akumulator, zawiera wartosc zmiennej
	signal mar : std_logic_vector(4 downto 0):= "00000"; --memory adres register
	signal mbr : std_logic_vector(8 downto 0):= "000000000"; --memory buffer register
	signal ir : std_logic_vector(8 downto 0):= "000000000"; --instruction register
	signal inreg : std_logic_vector(8 downto 0):= "000000000"; --input register
	signal outreg : std_logic_vector(8 downto 0):= "000000000"; -- output register
	
BEGIN
  PROCESS(clk,readwrite,typeregister)
  BEGIN
  IF (clk'event and clk='1') THEN
	if (typeregister= "001") then
		if (readwrite='1') then
			q <=ac;
		else
			ac <= towrite;
			q <= towrite;
		end if;
	elsif (typeregister= "010") then
		if (readwrite='1') then
			q <= mar;
		else
			mar <= towrite(4 downto 0);
			q <= towrite;
		end if;
	elsif (typeregister = "011") then
		if (readwrite= '1') then
			q <= mbr;
		else
			mbr <= towrite;
			q <= towrite;
		end if;
	elsif (typeregister = "100") then
		if (readwrite= '1') then
			q <=ir;
		else
			ir <= towrite;
			q <= towrite;
		end if;
	elsif (typeregister = "101") then
		if (readwrite='1') then
			q<= inreg;
		else
			inreg <= towrite;
			q <= towrite;
		end if;
	elsif (typeregister = "110") then
		if (readwrite='1') then
			q <= outreg;
		else
			outreg <= towrite;
			q <= towrite;
		end if;
	else
		q <= "000000000";
	end if;
END IF;
 
  END PROCESS;
END registers_arch;

