--
-- VHDL Architecture idx_fpga_lib.bench_ptrhm_acquire_tester.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:34:09 11/23/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.ALL;

ENTITY bench_ptrhm_acquire_tester IS
   GENERIC( 
      N_ISBITS : integer range 7 downto 1 := 4
   );
   PORT( 
      ExpAck : IN     std_ulogic;
      rData  : IN     std_logic_vector (15 DOWNTO 0);
      wdata0 : IN     std_ulogic_vector (7 DOWNTO 0);
      wdata1 : IN     std_ulogic_vector (7 DOWNTO 0);
      wdata2 : IN     std_ulogic_vector (7 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      ExpWr  : OUT    std_ulogic;
      F8M    : OUT    std_ulogic;
      rst    : OUT    std_logic;
      scl    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );

-- Declarations

END bench_ptrhm_acquire_tester ;

--
ARCHITECTURE rtl OF bench_ptrhm_acquire_tester IS
  SIGNAL ClkDone : std_ulogic;
BEGIN

  clock : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while ClkDone = '0' loop
      F8M <= '0';
      wait for 62 ns;
      F8M <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  testproc : Process Is
      procedure sbrd_check( addr_in : std_logic_vector (15 DOWNTO 0);
          expected : std_logic_vector(15 DOWNTO 0) ) is
      begin
        -- pragma synthesis_off
        wait until F8M'Event AND F8M = '1';
        Addr <= addr_in;
        ExpRd <= '1';
        wait for 1 us;
        assert ExpAck = '1' report "No Acknowledge on read" severity error;
        assert RData = expected
         report "Input " & to_hstring(addr_in) & " Incorrect: "
                & to_hstring(RData) & " expected " & to_hstring(expected)
         severity error;
        ExpRd <= '0';
        wait for 40 ns;
        -- pragma synthesis_on
      end procedure sbrd_check;
  Begin
    ClkDone <= '0';
    rst <= '1';
    Addr <= (others => '0');
    ExpRd <= '0';
    ExpWr <= '0';
    scl <= (others => 'H');
    sda <= (others => 'H');
    -- pragma synthesis_off
    wait until F8M'event AND F8M = '1';
    wait until F8M'event AND F8M = '1';
    rst <= '0';
    
    wait for 1000 ms;
    sbrd_check(X"0206", X"000F");
    
    ClkDone <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
  
END ARCHITECTURE rtl;

