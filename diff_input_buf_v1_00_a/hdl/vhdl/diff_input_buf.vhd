-- Differential Input Buffer IP Core VHDL Soure Code
-- Kieran O' Leary - 11th June 2004

-- Description: This core will take two differential bus inputs "DIFF_INPUT_P" and "DIFF_INPUT_N" and convert it to a single-ended input bus 
-- "SINGLE_ENDED_INPUT". SINGLE_ENDED_INPUT<0> will be associated with DIFF_INPUT_P<0> and DIFF_INPUT_N<0> and so on.
-- By default the IOSTANDARD will be LVDS_25 but this can be changed along with the pin location in a UCF file.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity DIFF_INPUT_BUF is
    Generic (
    		  INPUT_BUS_WIDTH : integer := 4);
	 Port ( SINGLE_ENDED_INPUT : out std_logic_vector(INPUT_BUS_WIDTH-1 downto 0);
           DIFF_INPUT_P : in std_logic_vector(INPUT_BUS_WIDTH-1 downto 0);
			  DIFF_INPUT_N : in std_logic_vector(INPUT_BUS_WIDTH-1 downto 0));
end DIFF_INPUT_BUF;

architecture Behavioral of DIFF_INPUT_BUF is

	component IBUFDS
		port (O : out STD_ULOGIC;
			IB : in STD_ULOGIC;
			I : in STD_ULOGIC);
	end component;

begin

XPS_IBUFDS_IP_CORE_GENERATE: for i in 0 to INPUT_BUS_WIDTH-1 generate
  MULTIPLE_IBUFDS : IBUFDS
    port map (I => DIFF_INPUT_P(i), IB => DIFF_INPUT_N(i), O => SINGLE_ENDED_INPUT(i));
end generate;

end Behavioral;
