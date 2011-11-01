--
-- VHDL Architecture idx_fpga_lib.i2c_half_switch.syn
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:42:51 11/ 1/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;

ENTITY i2c_half_switch IS
   PORT( 
      ISwitch      : IN     std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      scl_pad_o    : IN     std_logic;
      scl_padoen_o : IN     std_logic;
      scl_pad_i    : OUT    std_logic;
      scl          : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );

-- Declarations

END i2c_half_switch ;

--
ARCHITECTURE syn OF i2c_half_switch IS
BEGIN
END ARCHITECTURE syn;

