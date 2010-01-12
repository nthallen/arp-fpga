-- VHDL Entity idx_fpga_lib.channel.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:47:19 01/11/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY channel IS
   PORT( 
      CMDENBL  : IN     std_ulogic;
      ChanSel  : IN     std_ulogic;
      DirOutIn : IN     std_ulogic;
      F4M      : IN     std_ulogic;
      F8M      : IN     std_ulogic;
      KillA    : IN     std_ulogic;
      KillB    : IN     std_ulogic;
      LimI     : IN     std_ulogic;
      LimO     : IN     std_ulogic;
      OpCd     : IN     std_ulogic_vector (2 DOWNTO 0);
      RdEn     : IN     std_ulogic;
      WrEn     : IN     std_ulogic;
      ZR       : IN     std_ulogic;
      rst      : IN     std_logic;
      Dir      : OUT    std_ulogic;
      Run      : OUT    std_ulogic;
      Step     : OUT    std_ulogic;
      Data     : INOUT  std_logic_vector ( 15 DOWNTO 0 )
   );

-- Declarations

END channel ;

--
-- VHDL Architecture idx_fpga_lib.channel.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:47:19 01/11/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF channel IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL ArmZero  : std_ulogic;
   SIGNAL CfgEn    : std_ulogic;
   SIGNAL ClkEn    : std_ulogic;
   SIGNAL CtEn     : std_ulogic;
   SIGNAL DirOut   : std_ulogic;
   SIGNAL InLimit  : std_ulogic;
   SIGNAL Ld       : std_ulogic;
   SIGNAL Limit    : std_ulogic;
   SIGNAL OutLimit : std_ulogic;
   SIGNAL PosEn    : std_ulogic;
   SIGNAL ResetPos : std_ulogic;
   SIGNAL Running  : std_ulogic;
   SIGNAL StepClk  : std_ulogic;
   SIGNAL StepEn   : std_ulogic;
   SIGNAL ZeroCt   : std_ulogic;
   SIGNAL ZeroRef  : std_logic;
   SIGNAL rclk     : std_ulogic;


   -- Component Declarations
   COMPONENT ChOpDec
   PORT (
      ChanSel : IN     std_ulogic ;
      OpCd    : IN     std_ulogic_vector (2 DOWNTO 0);
      CfgEn   : OUT    std_ulogic ;
      CtEn    : OUT    std_ulogic ;
      PosEn   : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT CtState
   PORT (
      CtEn    : IN     std_ulogic ;
      F8M     : IN     std_ulogic ;
      PosEn   : IN     std_ulogic ;
      RdEn    : IN     std_ulogic ;
      StepClk : IN     std_ulogic ;
      WrEn    : IN     std_ulogic ;
      rst     : IN     std_logic ;
      ClkEn   : OUT    std_ulogic ;
      Ld      : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT DriveCtr
   PORT (
      CtEn     : IN     std_ulogic ;
      DirOutIn : IN     std_ulogic ;
      DirOut   : OUT    std_ulogic ;
      Ld       : IN     std_ulogic ;
      ClkEn    : IN     std_ulogic ;
      Data     : IN     std_logic_vector ( 15 DOWNTO 0 );
      rst      : IN     std_logic ;
      F8M      : IN     std_ulogic ;
      ZeroCt   : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT IO
   PORT (
      CMDENBL  : IN     std_ulogic;
      CfgEn    : IN     std_ulogic;
      Data     : IN     std_logic_vector ( 15 DOWNTO 0 );
      DirOut   : IN     std_ulogic;
      F8M      : IN     std_ulogic;
      KillA    : IN     std_ulogic;
      KillB    : IN     std_ulogic;
      LimI     : IN     std_ulogic;
      LimO     : IN     std_ulogic;
      RdEn     : IN     std_ulogic;
      Running  : IN     std_ulogic;
      WrEn     : IN     std_ulogic;
      ZR       : IN     std_ulogic;
      Dir      : OUT    std_ulogic;
      InLimit  : OUT    std_ulogic;
      OutLimit : OUT    std_ulogic;
      Run      : OUT    std_ulogic;
      Step     : OUT    std_ulogic;
      ZeroRef  : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT Limits
   PORT (
      DirOut   : IN     std_ulogic ;
      F8M      : IN     std_ulogic ;
      InLimit  : IN     std_ulogic ;
      OutLimit : IN     std_ulogic ;
      rst      : IN     std_logic ;
      ArmZero  : OUT    std_ulogic ;
      Limit    : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT PosCtr
   PORT (
      RdEn     : IN     std_ulogic ;
      PosEn    : IN     std_ulogic ;
      F8M      : IN     std_ulogic ;
      rst      : IN     std_logic ;
      Data     : INOUT  std_logic_vector ( 15 DOWNTO 0 );
      Ld       : IN     std_ulogic ;
      ClkEn    : IN     std_ulogic ;
      DirOut   : IN     std_ulogic ;
      ResetPos : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT RateGen
   PORT (
      CfgEn   : IN     std_ulogic;
      F4M     : IN     std_ulogic;
      WrEn    : IN     std_ulogic;
      ratesel : IN     std_logic_vector (3 DOWNTO 0);
      rclk    : OUT    std_ulogic
   );
   END COMPONENT;
   COMPONENT StepClkGen
   PORT (
      F8M     : IN     std_ulogic ;
      StepEn  : IN     std_ulogic ;
      rclk    : IN     std_ulogic ;
      rst     : IN     std_logic ;
      Running : OUT    std_ulogic ;
      StepClk : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT StepEnDef
   PORT (
      CMDENBL : IN     std_ulogic ;
      Limit   : IN     std_ulogic ;
      ZeroCt  : IN     std_ulogic ;
      StepEn  : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT Zero
   PORT (
      ArmZero  : IN     std_ulogic ;
      DirOut   : IN     std_ulogic ;
      F8M      : IN     std_ulogic ;
      ZeroRef  : IN     std_logic ;
      rst      : IN     std_logic ;
      ResetPos : OUT    std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : ChOpDec USE ENTITY idx_fpga_lib.ChOpDec;
   FOR ALL : CtState USE ENTITY idx_fpga_lib.CtState;
   FOR ALL : DriveCtr USE ENTITY idx_fpga_lib.DriveCtr;
   FOR ALL : IO USE ENTITY idx_fpga_lib.IO;
   FOR ALL : Limits USE ENTITY idx_fpga_lib.Limits;
   FOR ALL : PosCtr USE ENTITY idx_fpga_lib.PosCtr;
   FOR ALL : RateGen USE ENTITY idx_fpga_lib.RateGen;
   FOR ALL : StepClkGen USE ENTITY idx_fpga_lib.StepClkGen;
   FOR ALL : StepEnDef USE ENTITY idx_fpga_lib.StepEnDef;
   FOR ALL : Zero USE ENTITY idx_fpga_lib.Zero;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   ChOpDec1 : ChOpDec
      PORT MAP (
         ChanSel => ChanSel,
         OpCd    => OpCd,
         CfgEn   => CfgEn,
         CtEn    => CtEn,
         PosEn   => PosEn
      );
   CtState1 : CtState
      PORT MAP (
         CtEn    => CtEn,
         F8M     => F8M,
         PosEn   => PosEn,
         RdEn    => RdEn,
         StepClk => StepClk,
         WrEn    => WrEn,
         rst     => rst,
         ClkEn   => ClkEn,
         Ld      => Ld
      );
   U_2 : DriveCtr
      PORT MAP (
         CtEn     => CtEn,
         DirOutIn => DirOutIn,
         DirOut   => DirOut,
         Ld       => Ld,
         ClkEn    => ClkEn,
         Data     => Data,
         rst      => rst,
         F8M      => F8M,
         ZeroCt   => ZeroCt
      );
   IO0 : IO
      PORT MAP (
         CMDENBL  => CMDENBL,
         CfgEn    => CfgEn,
         Data     => Data,
         DirOut   => DirOut,
         F8M      => F8M,
         KillA    => KillA,
         KillB    => KillB,
         LimI     => LimI,
         LimO     => LimO,
         RdEn     => RdEn,
         Running  => Running,
         WrEn     => WrEn,
         ZR       => ZR,
         Dir      => Dir,
         InLimit  => InLimit,
         OutLimit => OutLimit,
         Run      => Run,
         Step     => Step,
         ZeroRef  => ZeroRef
      );
   Limits0 : Limits
      PORT MAP (
         DirOut   => DirOut,
         F8M      => F8M,
         InLimit  => InLimit,
         OutLimit => OutLimit,
         rst      => rst,
         ArmZero  => ArmZero,
         Limit    => Limit
      );
   U_1 : PosCtr
      PORT MAP (
         RdEn     => RdEn,
         PosEn    => PosEn,
         F8M      => F8M,
         rst      => rst,
         Data     => Data,
         Ld       => Ld,
         ClkEn    => ClkEn,
         DirOut   => DirOut,
         ResetPos => ResetPos
      );
   RG1 : RateGen
      PORT MAP (
         CfgEn   => CfgEn,
         F4M     => F4M,
         WrEn    => WrEn,
         rclk    => rclk,
         ratesel => Data(11 DOWNTO 8)
      );
   U_0 : StepClkGen
      PORT MAP (
         F8M     => F8M,
         StepEn  => StepEn,
         rclk    => rclk,
         rst     => rst,
         Running => Running,
         StepClk => StepClk
      );
   SED : StepEnDef
      PORT MAP (
         CMDENBL => CMDENBL,
         Limit   => Limit,
         ZeroCt  => ZeroCt,
         StepEn  => StepEn
      );
   Zero0 : Zero
      PORT MAP (
         ArmZero  => ArmZero,
         DirOut   => DirOut,
         F8M      => F8M,
         ZeroRef  => ZeroRef,
         rst      => rst,
         ResetPos => ResetPos
      );

END struct;
