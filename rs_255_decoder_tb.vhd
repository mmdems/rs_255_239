library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;

entity rs_255_decoder_tb is
end rs_255_decoder_tb;

architecture tb of rs_255_decoder_tb is

component rs_255_decoder is
port(
     DataIn      : in std_logic_vector(63 downto 0);
     EnIn        : in std_logic;
     StartFrame  : in std_logic;
     Clk         : in std_logic
     );
end component;

	constant clk_period  : time := 10 ns; -- freq = 200 MHz
	signal T_DataIn      : std_logic_vector(63 downto 0);
	signal T_EnIn        : std_logic; 
	signal T_StartFrame  : std_logic;
	signal T_Clk         : std_logic;
	signal END_SIM       : boolean := false;
	type FileType is file of integer;
	signal DataCor       : std_logic_vector(63 downto 0);
	signal Err           : std_logic_vector(63 downto 0):= (others => '0');

begin
	DataCor <= T_DataIn xor Err;
	
	UUT: rs_255_decoder port map (DataCor, T_EnIn, T_StartFrame, T_Clk);
	process
	begin
	wait for 1 ns;
		while 1 = 1 loop
			Err <= x"0000000000000000";
			wait for 1 * clk_period;
			Err <= x"1234567890123456";
			wait for 1 * clk_period;
			Err <= x"0000000000000000";
			wait for 1 * clk_period;
			Err <= x"FFFFFFFFFFFFFFFF";
			wait for 1 * clk_period;
			Err <= (others => '0');
			wait for 506 * clk_period;
			end loop;
	end process;
	
	DATAIN:
	process
		variable v_DATAIN1 : std_logic_vector(31 downto 0);
		variable v_DATAIN2 : std_logic_vector(31 downto 0);
		variable v_TMP     : integer;
		variable v_COUNTER : integer range 0 to 2039 := 0;
		file INFILE        : FileType open read_mode is "datain.dat";
	begin
		T_StartFrame <= '0';
		file_open(INFILE, "datain.dat",  read_mode);
		while not endfile(INFILE) loop
			wait until T_Clk'event and T_Clk = '1' and T_EnIn = '1' and not endfile(INFILE);
				wait for 1 ns;
				read(INFILE, v_TMP);
				v_DATAIN1 := conv_std_logic_vector(v_TMP, 32);
				read(INFILE, v_TMP);
				v_DATAIN2 := conv_std_logic_vector(v_TMP, 32);
				T_DataIn <= (v_DATAIN2 & v_DATAIN1);
				if v_COUNTER = 0 then
					T_StartFrame <= '1';
					v_COUNTER := 2039;
				else
					T_StartFrame <= '0';
					v_COUNTER := v_COUNTER - 1;
				end if;
		end loop;
	end process;
	
	ENABLE:
	process
	begin
		if END_SIM = false then
			T_EnIn <= '1';
			-- wait for 510 * clk_period;
			-- T_EnIn <= '1';
			-- wait for 8 * clk_period;
			-- T_EnIn <= '0';
			-- wait for 8 * clk_period;
			-- T_EnIn <= '1';
			wait;
		else
			wait;
		end if;
	end process;
	
	CLOCK:
	process
	begin
		if END_SIM = false then
			T_Clk <= '1';
			wait for clk_period / 2;
		else
			wait;
		end if;
		if END_SIM = false then
			T_Clk <= '0';
			wait for clk_period / 2;
		else
			wait;
		end if;
	end process;

end tb;

