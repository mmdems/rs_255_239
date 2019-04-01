library IEEE;
use IEEE.std_logic_1164.all;

entity rs_255_decoder is
port(
     DataIn      : in std_logic_vector(63 downto 0);
     Clk         : in std_logic;
     EnIn        : in std_logic;
     StartFrame  : in std_logic;
	 DataOut     : out std_logic_vector(63 downto 0);
	 EnOut		 : out std_logic;
	 StartOut    : out std_logic
     );
end rs_255_decoder;

architecture beh of rs_255_decoder is
	signal EvenOdd           : std_logic := '0';
	signal StartWord         : std_logic;
	signal StartWordCounter  : integer range 0 to 509 := 508;
	signal SyndromeEnableOut : std_logic_vector(1 downto 0);
	type ShiftRegs is array (914 downto 0) of std_logic_vector(64 downto 0);
	signal DataInDelayed     : ShiftRegs;
	signal ErrorOut          : std_logic_vector(63 downto 0);
	signal ErrorEnIn         : std_logic_vector(7 downto 0);
	signal EnCsee            : std_logic_vector(15 downto 0);
begin

	EnOut <= EnIn;
	process(Clk)
		variable ErrorOutRvrsd : std_logic_vector(63 downto 0);
	begin	
		if Clk'event and Clk = '1' and EnIn = '1' then
			if StartFrame = '1' then
				EvenOdd <= '0';
				StartWordCounter <= 0;
			else
				EvenOdd <= not EvenOdd;
				if StartWordCounter = 509 then
					StartWordCounter <= 0;
				else
					StartWordCounter <= StartWordCounter + 1;
				end if;
			end if;
			
			if StartWordCounter = 508 or StartWordCounter = 509 then
				StartWord <= '1';
			else
				StartWord <= '0';
			end if;
			
			if StartWordCounter = 507 then
				SyndromeEnableOut(0) <= '1';
			else
				SyndromeEnableOut(0) <= '0';
			end if;
			if StartWordCounter = 508 then
				SyndromeEnableOut(1) <= '1';
			else
				SyndromeEnableOut(1) <= '0';
			end if;
						
			DataInDelayed <= (StartFrame & DataIn) & DataInDelayed (914 downto 1);
			
			DATA_RVRSD:
			for i in 0 to 7 loop
				for j in 0 to 7 loop
					ErrorOutRvrsd(i * 8 + j) := ErrorOut(i * 8 + 7 - j);
				end loop;
			end loop;
			DataOut <= DataInDelayed(0)(63 downto 0) xor ErrorOutRvrsd;
			StartOut <= DataInDelayed(0)(64);
						
		end if;
	end process;

	DECODER:
	for i in 0 to 7 generate
		signal SyndromeOut : std_logic_vector(1023 downto 0);
		signal Lambda      : std_logic_vector(143 downto 0);
		signal Omega       : std_logic_vector(127 downto 0);
		signal LambdaEnOut : std_logic_vector(1 downto 0);
	begin
		CLC: entity work.rs_255_synd 
		port map(
			DataIn => DataIn(7 + 8 * i downto 8 * i), 
			Clk => Clk,
			EnIn => EnIn,
			StartWord => StartWord,
			EvenOddIn => EvenOdd,
			SyndromeOut => SyndromeOut(127 + 128 * i downto 128 * i)
		);	
		
		-- KESRiBM_CSEE:
		-- for j in 0 to 1 generate
			-- signal LambdaEnOut : std_logic;
			-- signal Lambda      : std_logic_vector(71 downto 0);
			-- signal Omega       : std_logic_vector(63 downto 0);
			-- signal ErrorEnOut  : std_logic;
		-- begin
			-- KES: entity work.rs_255_kes(RiBM)
			-- port map(
				-- SyndromeIn => SyndromeOut(127 + 128 * i downto 128 * i),
				-- Clk => Clk,
				-- EnIn => EnIn,
				-- SyndromeEnIn => SyndromeEnableOut(j),
				-- Lambda => Lambda,
				-- Omega => Omega,
				-- LambdaEnOut => LambdaEnOut
			-- );
			
		KES_UiBM3t:
		for j in 0 to 1 generate
		begin
			KES: entity work.rs_255_kes(UiBM3t)
			port map(
				SyndromeIn => SyndromeOut(127 + 128 * i downto 128 * i),
				Clk => Clk,
				EnIn => EnIn,
				SyndromeEnIn => SyndromeEnableOut(j),
				Lambda => Lambda(71 + 72 * j downto 72 * j),
				Omega => Omega(63 + 64 * j downto 64 * j),
				LambdaEnOut => LambdaEnOut(j)
			);
		end generate;
							
		CSEE: entity work.rs_255_csee
		port map(
			Clk => Clk,
			EnIn => EnIn,
			LambdaEnIn => LambdaEnOut,
			LambdaIn => Lambda,
			OmegaIn => Omega,
			ErrorValue => ErrorOut(7 + 8 * i downto 8 * i),
			ErrorEnOut => ErrorEnIn(i)
		);
	
	end generate;
end beh;