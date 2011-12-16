--
-- VHDL Architecture idx_fpga_lib.qclic_ram.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:58:36 12/13/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_ram IS
   PORT( 
      rRd       : IN     std_ulogic;
      rWr       : IN     std_ulogic;
      raddr     : IN     std_logic_vector (6 DOWNTO 0);
      ram_wdata : IN     std_logic_vector (15 DOWNTO 0);
      ram_rdata : OUT    std_logic_vector (15 DOWNTO 0);
      F8M       : IN     std_logic;
      rst       : IN     std_logic
   );

-- Declarations

END qclic_ram ;

--
ARCHITECTURE beh OF qclic_ram IS
  type qram_t is array (127 downto 0) of std_logic_vector(15 downto 0);
  SIGNAL qram : qram_t;
BEGIN
  rd_proc : Process (F8M) IS
  BEGIN
    if F8M'event AND F8M = '1' then
      if rst = '1' then
        ram_rdata <= (others => '0');
      elsif rRd = '1' then
        ram_rdata <= qram(raddr);
      end if;
    end if;
  End Process;
  
  wr_proc : Process (F8M) IS
  BEGIN
    if F8M'event AND F8M = '1' then
      if rWr = '1' then
        qram(raddr) <= ram_wdata;
      end if;
    end if;
  END Process;
END ARCHITECTURE beh;
