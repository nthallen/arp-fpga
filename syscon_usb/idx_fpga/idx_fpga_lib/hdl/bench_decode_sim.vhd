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
  GENERIC (
    N_CHANNELS : integer range 15 downto 1 := 2
  );
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
  SIGNAL Chan   :   std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
  SIGNAL Running :   std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
  SIGNAL OpCd   :   std_logic_vector (2 DOWNTO 0);
  SIGNAL Data   :   std_logic_vector (15 DOWNTO 0);
  SIGNAL iData  :   std_logic_vector (15 DOWNTO 0);
  SIGNAL RdEn   :   std_ulogic;
  SIGNAL F4M    :   std_ulogic;
  SIGNAL BdIntr :   std_ulogic;
  SIGNAL Ireq   :   std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
  SIGNAL Done   :   std_ulogic;
  
  COMPONENT decode IS
    GENERIC (
      N_CHANNELS : integer range 15 downto 1 := 1;
      BASE_ADDR : std_logic_vector (15 DOWNTO 0) := X"0A00"
    );
    PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      BdIntr : OUT    std_ulogic;
      Chan   : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Running : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Ireq    : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd   : OUT    std_logic_vector (2 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn   : OUT    std_ulogic;
      F4M    : OUT    std_ulogic
   );
 END COMPONENT;
BEGIN
  DUT : decode
    Generic Map ( N_CHANNELS => N_CHANNELS, BASE_ADDR => X"0A00" )
    Port Map (
      Addr => Addr,
      ExpRd => ExpRd,
      ExpWr => ExpWr,
      F8M => F8M,
      rst => rst,
      ExpAck => ExpAck,
      WrEn => WrEn,
      BdIntr => BdIntr,
      Chan => Chan,
      Running => Running,
      Ireq => Ireq,
      OpCd => OpCd,
      Data => Data,
      iData => iData,
      RdEn => RdEn,
      F4M => F4M );

  f8m_clk : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 100 ns;
    while Done = '0' loop
      wait for 62 ns;
      F8M <= '1';
      wait for 63 ns;
      F8M <= '0';
    end loop;
    wait;
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
    
    procedure check_bdint( Ireq_In : IN std_ulogic_vector(1 downto 0);
                           BdIntr_Out : IN std_ulogic ) is
    begin
      Ireq <= "00";
      -- pragma synthesis_off
      wait until F8M'Event and F8M = '1';
      wait for 20 ns;
      assert BdIntr = '0' report "BdIntr asserted w/o request" severity error;
      Ireq <= Ireq_In;
      wait until F8M'Event and F8M = '1';
      wait for 20 ns;
      assert BdIntr = BdIntr_Out report "BdIntr not set on request" severity error;
      -- pragma synthesis_on
      return;
    end procedure check_bdint;
    
    procedure check_write( Addr_In : IN std_logic_vector(15 DOWNTO 0);
       Expect_Ack : IN integer;
       Expect_Chan : IN integer;
       Chan_No : IN integer ) is
    begin
      Addr <= Addr_In;
      -- pragma synthesis_off
      wait for 100 ns;
      ExpWr <= '1';
      wait until F8M'Event and F8M = '1';
      wait for 30 ns;
      assert WrEn = '1' report "WrEn not asserted" severity error;
      wait for 1 us;
      if Expect_Ack = 1 then
        assert ExpAck = '1' report "No Acknowledge" severity error;
      else
        assert ExpAck = '0' report "Permanent Acknowledge" severity error;
      end if;
      if Expect_Chan = 1 then
        for i in 0 to N_CHANNELS-1 loop
          if i = Chan_No then
            assert Chan(i) = '1'
              report "Specified channel not asserted"
              severity error;
          else
            assert Chan(i) = '0'
              report "Unspecified channel asserted"
              severity error;
          end if;
        end loop;
      else
        for i in 0 to N_CHANNELS-1 loop
          assert Chan(i) = '0'
            report "Unspecified channel asserted"
            severity error;
        end loop;
      end if;
      ExpWr <= '0';
      wait until F8M'Event and F8M = '1';
      wait for 30 ns;
      assert WrEn = '0' report "WrEn not cleared" severity error;
      assert ExpAck = '0' report "ExpAck not cleared" severity error;
      wait for 250 ns;
      -- pragma synthesis_on
      return;
    end procedure check_write;

    procedure check_read( Addr_In : IN std_logic_vector(15 DOWNTO 0);
       Expect_Ack : IN integer;
       Expect_Chan : IN integer;
       Chan_No : IN integer;
       Set_Data : IN integer;
       iData_In : IN std_logic_vector(15 DOWNTO 0);
       RData : IN std_logic_vector(15 DOWNTO 0);
       What : IN string ) is
    begin
      Addr <= Addr_In;
      Data <= (others => 'Z');
      -- pragma synthesis_off;
      wait for 100 ns;
      ExpRd <= '1';
      wait until F8M'Event and F8M = '1';
      wait until F8M'Event and F8M = '1';
      if Expect_Ack = 1 then
        assert RdEn = '1'
          report "RdEn not set"
          severity error;
      else
        assert RdEn = '0'
          report "RdEn set on invalid address"
          severity error;
      end if;
      if Expect_Chan = 1 then
        for i in 0 to N_CHANNELS-1 loop
          if i = Chan_No then
            assert Chan(i) = '1'
              report "Specified channel not asserted"
              severity error;
          else
            assert Chan(i) = '0'
              report "Unspecified channel asserted"
              severity error;
          end if;
        end loop;
      else
        for i in 0 to N_CHANNELS-1 loop
          assert Chan(i) = '0'
            report "Unspecified channel asserted"
            severity error;
        end loop;
      end if;
      wait for 30 ns;
      if Set_Data = 1 then
        iData <= iData_In;
      end if;
      wait for 970 ns;
      if Expect_Ack = 1 then
        assert ExpAck = '1'
          report "ExpAck not set"
          severity error;
        assert Data = RData
          report "Data on " & What & " read not valid"
          severity error;
      end if;
      ExpRd <= '0';
      wait for 30 ns;
      iData <= (others => 'Z');
      -- pragma synthesis_on
      return;
    end procedure check_read;

  Begin
    Done <= '0';
    Addr <= X"0000";
    ExpRd <= '0';
    ExpWr <= '0';
    rst <= '1';
    Running <= "00";
    Data <= (others => 'Z');
    iData <= (others => 'Z');
    -- pragma synthesis_off
    wait for 250 ns;
    rst <= '0';
    wait for 250 ns;
    Data <= X"0000";
    check_write( X"0000", 0, 0, 0 );
    check_write( X"0A00", 1, 0, 0 );
    check_write( X"0A08", 1, 1, 0 );
    check_write( X"0A10", 1, 1, 1 );
    check_write( X"0A18", 0, 0, 0 ); -- one beyond N_CHANNELS

    check_read( X"0000", 0, 0, 0, 0, X"0000", X"0000", "Invalid Address" );
    check_read( X"0A08", 1, 1, 0, 1, X"55AA", X"55AA", "Channel Status" );
    Running <= "00";
    check_read( X"0A00", 1, 0, 0, 0, X"0000", X"0000", "Board Status" );
    Running <= "10";
    check_read( X"0A00", 1, 0, 0, 0, X"0000", X"0002", "Board Status" );
    Running <= "01";
    check_read( X"0A00", 1, 0, 0, 0, X"0000", X"0001", "Board Status" );
    
    -- Test interrupt operation
    assert BdIntr = '0' report "BdIntr asserted before config" severity error;
    Ireq <= "00";
    sbwr( X"0A00", X"0020" ); --enable interrupt 0x40
    check_bdint( "01", '1' );
    check_bdint( "10", '1' );
    check_bdint( "11", '1' );
    sbwr( X"0A00", X"0000" ); --disable interrupt
    check_bdint( "01", '0' );
    check_bdint( "10", '0' );
    check_bdint( "11", '0' );
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

END ARCHITECTURE sim;

