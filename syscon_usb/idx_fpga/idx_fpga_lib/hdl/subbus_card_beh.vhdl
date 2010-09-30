--
-- VHDL Architecture idx_fpga_lib.subbus_card.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:40:52 09/30/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY subbus_card IS
  GENERIC (
    BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600"
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    Data    : INOUT  std_logic_vector (15 DOWNTO 0);
    ExpRd   : IN     std_ulogic;
    ExpWr   : IN     std_ulogic;
    ExpAck  : OUT    std_ulogic;
    F8M     : IN     std_ulogic;
    rst     : IN     std_ulogic
  );
END ENTITY subbus_card;

--
ARCHITECTURE beh OF subbus_card IS
BEGIN
END ARCHITECTURE beh;


