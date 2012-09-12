--
-- VHDL Architecture idx_fpga_lib.lk204_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:56:56 08/23/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_addr IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1100"
   );
   PORT( 
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      BdEn  : OUT    std_ulogic;
      LK204 : OUT    std_logic
   );

-- Declarations

END lk204_addr ;

--
ARCHITECTURE beh OF lk204_addr IS
BEGIN
  decode : Process ( Addr ) IS
  BEGIN
    if Addr = BASE_ADDR then
      BdEn <= '1';
      LK204 <= '1';
    elsif Addr = BASE_ADDR + 1 then
      BdEn <= '1';
      LK204 <= '0';
    else
      BdEn <= '0';
      LK204 <= '0';
    end if;
  END Process;
END ARCHITECTURE beh;

