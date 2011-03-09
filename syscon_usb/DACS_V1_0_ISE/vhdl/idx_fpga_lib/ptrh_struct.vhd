-- VHDL Entity idx_fpga_lib.ptrh.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:38:41 03/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh IS
   GENERIC( 
      BASE_ADDR : unsigned(15 DOWNTO 0) := X"0300"
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F25M   : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      rData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic;
      sda    : INOUT  std_logic
   );

-- Declarations

END ptrh ;

--
-- VHDL Architecture idx_fpga_lib.ptrh.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:38:42 03/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF ptrh IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BdEn    : std_ulogic;
   SIGNAL Full    : std_ulogic_vector(12 DOWNTO 0);
   SIGNAL RdEn    : std_ulogic;
   SIGNAL RegEn   : std_logic_vector(12 DOWNTO 0);
   SIGNAL WrEn    : std_ulogic_vector(12 DOWNTO 0);
   SIGNAL hold_D1 : std_ulogic;
   SIGNAL hold_D2 : std_ulogic;
   SIGNAL wData   : std_logic_vector(23 DOWNTO 0);


   -- Component Declarations
   COMPONENT ptrh_acquire
   PORT (
      F25M  : IN     std_ulogic ;
      Full  : IN     std_ulogic_vector (12 DOWNTO 0);
      rst   : IN     std_ulogic ;
      WrEn  : OUT    std_ulogic_vector (12 DOWNTO 0);
      wData : OUT    std_logic_vector (23 DOWNTO 0);
      scl   : INOUT  std_logic ;
      sda   : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT ptrh_addr
   GENERIC (
      BASE_ADDR : unsigned(15 DOWNTO 0) := X"0300"
   );
   PORT (
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      BdEn  : OUT    std_ulogic;
      RegEn : OUT    std_logic_vector (12 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ptrh_dprams
   PORT (
      F25M    : IN     std_ulogic;
      F8M     : IN     std_ulogic;
      RdEn    : IN     std_ulogic;
      RegEn   : IN     std_logic_vector (12 DOWNTO 0);
      WrEn    : IN     std_ulogic_vector (12 DOWNTO 0);
      hold_D1 : IN     std_ulogic;
      hold_D2 : IN     std_ulogic;
      wData   : IN     std_logic_vector (23 DOWNTO 0);
      Full    : OUT    std_ulogic_vector (12 DOWNTO 0);
      rData   : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ptrh_hold
   PORT (
      En0  : IN     std_logic ;
      En1  : IN     std_logic ;
      F8M  : IN     std_ulogic ;
      RdEn : IN     std_ulogic ;
      hold : OUT    std_logic  := '0'
   );
   END COMPONENT;
   COMPONENT subbus_io
   PORT (
      BdEn   : IN     std_ulogic;
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      RdEn   : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : ptrh_acquire USE ENTITY idx_fpga_lib.ptrh_acquire;
   FOR ALL : ptrh_addr USE ENTITY idx_fpga_lib.ptrh_addr;
   FOR ALL : ptrh_dprams USE ENTITY idx_fpga_lib.ptrh_dprams;
   FOR ALL : ptrh_hold USE ENTITY idx_fpga_lib.ptrh_hold;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   ptrh_acq : ptrh_acquire
      PORT MAP (
         F25M  => F25M,
         Full  => Full,
         rst   => rst,
         WrEn  => WrEn,
         wData => wData,
         scl   => scl,
         sda   => sda
      );
   ptrh_addr_dec : ptrh_addr
      GENERIC MAP (
         BASE_ADDR => BASE_ADDR
      )
      PORT MAP (
         Addr  => Addr,
         BdEn  => BdEn,
         RegEn => RegEn
      );
   dprams : ptrh_dprams
      PORT MAP (
         F25M    => F25M,
         F8M     => F8M,
         RdEn    => RdEn,
         RegEn   => RegEn,
         WrEn    => WrEn,
         hold_D1 => hold_D1,
         hold_D2 => hold_D2,
         wData   => wData,
         Full    => Full,
         rData   => rData
      );
   ptrh_hold_D1 : ptrh_hold
      PORT MAP (
         En0  => RegEn(9),
         En1  => RegEn(10),
         F8M  => F8M,
         RdEn => RdEn,
         hold => hold_D1
      );
   ptrh_hold_D2 : ptrh_hold
      PORT MAP (
         En0  => RegEn(11),
         En1  => RegEn(12),
         F8M  => F8M,
         RdEn => RdEn,
         hold => hold_D2
      );
   ptrh_io : subbus_io
      PORT MAP (
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         RdEn   => RdEn,
         WrEn   => OPEN,
         BdEn   => BdEn
      );

END struct;