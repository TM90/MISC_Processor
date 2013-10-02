----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 		Tobias Markus
-- 
-- Create Date:    12:09:21 10/07/2012 
-- Design Name: 
-- Module Name:    reg_file - Behavioral 
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

entity reg_file is
	port(
			CLK					: in std_logic;
			RST 					: in std_logic;
			IN_WR					: in std_logic;
			SREG_EN				: in std_logic;
			IN_MODE				: in std_logic_vector(1 downto 0);
			OUT_MODE				: in std_logic;
			SEL					: in std_logic;
			MOD_SREG				: in std_logic;
			ADDR_IN				: in std_logic_vector(3 downto 0);
			ADDR_OUT0			: in std_logic_vector(3 downto 0);
			ADDR_OUT1			: in std_logic_vector(3 downto 0);
			INPUT_LOOP			: in std_logic_vector(31 downto 0);
			INPUT_INSTR_DEC	: in std_logic_vector(31 downto 0);
			INPUT_DATA_BUS		: in std_logic_vector(31 downto 0);
			SREG_MASK			: in std_logic_vector(2 downto 0);
			INPUT_SREG			: in std_logic_vector(2 downto 0);
			OUTPUT_ALU0			: out std_logic_vector(31 downto 0);
			OUTPUT_ALU1			: out std_logic_vector(31 downto 0);
			OUTPUT_BYP			: out std_logic_vector(31 downto 0);
			sreg_out				: out std_logic_vector(2 downto 0);
			STACK_EN				: in std_logic;
			STACK_DIR			: in std_logic
			);
end reg_file;

architecture Behavioral of reg_file is

type int_reg is array(15 downto 0) of std_logic_vector(31 downto 0);
signal reg_file_int 	: int_reg;
signal input_int : std_logic_vector(31 downto 0);
signal sreg : std_logic_vector(2 downto 0);

begin
	sreg_out <= sreg;
	IN_MUX:process(IN_MODE,INPUT_INSTR_DEC,INPUT_LOOP,INPUT_DATA_BUS) -- Input Multiplexer to select source
	begin 
		case IN_MODE is 
			when "00" =>
				input_int <= INPUT_LOOP;
			when "01" =>
				input_int <= INPUT_INSTR_DEC;
			when "10" =>
				input_int <= INPUT_DATA_BUS;
			when others =>
				input_int <= INPUT_LOOP;
		end case;
	end process;
	
	OUT_MUX:process(OUT_MODE,input_int,reg_file_int,ADDR_OUT0,ADDR_OUT1) -- Output Multiplexer to select target and output address
	begin
		case OUT_MODE is 
			when '0' =>
				OUTPUT_ALU0	<= reg_file_int(to_integer(unsigned((ADDR_OUT0))));
				OUTPUT_ALU1	<= reg_file_int(to_integer(unsigned((ADDR_OUT1))));
				OUTPUT_BYP  <= (others=>'0');
			when '1' =>
				OUTPUT_BYP 	<= reg_file_int(to_integer(unsigned((ADDR_OUT0))));
				OUTPUT_ALU0	<= (others=>'0');
				OUTPUT_ALU1 <= reg_file_int(to_integer(unsigned((ADDR_OUT1))));
			when others =>
				OUTPUT_BYP 	<= reg_file_int(to_integer(unsigned((ADDR_OUT0))));
				OUTPUT_ALU0	<= (others=>'0');
				OUTPUT_ALU1 <= reg_file_int(to_integer(unsigned((ADDR_OUT1))));
		end case;
	end process;
	
	ADDR_IN_P:process(CLK,RST) -- Select input address
	begin
		if(RST='1') then 
			for I in 0 to 15 loop
				reg_file_int(I) <= (others=>'0');
			end loop;
		elsif(rising_edge(CLK)) then
			if(SREG_EN='1') then
				sreg <= sreg or SREG_MASK or INPUT_SREG;
			end if;
			if(STACK_EN='1') then
				if(STACK_DIR='1') then
					reg_file_int(15)	<= std_logic_vector(unsigned(reg_file_int(15)) - "1"); 
				else
					reg_file_int(15)	<= std_logic_vector(unsigned(reg_file_int(15)) + "1");
				end if;
			end if;
			if(IN_WR='1') then
				reg_file_int(to_integer(unsigned(ADDR_IN)))	<=	input_int;
				if(IN_MODE = "01") then
					if (MOD_SREG = '1') then
						sreg(to_integer(unsigned(ADDR_IN))) 	<= input_int(0); 
					end if;
					if(SEL='1') then
						reg_file_int(to_integer(unsigned(ADDR_IN)))(31 downto 16)	<=	input_int(15 downto 0);
					else
						reg_file_int(to_integer(unsigned(ADDR_IN)))(15 downto 0)		<=	input_int(15 downto 0);
					end if;
				end if;
			end if;
		end if;
	end process;
end Behavioral;

