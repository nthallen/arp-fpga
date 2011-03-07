--
-- VHDL Architecture idx_fpga_lib.ptrh_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:39:31 02/ 4/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh_addr IS
   GENERIC (
     BASE_ADDR : unsigned(15 DOWNTO 0) := X"0300"
   );
   PORT( 
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      BdEn  : OUT    std_ulogic;
      RegEn : OUT    std_logic_vector (12 DOWNTO 0)
   );

-- Declarations

END ptrh_addr ;

--
ARCHITECTURE beh OF ptrh_addr IS
  SIGNAL RegEn_int : std_logic_vector(12 DOWNTO 0);
BEGIN
  decode : Process (Addr, RegEn_int ) Is
  Begin
    BdEn <= '0';
    RegEn_int <= (others => '0');
    if Addr = BASE_ADDR+0 then
      RegEn_int(0) <= '1';
    elsif Addr = BASE_ADDR+2 then
      RegEn_int(1) <= '1';
    elsif Addr = BASE_ADDR+4 then
      RegEn_int(2) <= '1';
    elsif Addr = BASE_ADDR+6 then
      RegEn_int(3) <= '1';
    elsif Addr = BASE_ADDR+8 then
      RegEn_int(4) <= '1';
    elsif Addr = BASE_ADDR+10 then
      RegEn_int(5) <= '1';
    elsif Addr = BASE_ADDR+12 then
      RegEn_int(6) <= '1';
    elsif Addr = BASE_ADDR+14 then
      RegEn_int(7) <= '1';
    elsif Addr = BASE_ADDR+16 then
      RegEn_int(8) <= '1';
    elsif Addr = BASE_ADDR+18 then
      RegEn_int(9) <= '1';
    elsif Addr = BASE_ADDR+20 then
      RegEn_int(10) <= '1';
    elsif Addr = BASE_ADDR+22 then
      RegEn_int(11) <= '1';
    elsif Addr = BASE_ADDR+24 then
      RegEn_int(12) <= '1';
    end if;

    for i in 0 to 12 loop
      if RegEn_int(i) = '1' then
        BdEn <= '1';
      end if;
    end loop;
    
  End Process;

  RegEn <= RegEn_int;

END ARCHITECTURE beh;
