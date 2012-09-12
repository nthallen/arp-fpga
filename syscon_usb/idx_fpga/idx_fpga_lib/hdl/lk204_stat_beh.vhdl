--
-- VHDL Architecture idx_fpga_lib.lk204_stat.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:05:54 08/23/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_stat IS
   GENERIC( 
      FIFO_WIDTH : integer range 16 downto 1 := 1
   );
   PORT( 
      F8M      : IN     std_ulogic;
      KeyData  : IN     std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      KeyEmpty : IN     std_logic;
      RdEn     : IN     std_ulogic;
      Status   : IN     std_logic_vector (15 DOWNTO 0);
      KeyRE    : OUT    std_logic_vector;
      RData    : OUT    std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      Rst      : IN     std_logic;
      LK204    : IN     std_logic
   );

-- Declarations

END lk204_stat ;

--
ARCHITECTURE beh OF lk204_stat IS
    SIGNAL Reading : std_logic;
BEGIN
  RData_proc : Process (F8M) is
  Begin
    if F8M'Event AND F8M = '1' then
      if Rst = '1' then
        Reading <= '0';
        KeyRE <= '0';
        RData <= (others => '0');
      else
        if RdKey = '1' then
          RData(15 DOWNTO FIFO_WIDTH) <= (others => '0');
          RData(FIFO_WIDTH-1 DOWNTO 0) <= KeyData;
          -- KeyData will be zero if KeyEmpty
        else
          RData <= Status;
        end if;
        
        if Reading = '1' AND RdEn = '0' then
          Reading <= '0';
          KeyRE <= '1';
        elsif RdEn = '1' AND RdKey = '1' then
          Reading <= '1';
          KeyRE <= '0';
        else
          KeyRE <= '0';
        end if;
      end if;
    end if;
  End Process;
END ARCHITECTURE beh;
