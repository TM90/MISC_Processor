----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:47 08/08/2013 
-- Design Name: 
-- Module Name:    toplevel_processor - Behavioral 
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

entity toplevel_processor is
	 generic (
	 ProgMem_ADDR_WIDTH : integer := 10
	 );
    Port ( CLK 	: in  STD_LOGIC;
           RST 	: in  STD_LOGIC;
           DATA 	: inout  STD_LOGIC_VECTOR (31 downto 0);
			  ADDR	: out std_logic_vector(31 downto 0);
           RD 		: out  STD_LOGIC;
           WR 		: out  STD_LOGIC);
end toplevel_processor;

architecture Behavioral of toplevel_processor is

signal instr_int 				: std_logic_vector(31 downto 0);
signal progmem_wea_int 		: std_logic;
signal pc_tick_int			: std_logic;
signal pc_en_jmp_int			: std_logic;  
signal pc_jump_int			: std_logic_vector(ProgMem_ADDR_WIDTH-1 downto 0);
signal rf_in_wr_int			: std_logic;
signal rf_sreg_en_int		: std_logic;
signal rf_sel_int				: std_logic;
signal rf_in_mode_int		: std_logic_vector(1 downto 0);
signal rf_out_mode_int		: std_logic;
signal rf_addr_in_int		: std_logic_vector(3 downto 0);
signal rf_addr_out0_int		: std_logic_vector(3 downto 0);
signal rf_addr_out1_int		: std_logic_vector(3 downto 0);
signal rf_input_id_int		: std_logic_vector(31 downto 0);
signal rf_sreg_mask_int		: std_logic_vector(2 downto 0);
signal alu_mode_int			: std_logic_vector(2 downto 0);
signal input_loop_int		: std_logic_vector(31 downto 0);
signal input_sreg_int		: std_logic_vector(2 downto 0);
signal output_alu0_int		: std_logic_vector(31 downto 0);
signal output_alu1_int 		: std_logic_vector(31 downto 0);
signal pm_addr_int			: std_logic_vector(ProgMem_ADDR_WIDTH-1 downto 0);
signal rf_mod_sreg_int		: std_logic;
signal rf_sreg_out_int		: std_logic_vector(2 downto 0);

component instr_dec is
	generic(
		ADDR_WIDTH 				: integer := 10
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
		OUTPUT_ALU1				: in std_logic_vector(31 downto 0)
	);
end component;

component reg_file is
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
			SREG_OUT				: out std_logic_vector(2 downto 0)
			);
end component;

component ALU is
    port(
			IN_A					: in std_logic_vector(31 downto 0);
			IN_B					: in std_logic_vector(31 downto 0);
			MODE					: in std_logic_vector(2 downto 0);
			CARRY 				: in std_logic;
			ALU_OUT				: out std_logic_vector(31 downto 0)
	    );
end component;

component SREG is
	port(
			IN_A_31				: in std_logic;
			IN_A_0				: in std_logic;
			IN_B_31  			: in std_logic;
			MODE					: in std_logic_vector(2 downto 0);
			ALU_OUT				: in std_logic_vector(31 downto 0);
			SREG_OUT 			: out std_logic_vector(2 downto 0)
			);
end component;

component PC is
	 generic (
			ADDR_WIDTH 			: integer := 10
	 );
    port ( 
			CLK 					: in STD_LOGIC;
			RST					: in std_logic;
			TICK					: in std_logic;
			EN_JMP				: in std_logic;
			JUMP 					: in std_logic_vector(ADDR_WIDTH-1 downto 0);
			ADDRA 				: out std_logic_vector(ADDR_WIDTH-1 downto 0));
end component;

component ProgMem is

	generic (
			DATA_WIDTH 			: integer := 32;
			ADDR_WIDTH 			: integer := 10
	);

	port (
			CLK					: in std_logic;
			WEA					: in std_logic;
			DINA					: in std_logic_vector((DATA_WIDTH -1) downto 0);
			TICK 					: in std_logic;
			addra					: in std_logic_vector ((ADDR_WIDTH - 1) downto 0);
			douta					: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end component;

begin

	Inst_instr_dec: instr_dec
	generic map (
		ADDR_WIDTH 				=> 10
	 )	
	PORT MAP(
		CLK 						=> CLK,
		RST 						=> RST,
		INSTR 					=> instr_int,
		ProgMem_WEA 			=> progmem_wea_int,
		PC_TICK 					=> pc_tick_int,
		PC_EN_JMP				=> pc_en_jmp_int,
		PC_JUMP 					=> pc_jump_int,
		rf_IN_WR 				=> rf_in_wr_int,
		rf_SREG_EN 				=> rf_sreg_en_int,
		rf_SEL 					=> rf_sel_int,
		rf_MOD_SREG				=> rf_mod_sreg_int,
		rf_IN_MODE 				=> rf_in_mode_int,
		rf_OUT_MODE 			=> rf_out_mode_int,
		rf_ADDR_IN 				=> rf_addr_in_int,
		rf_ADDR_OUT0 			=> rf_addr_out0_int,
		rf_ADDR_OUT1 			=> rf_addr_out1_int,
		rf_INPUT_INSTR_DEC 	=> rf_input_id_int,
		rf_SREG_MASK 			=> rf_sreg_mask_int,
		db_ADDR 					=> ADDR,
		db_WR 					=> WR,
		db_RD 					=> RD,
		ALU_MODE 				=> alu_mode_int, 
		OUTPUT_ALU1				=> output_alu1_int
	);
	
	Inst_reg_file: reg_file 
	PORT MAP(
		CLK 						=> CLK,
		RST 						=> RST,
		IN_WR 					=> rf_in_wr_int,
		SREG_EN 					=> rf_sreg_en_int,
		IN_MODE 					=> rf_in_mode_int,
		OUT_MODE					=> rf_out_mode_int,
		SEL 						=> rf_sel_int,
		MOD_SREG					=> rf_mod_sreg_int,
		ADDR_IN 					=> rf_addr_in_int,
		ADDR_OUT0			 	=> rf_addr_out0_int,
		ADDR_OUT1 				=> rf_addr_out1_int,
		INPUT_LOOP 				=> input_loop_int,
		INPUT_INSTR_DEC 		=> rf_input_id_int,
		INPUT_DATA_BUS 		=> DATA,
		SREG_MASK 				=> rf_sreg_mask_int,
		INPUT_SREG 				=> input_sreg_int,
		OUTPUT_ALU0 			=> output_alu0_int,
		OUTPUT_ALU1 			=> output_alu1_int,
		OUTPUT_BYP 				=> DATA,
		SREG_OUT					=> rf_sreg_out_int
	);
	
	Inst_ALU: ALU 
	PORT MAP(
		IN_A 						=> output_alu0_int,
		IN_B 						=> output_alu1_int,
		MODE 						=> alu_mode_int,
		CARRY 					=> '0',
		ALU_OUT 					=> input_loop_int
	);
	
	Inst_SREG: SREG 
	PORT MAP(
		IN_A_31 					=> output_alu0_int(31),
		IN_A_0 					=> output_alu0_int(0),
		IN_B_31 					=> output_alu1_int(31),
		MODE 						=> alu_mode_int,
		ALU_OUT 					=> input_loop_int,
		SREG_OUT 				=> input_sreg_int
	);
	
	Inst_PC: PC 
	generic map (
		ADDR_WIDTH => 10
	 )
	PORT MAP(
		CLK 						=> CLK,
		RST 						=> RST,
		TICK 						=> pc_tick_int,
		EN_JMP 					=> pc_en_jmp_int,
		JUMP 						=> pc_jump_int,
		ADDRA 					=> pm_addr_int
	);
	
	Inst_ProgMem: ProgMem 
	generic map(
		DATA_WIDTH 				=> 32,
		ADDR_WIDTH 				=> 10
	)
	PORT MAP(
		CLK 						=> CLK,
		WEA 						=> progmem_wea_int,
		DINA 						=> x"00000000",
		TICK 						=> pc_tick_int,
		addra 					=> pm_addr_int,
		douta 					=> instr_int
	);
end Behavioral;

