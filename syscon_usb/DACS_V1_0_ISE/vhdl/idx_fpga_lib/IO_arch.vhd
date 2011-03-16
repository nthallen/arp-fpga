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
      KZP      : IN     std_logic_vector (2 DOWNTO 0);
      rst      : IN     std_logic;
      Dir      : OUT    std_ulogic;
      InLimit  : OUT    std_ulogic;
      OutLimit : OUT    std_ulogic;
      Run      : OUT    std_ulogic;
      Step     : OUT    std_ulogic;
      ZeroRef  : OUT    std_logic;
      RData    : OUT    std_logic_vector ( 15 DOWNTO 0 );
      WData    : IN     std_logic_vector (7 DOWNTO 0)
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
  SIGNAL KillAPolarity : std_ulogic;
  SIGNAL KillBPolarity : std_ulogic;
  SIGNAL StatusPort : std_logic_vector (7 downto 0);
  SIGNAL InLim : std_ulogic;
  SIGNAL OutLim : std_ulogic;
  SIGNAL ZRP : std_ulogic;
BEGIN
  
  Limits : Process ( LimI, LimO, InPolarity, OutPolarity, LimitSwap ) Is
  Begin
    if LimitSwap = '0' then
      InLim <= LimI xnor InPolarity;
      OutLim <= LimO xnor OutPolarity;
    else
      InLim <= LimO xnor InPolarity;
      OutLim <= LimI xnor OutPolarity;
    end if;
  End Process;
  
  Zeros : Process ( ZR, ZeroPolarity ) Is
  Begin
    ZRP <= ZR xnor ZeroPolarity;
  End Process;

  Status : Process ( F8M ) Is
  Begin
    if F8M'Event and F8M = '1' then
      if rst = '1' then
        LimitSwap <= '0';
        ZrefDisable <= '0';
        StepPolarity <= '0';
        DirPolarity <= '0';
        RunPolarity <= '0';
        InPolarity <= '0';
        OutPolarity <= '0';
        ZeroPolarity <= '0';
        KillAPolarity <= '0';
        KillBPolarity <= '0';
      else
        InLimit <= InLim;
        OutLimit <= OutLim;
        if ZrefDisable = '1' then
          ZeroRef <= '0';
        else
          ZeroRef <= ZRP;
        end if;
        Dir <= DirOut xor DirPolarity;
        Run <= Running xor RunPolarity;
        Step <= StepClk xor StepPolarity;
        if RdEn = '0' or CfgEn = '0' then
          StatusPort(7) <= CMDENBL;
          StatusPort(6) <= ZRP;
          StatusPort(5) <= KillB xnor KillBPolarity;
          StatusPort(4) <= KillA xnor KillAPolarity;
          StatusPort(3) <= Running;
          StatusPort(2) <= DirOut;
          StatusPort(1) <= OutLim;
          StatusPort(0) <= InLim;
        end if;
        if WrEn = '1' and CfgEn = '1' AND WData(5) = '1' then
          LimitSwap <= WData(0);
          ZrefDisable <= WData(1);
          StepPolarity <= WData(2);
          DirPolarity <= WData(3);
          RunPolarity <= WData(4);
          InPolarity <= WData(6);
          OutPolarity <= WData(7);
          ZeroPolarity <= KZP(0);
          KillAPolarity <= KZP(1);
          KillBPolarity <= KZP(2);
        end if;
      end if;
    end if;
    
  End Process;
  
  RData(7 downto 0) <= StatusPort;
  RData(15 downto 8) <= (others => '0');
  
END ARCHITECTURE arch;

