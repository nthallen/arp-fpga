--
-- VHDL Architecture idx_fpga_lib.qclic_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:13:58 12/13/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_addr IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
   );
   PORT( 
      Addr : IN     std_logic_vector (15 DOWNTO 0);
      BdEn : OUT    std_ulogic;
      cmd  : OUT    std_logic_vector (2 DOWNTO 0)
   );

-- Declarations

END qclic_addr ;

--
ARCHITECTURE beh OF qclic_addr IS
BEGIN
  decode : Process ( Addr ) IS
  BEGIN
    if Addr(0) = '0' AND Addr >= BASE_ADDR AND
       Addr <= BASE_ADDR + 14 then
      BdEn <= '1';
      cmd <= Addr(4 DOWNTO 1);
    else
      BdEn <= '0';
      cmd <= (others => '1'); -- Invalid command
    end if;
  END Process;
END ARCHITECTURE beh;

