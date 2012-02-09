--
-- VHDL Architecture idx_fpga_lib.vm_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 07:09:12 04/20/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY vm_tester IS
   PORT( 
      ExpAck : IN     std_ulogic;
      rData  : IN     std_logic_vector (15 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      F8M    : OUT    std_ulogic;
      rst    : OUT    std_ulogic;
      SCL    : INOUT  std_logic;
      SDA    : INOUT  std_logic
   );

-- Declarations

END vm_tester ;

--
ARCHITECTURE sim OF vm_tester IS
  SIGNAL F8M_int : std_ulogic;
  SIGNAL Done : std_ulogic;
  SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);

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

BEGIN

  clock8 : Process
  Begin
    F8M_int <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F8M_int <= '0';
      wait for 62 ns;
      F8M_int <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : Process
    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Addr <= addr_in;
      -- pragma synthesis_off
      wait until F8M_int'Event AND F8M_int = '1';
      ExpRd <= '1';
      for i in 1 to 8 loop
        wait until F8M_int'Event AND F8M_int = '1';
      end loop;
      assert ExpAck = '1'
        report "No Acknowledge on read from " & word_string(addr_in)
        severity error;
      Read_Result <= rData;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
  Begin
    Done <= '0';
    Addr <= X"0000";
    ExpRd <= '0';
    rst <= '1';
    SCL <= 'H';
    SDA <= 'H';
    -- pragma synthesis_off
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    rst <= '0';
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    wait until F8M_int'Event AND F8M_int = '1';
    for i in 0 to 4 loop
      wait for 10 ms;
      sbrd(X"0360");
      sbrd(X"0362");
      sbrd(X"0364");
      sbrd(X"0366");
      sbrd(X"0368");
    end loop;
    -- Test timeout
    SCL <= '0';
    for i in 0 to 12 loop
      wait for 10 ms;
      sbrd(X"0360");
      sbrd(X"0362");
      sbrd(X"0364");
      sbrd(X"0366");
      sbrd(X"0368");
    end loop;
    SCL <= 'H';
    -- Test recovery
    for i in 0 to 4 loop
      wait for 10 ms;
      sbrd(X"0360");
      sbrd(X"0362");
      sbrd(X"0364");
      sbrd(X"0366");
      sbrd(X"0368");
    end loop;
    
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  F8M <= F8M_int;
  
END ARCHITECTURE sim;

