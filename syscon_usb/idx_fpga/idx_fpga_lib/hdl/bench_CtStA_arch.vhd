--
-- VHDL Architecture idx_fpga_lib.bench_CtStA.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:49:02 01/26/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_CtStA IS
END ENTITY bench_CtStA;

--
ARCHITECTURE arch OF bench_CtStA IS
  SIGNAL W : std_ulogic;
  SIGNAL F8M : std_ulogic;
  SIGNAL rst : std_ulogic;
  SIGNAL Ld : std_ulogic;
  SIGNAL Ldd : std_ulogic;
  COMPONENT CtStA IS
    PORT (
      W : IN std_ulogic;
      F8M : IN std_ulogic;
      rst : IN std_ulogic;
      Ld : OUT std_ulogic;
      Ldd : OUT std_ulogic
    );
  END COMPONENT;
BEGIN
  DUT : CtStA
    PORT MAP (
      W => W,
      F8M => F8M,
      rst => rst,
      Ld => Ld,
      Ldd => Ldd );

  f8m_clk : Process
  Begin
    f8m <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    f8m <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;

END ARCHITECTURE arch;

