--
-- VHDL Architecture idx_fpga_lib.ana_ctrl_reg.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 08:20:49 03/17/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_ctrl_reg IS
   PORT( 
      CtrlEn : IN     std_ulogic;
      F30M   : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      WData  : IN     std_logic_vector (9 DOWNTO 0);
      WrEn   : IN     std_ulogic;
      AICtrl : OUT    std_logic_vector (9 DOWNTO 0)
   );

-- Declarations

END ana_ctrl_reg ;

--
ARCHITECTURE beh OF ana_ctrl_reg IS
  SIGNAL AICtrl_In : std_logic_vector(9 DOWNTO 0);
BEGIN
  W : Process (F8M) IS
  Begin
    if F8M'Event and F8M = '1' then
      if rst = '1' then
        AICtrl_In <= (others => '0');
      elsif CtrlEn = '1' AND WrEn = '1' then
        AICtrl_In <= WData;
      end if;
    end if;
  End Process;
  
  R : Process (F30M) IS
  Begin
    if F30M'Event and F30M = '1' then
      AICtrl <= AICtrl_In;
    end if;
  End Process;

END ARCHITECTURE beh;

