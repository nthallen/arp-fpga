--
-- VHDL Architecture idx_fpga_lib.RateGen.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:45:36 12/18/2009
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY RateGen IS
   PORT( 
      CfgEn : IN     std_ulogic;
      F4M   : IN     std_ulogic;
      WrEn  : IN     std_ulogic;
      rclk  : OUT    std_ulogic;
      ratesel  : IN     std_logic_vector (3 DOWNTO 0)
   );

-- Declarations

END RateGen ;

--
ARCHITECTURE arch OF RateGen IS
  signal Divisor : std_logic_vector (15 downto 0) := X"0000";
  signal DivTmp : std_logic_vector (15 downto 0) := X"0000";
  signal Cnt : std_logic_vector (15 downto 0) := X"0000";
  signal rclk_int : std_ulogic := '0';
BEGIN
  process (WrEn,DivTmp,CfgEn) is
  begin
    if WrEn'Event and WrEn = '1' and CfgEn = '1' then
      case ratesel is
        when X"0" => DivTmp <= X"9366";
        when X"1" => DivTmp <= X"61A7";
        when X"2" => DivTmp <= X"4902";
        when X"3" => DivTmp <= X"30D3";
        when X"4" => DivTmp <= X"1D41";
        when X"5" => DivTmp <= X"1387";
        when X"6" => DivTmp <= X"0EA7";
        when X"7" => DivTmp <= X"09C3";
        when X"8" => DivTmp <= X"0751";
        when X"9" => DivTmp <= X"04E1";
        when X"A" => DivTmp <= X"03A8";
        when X"B" => DivTmp <= X"0270";
        when X"C" => DivTmp <= X"0176";
--      when X"D" => DivTmp <= X"00F9";
--      when X"E" => DivTmp <= X"00BA";
--      when X"F" => DivTmp <= X"007C"; 
        when X"D" => DivTmp <= X"0003";
        when X"E" => DivTmp <= X"0002";
        when X"F" => DivTmp <= X"0001";
        when others => DivTmp <= X"0000";
      end case;
    end if;
    Divisor <= DivTmp;
  end process;
  
  process (F4M, rclk_int) is
  begin
    if F4M'Event and F4M = '1' then
      if Cnt = X"0000" then
        rclk_int <= not rclk_int;
        Cnt <= Divisor;
      else
        Cnt <= Cnt - 1;
      end if;
    end if;
    rclk <= rclk_int;
  end process;
END ARCHITECTURE arch;

