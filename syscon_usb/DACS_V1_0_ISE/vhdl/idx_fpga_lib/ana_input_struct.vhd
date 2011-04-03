-- VHDL Entity idx_fpga_lib.ana_input.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 17:12:19 04/ 2/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_input IS
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F30M   : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      SDI    : IN     std_ulogic_vector (1 DOWNTO 0);
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      rst    : IN     std_ulogic;
      CS5    : OUT    std_ulogic;
      Conv   : OUT    std_ulogic;
      ExpAck : OUT    std_ulogic;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      RdyOut : OUT    std_ulogic;
      Row    : OUT    std_ulogic_vector (5 DOWNTO 0);
      SCK16  : OUT    std_ulogic_vector (1 DOWNTO 0);
      SCK5   : OUT    std_ulogic_vector (1 DOWNTO 0);
      SDO    : OUT    std_ulogic_vector (1 DOWNTO 0)
   );

-- Declarations

END ana_input ;

--
-- VHDL Architecture idx_fpga_lib.ana_input.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 17:12:20 04/ 2/2011
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
   SIGNAL AICtrl    : std_logic_vector(10 DOWNTO 0);
   SIGNAL AcqAddr   : std_logic_vector(8 DOWNTO 0);
   SIGNAL AcqData   : std_logic_vector(31 DOWNTO 0);
   SIGNAL BdEn      : std_ulogic;
   SIGNAL CfgAddr   : std_logic_vector(7 DOWNTO 0);
   SIGNAL CfgEn     : std_ulogic;
   SIGNAL CtrlEn    : std_ulogic;
   SIGNAL DataEn    : std_ulogic;
   SIGNAL RAM_BUSYR : std_ulogic;
   SIGNAL RAM_BUSYW : std_ulogic;
   SIGNAL RD_Addr   : std_logic_vector(7 DOWNTO 0);
   SIGNAL RD_DATA   : std_logic_vector(8 DOWNTO 0);
   SIGNAL RD_DATA1  : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdEn      : std_ulogic;
   SIGNAL RdEn1     : std_ulogic;
   SIGNAL StatEn    : std_ulogic;
   SIGNAL Status    : std_ulogic_vector(11 DOWNTO 0);
   SIGNAL WR_Addr   : std_logic_vector(7 DOWNTO 0);
   SIGNAL WrEn      : std_ulogic;
   SIGNAL WrEn1     : std_ulogic;


   -- Component Declarations
   COMPONENT ana_addr
   PORT (
      Addr    : IN     std_logic_vector (15 DOWNTO 0);
      AcqAddr : OUT    std_logic_vector (8 DOWNTO 0);
      BdEn    : OUT    std_ulogic;
      CfgAddr : OUT    std_logic_vector (7 DOWNTO 0);
      CfgEn   : OUT    std_ulogic;
      CtrlEn  : OUT    std_ulogic;
      DataEn  : OUT    std_ulogic;
      StatEn  : OUT    std_ulogic
   );
   END COMPONENT;
   COMPONENT ana_cfg_ram
   PORT (
      CfgEn    : IN     std_ulogic;
      RDEN     : IN     std_ulogic;
      RD_ADDR  : IN     std_logic_vector (7 DOWNTO 0);
      RD_CLK   : IN     std_ulogic;
      RST      : IN     std_ulogic;
      WE       : IN     std_ulogic;
      WR_ADDR  : IN     std_logic_vector (7 DOWNTO 0);
      WR_CLK   : IN     std_ulogic;
      WR_DATA  : IN     std_logic_vector (15 DOWNTO 0);
      RAM_BUSY : OUT    std_ulogic;
      RD_DATA  : OUT    std_logic_vector (8 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ana_ctrl_reg
   PORT (
      CtrlEn : IN     std_ulogic ;
      F8M    : IN     std_ulogic ;
      rst    : IN     std_ulogic ;
      WData  : IN     std_logic_vector (10 DOWNTO 0);
      WrEn   : IN     std_ulogic ;
      AICtrl : OUT    std_logic_vector (10 DOWNTO 0);
      F30M   : IN     std_ulogic 
   );
   END COMPONENT;
   COMPONENT ana_data_ram
   PORT (
      DATAEN   : IN     std_ulogic;
      RDEN     : IN     std_ulogic;
      RD_ADDR  : IN     std_logic_vector (8 DOWNTO 0);
      RD_CLK   : IN     std_ulogic;
      RST      : IN     std_ulogic;
      WREN     : IN     std_ulogic;
      WR_ADDR  : IN     std_logic_vector (7 DOWNTO 0);
      WR_CLK   : IN     std_ulogic;
      WR_DATA  : IN     std_logic_vector (31 DOWNTO 0);
      RAM_BUSY : OUT    std_ulogic;
      RD_DATA  : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ana_hwside
   GENERIC (
      DEF_CFG : std_logic_vector(8 DOWNTO 0) := "000010100"
   );
   PORT (
      AICtrl    : IN     std_logic_vector (10 DOWNTO 0);
      CLK       : IN     std_logic;
      CfgData   : IN     std_logic_vector (8 DOWNTO 0);
      RAM_BusyR : IN     std_ulogic;
      RAM_BusyW : IN     std_ulogic;
      RST       : IN     std_ulogic;
      SDI       : IN     std_ulogic_vector (1 DOWNTO 0);
      AcqData   : OUT    std_logic_vector (31 DOWNTO 0);
      CS5       : OUT    std_ulogic;
      Conv      : OUT    std_ulogic;
      RD_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      RdEn      : OUT    std_ulogic;
      RdyOut    : OUT    std_ulogic;
      Row       : OUT    std_ulogic_vector (5 DOWNTO 0);
      SCK16     : OUT    std_ulogic_vector (1 DOWNTO 0);
      SCK5      : OUT    std_ulogic_vector (1 DOWNTO 0);
      SDO       : OUT    std_ulogic_vector (1 DOWNTO 0);
      Status    : OUT    std_ulogic_vector (11 DOWNTO 0);
      WR_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      WrEn      : OUT    std_ulogic
   );
   END COMPONENT;
   COMPONENT ana_rdata
   PORT (
      DataEn   : IN     std_ulogic ;
      RD_DATA1 : IN     std_logic_vector (15 DOWNTO 0);
      StatEn   : IN     std_ulogic ;
      Status   : IN     std_ulogic_vector (11 DOWNTO 0);
      RData    : OUT    std_logic_vector (15 DOWNTO 0);
      F8M      : IN     std_ulogic 
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
   FOR ALL : ana_addr USE ENTITY idx_fpga_lib.ana_addr;
   FOR ALL : ana_cfg_ram USE ENTITY idx_fpga_lib.ana_cfg_ram;
   FOR ALL : ana_ctrl_reg USE ENTITY idx_fpga_lib.ana_ctrl_reg;
   FOR ALL : ana_data_ram USE ENTITY idx_fpga_lib.ana_data_ram;
   FOR ALL : ana_hwside USE ENTITY idx_fpga_lib.ana_hwside;
   FOR ALL : ana_rdata USE ENTITY idx_fpga_lib.ana_rdata;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   addrs : ana_addr
      PORT MAP (
         Addr    => Addr,
         BdEn    => BdEn,
         CfgEn   => CfgEn,
         CtrlEn  => CtrlEn,
         DataEn  => DataEn,
         StatEn  => StatEn,
         CfgAddr => CfgAddr,
         AcqAddr => AcqAddr
      );
   cfg_ram : ana_cfg_ram
      PORT MAP (
         RD_ADDR  => RD_Addr,
         WR_ADDR  => CfgAddr,
         RD_DATA  => RD_DATA,
         WR_DATA  => WData,
         WE       => WrEn,
         CfgEn    => CfgEn,
         RDEN     => RdEn1,
         RD_CLK   => F30M,
         WR_CLK   => F8M,
         RAM_BUSY => RAM_BUSYR,
         RST      => rst
      );
   ctrl_reg : ana_ctrl_reg
      PORT MAP (
         CtrlEn => CtrlEn,
         F8M    => F8M,
         rst    => rst,
         WData  => WData(10 DOWNTO 0),
         WrEn   => WrEn,
         AICtrl => AICtrl,
         F30M   => F30M
      );
   data_ram : ana_data_ram
      PORT MAP (
         RDEN     => RdEn,
         DATAEN   => DataEn,
         WREN     => WrEn1,
         RD_DATA  => RD_DATA1,
         WR_DATA  => AcqData,
         RD_ADDR  => AcqAddr,
         WR_ADDR  => WR_Addr,
         RD_CLK   => F8M,
         WR_CLK   => F30M,
         RAM_BUSY => RAM_BUSYW,
         RST      => rst
      );
   hwside : ana_hwside
      GENERIC MAP (
         DEF_CFG => "000010100"
      )
      PORT MAP (
         CLK       => F30M,
         RST       => rst,
         AICtrl    => AICtrl,
         Row       => Row,
         CfgData   => RD_DATA,
         AcqData   => AcqData,
         RD_Addr   => RD_Addr,
         WR_Addr   => WR_Addr,
         Status    => Status,
         RAM_BusyR => RAM_BUSYR,
         RAM_BusyW => RAM_BUSYW,
         RdEn      => RdEn1,
         WrEn      => WrEn1,
         RdyOut    => RdyOut,
         Conv      => Conv,
         CS5       => CS5,
         SDI       => SDI,
         SCK16     => SCK16,
         SDO       => SDO,
         SCK5      => SCK5
      );
   rdata_arb : ana_rdata
      PORT MAP (
         DataEn   => DataEn,
         RD_DATA1 => RD_DATA1,
         StatEn   => StatEn,
         Status   => Status,
         RData    => RData,
         F8M      => F8M
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
