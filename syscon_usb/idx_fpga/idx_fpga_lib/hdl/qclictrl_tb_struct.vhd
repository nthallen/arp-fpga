-- VHDL Entity idx_fpga_lib.qclictrl_tb.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:38:13 12/ 6/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY qclictrl_tb IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
   );
-- Declarations

END qclictrl_tb ;

--
-- VHDL Architecture idx_fpga_lib.qclictrl_tb.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:38:13 12/ 6/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
--  Copyright 2011 President and Fellows of Harvard College
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF qclictrl_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr      : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpAck    : std_ulogic;
   SIGNAL ExpRd     : std_ulogic;
   SIGNAL ExpWr     : std_ulogic;
   SIGNAL F8M       : std_logic;
   SIGNAL MQ_enable : std_logic;
   SIGNAL QCLI_out  : std_logic_vector(15 DOWNTO 0);
   SIGNAL QNBsy     : std_logic;
   SIGNAL QSClk     : std_logic;
   SIGNAL QSData    : std_logic;
   SIGNAL QSync     : std_ulogic;
   SIGNAL RData     : std_logic_vector(15 DOWNTO 0);
   SIGNAL WData     : std_logic_vector(15 DOWNTO 0);
   SIGNAL rst       : std_logic;


   -- Component Declarations
   COMPONENT mock_qcli
   PORT (
      F8M       : IN     std_logic ;
      MQ_enable : IN     std_logic ;
      QSync     : IN     std_ulogic ;
      rst       : IN     std_logic ;
      QCLI_out  : OUT    std_logic_vector (15 DOWNTO 0);
      QNBsy     : OUT    std_logic ;
      QSClk     : INOUT  std_logic ;
      QSData    : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT qclictrl
   GENERIC (
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
   );
   PORT (
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F8M    : IN     std_logic ;
      QNBsy  : IN     std_logic ;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      rst    : IN     std_logic ;
      ExpAck : OUT    std_ulogic ;
      QSync  : OUT    std_ulogic ;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      QSClk  : INOUT  std_logic ;
      QSData : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT qclictrl_tester
   PORT (
      ExpAck    : IN     std_ulogic ;
      QCLI_out  : IN     std_logic_vector (15 DOWNTO 0);
      QSync     : IN     std_ulogic ;
      RData     : IN     std_logic_vector (15 DOWNTO 0);
      Addr      : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd     : OUT    std_ulogic ;
      ExpWr     : OUT    std_ulogic ;
      F8M       : OUT    std_logic ;
      MQ_enable : OUT    std_logic ;
      WData     : OUT    std_logic_vector (15 DOWNTO 0);
      rst       : OUT    std_logic ;
      QSClk     : INOUT  std_logic ;
      QSData    : INOUT  std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : mock_qcli USE ENTITY idx_fpga_lib.mock_qcli;
   FOR ALL : qclictrl USE ENTITY idx_fpga_lib.qclictrl;
   FOR ALL : qclictrl_tester USE ENTITY idx_fpga_lib.qclictrl_tester;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   qcli : mock_qcli
      PORT MAP (
         F8M       => F8M,
         MQ_enable => MQ_enable,
         QSync     => QSync,
         rst       => rst,
         QCLI_out  => QCLI_out,
         QNBsy     => QNBsy,
         QSClk     => QSClk,
         QSData    => QSData
      );
   DUT : qclictrl
      GENERIC MAP (
         BASE_ADDR => X"1000"
      )
      PORT MAP (
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         QNBsy  => QNBsy,
         WData  => WData,
         rst    => rst,
         ExpAck => ExpAck,
         QSync  => QSync,
         RData  => RData,
         QSClk  => QSClk,
         QSData => QSData
      );
   tester : qclictrl_tester
      PORT MAP (
         ExpAck    => ExpAck,
         QCLI_out  => QCLI_out,
         QSync     => QSync,
         RData     => RData,
         Addr      => Addr,
         ExpRd     => ExpRd,
         ExpWr     => ExpWr,
         F8M       => F8M,
         MQ_enable => MQ_enable,
         WData     => WData,
         rst       => rst,
         QSClk     => QSClk,
         QSData    => QSData
      );

END struct;
