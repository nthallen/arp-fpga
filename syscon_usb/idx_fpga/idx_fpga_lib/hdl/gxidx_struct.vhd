-- VHDL Entity idx_fpga_lib.gxidx.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:39:01 02/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY gxidx IS
   GENERIC( 
      N_CHANNELS : integer range 15 downto 1 := 2
   );
   PORT( 
      rst         : IN     std_ulogic;
      Addr        : IN     std_ulogic_vector (15 DOWNTO 0);
      CMDENBL     : IN     std_ulogic;
      ExpRd       : IN     std_ulogic;
      ExpWr       : IN     std_ulogic;
      F8M         : IN     std_ulogic;
      KillA       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      KillB       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      LimI        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      LimO        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      ZR          : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      ExpAck      : OUT    std_ulogic;
      ExpIntr_Not : OUT    std_logic;
      Dir         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Run         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Step        : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Data        : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END gxidx ;

--
-- VHDL Architecture idx_fpga_lib.gxidx.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:39:01 02/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF gxidx IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BaseEn : std_ulogic;
   SIGNAL Chan   : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0);
   SIGNAL F4M    : std_ulogic;
   SIGNAL INTA   : std_ulogic;
   SIGNAL OpCd   : std_ulogic_vector(2 DOWNTO 0);
   SIGNAL RdEn   : std_ulogic;
   SIGNAL WrEn   : std_ulogic;
   SIGNAL iData  : std_logic_vector(15 DOWNTO 0);


   -- Component Declarations
   COMPONENT channel
   PORT (
      CMDENBL : IN     std_ulogic ;
      ChanSel : IN     std_ulogic ;
      F4M     : IN     std_ulogic ;
      F8M     : IN     std_ulogic ;
      KillA   : IN     std_ulogic ;
      KillB   : IN     std_ulogic ;
      LimI    : IN     std_ulogic ;
      LimO    : IN     std_ulogic ;
      OpCd    : IN     std_ulogic_vector (2 DOWNTO 0);
      RdEn    : IN     std_ulogic;
      WrEn    : IN     std_ulogic ;
      ZR      : IN     std_ulogic ;
      rst     : IN     std_ulogic ;
      Dir     : OUT    std_ulogic ;
      Run     : OUT    std_ulogic ;
      Step    : OUT    std_ulogic ;
      Data    : INOUT  std_logic_vector ( 15 DOWNTO 0 )
   );
   END COMPONENT;
   
   COMPONENT decode
   GENERIC (
      N_CHANNELS : integer range 15 downto 1 := 1
   );
   PORT (
      Addr   : IN     std_ulogic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      rst    : IN     std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      WrEn   : OUT    std_ulogic ;
      BaseEn : OUT    std_ulogic ;
      INTA   : OUT    std_ulogic ;
      Chan   : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd   : OUT    std_ulogic_vector (2 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn   : OUT    std_ulogic ;
      F4M    : OUT    std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : channel USE ENTITY idx_fpga_lib.channel;
   FOR ALL : decode USE ENTITY idx_fpga_lib.decode;
   -- pragma synthesis_on


BEGIN

  decode_i : decode
    GENERIC MAP (
      N_CHANNELS => N_CHANNELS
    )
    PORT MAP (
      Addr   => Addr,
      ExpRd  => ExpRd,
      ExpWr  => ExpWr,
      F8M    => F8M,
      rst    => rst,
      ExpAck => ExpAck,
      WrEn   => WrEn,
      BaseEn => BaseEn,
      INTA   => INTA,
      Chan   => Chan,
      OpCd   => OpCd,
      Data   => Data,
      iData  => iData,
      RdEn   => RdEn,
      F4M    => F4M
    );
    
  channels : for chno in 0 to N_CHANNELS-1 generate
    Ch : channel
      PORT MAP (
         CMDENBL => CMDENBL,
         ChanSel => Chan(chno),
         F4M     => F4M,
         F8M     => F8M,
         KillA   => KillA(chno),
         KillB   => KillB(chno),
         LimI    => LimI(chno),
         LimO    => LimO(chno),
         OpCd    => OpCd,
         RdEn    => RdEn,
         WrEn    => WrEn,
         ZR      => ZR(chno),
         rst     => rst,
         Dir     => Dir(chno),
         Run     => Run(chno),
         Step    => Step(chno),
         Data    => iData
      );
  end generate;

END struct;
