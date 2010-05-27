--
-- VHDL Architecture idx_fpga_lib.bench_syscon.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:48:33 05/27/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_syscon IS
  PORT (
    Status_o : OUT std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
    ExpRd_o : OUT std_ulogic;
    ExpWr_o : OUT std_ulogic;
    ExpAddr_o : OUT std_ulogic_vector (15 DOWNTO 0)
  );
END ENTITY bench_syscon;

--
ARCHITECTURE sim OF bench_syscon IS
  SIGNAL F8M : std_ulogic;
  SIGNAL Ctrl : std_ulogic_vector (1 DOWNTO 0); -- Wr,Rd
  SIGNAL Addr : std_ulogic_vector (15 DOWNTO 0);
  SIGNAL Data : std_logic_vector (15 DOWNTO 0);
  SIGNAL Status : std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
  SIGNAL ExpRd : std_ulogic;
  SIGNAL ExpWr : std_ulogic;
  SIGNAL ExpAddr : std_ulogic_vector (15 DOWNTO 0);
  SIGNAL ExpData : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpAck : std_logic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias Done is Status(0);
  alias Ack is Status(1);

  COMPONENT syscon IS
    PORT (
      F8M : IN std_ulogic;
      Ctrl : IN std_ulogic_vector (1 DOWNTO 0); -- Wr,Rd
      Addr : IN std_ulogic_vector (15 DOWNTO 0);
      Data : INOUT std_logic_vector (15 DOWNTO 0);
      Status : OUT std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
      ExpRd : OUT std_ulogic;
      ExpWr : OUT std_ulogic;
      ExpData : INOUT std_logic_vector (15 DOWNTO 0);
      ExpAddr : OUT std_ulogic_vector (15 DOWNTO 0);
      ExpAck : INOUT std_logic
    );
  END COMPONENT;
BEGIN
  DUT : syscon
    PORT MAP (
      F8M => F8M,
      Ctrl => Ctrl,
      Addr => Addr,
      Data => Data,
      Status => Status,
      ExpRd => ExpRd,
      ExpWr => ExpWr,
      ExpData => ExpData,
      ExpAddr => ExpAddr,
      ExpAck => ExpAck
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

  test_proc: Process
  Begin
    Ctrl <= "00";
    Addr <= (others => '0');
    Data <= (others => 'Z');
    ExpData <= (others => 'Z');
    ExpAck <= 'Z';
    -- pragma synthesis_off
    wait for 300 ns;
    Ctrl <= "01";
    wait for 200 ns;
    assert ExpRd = '1' report "ExpRd expected" severity error;
    ExpData <= X"55AA";
    ExpAck <= '1';
    wait for 1000 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    Ctrl <= "00";
    ExpData <= (others => 'Z');
    ExpAck <= 'Z';
    wait for 300 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    Data <= X"1234";
    wait for 100 ns;
    WrEn <= '1';
    wait for 300 ns;
    assert ExpWr = '1' report "ExpWr should be asserted" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert To_X01(Ack) = '0' report "Ack should not be asserted" severity error;
    ExpAck <= '1';
    wait for 300 ns;
    assert Ack = '1' report "Ack should be asserted" severity error;
    wait for 600 ns;
    ExpAck <= 'Z';
    wait for 100 ns;
    assert ExpWr = '0' report "ExpWr should be cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    WrEn <= '0';
    wait for 100 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert To_X01(Ack) = '0' report "Ack should not be asserted" severity error;
    wait;
   -- pragma synthesis_on
  End Process;
  
  Status_o <= Status;
  ExpRd_o <= ExpRd;
  ExpWr_o <= ExpWr;
  ExpAddr_o <= ExpAddr;
  
END ARCHITECTURE sim;

