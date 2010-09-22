--
-- VHDL Package Header idx_fpga_lib.Digio_types
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:13:25 09/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
PACKAGE Digio_types IS
  type IOarray is array (1 to 0, 5 to 0) of std_logic_vector (7 DOWNTO 0);
END Digio_types;
