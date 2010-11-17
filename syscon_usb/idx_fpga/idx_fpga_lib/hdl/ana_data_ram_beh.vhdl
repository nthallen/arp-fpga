--
-- VHDL Architecture idx_fpga_lib.ana_data_ram.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:02:13 11/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY ana_data_ram IS
  PORT (
    RDEN    : IN std_ulogic;
    WREN    : IN std_ulogic;
    RD_DATA : OUT std_logic_vector(15 DOWNTO 0);
    WR_DATA : IN std_logic_vector(31 DOWNTO 0);
    RD_ADDR : IN std_logic_vector(7 DOWNTO 0);
    WR_ADDR : IN std_logic_vector(7 DOWNTO 0);
    RD_CLK  : IN std_ulogic;
    WR_CLK  : IN std_ulogic;
    RST     : IN std_ulogic
    );
END ENTITY ana_data_ram;

--
ARCHITECTURE beh OF ana_data_ram IS
   SIGNAL WREN_int : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL RD_DATA_int : std_logic_vector(31 DOWNTO 0);
   COMPONENT ana_ram
      PORT (
         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
         WREN    : IN     std_ulogic_vector(1 DOWNTO 0);
         RDEN    : IN     std_ulogic;
         OE      : IN     std_ulogic;
         RD_CLK  : IN     std_ulogic;
         WR_CLK  : IN     std_ulogic;
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
         WR_DATA => WR_DATA,
         WREN    => WREN_int,
         RDEN    => RDEN,
         OE      => RDEN,
         RD_CLK  => RD_CLK,
         WR_CLK  => WR_CLK,
         RST     => RST
      );
  WREN_int(0) <= WREN;
  WREN_int(1) <= WREN;
  RD_DATA <= RD_DATA_int(15 DOWNTO 0);
END ARCHITECTURE beh;

