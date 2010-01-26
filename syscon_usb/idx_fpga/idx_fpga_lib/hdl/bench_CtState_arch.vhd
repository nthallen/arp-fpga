--
-- VHDL Architecture idx_fpga_lib.bench_CtState.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:44:39 01/26/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_CtState IS
  PORT (
    Ld_o : OUT std_ulogic;
    ClkEn_o : OUT std_ulogic
  );
END ENTITY bench_CtState;

--
ARCHITECTURE arch OF bench_CtState IS
  SIGNAL CtEn : std_ulogic;
  SIGNAL PosEn : std_ulogic;
  SIGNAL WrEn : std_ulogic;
  SIGNAL RdEn : std_ulogic;
  SIGNAL StepClk : std_ulogic;
  SIGNAL F8M : std_ulogic;
  SIGNAL rst : std_ulogic;
  SIGNAL Ld : std_ulogic;
  SIGNAL ClkEn : std_ulogic;
  COMPONENT CtState IS
    PORT (
      CtEn : IN std_ulogic;
      PosEn : IN std_ulogic;
      WrEn : IN std_ulogic;
      RdEn : IN std_ulogic;
      StepClk : IN std_ulogic;
      F8M : IN std_ulogic;
      rst : IN std_ulogic;
      Ld : OUT std_ulogic;
      ClkEn : OUT std_ulogic
    );
  END COMPONENT;
BEGIN
  DUT : CtState
    PORT MAP (
      CtEn => CtEn,
      PosEn => PosEn,
      WrEn => WrEn,
      RdEn => RdEn,
      StepClk => StepClk,
      F8M => F8M,
      rst => rst,
      Ld => Ld,
      ClkEn => ClkEn
    );

  Ld_o <= Ld;
  ClkEn_o <= ClkEn;
  
  f8m_clk : Process
  Begin
    f8m <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    f8m <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;
  
  test_proc : Process
  Begin
    rst <= '1';
    CtEn <= '0';
    PosEn <= '0';
    WrEn <= '0';
    RdEn <= '0';
    StepClk <= '0';
    -- pragma synthesis_off
    wait for 20 ns;
    rst <= '0';
    wait for 250 ns;
    -- writing
    PosEn <= '1';
    wait for 100 ns;
    WrEn <= '1';
    wait for 500 ns;
    -- stepping
    StepClk <= '1';
    wait for 500 ns;
    WrEn <= '0';
    wait for 100 ns;
    PosEn <= '0';
    wait for 200 ns;
    StepClk <= '0';
    wait for 100 ns;
    -- writing and stepping
    PosEn <= '1';
    wait for 200 ns;
    WrEn <= '1';
    StepClk <= '1';
    wait for 1 us;
    WrEn <= '0';
    wait for 200 ns;
    StepClk <= '0';
    PosEn <= '0';
    wait for 100 ns;
    -- reading
    PosEn <= '1';
    wait for 100 ns;
    RdEn <= '1';
    wait for 200 ns;
    StepClk <= '1';
    wait for 800 ns;
    RdEn <= '0';
    wait for 400 ns;
    StepClk <= '0';
    --  and stepping
    wait;
    -- pragma synthesis_on
  End Process;

END ARCHITECTURE arch;

