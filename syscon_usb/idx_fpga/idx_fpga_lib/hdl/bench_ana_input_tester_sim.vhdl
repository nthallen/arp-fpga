--
-- VHDL Architecture idx_fpga_lib.bench_ana_input_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:47:57 11/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY bench_ana_input_tester IS
   PORT( 
      CS5    : IN     std_ulogic;
      Conv   : IN     std_ulogic;
      ExpAck : IN     std_ulogic;
      RdyOut : IN     std_ulogic;
      Row    : IN     std_ulogic_vector (5 DOWNTO 0);
      SCK16  : IN     std_ulogic_vector (1 DOWNTO 0);
      SCK5   : IN     std_ulogic_vector (1 DOWNTO 0);
      SDO    : IN     std_ulogic_vector (1 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      ExpWr  : OUT    std_ulogic;
      F8M    : OUT    std_ulogic;
      F30M   : OUT    std_ulogic;
      RST    : OUT    std_ulogic;
      SDI    : OUT    std_ulogic_vector (1 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END bench_ana_input_tester ;

--
ARCHITECTURE sim OF bench_ana_input_tester IS
   SIGNAL Bank : std_ulogic;
   SIGNAL RST_int : std_ulogic;
   SIGNAL F8M_int : std_ulogic;
   SIGNAL CvtCnt : unsigned(7 DOWNTO 0);
   SIGNAL Done : std_ulogic;
   SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);
   
   COMPONENT mock_ad7687_chain
      PORT (
         SCK16 : IN     std_ulogic;
         Conv  : IN     std_ulogic;
         RST   : IN     std_ulogic;
         SDO   : OUT    std_ulogic;
         Row   : IN     std_ulogic_vector(2 DOWNTO 0);
         Bank  : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : mock_ad7687_chain USE ENTITY idx_fpga_lib.mock_ad7687_chain;
   
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
   bank0 : mock_ad7687_chain
      PORT MAP (
         SCK16 => SCK16(0),
         Conv  => Conv,
         RST   => RST_int,
         SDO   => SDI(0),
         Row   => Row(2 DOWNTO 0),
         Bank  => '0'
      );

  bank1 : mock_ad7687_chain
    PORT MAP (
      SCK16 => SCK16(1),
      Conv  => Conv,
      RST   => RST_int,
      SDO   => SDI(1),
      Row   => Row(2 DOWNTO 0),
      Bank  => '1'
    );

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

  clock30 : Process
  Begin
    F30M <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F30M <= '0';
      wait for 16 ns;
      F30M <= '1';
      wait for 17 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  Count : Process (RST_int,CS5)
  Begin
    if RST_int = '1' then
      CvtCnt <= X"00";
    elsif CS5'Event AND CS5 = '0' then
      CvtCnt <= CvtCnt + 1;
    end if;
  End Process;
  

  test_proc : Process
    Variable CvtdRow : unsigned(4 DOWNTO 0);
    
    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Addr <= addr_in;
      -- pragma synthesis_off
      wait for 125 ns;
      ExpRd <= '1';
      wait for 1 us;
      assert ExpAck = '1' report "No Acknowledge on read" severity error;
      Read_Result <= Data;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;

    procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      Addr <= Addr_In;
      Data <= Data_in;
      -- pragma synthesis_off
      wait for 40 ns;
      ExpWr <= '1';
      wait for 1 us;
      assert ExpAck = '1' report "No acknowledge on write" severity error;
      ExpWr <= '0';
      wait for 250 ns;
      Data <= (others => 'Z');
      -- pragma synthesis_on
      return;
    end procedure sbwr;

    procedure check_chan( Addr_In : IN std_logic_vector(15 downto 0);
                          Cfg_In  : IN std_logic_vector(15 downto 0) ) is
      variable CvtdRow : unsigned(4 downto 0);
      variable Addr_U : unsigned(15 downto 0);
    begin
      sbrd( Addr_In );
      assert Read_Result(15 DOWNTO 8) = Addr_In(8 DOWNTO 1)
        report "Mock output does not match row/column: " &
          word_string(Read_Result) & " Addr: " &
          word_string(Addr_In) & " match: " &
          word_string(Read_Result(15 DOWNTO 8) & Addr_In(8 DOWNTO 1))
        severity error;
      assert Read_Result(2 DOWNTO 0) = Addr_In(7 DOWNTO 5)
        report "Mock low bits do not match cvt count row: " &
          word_string(Read_Result) & " Addr: " &
          word_string(Addr_In) & " match: " &
          word_string( "00000" & Read_Result(2 DOWNTO 0) &
                       "00000" & Addr_In(8 DOWNTO 6))
        severity error;
      CvtdRow := CvtCnt(7 DOWNTO 3);
      assert Read_Result(7 Downto 3) = conv_std_logic_vector(CvtdRow,5)
          OR Read_Result(7 DOWNTO 3) = conv_std_logic_vector(CvtdRow-1,5)
        report "Cvt Count does not match"
      severity error;
      for i in 15 downto 0 loop
        Addr_U(i) := Addr_In(i);
      end loop;
      sbrd( conv_std_logic_vector(Addr_U+1,16) );
      assert Read_Result = Cfg_In
        report "Configuration readback expected: " & word_string(Cfg_In) &
               " read: " & word_string(Read_Result)
        severity error;
      return;
    end procedure check_chan;
  
  Begin
    Done <= '0';
    ExpRd <= '0';
    ExpWr <= '0';
    Data <= (others => 'Z');
    RST_int <= '1';
    -- pragma synthesis_off
    wait until F8M_int'Event AND F8M_int = '1';
    RST_int <= '0';
    wait until F8M_int'Event AND F8M_int = '1';
    wait for 100 us; -- wait for initial conversions
    sbwr( X"0C20", X"001C" );
    sbwr( X"0C34", X"0010" );
    wait for 220 us;
    for i in 1 to 20 loop
      check_chan( X"0C20", X"001C" );
      check_chan( X"0C34", X"0010" );
      wait for 100 us;
    end loop;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  RST <= RST_int;
  F8M <= F8M_int;

END ARCHITECTURE sim;

