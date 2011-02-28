--
-- VHDL Architecture idx_fpga_lib.idx_ch_rd.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:26:35 02/28/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY idx_ch_rd IS
   PORT( 
      OpCd     : IN     std_logic_vector (2 DOWNTO 0);
      PosData  : IN     std_logic_vector ( 15 DOWNTO 0 );
      StatData : IN     std_logic_vector ( 15 DOWNTO 0 );
      RData    : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END idx_ch_rd ;

--
ARCHITECTURE beh OF idx_ch_rd IS
BEGIN
  RD : Process (OpCd, PosData, StatData) Is
  Begin
    if OpCd = "100" then
      RData <= PosData;
    elsif OpCd = "110" then
      RData <= StatData;
    else
      RData <= (others => '0');
    end if;
  End Process;
END ARCHITECTURE beh;

