--
-- VHDL Architecture idx_fpga_lib.bench_IO.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:14:26 01/15/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
-- Things I need to test:
-- Reading Back CMDENBL, KillA, KillB
-- InLimit Swap, Polarity, and Readback
-- OutLimit Swap, Polarity, and Readback
-- ZeroRef Enable, Polarity, and Readback
-- Dir Polarity and Readback
-- Run Polarity and Readback
-- Step Polarity
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_IO IS
END ENTITY bench_IO;

--
ARCHITECTURE arch OF bench_IO IS
  SIGNAL CMDENBL : std_ulogic;
  SIGNAL CfgEn : std_ulogic;
  SIGNAL DirOut : std_ulogic;
  SIGNAL F8M : std_ulogic;
  SIGNAL KillA : std_ulogic;
  SIGNAL KillB : std_ulogic;
  SIGNAL LimI : std_ulogic;
  SIGNAL LimO : std_ulogic;
  SIGNAL RdEn : std_ulogic;
  SIGNAL Running : std_ulogic;
  SIGNAL StepClk : std_ulogic;
  SIGNAL WrEn : std_ulogic;
  SIGNAL ZR : std_ulogic;
  SIGNAL Dir : std_ulogic;
  SIGNAL InLimit : std_ulogic;
  SIGNAL OutLimit : std_ulogic;
  SIGNAL Run : std_ulogic;
  SIGNAL Step : std_ulogic;
  SIGNAL ZeroRef : std_logic;
  SIGNAL Data : std_logic_vector ( 15 DOWNTO 0 );
  
  Procedure CheckStatus( BitNo : IN natural; Val : IN std_logic; Tstr : IN string ) Is
  Begin
    --CfgEn <= '1';
    WrEn <= '0';
    RdEn <= '0';
    wait for 1 us;
    RdEn <= '1';
    wait for 1 us;
    assert Data(BitNo) = Val report "Status Readback test " & Tstr & " failed" severity error;
    RdEn <= '0';
    wait for 1 us;
  End Procedure CheckStatus;

  COMPONENT IO IS
     PORT( 
        CMDENBL  : IN     std_ulogic;
        CfgEn    : IN     std_ulogic;
        DirOut   : IN     std_ulogic;
        F8M      : IN     std_ulogic;
        KillA    : IN     std_ulogic;
        KillB    : IN     std_ulogic;
        LimI     : IN     std_ulogic;
        LimO     : IN     std_ulogic;
        RdEn     : IN     std_ulogic;
        Running  : IN     std_ulogic;
        StepClk  : IN     std_ulogic;
        WrEn     : IN     std_ulogic;
        ZR       : IN     std_ulogic;
        Dir      : OUT    std_ulogic;
        InLimit  : OUT    std_ulogic;
        OutLimit : OUT    std_ulogic;
        Run      : OUT    std_ulogic;
        Step     : OUT    std_ulogic;
        ZeroRef  : OUT    std_logic;
        Data     : INOUT  std_logic_vector ( 15 DOWNTO 0 )
     );
  END COMPONENT;
BEGIN
  DUT : IO
     PORT MAP ( 
      CMDENBL => CMDENBL,
      CfgEn => CfgEn,
      DirOut => DirOut,
      F8M => F8M,
      KillA => KillA,
      KillB => KillB,
      LimI => LimI,
      LimO => LimO,
      RdEn => RdEn,
      Running => Running,
      StepClk => StepClk,
      WrEn => WrEn,
      ZR => ZR,
      Dir => Dir,
      InLimit => InLimit,
      OutLimit => OutLimit,
      Run => Run,
      Step => Step,
      ZeroRef => ZeroRef,
      Data => Data
     );

  Process
  Begin
    f8m <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    f8m <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;

END ARCHITECTURE arch;

