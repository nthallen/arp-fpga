--
-- VHDL Architecture idx_fpga_lib.ana_hwside.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:18:19 10/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY ana_hwside IS
  GENERIC (
     DEF_CFG : std_logic_vector(4 DOWNTO 0) := "10100"
  );
  PORT (
    CLK    : IN std_logic;
    RST    : IN std_logic;
    Row    : OUT std_ulogic_vector(2 DOWNTO 0);
    CfgData : IN std_logic_vector(4 DOWNTO 0);
    AcqData : OUT std_logic_vector(31 DOWNTO 0);
    RAMAddr : OUT std_logic_vector(7 DOWNTO 0);
    RdWrEn  : OUT std_ulogic;
    RdyOut  : OUT std_ulogic;
    Conv    : OUT std_ulogic; -- Conv and SDI to AD7687s
    CS5     : OUT std_ulogic; -- CS for LMP7312s
    SDI     : IN std_ulogic_vector(1 DOWNTO 0); -- data from AD7687s SDO
    SCK16   : OUT std_ulogic_vector(1 DOWNTO 0); -- SCK to AD7687s
    SDO     : OUT std_ulogic_vector(1 DOWNTO 0); -- data to LMP7312 SDI
    SCK5    : OUT std_ulogic_vector(1 DOWNTO 0) -- SCK to LMP7312s
  );
END ENTITY ana_hwside;

--
ARCHITECTURE beh OF ana_hwside IS
   type cache_t is array (7 DOWNTO 0) of std_logic_vector(4 DOWNTO 0);
   SIGNAL RdyIn  : std_ulogic;
   SIGNAL S5WE   : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL Start  : std_ulogic;
   SIGNAL DO5_0  : std_logic_vector(4 DOWNTO 0);
   SIGNAL DO5_1  : std_logic_vector(4 DOWNTO 0);
   SIGNAL DO16_0 : std_ulogic_vector(15 DOWNTO 0);
   SIGNAL DO16_1 : std_ulogic_vector(15 DOWNTO 0);
   SIGNAL Rdy    : std_ulogic_vector(3 DOWNTO 0);
   SIGNAL RAMAddr_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL CfgCache0 : cache_t;
   SIGNAL CfgCache1 : cache_t;

   COMPONENT ana_acquire
      PORT (
         CLK    : IN     std_ulogic;
         RST    : IN     std_ulogic;
         RdyIn  : IN     std_ulogic;
         SDI    : IN     std_ulogic_vector(1 DOWNTO 0);
         Addr   : OUT    std_logic_vector(7 DOWNTO 0);
         Conv   : OUT    std_ulogic;
         CS5    : OUT    std_ulogic;
         NxtRow : OUT    std_ulogic_vector(2 DOWNTO 0);
         RdWrEn : OUT    std_ulogic;
         RdyOut : OUT    std_ulogic;
         S5WE   : OUT    std_ulogic_vector(1 DOWNTO 0);
         Start  : OUT    std_ulogic
      );
   END COMPONENT;

   COMPONENT ana_s16
      PORT (
         CLK   : IN     std_ulogic;
         RST   : IN     std_ulogic;
         SDI   : IN     std_ulogic;
         Start : IN     std_ulogic;
         DO    : OUT    std_ulogic_vector(15 DOWNTO 0);
         RDY   : OUT    std_ulogic;
         SCK   : OUT    std_ulogic
      );
   END COMPONENT;

   COMPONENT ana_s5
      GENERIC (
         DEF_CFG : std_logic_vector(4 DOWNTO 0) := "10100"
      );
      PORT (
         SDO   : OUT    std_ulogic;
         SCK   : OUT    std_ulogic;
         DI    : IN     std_logic_vector(4 DOWNTO 0);
         WE    : IN     std_ulogic;
         Start : IN     std_ulogic;
         CLK   : IN     std_ulogic;
         RST   : IN     std_ulogic;
         DO    : OUT    std_logic_vector(4 DOWNTO 0);
         RDY   : OUT    std_ulogic
      );
   END COMPONENT;

   FOR ALL : ana_acquire USE ENTITY idx_fpga_lib.ana_acquire;
   FOR ALL : ana_s16 USE ENTITY idx_fpga_lib.ana_s16;
   FOR ALL : ana_s5 USE ENTITY idx_fpga_lib.ana_s5;
BEGIN

   ana_s5_0 : ana_s5
      GENERIC MAP (
         DEF_CFG => DEF_CFG
      )
      PORT MAP (
         SDO   => SDO(0),
         SCK   => SCK5(0),
         DI    => CfgData,
         WE    => S5WE(0),
         Start => Start,
         CLK   => CLK,
         RST   => RST,
         DO    => DO5_0,
         RDY   => RDY(0)
      );

  ana_s5_1 : ana_s5
     GENERIC MAP (
        DEF_CFG => DEF_CFG
     )
     PORT MAP (
        SDO   => SDO(1),
        SCK   => SCK5(1),
        DI    => CfgData,
        WE    => S5WE(1),
        Start => Start,
        CLK   => CLK,
        RST   => RST,
        DO    => DO5_1,
        RDY   => RDY(1)
     );

   ana_s16_0 : ana_s16
      PORT MAP (
         CLK   => CLK,
         RST   => RST,
         SDI   => SDI(0),
         Start => Start,
         DO    => DO16_0,
         RDY   => RDY(2),
         SCK   => SCK16(0)
      );

  ana_s16_1 : ana_s16
     PORT MAP (
        CLK   => CLK,
        RST   => RST,
        SDI   => SDI(1),
        Start => Start,
        DO    => DO16_1,
        RDY   => RDY(3),
        SCK   => SCK16(1)
     );

   ana_acquire_i : ana_acquire
      PORT MAP (
         CLK    => CLK,
         RST    => RST,
         RdyIn  => RdyIn,
         SDI    => SDI,
         Addr   => RAMAddr_int,
         Conv   => Conv,
         CS5    => CS5,
         NxtRow => Row,
         RdWrEn => RdWrEn,
         RdyOut => RdyOut,
         S5WE   => S5WE,
         Start  => Start
      );

  Ready : Process (Rdy) Is
  Begin
    if Rdy = "1111" then
      RdyIn <= '1';
    else
      RdyIn <= '0';
    end if;
  End Process;
  
  WData : Process (CLK) Is
    Variable CacheUaddr : unsigned(2 DOWNTO 0);
    Variable CacheAddr : integer range 7 DOWNTO 0;
  Begin
    if CLK'Event AND CLK = '1' then
      if RST = '1' then
        for i in 0 to 7 loop
          CfgCache0(i) <= DEF_CFG;
          CfgCache1(i) <= DEF_CFG;
        end loop;
      else
        for i in 0 to 2 loop
          CacheUaddr(i) := RAMAddr_int(i);
        end loop;
        CacheAddr := conv_integer(CacheUaddr);
        if RAMAddr_int(3) = '0' then
          AcqData(15 DOWNTO 0) <= std_logic_vector(DO16_0);
          AcqData(20 DOWNTO 16) <= CfgCache0(CacheAddr);
        else
          AcqData(15 DOWNTO 0) <= std_logic_vector(DO16_1);
          AcqData(20 DOWNTO 16) <= CfgCache1(CacheAddr);
        end if;
        AcqData(31 DOWNTO 21) <= (others => '0');
        if S5WE(0) = '1' then
          CfgCache0(CacheAddr) <= DO5_0;
        end if;
        if S5WE(1) = '1' then
          CfgCache1(CacheAddr) <= DO5_1;
        end if;
      end if;
    end if;
  End Process;
  
  RAMAddr <= RAMAddr_int;
      
END ARCHITECTURE beh;

