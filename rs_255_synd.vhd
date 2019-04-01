library ieee;
use ieee.std_logic_1164.all;
use work.rs_255_package.all;

entity rs_255_synd is 
port(
     DataIn        : in std_logic_vector(7 downto 0);
     Clk           : in std_logic;
     EnIn          : in std_logic;
     StartWord     : in std_logic;
     EvenOddIn     : in std_logic;
	 SyndromeOut   : out std_logic_vector(127 downto 0)
     );
end rs_255_synd;

architecture beh of rs_255_synd is
	type DataArray is array (15 downto 0) of std_logic_vector(7 downto 0);
	signal Alpha : DataArray := ("00000001", "00000010", "00000100", "00001000", "00010000", "00100000", "01000000", "10000000",
                                 "00011101", "00111010", "01110100", "11101000", "11001101", "10000111", "00010011", "00100110"
                                );
	signal SyndromeComponent : DataArray;	
	signal DataInternal      : DataArray;
	signal DataBuffer1       : DataArray;
	signal DataBuffer2       : DataArray;
	signal DataInRvrsd       : std_logic_vector(7 downto 0);
begin
	DATA_RVRSD:
	for i in 0 to 7 generate
		DataInRvrsd(i) <= DataIn(7 - i);
	end generate;
	
	DATA_INT:
	for i in 0 to 15 generate
		DataInternal(i) <= gf_mult_255(DataBuffer1(i), Alpha(i)) xor DataInRvrsd when EvenOddIn = '1' else
						   gf_mult_255(DataBuffer2(i), Alpha(i)) xor DataInRvrsd;
		process(Clk)
		begin
			if rising_edge(Clk) and EnIn = '1' then
				if EvenOddIn = '1' then
					if StartWord = '1' then
						DataBuffer1(i) <= DataInRvrsd;
					else
						DataBuffer1(i) <= DataInternal(i);
					end if;
				else
					if StartWord = '1' then
						DataBuffer2(i) <= DataInRvrsd;
					else
						DataBuffer2(i) <= DataInternal(i);
					end if;
				end if;
			end if;
		end process;
		SyndromeComponent(i) <= DataBuffer1(i) when EvenOddIn = '0' else 
								DataBuffer2(i);
	end generate;

	SYND_OUT:
	for i in 0 to 15 generate
		SyndromeOut(7 + 8 * i downto 8 * i) <= SyndromeComponent(i); -- старшие внизу
	end generate;
end beh;
