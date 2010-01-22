--
-- VHDL Architecture idx_fpga_lib.bench_channel.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:21:08 01/20/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
--LIBRARY idx_fpga_lib;
--USE idx_fpga_lib.All;

ENTITY bench_channel IS
  Port ( Dir_o : OUT std_ulogic;
         Run_o : OUT std_ulogic;
         Step_o : OUT std_ulogic );
END ENTITY bench_channel;

--
ARCHITECTURE arch OF bench_channel IS
   SIGNAL CMDENBL  : std_ulogic;
   SIGNAL ChanSel  : std_ulogic;
   SIGNAL F4M      : std_ulogic;
   SIGNAL F8M      : std_ulogic;
   SIGNAL KillA    : std_ulogic;
   SIGNAL KillB    : std_ulogic;
   SIGNAL LimI     : std_ulogic;
   SIGNAL LimO     : std_ulogic;
   SIGNAL OpCd     : std_ulogic_vector(2 DOWNTO 0);
   SIGNAL RdEn     : std_ulogic;
   SIGNAL WrEn     : std_ulogic;
   SIGNAL ZR       : std_ulogic;
   SIGNAL rst      : std_logic;
   SIGNAL Dir      : std_ulogic;
   SIGNAL Run      : std_ulogic;
   SIGNAL Step     : std_ulogic;
   SIGNAL Data     : std_logic_vector( 15 DOWNTO 0 );
   COMPONENT channel
      PORT (
         CMDENBL  : IN     std_ulogic;
         ChanSel  : IN     std_ulogic;
         F4M      : IN     std_ulogic;
         F8M      : IN     std_ulogic;
         KillA    : IN     std_ulogic;
         KillB    : IN     std_ulogic;
         LimI     : IN     std_ulogic;
         LimO     : IN     std_ulogic;
         OpCd     : IN     std_ulogic_vector(2 DOWNTO 0);
         RdEn     : IN     std_ulogic;
         WrEn     : IN     std_ulogic;
         ZR       : IN     std_ulogic;
         rst      : IN     std_logic;
         Dir      : OUT    std_ulogic;
         Run      : OUT    std_ulogic;
         Step     : OUT    std_ulogic;
         Data     : INOUT  std_logic_vector( 15 DOWNTO 0 )
      );
   END COMPONENT;
   --FOR ALL : channel USE ENTITY idx_fpga_lib.channel;
  
BEGIN
  DUT : channel
    PORT MAP (
       CMDENBL  => CMDENBL,
       ChanSel  => ChanSel,
       F4M      => F4M,
       F8M      => F8M,
       KillA    => KillA,
       KillB    => KillB,
       LimI     => LimI,
       LimO     => LimO,
       OpCd     => OpCd,
       RdEn     => RdEn,
       WrEn     => WrEn,
       ZR       => ZR,
       rst      => rst,
       Dir      => Dir,
       Run      => Run,
       Step     => Step,
       Data     => Data
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

  f4m_clk : Process (F8M, rst)
  Begin
    if rst = '1' then
      F4M <= '0';
    elsif F8M'Event and F8M = '1' then
      F4M <= not F4M;
    end if;
  End Process;
  
  test_proc : Process
    procedure sbwr( Addr : IN std_ulogic_vector (2 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      ChanSel <= '1';
      OpCd <= Addr;
      Data <= Data_in;
      -- pragma synthesis_off
      wait for 40 ns;
      WrEn <= '1';
      wait for 1 us;
      WrEn <= '0';
      wait for 40 ns;
      ChanSel <= '0';
      Data <= (others => 'Z');
      -- pragma synthesis_on
      return;
    end procedure sbwr;
    
    procedure verify( Pos : IN std_logic_vector (15 downto 0);
                      ChSt : IN std_logic_vector (15 downto 0);
                      RunChk : IN std_ulogic;
                      DirChk : IN std_ulogic ) is
    begin
      assert Run = RunChk report "Run Value Incorrect" severity error;
      assert Dir = DirChk report "Dir Value Incorrect" severity error;
      -- read the position
      OpCd <= "100";
      ChanSel <= '1';
      -- pragma synthesis_off
      wait for 40 ns;
      RdEn <= '1';
      wait for 1 us;
      assert Data = Pos report "Position Value Incorrect" severity error;
      RdEn <= '0';
      wait for 40 ns;
      OpCd <= "110";
      RdEn <= '1';
      wait for 1 us;
      assert Data = ChSt report "Status Value Incorrect" severity error;
      RdEn <= '0';
      wait for 40 ns;
      -- pragma synthesis_on
      return;
    end procedure verify;
  Begin
    rst <= '1';
    -- pragma synthesis_off
    wait for 200 ns;
    -- pragma synthesis_on
    rst <= '0';
    WrEn <= '0';
    RdEn <= '0';
    ChanSel <= '0';
    OpCd <= "000";
    CMDENBL <= '1';
    ZR <= '0';
    KillB <= '0';
    KillA <= '0';
    LimO <= '0';
    LimI <= '0';
    Data <= (others => 'Z');
    -- configure the channel for 16000 Hz
    sbwr( "110", X"0F20" );
    -- drive in zero to set direction
    sbwr( "000", X"0000" );
    -- readback position and status
    verify( X"0000", X"0080", '0', '0');
    -- program to drive out 7 steps
    sbwr( "010", X"0007" );
    -- readback position and status and verify Run and Dir during the drive
    -- pragma synthesis_off
    wait for 200 us;
    verify( X"0002", X"008C", '1', '1');
    -- readback position and status and Run and Dir after the drive
    wait for 375 us;
    verify( X"0007", X"0088", '0', '1');
    -- program to drive out 1000 steps
    -- readback position and status during drive
    -- set the out limit
    -- readback status
    
    wait;
    -- pragma synthesis_on
  End Process;
  
  Run_o <= Run;
  Dir_o <= Dir;
  Step_o <= Step;  
     
END ARCHITECTURE arch;

