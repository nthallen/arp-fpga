-- VHDL Entity idx_fpga_lib.lk204.symbol
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:17 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY lk204 IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1100"
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      INTA   : IN     std_ulogic;
      Rst    : IN     std_logic;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      BdIntr : OUT    std_logic;
      ExpAck : OUT    std_ulogic;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      scl    : INOUT  std_logic_vector (0 TO 0);
      sda    : INOUT  std_logic_vector (0 TO 0)
   );

-- Declarations

END lk204 ;

--
-- VHDL Architecture idx_fpga_lib.lk204.struct
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:17 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF lk204 IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BdEn         : std_ulogic;
   SIGNAL CharData     : std_logic_vector(8 DOWNTO 0);
   SIGNAL Empty        : std_logic;
   SIGNAL En           : std_ulogic_vector(0 TO 0);
   SIGNAL Full         : std_logic;
   SIGNAL Ictrl        : std_logic;
   SIGNAL Ireq         : std_ulogic;
   SIGNAL KeyData      : std_logic_vector(7 DOWNTO 0);
   SIGNAL KeyEmpty     : std_logic;
   SIGNAL KeyRE        : std_logic;
   SIGNAL LK204        : std_logic;
   SIGNAL LKWrEn       : std_logic;
   SIGNAL PCA          : std_logic;
   SIGNAL RE           : std_logic;
   SIGNAL RdEn         : std_ulogic;
   SIGNAL SData        : std_logic_vector(7 DOWNTO 0);
   SIGNAL Status       : std_logic_vector(15 DOWNTO 0);
   SIGNAL WData1       : std_logic_vector(8 DOWNTO 0);
   SIGNAL WE           : std_logic;
   SIGNAL WE1          : std_logic;
   SIGNAL WQFull       : std_logic;
   SIGNAL WrEn         : std_ulogic;
   SIGNAL scl_pad_i    : std_logic;
   SIGNAL scl_pad_o    : std_logic;                        -- i2c clock line output
   SIGNAL scl_padoen_o : std_logic;                        -- i2c clock line output enable, active low
   SIGNAL sda_pad_i    : std_logic;
   SIGNAL sda_pad_o    : std_logic;                        -- i2c data line output
   SIGNAL sda_padoen_o : std_logic;                        -- i2c data line output enable, active low


   -- Component Declarations
   COMPONENT IntrCtrl
   PORT (
      F8M    : IN     std_ulogic ;
      Ictrl  : IN     std_logic ;
      Ireq   : IN     std_ulogic ;
      Rst    : IN     std_logic ;
      WData  : IN     std_logic ;
      WrEn   : IN     std_ulogic ;
      BdIntr : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT fifo
   GENERIC (
      FIFO_WIDTH  : integer range 16 downto 1  := 1;
      FIFO_LENGTH : integer range 255 downto 1 := 1
   );
   PORT (
      WData : IN     std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      WE    : IN     std_logic ;
      RE    : IN     std_logic ;
      Clk   : IN     std_ulogic ;
      Rst   : IN     std_logic ;
      RData : OUT    std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      Empty : OUT    std_logic ;
      Full  : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT i2c_half_switch
   GENERIC (
      N_ISBITS : integer range 20 downto 1 := 4
   );
   PORT (
      En       : IN     std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      pad_o    : IN     std_logic ;
      padoen_o : IN     std_logic ;
      pad_i    : OUT    std_logic ;
      pad      : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT lk204_addr
   GENERIC (
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1100"
   );
   PORT (
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      BdEn  : OUT    std_ulogic ;
      Ictrl : OUT    std_logic ;
      LK204 : OUT    std_logic ;
      PCA   : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT lk204_engine
   PORT (
      CharData     : IN     std_logic_vector (8 DOWNTO 0);
      Empty        : IN     std_logic ;
      F8M          : IN     std_ulogic ;
      Full         : IN     std_logic ;
      LKWrEn       : IN     std_logic ;
      Rst          : IN     std_logic ;
      WQFull       : IN     std_logic ;
      scl_pad_i    : IN     std_logic ;
      sda_pad_i    : IN     std_logic ;
      EngStatus    : OUT    std_logic_vector (15 DOWNTO 0);
      RE           : OUT    std_logic ;
      SData        : OUT    std_logic_vector (7 DOWNTO 0);
      WE           : OUT    std_logic ;
      scl_pad_o    : OUT    std_logic ;                   -- i2c clock line output
      scl_padoen_o : OUT    std_logic ;                   -- i2c clock line output enable, active low
      sda_pad_o    : OUT    std_logic ;                   -- i2c data line output
      sda_padoen_o : OUT    std_logic                     -- i2c data line output enable, active low
   );
   END COMPONENT;
   COMPONENT lk204_intr
   PORT (
      F8M      : IN     std_ulogic ;
      INTA     : IN     std_ulogic ;
      KeyEmpty : IN     std_logic ;
      Rst      : IN     std_logic ;
      Ireq     : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT lk204_stat
   PORT (
      F8M      : IN     std_ulogic ;
      KeyData  : IN     std_logic_vector (7 DOWNTO 0);
      KeyEmpty : IN     std_logic ;
      RdEn     : IN     std_ulogic ;
      Status   : IN     std_logic_vector (15 DOWNTO 0);
      KeyRE    : OUT    std_logic ;
      RData    : OUT    std_logic_vector (15 DOWNTO 0);
      Rst      : IN     std_logic ;
      LK204    : IN     std_logic ;
      PCA      : IN     std_logic 
   );
   END COMPONENT;
   COMPONENT lk204_wd
   PORT (
      F8M    : IN     std_ulogic ;
      LK204  : IN     std_logic ;
      PCA    : IN     std_logic ;
      Rst    : IN     std_logic ;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      WrEn   : IN     std_ulogic ;
      En     : OUT    std_ulogic_vector (0 TO 0);
      LKWrEn : OUT    std_logic ;
      WData1 : OUT    std_logic_vector (8 DOWNTO 0);
      WE1    : OUT    std_logic 
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
   FOR ALL : IntrCtrl USE ENTITY idx_fpga_lib.IntrCtrl;
   FOR ALL : fifo USE ENTITY idx_fpga_lib.fifo;
   FOR ALL : i2c_half_switch USE ENTITY idx_fpga_lib.i2c_half_switch;
   FOR ALL : lk204_addr USE ENTITY idx_fpga_lib.lk204_addr;
   FOR ALL : lk204_engine USE ENTITY idx_fpga_lib.lk204_engine;
   FOR ALL : lk204_intr USE ENTITY idx_fpga_lib.lk204_intr;
   FOR ALL : lk204_stat USE ENTITY idx_fpga_lib.lk204_stat;
   FOR ALL : lk204_wd USE ENTITY idx_fpga_lib.lk204_wd;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   IntrCtrl0 : IntrCtrl
      PORT MAP (
         F8M    => F8M,
         Ictrl  => Ictrl,
         Ireq   => Ireq,
         Rst    => Rst,
         WData  => WData(5),
         WrEn   => WrEn,
         BdIntr => BdIntr
      );
   RQueue : fifo
      GENERIC MAP (
         FIFO_WIDTH  => 8,
         FIFO_LENGTH => 2
      )
      PORT MAP (
         WData => SData,
         WE    => WE,
         RE    => KeyRE,
         Clk   => F8M,
         Rst   => Rst,
         RData => KeyData,
         Empty => KeyEmpty,
         Full  => Full
      );
   WQueue : fifo
      GENERIC MAP (
         FIFO_WIDTH  => 9,
         FIFO_LENGTH => 85
      )
      PORT MAP (
         WData => WData1,
         WE    => WE1,
         RE    => RE,
         Clk   => F8M,
         Rst   => Rst,
         RData => CharData,
         Empty => Empty,
         Full  => WQFull
      );
   scl_buf : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => 1
      )
      PORT MAP (
         En       => En,
         pad_o    => scl_pad_o,
         padoen_o => scl_padoen_o,
         pad_i    => scl_pad_i,
         pad      => scl
      );
   sda_buf : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => 1
      )
      PORT MAP (
         En       => En,
         pad_o    => sda_pad_o,
         padoen_o => sda_padoen_o,
         pad_i    => sda_pad_i,
         pad      => sda
      );
   Addr_dec : lk204_addr
      GENERIC MAP (
         BASE_ADDR => BASE_ADDR
      )
      PORT MAP (
         Addr  => Addr,
         BdEn  => BdEn,
         Ictrl => Ictrl,
         LK204 => LK204,
         PCA   => PCA
      );
   Engine : lk204_engine
      PORT MAP (
         CharData     => CharData,
         Empty        => Empty,
         F8M          => F8M,
         Full         => Full,
         LKWrEn       => LKWrEn,
         Rst          => Rst,
         WQFull       => WQFull,
         scl_pad_i    => scl_pad_i,
         sda_pad_i    => sda_pad_i,
         EngStatus    => Status,
         RE           => RE,
         SData        => SData,
         WE           => WE,
         scl_pad_o    => scl_pad_o,
         scl_padoen_o => scl_padoen_o,
         sda_pad_o    => sda_pad_o,
         sda_padoen_o => sda_padoen_o
      );
   Intr : lk204_intr
      PORT MAP (
         F8M      => F8M,
         INTA     => INTA,
         KeyEmpty => KeyEmpty,
         Rst      => Rst,
         Ireq     => Ireq
      );
   Status_sel : lk204_stat
      PORT MAP (
         F8M      => F8M,
         KeyData  => KeyData,
         KeyEmpty => KeyEmpty,
         RdEn     => RdEn,
         Status   => Status,
         KeyRE    => KeyRE,
         RData    => RData,
         Rst      => Rst,
         LK204    => LK204,
         PCA      => PCA
      );
   wd : lk204_wd
      PORT MAP (
         F8M    => F8M,
         LK204  => LK204,
         PCA    => PCA,
         Rst    => Rst,
         WData  => WData,
         WrEn   => WrEn,
         En     => En,
         LKWrEn => LKWrEn,
         WData1 => WData1,
         WE1    => WE1
      );
   IO : subbus_io
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
