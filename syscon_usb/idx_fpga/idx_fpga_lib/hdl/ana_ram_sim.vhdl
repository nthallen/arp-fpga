--
-- VHDL Architecture idx_fpga_lib.ana_ram.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 20:37:07 07/27/2018
--
-- using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ARCHITECTURE sim OF ana_ram IS
  SIGNAL RD_DATA_int : std_logic_vector(31 DOWNTO 0);
  TYPE mem_t IS array ( 255 DOWNTO 0) of std_logic_vector(31 DOWNTO 0);
  SIGNAL mem : mem_t;
BEGIN
  RDWR : PROCESS (CLK) IS
  BEGIN
    IF CLK'EVENT AND CLK = '1' THEN
      IF RST = '1' THEN
        FOR i IN 255 DOWNTO 0 LOOP
          mem(i) <= (others => '0');
        END LOOP;
      ELSE
        IF WREN = '1' THEN
          mem(to_integer(unsigned(WR_ADDR))) <= WR_DATA;
        ELSIF RDEN = '1' THEN
          RD_DATA_int <= mem(to_integer(unsigned(RD_ADDR)));
        END IF;
      END IF;
    END IF;
  END PROCESS;
  
  RD_DATA <= RD_DATA_int;
End Architecture sim;

