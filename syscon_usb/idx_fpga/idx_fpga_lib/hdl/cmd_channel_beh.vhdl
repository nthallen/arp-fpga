--
-- VHDL Architecture idx_fpga_lib.cmd_channel.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 08:28:28 01/22/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY cmd_channel IS
  GENERIC ( CMD_DFLT : std_ulogic := '0' );
  PORT (
    CmdOn   : IN std_ulogic;
    CmdOff  : IN std_ulogic;
    CmdStrb : IN std_ulogic;
    CmdEnbl : IN std_ulogic;
    RST     : IN std_ulogic;
    CmdOut  : OUT std_ulogic
  );
END ENTITY cmd_channel;

--
ARCHITECTURE beh OF cmd_channel IS
BEGIN
  
  cmd_p : Process (CmdStrb, RST) Is
  Begin
    if RST = '1' then
      CmdOut <= CMD_DFLT;
    elsif CmdStrb'Event AND CmdStrb = '1' then
      if CmdEnbl = '1' AND CmdOn = '1' AND CmdOff = '0' then
        CmdOut <= '1';
      elsif CmdEnbl = '1' AND CmdOn = '0' AND CmdOff = '1' then
        CmdOut <= '0';
      end if;
    end if;
  End Process;
  
END ARCHITECTURE beh;

