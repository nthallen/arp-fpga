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
  PORT (
    Dir_o : OUT std_ulogic;
    InLimit_o : OUT std_ulogic;
    OutLimit_o : OUT std_ulogic;
    Run_o : OUT std_ulogic;
    Step_o : OUT std_ulogic;
    ZeroRef_o : OUT std_ulogic
  );
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
  SIGNAL WrIn : std_ulogic;
  SIGNAL Wrote : std_ulogic;

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

  f8m_clk : Process
  Begin
    f8m <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    f8m <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;
  
  WrEnbl : Process (F8M) Is
  Begin
    if F8M'Event and F8M = '1' then
      if WrIn = '1' then
        if Wrote = '1' then
          WrEn <= '0';
        else
          WrEn <= '1';
          Wrote <= '1';
        end if;
      else
        WrEn <= '0';
        Wrote <= '0';
      end if;
    end if;
  End Process;
  

  test_proc: Process

-- pragma synthesis_off
    Procedure CheckStatusBit( BitNo : IN natural; Val : IN std_logic; Tstr : IN string ) Is
    Begin
      --CfgEn <= '1';
      WrIn <= '0';
      RdEn <= '0';
      CfgEn <= '1';
      wait for 130 ns;
      RdEn <= '1';
      wait for 1 us;
      assert Data(BitNo) = Val report "Status Readback test " & Tstr & " failed" severity error;
      RdEn <= '0';
      wait for 100 ns;
      CfgEn <= '0';
      wait for 100 ns;
      return;
    End Procedure CheckStatusBit;
-- pragma synthesis_on

    -- pragma synthesis_off
    Procedure CheckStatusWord( Val : IN std_logic_vector (15 downto 0);
      Mask : IN std_logic_vector (15 downto 0);
      Tstr : IN string ) Is
    Begin
      --CfgEn <= '1';
      WrIn <= '0';
      RdEn <= '0';
      CfgEn <= '1';
      wait for 130 ns;
      RdEn <= '1';
      wait for 1 us;
      assert (Data AND Mask) = Val report "Status Readback test " & Tstr & " failed" severity error;
      RdEn <= '0';
      wait for 100 ns;
      CfgEn <= '0';
      wait for 100 ns;
      return;
    End Procedure CheckStatusWord;
-- pragma synthesis_on
    
    Procedure WriteCfg( CfgWd : std_logic_vector (15 downto 0) ) Is
    Begin
      WrIn <= '0';
      RdEn <= '0';
      CfgEn <= '1';
      Data <= CfgWd;
      -- pragma synthesis_off
      wait for 100 ns;
      WrIn <= '1';
      wait for 1 us;
      WrIn <= '0';
      wait for 100 ns;
      CfgEn <= '0';
      Data <= (others => 'Z');
      -- pragma synthesis_on
      return;
    End Procedure WriteCfg;
    
    Procedure ExerciseLimits( Pol : IN std_logic_vector (15 downto 0) ) Is
    Begin
      LimI <= '0';
      LimO <= '0';
      -- pragma synthesis_off
      wait for 130 ns;
      CheckStatusWord( X"0000" xor Pol, X"0003", "Lim00" );
      LimI <= '1';
      wait for 130 ns;
      CheckStatusWord( X"0001" xor Pol, X"0003", "Lim01" );
      LimO <= '1';
      wait for 130 ns;
      CheckStatusWord( X"0003" xor Pol, X"0003", "Lim11" );
      LimI <= '0';
      wait for 130 ns;
      CheckStatusWord( X"0002" xor Pol, X"0003", "Lim10" );
      -- pragma synthesis_on
      return;
    End Procedure;
    
    Procedure ExerciseSwapLimits( Pol : IN std_logic_vector (15 downto 0) ) Is
    Begin
      LimI <= '0';
      LimO <= '0';
      -- pragma synthesis_off
      CheckStatusWord( X"0000" xor Pol, X"0003", "SLim00" );
      LimI <= '1';
      CheckStatusWord( X"0002" xor Pol, X"0003", "SLim01" );
      LimO <= '1';
      CheckStatusWord( X"0003" xor Pol, X"0003", "SLim11" );
      LimI <= '0';
      CheckStatusWord( X"0001" xor Pol, X"0003", "SLim10" );
      -- pragma synthesis_on
      return;
    End Procedure;

  Begin
    CMDENBL <= '0';
    KillB <= '0';
    KillA <= '0';
    LimO <= '0';
    LimI <= '0';
    Running <= '0';
    DirOut <= '0';
    StepClk <= '0';
    ZR <= '0';
    WriteCfg( X"0020" );
    -- pragma synthesis_off
    CheckStatusWord( X"0000", X"0000", "Init" );
    ExerciseLimits( X"0000" );
    -- Swap Limit Switches
    WriteCfg( X"0021" );
    ExerciseSwapLimits( X"0000" );
    -- Invert In Limit, no swap
    WriteCfg( X"0060" );
    ExerciseLimits( X"0001" );
    -- Invert In Limit, swap
    WriteCfg( X"0061" );
    ExerciseSwapLimits( X"0001" );
    -- Invert Out Limit, no swap
    WriteCfg( X"00A0" );
    ExerciseLimits( X"0002" );
    -- Invert Out Limit, swap
    WriteCfg( X"00A1" );
    ExerciseSwapLimits( X"0002" );
    -- Test zero reference logic
    -- zero status on and off with and without polarity
    -- ZeroRef under the same conditions with and without enable
    ZR <= '0';
    WriteCfg( X"0020" );
    CheckStatusWord( X"0000", X"0040", "Zero0" );
    assert ZeroRef = '0' report "ZeroRef Error" severity error;
    ZR <= '1';
    CheckStatusWord( X"0040", X"0040", "Zero1" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    ZR <= '0';
    -- Zero disable
    WriteCfg( X"0022" );
    CheckStatusWord( X"0000", X"0040", "Zero2" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    ZR <= '1';
    CheckStatusWord( X"0040", X"0040", "Zero1b" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    -- Invert ZeroRef
    ZR <= '1';
    WriteCfg( X"1020" );
    CheckStatusWord( X"0000", X"0040", "Zero0b" );
    assert ZeroRef = '0' report "ZeroRef Error" severity error;
    ZR <= '0';
    CheckStatusWord( X"0040", X"0040", "Zero1d" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    ZR <= '1';
    -- Zero disable
    WriteCfg( X"1022" );
    CheckStatusWord( X"0000", X"0040", "Zero2c" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    ZR <= '0';
    CheckStatusWord( X"0040", X"0040", "Zero1d" );
    assert ZeroRef = '1' report "ZeroRef Error" severity error;
    wait;
    -- pragma synthesis_on
  End Process;

  Dir_o <= Dir;
  InLimit_o <= InLimit;
  OutLimit_o <= OutLimit;
  Run_o <= Run;
  Step_o <= Step;
  ZeroRef_o <= ZeroRef;

END ARCHITECTURE arch;

