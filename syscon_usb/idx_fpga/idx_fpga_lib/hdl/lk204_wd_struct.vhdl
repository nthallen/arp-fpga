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
   GENERIC( 
      FIFO_WIDTH : integer range 14 downto 1 := 8
   );
   PORT( 
      LK204  : IN     std_logic;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      WData1 : OUT    std_logic_vector (FIFO_WIDTH DOWNTO 0)
   );

-- Declarations

END lk204_wd ;

--
ARCHITECTURE struct OF lk204_wd IS
BEGIN
  WData1(FIFO_WIDTH-1 DOWNTO 0) <= WData(FIFO_WIDTH-1 DOWNTO 0);
  WData1(FIFO_WIDTH) <= LK204;
END ARCHITECTURE struct;

