library IEEE;
use IEEE.std_logic_1164.all;

package rs_255_package is
	function gf_mult_255(
                      a: in std_logic_vector(7 downto 0);
                      b: in std_logic_vector(7 downto 0)
                      )
	return std_logic_vector;
	
end rs_255_package;

package body rs_255_package is

	function gf_mult_255(
                          a: in std_logic_vector(7 downto 0);
                          b: in std_logic_vector(7 downto 0)
                          )
		return std_logic_vector is
  		variable c: std_logic_vector(7 downto 0);
	begin
  		c(7) := (a(0) and b(7)) xor (a(1) and b(6)) xor (a(2) and b(5)) xor (a(3) and b(4)) xor (a(4) and b(3)) xor (a(4) and b(7)) xor
				(a(5) and b(2)) xor (a(5) and b(6)) xor (a(5) and b(7)) xor (a(6) and b(1)) xor (a(6) and b(5)) xor (a(6) and b(6)) xor
				(a(6) and b(7)) xor (a(7) and b(0)) xor (a(7) and b(4)) xor (a(7) and b(5)) xor (a(7) and b(6));

		c(6) := (a(0) and b(6)) xor (a(1) and b(5)) xor (a(2) and b(4)) xor (a(3) and b(3)) xor (a(3) and b(7)) xor (a(4) and b(2)) xor
				(a(4) and b(6)) xor (a(4) and b(7)) xor (a(5) and b(1)) xor (a(5) and b(5)) xor (a(5) and b(6)) xor (a(5) and b(7)) xor 
				(a(6) and b(0)) xor (a(6) and b(4)) xor (a(6) and b(5)) xor (a(6) and b(6)) xor (a(7) and b(3)) xor (a(7) and b(4)) xor
				(a(7) and b(5));
	
		c(5) := (a(0) and b(5)) xor (a(1) and b(4)) xor (a(2) and b(3)) xor (a(2) and b(7)) xor (a(3) and b(2)) xor (a(3) and b(6)) xor
				(a(3) and b(7)) xor (a(4) and b(1)) xor (a(4) and b(5)) xor (a(4) and b(6)) xor (a(4) and b(7)) xor (a(5) and b(0)) xor
				(a(5) and b(4)) xor (a(5) and b(5)) xor (a(5) and b(6)) xor (a(6) and b(3)) xor (a(6) and b(4)) xor (a(6) and b(5)) xor
				(a(7) and b(2)) xor (a(7) and b(3)) xor (a(7) and b(4));
	
		c(4) := (a(0) and b(4)) xor (a(1) and b(3)) xor (a(1) and b(7)) xor (a(2) and b(2)) xor (a(2) and b(6)) xor (a(2) and b(7)) xor
				(a(3) and b(1)) xor (a(3) and b(5)) xor (a(3) and b(6)) xor (a(3) and b(7)) xor (a(4) and b(0)) xor (a(4) and b(4)) xor 
				(a(4) and b(5)) xor (a(4) and b(6)) xor (a(5) and b(3)) xor (a(5) and b(4)) xor (a(5) and b(5)) xor (a(6) and b(2)) xor
				(a(6) and b(3)) xor (a(6) and b(4)) xor (a(7) and b(1)) xor (a(7) and b(2)) xor (a(7) and b(3)) xor (a(7) and b(7));
	
		c(3) := (a(0) and b(3)) xor (a(1) and b(2)) xor (a(1) and b(7)) xor (a(2) and b(1)) xor (a(2) and b(6)) xor (a(2) and b(7)) xor
				(a(3) and b(0)) xor (a(3) and b(5)) xor (a(3) and b(6)) xor (a(4) and b(4)) xor (a(4) and b(5)) xor (a(4) and b(7)) xor
				(a(5) and b(3)) xor (a(5) and b(4)) xor (a(5) and b(6)) xor (a(5) and b(7)) xor (a(6) and b(2)) xor (a(6) and b(3)) xor
				(a(6) and b(5)) xor (a(6) and b(6)) xor (a(7) and b(1)) xor (a(7) and b(2)) xor (a(7) and b(4)) xor (a(7) and b(5));
	
		c(2) := (a(0) and b(2)) xor (a(1) and b(1)) xor (a(1) and b(7)) xor (a(2) and b(0)) xor (a(2) and b(6)) xor (a(3) and b(5)) xor
				(a(3) and b(7)) xor (a(4) and b(4)) xor (a(4) and b(6)) xor (a(5) and b(3)) xor (a(5) and b(5)) xor (a(5) and b(7)) xor
				(a(6) and b(2)) xor (a(6) and b(4)) xor (a(6) and b(6)) xor (a(6) and b(7)) xor (a(7) and b(1)) xor (a(7) and b(3)) xor
				(a(7) and b(5)) xor (a(7) and b(6));
	
		c(1) := (a(0) and b(1)) xor (a(1) and b(0)) xor (a(2) and b(7)) xor (a(3) and b(6)) xor (a(4) and b(5)) xor (a(5) and b(4)) xor 
				(a(6) and b(3)) xor (a(6) and b(7)) xor (a(7) and b(2)) xor (a(7) and b(6)) xor (a(7) and b(7));
	
		c(0) := (a(0) and b(0)) xor (a(1) and b(7)) xor (a(2) and b(6)) xor (a(3) and b(5)) xor (a(4) and b(4)) xor (a(5) and b(3)) xor
				(a(5) and b(7)) xor (a(6) and b(2)) xor (a(6) and b(6)) xor (a(6) and b(7)) xor (a(7) and b(1)) xor (a(7) and b(5)) xor
				(a(7) and b(6)) xor (a(7) and b(7));
  		return c;
	end;

end package body rs_255_package;