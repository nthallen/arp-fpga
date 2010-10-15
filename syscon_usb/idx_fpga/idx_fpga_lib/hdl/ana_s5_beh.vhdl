--
-- VHDL Architecture idx_fpga_lib.ana_s5.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:14:23 10/15/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
-- Shift register SPI interface to
-- LMP7312 programmable amplifer/attenuator

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY ana_s5 IS
  GENERIC (
    DEF_CFG : std_ulogic_vector(4 DOWNTO 0) := "10100"
  );
  PORT (
    SDI : IN std_ulogic;
    SDO : OUT std_ulogic;
    SCK : OUT std_ulogic; -- 5 MHz max
    DI : IN std_ulogic_vector(4 DOWNTO 0);
    DO : OUT std_ulogic_vector(4 DOWNTO 0);
    WE : IN std_ulogic;
    Start : IN std_ulogic;
    CLK : IN std_ulogic; -- 30 MHz max
    RST : IN std_ulogic;
    RDY : OUT std_ulogic
  );
END ENTITY ana_s5;

--
ARCHITECTURE beh OF ana_s5 IS
  SIGNAL RDI : std_ulogic_vector(4 DOWNTO 0);
  COMPONENT ana_s5s
     PORT (
        DI    : IN     std_ulogic_vector(4 DOWNTO 0);
        SDI   : IN     std_ulogic;
        Start : IN     std_ulogic;
        clk   : IN     std_logic;
        rst   : IN     std_logic;
        DO    : OUT    std_ulogic_vector(4 DOWNTO 0);
        RDY   : OUT    std_ulogic;
        SCK   : OUT    std_ulogic;
        SDO   : OUT    std_ulogic
     );
  END COMPONENT;
  FOR ALL : ana_s5s USE ENTITY idx_fpga_lib.ana_s5s;
BEGIN
  SRDI : Process (CLK) IS
  Begin
    if CLK'Event AND CLK = '1' then
      if RST = '1' then
        RDI <= DEF_CFG;
      elsif WE = '1' then
        -- Could check here for overflow
        RDI <= DI;
      end if;
    end if;
  End Process;
   --  hds hds_inst
   ana_s5s_i : ana_s5s
      PORT MAP (
         DI    => DI,
         SDI   => SDI,
         Start => Start,
         clk   => CLK,
         rst   => RST,
         DO    => DO,
         RDY   => RDY,
         SCK   => SCK,
         SDO   => SDO
      );
END ARCHITECTURE beh;

