----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Tobias Markus
-- 
-- Create Date:    09:48:35 10/08/2012 
-- Design Name: 
-- Module Name:    ProgMem - Behavioral 
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgMem is

	generic 
	(
		DATA_WIDTH : integer := 32;
		ADDR_WIDTH : integer := 10
	);

	port 
	(
		CLK		: in std_logic;
		WEA		: in std_logic;
		DINA		: in std_logic_vector((DATA_WIDTH -1) downto 0);
		TICK 		: in std_logic;
		addra		: in std_logic_vector ((ADDR_WIDTH - 1) downto 0);
		douta		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of ProgMem is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
	function init_ram
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			if(addr_pos=0) then 
				tmp(addr_pos) := "01010000000000000101010101010101"; -- load l r0 
			elsif(addr_pos=1) then
				tmp(addr_pos) := "01010000100000000101010101010101"; -- load h r0
			elsif(addr_pos=2) then
				tmp(addr_pos) := "01010001000000000101010101010101"; -- load l r1
			elsif(addr_pos=3) then
				tmp(addr_pos) := "01010001100000000101010101010101"; -- load h r1
			elsif(addr_pos=4) then
				tmp(addr_pos) := "00010000000000010000111000000000"; -- r0+r1=>r0	
			elsif(addr_pos=5) then
				tmp(addr_pos) := "00100000000000010000000000000000"; -- out r0,r1		
			elsif(addr_pos=6) then
				tmp(addr_pos) := "10010000000000010000000000000000"; -- in r0,r1	
			elsif(addr_pos=7) then
				tmp(addr_pos) := "11101111000000010000000000000000"; -- jmp 0x0000
			else
				tmp(addr_pos) := std_logic_vector(to_unsigned(0, DATA_WIDTH));-- NOP
			end if;
		end loop;
		return tmp;
	end init_ram;	
--	 Declare the RAM signal.	
	signal ram : memory_t := init_ram;

	-- Register to hold the address 
	signal addr_reg : std_logic_vector ((ADDR_WIDTH-1) downto 0);

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(WEA = '1') then
			ram(to_integer(unsigned(addra))) <= DINA;
		end if;

		-- Register the address for reading
		if(Tick='1') then
			addr_reg <= addra;
		end if;
	end if;
	end process;

	douta <= ram(to_integer(unsigned(addr_reg)));

end rtl;


