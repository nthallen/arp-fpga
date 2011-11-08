--
-- VHDL Architecture idx_fpga_lib.bench_ptrhm_i2c_sm_tester.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:29:28 11/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.ALL;

ENTITY bench_ptrhm_i2c_sm_tester IS
   GENERIC( 
      N_ISBITS : integer range 20 DOWNTO 2
   );
   PORT( 
      done      : IN     std_ulogic;
      err       : IN     std_ulogic;
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
      scl       : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda       : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      En        : OUT    std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      F8M       : OUT    std_ulogic;
      cmd       : OUT    ptrhm_i2c_op;
      i2c_addr  : OUT    std_ulogic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      rst       : OUT    std_ulogic
   );

-- Declarations

END bench_ptrhm_i2c_sm_tester ;

--
ARCHITECTURE rtl OF bench_ptrhm_i2c_sm_tester IS
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
  Begin
    ClkDone <= '0';
    cmd <= NOP;
    En <= "01";
    i2c_addr <= (others => '0');
    i2c_wdata <= (others => '0');
    rst <= '1';
    scl <= (others => 'H');
    sda <= (others => 'H');
    -- pragma synthesis_off
    wait until F8M'event AND F8M = '1';
    wait until F8M'event AND F8M = '1';
    rst <= '0';
    wait until F8M'event AND F8M = '1';
    assert done = '0' AND err = '0'
      report "Done and err not clear after reset"
      severity error;
    for i in N_ISBITS-1 DOWNTO 0 loop
      assert To_01(sda(i)) = '1' AND To_01(scl(i)) = '1'
        report "I2C bus not inactive after reset"
        severity error;
    end loop;
    wait until done = '1';
    wait until done = '0';
  -- Write to existing address
  --  with device enabled: verify success
    i2c_addr <= "1000000";
    i2c_wdata <= X"5A";
    cmd <= Write;
    wait until done = '1' OR err = '1';
    assert done = '1' AND err = '0'
      report "Unexpected failure writing to first device"
      severity error;
  --  with other device enabled: verify failure
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "10";
    cmd <= Write;
    wait until done = '1' OR err = '1';
    assert done = '0' AND err = '1'
      report "Unexpected success writing to second device"
      severity error;
  --  with both devices enabled: verify success
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "11";
    cmd <= Write;
    wait until done = '1' OR err = '1';
    assert done = '1' AND err = '0'
      report "Unexpected failure writing to both devices"
      severity error;
  --  with neither device enabled: verify failure
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "00";
    cmd <= Write;
    wait until done = '1' OR err = '1';
    assert done = '0' AND err = '1'
      report "Unexpected success writing to no devices"
      severity error;
  -- WriteRead2: verify two bytes of data
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "01";
    cmd <= WriteRead2;
    wait until done = '1' OR err = '1';
    assert done = '1' AND err = '0'
      report "Unexpected failure reading 2 bytes from first device"
      severity error;
  -- WriteRead3: verify three bytes of data
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "01";
    cmd <= WriteRead3;
    wait until done = '1' OR err = '1';
    assert done = '1' AND err = '0'
      report "Unexpected failure reading 3 bytes from first device"
      severity error;
  -- SelectAll : verify command failure
    cmd <= NOP;
    wait until done = '0' AND err = '0';
    En <= "01";
    cmd <= SelectAll;
    wait until done = '1' OR err = '1';
    assert done = '0' AND err = '1'
      report "Unexpected success with unsupported command"
      severity error;
    
    ClkDone <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
END ARCHITECTURE rtl;

