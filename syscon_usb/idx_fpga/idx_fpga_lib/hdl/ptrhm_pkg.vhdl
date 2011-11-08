--
-- VHDL Package Header idx_fpga_lib.ptrhm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:44:30 10/28/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
PACKAGE ptrhm IS
  type ISB_array is array (integer range <>) of integer;
  type ESA_array is array (integer range <>) of std_ulogic_vector(6 downto 0);
  type ESID_array is array(integer range <>) of integer;
  type ESB_array is array(integer range <>) of integer range 0 to 7;
  type ptrhm_i2c_op is (Init, NOP, SelectAll, DeselectAll, SelectOne, Write, WriteRead2, WriteRead3);
END ptrhm;
