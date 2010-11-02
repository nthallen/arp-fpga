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
  GENERIC ( DEBUG_MULTIPLIER : integer := 100 );
  PORT (
    TickTock : IN std_ulogic; -- Comes from control word
    CmdEnbl_cmd : IN std_ulogic; -- Comes from control word
    CmdEnbl : OUT std_ulogic; -- Goes to HW
    TwoSecondTO : OUT std_ulogic; -- Goes back in status
    TwoMinuteTO : OUT std_ulogic;
    F8M : IN std_ulogic;
    RST : IN std_ulogic
  );
END ENTITY syscon_tick;

--
ARCHITECTURE beh OF syscon_tick IS
  SIGNAL Ticked : std_ulogic;
  SIGNAL TwoSecTO : std_ulogic;
  SIGNAL TwoSecTOd : std_ulogic; -- latched
  SIGNAL CmdEnbl_int: std_ulogic;
  SIGNAL TwoMinTO : std_ulogic;
  SIGNAL TickCnt : unsigned(29 DOWNTO 0);
BEGIN
  SIC : Process (F8M, RST) IS
  Begin
    if RST = '1' then
      TwoSecTO <= '1';
      TwoSecTOd <= '1';
      TwoMinTO <= '0';
      Ticked <= '0';
      TickCnt <= conv_unsigned(0,30);
    elsif F8M'Event AND F8M = '1' then
      if TickTock /= Ticked then
        TwoMinTO <= '0';
        TwoSecTO <= '0';
        TickCnt <= conv_unsigned(0,30);
      elsif TwoMinTO = '0' then
        TickCnt <= TickCnt + 1;
        if TickCnt = conv_unsigned(160000*DEBUG_MULTIPLIER,30) then
          TwoSecTO <= '1';
        elsif TickCnt = conv_unsigned(9600000*DEBUG_MULTIPLIER,30) then
          TwoMinTO <= '1';
        end if;
      end if;
      Ticked <= TickTock;
      
      if TwoSecTod = '0' AND TwoSecTO = '0'
         AND CmdEnbl_cmd = '1' then
        CmdEnbl_int <= '1';
      else
        CmdEnbl_int <= '0';
      end if;
      
      if TwoSecTOd = '1' then
        if CmdEnbl_cmd = '0' then
          TwoSecTOd <= '0';
        end if;
      elsif CmdEnbl_int = '1' AND TwoSecTO = '1' then
        TwoSecTOd <= '1';
      end if;
    end if;
  End Process;
  
  CmdEnbl <= CmdEnbl_int;
  TwoSecondTO <= TwoSecTOd;
  TwoMinuteTO <= TwoMinTO;
END ARCHITECTURE beh;

