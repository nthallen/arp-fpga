--
-- VHDL Architecture idx_fpga_lib.qclictrl_tester.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:34:55 12/20/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY qclictrl_tester IS
   PORT( 
      ExpAck    : IN     std_ulogic;
      QCLI_out  : IN     std_logic_vector (15 DOWNTO 0);
      QSync     : IN     std_ulogic;
      RData     : IN     std_logic_vector (15 DOWNTO 0);
      Addr      : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd     : OUT    std_ulogic;
      ExpWr     : OUT    std_ulogic;
      F8M       : OUT    std_logic;
      MQ_enable : OUT    std_logic;
      WData     : OUT    std_logic_vector (15 DOWNTO 0);
      rst       : OUT    std_logic;
      QSClk     : INOUT  std_logic;
      QSData    : INOUT  std_logic
   );

-- Declarations

END qclictrl_tester ;

--
ARCHITECTURE rtl OF qclictrl_tester IS
  SIGNAL F8M_int : std_ulogic;
  SIGNAL Done : std_ulogic;
  SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);
  SIGNAL WatchForSynch : std_ulogic;
BEGIN

  clock8 : Process
  Begin
    F8M_int <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F8M_int <= '0';
      wait for 62 ns;
      F8M_int <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  test_proc : Process
    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Addr <= addr_in;
      -- pragma synthesis_off
      wait until F8M_int'Event AND F8M_int = '1';
      ExpRd <= '1';
      for i in 1 to 8 loop
        wait until F8M_int'Event AND F8M_int = '1';
      end loop;
      assert ExpAck = '1'
        report "No Acknowledge on read from addr" -- & to_hexstring(addr_in)
        severity error;
      Read_Result <= rData;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
    
    procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      -- pragma synthesis_off
      wait until F8M'Event AND F8M = '1';
      Addr <= Addr_In;
      WData <= Data_in;
      ExpWr <= '1';
      wait for 1 us;
      assert ExpAck = '1' report "No acknowledge on write" severity error;
      ExpWr <= '0';
      wait for 250 ns;
      -- pragma synthesis_on
      return;
    end procedure sbwr;
Begin
    Done <= '0';
    WatchForSynch <= '0';
    QSClk <= 'L';
    QSData <= 'L';
    ExpWr <= '0';
    ExpRd <= '0';
    MQ_enable <= '1';
    rst <= '1';
    -- pragma synthesis_off
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    rst <= '0';
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    sbrd(X"1000"); -- read controller status
    assert RData = X"0000" report "RData should be 0000";
    wait until QSync = '0';
    wait until QSync = '1';
    sbrd(X"1000"); -- read controller status again
    assert RData = X"4000" report "RData should be 4000 during read";
    sbrd(X"1002"); -- read QCLI status
    wait for 260 us;
    sbrd(X"1000"); -- read controller status again
    assert RData = X"4000" report "Rdata should be 4000 during read (2)";
    sbrd(X"1002"); -- read QCLI status
    wait for 300 us;
    sbrd(X"1000"); -- read controller status again
    assert RData = X"4800"
      report "RData should be 4800"
      severity error;
    wait for 260 us;
    sbrd(X"1000"); -- read controller status again
    assert RData = X"0800"
      report "RData should be 0800"
      severity error;
    sbwr( X"1006", X"1234" );
    wait for 8 us;
    sbwr( X"1006", X"5678" );
    wait for 8 us;
    -- sbrd( X"1002" ); -- Throw in a status read to see if timeout
    -- Gets delayed until the read is completed
    sbwr( X"1008", X"9ABC" );
    loop
      sbrd(X"1000");
      exit when RData(10) = '0'; -- Write Pending bit
    end loop;
    loop
      sbrd(X"1000");
      exit when RData(14) = '1'; -- Reading
    end loop;
    loop
      sbrd(X"1000");
      exit when RData(14) = '0'; -- Reading
    end loop;
    
    -- Now let's test the block read:
    sbwr(X"100A", X"3500");
    loop
      wait for 1 ms;
      sbrd(X"1000");
      exit when RData(9) = '1';
    end loop;
    for i in 1 to 128 loop
      sbrd(X"1004");
    end loop;
    loop
      wait for 1 ms;
      sbrd(X"1000");
      exit when RData(14) = '0';
    end loop;
    assert RData = X"0800"
      report "RData (Ctrlr_status) should be 0800";
    sbrd(X"1002");
    assert RData = X"8383"
      report "RData (QCLI_status) should be 8383";
    
    -- Now let's test some error detection and correction
    sbrd(X"1004"); -- read from empty FIFO
    assert RData = X"0000"
      report "Read from empty FIFO should return 0000";
    sbrd(X"1000"); -- read ctrlr_status
    assert RData(13) = '1'
      report "Read from empty FIFO should assert RWConflict";
    sbwr(X"100C", X"0000");
    sbrd(X"1000"); -- read ctrlr_status
    assert RData(13) = '0'
      report "RWConflict not reset by controller reset";
      
    sbwr(X"1006", X"4321"); -- Start Write
    sbrd(X"1004"); -- Read FIFO with write pending should set RWConflict
    sbrd(X"1000"); -- read ctrlr_status
    assert RData(13) = '1' AND RData(10) = '1'
      report "Read FIFO with WQPending should assert RWConflict";
    sbwr(X"100C", X"0000"); -- ctrlr reset
    sbrd(X"1000"); -- read ctrlr_status
    assert RData(13) = '0' AND RData(10) = '0'
      report "RWConflict 2 not reset by controller reset";
    wait for 300 us; -- to clear out any pending read
    
    sbwr(X"100A", X"2200"); -- Start a read block
    loop
      sbrd(X"1000");
      exit when RData(9) = '1'; -- Read Complete
    end loop;
    sbwr(X"1006", X"DCBA");
    sbrd(X"1000");
    assert RData(13) = '1'
      report "Write with read complete should assert RWConflict";
    sbwr(X"100C", X"0000"); -- ctrlr reset
    sbrd(X"1000"); -- read ctrlr_status
    assert RData(13) = '0' AND RData(8) = '0'
      report "RWConflict 3 not reset by controller reset";
      
    WatchForSynch <= '1';
    -- wait for 20 sec;
     
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
  
  WatchSynch: Process
  Begin
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      wait until WatchForSynch = '1' OR Done = '1';
      wait until QSync = '0' OR Done = '1';
      wait until QSync = '1' for 10 us;
      assert QSync = '1' OR Done = '1'
        report "QSync pulse exceeded 10 us";
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  F8M <= F8M_int;

END ARCHITECTURE rtl;

