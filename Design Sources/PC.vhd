----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Tobias Markus
-- 
-- Create Date:    12:03:22 10/11/2012 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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
use IEEE.numeric_std.all;

entity PC is
	 generic (
				ADDR_WIDTH : integer := 10
	 );
    port ( 
				CLK 		: in STD_LOGIC;
				RST		: in std_logic;
				TICK		: in std_logic;
				EN_JMP	: in std_logic;
				JUMP 		: in std_logic_vector(ADDR_WIDTH-1 downto 0);
				ADDRA 	: out std_logic_vector(ADDR_WIDTH-1 downto 0));
end PC;

architecture Behavioral of PC is

signal pointer : unsigned(ADDR_WIDTH-1 downto 0):=(others=>'0');

begin

ADDRA <=std_logic_vector(pointer);

Counter: process(CLK)
	begin
		if(rising_edge(CLK)) then
			if (RST='1') then
				pointer <=(others=>'0');
			else
				if(TICK='1') then  -- count when PC_SET.tick is true
					pointer <= pointer + "1"; 
				end if;
				if(EN_JMP='1') then -- for jump
					pointer <= unsigned(JUMP);
				end if;
			end if;
		end if;
	end process;
end Behavioral;

