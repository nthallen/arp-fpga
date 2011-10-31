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
  generic (
    N_PTRH : integer;
    N_ESID : integer;
    N_ISBITS : integer
  );
  type ISB_array is array (0 to N_ESID-1) of integer range 0 to N_ISBITS-1;
  type ESA_array is array (0 to N_ESID-1) of std_ulogic_vector(7 downto 0);
  type ESID_array is array(0 to N_PTRH-1) of integer range 0 to N_ESID-1;
  type ESB_array is array(0 to N_PTRH-1) of integer range 0 to 7;
  type ptrhm_i2c_op is (SelectAll, DeselectAll, SelectOne, WriteRead2, WriteRead3);
END ptrhm;
