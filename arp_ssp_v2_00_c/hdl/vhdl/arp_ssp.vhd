-- ARP SSP IP Core VHDL Soure Code
-- Norton Allen -- Oct 11, 2007

-- Description: First attempt at using XBD to handle differenital
-- inputs

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity ARP_SSP is
  Generic (
    INPUT_BUS_WIDTH : integer := 16 );
  Port (
    SSP_DATA_VALID_P: in std_logic;
    SSP_DATA_VALID_N: in std_logic;
    SSP_DATA_VALID: out std_logic;
    SSP_DATA_VALID_INV: out std_logic;
    SSP_DATA_P : in std_logic_vector(INPUT_BUS_WIDTH-1 downto 0);
    SSP_DATA_N : in std_logic_vector(INPUT_BUS_WIDTH-1 downto 0);
    SSP_DATA : out std_logic_vector(INPUT_BUS_WIDTH-1 downto 0);
    SSP_DATA_OOR_P: in std_logic;
    SSP_DATA_OOR_N: in std_logic;
    SSP_DATA_OOR: out std_logic
  );
end ARP_SSP;

architecture Behavioral of ARP_SSP is
signal DV: std_logic;
--	component IBUFDS
--	  port ( O : out STD_ULOGIC;
--	        IB : in STD_ULOGIC;
--		I : in STD_ULOGIC);
--	end component;

begin

  IBUFDS_DV : IBUFDS
   generic map (
      CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
      DIFF_TERM => TRUE, -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
      --IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
      --IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
      IOSTANDARD => "LVDS_25")
   port map (
      O => DV,  -- Clock buffer output
      I => SSP_DATA_VALID_P,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB => SSP_DATA_VALID_N -- Diff_n clock buffer input (connect directly to top-level port)
   );

  IBUFDS_OOR : IBUFDS
   generic map (
      CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
      DIFF_TERM => TRUE, -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
      --IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
      --IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
      IOSTANDARD => "LVDS_25")
   port map (
      O => SSP_DATA_OOR,  -- Clock buffer output
      I => SSP_DATA_OOR_P,  -- Diff_p clock buffer input (connect directly to top-level port)
      IB => SSP_DATA_OOR_N -- Diff_n clock buffer input (connect directly to top-level port)
   );

  ARP_SSP_IP_CORE_GENERATE: for i in 0 to INPUT_BUS_WIDTH-1 generate
    MULTIPLE_IBUFDS : IBUFDS
     generic map (
	CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
	DIFF_TERM => TRUE, -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
	--IBUF_DELAY_VALUE => "0", -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
	--IFD_DELAY_VALUE => "AUTO", -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
	IOSTANDARD => "LVDS_25")
      port map (I => SSP_DATA_P(i), IB => SSP_DATA_N(i), O => SSP_DATA(i));
  end generate;
  
  SSP_DATA_VALID <= DV;
  SSP_DATA_VALID_INV <= not DV;
end Behavioral;
