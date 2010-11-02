-- VHDL Entity idx_fpga_lib.ana_input.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:41:43 11/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_input IS
   PORT( 
      Addr   : IN     std_ulogic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F30M   : IN     std_ulogic;
      RST    : IN     std_ulogic;
      SDI    : IN     std_ulogic_vector (1 DOWNTO 0);
      CS5    : OUT    std_ulogic;
      Conv   : OUT    std_ulogic;
      ExpAck : OUT    std_ulogic;
      RdyOut : OUT    std_ulogic;
      Row    : OUT    std_ulogic_vector (2 DOWNTO 0);
      SCK16  : OUT    std_ulogic_vector (1 DOWNTO 0);
      SCK5   : OUT    std_ulogic_vector (1 DOWNTO 0);
      SDO    : OUT    std_ulogic_vector (1 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END ana_input ;

--
-- VHDL Architecture idx_fpga_lib.ana_input.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:41:43 11/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF ana_input IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL AcqAddr : std_logic_vector(7 DOWNTO 0);
   SIGNAL AcqData : std_logic_vector(31 DOWNTO 0);
   SIGNAL BdEn    : std_ulogic;
   SIGNAL CfgAddr : std_logic_vector(7 DOWNTO 0);
   SIGNAL RAMAddr : std_logic_vector(7 DOWNTO 0);
   SIGNAL RD_DATA : std_logic_vector(4 DOWNTO 0);
   SIGNAL RdEn    : std_ulogic;
   SIGNAL RdWrEn  : std_ulogic;
   SIGNAL WrEn    : std_ulogic;
   SIGNAL iData   : std_logic_vector(15 DOWNTO 0);


   -- Component Declarations
   COMPONENT ana_addr
   PORT (
      Addr    : IN     std_ulogic_vector (15 DOWNTO 0);
      AcqAddr : OUT    std_logic_vector (7 DOWNTO 0);
      BdEn    : OUT    std_ulogic;
      CfgAddr : OUT    std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ana_cfg_ram
   PORT (
      CLK     : IN     std_ulogic;
      RDEN    : IN     std_ulogic;
      RD_ADDR : IN     std_logic_vector (7 DOWNTO 0);
      RST     : IN     std_ulogic;
      WE0     : IN     std_ulogic;
      WE1     : IN     std_ulogic;
      WR_ADDR : IN     std_logic_vector (7 DOWNTO 0);
      WR_DATA : IN     std_logic_vector (15 DOWNTO 0);
      RD_DATA : OUT    std_logic_vector (4 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ana_data_ram
   PORT (
      CLK     : IN     std_ulogic;
      RDEN    : IN     std_ulogic;
      RD_ADDR : IN     std_logic_vector (7 DOWNTO 0);
      RST     : IN     std_ulogic;
      WREN    : IN     std_ulogic;
      WR_ADDR : IN     std_logic_vector (7 DOWNTO 0);
      WR_DATA : IN     std_logic_vector (31 DOWNTO 0);
      RD_DATA : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ana_hwside
   GENERIC (
      DEF_CFG : std_logic_vector(4 DOWNTO 0) := "10100"
   );
   PORT (
      CLK     : IN     std_logic;
      CfgData : IN     std_logic_vector (4 DOWNTO 0);
      RST     : IN     std_logic;
      SDI     : IN     std_ulogic_vector (1 DOWNTO 0);
      AcqData : OUT    std_logic_vector (31 DOWNTO 0);
      CS5     : OUT    std_ulogic;
      Conv    : OUT    std_ulogic;
      RAMAddr : OUT    std_logic_vector (7 DOWNTO 0);
      RdWrEn  : OUT    std_ulogic;
      RdyOut  : OUT    std_ulogic;
      Row     : OUT    std_ulogic_vector (2 DOWNTO 0);
      SCK16   : OUT    std_ulogic_vector (1 DOWNTO 0);
      SCK5    : OUT    std_ulogic_vector (1 DOWNTO 0);
      SDO     : OUT    std_ulogic_vector (1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT subbus_io
   PORT (
      BdEn   : IN     std_ulogic;
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      RdEn   : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : ana_addr USE ENTITY idx_fpga_lib.ana_addr;
   FOR ALL : ana_cfg_ram USE ENTITY idx_fpga_lib.ana_cfg_ram;
   FOR ALL : ana_data_ram USE ENTITY idx_fpga_lib.ana_data_ram;
   FOR ALL : ana_hwside USE ENTITY idx_fpga_lib.ana_hwside;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   addrs : ana_addr
      PORT MAP (
         Addr    => Addr,
         BdEn    => BdEn,
         CfgAddr => CfgAddr,
         AcqAddr => AcqAddr
      );
   cfg_ram : ana_cfg_ram
      PORT MAP (
         RD_ADDR => RAMAddr,
         WR_ADDR => CfgAddr,
         RD_DATA => RD_DATA,
         WR_DATA => iData,
         WE0     => WrEn,
         WE1     => BdEn,
         RDEN    => RdWrEn,
         CLK     => F30M,
         RST     => RST
      );
   data_ram : ana_data_ram
      PORT MAP (
         RDEN    => RdEn,
         WREN    => RdWrEn,
         RD_DATA => iData,
         WR_DATA => AcqData,
         RD_ADDR => AcqAddr,
         WR_ADDR => RAMAddr,
         CLK     => F30M,
         RST     => RST
      );
   hwside : ana_hwside
      GENERIC MAP (
         DEF_CFG => "10100"
      )
      PORT MAP (
         CLK     => F30M,
         RST     => RST,
         Row     => Row,
         CfgData => RD_DATA,
         AcqData => AcqData,
         RAMAddr => RAMAddr,
         RdWrEn  => RdWrEn,
         RdyOut  => RdyOut,
         Conv    => Conv,
         CS5     => CS5,
         SDI     => SDI,
         SCK16   => SCK16,
         SDO     => SDO,
         SCK5    => SCK5
      );
   IO : subbus_io
      PORT MAP (
         Data   => Data,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F30M,
         rst    => RST,
         iData  => iData,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );

END struct;
