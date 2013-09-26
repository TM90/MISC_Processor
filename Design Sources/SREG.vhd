----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Tobias Markus
-- 
-- Create Date:    12:43:39 08/07/2013 
-- Design Name: 
-- Module Name:    SREG - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SREG is
	port(
				IN_A_31	: in std_logic;
				IN_A_0	: in std_logic;
				IN_B_31  : in std_logic;
				MODE		: in std_logic_vector(2 downto 0);
				ALU_OUT	: in std_logic_vector(31 downto 0);
				SREG_OUT : out std_logic_vector(2 downto 0)
			);
end SREG;

architecture Behavioral of SREG is

type sreg_type is record
	Zero  : std_logic;
	Neg   : std_logic;
	Carry : std_logic;
end record;

signal sreg_int : sreg_type;

begin

SREG_OUT <= sreg_int.Zero & sreg_int.Neg & sreg_int.Carry;

FuncMux:process(IN_A_31,IN_A_0,IN_B_31,MODE,ALU_OUT)
begin
		case MODE is 
			when "001" => -- add with carry
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg  		<= ALU_OUT(31);
				sreg_int.Carry 	<=	(IN_A_31 and IN_B_31) or
											(not ALU_OUT(31) and IN_A_31) or
											(not ALU_OUT(31) and IN_A_0);
			when "000" => -- add
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry 	<=	(IN_A_31 and IN_B_31) or
											(not ALU_OUT(31) and IN_A_31) or
											(not ALU_OUT(31) and IN_B_31);
			when "111" => -- sub with carry
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry 	<=	((not IN_A_31) and IN_B_31) or 
											(IN_B_31 and ALU_OUT(31)) or 
											(ALU_OUT(31) and (not IN_A_31));
			when "110" => -- sub
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry 	<=	((not IN_A_31) and IN_B_31) or 
											(IN_B_31 and ALU_OUT(31)) or 
											(ALU_OUT(31) and (not IN_A_31));
			when "010" => -- slr
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry		<= IN_A_0;
			when "011" => -- or
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry		<= '0';
			when "100" => -- and
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry		<= '0';
			when "101" => -- xor
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry		<= '0';
			when others => -- add
				if(ALU_OUT = x"00000000") then
					sreg_int.Zero 	<= '1';
				else
					sreg_int.Zero 	<= '0';
				end if;
				sreg_int.Neg 		<= ALU_OUT(31);
				sreg_int.Carry 	<=	(IN_A_31 and IN_B_31) or
											(not ALU_OUT(31) and IN_A_31) or
											(not ALU_OUT(31) and IN_B_31);
		end case;
end process;

end Behavioral;

