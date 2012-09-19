-- VHDL Entity idx_fpga_lib.lk204_tb.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:58:49 09/19/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_tb IS
   GENERIC( 
      FIFO_WIDTH : integer range 14 DOWNTO 1     := 8;
      BASE_ADDR  : std_logic_vector(15 DOWNTO 0) := X"1100"
   );
-- Declarations

END lk204_tb ;

--
-- VHDL Architecture idx_fpga_lib.lk204_tb.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:58:49 09/19/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
--  Copyright 2011 President and Fellows of Harvard College
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF lk204_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL BdIntr : std_ulogic;
   SIGNAL ExpAck : std_ulogic;
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL INTA   : std_ulogic;
   SIGNAL RData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL Rst    : std_logic;
   SIGNAL WData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL scl    : std_logic_vector(0 TO 0);
   SIGNAL sda    : std_logic_vector(0 TO 0);
   SIGNAL wdata1 : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL wdata2 : std_ulogic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT i2c_slave
   GENERIC (
      I2C_ADDR : std_logic_vector(6 DOWNTO 0) := "1000000"
   );
   PORT (
      clk   : IN     std_ulogic ;
      rst   : IN     std_ulogic ;
      scl   : IN     std_logic ;
      wdata : OUT    std_ulogic_vector (7 DOWNTO 0);
      sda   : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT lk204
   GENERIC (
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1100"
   );
   PORT (
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      INTA   : IN     std_ulogic ;
      Rst    : IN     std_logic ;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      BdIntr : OUT    std_logic ;
      ExpAck : OUT    std_ulogic ;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic_vector (0 TO 0);
      sda    : INOUT  std_logic_vector (0 TO 0)
   );
   END COMPONENT;
   COMPONENT lk204_tester
   PORT (
      BdIntr : IN     std_ulogic ;
      ExpAck : IN     std_ulogic ;
      RData  : IN     std_logic_vector (15 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic ;
      ExpWr  : OUT    std_ulogic ;
      F8M    : OUT    std_ulogic ;
      INTA   : OUT    std_ulogic ;
      Rst    : OUT    std_logic ;
      WData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic_vector (0 TO 0);
      sda    : INOUT  std_logic_vector (0 TO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : i2c_slave USE ENTITY idx_fpga_lib.i2c_slave;
   FOR ALL : lk204 USE ENTITY idx_fpga_lib.lk204;
   FOR ALL : lk204_tester USE ENTITY idx_fpga_lib.lk204_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   mock_9554 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "0100000"
      )
      PORT MAP (
         clk   => F8M,
         rst   => Rst,
         scl   => scl(0),
         wdata => wdata2,
         sda   => sda(0)
      );
   mock_lk204 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk   => F8M,
         rst   => Rst,
         scl   => scl(0),
         wdata => wdata1,
         sda   => sda(0)
      );
   DUT : lk204
      GENERIC MAP (
         BASE_ADDR => X"1100"
      )
      PORT MAP (
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         INTA   => INTA,
         Rst    => Rst,
         WData  => WData,
         BdIntr => BdIntr,
         ExpAck => ExpAck,
         RData  => RData,
         scl    => scl,
         sda    => sda
      );
   tester : lk204_tester
      PORT MAP (
         BdIntr => BdIntr,
         ExpAck => ExpAck,
         RData  => RData,
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         INTA   => INTA,
         Rst    => Rst,
         WData  => WData,
         scl    => scl,
         sda    => sda
      );

END struct;
