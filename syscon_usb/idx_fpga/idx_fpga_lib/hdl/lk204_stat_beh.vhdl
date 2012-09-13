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
   PORT( 
      F8M      : IN     std_ulogic;
      KeyData  : IN     std_logic_vector (7 DOWNTO 0);
      KeyEmpty : IN     std_logic;
      RdEn     : IN     std_ulogic;
      Status   : IN     std_logic_vector (15 DOWNTO 0);
      KeyRE    : OUT    std_logic;
      RData    : OUT    std_logic_vector (15 DOWNTO 0);
      Rst      : IN     std_logic;
      LK204    : IN     std_logic
   );

-- Declarations

END lk204_stat ;

--
ARCHITECTURE beh OF lk204_stat IS
    SIGNAL Reading : std_logic;
    SIGNAL RdFIFO : std_logic;
BEGIN
  RData_proc : Process (F8M) is
  Begin
    if F8M'Event AND F8M = '1' then
      if Rst = '1' then
        Reading <= '0';
        KeyRE <= '0';
        RData <= (others => '0');
        RdFIFO <= '0';
      else
        if RdEn = '1' AND Reading = '0' then
          if LK204 = '1' then
            RData(15 DOWNTO 8) <= (others => '0');
            RData(7 DOWNTO 0) <= KeyData;
            RdFIFO <= not KeyEmpty;
            -- KeyData will be zero if KeyEmpty
          else
            RdFIFO <= '0';
            RData <= Status;
            RData(4) <= not KeyEmpty;
          end if;
          Reading <= '1';
        elsif RdEn = '0' AND Reading = '1' then
          Reading <= '0';
          KeyRE <= RdFIFO;
        else
          KeyRE <= '0';
        end if;
      end if;
    end if;
  End Process;
END ARCHITECTURE beh;
