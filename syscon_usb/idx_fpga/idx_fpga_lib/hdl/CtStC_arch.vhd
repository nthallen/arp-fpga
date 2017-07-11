--
-- VHDL Architecture idx_fpga_lib.CtStC.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:41:01 01/26/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY CtStC IS
  PORT( 
    CtEn  : IN     std_ulogic;
    F8M   : IN     std_ulogic;
    PosEn : IN     std_ulogic;
    RdEn  : IN     std_ulogic;
    WrEn  : IN     std_ulogic;
    R     : OUT    std_ulogic;
    Ld    : OUT    std_ulogic
  );

-- Declarations

END ENTITY CtStC ;

--
ARCHITECTURE arch OF CtStC IS
BEGIN
  
  Process (F8M) Is
  Begin
    if F8M'Event and F8M = '1' then
      Ld <= WrEn and (PosEn or CtEn);
      R <= RdEn and PosEn;
    end if;
  End Process;
END ARCHITECTURE arch;

