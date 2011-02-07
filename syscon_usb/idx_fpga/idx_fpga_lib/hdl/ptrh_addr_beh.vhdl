--
-- VHDL Architecture idx_fpga_lib.ptrh_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:39:31 02/ 4/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh_addr IS
   PORT( 
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      BdEn  : OUT    std_ulogic;
      RegEn : OUT    std_logic_vector (12 DOWNTO 0)
   );

-- Declarations

END ptrh_addr ;

--
ARCHITECTURE beh OF ptrh_addr IS
BEGIN
END ARCHITECTURE beh;

