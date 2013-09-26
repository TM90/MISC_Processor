----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 	Tobias Markus
-- 
-- Create Date:    10:13:31 08/02/2013 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port(
		IN_A	: in std_logic_vector(31 downto 0);
		IN_B	: in std_logic_vector(31 downto 0);
		MODE	: in std_logic_vector(2 downto 0);
		CARRY 	: in std_logic;
		ALU_OUT	: out std_logic_vector(31 downto 0)
	    );
end ALU;

architecture Behavioral of ALU is

begin
	FuncMux:process(IN_A,IN_B,CARRY,MODE)
	begin
		case MODE is 
			when "000" =>
				ALU_OUT <= std_logic_vector(unsigned(IN_A) + unsigned(IN_B));
			when "001" =>
				ALU_OUT <= std_logic_vector(unsigned(IN_A) + unsigned(IN_B));
				if(CARRY='1') then
					ALU_OUT <= std_logic_vector(unsigned(IN_A) + unsigned(IN_B) + "1");
				end if;
			when "010" =>
				ALU_OUT <= "0" & IN_A(31 downto 1);
			when "011" =>
				ALU_OUT <= IN_A or IN_B;
			when "100" =>
				ALU_OUT <= IN_A and IN_B;
			when "101" =>
				ALU_OUT <= IN_A xor IN_B;
			when "110" =>
				ALU_OUT <= std_logic_vector(unsigned(IN_A) - unsigned(IN_B));
			when "111" =>
				ALU_OUT <= std_logic_vector(unsigned(IN_A) - unsigned(IN_B));
				if(CARRY='1') then
					ALU_OUT <= std_logic_vector(unsigned(IN_A) - unsigned(IN_B) - "1");
				end if;
			when others =>
				ALU_OUT <= std_logic_vector(unsigned(IN_A) + unsigned(IN_B));
		end case;
	end process;
end Behavioral;

