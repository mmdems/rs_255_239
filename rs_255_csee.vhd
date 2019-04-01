library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.rs_255_package.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity rs_255_csee is
port(
	 Clk        : in std_logic;
	 EnIn       : in std_logic;
	 LambdaEnIn : in std_logic_vector(1 downto 0);
	 LambdaIn   : in std_logic_vector(143 downto 0);    -- 2 * 72 
	 OmegaIn    : in std_logic_vector(127 downto 0);    -- 2 * 64
	 ErrorValue : out std_logic_vector(7 downto 0);
	 ErrorEnOut : out std_logic
	 );
end rs_255_csee;

architecture beh of rs_255_csee is
	type RegArray is array (8 downto 0) of std_logic_vector(7 downto 0);
	signal Alpha         : RegArray := ("00011101", "10000000", "01000000", "00100000", "00010000", "00001000", "00000100", "00000010", "00000001"); -- alpha^8 .. alpha^0
	signal LambdaReg     : RegArray; -- 1..8
	signal LambdaReg_2   : RegArray; -- 9..16
	signal OmegaReg      : RegArray; -- 1..8
	signal OmegaReg_2    : RegArray; -- 9..16
	signal Alpha16       : std_logic_vector(7 downto 0); -- 1..8
	signal Alpha16_2     : std_logic_vector(7 downto 0); -- 9..16
	signal LambdaNew     : std_logic_vector(7 downto 0);
	signal Counter       : integer  := 0;
	signal ErrorEnOutInt : std_logic;
	signal ErrorValueInt : std_logic_vector(7 downto 0);
	type PolyvalsLatched is array (2 downto 0) of std_logic_vector(7 downto 0);
	signal LatchedLambda  : PolyvalsLatched;
	signal LatchedOmega   : PolyvalsLatched;
	signal LatchedAlpha16 : PolyvalsLatched;
	signal InvElem        : std_logic_vector(7 downto 0);

begin
	process(Clk)
		variable LambdaPolyval    : std_logic_vector(7 downto 0) := x"00";
		variable OmegaPolyval     : std_logic_vector(7 downto 0) := x"00";
		variable zLambdaDerivative : std_logic_vector(7 downto 0) := x"00"; -- z * Л'(z)
		type Mults is array (8 downto 0) of std_logic_vector(7 downto 0);
		variable LambdaMult : Mults;
		variable OmegaMult  : Mults;
	begin
		if rising_edge(Clk) and EnIn = '1' then
			if LambdaEnIn(0) = '1' then -- 1..8
				for i in 0 to 8 loop
					LambdaMult(i) := LambdaIn(7 + i * 8 downto i * 8);
				end loop;
				for i in 0 to 7 loop
					OmegaMult(i) := OmegaIn(7 + i * 8 downto i * 8);
				end loop;
				Counter <= 0;
				ErrorEnOutInt <= '0';
				ErrorValueInt <= x"00";
			elsif LambdaEnIn(1) = '1' then -- 9..16
				for i in 0 to 8 loop
					LambdaMult(i) := LambdaIn(72 + 7 + i * 8 downto 72 + i * 8);
				end loop;
				for i in 0 to 7 loop
					OmegaMult(i) := OmegaIn(64 + 7 + i * 8 downto 64 + i * 8);
				end loop;
			else
				for i in 0 to 8 loop
					LambdaMult(i) := LambdaReg_2(i);
				end loop;
				for i in 0 to 7 loop
					OmegaMult(i) := OmegaReg_2(i);
				end loop;
			end if;
						
			OmegaPolyval := x"00";
			for i in 0 to 7 loop
				OmegaReg(i) <= gf_mult_255(OmegaMult(i), Alpha(i));
				OmegaPolyval := OmegaPolyval xor OmegaReg(i);
			end loop;
			
			LambdaPolyval := x"00";
			for i in 0 to 8 loop
				LambdaReg(i) <= gf_mult_255(LambdaMult(i), Alpha(i));
				LambdaPolyval := LambdaPolyval xor LambdaReg(i);
			end loop;
			
			zLambdaDerivative := x"00";
			for i in 0 to 3 loop
				zLambdaDerivative := zLambdaDerivative xor LambdaReg(i * 2 + 1);
			end loop;
			if LatchedLambda(0) = x"00" then
				ErrorValueInt <= gf_mult_255(gf_mult_255(LatchedOmega(0), LatchedAlpha16(0)), InvElem);
			else
				ErrorValueInt <= x"00";
			end if;
			
			if LambdaEnIn(0) = '0' and LambdaEnIn(1) = '0' then
				Alpha16 <= gf_mult_255(Alpha16_2, "01001100");    -- "01001100" = alpha ^ 16 = gf(2, 8) ^ 16
			else
				Alpha16 <= "01001100";
			end if;
			
			Counter <= Counter + 1;
			if Counter = 3 then
				ErrorEnOutInt <= '1';
			else
				ErrorEnOutInt <= '0';
			end if;
			
			Alpha16_2 <= Alpha16;
			LambdaReg_2 <= LambdaReg;
			OmegaReg_2 <= OmegaReg;
			
			LatchedLambda(2) <= LambdaPolyval;
			LatchedOmega(2) <= OmegaPolyval;
			LatchedAlpha16(2) <= Alpha16;
			for i in 2 downto 1 loop
				LatchedLambda(i - 1) <= LatchedLambda(i);
				LatchedOmega(i - 1) <= LatchedOmega(i);
				LatchedAlpha16(i - 1) <= LatchedAlpha16(i);
			end loop;
			LambdaNew <= zLambdaDerivative;

		end if;	
	end process;
	
	altsyncram_component : altsyncram
	generic map(
		init_file => "rs_255_inv.mif",
		intended_device_family => "Arria V",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO", -- ?? 
		lpm_type => "altsyncram",
		numwords_a => 256,
		operation_mode => "ROM",
		outdata_reg_a => "CLOCK0",
		widthad_a => 8,
		width_a => 8
	)
	port map(
		address_a => LambdaNew,
		clock0 => Clk,
		clocken0 => EnIn,
		q_a => InvElem
	);

	ErrorEnOut <= ErrorEnOutInt;
	ErrorValue <= x"00" xor ErrorValueInt;
	
end beh;
