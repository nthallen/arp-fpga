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

ENTITY bench_system IS
  GENERIC (
    N_CHANNELS : integer range 15 downto 1 := 2
  );
  PORT (
    Status_o : OUT std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
    ExpRd_o : OUT std_ulogic;
    ExpWr_o : OUT std_ulogic;
    ExpAddr_o : OUT std_ulogic_vector (15 DOWNTO 0);
    Data_i_o : OUT std_logic_vector (15 DOWNTO 0);
    ExpReset_o : OUT std_ulogic;
    CmdEnbl_o : OUT std_ulogic;
    CmdStrb_o : OUT std_ulogic
  );
END ENTITY bench_system;

--
ARCHITECTURE sim OF bench_system IS
  SIGNAL F8M : std_ulogic;
  SIGNAL Ctrl : std_ulogic_vector (4 DOWNTO 0); -- Wr,Rd
  SIGNAL Addr : std_ulogic_vector (15 DOWNTO 0);
  SIGNAL Data_i : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_o : std_logic_vector (15 DOWNTO 0);
  SIGNAL Status : std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
  SIGNAL ExpRd : std_ulogic;
  SIGNAL ExpWr : std_ulogic;
  SIGNAL ExpAddr : std_ulogic_vector (15 DOWNTO 0);
  SIGNAL ExpData : std_logic_vector (15 DOWNTO 0);
  SIGNAL ExpAck : std_logic;
  SIGNAL CmdEnbl : std_ulogic;
  SIGNAL CmdStrb : std_ulogic;
  SIGNAL ExpReset : std_ulogic;
  SIGNAL ExpIntr_not : std_logic;
  SIGNAL KillA       : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL KillB       : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL LimI        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL LimO        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL ZR          : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL Dir         : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL Run         : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  SIGNAL Step        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias Done is Status(0);
  alias Ack is Status(1);
  
  COMPONENT syscon IS
    PORT (
      F8M : IN std_ulogic;
      Ctrl : IN std_ulogic_vector (4 DOWNTO 0); -- Wr,Rd
      Addr : IN std_ulogic_vector (15 DOWNTO 0);
      Data_i : OUT std_logic_vector (15 DOWNTO 0);
      Data_o : IN std_logic_vector (15 DOWNTO 0);
      Status : OUT std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
      ExpRd : OUT std_ulogic;
      ExpWr : OUT std_ulogic;
      ExpData : INOUT std_logic_vector (15 DOWNTO 0);
      ExpAddr : OUT std_ulogic_vector (15 DOWNTO 0);
      ExpAck : INOUT std_logic;
       CmdEnbl : OUT std_ulogic;
      CmdStrb : OUT std_ulogic;
      ExpReset : OUT std_ulogic
    );
  END COMPONENT;
  FOR ALL : syscon USE ENTITY idx_fpga_lib.syscon;
  
  COMPONENT gxidx
      GENERIC (
         N_CHANNELS : integer range 15 downto 1 := 2
      );
      PORT (
         rst         : IN     std_ulogic;
         Addr        : IN     std_ulogic_vector(15 DOWNTO 0);
         CMDENBL     : IN     std_ulogic;
         ExpRd       : IN     std_ulogic;
         ExpWr       : IN     std_ulogic;
         F8M         : IN     std_ulogic;
         KillA       : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         KillB       : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         LimI        : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         LimO        : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         ZR          : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         ExpAck      : OUT    std_ulogic;
         ExpIntr_Not : OUT    std_logic;
         Dir         : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Run         : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Step        : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Data        : INOUT  std_logic_vector(15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : gxidx USE ENTITY idx_fpga_lib.gxidx;
BEGIN
  DUT : syscon
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
        CmdEnbl  => CmdEnbl,
        CmdStrb  => CmdStrb,
        ExpReset => ExpReset
     );
  DUT2 : gxidx
    GENERIC MAP (
       N_CHANNELS => N_CHANNELS
    )
    PORT MAP (
       rst         => ExpReset,
       Addr        => ExpAddr,
       CMDENBL     => CmdEnbl,
       ExpRd       => ExpRd,
       ExpWr       => ExpWr,
       F8M         => F8M,
       KillA       => KillA,
       KillB       => KillB,
       LimI        => LimI,
       LimO        => LimO,
       ZR          => ZR,
       ExpAck      => ExpAck,
       ExpIntr_Not => ExpIntr_Not,
       Dir         => Dir,
       Run         => Run,
       Step        => Step,
       Data        => ExpData
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
    -- pragma synthesis_off
    wait for 300 ns;
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 100 ns;
    RdEn <= '1';
    wait for 200 ns;
    assert ExpRd = '1' report "ExpRd expected" severity error;
    wait until Done = '1';
    wait for 1000 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    RdEn <= '0';
    wait for 300 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    Data_o <= X"5555";
    Addr <= X"0A0C";
    wait for 100 ns;
    WrEn <= '1';
    wait for 300 ns;
    assert ExpWr = '1' report "ExpWr should be asserted" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    wait for 300 ns;
    assert Ack = '1' report "Ack should be asserted" severity error;
    wait for 600 ns;
    wait for 100 ns;
    assert ExpWr = '0' report "ExpWr should be cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    WrEn <= '0';
    wait for 100 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    RdEn <= '1';
    wait for 200 ns;
    assert ExpRd = '1' report "ExpRd expected" severity error;
    wait until Done = '1';
    wait for 1000 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    RdEn <= '0';
    wait for 300 ns;
    assert ExpRd = '0' report "ExpRd should have cleared" severity error;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
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

