--
-- VHDL Architecture idx_fpga_lib.IO.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:34:54 01/15/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY IO IS
   PORT( 
      CMDENBL  : IN     std_ulogic;
      CfgEn    : IN     std_ulogic;
      DirOut   : IN     std_ulogic;
      F8M      : IN     std_ulogic;
      KillA    : IN     std_ulogic;
      KillB    : IN     std_ulogic;
      LimI     : IN     std_ulogic;
      LimO     : IN     std_ulogic;
      RdEn     : IN     std_ulogic;
      Running  : IN     std_ulogic;
      StepClk  : IN     std_ulogic;
      WrEn     : IN     std_ulogic;
      ZR       : IN     std_ulogic;
      Dir      : OUT    std_ulogic;
      InLimit  : OUT    std_ulogic;
      OutLimit : OUT    std_ulogic;
      Run      : OUT    std_ulogic;
      Step     : OUT    std_ulogic;
      ZeroRef  : OUT    std_logic;
      Data     : INOUT  std_logic_vector ( 15 DOWNTO 0 )
   );

-- Declarations

END IO ;

--
ARCHITECTURE arch OF IO IS
  SIGNAL LimitSwap : std_ulogic;
  SIGNAL ZrefDisable : std_ulogic;
  SIGNAL StepPolarity : std_ulogic;
  SIGNAL DirPolarity : std_ulogic;
  SIGNAL RunPolarity : std_ulogic;
  SIGNAL InPolarity : std_ulogic;
  SIGNAL OutPolarity : std_ulogic;
  SIGNAL ZeroPolarity : std_ulogic;
  SIGNAL StatusPort : std_logic_vector (7 downto 0);
  SIGNAL InLim : std_ulogic;
  SIGNAL OutLim : std_ulogic;
  SIGNAL ZRP : std_ulogic;
BEGIN
  
  Limits : Process ( LimI, LimO, InPolarity, OutPolarity, LimitSwap ) Is
  Begin
    if LimitSwap = '0' then
      InLim <= LimI xor InPolarity;
      OutLim <= LimO xor OutPolarity;
    else
      InLim <= LimO xor InPolarity;
      OutLim <= LimI xor OutPolarity;
    end if;
  End Process;
  
  Zeros : Process ( ZR, ZeroPolarity ) Is
  Begin
    ZRP <= ZR xor ZeroPolarity;
  End Process;

  Status : Process ( F8M ) Is
  Begin
    if F8M'Event and F8M = '1' then
      InLimit <= InLim;
      OutLimit <= OutLim;
      ZeroRef <= ZRP or ZrefDisable;
      Dir <= DirOut xor DirPolarity;
      Run <= Running xor RunPolarity;
      Step <= StepClk xor StepPolarity;
      if RdEn = '0' or CfgEn = '0' then
        StatusPort(7) <= CMDENBL;
        StatusPort(6) <= ZRP;
        StatusPort(5) <= KillB;
        StatusPort(4) <= KillA;
        StatusPort(3) <= Running;
        StatusPort(2) <= DirOut;
        StatusPort(1) <= OutLim;
        StatusPort(0) <= InLim;
      end if;
      if WrEn = '1' and CfgEn = '1' AND Data(5) = '1' then
        LimitSwap <= Data(0);
        ZrefDisable <= Data(1);
        StepPolarity <= Data(2);
        DirPolarity <= Data(3);
        RunPolarity <= Data(4);
        InPolarity <= Data(6);
        OutPolarity <= Data(7);
        ZeroPolarity <= Data(12);
      end if;
    end if;
    
  End Process;
  
  ReadBack : Process ( RdEn, CfgEn, StatusPort) Is
  Begin
    if RdEn = '1' and CfgEn = '1' then
      Data(7 downto 0) <= StatusPort;
      Data(15 downto 8) <= (others => '0');
    else
      Data <= (others => 'Z');
    end if;
  End Process;
  
  
END ARCHITECTURE arch;

