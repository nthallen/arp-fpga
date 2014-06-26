--
-- VHDL Architecture idx_fpga_lib.adc_v1_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:58:50 04/ 7/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY adc_v1_tester IS
   GENERIC( 
      N_ADC : integer range 4 downto 1 := 2
   );
   PORT( 
      ExpAck : IN     std_ulogic;
      RData  : IN     std_logic_vector (15 DOWNTO 0);
      rst    : OUT    std_logic;
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      En     : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      ExpWr  : OUT    std_ulogic;
      F8M    : OUT    std_ulogic
   );

-- Declarations

END adc_v1_tester ;

--

ARCHITECTURE sim OF adc_v1_tester IS
   SIGNAL Done : std_ulogic;
   SIGNAL F8M_int : std_ulogic;
   SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);
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
      wait for 1 ns;
      ExpRd <= '1';
      for i in 1 to 8 loop
        wait until F8M_int'Event AND F8M_int = '1';
      end loop;
      assert ExpAck = '1' report "No Acknowledge on read" severity error;
      Read_Result <= RData;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
    
    procedure read_all is
    begin
      sbrd(X"0E80");
      -- pragma synthesis_off
      wait for 5 us;
      sbrd(X"0E82");
      wait for 5 us;
      sbrd(X"0E84");
      wait for 5 us;
      sbrd(X"0E86");
      wait for 5 us;
      sbrd(X"0E88");
      -- pragma synthesis_on
      return;
    end procedure read_all;

  Begin
    Done <= '0';
    ExpRd <= '0';
    ExpWr <= '0';
    rst <= '1';
    En <= (others => '1');
    Addr <= (others => '0');
    -- pragma synthesis_off
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    rst <= '0';
    wait for 150 us;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 us;
    En(0) <= '0';
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 us;
    En(0) <= '1';
    En(1) <= '0';
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 us;
    En(1) <= '1';
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    wait for 1 ms;
    read_all;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  F8M <= F8M_int;

END ARCHITECTURE sim;

