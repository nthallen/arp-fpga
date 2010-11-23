--
-- VHDL Architecture idx_fpga_lib.DACSbd.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:25:16 11/18/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY DACSbd IS
  GENERIC (
     IDX_N_CHANNELS     : integer range 15 downto 1     := 3;
     DIGIO_N_CONNECTORS : integer range 4 downto 1      := 2
  );
  PORT (
    AI_AD_CNV : OUT std_ulogic_vector ( 1 DOWNTO 0 );
    AI_AD_MISO : IN std_ulogic_vector ( 1 DOWNTO 0 );
    AI_AD_SCK : OUT std_ulogic_vector ( 1 DOWNTO 0 );
    AI_AFE_CS_B : OUT std_ulogic_vector ( 1 DOWNTO 0 );
    AI_AFE_MOSI : OUT std_ulogic_vector ( 1 DOWNTO 0 );
    AI_AFE_SCK : OUT std_ulogic_vector ( 1 DOWNTO 0 );
    AI_MUX0_A : OUT std_ulogic_vector ( 2 DOWNTO 0 );
    AI_MUX1_A : OUT std_ulogic_vector ( 2 DOWNTO 0 );
    DA_CS_B : OUT std_logic_vector ( 1 DOWNTO 0 );
    DIO : INOUT std_logic_vector ( 119 DOWNTO 0 );
    DIO_DIR : OUT std_logic_vector ( 14 DOWNTO 0 );
    GPIO_LED : OUT std_logic_vector ( 3 DOWNTO 0 );
    GPIO_SW : IN std_logic_vector ( 3 DOWNTO 0 );
    DIO_OE : IN std_ulogic;
    DIO_OE_B : IN std_ulogic;
    FPGA_CMDENBL : OUT std_ulogic;
    FPGA_CMDENBL_B : OUT std_ulogic;
    FPGA_CMDSTRB : OUT std_ulogic;
    FPGA_CMDSTRB_B : OUT std_ulogic;
    FPGA_CMD_DIR : IN std_ulogic;
    FPGA_CPU_RESET : IN std_ulogic;
    FPGA_SYSCLK : IN std_ulogic;
    FTDI_D : INOUT std_logic_vector ( 7 DOWNTO 0 );
    FTDI_RD : OUT std_logic;
    FTDI_RXF : IN std_logic;
    FTDI_SI : OUT std_logic;
    FTDI_WR : OUT std_logic;
    GPIO_ERROR_LED : OUT std_logic;
    IIC_SCL : INOUT std_logic;
    IIC_SDA : INOUT std_logic;
    USB_1_RX : IN std_logic;
    USB_1_TX : OUT std_logic;
    -- UNUSED BELOW HERE
    BIO : IN std_logic_vector ( 15 DOWNTO 0 );
    COUNT : IN std_logic_vector ( 7 DOWNTO 0 );
    COUNT_LE : IN std_logic_vector ( 7 DOWNTO 0 );
    COUNT_SDN : IN std_ulogic;
    DA_CLR_B : IN std_ulogic;
    DA_LDAC_B : IN std_ulogic;
    DA_SCK : INOUT std_ulogic;
    DA_SDI : INOUT std_ulogic;
    FPGA_CSO_B : IN std_ulogic;
    FPGA_D0_DIN_MISO_MISO1 : IN std_ulogic;
    FPGA_D1_MISO2 : IN std_ulogic;
    FPGA_D2_MISO3 : IN std_ulogic;
    FPGA_MOSI_CSI_B_MISO0 : IN std_ulogic;
    FPGA_MSD_CS_B : IN std_ulogic;
    FPGA_UFM_CS_B : IN std_ulogic;
    FPGA_XCLK : IN std_ulogic;
    FPGA_XTRIG : IN std_ulogic;
    FTDI_PWREN_B : IN std_ulogic;
    FTDI_SIWU : IN std_ulogic;
    FTDI_SPR_AC1 : IN std_ulogic;
    FTDI_SPR_AC6 : IN std_ulogic;
    FTDI_SPR_AC7 : IN std_ulogic;
    FTDI_SPR_AD3 : IN std_ulogic;
    FTDI_SPR_AD5 : IN std_ulogic;
    FTDI_SPR_AD6 : IN std_ulogic;
    FTDI_SPR_AD7 : IN std_ulogic;
    FTDI_SPR_BC5 : IN std_ulogic;
    FTDI_SPR_BC6 : IN std_ulogic;
    FTDI_SPR_BC7 : IN std_ulogic;
    FTDI_SUSPEND_B : IN std_ulogic;
    FTDI_TXE : IN std_ulogic;
    FTDI_UPLOAD : IN std_ulogic;
    GPIO_HDR : IN std_ulogic_vector ( 15 DOWNTO 0 );
    MPS_PFO_B : IN std_ulogic;
    MPS_RESET_B : IN std_ulogic;
    MPS_WDI : IN std_ulogic;
    PHY_COL : IN std_ulogic;
    PHY_CRS : IN std_ulogic;
    PHY_INT : IN std_ulogic;
    PHY_MDC : IN std_ulogic;
    PHY_MDIO : IN std_ulogic;
    PHY_RESET : IN std_ulogic;
    PHY_RXCTL_RXDV : IN std_ulogic;
    PHY_RXC_RXCLK : IN std_ulogic;
    PHY_RXD0 : IN std_ulogic;
    PHY_RXD1 : IN std_ulogic;
    PHY_RXD2 : IN std_ulogic;
    PHY_RXD3 : IN std_ulogic;
    PHY_RXER : IN std_ulogic;
    PHY_TXCLK : IN std_ulogic;
    PHY_TXCTL_TXEN : IN std_ulogic;
    PHY_TXD0 : IN std_ulogic;
    PHY_TXD1 : IN std_ulogic;
    PHY_TXD2 : IN std_ulogic;
    PHY_TXD3 : IN std_ulogic;
    USB_1_CTS : IN std_ulogic;
    USB_1_RTS : IN std_ulogic
  );
END ENTITY DACSbd;

--
ARCHITECTURE beh OF DACSbd IS
   SIGNAL subbus_cmdenbl                 : std_ulogic;
   SIGNAL subbus_cmdstrb                 : std_ulogic;
   SIGNAL subbus_fail_leds               : std_logic_vector(4 downto 0);
   SIGNAL subbus_flt_cpu_reset           : std_ulogic;
   SIGNAL idx_Run                        : std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
   SIGNAL idx_Step                       : std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
   SIGNAL idx_Dir                        : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_KillA                      : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_KillB                      : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_LimI                       : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_LimO                       : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_ZR                         : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   --SIGNAL dig_IO                       : std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
   SIGNAL spare_DIO                      : std_logic_vector(7 DOWNTO 0);
   SIGNAL dig_Dir                        : std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);
   SIGNAL ana_in_CS5                     : std_ulogic;
   SIGNAL ana_in_Conv                    : std_ulogic;
   SIGNAL ana_in_Row                     : std_ulogic_vector(2 DOWNTO 0);
   COMPONENT dacs
      GENERIC (
         N_INTERRUPTS       : integer range 15 downto 1     := 1;
         N_BOARDS           : integer range 15 downto 1     := 3;
         IDX_N_CHANNELS     : integer range 15 downto 1     := IDX_N_CHANNELS;
         IDX_BASE_ADDR      : std_logic_vector(15 downto 0) := X"0A00";
         DIGIO_N_CONNECTORS : integer range 4 downto 1      := DIGIO_N_CONNECTORS
      );
      PORT (
         fpga_0_rst_1_sys_rst_pin       : IN     std_logic;
         fpga_0_clk_1_sys_clk_pin       : IN     std_logic;
         xps_epc_0_FTDI_RXF_pin         : IN     std_logic;
         xps_epc_0_PRH_Data_pin         : INOUT  std_logic_vector(7 downto 0);
         xps_epc_0_PRH_Rd_n_pin         : OUT    std_logic;
         xps_epc_0_FTDI_WR_pin          : OUT    std_logic;
         FTDI_SI_pin                    : OUT    std_logic;
         fpga_0_RS232_RX_pin            : IN     std_logic;
         fpga_0_RS232_TX_pin            : OUT    std_logic;
         fpga_0_Generic_IIC_Bus_Sda_pin : INOUT  std_logic;
         fpga_0_Generic_IIC_Bus_Scl_pin : INOUT  std_logic;
         subbus_cmdenbl                 : OUT    std_ulogic;
         subbus_cmdstrb                 : OUT    std_ulogic;
         subbus_fail_leds               : OUT    std_logic_vector(4 downto 0);
         subbus_flt_cpu_reset           : OUT    std_ulogic;
         DACS_switches                  : IN     std_logic_vector(3 downto 0);
         idx_Run                        : OUT    std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
         idx_Step                       : OUT    std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
         idx_Dir                        : OUT    std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         idx_KillA                      : IN     std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         idx_KillB                      : IN     std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         idx_LimI                       : IN     std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         idx_LimO                       : IN     std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         idx_ZR                         : IN     std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
         dig_IO                         : INOUT  std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
         dig_Dir                        : OUT    std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);
         ana_in_SDI                     : IN     std_ulogic_vector(1 DOWNTO 0);
         ana_in_CS5                     : OUT    std_ulogic;
         ana_in_Conv                    : OUT    std_ulogic;
         ana_in_Row                     : OUT    std_ulogic_vector(2 DOWNTO 0);
         ana_in_SCK16                   : OUT    std_ulogic_vector(1 DOWNTO 0);
         ana_in_SCK5                    : OUT    std_ulogic_vector(1 DOWNTO 0);
         ana_in_SDO                     : OUT    std_ulogic_vector(1 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : dacs USE ENTITY idx_fpga_lib.dacs;
BEGIN
  dacs_i : dacs
    GENERIC MAP (
       N_INTERRUPTS       => 1,
       N_BOARDS           => 3,
       IDX_N_CHANNELS     => IDX_N_CHANNELS,
       IDX_BASE_ADDR      => X"0A00",
       DIGIO_N_CONNECTORS => DIGIO_N_CONNECTORS
    )
    PORT MAP (
       fpga_0_rst_1_sys_rst_pin       => FPGA_CPU_RESET,
       fpga_0_clk_1_sys_clk_pin       => FPGA_SYSCLK,
       xps_epc_0_FTDI_RXF_pin         => FTDI_RXF,
       xps_epc_0_PRH_Data_pin         => FTDI_D,
       xps_epc_0_PRH_Rd_n_pin         => FTDI_RD,
       xps_epc_0_FTDI_WR_pin          => FTDI_WR,
       FTDI_SI_pin                    => FTDI_SI,
       fpga_0_RS232_RX_pin            => USB_1_RX,
       fpga_0_RS232_TX_pin            => USB_1_TX,
       fpga_0_Generic_IIC_Bus_Sda_pin => IIC_SDA,
       fpga_0_Generic_IIC_Bus_Scl_pin => IIC_SCL,
       subbus_cmdenbl                 => subbus_cmdenbl,
       subbus_cmdstrb                 => subbus_cmdstrb,
       subbus_fail_leds               => subbus_fail_leds,
       subbus_flt_cpu_reset           => subbus_flt_cpu_reset,
       DACS_switches                  => GPIO_SW,
       idx_Run                        => idx_Run,
       idx_Step                       => idx_Step,
       idx_Dir                        => idx_Dir,
       idx_KillA                      => idx_KillA,
       idx_KillB                      => idx_KillB,
       idx_LimI                       => idx_LimI,
       idx_LimO                       => idx_LimO,
       idx_ZR                         => idx_ZR,
       dig_Dir                        => dig_Dir,
       dig_IO(23 DOWNTO 0)            => DIO(23 DOWNTO 0),
       dig_IO(31 DOWNTO 24)           => spare_DIO,
       dig_IO(95 DOWNTO 32)           => DIO(119 DOWNTO 56),
       ana_in_SDI                     => AI_AD_MISO,
       ana_in_CS5                     => ana_in_CS5,
       ana_in_Conv                    => ana_in_Conv,
       ana_in_Row                     => ana_in_Row,
       ana_in_SCK16                   => AI_AD_SCK,
       ana_in_SCK5                    => AI_AFE_SCK,
       ana_in_SDO                     => AI_AFE_MOSI
    );

  AI_AD_CNV(0) <= ana_in_Conv;
  AI_AD_CNV(1) <= ana_in_Conv;
  AI_AFE_CS_B(0) <= ana_in_CS5;
  AI_AFE_CS_B(1) <= ana_in_CS5;
  AI_MUX0_A <= ana_in_Row;
  AI_MUX1_A <= ana_in_Row;
  -- DIO(23 DOWNTO 0) <= dig_IO(23 DOWNTO 0);
  DIO(24) <=	idx_Dir(0);
  DIO(25) <=	idx_Run(0);
  DIO(26) <=	idx_Step(0);
  DIO(27) <=	idx_Dir(1);
  DIO(28) <=	idx_Run(1);
  DIO(29) <=	idx_Step(1);
  DIO(30) <=	idx_Dir(2);
  DIO(31) <=	idx_Run(2);
  DIO(32) <=	idx_Step(2);
  DIO(39 DOWNTO 33) <= (others => '0');
  idx_KillA(0) <= DIO(40);
  idx_KillB(0) <= DIO(41);
  idx_LimI(0) <= DIO(42);
  idx_LimO(0) <= DIO(43);
  idx_ZR(0) <= DIO(44);
  idx_KillA(1) <= DIO(45);
  idx_KillB(1) <= DIO(46);
  idx_LimI(1) <= DIO(47);
  idx_LimO(1) <= DIO(48);
  idx_ZR(1) <= DIO(49);
  idx_KillA(2) <= DIO(50);
  idx_KillB(2) <= DIO(51);
  idx_LimI(2) <= DIO(52);
  idx_LimO(2) <= DIO(53);
  idx_ZR(2) <= DIO(54);
  -- DIO(119 DOWNTO 56) <= dig_IO(95 DOWNTO 32);
  DIO_DIR(2 DOWNTO 0) <= dig_Dir(2 DOWNTO 0);
  DIO_DIR(6 DOWNTO 3) <= "1100";
  DIO_DIR(14 DOWNTO 7) <= dig_Dir(11 DOWNTO 4);
  FPGA_CMDENBL	<= subbus_cmdenbl;
  FPGA_CMDENBL_B	<= not subbus_cmdenbl;
  FPGA_CMDSTRB	<= subbus_cmdstrb;
  FPGA_CMDSTRB_B	<= not subbus_cmdstrb;
  GPIO_ERROR_LED	<= subbus_fail_leds(0);
  GPIO_LED <= subbus_fail_leds(4 DOWNTO 1);
END ARCHITECTURE beh;

