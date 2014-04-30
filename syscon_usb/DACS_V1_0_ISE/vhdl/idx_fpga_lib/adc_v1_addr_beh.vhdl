--
-- VHDL Architecture idx_fpga_lib.adc_v1_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 10:28:29 04/ 7/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adc_v1_addr IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 downto 0) := X"0E80"
   );
   PORT( 
      Addr     : IN     std_logic_vector (15 DOWNTO 0);
      BdEn     : OUT    std_ulogic;
      HighWord : OUT    std_logic
   );

-- Declarations

END adc_v1_addr ;

--
ARCHITECTURE beh OF adc_v1_addr IS
BEGIN
  BdEn_out : Process (Addr) Is
  begin
    if  Addr = BASE_ADDR then
      BdEn <= '1';
      HighWord <= '0';
    elsif Addr = BASE_ADDR + 2 then
      BdEn <= '1';
      HighWord <= '1';
    else
      BdEn <= '0';
      HighWord <= '0';
    end if;
  End Process;
END ARCHITECTURE beh;

