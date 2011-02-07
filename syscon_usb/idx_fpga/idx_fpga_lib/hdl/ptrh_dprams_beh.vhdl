--
-- VHDL Architecture idx_fpga_lib.ptrh_dprams.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:35:37 02/ 6/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY ptrh_dprams IS
   PORT (
      F25M    : IN     std_ulogic;
      F8M     : IN     std_ulogic;
      RdEn    : IN     std_ulogic;
      RegEn   : IN     std_logic_vector(12 DOWNTO 0);
      WrEn    : IN     std_ulogic_vector(12 DOWNTO 0);
      hold_D1 : IN     std_ulogic;
      hold_D2 : IN     std_ulogic;
      wData   : IN     std_logic_vector(15 DOWNTO 0);
      Full    : OUT    std_ulogic_vector(12 DOWNTO 0);
      iData   : OUT    std_logic_vector(15 DOWNTO 0)
   );
END ptrh_dprams;

--
ARCHITECTURE beh OF ptrh_dprams IS
   SIGNAL hold : std_logic_vector(12 DOWNTO 0);
   COMPONENT ptrh_dpram
      PORT (
         RegEn : IN     std_logic;
         F8M   : IN     std_ulogic;
         RdEn  : IN     std_ulogic;
         hold  : IN     std_logic;
         iData : OUT    std_logic_vector(15 DOWNTO 0);
         wData : IN     std_logic_vector(15 DOWNTO 0);
         WrEn  : IN     std_ulogic;
         F25M  : IN     std_ulogic;
         Full  : OUT    std_ulogic
      );
   END COMPONENT;
   FOR ALL : ptrh_dpram USE ENTITY idx_fpga_lib.ptrh_dpram;
BEGIN
  hold(12) <= hold_D2;
  hold(11) <= hold_D2;
  hold(10) <= hold_D1;
  hold(9) <= hold_D1;
  hold(8 DOWNTO 0) <= (others => '0');
  
  rams : for i in 0 to 12 generate
   ram : ptrh_dpram
      PORT MAP (
         RegEn => RegEn(i),
         F8M   => F8M,
         RdEn  => RdEn,
         hold  => hold(i),
         iData => iData,
         wData => wData,
         WrEn  => WrEn(i),
         F25M  => F25M,
         Full  => Full(i)
      );
  end generate;
END ARCHITECTURE beh;

