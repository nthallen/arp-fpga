--
-- VHDL Architecture idx_fpga_lib.tmp_func.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:53:54 01/19/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tmp_func IS
END ENTITY tmp_func;

--
ARCHITECTURE sim OF tmp_func IS
  pure function mkaddr(
    row : in std_logic_vector(5 DOWNTO 0);
    bank : in std_logic_vector(0 DOWNTO 0);
    col : in std_logic_vector(2 DOWNTO 0) 
  ) return std_logic_vector is
    variable rv : std_logic_vector(7 DOWNTO 0);
  begin
    rv := '0' & row(2 DOWNTO 0) & bank & col;
    return rv;
  end mkaddr;
  SIGNAL Row : std_logic_vector(5 DOWNTO 0);
  SIGNAL Bank : std_logic_vector(0 DOWNTO 0);
  SIGNAL Col : std_logic_vector(2 DOWNTO 0);
  SIGNAL Addr : std_logic_vector(7 DOWNTO 0);
BEGIN
  
  test_proc : Process Is
  Begin
    Row <= "010100";
    Bank <= "1";
    Col <= "010";
    Addr <= X"00";
    -- pragma synthesis_off
    wait for 100 ns;
    Addr <= mkaddr(Row,Bank,Col);
    wait for 100 nx;
    wait;
    -- pragma synthesis_on
  End Process;
  
END ARCHITECTURE sim;

