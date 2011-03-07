-- VHDL Entity idx_fpga_lib.bench_ptrh.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:01:26 03/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--


ENTITY bench_ptrh IS
-- Declarations

END bench_ptrh ;

--
-- VHDL Architecture idx_fpga_lib.bench_ptrh.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:01:26 03/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF bench_ptrh IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpAck : std_ulogic;
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL F25M   : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL rData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL rst    : std_ulogic;
   SIGNAL scl    : std_logic;
   SIGNAL sda    : std_logic;


   -- Component Declarations
   COMPONENT i2c_slave
   GENERIC (
      I2C_ADDR : std_logic_vector(6 DOWNTO 0) := "1000000"
   );
   PORT (
      clk : IN     std_ulogic ;
      rst : IN     std_ulogic ;
      scl : IN     std_logic ;
      sda : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT ptrh
   GENERIC (
      BASE_ADDR : unsigned(15 DOWNTO 0) := X"0300"
   );
   PORT (
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F25M   : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      rst    : IN     std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      rData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic ;
      sda    : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT ptrh_tester
   PORT (
      ExpAck : IN     std_ulogic ;
      rData  : IN     std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic ;
      sda    : INOUT  std_logic ;
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic ;
      ExpWr  : OUT    std_ulogic ;
      F25M   : OUT    std_ulogic ;
      F8M    : OUT    std_ulogic ;
      rst    : OUT    std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : i2c_slave USE ENTITY idx_fpga_lib.i2c_slave;
   FOR ALL : ptrh USE ENTITY idx_fpga_lib.ptrh;
   FOR ALL : ptrh_tester USE ENTITY idx_fpga_lib.ptrh_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_2 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk => F25M,
         rst => rst,
         scl => scl,
         sda => sda
      );
   U_3 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1110111"
      )
      PORT MAP (
         clk => F25M,
         rst => rst,
         scl => scl,
         sda => sda
      );
   U_0 : ptrh
      PORT MAP (
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F25M   => F25M,
         F8M    => F8M,
         rst    => rst,
         ExpAck => ExpAck,
         rData  => rData,
         scl    => scl,
         sda    => sda
      );
   U_1 : ptrh_tester
      PORT MAP (
         ExpAck => ExpAck,
         rData  => rData,
         scl    => scl,
         sda    => sda,
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F25M   => F25M,
         F8M    => F8M,
         rst    => rst
      );

END struct;
