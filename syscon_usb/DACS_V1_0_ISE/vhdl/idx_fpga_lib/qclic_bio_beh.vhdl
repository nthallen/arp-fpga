--
-- VHDL Architecture idx_fpga_lib.qclic_bio.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:42:08 12/13/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_bio IS
   PORT( 
      o  : IN     std_ulogic;
      en : IN     std_logic;
      io : INOUT  std_logic;
      i  : OUT    std_ulogic
   );

-- Declarations

END qclic_bio ;

--
ARCHITECTURE beh OF qclic_bio IS
BEGIN
  with io select
    i <= '1' when '1',
         '1' when 'H',
         '0' when others;
  -- i <= To_01(std_ulogic(io),'0');
  
  output_p : Process (o,en) Is
  Begin
    if en = '1' then
      if o = '1' then
        io <= '1';
      else
        io <= '0';
      end if;
    else
      io <= 'Z';
    end if;
  End Process;
END ARCHITECTURE beh;

