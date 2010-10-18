--
-- VHDL Test Bench idx_fpga_lib.bench_ana_acquire.ana_acquire_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:22:47 10/18/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ana_acquire IS
END bench_ana_acquire;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ana_acquire IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL CLK    : std_logic;
   SIGNAL Conv   : std_ulogic;
   SIGNAL NxtRow : std_ulogic_vector(2 DOWNTO 0);
   SIGNAL RdWrEn : std_ulogic;
   SIGNAL RdyIn  : std_ulogic;
   SIGNAL RdyOut : std_ulogic;
   SIGNAL RST    : std_logic;
   SIGNAL S5WE   : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL Start  : std_ulogic;
   SIGNAL Done   : std_ulogic;


   -- Component declarations
   COMPONENT ana_acquire
      PORT (
         Addr   : OUT    std_ulogic_vector(7 DOWNTO 0);
         CLK    : IN     std_logic;
         Conv   : IN     std_ulogic;
         NxtRow : OUT    std_ulogic_vector(2 DOWNTO 0);
         RdWrEn : OUT    std_ulogic;
         RdyIn  : IN     std_ulogic;
         RdyOut : OUT    std_ulogic;
         RST    : IN     std_logic;
         S5WE   : OUT    std_ulogic_vector(1 DOWNTO 0);
         Start  : OUT    std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_acquire : ana_acquire USE ENTITY idx_fpga_lib.ana_acquire;
   -- pragma synthesis_on

BEGIN

 DUT_ana_acquire : ana_acquire
    PORT MAP (
       Addr   => Addr,
       CLK    => CLK,
       Conv   => Conv,
       NxtRow => NxtRow,
       RdWrEn => RdWrEn,
       RdyIn  => RdyIn,
       RdyOut => RdyOut,
       RST    => RST,
       S5WE   => S5WE,
       Start  => Start
    );

  clock : Process
  Begin
    CLK <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      CLK <= '0';
      wait for 16 ns;
      CLK <= '1';
      wait for 17 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  rdy : Process
  Begin
    RdyIn <= '1';
    -- pragma synthesis_off
    wait for 100 ns;
    while Done = '0' loop
      wait until CLK'Event AND CLK = '1' AND Start = '1';
      RdyIn <= '0';
      for i in 1 to 31 loop
        wait until CLK'Event AND CLK = '1';
      end loop;
      RdyIn <= '1';
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : Process
    Begin
      Done <= '0';
      Conv <= '0';
      RST <= '1';
      -- pragma synthesis_off
      wait for 200 ns;
      RST <= '0';
      for i in 1 to 10 loop
        wait for 1 us;
        Conv <= '1';
        wait for 5 us;
        Conv <= '0';
        wait until RdyOut = '1';
      end loop;
      Done <= '1';
      wait;
      -- pragma synthesis_on
    End Process;

END rtl;