--
-- VHDL Test Bench idx_fpga_lib.bench_ctr_resynch.ctr_resynch_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:41:33 09/30/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ctr_resynch IS
END bench_ctr_resynch;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ctr_resynch IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL CtrsEn      : std_ulogic;
   SIGNAL clk       : std_logic;
   SIGNAL L2        : std_ulogic;
   SIGNAL LatchEdge : std_ulogic;
   SIGNAL RdEdge    : std_ulogic;
   SIGNAL RS        : std_ulogic;
   SIGNAL rst       : std_logic;
   SIGNAL StatEn    : std_ulogic;
   SIGNAL Done      : std_logic;


   -- Component declarations
   COMPONENT ctr_resynch
      PORT (
         CtrsEn    : IN     std_ulogic;
         clk       : IN     std_logic;
         L2        : OUT    std_ulogic;
         LatchEdge : IN     std_ulogic;
         RdEdge    : IN     std_ulogic;
         RS        : OUT    std_ulogic;
         rst       : IN     std_logic;
         StatEn    : IN     std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ctr_resynch : ctr_resynch USE ENTITY idx_fpga_lib.ctr_resynch;
   -- pragma synthesis_on

BEGIN
  
   DUT_ctr_resynch : ctr_resynch
    PORT MAP (
       CtrsEn    => CtrsEn,
       clk       => clk,
       L2        => L2,
       LatchEdge => LatchEdge,
       RdEdge    => RdEdge,
       RS        => RS,
       rst       => rst,
       StatEn    => StatEn
    );

  clock : Process
  Begin
    clk <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      clk <= '0';
      wait for 62.5 ns;
      clk <= '1';
      wait for 62.5 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  test_proc : Process
    procedure latch is
    begin
      -- pragma synthesis_off
      wait until clk'event and clk = '1';
      LatchEdge <= '1';
      wait until clk'event and clk = '1';
      -- pragma synthesis_on
      LatchEdge <= '0';
      return;
    end;

    procedure RdStat is
    begin
      -- pragma synthesis_off
      wait until clk'event and clk = '1';
      RdEdge <= '1';
      StatEn <= '1';
      wait until clk'event and clk = '1';
      -- pragma synthesis_on
      RdEdge <= '0';
      StatEn <= '0';
      return;
    end;
    
    procedure RdCtr is
    begin
      -- pragma synthesis_off
      wait until clk'event and clk = '1';
      RdEdge <= '1';
      CtrsEn <= '1';
      wait until clk'event and clk = '1';
      -- pragma synthesis_on
      RdEdge <= '0';
      CtrsEn <= '0';
      return;
    end;
  Begin
    Done <= '0';
    LatchEdge <= '0';
    RdEdge <= '0';
    CtrsEn <= '0';
    StatEn <= '0';
    rst <= '1';
    -- pragma synthesis_off
    wait for 300 ns;
    rst <= '0';
    wait for 300 ns;
    latch;
    RdStat;
    RdCtr;
    RdCtr;
    latch;
    RdStat;
    RdCtr;
    RdCtr;
    latch;
    RdCtr;
    RdCtr;
    RdStat;
    latch;
    RdStat;
    RdStat;
    latch;
    RdStat;
    RdCtr;
    latch;
    latch;
    RdStat;
    RdCtr;
    latch;
    RdStat;
    
    wait for 1000 ns;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

END rtl;