-- RiBM
-- folding factor = 24
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.rs_255_package.all;

entity rs_255_kes is
port(
		SyndromeIn   : in std_logic_vector(127 downto 0);
		Clk          : in std_logic;
		EnIn         : in std_logic;
		SyndromeEnIn : in std_logic;
		Lambda       : out std_logic_vector(71 downto 0);
		Omega        : out std_logic_vector(63 downto 0);
		LambdaEnOut  : out std_logic
	);
end entity;

architecture RiBM of rs_255_kes is
	type RegArray is array (25 downto 0) of std_logic_vector(7 downto 0);
	signal Theta          : RegArray;
	signal Delta          : RegArray;
	signal Counter        : integer range 0 to 16;
	signal Gamma          : std_logic_vector(7 downto 0);
	signal kReg           : std_logic_vector(5 downto 0); 
	signal LambdaEnOutInt : std_logic := '0';
begin
	process(Clk)
	begin	
		if rising_edge(Clk) and EnIn = '1' then
			if SyndromeEnIn = '1' then
				Delta <= (others => x"00");
				Theta <= (others => x"00");
				Delta(24) <= x"01";
				Theta(24) <= x"01";
				for i in 0 to 15 loop
					Delta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
					Theta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
				end loop;
				kReg <= (others => '0');
				Gamma <= x"01";
				Counter <= 0;
			else
				if Counter <= 15 then
					if Delta(0) /= x"00" and kReg(5) = '0' then
						kReg <= not kReg;
						Gamma <= Delta(0);
						for i in 24 downto 0 loop
							Theta(i) <= Delta(i + 1);
						end loop;						
					else
						kReg <= kReg + 1;		
					end if;
					for i in 24 downto 0 loop
						Delta(i) <= gf_mult_255(Delta(i + 1), Gamma) xor gf_mult_255(Delta(0), Theta(i));
					end loop;
					Counter <= Counter + 1;
				end if;
				if Counter = 15 then
					LambdaEnOutInt <= '1';
					Counter <= 16;
				else
					LambdaEnOutInt <= '0';
				end if;
			end if;
		end if;
	end process;

	OMEGA_GENERATE:
	for i in 0 to 7 generate
		Omega(7 + i * 8 downto i * 8) <= Delta(i);
	end generate;
	LAMBDA_GENERATE:
	for i in 0 to 8 generate
		Lambda(7 + i * 8 downto i * 8) <= Delta(8 + i);
	end generate;
	LambdaEnOut <= LambdaEnOutInt;
	
end RiBM;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

architecture UiBM3t of rs_255_kes is
	type RegArray is array (24 downto 0) of std_logic_vector(7 downto 0);
	signal Theta          : RegArray;
	signal Delta          : RegArray;
	signal CounterI       : integer range 0 to 24;
	signal Gamma          : std_logic_vector(7 downto 0);
	signal kReg           : std_logic_vector(5 downto 0);
	signal LambdaEnOutInt : std_logic := '0';
begin
	process(Clk)
		variable MultMux      : std_logic_vector(7 downto 0);
		variable CounterEnOut : integer range 0 to 510;
	begin
		if rising_edge(Clk) and EnIn = '1' then
			if SyndromeEnIn = '1' then
				Delta <= (others => x"00");
				Theta <= (others => x"00");
				Delta(24) <= x"01";
				Theta(24) <= x"01";
				for i in 0 to 15 loop
					Delta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
					Theta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
				end loop;
				kReg <= (others => '0');
				Gamma <= x"01";
				CounterI <= 0;
				CounterEnOut := 0;
			else		
				if CounterI <= 24 then
					if CounterI = 24 then
						if Delta(0) /= x"00" and kReg(5) = '0' then
							kReg <= not kReg;
							Gamma <= Delta(0);
							Theta(24) <= x"00";
						else
							kReg <= kReg + 1;
							Theta(24) <= Theta(0);
						end if;
						Delta(0) <= Delta(1);
					else
						if Delta(0) /= x"00" and kReg(5) = '0' then
							Theta(24) <= Delta(1);
						else
							Theta(24) <= Theta(0);
						end if;
					end if;
					if CounterI = 24  then
						MultMux := x"00";
					else
						 MultMux := Delta(1);
					end if;
							  
					Delta(24) <= gf_mult_255(MultMux, Gamma) xor gf_mult_255(Delta(0), Theta(0));					
					for i in 24 downto 1 loop
						Theta(i - 1) <= Theta(i);
					end loop;					
					for j in 24 downto 2 loop
						Delta(j - 1) <= Delta(j);
					end loop;	
				end if;	
				if CounterI = 24 then
					CounterI <= 0;
				else
					CounterI <= CounterI + 1;
				end if;	
			end if;
			if CounterEnOut = 400 then
				LambdaEnOutInt <= '1';
			else
				LambdaEnOutInt <= '0';
			end if;
			CounterEnOut := CounterEnOut + 1;
		end if;
	end process;

	OMEGA_GENERATE:
	for i in 0 to 7 generate
		Omega(7 + i * 8 downto i * 8) <= Delta(i);
	end generate;
	LAMBDA_GENERATE:
	for i in 0 to 8 generate
		Lambda(7 + i * 8 downto i * 8) <= Delta(8 + i);
	end generate;
	LambdaEnOut <= LambdaEnOutInt;
end UiBM3t;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- architecture TiBM of rs_255_kes is
	-- type RegArray is array (18 downto 0) of std_logic_vector(7 downto 0);
	-- signal Theta          : RegArray;
	-- signal Delta          : RegArray;
	-- signal Counter        : integer range 0 to 16;
	-- signal Gamma          : std_logic_vector(7 downto 0);
	-- signal kReg           : std_logic_vector(5 downto 0); 
	-- signal LambdaEnOutInt : std_logic := '0';
	-- signal cnt : std_logic;
-- begin
	-- process(Clk)
		-- variable MuxGen1   : std_logic_vector(26 downto 0) := "101000010101010101110000000";
		-- variable MuxGen2   : std_logic_vector(26 downto 0) := "010101010101010101000000000";
		-- variable MuxSignal : std_logic_vector(26 downto 0);
		-- variable ThetaVar  : std_logic_vector(7 downto 0);
		-- variable DeltaVar  : std_logic_vector(7 downto 0);
	-- begin
		-- if rising_edge(Clk) and EnIn = '1' then
			-- if SyndromeEnIn = '1' then
				-- Delta <= (others => x"00");
				-- Theta <= (others => x"00");
				-- Delta(17) <= x"01";
				-- Theta(17) <= x"01";
				-- for i in 0 to 15 loop
					-- Delta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
					-- Theta(15 - i) <= SyndromeIn(7 + i * 8 downto i * 8);
				-- end loop;
				-- kReg <= (others => '0');
				-- Gamma <= x"01";
				-- Counter <= 0;
				-- cnt <= '0';
			-- else
				-- MuxSignal := MuxGen1 when cnt = '1' else
							 -- MuxGen2;
				-- if cnt = '1' then
					-- MuxGen1 := "10" & MuxGen1(26 downto 11) & '1' & MuxGen1(8 downto 1);
				-- end if;
				-- cnt <= not cnt;
				-- if Counter <= 15 then	
					-- if Counter = 14 or Counter = 15 then
						-- MuxSignal := "010101010101010101000000000";
					-- end if;	
					-- for i in 8 downto 0 loop
						-- ThetaVar := Theta(8 + i) when MuxSignal(i) = '1' else -- MUX(2) of PE2
									-- Theta(9 + i);
						-- DeltaVar := Delta(10 + i) when MuxSignal(9 + i * 2 + 1 downto 9 + i * 2) = "01" else -- MUX(1) of PE2
									-- Delta(9 + i) when MuxSignal(9 + i * 2 + 1 downto 9 + i * 2) = "10" else
									-- x"00";
						-- Delta(i) <= gf_mult_255(Delta(i + 1), Gamma) xor gf_mult_255(Delta(0), Theta(i)); -- PE1
						-- Delta(9 + i) <= gf_mult_255(DeltaVar, Gamma) xor gf_mult_255(Delta(0), ThetaVar); -- PE2
						-- if Delta(0) /= x"00" and kReg(5) = '0' then -- MC = '1'
							-- kReg <= not kReg;
							-- Gamma <= Delta(0);
							-- Theta(i) <= Delta(i + 1); -- PE1
							-- Theta(9 + i) <= DeltaVar; -- PE2
						-- else -- MC = '0'
							-- kReg <= kReg + 1;
							-- Theta(9 + i) <= ThetaVar; -- PE2
						-- end if;
					-- end loop;
					-- Counter <= Counter + 1;
				-- end if;
				-- if Counter = 15 then
					-- LambdaEnOutInt <= '1';
					-- Counter <= 16;
				-- else
					-- LambdaEnOutInt <= '0';
				-- end if;
			-- end if;
		-- end if;
	-- end process;

	-- OMEGA_GENERATE:
	-- for i in 0 to 7 generate
		-- Omega(7 + i * 8 downto i * 8) <= Delta(i);
	-- end generate;
	-- LAMBDA_GENERATE:
	-- for i in 0 to 8 generate
		-- Lambda(7 + i * 8 downto i * 8) <= Delta(8 + i);
	-- end generate;
	-- LambdaEnOut <= LambdaEnOutInt;

-- end TiBM;
