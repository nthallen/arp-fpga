--
-- VHDL Architecture idx_fpga_lib.bench_RateGen.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:09:58 01/14/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

    -- Ignore the following package references for synthesis
    -- pragma synthesis_off
    LIBRARY std_developerskit;
    USE std_developerskit.std_iopak.all;
    -- pragma synthesis_on
   
ENTITY bench_RateGen IS
END ENTITY bench_RateGen;

--
ARCHITECTURE arch OF bench_RateGen IS
  SIGNAL F4M      :  std_ulogic;
  SIGNAL rst      :  std_ulogic;
  SIGNAL WrEn     :  std_ulogic; 
  SIGNAL CfgEn    :  std_ulogic;
  SIGNAL rclk     :  std_ulogic;
  SIGNAL ratesel  :  std_logic_vector(3 downto 0);
  SIGNAL ratectr  :  std_logic_vector(15 downto 0);
  COMPONENT RateGen IS
   PORT( 
      CfgEn : IN     std_ulogic;
      F4M   : IN     std_ulogic;
      rst   : IN     std_ulogic;
      WrEn  : IN     std_ulogic;
      rclk  : OUT    std_ulogic;
      ratesel  : IN  std_logic_vector (3 DOWNTO 0)
 );
  END COMPONENT;
BEGIN
  DUT  : RateGen
    PORT MAP ( 
      F4M => F4M,
      rst => rst,
      WrEn => WrEn,
      CfgEn   => CfgEn,
      ratesel => ratesel,
      rclk => rclk );

  reset_proc : Process
  Begin
    rst <= '1';
    --  pragma synthesis_off
   wait for 1 us;
    rst <= '0';
   wait;
    -- pragma synthesis_on
  End Process;

  clock_proc : Process
  Begin
    F4M <= '0';
    -- pragma synthesis_off
   wait for 125 ns;
    F4M <= '1';
   wait for 125 ns;
    -- pragma synthesis_on
  End Process;
  
  rate_cnt : Process ( rclk, CfgEn )
  Begin
    if CfgEn = '1' then
      ratectr <= X"0000";
    elsif rclk'Event and rclk = '1' then
      ratectr <= ratectr + 1;
    end if;
  End Process;

  test_seq : Process
    procedure test_rate ( selector : in std_logic_vector (3 downto 0);
                          target_rate : in std_logic_vector (15 downto 0) ) is
    begin
      WrEn <= '0';
      CfgEn <= '0';
      ratesel <= selector;
      -- pragma synthesis_off
     wait for 2 us;
      CfgEn <= '1';
     wait for 1 us;
      WrEn <= '1';
     wait for 1 us;
      WrEn <= '0';
     wait for 1 us;
      CfgEn <= '0';
     wait for 1000 ms;
      assert ratectr = target_rate report "Rate was " & To_String(ratectr, "%d")
        & ": expected " & To_String(target_rate, "%s") severity error;
      -- pragma synthesis_on
      return;
    end procedure test_rate;
  Begin
    WrEn <= '0';
    CfgEn <= '0';
    ratesel <= "0000";
    -- pragma synthesis_off
    test_rate( X"0", X"0035"); -- 53Hz
    test_rate( X"1", X"004F"); -- 80Hz 79?
    test_rate( X"2", X"006B"); -- 107 Hz
    test_rate( X"3", X"00A0"); -- 160 Hz
    test_rate( X"4", X"010B"); -- 267 Hz
    test_rate( X"5", X"0190"); -- 400 Hz
    test_rate( X"6", X"0214"); -- 533 Hz 532?
    test_rate( X"7", X"0320"); -- 800 Hz
    test_rate( X"8", X"042C"); -- 1067 Hz 1068?
    test_rate( X"9", X"063F"); -- 1600 Hz 1599?
    test_rate( X"A", X"0857"); -- 2133 Hz 2135?
    test_rate( X"B", X"0C80"); -- 3200 Hz
    test_rate( X"C", X"14D5"); -- 5333 Hz
    test_rate( X"D", X"1F40"); -- 8000 Hz
    test_rate( X"E", X"28AB"); -- 10667 Hz got 29C7
    test_rate( X"F", X"3E80"); -- 16000 Hz
   wait;
    -- pragma synthesis_on
  End Process;
END ARCHITECTURE arch;

