--
-- VHDL Architecture idx_fpga_lib.ana_cfg_ram.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:39:19 11/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY ana_cfg_ram IS
  PORT (
    RD_ADDR : IN std_logic_vector(7 DOWNTO 0);
    WR_ADDR : IN std_logic_vector(7 DOWNTO 0);
    RD_DATA : OUT std_logic_vector(4 DOWNTO 0);
    WR_DATA : IN  std_logic_vector(15 DOWNTO 0);
    WE0 : IN std_ulogic;
    WE1 : IN std_ulogic;
    RDEN : IN std_ulogic;
    CLK  : IN std_ulogic;
    RST  : IN std_ulogic
    );
END ENTITY ana_cfg_ram;

--
ARCHITECTURE beh OF ana_cfg_ram IS
   SIGNAL RD_DATA_int : std_logic_vector(31 DOWNTO 0);
   SIGNAL WR_DATA_int : std_logic_vector(31 DOWNTO 0);
   SIGNAL WREN    : std_ulogic_vector(1 DOWNTO 0);
   COMPONENT ana_ram
      PORT (
         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
         WREN    : IN     std_ulogic_vector(1 DOWNTO 0);
         RDEN    : IN     std_ulogic;
         OE      : IN     std_ulogic;
         CLK     : IN     std_ulogic;
         RST     : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : ana_ram USE ENTITY idx_fpga_lib.ana_ram;
BEGIN
   --  hds hds_inst
   ana_ram_i : ana_ram
      PORT MAP (
         RD_ADDR => RD_ADDR,
         WR_ADDR => WR_ADDR,
         RD_DATA => RD_DATA_int,
         WR_DATA => WR_DATA_int,
         WREN    => WREN,
         RDEN    => RDEN,
         OE      => '1',
         CLK     => CLK,
         RST     => RST
      );
  WREN(0) <= WE0;
  WREN(1) <= WE1;
  WR_DATA_int(15 DOWNTO 0) <= WR_DATA;
  WR_DATA_int(31 DOWNTO 16) <= (others => '0');
  RD_DATA <= RD_DATA_int(4 DOWNTO 0);
END ARCHITECTURE beh;

