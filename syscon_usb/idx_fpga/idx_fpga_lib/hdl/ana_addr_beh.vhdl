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
    Variable permute : unsigned(5 DOWNTO 0);
    Variable mapped : unsigned(5 DOWNTO 0);
  Begin
    if Addr(8) = '1' then
      CfgAddr <= Addr(8 downto 1);
    else
      permute(0) := Addr(1);
      permute(1) := Addr(2);
      permute(2) := Addr(3);
      permute(3) := Addr(5);
      permute(4) := Addr(6);
      permute(5) := Addr(7);
      mapped := permute + 16#37#;
      CfgAddr(2 DOWNTO 0) <= CONV_STD_LOGIC_VECTOR(mapped(2 DOWNTO 0),3);
      CfgAddr(3) <= Addr(4);
      CfgAddr(6 DOWNTO 4) <= CONV_STD_LOGIC_VECTOR(mapped(5 DOWNTO 3),3);
      CfgAddr(7) <= '0';
    end if;
    AcqAddr <= Addr(8 DOWNTO 0);
    if Addr(15 DOWNTO 9) = "0000110" then
      BdEn <= '1';
    else
      BdEn <= '0';
    end if;
  end process;

END ARCHITECTURE beh;

