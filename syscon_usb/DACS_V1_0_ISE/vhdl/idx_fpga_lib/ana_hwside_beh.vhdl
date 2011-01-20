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
     DEF_CFG : std_logic_vector(8 DOWNTO 0) := "000010100"
  );
  PORT (
    CLK    : IN std_logic;
    RST    : IN std_logic;
    Row    : OUT std_ulogic_vector(5 DOWNTO 0);
    CfgData : IN std_logic_vector(8 DOWNTO 0);
    AcqData : OUT std_logic_vector(31 DOWNTO 0);
    RD_Addr : OUT std_logic_vector(7 DOWNTO 0);
    WR_Addr : OUT std_logic_vector(7 DOWNTO 0);
    RAM_Busy : OUT std_ulogic;
    RdEn    : OUT std_ulogic;
    WrEn    : OUT std_ulogic;
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
   type cache_t is array (7 DOWNTO 0) of std_logic_vector(8 DOWNTO 0);
   SIGNAL RdyIn  : std_ulogic;
   SIGNAL S5WE   : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL Start  : std_ulogic;
   SIGNAL DO5_0  : std_logic_vector(8 DOWNTO 0);
   SIGNAL DO5_1  : std_logic_vector(8 DOWNTO 0);
   SIGNAL DO16_0 : std_ulogic_vector(15 DOWNTO 0);
   SIGNAL DO16_1 : std_ulogic_vector(15 DOWNTO 0);
   SIGNAL Rdy    : std_ulogic_vector(3 DOWNTO 0);
   SIGNAL WR_Addr_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL Col_Addr : std_logic_vector(3 DOWNTO 0);
   SIGNAL CfgCache0 : cache_t;
   SIGNAL CfgCache1 : cache_t;
   SIGNAL CurMuxCfg : std_logic_vector(3 DOWNTO 0);
   SIGNAL RD_Addr_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL RD_Addr_cache : std_logic_vector(3 DOWNTO 0);
   SIGNAL CfgData_int : std_logic_vector(8 DOWNTO 0);
   SIGNAL RdEn_int : std_ulogic;

   COMPONENT ana_acquire
      PORT (
         CLK    : IN     std_ulogic;
         RST    : IN     std_ulogic;
         RdyIn  : IN     std_ulogic;
         SDI    : IN     std_ulogic_vector(1 DOWNTO 0);
         CurMuxCfg : IN  std_logic_vector(3 DOWNTO 0);
         NewMuxCfg : IN  std_logic_vector(3 DOWNTO 0);
         RD_Addr : OUT   std_logic_vector(7 DOWNTO 0);
         WR_Addr : OUT   std_logic_vector(7 DOWNTO 0);
         Col_Addr : OUT  std_logic_vector(3 DOWNTO 0);
         Conv   : OUT    std_ulogic;
         CS5    : OUT    std_ulogic;
         NxtRow : OUT    std_ulogic_vector(5 DOWNTO 0);
         RdEn   : OUT    std_ulogic;
         WrEn   : OUT    std_ulogic;
         RAM_Busy : OUT  std_ulogic;
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
         DEF_CFG : std_logic_vector(8 DOWNTO 0) := "000010100"
      );
      PORT (
         SDO   : OUT    std_ulogic;
         SCK   : OUT    std_ulogic;
         DI    : IN     std_logic_vector(8 DOWNTO 0);
         WE    : IN     std_ulogic;
         Start : IN     std_ulogic;
         CLK   : IN     std_ulogic;
         RST   : IN     std_ulogic;
         DO    : OUT    std_logic_vector(8 DOWNTO 0);
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
         DI    => CfgData_int,
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
        DI    => CfgData_int,
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
         CurMuxCfg => CurMuxCfg,
         NewMuxCfg => CfgData_int(8 DOWNTO 5),
         Col_Addr => Col_Addr,
         RD_Addr => Rd_Addr_int,
         WR_Addr => WR_Addr_int,
         WrEn => WrEn,
         RdEn => RdEn_int,
         Conv   => Conv,
         CS5    => CS5,
         NxtRow => Row,
         RAM_Busy => RAM_Busy,
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
  
  WCache : Process (CLK) Is
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
        -- With RD_Addr and WR_Addr separate and either pointing to
        -- muxed addrs, we need a separate address for the cache
        for i in 0 to 2 loop
          CacheUaddr(i) := Col_Addr(i);
        end loop;
        CacheAddr := conv_integer(CacheUaddr);
        
        if S5WE(0) = '1' then
          CfgCache0(CacheAddr) <= DO5_0;
        end if;
        if S5WE(1) = '1' then
          CfgCache1(CacheAddr) <= DO5_1;
        end if;
      end if;
    end if;
  End Process;
  
  WData : Process(CLK) Is
    Variable CacheUaddr : unsigned(2 DOWNTO 0);
    Variable CacheAddr : integer range 7 DOWNTO 0;
  Begin
    if CLK'Event AND CLK = '1' then
      for i in 0 to 2 loop
        CacheUaddr(i) := Col_Addr(i);
      end loop;
      CacheAddr := conv_integer(CacheUaddr);
  
      if Col_Addr(3) = '0' then
        AcqData(15 DOWNTO 0) <= std_logic_vector(DO16_0);
        AcqData(24 DOWNTO 16) <= CfgCache0(CacheAddr);
        CurMuxCfg <= CfgCache0(CacheAddr)(8 DOWNTO 5);
      else
        AcqData(15 DOWNTO 0) <= std_logic_vector(DO16_1);
        AcqData(24 DOWNTO 16) <= CfgCache1(CacheAddr);
        CurMuxCfg <= CfgCache1(CacheAddr)(8 DOWNTO 5);
      end if;
    end if;
    AcqData(31 DOWNTO 25) <= (others => '0');
  End Process;
  
  RdAddr_p : Process (CLK) Is
  Begin
    if CLK'Event AND CLK = '1' then
      if RdEn_int = '1' then
        RD_Addr_cache <= RD_Addr_int(7 DOWNTO 4);
      end if;
    end if;
  End Process;

  CfgData_p : Process (RD_Addr_cache, CfgData) Is
  Begin
    if RD_Addr_cache(3) = '1' then
      CfgData_int(8 DOWNTO 5) <= RD_Addr_cache;
    else
      CfgData_int(8 DOWNTO 5) <= CfgData(8 DOWNTO 5);
    end if;
    CfgData_int(4 DOWNTO 0) <= CfgData(4 DOWNTO 0);
  End Process;
  
  RdEn <= RdEn_int;
  RD_Addr <= RD_Addr_int;
  WR_Addr <= WR_Addr_int;
      
END ARCHITECTURE beh;

