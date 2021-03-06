--
-- VHDL Test Bench idx_fpga_lib.bench_ana_s16.ana_s16_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:12:53 10/15/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ana_s16 IS
END bench_ana_s16;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ARCHITECTURE rtl OF bench_ana_s16 IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL CLK   : std_ulogic;
   SIGNAL DO    : std_ulogic_vector(15 DOWNTO 0);
   SIGNAL RDY   : std_ulogic;
   SIGNAL RST   : std_ulogic;
   SIGNAL SCK   : std_ulogic;
   SIGNAL SDI   : std_ulogic;
   SIGNAL Start : std_ulogic;
   SIGNAL Restart : std_ulogic;
   SIGNAL Done  : std_ulogic;


   -- Component declarations
   COMPONENT ana_s16
      PORT (
         CLK    : IN     std_ulogic;
         DO     : OUT    std_ulogic_vector(15 DOWNTO 0);
         RDY    : OUT    std_ulogic;
         RST    : IN     std_ulogic;
         SCK    : OUT    std_ulogic;
         SDI    : IN     std_ulogic;
         Start  : IN     std_ulogic;
         Restart : IN    std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR U_0 : ana_s16 USE ENTITY idx_fpga_lib.ana_s16;
   -- pragma synthesis_on
   
   function char_string( Ain : in std_ulogic_vector(3 DOWNTO 0) )
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
   
   function word_string( Ain : in std_ulogic_vector(15 DOWNTO 0) )
   return string is
   begin
     return
       char_string(Ain(15 downto 12)) &
       char_string(Ain(11 downto 8)) &
       char_string(Ain(7 downto 4)) &
       char_string(Ain(3 downto 0));
   end word_string;
   
   function pos_string( N : in integer )
   return string is
     Variable M : integer;
     Variable R : integer;
     Variable isneg : std_logic;
   begin
     if N = 0 then
       return "0";
     end if;
       M := N/10;
       R := N - M*10;
       if M = 0 then
         case R is
           when 0 => return "0";
           when 1 => return "1";
           when 2 => return "2";
           when 3 => return "3";
           when 4 => return "4";
           when 5 => return "5";
           when 6 => return "6";
           when 7 => return "7";
           when 8 => return "8";
           when 9 => return "9";
           when others => return "X";
         end case;
       else
         case R is
           when 0 => return pos_string(M) & "0";
           when 1 => return pos_string(M) & "1";
           when 2 => return pos_string(M) & "2";
           when 3 => return pos_string(M) & "3";
           when 4 => return pos_string(M) & "4";
           when 5 => return pos_string(M) & "5";
           when 6 => return pos_string(M) & "6";
           when 7 => return pos_string(M) & "7";
           when 8 => return pos_string(M) & "8";
           when 9 => return pos_string(M) & "9";
           when others => return pos_string(M) & "X";
         end case;
       end if;
   end pos_string;
   
   function int_string( N : in integer )
   return string is
   begin
     if N < 0 then
       return "-" & pos_string(-N);
     else
       return pos_string(N);
     end if;
   end int_string;

BEGIN

   U_0 : ana_s16
      PORT MAP (
         CLK     => CLK,
         DO      => DO,
         RDY     => RDY,
         RST     => RST,
         SCK     => SCK,
         SDI     => SDI,
         Start   => Start,
         Restart => Restart
      );

  clock : Process
  Begin
    clk <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      clk <= '0';
      wait for 20 ns;
      clk <= '1';
      wait for 20 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : Process
    Procedure check(DI : IN std_ulogic_vector(15 DOWNTO 0); RS : IN std_ulogic ) IS
      -- pragma synthesis_off
      Variable BN : integer;
      -- pragma synthesis_on
    Begin
      -- pragma synthesis_off
      assert RDY = '1'
        report "Not RDY in check"
        severity error;
      if RS = '1' then
        Restart <= '1';
        BN := 15;
        SDI <= DI(15);
      else
        Start <= '1';
        BN := 16;
        SDI <= '0';
      end if;
      while BN > 0 loop
        wait until SCK'Event AND SCK = '1';
        Start <= '0';
        Restart <= '0';
        assert RDY = '0'
          report "RDY not clear in check"
          severity error;
        BN := BN-1;
        SDI <= DI(BN);
      end loop;
      wait until SCK'Event AND SCK = '1';
      assert RDY = '1' report "RDY should be high" severity error;
      assert DO = DI
        report "Read value incorrect: Read " & word_string(DO)
                        & " Expected " & word_string(DI)
        severity error;
      -- pragma synthesis_on
      return;
    End Procedure;
  Begin
    Done <= '0';
    SDI <= '0';
    Start <= '0';
    Restart <= '0';
    rst <= '1';
    -- pragma synthesis_off
    wait until clk'Event AND clk = '1';
    rst <= '0';
    wait until clk'Event AND clk = '1';
    wait until clk'Event AND clk = '1';
    wait until clk'Event AND clk = '1';
    wait until clk'Event AND clk = '1';
    assert Rdy = '1'
      report "Not ready"
      severity error;
    check(X"55AA",'0');
    check(X"1234",'1');
    check(X"4321",'1');
    check(X"5A5A",'1');
    wait for 5 us;
    check(X"55AA",'0');
    check(X"1234",'1');
    check(X"4321",'1');
    check(X"5A5A",'1');
    Start <= '1';
    wait for 2 us;
    assert RDY = '0'
      report "RDY asserted w/o first clearing Start"
      severity error;
    Start <= '0';
    wait for 2 us;
    assert RDY = '1'
      report "Not RDY after long Start"
      severity error;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

END rtl;