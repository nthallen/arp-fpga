-- VHDL Entity idx_fpga_lib.adc_v1.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:12:59 04/08/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY adc_v1 IS
   GENERIC( 
      BASE_ADDR : std_logic_vector := X"0E80"
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      MISO   : IN     std_logic;
      rst    : IN     std_logic;
      CS_B   : OUT    std_logic;
      ExpAck : OUT    std_ulogic;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      SCLK   : OUT    std_logic
   );

-- Declarations

END adc_v1 ;

--
-- VHDL Architecture idx_fpga_lib.adc_v1.struct
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:12:59 04/08/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF adc_v1 IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Ack        : std_logic;
   SIGNAL BdEn       : std_ulogic;
   SIGNAL DATA_READY : std_logic;
   SIGNAL HighWord   : std_logic;
   SIGNAL INTENSITY  : std_logic_vector(31 DOWNTO 0);
   SIGNAL RdEn       : std_ulogic;
   SIGNAL WrEn       : std_ulogic;


   -- Component Declarations
   COMPONENT adc_glue
   PORT (
      DATA_READY : IN     std_logic ;
      F8M        : IN     std_ulogic ;
      HighWord   : IN     std_logic ;
      INTENSITY  : IN     std_logic_vector (31 DOWNTO 0);
      RdEn       : IN     std_ulogic ;
      WrEn       : IN     std_ulogic ;
      rst        : IN     std_logic ;
      Ack        : OUT    std_logic ;
      RData      : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT adc_sm
   PORT (
      ACK        : IN     std_logic ;
      CLK        : IN     std_ulogic ;
      MISO       : IN     std_logic ;
      rst        : IN     std_logic ;
      CS_B       : OUT    std_logic ;
      DATA_READY : OUT    std_logic ;
      INTENSITY  : OUT    std_logic_vector (31 DOWNTO 0);
      SCLK       : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT adc_v1_addr
   GENERIC (
      BASE_ADDR : std_logic_vector(15 downto 0) := X"0E80"
   );
   PORT (
      Addr     : IN     std_logic_vector (15 DOWNTO 0);
      BdEn     : OUT    std_ulogic ;
      HighWord : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT subbus_io
   PORT (
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      F8M    : IN     std_ulogic ;
      RdEn   : OUT    std_ulogic ;
      WrEn   : OUT    std_ulogic ;
      BdEn   : IN     std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : adc_glue USE ENTITY idx_fpga_lib.adc_glue;
   FOR ALL : adc_sm USE ENTITY idx_fpga_lib.adc_sm;
   FOR ALL : adc_v1_addr USE ENTITY idx_fpga_lib.adc_v1_addr;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   glue : adc_glue
      PORT MAP (
         DATA_READY => DATA_READY,
         F8M        => F8M,
         HighWord   => HighWord,
         INTENSITY  => INTENSITY,
         RdEn       => RdEn,
         WrEn       => WrEn,
         rst        => rst,
         Ack        => Ack,
         RData      => RData
      );
   sm : adc_sm
      PORT MAP (
         ACK        => Ack,
         CLK        => F8M,
         MISO       => MISO,
         rst        => rst,
         CS_B       => CS_B,
         DATA_READY => DATA_READY,
         INTENSITY  => INTENSITY,
         SCLK       => SCLK
      );
   adc_addr : adc_v1_addr
      GENERIC MAP (
         BASE_ADDR => BASE_ADDR
      )
      PORT MAP (
         Addr     => Addr,
         BdEn     => BdEn,
         HighWord => HighWord
      );
   U_0 : subbus_io
      PORT MAP (
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );

END struct;