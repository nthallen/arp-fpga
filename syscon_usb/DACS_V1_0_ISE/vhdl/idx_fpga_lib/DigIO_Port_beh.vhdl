--
-- VHDL Architecture idx_fpga_lib.DigIO_Port.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:00:07 09/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY DigIO_Port IS
  GENERIC ( DIGIO_FORCE_DIR : std_ulogic := '0';
            DIGIO_FORCE_DIR_VAL : std_ulogic := '0' );
  PORT (
    DW : IN    std_logic_vector (7 DOWNTO 0);
    DR : OUT   std_logic_vector (7 DOWNTO 0);
    IO : INOUT std_logic_vector (7 DOWNTO 0);
    ConnEn : IN std_ulogic;
    PortEn : IN std_ulogic;
    RS : IN std_ulogic; -- synch reset qualify with ConnEn & PortEn
    RA : IN std_ulogic; -- asynch reset qualify only with CLK
    Dir_In : IN std_logic;
    Dir_Out : OUT std_logic;
    CfgEn : IN std_ulogic;
    WrEn : IN std_ulogic;
    Clk : In std_ulogic
  );
END ENTITY DigIO_Port;

--
ARCHITECTURE beh OF DigIO_Port IS
  SIGNAL Dir : std_ulogic;
  SIGNAL Dout : std_logic_vector (7 DOWNTO 0);
BEGIN
  Direction : Process (Clk)
  Begin
    if Clk'Event AND Clk = '1' then
      if DIGIO_FORCE_DIR = '1' then
        Dir <= DIGIO_FORCE_DIR_VAL;
      elsif RA = '1' OR ( RS = '1' AND ConnEn = '1') then
        Dir <= '1';
      elsif WrEn = '1' AND ConnEn = '1' AND CfgEn = '1' then
        Dir <= Dir_In;
      end if;
    end if;
  End Process;
  
  Dbuf : Process (Clk)
  Begin
    if Clk'Event AND Clk = '1' then
      if RA = '1' OR ( RS = '1' AND ConnEn = '1') then
        Dout <= (others => '0');
      elsif WrEn = '1' AND ConnEn = '1' AND PortEn = '1' then
        Dout <= DW;
      end if;
    end if;
  End Process;
  
  IObuf : Process (Dir, Dout)
  Begin
    if Dir = '0' then
      IO <= Dout;
    else IO <= (others => 'Z');
    end if;
  End Process;
  
  DR <= IO;
  Dir_Out <= Dir;
    
END ARCHITECTURE beh;

