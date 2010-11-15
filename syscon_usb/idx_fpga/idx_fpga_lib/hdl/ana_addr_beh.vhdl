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
    F30M : IN  std_ulogic;
    BdEn : OUT std_ulogic;
    CfgAddr : OUT std_logic_vector(7 DOWNTO 0);
    AcqAddr : OUT std_logic_vector(7 DOWNTO 0)
  );
END ENTITY ana_addr;

--
ARCHITECTURE beh OF ana_addr IS
  SIGNAL permute : unsigned(5 DOWNTO 0);
  SIGNAL mapped : unsigned(5 DOWNTO 0);
BEGIN
  
  Addrs : Process (F8M) is
  Begin
    if F30M'Event AND F30M = '1' then
      permute(0) <= Addr(1);
      permute(1) <= Addr(2);
      permute(2) <= Addr(3);
      permute(3) <= Addr(5);
      permute(4) <= Addr(6);
      permute(5) <= Addr(7);
      mapped <= permute + 16#37#;
      CfgAddr(2 DOWNTO 0) <= CONV_STD_LOGIC_VECTOR(mapped(2 DOWNTO 0),3);
      CfgAddr(3) <= Addr(4);
      CfgAddr(6 DOWNTO 4) <= CONV_STD_LOGIC_VECTOR(mapped(5 DOWNTO 3),3);
      CfgAddr(7) <= '0';
      AcqAddr(6 DOWNTO 0) <= Addr(7 DOWNTO 1);
      AcqAddr(7) <= '0';
    end if;
  end process;
  
  En : Process (Addr) Is
  Begin
    if Addr(15 DOWNTO 8) = "00001100" AND Addr(0) = '0' then
      BdEn <= '1';
    else
      BdEn <= '0';
    end if;
  End Process;
END ARCHITECTURE beh;

