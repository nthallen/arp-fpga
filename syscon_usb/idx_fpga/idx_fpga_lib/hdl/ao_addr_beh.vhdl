--
-- VHDL Architecture idx_fpga_lib.ao_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:48:06 02/ 1/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ao_addr IS
   PORT( 
      Addr : IN     std_logic_vector (15 DOWNTO 0);
      BdEn : OUT    std_ulogic
   );

-- Declarations

END ao_addr ;

--
ARCHITECTURE beh OF ao_addr IS
BEGIN
  BdEn_out : Process (Addr) Is
  begin
    if Addr >= X"0400" AND Addr < X"0420" then
      BdEn <= '1';
    else
      BdEn <= '0';
    end if;
  End Process;
END ARCHITECTURE beh;

