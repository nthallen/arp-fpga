--
-- VHDL Architecture idx_fpga_lib.test_syntax.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:55:08 09/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY test_syntax IS
  GENERIC ( N_CONNECTORS : integer range 4 DOWNTO 1 := 2 );
  PORT (
    IO : INOUT std_logic_vector( N_CONNECTORS*6*8-1 DOWNTO 0)
  );
END ENTITY test_syntax;

--
ARCHITECTURE beh OF test_syntax IS
BEGIN
END ARCHITECTURE beh;

