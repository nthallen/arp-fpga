--
-- VHDL Architecture idx_fpga_lib.benc_gxidx.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:14:59 02/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY bench_gxidx IS
  GENERIC (
    N_CHANNELS : integer range 15 downto 1 := 2
  );
END ENTITY bench_gxidx;

--
ARCHITECTURE sim OF bench_gxidx IS
   SIGNAL rst         : std_ulogic;
   SIGNAL Addr        : std_logic_vector(15 DOWNTO 0);
   SIGNAL CMDENBL     : std_ulogic;
   SIGNAL ExpRd       : std_ulogic;
   SIGNAL ExpWr       : std_ulogic;
   SIGNAL INTA        : std_ulogic;
   SIGNAL F8M         : std_ulogic;
   SIGNAL KillA       : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL KillB       : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL LimI        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL LimO        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL ZR          : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL ExpAck      : std_ulogic;
   SIGNAL BdIntr      : std_logic;
   SIGNAL Dir         : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL Run         : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL Step        : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL Data        : std_logic_vector(15 DOWNTO 0);
   COMPONENT gxidx
      GENERIC (
         N_CHANNELS : integer range 15 downto 1 := 2
      );
      PORT (
         rst         : IN     std_ulogic;
         Addr        : IN     std_logic_vector(15 DOWNTO 0);
         CMDENBL     : IN     std_ulogic;
         ExpRd       : IN     std_ulogic;
         ExpWr       : IN     std_ulogic;
         INTA        : IN     std_ulogic;
         F8M         : IN     std_ulogic;
         KillA       : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         KillB       : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         LimI        : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         LimO        : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         ZR          : IN     std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         ExpAck      : OUT    std_ulogic;
         BdIntr      : OUT    std_ulogic;
         Dir         : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Run         : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Step        : OUT    std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
         Data        : INOUT  std_logic_vector(15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : gxidx USE ENTITY idx_fpga_lib.gxidx;
BEGIN
   --  hds hds_inst
   DUT : gxidx
      GENERIC MAP (
         N_CHANNELS => N_CHANNELS
      )
      PORT MAP (
         rst         => rst,
         Addr        => Addr,
         CMDENBL     => CMDENBL,
         ExpRd       => ExpRd,
         ExpWr       => ExpWr,
         INTA        => INTA,
         F8M         => F8M,
         KillA       => KillA,
         KillB       => KillB,
         LimI        => LimI,
         LimO        => LimO,
         ZR          => ZR,
         ExpAck      => ExpAck,
         BdIntr      => BdIntr,
         Dir         => Dir,
         Run         => Run,
         Step        => Step,
         Data        => Data
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
       
       test_proc : Process
         procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                         Data_In : IN std_logic_vector (15 downto 0) ) is
         begin
           Addr <= Addr_In;
           Data <= Data_in;
           -- pragma synthesis_off
           wait for 40 ns;
           ExpWr <= '1';
           wait for 1 us;
           assert ExpAck = '1' report "No acknowledge on write" severity error;
           ExpWr <= '0';
           wait for 250 ns;
           Data <= (others => 'Z');
           -- pragma synthesis_on
           return;
         end procedure sbwr;
         
         procedure verify( ChNo : IN integer range 14 downto 0;
                           Pos : IN std_logic_vector (15 downto 0);
                           ChSt : IN std_logic_vector (15 downto 0);
                           RunChk : IN std_ulogic;
                           DirChk : IN std_ulogic ) is
           -- pragma synthesis_off
           Variable BaseAddr : unsigned (15 downto 0);
           -- pragma synthesis_on
         begin
           assert Run(ChNo) = RunChk report "Run Value Incorrect" severity error;
           assert Dir(ChNo) = DirChk report "Dir Value Incorrect" severity error;
           -- read the position
           -- pragma synthesis_off
           BaseAddr := X"0A00";
           BaseAddr := BaseAddr + 8*(ChNo+1);
           Addr <= std_logic_vector(BaseAddr+4);
           wait for 40 ns;
           ExpRd <= '1';
           wait for 1 us;
           assert ExpAck = '1' report "No Acknowledge on position read" severity error;
           assert Data = Pos report "Position Value Incorrect" severity error;
           ExpRd <= '0';
           wait for 40 ns;
           Addr <= std_logic_vector(BaseAddr+6);
           ExpRd <= '1';
           wait for 1 us;
           assert ExpAck = '1' report "No Acknowledge on status read" severity error;
           assert Data = ChSt report "Status Value Incorrect" severity error;
           ExpRd <= '0';
           wait for 40 ns;
           -- pragma synthesis_on
           return;
         end procedure verify;
         
         procedure check_intr_active is
         begin
           -- pragma synthesis_off
           assert BdIntr = '1' report "BdIntr not observed" severity error;
           wait until F8M'Event and F8M = '1';
           INTA <= '1';
           wait until F8M'Event and F8M = '1';
           assert BdIntr = '1' report "BdIntr not active during INTA" severity error;
           INTA <= '0';
           wait until F8M'Event and F8M = '1';
           wait until F8M'Event and F8M = '1';
           wait until F8M'Event and F8M = '1';
           wait until F8M'Event and F8M = '1';
           assert BdIntr = '0' report "BdIntr not cleared by INTA" severity error;
           -- pragma synthesis_on
         end procedure check_intr_active;
         
         procedure exercise(ChNo : integer range 14 downto 0) is
           -- pragma synthesis_off
           Variable BaseAddr : unsigned (15 downto 0);
           -- pragma synthesis_on
         begin
           -- pragma synthesis_off
           BaseAddr := X"0A00";
           BaseAddr := BaseAddr + 8*(ChNo+1);
           -- readback position and status
           verify( ChNo, X"0000", X"0080", '0', '0');
           -- program to drive out 7 steps
           sbwr( std_logic_vector(BaseAddr+2), X"0007" );
           -- readback position and status and verify Run and Dir during the drive
           -- pragma synthesis_off
           wait until Run'Event and Run(ChNo) = '1' for 63 us;
           verify( ChNo, X"0000", X"008C", '1', '1');
           wait for 156 us;
           verify( ChNo, X"0002", X"008C", '1', '1');
           -- readback position and status and Run and Dir after the drive
           wait for 350 us;
           verify( ChNo, X"0007", X"008C", '1', '1');
           wait for 75 us;
           verify( ChNo, X"0007", X"0084", '0', '1');
           check_intr_active;
           -- program to drive out 1024 steps
           sbwr( std_logic_vector(BaseAddr+2), X"0200" );
           -- readback position and status during drive
           wait until Run'Event and Run(ChNo) = '1' for 63 us;
           verify( ChNo, X"0007", X"008C", '1', '1');
           wait for 300 us;
           -- set the out limit
           LimO(ChNo) <= '1';
           wait for 140 us;
           verify( ChNo, X"000B", X"0086", '0', '1');
           check_intr_active;
           -- drive in a lot
           sbwr( std_logic_vector(BaseAddr), X"1000" );
           wait until Run'Event and Run(ChNo) = '1' for 63 us;
           verify( ChNo, X"000B", X"008A", '1', '0');
           wait for 100 us;
           -- reset out limit
           LimO(ChNo) <= '0';
           wait for 300 us;
           -- set in limit
           LimI(ChNo) <= '1';
           wait for 200 us;
           -- verify stop and position
           verify( ChNo, X"0005", X"0081", '0', '0');
           check_intr_active;
           -- drive out a lot
           sbwr( std_logic_vector(BaseAddr+2), X"0010" );
           wait until Run'Event and Run(ChNo) = '1' for 63 us;
           verify( ChNo, X"0005", X"008D", '1', '1');
           -- clear in limit
           wait for 300 us;
           LimI(ChNo) <= '0';
           wait for 400 us;
           verify( ChNo, X"0010", X"008C", '1', '1');
           -- set zero ref
           ZR(ChNo) <= '1';
           wait for 1 us;
           -- verify zero position
           verify( ChNo, X"0000", X"00CC", '1', '1' );
           wait for 125 us;
           -- clear zero ref
           ZR(ChNo) <= '0';
           wait for 400 us;
           -- verify end position
           verify( ChNo, X"0005", X"0084", '0', '1');
           check_intr_active;
           -- pragma synthesis_on
           return;
         end procedure exercise;
       Begin
         ExpWr <= '0';
         ExpRd <= '0';
         INTA <= '0';
         Addr <= X"0000";
         CMDENBL <= '1';
         ZR <= "00";
         KillB <= "00";
         KillA <= "00";
         LimO <= "00";
         LimI <= "00";
         Data <= (others => 'Z');
         rst <= '1';
         -- pragma synthesis_off
         wait for 200 ns;
         -- pragma synthesis_on
         rst <= '0';
         wait for 400 ns;
         -- pulse INTA to clear
         INTA <= '1';
         wait for 200 ns;
         INTA <= '0';
         wait for 200 ns;
         -- configure the channels for 16000 Hz
         -- set all limits true in high
         sbwr( X"0A0E", X"7FE0" ); -- was 0F20
         sbwr( X"0A16", X"7FE0" ); -- was 0F20
         -- enable interrupts
         sbwr( X"0A00", X"0020" );
         
         -- drive in zero to set direction
         sbwr( X"0A08", X"0000" );
         sbwr( X"0A10", X"0000" );
         exercise(0);
         exercise(1);
         wait;
         -- pragma synthesis_on
       End Process;

END ARCHITECTURE sim;

