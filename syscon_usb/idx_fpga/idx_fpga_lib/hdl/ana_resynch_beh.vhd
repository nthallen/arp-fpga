--
-- VHDL Architecture idx_fpga_lib.ana_resynch.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:36:36 11/17/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_resynch IS
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F30M   : IN     std_ulogic;
      Addr1  : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd1 : OUT    std_ulogic;
      ExpWr1 : OUT    std_ulogic
   );

-- Declarations

END ana_resynch ;

--
ARCHITECTURE beh OF ana_resynch IS
BEGIN
  clocked: Process (F30M)
  BEGIN
    if F30M'Event AND F30M = '1' then
      Addr1 <= Addr;
      ExpRd1 <= ExpRd;
      ExpWr1 <= ExpWr;
    end if;
  End Process;
END ARCHITECTURE beh;

