library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rom_for_crc8 is
    Port ( address  : in  STD_LOGIC_VECTOR (4 downto 0);
			   readwrite : in std_logic;
			   tosave : in STD_LOGIC_VECTOR (8 downto 0);
           data_out : out  STD_LOGIC_VECTOR (8 downto 0)

			);
end rom_for_crc8;
--
-- ROM in this architecture stores CRC sums 
-- for constant input vector X"66"
-- n-th generated CRC sum is stored under n-th address
--
architecture const_66 of rom_for_crc8 is
  constant ADDRESS_WIDTH : integer := 5;
  constant DATA_WIDTH    : integer := 9;
  
  type rom_t is array (0 to 2 ** ADDRESS_WIDTH - 1)
                   of std_logic_vector(DATA_WIDTH-1 downto 0);

  
  signal output_after_rom : rom_t := (
     "000111110", --load 30
	 "001111111", --add 31
	 --"001100010", -- 3 linia i tak dalej...
     "100001000", --skip if ac >0 
	 "100100001", --jump do pierwszej lini
	-- "001111111", --add 31
	 "011011111", --WYPISZ AC
	 --"010000011",
	 --"010100100",
	 "011100110", --HALT
	 "000011111", 
	 "011100110", 
	 "100101000",
	 "000001001",
	 "000001010",
	 "000001011",
	 "000001100",
	 "000001101",
	 "000001110",
	 "000001111",
	 "000010000",
	 "000010001",
	 "000010010",
	 "000010011",
	 "000010100",
	 "000010101",
	 "000010110",
	 "000010111",
	 "000011000",
	 "000011001",
	 "000011010",
	 "000011011",
	 "000011100",
	 "000011101",
	 "100000101", --zmienna1
	 "000000001" -- zmienna2
	 );
begin
  PROCESS(address, readwrite, tosave)
  BEGIN
  --TODO:dorobic automatyczne wykrywanie, czy dane sa do wczytania, czy do odebrania
  --wczytywanie pelnego polecenia, w przypadku gdy trzeba pobrac adres z zmiennej
  --w przeciwnym przypadku wczytywanie po adress. (potem bedzie to przerobione pod PC)
  
	if readwrite ='1' then
		data_out <= output_after_rom(to_integer(unsigned(address)));
	else
		output_after_rom(to_integer(unsigned(address))) <= tosave;
		data_out <= "000000000";
	end if;
	end process;
end const_66;
