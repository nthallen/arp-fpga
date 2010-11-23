--
-- VHDL Architecture idx_fpga_lib.syscon_tick.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:27:52 11/ 2/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY syscon_tick IS
  GENERIC ( DEBUG_MULTIPLIER : integer := 1 ); -- set to 100 for faster simulation
  PORT (
    TickTock : IN std_ulogic; -- Comes from control word
    CmdEnbl_cmd : IN std_ulogic; -- Comes from control word
    Arm_In : IN std_ulogic; -- from control word
    CmdEnbl : OUT std_ulogic; -- Goes to HW
    TwoSecondTO : OUT std_ulogic; -- Goes back in status
    Flt_CPU_Reset : OUT std_ulogic; -- 1sec reset pulse
    TwoMinuteTO : OUT std_ulogic; -- Lights Fail
    F8M : IN std_ulogic
  );
END ENTITY syscon_tick;

--
ARCHITECTURE beh OF syscon_tick IS
  SIGNAL Ticked : std_ulogic := '0';
  SIGNAL TwoSecTO : std_ulogic := '1';
  SIGNAL TickEnbl : std_ulogic := '1';
  SIGNAL Armed    : std_ulogic := '0';
  SIGNAL CmdEnbl_int: std_ulogic := '0';
  SIGNAL TwoMinTO : std_ulogic := '0';
  SIGNAL TickCnt : unsigned(29 DOWNTO 0) := conv_unsigned(0,30);
  SIGNAL CPU_Reset : std_ulogic := '0';
BEGIN
  SIC : Process (F8M) IS
  Begin
    if F8M'Event AND F8M = '1' then
      if Arm_In = '1' AND TickEnbl = '1' AND TickTock /= Ticked then
        TwoMinTO <= '0';
        TwoSecTO <= '0';
        TickCnt <= conv_unsigned(0,30);
        Armed <= '1';
      elsif TwoMinTO = '0' then
        TickCnt <= TickCnt + DEBUG_MULTIPLIER;
        if Armed = '1' AND TickCnt = conv_unsigned(16000000,30) then
          TwoSecTO <= '1';
          TickEnbl <= '0';
          Armed <= '0';
        elsif TickCnt = conv_unsigned(960000000,30) then
          TwoMinTO <= '1';
        end if;
      end if;
      Ticked <= TickTock;
      
      if Arm_In = '1' AND Armed = '1' AND CmdEnbl_cmd = '1' then
        CmdEnbl_int <= '1';
      else
        CmdEnbl_int <= '0';
      end if;
      
      if CmdEnbl_cmd = '0' then
        TickEnbl <= '1';
      end if;
      
      if ( Arm_In = '1' OR CPU_Reset = '1')
           AND TwoSecTO = '1'
           AND TickCnt < conv_unsigned(24000000,30) then
        CPU_Reset <= '1';
      else
        CPU_Reset <= '0';
      end if;
    end if;
  End Process;
  
  CmdEnbl <= CmdEnbl_int;
  TwoSecondTO <= TwoSecTO;
  TwoMinuteTO <= TwoMinTO;
  Flt_CPU_Reset <= CPU_Reset;
END ARCHITECTURE beh;

