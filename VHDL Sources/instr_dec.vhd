----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Tobias Markus
-- 
-- Create Date:    12:52:58 08/08/2013 
-- Design Name: 
-- Module Name:    instr_dec - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_dec is
	generic(
		ADDR_WIDTH : integer := 10
	);
	port(
		CLK 						: in std_logic;
		RST 						: in std_logic;
		INSTR						: in std_logic_vector(31 downto 0);
		ProgMem_WEA				: out std_logic; 
		PC_TICK					: out std_logic; 
		PC_EN_JMP				: out std_logic; 
		PC_JUMP					: out std_logic_vector(ADDR_WIDTH-1 downto 0); 
		rf_IN_WR					: out std_logic; 
		rf_SREG_EN				: out std_logic; 
		rf_SEL					: out std_logic; 
		rf_MOD_SREG				: out std_logic;
		rf_IN_MODE				: out std_logic_vector(1 downto 0); 
		rf_OUT_MODE				: out std_logic; 
		rf_ADDR_IN				: out std_logic_vector(3 downto 0); 
		rf_ADDR_OUT0			: out std_logic_vector(3 downto 0); 
		rf_ADDR_OUT1			: out std_logic_vector(3 downto 0); 
		rf_INPUT_INSTR_DEC 	: out std_logic_vector(31 downto 0); 
		rf_SREG_MASK			: out std_logic_vector(2 downto 0); 
		db_ADDR					: out std_logic_vector(31 downto 0);
		db_WR						: out std_logic;
		db_RD						: out std_logic;
		ALU_MODE					: out std_logic_vector(2 downto 0); 
		OUTPUT_ALU1				: in std_logic_vector(31 downto 0);
		rf_SREG_OUT				: in std_logic_vector(2 downto 0)
	);
end instr_dec;

architecture Behavioral of instr_dec is

signal instr_int : std_logic_vector(31 downto 0);

begin
	rf_ADDR_IN		<= INSTR(27 downto 24);
	rf_ADDR_OUT0	<= INSTR(23 downto 20);
	rf_ADDR_OUT1	<= INSTR(19 downto 16);
	
	Pipeline:process(CLK,RST)
	begin
		if(RST='1') then
			instr_int <= (others => '0');
		elsif(rising_edge(CLK)) then
			instr_int <= INSTR;
		end if;
	end process;
	
	Dec_P:process(INSTR,OUTPUT_ALU1,instr_int,rf_SREG_OUT)
	begin
		ProgMem_WEA				<= '0';
		PC_TICK 					<= '1';
		PC_EN_JMP				<= '0';
		PC_JUMP					<= (others=>'0');
		rf_SREG_EN				<= '1';
		rf_SEL					<= '0';
		rf_IN_MODE 				<= INSTR(31 downto 30);
		rf_OUT_MODE 			<= INSTR(29);
		rf_IN_WR					<= INSTR(28);
		ALU_MODE 				<= INSTR(14 downto 12);
		rf_SREG_MASK			<= INSTR(11 downto 9);
		rf_INPUT_INSTR_DEC 	<= (others=>'0');
		db_WR						<= '0';
		db_RD 					<= '0';
		db_ADDR					<= (others=>'0');
		rf_MOD_SREG				<= '0';
		if(INSTR(30 downto 28) = "101" and INSTR(22)='0') then 	-- load
			rf_SREG_EN				<= '0';
			rf_SEL					<= INSTR(23);
			rf_INPUT_INSTR_DEC	<= "0000000000000000" & INSTR(15 downto 0);
		elsif(INSTR(30 downto 28) = "101" and INSTR(22)='1') then -- setsreg
			rf_SREG_EN				<= '0';
			rf_MOD_SREG				<= '1';
			rf_INPUT_INSTR_DEC	<= "0000000000000000000000000000000" & INSTR(23);
		elsif(INSTR(31 downto 28) = "1001") then 			-- in
			rf_SREG_EN				<= '0';
			db_RD 					<= '1';
			db_ADDR					<= OUTPUT_ALU1;
		elsif(INSTR(31 downto 28) = "0010") then 			-- out
			rf_SREG_EN				<= '0';
			db_WR						<= '1';
			db_ADDR					<= OUTPUT_ALU1;
		elsif(INSTR(31 downto 29) = "011") then 			-- branch
			rf_SREG_EN				<= '0';
			if(rf_SREG_OUT(to_integer(unsigned(INSTR(25 downto 24))))=INSTR(26)) then
				PC_EN_JMP				<= '1';
				PC_TICK 					<= '0';
				PC_JUMP					<= INSTR(ADDR_WIDTH-1 downto 0);
			end if;
			if(instr_int(31 downto 29) = "011") then
				PC_EN_JMP 			<= '0';
				PC_TICK 				<= '1';
			end if;
		elsif(INSTR(31 downto 24) = "11101111") then 	-- jump
			rf_SREG_EN				<= '0';
			PC_EN_JMP				<= '1';
			PC_TICK 					<= '0';
			PC_JUMP					<= INSTR(ADDR_WIDTH-1 downto 0);
			if(instr_int(31 downto 24) = "11101111") then
				PC_EN_JMP 			<= '0';
				PC_TICK 				<= '1';
			end if;
		elsif(INSTR(31 downto 24) = "11100000") then		-- call
			rf_SREG_EN			<= '0';
		elsif(INSTR(31 downto 24) = "00000000" and INSTR(0)='1') then 	-- return
			rf_SREG_EN			<= '0';
		end if;
	end process;

end Behavioral;

