-- VHDL Entity idx_fpga_lib.bench_ana_input.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:04:28 03/28/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--


ENTITY bench_ana_input IS
-- Declarations

END bench_ana_input ;

--
-- VHDL Architecture idx_fpga_lib.bench_ana_input.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:04:28 03/28/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF bench_ana_input IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL CS5    : std_ulogic;
   SIGNAL Conv   : std_ulogic;
   SIGNAL ExpAck : std_ulogic;
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL F30M   : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL RData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL RST    : std_ulogic;
   SIGNAL RdyOut : std_ulogic;
   SIGNAL Row    : std_ulogic_vector(5 DOWNTO 0);
   SIGNAL SCK16  : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL SCK5   : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL SDI    : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL SDO    : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL WData  : std_logic_vector(15 DOWNTO 0);


   -- Component Declarations
   COMPONENT ana_input
   PORT (
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F30M   : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      SDI    : IN     std_ulogic_vector (1 DOWNTO 0);
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      rst    : IN     std_ulogic ;
      CS5    : OUT    std_ulogic ;
      Conv   : OUT    std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      RdyOut : OUT    std_ulogic ;
      Row    : OUT    std_ulogic_vector (5 DOWNTO 0);
      SCK16  : OUT    std_ulogic_vector (1 DOWNTO 0);
      SCK5   : OUT    std_ulogic_vector (1 DOWNTO 0);
      SDO    : OUT    std_ulogic_vector (1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT bench_ana_input_tester
   PORT (
      CS5    : IN     std_ulogic ;
      Conv   : IN     std_ulogic ;
      ExpAck : IN     std_ulogic ;
      RdyOut : IN     std_ulogic ;
      Row    : IN     std_ulogic_vector (5 DOWNTO 0);
      SCK16  : IN     std_ulogic_vector (1 DOWNTO 0);
      SCK5   : IN     std_ulogic_vector (1 DOWNTO 0);
      SDO    : IN     std_ulogic_vector (1 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic ;
      ExpWr  : OUT    std_ulogic ;
      F8M    : OUT    std_ulogic ;
      F30M   : OUT    std_ulogic ;
      RST    : OUT    std_ulogic ;
      SDI    : OUT    std_ulogic_vector (1 DOWNTO 0);
      WData  : OUT    std_logic_vector (15 DOWNTO 0);
      RData  : IN     std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : ana_input USE ENTITY idx_fpga_lib.ana_input;
   FOR ALL : bench_ana_input_tester USE ENTITY idx_fpga_lib.bench_ana_input_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   DUT : ana_input
      PORT MAP (
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F30M   => F30M,
         F8M    => F8M,
         SDI    => SDI,
         WData  => WData,
         rst    => RST,
         CS5    => CS5,
         Conv   => Conv,
         ExpAck => ExpAck,
         RData  => RData,
         RdyOut => RdyOut,
         Row    => Row,
         SCK16  => SCK16,
         SCK5   => SCK5,
         SDO    => SDO
      );
   tester : bench_ana_input_tester
      PORT MAP (
         CS5    => CS5,
         Conv   => Conv,
         ExpAck => ExpAck,
         RdyOut => RdyOut,
         Row    => Row,
         SCK16  => SCK16,
         SCK5   => SCK5,
         SDO    => SDO,
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         F30M   => F30M,
         RST    => RST,
         SDI    => SDI,
         WData  => WData,
         RData  => RData
      );

END struct;
