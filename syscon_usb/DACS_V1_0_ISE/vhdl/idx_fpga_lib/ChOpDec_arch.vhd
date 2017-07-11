--
-- VHDL Architecture idx_fpga_lib.ChOpDec.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:54:30 01/ 7/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY ChOpDec IS
  PORT( 
    ChanSel : IN     std_ulogic;
    OpCd    : IN     std_logic_vector (2 DOWNTO 0);
    CfgEn   : OUT    std_ulogic;
    CtEn    : OUT    std_ulogic;
    PosEn   : OUT    std_ulogic
  );

-- Declarations

END ENTITY ChOpDec ;

--
ARCHITECTURE arch OF ChOpDec IS
BEGIN
  -- This could be a conditional assignment, but is
  -- is not supported in VHDL-2002
  PROCESS (OpCd, ChanSel)
    BEGIN
      if ChanSel = '1' and OpCd = "110" then
        CfgEn <= '1';
      else
        CfgEn <= '0';
      end if;
      if ChanSel = '1' and OpCd = "100" then
        PosEn <= '1';
      else
        PosEn <= '0';
      end if;
      if ChanSel = '1' and OpCd(2) = '0' and OpCd(0) = '0' then
        CtEn <= '1';
      else
        CtEn <= '0';
      end if;
    END PROCESS;
END ARCHITECTURE arch;

