--
-- VHDL Architecture idx_fpga_lib.StepEnDef.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:30:10 01/11/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY StepEnDef IS
   PORT( 
      CMDENBL : IN     std_ulogic;
      Limit   : IN     std_ulogic;
      ZeroCt  : IN     std_ulogic;
      StepEn  : OUT    std_ulogic
   );

-- Declarations

END StepEnDef ;

--
ARCHITECTURE arch OF StepEnDef IS
BEGIN
  PROCESS (CMDENBL, Limit, ZeroCt )
    BEGIN
      IF CMDENBL = '1' AND ZeroCt /= '1' AND Limit /= '1' THEN
        StepEn <= '1';
      ELSE
        StepEn <= '0';
      END IF;
    END PROCESS;
END ARCHITECTURE arch;

