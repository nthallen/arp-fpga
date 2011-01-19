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
-- USE idx_fpga_lib.All;

ENTITY ana_cfg_ram IS
  PORT (
    RD_ADDR : IN std_logic_vector(7 DOWNTO 0);
    WR_ADDR : IN std_logic_vector(7 DOWNTO 0);
    RD_DATA : OUT std_logic_vector(8 DOWNTO 0);
    WR_DATA : IN  std_logic_vector(15 DOWNTO 0);
    WE0 : IN std_ulogic;
    WE1 : IN std_ulogic;
    RDEN : IN std_ulogic;
    RD_CLK : IN std_ulogic;
    WR_CLK : IN std_ulogic;
    RAM_BUSY : IN std_ulogic;
    RST  : IN std_ulogic
    );
END ENTITY ana_cfg_ram;

--
ARCHITECTURE beh OF ana_cfg_ram IS
   SIGNAL RD_DATA_int : std_logic_vector(31 DOWNTO 0);
   SIGNAL WR_DATA_int : std_logic_vector(31 DOWNTO 0);
   SIGNAL WREN    : std_ulogic;
   SIGNAL Written : std_ulogic;
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
         RD_CLK  => RD_CLK,
         WR_CLK  => WR_CLK,
         RST     => RST
      );

  Wr_En : Process (WR_CLK)
  Begin
    if WR_CLK'Event AND WR_CLK = '1' then
      if RST = '1' then
        WREN <= '0';
        Written <= '0';
      elsif Written = '0' AND RAM_BUSY = '0' AND WE0 = '1' and WE1 = '1' then
        WREN <= '1';
        Written <= '1';
      elsif Written = '1' then
        WREN <= '0';
        if WE0 /= '1' OR WE1 /= '1' then
          Written <= '0';
        end if;
      end if;
    end if;
  End Process;

  WR_DATA_int(15 DOWNTO 0) <= WR_DATA;
  WR_DATA_int(31 DOWNTO 16) <= (others => '0');
  RD_DATA <= RD_DATA_int(8 DOWNTO 0);
END ARCHITECTURE beh;

