--
-- VHDL Architecture idx_fpga_lib.lk204_engstat.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:36:53 09/20/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_engstat IS
   PORT( 
      Empty     : IN     std_logic;
      LKWrEn    : IN     std_logic;
      Status    : IN     std_logic_vector (15 DOWNTO 0);
      WQFull    : IN     std_logic;
      EngStatus : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END lk204_engstat ;

--
ARCHITECTURE struct OF lk204_engstat IS
BEGIN
  EngStatus(15 downto 8) <= Status(15 downto 8);
  EngStatus(4 downto 0) <= Status(4 downto 0);
  EngStatus(5) <= not Empty;
  EngStatus(6) <= WQFull;
  EngStatus(7) <= LKWrEn;
END ARCHITECTURE struct;

