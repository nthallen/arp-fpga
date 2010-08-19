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
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY bench_syscon IS
  GENERIC (
    N_INTERRUPTS : integer range 15 downto 1 := 1
  );
  PORT (
    Status_o : OUT std_logic_vector (1 DOWNTO 0); -- Ack,Done
    ExpRd_o : OUT std_ulogic;
    ExpWr_o : OUT std_ulogic;
    ExpAddr_o : OUT std_logic_vector (15 DOWNTO 0);
    Data_i_o : OUT std_logic_vector (15 DOWNTO 0);
    ExpReset_o : OUT std_ulogic;
    CmdEnbl_o : OUT std_ulogic;
    CmdStrb_o : OUT std_ulogic
  );
END ENTITY bench_syscon;

--
ARCHITECTURE sim OF bench_syscon IS
  SIGNAL F8M : std_ulogic;
  SIGNAL Ctrl : std_logic_vector (4 DOWNTO 0); -- Wr,Rd
  SIGNAL Addr : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_i : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_o : std_logic_vector (15 DOWNTO 0);
  SIGNAL Status : std_logic_vector (1 DOWNTO 0); -- Ack,Done
  SIGNAL ExpRd : std_ulogic;
  SIGNAL ExpWr : std_ulogic;
  SIGNAL ExpAddr : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpData : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpAck : std_logic;
  SIGNAL BdIntr : std_ulogic_vector(N_INTERRUPTS-1 downto 0);
  SIGNAL ExpIntr : std_logic;
  SIGNAL INTA    : std_ulogic;
  SIGNAL CmdEnbl : std_ulogic;
  SIGNAL CmdStrb : std_ulogic;
  SIGNAL ExpReset : std_ulogic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias Done is Status(0);
  alias Ack is Status(1);
  
  COMPONENT syscon IS
    GENERIC(
      N_INTERRUPTS : integer range 15 downto 0 := 1
    );
    PORT (
      F8M : IN std_logic;
      Ctrl : IN std_logic_vector (4 DOWNTO 0); -- Wr,Rd
      Addr : IN std_logic_vector (15 DOWNTO 0);
      Data_i : OUT std_logic_vector (15 DOWNTO 0);
      Data_o : IN std_logic_vector (15 DOWNTO 0);
      Status : OUT std_logic_vector (1 DOWNTO 0); -- Ack,Done
      ExpRd : OUT std_logic;
      ExpWr : OUT std_logic;
      ExpData : INOUT std_logic_vector (15 DOWNTO 0);
      ExpAddr : OUT std_logic_vector (15 DOWNTO 0);
      ExpAck : IN std_logic;
      BdIntr : IN std_ulogic_vector(N_INTERRUPTS-1 downto 0);
      ExpIntr : OUT std_logic;
      INTA    : OUT std_ulogic;
   	  CmdEnbl : OUT std_ulogic;
	    CmdStrb : OUT std_ulogic;
	    ExpReset : OUT std_ulogic
    );
  END COMPONENT;
  FOR ALL : syscon USE ENTITY idx_fpga_lib.syscon;
BEGIN
  DUT : syscon
     GENERIC MAP (
       N_INTERRUPTS => N_INTERRUPTS
     )
     PORT MAP (
        F8M      => F8M,
        Ctrl     => Ctrl,
        Addr     => Addr,
        Data_i   => Data_i,
        Data_o   => Data_o,
        Status   => Status,
        ExpRd    => ExpRd,
        ExpWr    => ExpWr,
        ExpData  => ExpData,
        ExpAddr  => ExpAddr,
        ExpAck   => ExpAck,
        BdIntr   => BdIntr,
        ExpIntr  => ExpIntr,
        INTA     => INTA,
        CmdEnbl  => CmdEnbl,
        CmdStrb  => CmdStrb,
        ExpReset => ExpReset
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
    Ctrl <= "00000";
    Addr <= (others => '0');
    Data_o <= (others => '0');
    ExpData <= (others => 'Z');
    ExpAck <= '0';
    BdIntr <= ( others => '0' );
    -- pragma synthesis_off
    wait for 300 ns;
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 100 ns;
    RdEn <= '1';
    wait for 200 ns;
    assert ExpRd = '1' report "ExpRd expected" severity error;
    ExpData <= X"55AA";
    ExpAck <= '1';
    wait until Done = '1';
    ExpData <= (others => 'Z');
    ExpAck <= '0';
    wait for 1000 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    RdEn <= '0';
    wait for 300 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    Data_o <= X"1234";
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
    ExpAck <= '0';
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
  Data_i_o <= Data_i;
  ExpReset_o <= ExpReset;
  CmdEnbl_o <= CmdEnbl;
  CmdStrb_o <= CmdStrb;
  
END ARCHITECTURE sim;

