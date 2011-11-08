--
-- VHDL Architecture idx_fpga_lib.ptrh_hold.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:45:15 02/ 4/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh_hold IS
   PORT( 
      En0  : IN     std_ulogic;
      En1  : IN     std_ulogic;
      F8M  : IN     std_ulogic;
      RdEn : IN     std_ulogic;
      hold : OUT    std_logic;
      rst  : IN     std_ulogic
   );

-- Declarations

END ptrh_hold ;

--
ARCHITECTURE beh OF ptrh_hold IS
BEGIN
  hold_p : Process (F8M) IS
  Begin
    if F8M'Event AND F8M = '1' then
      if rst = '1' then
        hold <= '0';
      elsif RdEn = '1' AND En0 = '1' then
        hold <= '1';
      elsif RdEn = '1' AND En1 = '1' then
        hold <= '0';
      end if;
    end if;
  End Process;
END ARCHITECTURE beh;

