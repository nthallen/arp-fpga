--
-- VHDL Architecture idx_fpga_lib.IntrCtrl.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:05:21 09/17/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY IntrCtrl IS
   PORT( 
      F8M    : IN     std_ulogic;
      Ictrl  : IN     std_logic;
      Ireq   : IN     std_ulogic;
      Rst    : IN     std_logic;
      WData  : IN     std_logic;
      WrEn   : IN     std_ulogic;
      BdIntr : OUT    std_logic
   );

-- Declarations

END IntrCtrl ;

--
ARCHITECTURE beh OF IntrCtrl IS
  SIGNAL IntrEn : std_logic;
BEGIN
  SetEn : Process (F8M) IS
  BEGIN
    if F8M'Event AND F8M = '1' then
      if Rst = '1' then
        IntrEn <= '0';
      elsif WrEn = '1' AND Ictrl = '1' then
        IntrEn <= WData;
      end if;
    end if;
  END Process;
  
  IntrOut : Process (IntrEn, Ireq) IS
  BEGIN
    if IntrEn = '1' AND Ireq = '1' then
      BdIntr <= '1';
    else
      BdIntr <= '0';
    end if;
  END Process;
END ARCHITECTURE beh;

