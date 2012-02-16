-- VHDL Entity idx_fpga_lib.bench_ptrhm_acquire_tb.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:57:41 02/16/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
library ieee;
USE ieee.std_logic_1164.all;
library idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;

ENTITY bench_ptrhm_acquire_tb IS
   GENERIC( 
      N_PTRH      : integer    := 8;
      N_ISBITS    : integer    := 4;
      ESID        : ESID_array := ( 3, 2, 1, 0, 0, 0, 0, 0 );
      ESwitchBit  : ESB_array  := ( 0, 0, 0, 4, 3, 2, 1, 0 );
      ISwitchBit  : ISB_array  := ( 3, 2, 1, 0 );
      ESwitchAddr : ESA_array  := ( "1110000",  "0000000", "0000000", "0000000" )
   );
-- Declarations

END bench_ptrhm_acquire_tb ;

--
-- VHDL Architecture idx_fpga_lib.bench_ptrhm_acquire_tb.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:57:41 02/16/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
--  Copyright 2011 President and Fellows of Harvard College
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.ALL;


ARCHITECTURE struct OF bench_ptrhm_acquire_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpAck : std_ulogic;
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL m_scl  : std_logic_vector(8 DOWNTO 0);
   SIGNAL m_sda  : std_logic_vector(8 DOWNTO 0);
   SIGNAL rData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL rst    : std_logic;
   SIGNAL scl    : std_logic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL sda    : std_logic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL wdata  : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL wdata0 : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL wdata1 : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL wdata2 : std_ulogic_vector(7 DOWNTO 0);


   -- Component Declarations
   COMPONENT bench_ptrhm_acquire_tester
   GENERIC (
      N_ISBITS : integer range 7 downto 1 := 4
   );
   PORT (
      ExpAck : IN     std_ulogic ;
      rData  : IN     std_logic_vector (15 DOWNTO 0);
      wdata0 : IN     std_ulogic_vector (7 DOWNTO 0);
      wdata1 : IN     std_ulogic_vector (7 DOWNTO 0);
      wdata2 : IN     std_ulogic_vector (7 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic ;
      ExpWr  : OUT    std_ulogic ;
      F8M    : OUT    std_ulogic ;
      rst    : OUT    std_logic ;
      m_scl  : INOUT  std_logic_vector (8 DOWNTO 0);
      m_sda  : INOUT  std_logic_vector (8 DOWNTO 0);
      scl    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT i2c_ext_switch
   GENERIC (
      N_SWBITS : NATURAL range 8 downto 2     := 8;
      I2C_ADDR : std_logic_vector(6 downto 0) := "1110000"
   );
   PORT (
      clk   : IN     std_ulogic;
      rst   : IN     std_ulogic;
      m_scl : INOUT  std_logic_vector (N_SWBITS DOWNTO 0);
      m_sda : INOUT  std_logic_vector (N_SWBITS DOWNTO 0);
      scl   : INOUT  std_logic;
      sda   : INOUT  std_logic
   );
   END COMPONENT;
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
   COMPONENT ptrhm_acquire
   GENERIC (
      N_PTRH      : integer range 16 downto 1 := 8;
      N_ISBITS    : integer range 8 downto 1  := 4;
      ESID        : ESID_array                := ( 3, 2, 1, 0, 0, 0, 0, 0 );
      ESwitchBit  : ESB_array                 := ( 0, 0, 0, 4, 3, 2, 1, 0 );
      ESwitchAddr : ESA_array                 := ( "0000000", "0000000", "0000000", "1110000" );
      ISwitchBit  : ISB_array                 := ( 3, 2, 1, 0 )
   );
   PORT (
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      rst    : IN     std_logic ;
      ExpAck : OUT    std_ulogic ;
      rData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda    : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : bench_ptrhm_acquire_tester USE ENTITY idx_fpga_lib.bench_ptrhm_acquire_tester;
   FOR ALL : i2c_ext_switch USE ENTITY idx_fpga_lib.i2c_ext_switch;
   FOR ALL : i2c_slave USE ENTITY idx_fpga_lib.i2c_slave;
   FOR ALL : ptrhm_acquire USE ENTITY idx_fpga_lib.ptrhm_acquire;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   tester : bench_ptrhm_acquire_tester
      GENERIC MAP (
         N_ISBITS => N_ISBITS
      )
      PORT MAP (
         ExpAck => ExpAck,
         rData  => rData,
         wdata0 => wdata0,
         wdata1 => wdata1,
         wdata2 => wdata2,
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         rst    => rst,
         m_scl  => m_scl,
         m_sda  => m_sda,
         scl    => scl,
         sda    => sda
      );
   ext_switch : i2c_ext_switch
      GENERIC MAP (
         N_SWBITS => 8,
         I2C_ADDR => "1110000"
      )
      PORT MAP (
         clk   => F8M,
         m_scl => m_scl,
         m_sda => m_sda,
         rst   => rst,
         scl   => OPEN,
         sda   => OPEN
      );
   MS0 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1110111"
      )
      PORT MAP (
         clk   => F8M,
         rst   => rst,
         scl   => scl(0),
         wdata => wdata,
         sda   => sda(0)
      );
   SHT0 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk   => F8M,
         rst   => rst,
         scl   => m_scl(0),
         wdata => wdata0,
         sda   => m_sda(0)
      );
   SHT1 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk   => F8M,
         rst   => rst,
         scl   => m_scl(1),
         wdata => wdata1,
         sda   => m_sda(1)
      );
   SHT2 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk   => F8M,
         rst   => rst,
         scl   => scl(0),
         wdata => wdata2,
         sda   => sda(0)
      );
   acquire : ptrhm_acquire
      GENERIC MAP (
         N_PTRH      => N_PTRH,
         N_ISBITS    => N_ISBITS,
         ESID        => ESID,
         ESwitchBit  => ESwitchBit,
         ESwitchAddr => ESwitchAddr,
         ISwitchBit  => ISwitchBit
      )
      PORT MAP (
         Addr   => Addr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => F8M,
         rst    => rst,
         ExpAck => ExpAck,
         rData  => rData,
         scl    => scl,
         sda    => sda
      );

END struct;
