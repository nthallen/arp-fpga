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

ENTITY bench_syscon IS
  GENERIC (
    N_INTERRUPTS : integer range 15 downto 1 := 1;
    N_BOARDS : integer range 15 downto 1 := 1
  );
  PORT (
    Status_o : OUT std_logic_vector (3 DOWNTO 0); -- ExpIntr,Ack,Done
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
  SIGNAL Ctrl : std_logic_vector (5 DOWNTO 0); -- Wr,Rd
  SIGNAL Addr : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_i : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_o : std_logic_vector (15 DOWNTO 0);
  SIGNAL Status : std_logic_vector (3 DOWNTO 0); -- ExpIntr,Ack,Done
  SIGNAL ExpRd : std_ulogic;
  SIGNAL ExpWr : std_ulogic;
  SIGNAL ExpAddr : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpData : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpAck : std_logic_vector( N_BOARDS-1 DOWNTO 0);
  SIGNAL BdIntr : std_ulogic_vector(N_INTERRUPTS-1 downto 0);
  SIGNAL INTA    : std_ulogic;
  SIGNAL CmdEnbl : std_ulogic;
  SIGNAL CmdStrb : std_ulogic;
  SIGNAL ExpReset : std_ulogic;
  SIGNAL Fail_In : std_ulogic;
  SIGNAL Fail_Out : std_ulogic;
  SIGNAL Flt_CPU_Reset : std_ulogic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias Done is Status(0);
  alias Ack is Status(1);
  alias ExpIntr is Status(2);
  SIGNAL SimDone : std_ulogic;
  
  COMPONENT syscon IS
    GENERIC(
      N_INTERRUPTS : integer range 15 downto 0 := 1;
      N_BOARDS : integer range 15 downto 1 := 1
    );
    PORT (
      F8M : IN std_logic;
      Ctrl : IN std_logic_vector (5 DOWNTO 0); -- Wr,Rd
      Addr : IN std_logic_vector (15 DOWNTO 0);
      Data_i : OUT std_logic_vector (15 DOWNTO 0);
      Data_o : IN std_logic_vector (15 DOWNTO 0);
      Status : OUT std_logic_vector (3 DOWNTO 0); -- ExpIntr,Ack,Done
      ExpRd : OUT std_logic;
      ExpWr : OUT std_logic;
      ExpData : INOUT std_logic_vector (15 DOWNTO 0);
      ExpAddr : OUT std_logic_vector (15 DOWNTO 0);
      ExpAck : IN std_logic_vector(N_BOARDS-1 DOWNTO 0);
      BdIntr : IN std_ulogic_vector(N_INTERRUPTS-1 DOWNTO 0);
      INTA    : OUT std_ulogic;
   	  CmdEnbl : OUT std_ulogic;
	    CmdStrb : OUT std_ulogic;
	    ExpReset : OUT std_ulogic;
      Fail_In : IN std_ulogic;
      Fail_Out : OUT std_ulogic;
      Flt_CPU_Reset : OUT std_ulogic
    );
  END COMPONENT;
  FOR ALL : syscon USE ENTITY idx_fpga_lib.syscon;
BEGIN
  DUT : syscon
     GENERIC MAP (
       N_INTERRUPTS => N_INTERRUPTS,
       N_BOARDS => N_BOARDS
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
        INTA     => INTA,
        CmdEnbl  => CmdEnbl,
        CmdStrb  => CmdStrb,
        ExpReset => ExpReset,
        Fail_In  => Fail_In,
        Fail_Out => Fail_Out,
        Flt_CPU_Reset => Flt_CPU_Reset
     );

  f8m_clk : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 20 ns;
    while SimDone = '0' loop
      F8M <= '1';
      wait for 62 ns;
      F8M <= '0';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc: Process
  Begin
    SimDone <= '0';
    Ctrl <= "000000";
    Addr <= (others => '0');
    Data_o <= (others => '0');
    ExpData <= (others => 'Z');
    ExpAck <= "0";
    BdIntr <= ( others => '0' );
    Fail_In <= '0';
    rst <= '1';
    -- pragma synthesis_off
    wait for 300 ns;
    rst <= '0';
    wait until F8M'Event and F8M = '1';
    RdEn <= '1';
    wait until F8M'Event and F8M = '1';
    wait until F8M'Event and F8M = '1';
    wait for 40 ns;
    assert ExpRd = '1' report "ExpRd expected" severity error;
    ExpData <= X"55AA";
    ExpAck <= "1";
    wait until Done = '1';
    ExpData <= (others => 'Z');
    ExpAck <= "0";
    wait for 1000 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    RdEn <= '0';
    wait until F8M'Event and F8M = '1';
    wait until F8M'Event and F8M = '1';
    wait for 40 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    Data_o <= X"1234";
    wait until F8M'Event AND F8M = '1';
    WrEn <= '1';
    wait until F8M'Event AND F8M = '1';
    wait until F8M'Event AND F8M = '1';
    wait for 40 ns;
    assert ExpWr = '1' report "ExpWr should be asserted" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert To_X01(Ack) = '0' report "Ack should not be asserted" severity error;
    ExpAck <= "1";
    wait until F8M'Event AND F8M = '1';
    wait for 40 ns;
    assert Ack = '1' report "Ack should be asserted" severity error;
    for i in 1 to 8 loop
      wait until F8M'Event and F8M = '1';
    end loop;
    wait for 40 ns;
    assert ExpWr = '0' report "ExpWr should be cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    WrEn <= '0';
    ExpAck <= "0";
    wait until F8M'Event and F8M = '1';
    wait until F8M'Event and F8M = '1';
    wait for 30 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert To_X01(Ack) = '0' report "Ack should not be asserted" severity error;

    -- Interrupt testing
    assert ExpIntr = '0' report "ExpIntr should not be asserted" severity error;
    BdIntr <= "1";
    Addr <= X"0040";
    wait for 150 ns;
    assert ExpIntr = '1' report "ExpInter should be asserted" severity error;
    RdEn <= '1';
    wait for 500 ns;
    assert INTA = '1' report "INTA not asserted" severity error;
    wait for 700 ns;
    assert INTA = '0' report "INTA asserted too long" severity error;
    assert Data_i = X"0001" report "Data value during INTA wrong" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    RdEn <= '0';
    wait for 200 ns;

    BdIntr <= "0";
    Addr <= X"0040";
    wait for 150 ns;
    assert ExpIntr = '0' report "ExpIntr should not be asserted" severity error;
    RdEn <= '1';
    wait for 500 ns;
    assert INTA = '1' report "INTA not asserted" severity error;
    wait for 700 ns;
    assert INTA = '0' report "INTA asserted too long" severity error;
    assert Data_i = X"0000" report "Data value during INTA wrong" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    RdEn <= '0';
    wait for 200 ns;
    SimDone <= '1';
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

