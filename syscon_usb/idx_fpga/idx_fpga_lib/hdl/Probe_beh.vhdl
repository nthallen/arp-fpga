--
-- VHDL Architecture idx_fpga_lib.Probe.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:05:19 02/ 1/2012
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY ProbeBuf IS
   PORT( 
      i : IN     std_logic;
      o : OUT    std_logic
   );

-- Declarations

END ProbeBuf ;

--
ARCHITECTURE beh OF ProbeBuf IS
BEGIN
  o <= i;
END ARCHITECTURE beh;

