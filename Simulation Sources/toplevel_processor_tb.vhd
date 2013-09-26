--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:14:31 08/09/2013
-- Design Name:   
-- Module Name:   D:/Praxis6/MISC/toplevel_processor_tb.vhd
-- Project Name:  MISC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: toplevel_processor
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY toplevel_processor_tb IS
END toplevel_processor_tb;
 
ARCHITECTURE behavior OF toplevel_processor_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT toplevel_processor
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         DATA : INOUT  std_logic_vector(31 downto 0);
         ADDR : OUT  std_logic_vector(31 downto 0);
         RD : OUT  std_logic;
         WR : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

	--BiDirs
   signal DATA : std_logic_vector(31 downto 0);

 	--Outputs
   signal ADDR : std_logic_vector(31 downto 0);
   signal RD : std_logic;
   signal WR : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toplevel_processor PORT MAP (
          CLK => CLK,
          RST => RST,
          DATA => DATA,
          ADDR => ADDR,
          RD => RD,
          WR => WR
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      RST <= '0';
      wait;
   end process;

END;
