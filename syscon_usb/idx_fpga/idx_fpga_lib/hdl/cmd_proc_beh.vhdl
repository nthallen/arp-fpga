--
-- VHDL Architecture idx_fpga_lib.cmd_proc.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 08:36:48 01/22/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY cmd_proc IS
  GENERIC ( CMD_PROC_N_CMDS : integer := 24 );
  PORT (
    cmd_dio : IN std_logic_vector( CMD_PROC_N_CMDS*2-1 DOWNTO 0 );
    cmd_out : OUT std_logic_vector( CMD_PROC_N_CMDS-1 DOWNTO 0 );
    CmdStrb : IN std_ulogic;
    CmdEnbl : IN std_ulogic;
    RST : IN std_ulogic
  );
END ENTITY cmd_proc;

--
ARCHITECTURE beh OF cmd_proc IS
   COMPONENT cmd_channel
      GENERIC (
         CMD_DFLT : std_ulogic := '0'
      );
      PORT (
         CmdOn   : IN     std_ulogic;
         CmdOff  : IN     std_ulogic;
         CmdStrb : IN     std_ulogic;
         CmdEnbl : IN     std_ulogic;
         RST     : IN     std_ulogic;
         CmdOut  : OUT    std_ulogic
      );
   END COMPONENT;
   FOR ALL : cmd_channel USE ENTITY idx_fpga_lib.cmd_channel;
BEGIN
   --  hds hds_inst
   cmds : for i in 0 to CMD_PROC_N_CMDS-1 generate
   channel : cmd_channel
      GENERIC MAP (
         CMD_DFLT => '0'
      )
      PORT MAP (
         CmdOn   => cmd_dio(2*i),
         CmdOff  => cmd_dio(2*i+1),
         CmdStrb => CmdStrb,
         CmdEnbl => CmdEnbl,
         RST     => RST,
         CmdOut  => cmd_out(i)
      );
   end generate;
END ARCHITECTURE beh;

