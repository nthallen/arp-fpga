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
USE idx_fpga_lib.all;

ENTITY ana_data_ram IS
  PORT (
    RDEN    : IN std_ulogic;
    DATAEN  : IN std_ulogic;
    WREN    : IN std_ulogic;
    RD_DATA : OUT std_logic_vector(15 DOWNTO 0);
    WR_DATA : IN std_logic_vector(31 DOWNTO 0);
    RD_ADDR : IN std_logic_vector(8 DOWNTO 0);
    WR_ADDR : IN std_logic_vector(7 DOWNTO 0);
    CLK     : IN std_ulogic;
    RST     : IN std_ulogic
    );
END ENTITY ana_data_ram;

ARCHITECTURE beh OF ana_data_ram IS
   SIGNAL RAM_RD_DATA : std_logic_vector(31 DOWNTO 0);
   SIGNAL RAM_RD_EN   : std_ulogic;
   SIGNAL RD_DATA_int : std_logic_vector(15 DOWNTO 0);
   SIGNAL RAM_BUSYR : std_ulogic;
--   COMPONENT ana_ram
--     generic (
--       INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
--       INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
--     );
--      PORT (
--         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
--         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
--         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
--         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
--         WREN    : IN     std_ulogic;
--         RDEN    : IN     std_ulogic;
--         CLK     : IN     std_ulogic;
--         RST     : IN     std_ulogic
--      );
--   END COMPONENT;

   COMPONENT ana_data_rd
      PORT (
         RAM_RD_DATA : IN     std_logic_vector(31 DOWNTO 0);
         RDEN        : IN     std_ulogic;
         DataEn      : IN     std_ulogic;
         RD_ADDR     : IN     std_logic_vector(8 DOWNTO 0);
         RD_CLK      : IN     std_ulogic;
         RST         : IN     std_ulogic;
         RAM_RD_EN   : OUT    std_ulogic;
         RD_DATA     : OUT    std_logic_vector(15 DOWNTO 0)
      );
   END COMPONENT;
-- FOR ALL : ana_ram USE ENTITY idx_fpga_lib.ana_ram;
   FOR ALL : ana_data_rd USE ENTITY idx_fpga_lib.ana_data_rd;
BEGIN
   ana_ram_i : entity ana_ram(sim)
      PORT MAP (
         RD_ADDR => RD_ADDR(8 DOWNTO 1),
         WR_ADDR => WR_ADDR,
         RD_DATA => RAM_RD_DATA,
         WR_DATA => WR_DATA,
         WREN    => WREN,
         RDEN    => RAM_RD_EN,
         CLK     => CLK,
         RST     => RST
      );
   --  hds hds_inst
   rdctrl : ana_data_rd
      PORT MAP (
         RAM_RD_DATA => RAM_RD_DATA,
         RDEN        => RDEN,
         DataEn      => DATAEN,
         RD_ADDR     => RD_ADDR,
         RD_CLK      => CLK,
         RST         => RST,
         RAM_RD_EN   => RAM_RD_EN,
         RD_DATA     => RD_DATA_int
      );
  
   RD_DATA <= RD_DATA_int;

END ARCHITECTURE beh;

