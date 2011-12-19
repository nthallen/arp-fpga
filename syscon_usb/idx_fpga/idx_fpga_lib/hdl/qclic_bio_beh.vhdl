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
      o : IN     std_ulogic;
      io   : INOUT  std_logic;
      i : OUT    std_ulogic
   );

-- Declarations

END qclic_bio ;

--
ARCHITECTURE beh OF qclic_bio IS
BEGIN
  i <= io;
  
  output_p : Process (o) Is
  Begin
    if o = '1' then
      io <= '1';
    else
      io <= 'Z';
    end if;
  End Process;
END ARCHITECTURE beh;

