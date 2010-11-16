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
USE idx_fpga_lib.All;

ENTITY bench_ana_input_tester IS
   PORT( 
      CS5    : IN     std_ulogic;
      Conv   : IN     std_ulogic;
      ExpAck : IN     std_ulogic;
      RdyOut : IN     std_ulogic;
      Row    : IN     std_ulogic_vector (2 DOWNTO 0);
      SCK16  : IN     std_ulogic_vector (1 DOWNTO 0);
      SCK5   : IN     std_ulogic_vector (1 DOWNTO 0);
      SDO    : IN     std_ulogic_vector (1 DOWNTO 0);
      Addr   : OUT    std_ulogic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      ExpWr  : OUT    std_ulogic;
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
   SIGNAL F30M_int : std_ulogic;
   SIGNAL Done : std_ulogic;
   
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
         Row   => Row,
         Bank  => '0'
      );

  bank1 : mock_ad7687_chain
    PORT MAP (
      SCK16 => SCK16(1),
      Conv  => Conv,
      RST   => RST_int,
      SDO   => SDI(1),
      Row   => Row,
      Bank  => '1'
    );

  clock : Process
  Begin
    F30M_int <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F30M_int <= '0';
      wait for 16 ns;
      F30M_int <= '1';
      wait for 17 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : Process
  Begin
    Done <= '0';
    ExpRd <= '0';
    ExpWr <= '0';
    Data <= (others => 'Z');
    RST_int <= '1';
    -- pragma synthesis_off
    wait until F30M_int'Event AND F30M_int = '1';
    RST_int <= '0';
    wait until F30M_int'Event AND F30M_int = '1';
    Addr <= X"0C20";
    wait for 100 ns;
    for i in 1 to 20 loop
      ExpRd <= '1';
      wait for 1 us;
      ExpRd <= '0';
      wait for 100 us;
    end loop;
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  RST <= RST_int;
  F30M <= F30M_int;

END ARCHITECTURE sim;
