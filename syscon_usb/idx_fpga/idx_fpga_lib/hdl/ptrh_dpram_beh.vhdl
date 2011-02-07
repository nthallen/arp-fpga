--
-- VHDL Architecture idx_fpga_lib.ptrh_dpram.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:47:34 02/ 4/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh_dpram IS
   PORT( 
      RegEn : IN     std_logic;
      F8M   : IN     std_ulogic;
      RdEn  : IN     std_ulogic;
      hold  : IN     std_logic;
      iData : OUT    std_logic_vector (15 DOWNTO 0);
      wData : IN     std_logic_vector (15 DOWNTO 0);
      WrEn  : IN     std_ulogic;
      F25M  : IN     std_ulogic;
      Full  : OUT    std_ulogic
   );

-- Declarations

END ptrh_dpram ;

--
ARCHITECTURE beh OF ptrh_dpram IS
  SIGNAL R0: std_logic_vector(15 DOWNTO 0);
  SIGNAL R1: std_logic_vector(15 DOWNTO 0);
  SIGNAL Full_int: std_ulogic;
  SIGNAL Txfrd: std_ulogic;
BEGIN
  R1_proc : Process (F8M) IS
  Begin
    if F8M'Event and F8M = '1' then
      if Full_int = '0' then
        Txfrd <= '0';
      elsif RdEn = '0' AND hold = '0' then
        Txfrd <= '1';
        R1 <= R0;
      end if;
    end if;
  End Process;
  
  D_proc : Process (F8M) IS
  Begin
    if F8M'Event AND F8M = '1' then
      if RdEn = '1' and RegEn = '1' then
        iData <= R1;
      else
        iData <= (others => 'Z');
      end if;
    end if;
  End Process;
  
  R0_proc : Process (F25M) IS
  Begin
    if F25M'Event AND F25M = '1' then
      if WrEn = '1' AND Full_int = '0' then
        R0 <= wData;
        Full_int <= '1';
      elsif Txfrd = '1' then
        Full_int <= '0';
      end if;
    end if;
  End Process;
  
  Full <= Full_int;
  
END ARCHITECTURE beh;
