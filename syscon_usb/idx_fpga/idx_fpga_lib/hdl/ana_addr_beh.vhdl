--
-- VHDL Architecture idx_fpga_lib.ana_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:59:50 10/29/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_addr IS
  PORT (
    Addr : IN  std_logic_vector(15 DOWNTO 0);
    BdEn : OUT std_ulogic;
    CfgAddr : OUT std_logic_vector(7 DOWNTO 0);
    AcqAddr : OUT std_logic_vector(8 DOWNTO 0)
  );
END ENTITY ana_addr;

--
ARCHITECTURE beh OF ana_addr IS
BEGIN
  
  Addrs : Process (Addr) is
  Begin
    CfgAddr <= Addr(8 downto 1);
    AcqAddr <= Addr(8 DOWNTO 0);
    if Addr(15 DOWNTO 9) = "0000110" then
      BdEn <= '1';
    else
      BdEn <= '0';
    end if;
  end process;

END ARCHITECTURE beh;

