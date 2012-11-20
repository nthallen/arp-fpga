--
-- VHDL Architecture idx_fpga_lib.lk204_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:51:19 09/13/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.all;

ENTITY lk204_tester IS
   PORT( 
      BdIntr   : IN     std_ulogic;
      ExpAck   : IN     std_ulogic;
      RData    : IN     std_logic_vector (15 DOWNTO 0);
      Addr     : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd    : OUT    std_ulogic;
      ExpWr    : OUT    std_ulogic;
      F8M      : OUT    std_ulogic;
      INTA     : OUT    std_ulogic;
      RE       : OUT    std_logic;
      Rst      : OUT    std_logic;
      WData    : OUT    std_logic_vector (15 DOWNTO 0);
      switches : OUT    std_logic_vector (7 DOWNTO 0);
      scl      : INOUT  std_logic_vector (0 TO 0);
      sda      : INOUT  std_logic_vector (0 TO 0);
      LEDs     : IN     std_ulogic_vector (7 DOWNTO 0)
   );

-- Declarations

END lk204_tester ;

--
ARCHITECTURE sim OF lk204_tester IS
   SIGNAL Done   : std_logic;
   SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0); 
   SIGNAL switches_int: std_logic_vector(1 DOWNTO 0);
BEGIN
  clock : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F8M <= '0';
      wait for 62 ns;
      F8M <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : process is
  
    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Addr <= addr_in;
      -- pragma synthesis_off
      wait for 125 ns;
      ExpRd <= '1';
      wait for 1 us;
      assert ExpAck = '1' report "No Acknowledge on read" severity error;
      Read_Result <= RData;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
    
    procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      Addr <= Addr_In;
      WData <= Data_in;
      -- pragma synthesis_off
      wait for 40 ns;
      ExpWr <= '1';
      wait for 1 us;
      assert ExpAck = '1' report "No acknowledge on write" severity error;
      ExpWr <= '0';
      wait for 250 ns;
      -- pragma synthesis_on
      return;
    end procedure sbwr;
    
    procedure check_read( Addr_In : IN std_logic_vector(15 downto 0);
                          Chk_Data : IN std_logic_vector(15 downto 0) ) is
    begin
      sbrd(Addr_In);
      assert Read_Result = Chk_Data
        report "Readback data incorrect"
        severity error;
      return;
    end procedure;
  Begin
    Done <= '0';
    Rst <= '1';
    Addr <= X"0000";
    WData <= X"0000";
    ExpWr <= '0';
    ExpRd <= '0';
    INTA <= '0';
    scl(0) <= 'H';
    sda(0) <= 'H';
    switches_int <= "00";
    -- pragma synthesis_off
    wait until F8M'Event AND F8M = '1';
    wait until F8M'Event AND F8M = '1';
    Rst <= '0';
    wait until F8M'Event AND F8M = '1';
    wait until F8M'Event AND F8M = '1';
    
    loop
      sbrd( X"1104" );
      if Read_Result(0) = '1' AND Read_Result(1) = '1' then
        exit;
      end if;
      wait for 350 us;
    end loop;
    sbwr( X"1102", X"0048"); -- H
    wait for 4 ms;
    sbrd( X"1104" );
    sbwr( X"1102", X"0065"); -- e
    sbwr( X"1102", X"006C"); -- l
    sbwr( X"1102", X"006C"); -- l
    sbwr( X"1102", X"006F"); -- o
    wait for 4 ms;
    sbrd( X"1104" );
    wait for 4 ms;
    sbrd( X"1104" );
    
    -- Wait for a polling event...
    wait for 120 ms;
    sbrd( X"1104" );
    assert Read_Result(4) = '1'
      report "Expected non-empty flag" severity error;
    assert BdIntr = '0'
      report "Expected BdIntr to be masked" severity error;
    sbwr( X"1100", X"0020"); -- Enable interrupt
    assert BdIntr = '1'
      report "Expected BdIntr to be unmasked" severity error;
    sbrd( X"1102"); -- Read from the keypad queue
    wait for 1 us;
    assert Read_Result(4) = '1'
      report "Expected empty flag" severity error;
    assert BdIntr = '0'
      report "Expected BdIntr to clear itself" severity error;
    wait until BdIntr = '1';
    wait for 2 us;
    wait until F8M'Event AND F8M = '1';
    INTA <= '1';
    for i in 1 to 8 loop
      wait until F8M'Event AND F8M = '1';
    end loop;
    INTA <= '0';
    wait until F8M'Event AND F8M = '1';
    wait until F8M'Event AND F8M = '1';
    wait until F8M'Event AND F8M = '1';
    assert BdIntr = '0'
      report "Expected BdIntr to clear itself after INTA" severity error;
    wait for 350 us;
    
    sbwr( X"1102", X"01FE" );
    sbrd( X"1104" );
    assert(Read_Result(15 downto 8) = X"00")
      report "Expected no switches or LEDs asserted" severity error;
    wait for 350 us;
    sbwr( X"1102", X"01A0" );
    sbrd( X"1104" );
    wait for 350 us;
    sbwr( X"1102", X"0000" );
    sbrd( X"1104" );
    wait for 10 ms;
    sbrd( X"1104" );
    wait for 350 us;
    switches_int <= "01"; -- Assert Purge switch
    wait for 150 ms;
    assert(LEDs(4) = '0')
      report "Expected Purge LED" severity error;
    wait for 150 ms;
    sbrd( X"1104" );
    assert(Read_Result(15 downto 8) = X"11")
      report "Expected Purge switch and LED status" severity error;
    switches_int <= "00"; -- Release Purge switch;
    wait for 150 ms;
    assert(LEDs(4) = '0')
      report "Expected Purge LED to stay on after switch release"
      severity error;
    sbrd(X"1104");
    assert(Read_Result(15 downto 8) = X"10")
      report "Status invalid: expected Purge LED w/o switch"
      severity error;
    sbwr(X"1104", X"0010"); -- Clear Purge LED
    wait for 10 ms;
    assert(LEDs(4) = '1')
      report "Purge LED should be off after write"
      severity error;
    sbwr(X"1104", X"00A0"); -- Set Land LED
    wait for 10 ms;
    assert(LEDs(5) = '0')
      report "Land LED should be on after set command"
      severity error;
    sbwr(X"1104", X"0090"); -- Set Purge LED
    wait for 10 ms;
    assert(LEDs(4) = '0')
      report "Purge LED should be on after set command"
      severity error;
    sbwr(X"1104", X"0030"); -- Clear both LEDs
    wait for 10 ms;
    assert(LEDs(5 downto 4) = "11")
      report "Both LEDs should be off after clear command"
      severity error;
    wait for 10 ms;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
  
  switches(7 downto 6) <= "00";
  switches(5 downto 4) <= not std_logic_vector(LEDs(5 downto 4));
  switches(3 downto 2) <= "00";
  switches(1 downto 0) <= switches_int;
  RE <= '1';
END ARCHITECTURE sim;

