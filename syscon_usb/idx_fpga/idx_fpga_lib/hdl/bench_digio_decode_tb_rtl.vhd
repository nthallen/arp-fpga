--
-- VHDL Test Bench idx_fpga_lib.bench_DigIO_decode.DigIO_decode_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:30:18 09/21/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_DigIO_decode IS
END bench_DigIO_decode;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_DigIO_decode IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Data   : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL ExpAck : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL rst    : std_ulogic;
   SIGNAL iData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdEn   : std_ulogic;
   SIGNAL WrEn   : std_ulogic;
   SIGNAL BdEn   : std_ulogic;


   -- Component declarations
   COMPONENT subbus_io
      PORT (
         Data   : INOUT  std_logic_vector(15 DOWNTO 0);
         ExpRd  : IN     std_ulogic;
         ExpWr  : IN     std_ulogic;
         ExpAck : OUT    std_ulogic;
         F8M    : IN     std_ulogic;
         rst    : IN     std_ulogic;
         iData  : INOUT  std_logic_vector(15 DOWNTO 0);
         RdEn   : OUT    std_ulogic;
         WrEn   : OUT    std_ulogic;
         BdEn   : IN     std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on

BEGIN

   DUT : subbus_io
      PORT MAP (
         Data   => Data,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         rst    => rst,
         iData  => iData,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );

  f8m_clk : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 62.5 ns;
    F8M <= '1';
    wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;

  TestProc : process
  begin
    ExpRd <= '0';
    ExpWr <= '0';
    BdEn <= '0';
    rst <= '1';
    Data <= (others => 'Z');
    iData <= (others => 'Z');
    -- pragma synthesis_off
    wait for 250 ns;
    rst <= '0';
    wait for 250 ns;
    Data <= X"5555";
    ExpWr <= '1';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert WrEn = '1' report "WrEn not asserted" severity error;
    wait for 1 us;
    assert ExpAck = '0' report "Permanent Acknowledge" severity error;
    ExpWr <= '0';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert WrEn = '0' report "WrEn not cleared" severity error;
    assert ExpAck = '0' report "ExpAck not cleared" severity error;
    wait for 250 ns;
    BdEn <= '1';
    wait for 250 ns;
    ExpWr <= '1';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert WrEn = '1' report "WrEn not asserted" severity error;
    assert iData = Data report "iData not defined" severity error;
    wait for 1 us;
    assert ExpAck = '1' report "No Acknowledge" severity error;
    ExpWr <= '0';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert WrEn = '0' report "WrEn not cleared" severity error;
    assert ExpAck = '0' report "ExpAck not cleared" severity error;
    Data <= (others => 'Z');
    wait for 100 ns;
    ExpRd <= '1';
    wait until RdEn = '1';
    wait for 30 ns;
    iData <= X"55AA";
    wait for 970 ns;
    ExpRd <= '0';
    wait for 30 ns;
    iData <= (others => 'Z');
    wait;
    -- pragma synthesis_on
  end process;

END rtl;