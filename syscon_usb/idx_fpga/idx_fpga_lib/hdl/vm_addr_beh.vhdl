--
-- VHDL Architecture idx_fpga_lib.vm_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:49:48 04/19/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY vm_addr IS
  GENERIC( 
    BASE_ADDR : unsigned(15 DOWNTO 0) := X"0360"
  );
  PORT( 
    Addr  : IN     std_logic_vector (15 DOWNTO 0);
    BdEn  : OUT    std_ulogic;
    RegEn : OUT    std_ulogic_vector (4 DOWNTO 0)
  );

-- Declarations

END ENTITY vm_addr ;

--
ARCHITECTURE beh OF vm_addr IS
  SIGNAL RegEn_int : std_ulogic_vector(4 DOWNTO 0);
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
    end if;

    for i in 0 to 4 loop
      if RegEn_int(i) = '1' then
        BdEn <= '1';
      end if;
    end loop;
    
  End Process;

  RegEn <= RegEn_int;
  
END ARCHITECTURE beh;

