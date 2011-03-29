--
-- VHDL Architecture idx_fpga_lib.ana_rdata.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:25:32 03/28/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_rdata IS
   PORT( 
      DataEn   : IN     std_ulogic;
      RD_DATA1 : IN     std_logic_vector (15 DOWNTO 0);
      StatEn   : IN     std_ulogic;
      Status   : IN     std_ulogic_vector (11 DOWNTO 0);
      RData    : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END ana_rdata ;

--
ARCHITECTURE beh OF ana_rdata IS
BEGIN
  DB : Process (DataEn, RD_DATA1, StatEn, Status ) IS
  Begin
    RData <= (others => '0');
    if DataEn = '1' then
      RData <= RD_DATA1;
    elsif StatEn = '1' then
      RData(11 DOWNTO 0) <= std_logic_vector(Status);
    end if;
  End Process;
END ARCHITECTURE beh;
