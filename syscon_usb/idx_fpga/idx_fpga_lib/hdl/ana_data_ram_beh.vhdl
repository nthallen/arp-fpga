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

ENTITY ana_data_ram IS
  PORT (
    RDEN    : IN std_ulogic;
    WREN    : IN std_ulogic;
    RD_DATA : OUT std_logic_vector(15 DOWNTO 0);
    WR_DATA : IN std_logic_vector(31 DOWNTO 0);
    RD_ADDR : IN std_logic_vector(8 DOWNTO 0);
    WR_ADDR : IN std_logic_vector(7 DOWNTO 0);
    RD_CLK  : IN std_ulogic;
    WR_CLK  : IN std_ulogic;
    RAM_BUSY : IN std_ulogic;
    RST     : IN std_ulogic
    );
END ENTITY ana_data_ram;

ARCHITECTURE beh OF ana_data_ram IS
   SIGNAL RAM_RD_DATA : std_logic_vector(31 DOWNTO 0);
   SIGNAL RAM_RD_EN   : std_ulogic;
   SIGNAL RD_DATA_int : std_logic_vector(15 DOWNTO 0);
   COMPONENT ana_ram
      PORT (
         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
         WREN    : IN     std_ulogic;
         RDEN    : IN     std_ulogic;
         RD_CLK  : IN     std_ulogic;
         WR_CLK  : IN     std_ulogic;
         RST     : IN     std_ulogic
      );
   END COMPONENT;

   COMPONENT ana_data_rd
      PORT (
         RAM_BUSY    : IN     std_ulogic;
         RAM_RD_DATA : IN     std_logic_vector(31 DOWNTO 0);
         RDEN        : IN     std_ulogic;
         RD_ADDR     : IN     std_logic_vector(8 DOWNTO 0);
         RD_CLK      : IN     std_ulogic;
         RST         : IN     std_ulogic;
         RAM_RD_EN   : OUT    std_ulogic;
         RD_DATA     : OUT    std_logic_vector(15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : ana_ram USE ENTITY idx_fpga_lib.ana_ram;
   FOR ALL : ana_data_rd USE ENTITY idx_fpga_lib.ana_data_rd;
BEGIN
   --  hds hds_inst
   ana_ram_i : ana_ram
      PORT MAP (
         RD_ADDR => RD_ADDR(8 DOWNTO 1),
         WR_ADDR => WR_ADDR,
         RD_DATA => RAM_RD_DATA,
         WR_DATA => WR_DATA,
         WREN    => WREN,
         RDEN    => RAM_RD_EN,
         RD_CLK  => RD_CLK,
         WR_CLK  => WR_CLK,
         RST     => RST
      );
   --  hds hds_inst
   rdctrl : ana_data_rd
      PORT MAP (
         RAM_BUSY    => RAM_BUSY,
         RAM_RD_DATA => RAM_RD_DATA,
         RDEN        => RDEN,
         RD_ADDR     => RD_ADDR,
         RD_CLK      => RD_CLK,
         RST         => RST,
         RAM_RD_EN   => RAM_RD_EN,
         RD_DATA     => RD_DATA_int
      );
  
  Out_En : Process (RDEN,RD_DATA_int) Is
  Begin
    if RDEN = '1' then
      RD_DATA <= RD_DATA_int;
    else
      RD_DATA <= (others => 'Z');
    end if;
  End Process;

END ARCHITECTURE beh;

