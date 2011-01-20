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
    for i in 1 to 20 loop
      sbrd( X"0C20" );
      assert Read_Result(15 DOWNTO 8) = X"10"
        report "Mock output does not match row/column"
        severity error;
      assert Read_Result(2 DOWNTO 0) = "001"
        report "Mock low bits do not match cvt count row"
        severity error;
      CvtdRow := CvtCnt(7 DOWNTO 3);
      assert Read_Result(7 Downto 3) = conv_std_logic_vector(CvtdRow,5)
          OR Read_Result(7 DOWNTO 3) = conv_std_logic_vector(CvtdRow-1,5)
        report "Cvt Count does not match"
        severity error;
      sbrd( X"0C21" );
      assert Read_Result = X"001C"
        report "Configuration readback does not match"
        severity error;
      wait for 100 us;
    end loop;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  RST <= RST_int;
  F8M <= F8M_int;

END ARCHITECTURE sim;

