--
-- VHDL Architecture idx_fpga_lib.lk204_wd.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:07:09 09/10/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_wd IS
   PORT( 
      LK204  : IN     std_logic;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      En     : OUT    std_ulogic_vector (0 TO 0);
      WData1 : OUT    std_logic_vector (8 DOWNTO 0)
   );

-- Declarations

END lk204_wd ;

--
ARCHITECTURE struct OF lk204_wd IS
BEGIN
  WData1(7 DOWNTO 0) <= WData(7 DOWNTO 0);
  WData1(8) <= LK204;
  En(0) <= '1';
END ARCHITECTURE struct;

