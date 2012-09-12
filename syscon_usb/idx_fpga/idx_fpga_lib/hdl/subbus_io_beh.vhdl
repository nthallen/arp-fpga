--
-- VHDL Architecture idx_fpga_lib.DigIO_decode.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:06:21 09/21/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
-- Both RdEn and WrEn are qualified with BdEn
-- WrEn will be one clock pulse long
-- RdEn will be longer
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY subbus_io IS
   PORT( 
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      F8M    : IN     std_ulogic;
      RdEn   : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      BdEn   : IN     std_ulogic
   );
  -- ExpRd,ExpWr,ExpAck all external.
  -- RdEn, WrEn are our qualified versions
  -- RdEn and WrEn are both qualified with BdEn
  -- WrEn is one clock pulse long.
  -- RdEn is longer
  -- BdEn is 1 when Addr selects an element

END subbus_io ;

--
ARCHITECTURE beh OF subbus_io IS
  SIGNAL Wrote : std_ulogic;
  SIGNAL RdEn_int : std_ulogic;
  SIGNAL WrEn_int : std_ulogic;
BEGIN

  
  -- WrEn_int needs to be qualified with BdEn_In
  -- to make sure WrEn occurs during BdEn
  WrEnbl : Process (F8M) Is
  Begin
    if F8M'Event and F8M = '1' then
      if ExpWr = '1' AND BdEn = '1' then
        if Wrote = '1' then
          WrEn_int <= '0';
        else
          WrEn_int <= '1';
          Wrote <= '1';
        end if;
      else
        WrEn_int <= '0';
        Wrote <= '0';
      end if;
    end if;
  End Process;
  
  Ack : process ( F8M ) is
  begin
    if F8M'event and F8M = '1' then
      if ExpRd = '1' AND BdEn = '1' then
        RdEn_int <= '1';
        ExpAck <= '1';
      elsif ExpWr = '1' AND BdEn = '1' then
        RdEn_int <= '0';
        ExpAck <= '1';
      else
        RdEn_int <= '0';
        ExpAck <= '0';
      end if;
    end if;
  end process;

  RdEn <= RdEn_int;
  WrEn <= WrEn_int;

END ARCHITECTURE beh;
