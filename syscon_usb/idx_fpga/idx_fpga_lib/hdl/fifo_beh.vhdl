--
-- VHDL Architecture idx_fpga_lib.fifo.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:31:18 08/21/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;

ENTITY fifo IS
  GENERIC (
    FIFO_WIDTH : integer range 16 downto 1 := 1;
    FIFO_LENGTH : integer range 256 downto 1 := 1
  );
  PORT (
    WData : IN std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
    WE : IN std_logic_vector;
    RE : IN std_logic_vector;
    Clk : IN std_ulogic;
    Rst : IN std_logic;
    RData : OUT std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
    Empty : OUT std_logic;
    Full : OUT std_logic
  );

END fifo ;

--
ARCHITECTURE beh OF fifo IS
BEGIN
END ARCHITECTURE beh;

