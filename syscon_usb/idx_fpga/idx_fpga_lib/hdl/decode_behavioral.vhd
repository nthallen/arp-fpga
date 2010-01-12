--
-- VHDL Architecture idx_fpga_lib.decode.behavioral
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:35:21 12/ 9/2009
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY decode IS
   PORT( 
      Addr   : IN     std_ulogic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      RdEn   : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      BaseEn : OUT    std_ulogic;
      INTA   : OUT    std_ulogic;
      Chan   : OUT    std_ulogic_vector (2 DOWNTO 1);
      OpCd   : OUT    std_ulogic_vector (2 DOWNTO 0)
   );

-- Declarations

END decode ;

--
ARCHITECTURE behavioral OF decode IS
  SIGNAL Chan_int : std_ulogic_vector (3 downto 0);
BEGIN
  process (Addr, Chan_int) is
  begin
      if Addr = X"0040" then
        Chan_int <= b"0001";
      elsif Addr = X"0A00" then
        Chan_int <= b"0010";
      elsif Addr(15 DOWNTO 6) = B"0000101000" and Addr(0) = '0' then
        case  Addr(5 DOWNTO 3) is
          when B"001" =>
            Chan_int <= b"0100";
          when B"010" =>
            Chan_int <= b"1000";
          when others =>
            Chan_int <= b"0000";
        end case;
      else
        Chan_int <= b"0000";
      end if;
      INTA <= Chan_int(0);
      BaseEn <= Chan_int(1);
      Chan <= Chan_int(3 downto 2);
      OpCd <= Addr(2 DOWNTO 0);
  end process;
  
  process ( Chan_int, ExpRd, ExpWr ) is
  begin
    RdEn <= '0';
    WrEn <= '0';
    if (Chan_int /= b"0000") and ( ExpRd = '1' or ExpWr = '1') then
      ExpAck <= '1';
      if ExpRd = '1' then
        RdEn <= '1';
      end if;
      if ExpWr = '1' then
        WrEn <= '1';
      end if;
    else
      ExpAck <= '0';
    end if;
  end process;
      
END ARCHITECTURE behavioral;

