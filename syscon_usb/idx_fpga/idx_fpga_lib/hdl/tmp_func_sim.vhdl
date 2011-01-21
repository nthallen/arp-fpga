--
-- VHDL Architecture idx_fpga_lib.tmp_func.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:53:54 01/19/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY tmp_func IS
END ENTITY tmp_func;

--
ARCHITECTURE sim OF tmp_func IS
  function char_string( Ain : in std_logic_vector(3 DOWNTO 0) )
  return string is
  begin
    case Ain is
      when X"0" => return "0";
      when X"1" => return "1";
      when X"2" => return "2";
      when X"3" => return "3";
      when X"4" => return "4";
      when X"5" => return "5";
      when X"6" => return "6";
      when X"7" => return "7";
      when X"8" => return "8";
      when X"9" => return "9";
      when X"A" => return "A";
      when X"B" => return "B";
      when X"C" => return "C";
      when X"D" => return "D";
      when X"E" => return "E";
      when X"F" => return "F";
      when others => return "X";
    end case;
  end char_string;
  
  function word_string( Ain : in std_logic_vector(15 DOWNTO 0) )
  return string is
  begin
    return
      char_string(Ain(15 downto 12)) &
      char_string(Ain(11 downto 8)) &
      char_string(Ain(7 downto 4)) &
      char_string(Ain(3 downto 0));
  end word_string;
  
  SIGNAL Addr : std_logic_vector(15 DOWNTO 0);
BEGIN
  
  test_proc : Process Is
  Begin
    Addr <= X"0C20";
    -- pragma synthesis_off
    wait for 100 ns;
    assert Addr = X"0000"
      report "R1: " & word_string(Addr)
      severity error;
    wait for 100 ns;
    wait;
    -- pragma synthesis_on
  End Process;
  
END ARCHITECTURE sim;

