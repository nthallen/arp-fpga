--
-- VHDL Architecture idx_fpga_lib.bench_decode.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:19:03 01/29/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_decode IS
END ENTITY bench_decode;

--
ARCHITECTURE sim OF bench_decode IS
  SIGNAL Addr   :   std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpRd  :   std_ulogic;
  SIGNAL ExpWr  :   std_ulogic;
  SIGNAL F8M    :   std_ulogic;
  SIGNAL rst    :   std_ulogic;
  SIGNAL ExpAck :   std_ulogic;
  SIGNAL WrEn   :   std_ulogic;
  SIGNAL INTA   :   std_ulogic;
  SIGNAL Chan   :   std_ulogic_vector (2-1 DOWNTO 0);
  SIGNAL Run    :   std_ulogic_vector (2-1 DOWNTO 0);
  SIGNAL OpCd   :   std_logic_vector (2 DOWNTO 0);
  SIGNAL Data   :   std_logic_vector (15 DOWNTO 0);
  SIGNAL iData  :   std_logic_vector (15 DOWNTO 0);
  SIGNAL RdEn   :   std_ulogic;
  SIGNAL F4M    :   std_ulogic;
  COMPONENT decode IS
    GENERIC ( N_CHANNELS : integer range 15 downto 1 := 1 );
    PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      INTA   : OUT    std_ulogic;
      Chan   : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Run    : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd   : OUT    std_logic_vector (2 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn   : OUT    std_ulogic;
      F4M    : OUT    std_ulogic
   );
 END COMPONENT;
BEGIN
  DUT : decode
    Generic Map ( N_CHANNELS => 2 )
    Port Map (
      Addr => Addr,
      ExpRd => ExpRd,
      ExpWr => ExpWr,
      F8M => F8M,
      rst => rst,
      ExpAck => ExpAck,
      WrEn => WrEn,
      INTA => INTA,
      Chan => Chan,
      Run => Run,
      OpCd => OpCd,
      Data => Data,
      iData => iData,
      RdEn => RdEn,
      F4M => F4M );

  f8m_clk : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 62.5 ns;
    F8M <= '1';
    wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;
  
  test_proc : Process
  Begin
    Addr <= X"0000";
    ExpRd <= '0';
    ExpWr <= '0';
    rst <= '1';
    Run <= "00";
    Data <= (others => 'Z');
    iData <= (others => 'Z');
    -- pragma synthesis_off
    wait for 250 ns;
    rst <= '0';
    wait for 250 ns;
    Data <= X"0000";
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
    Addr <= X"0A08";
    wait for 250 ns;
    ExpWr <= '1';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert WrEn = '1' report "WrEn not asserted" severity error;
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
    Addr <= X"0A00";
    wait for 250ns;
    ExpRd <= '1';
    wait until RdEn = '1';
    wait for 30 ns;
    assert ExpAck = '1' report "ExpAck not set" severity error;
    wait for 970 ns;
    assert Data(1 downto 0) = "00" report "Run misread" severity error;
    ExpRd <= '0';
    wait for 30ns;
    assert RdEn = '0' report "RdEn not cleared" severity error;
    assert ExpAck = '0' report "ExpAck not cleared" severity error;
    Run <= "10";
    ExpRd <= '1';
    wait until RdEn = '1';
    wait for 30 ns;
    assert ExpAck = '1' report "ExpAck not set" severity error;
    wait for 970 ns;
    assert Data(1 downto 0) = "10" report "Run misread" severity error;
    ExpRd <= '0';
    wait for 30ns;
    assert RdEn = '0' report "RdEn not cleared" severity error;
    assert ExpAck = '0' report "ExpAck not cleared" severity error;
    Run <= "01";
    ExpRd <= '1';
    wait until RdEn = '1';
    wait for 30 ns;
    assert ExpAck = '1' report "ExpAck not set" severity error;
    wait for 970 ns;
    assert Data(1 downto 0) = "01" report "Run misread" severity error;
    ExpRd <= '0';
    wait for 30ns;
    assert RdEn = '0' report "RdEn not cleared" severity error;
    assert ExpAck = '0' report "ExpAck not cleared" severity error;
    wait;
    -- pragma synthesis_on
  End Process;

END ARCHITECTURE sim;

