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

ENTITY PDACS_HTW IS
  GENERIC (
    DACS_BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"000D";
    INSTRUMENT_ID : std_logic_vector(15 DOWNTO 0) := X"0002";
    PTRH_N_BDS : integer range 5 downto 1 := 3;
    CTR_UG_N_BDS : integer range 5 downto 0 := 0;
    IDX_N_CHANNELS : integer range 15 downto 1 := 2;
    DIGIO_N_CONNECTORS : integer range 4 DOWNTO 1 := 4;
    DIGIO_FORCE_DIR : std_ulogic_vector := "111111111111111111100010";
    DIGIO_FORCE_DIR_VAL : std_ulogic_vector := "000000001111001111100000";
    CMD_PROC_N_CMDS : integer := 38
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
    DA_CLR_B : OUT std_ulogic;
    DA_LDAC_B : OUT std_ulogic;
    DA_SCK : OUT std_ulogic;
    DA_SDI : OUT std_ulogic;

    BIO : INOUT std_logic_vector ( 15 DOWNTO 0 );
    DIO : INOUT std_logic_vector ( 119 DOWNTO 0 );
    DIO_DIR : OUT std_logic_vector ( 14 DOWNTO 0 );
    DIO_OE : OUT std_ulogic;
    DIO_OE_B : OUT std_ulogic;

    GPIO_LED : OUT std_logic_vector ( 3 DOWNTO 0 );
    GPIO_SW : IN std_logic_vector ( 3 DOWNTO 0 );
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
    FTDI_TXE : IN std_ulogic;
    FTDI_SI : OUT std_logic;
    FTDI_WR : OUT std_logic;
    GPIO_ERROR_LED : OUT std_logic;
    IIC_SCL : INOUT std_logic;
    IIC_SDA : INOUT std_logic;
    USB_1_RX : IN std_logic;
    USB_1_TX : OUT std_logic;
    -- UNUSED BELOW HERE
    COUNT : IN std_logic_vector ( 7 DOWNTO 0 );
    COUNT_LE : IN std_logic_vector ( 7 DOWNTO 0 );
    COUNT_SDN : IN std_ulogic;
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
END ENTITY PDACS_HTW;

--
ARCHITECTURE beh OF PDACS_HTW IS
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
   SIGNAL dig_Dir                        : std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);
   SIGNAL dig_io_nc                      : std_logic_vector( 15 DOWNTO 0);
   SIGNAL ana_in_CS5                     : std_ulogic;
   SIGNAL ana_in_Conv                    : std_ulogic;
   SIGNAL ana_in_Row                     : std_ulogic_vector(5 DOWNTO 0);
   SIGNAL cmd_dio                        : std_logic_vector(CMD_PROC_N_CMDS*2-1 DOWNTO 0);
   SIGNAL cmd_out                        : std_logic_vector(CMD_PROC_N_CMDS-1 DOWNTO 0);
   SIGNAL RST                            : std_ulogic;
   SIGNAL Collision                      : std_ulogic;
   SIGNAL DACS_switches                  : std_logic_vector(7 DOWNTO 0);
   SIGNAL ctr_PMT                        : std_logic_vector(4*CTR_UG_N_BDS-1 DOWNTO 0);
   
   COMPONENT dacs
     GENERIC (
       DACS_BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0007";
       INSTRUMENT_ID : std_logic_vector(15 DOWNTO 0) := X"0001";
       N_INTERRUPTS : integer range 15 downto 1 := 1;
       PTRH_N_BDS : integer range 5 downto 1 := 2;
       CTR_UG_N_BDS : integer range 5 downto 0 := 2;
       IDX_N_CHANNELS : integer range 15 downto 1 := 3;
       IDX_BASE_ADDR : std_logic_vector(15 downto 0) := X"0A00";
       DIGIO_BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
       DIGIO_N_CONNECTORS : integer range 4 DOWNTO 1 := 2;
       DIGIO_FORCE_DIR : std_ulogic_vector := "000000000000";
       DIGIO_FORCE_DIR_VAL : std_ulogic_vector := "000000000000"
     );
     PORT (
       fpga_0_rst_1_sys_rst_pin       : IN     std_logic;
       fpga_0_clk_1_sys_clk_pin       : IN     std_logic;

       xps_epc_0_PRH_Data_pin         : INOUT  std_logic_vector(7 downto 0);
       FTDI_RD_pin                    : OUT    std_logic;
       FTDI_RXF_pin                   : IN     std_logic;
       FTDI_TXE_pin                   : IN     std_logic;
       FTDI_WR_pin                    : OUT    std_logic;
       FTDI_SI_pin                    : OUT    std_logic;

       fpga_0_RS232_RX_pin            : IN     std_logic;
       fpga_0_RS232_TX_pin            : OUT    std_logic;

       PTRH_SDA_pin                   : INOUT std_logic_vector(PTRH_N_BDS-1 DOWNTO 0);
       PTRH_SCK_pin                   : INOUT std_logic_vector(PTRH_N_BDS-1 DOWNTO 0);

       subbus_cmdenbl                 : OUT    std_ulogic;
       subbus_cmdstrb                 : OUT    std_ulogic;
       subbus_fail_leds               : OUT    std_logic_vector(4 downto 0);
       subbus_flt_cpu_reset           : OUT    std_ulogic;
       subbus_reset                   : OUT    std_ulogic;
       Collision                      : OUT    std_ulogic;

       DACS_switches                  : IN     std_logic_vector(7 downto 0);

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
       ana_in_Row                     : OUT    std_ulogic_vector(5 DOWNTO 0);
       ana_in_SCK16                   : OUT    std_ulogic_vector(1 DOWNTO 0);
       ana_in_SCK5                    : OUT    std_ulogic_vector(1 DOWNTO 0);
       ana_in_SDO                     : OUT    std_ulogic_vector(1 DOWNTO 0);

       ctr_PMT                        : IN std_logic_vector(4*CTR_UG_N_BDS-1 DOWNTO 0);
       
       DA_CLR_B                       : OUT std_logic;
       DA_CS_B                        : OUT std_logic_vector(1 DOWNTO 0);
       DA_LDAC_B                      : OUT std_logic;
       DA_SCK                         : OUT std_logic;
       DA_SDI                         : OUT std_logic
     );
   END COMPONENT;
   COMPONENT cmd_proc
      GENERIC (
         CMD_PROC_N_CMDS : integer := 24
      );
      PORT (
         cmd_dio : IN     std_logic_vector( CMD_PROC_N_CMDS*2-1 DOWNTO 0 );
         cmd_out : OUT    std_logic_vector( CMD_PROC_N_CMDS-1 DOWNTO 0 );
         CmdStrb : IN     std_ulogic;
         CmdEnbl : IN     std_ulogic;
         RST     : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : dacs USE ENTITY idx_fpga_lib.dacs;
   FOR ALL : cmd_proc USE ENTITY idx_fpga_lib.cmd_proc;
BEGIN
  dacs_i : dacs
    GENERIC MAP (
      DACS_BUILD_NUMBER => DACS_BUILD_NUMBER,
      INSTRUMENT_ID => INSTRUMENT_ID,
      PTRH_N_BDS => PTRH_N_BDS,
      CTR_UG_N_BDS => CTR_UG_N_BDS,
      IDX_N_CHANNELS => IDX_N_CHANNELS,
      DIGIO_N_CONNECTORS => DIGIO_N_CONNECTORS,
      DIGIO_FORCE_DIR => DIGIO_FORCE_DIR,
      DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL
    )
    PORT MAP (
       fpga_0_rst_1_sys_rst_pin       => FPGA_CPU_RESET,
       fpga_0_clk_1_sys_clk_pin       => FPGA_SYSCLK,

       xps_epc_0_PRH_Data_pin         => FTDI_D,
       FTDI_RD_pin                    => FTDI_RD,
       FTDI_WR_pin                    => FTDI_WR,
       FTDI_RXF_pin                   => FTDI_RXF,
       FTDI_TXE_pin                   => FTDI_TXE,
       FTDI_SI_pin                    => FTDI_SI,

       fpga_0_RS232_RX_pin            => USB_1_RX,
       fpga_0_RS232_TX_pin            => USB_1_TX,
       PTRH_SDA_pin(0)                => IIC_SDA,
       PTRH_SDA_pin(1)                => BIO(0),
       PTRH_SDA_pin(2)                => BIO(2),
       PTRH_SCK_pin(0)                => IIC_SCL,
       PTRH_SCK_pin(1)                => BIO(1),
       PTRH_SCK_pin(2)                => BIO(3),

       subbus_cmdenbl                 => subbus_cmdenbl,
       subbus_cmdstrb                 => subbus_cmdstrb,
       subbus_fail_leds               => subbus_fail_leds,
       subbus_flt_cpu_reset           => subbus_flt_cpu_reset,
       subbus_reset                   => RST,
       Collision                      => Collision,
       DACS_switches                  => DACS_switches,
       idx_Run                        => idx_Run,
       idx_Step                       => idx_Step,
       idx_Dir                        => idx_Dir,
       idx_KillA                      => idx_KillA,
       idx_KillB                      => idx_KillB,
       idx_LimI                       => idx_LimI,
       idx_LimO                       => idx_LimO,
       idx_ZR                         => idx_ZR,
       dig_Dir                        => dig_Dir,
       dig_IO(63 DOWNTO 0)            => cmd_dio(63 DOWNTO 0),
       dig_IO(107 DOWNTO 96)          => cmd_dio(75 DOWNTO 64),
       dig_IO(95 DOWNTO 64)           => cmd_out(31 DOWNTO 0), -- DS
       dig_IO(117 DOWNTO 112)         => cmd_out(37 DOWNTO 32), -- DS
       dig_IO(111 DOWNTO 108)         => DIO(47 DOWNTO 44),
       dig_IO(119 DOWNTO 118)         => dig_io_nc(1 DOWNTO 0),
       dig_IO(127 DOWNTO 120)         => DIO(63 DOWNTO 56),
       dig_IO(151 DOWNTO 128)         => DIO(111 DOWNTO 88),
       dig_IO(167 DOWNTO 152)         => DIO(39 DOWNTO 24),
       dig_IO(175 DOWNTO 168)         => DIO(55 DOWNTO 48),
       dig_IO(176)                    => DIO(117),
       dig_IO(177)                    => DIO(119),
       dig_IO(191 DOWNTO 178)         => dig_io_nc(15 DOWNTO 2),
       
       ana_in_SDI                     => AI_AD_MISO,
       ana_in_CS5                     => ana_in_CS5,
       ana_in_Conv                    => ana_in_Conv,
       ana_in_Row                     => ana_in_Row,
       ana_in_SCK16                   => AI_AD_SCK,
       ana_in_SCK5                    => AI_AFE_SCK,
       ana_in_SDO                     => AI_AFE_MOSI,
       DA_CLR_B                       => DA_CLR_B,
       DA_CS_B                        => DA_CS_B,
       DA_LDAC_B                      => DA_LDAC_B,
       DA_SCK                         => DA_SCK,
       DA_SDI                         => DA_SDI,
       
       ctr_PMT                        => ctr_PMT
    );

    cmd_proc_i : cmd_proc
       GENERIC MAP (
          CMD_PROC_N_CMDS => CMD_PROC_N_CMDS
       )
       PORT MAP (
          cmd_dio => cmd_dio,
          cmd_out => cmd_out,
          CmdStrb => subbus_cmdstrb,
          CmdEnbl => subbus_cmdenbl,
          RST     => RST
       );

  AI_AD_CNV(0) <= ana_in_Conv;
  AI_AD_CNV(1) <= ana_in_Conv;
  AI_AFE_CS_B(0) <= ana_in_CS5;
  AI_AFE_CS_B(1) <= ana_in_CS5;
  AI_MUX0_A <= ana_in_Row(2 DOWNTO 0);
  AI_MUX1_A <= ana_in_Row(2 DOWNTO 0);
  DIO(112) <= ana_in_row(3);
  DIO(114) <= ana_in_row(4);
  DIO(116) <= ana_in_row(5);

  BIO(15 DOWNTO 4) <= (others => 'Z');

  DIO(9 DOWNTO 0) <= cmd_out(33 DOWNTO 24);
  DIO(10) <= not cmd_out(34);
  DIO(14) <= cmd_out(35);
  DIO(15) <= cmd_out(36);
  DIO(43) <= cmd_out(37);

  DIO(11) <= idx_Dir(0);
  DIO(12) <= idx_Run(0);
  DIO(13) <= idx_Step(0);
  idx_KillA(0) <= DIO(16);
  idx_KillB(0) <= DIO(17);
  idx_LimI(0) <= DIO(18);
  idx_LimO(0) <= DIO(19);
  idx_KillA(1) <= DIO(20);
  idx_KillB(1) <= DIO(21);
  idx_LimI(1) <= DIO(22);
  idx_LimO(1) <= DIO(23);
  DIO(40) <= idx_Dir(1);
  DIO(41) <= idx_Run(1);
  DIO(42) <= idx_Step(1);
    
  DIO(87 DOWNTO 64) <= cmd_out(23 DOWNTO 0);
  DIO(113) <= subbus_fail_leds(0);
  DIO(115) <= subbus_fail_leds(1);
  DIO(118) <= subbus_flt_cpu_reset;

  DIO_DIR(0) <= '0'; -- CmdProc output
  DIO_DIR(1) <= '0'; -- CmdProc output
  DIO_DIR(2) <= '1'; -- Indexer Input
  DIO_DIR(3) <= dig_dir(19);
  DIO_DIR(4) <= dig_dir(20);
  DIO_DIR(5) <= dig_dir(13);
  DIO_DIR(6) <= dig_dir(21);
  DIO_DIR(7) <= dig_dir(15);
  DIO_DIR(10 DOWNTO 8) <= "000"; -- Power board outputs
  DIO_DIR(11) <= dig_dir(16);
  DIO_DIR(12) <= dig_dir(17);
  DIO_DIR(13) <= dig_dir(18);
  DIO_DIR(14) <= dig_dir(22);
  
  DIO_OE <= '1';
  DIO_OE_B <= '0';
  DACS_switches(7 DOWNTO 4) <= GPIO_SW;
  DACS_switches(3) <= '1';
  DACS_switches(2 DOWNTO 0) <= not DIO(62 DOWNTO 60);
  FPGA_CMDENBL	<= subbus_cmdenbl;
  FPGA_CMDENBL_B	<= not subbus_cmdenbl;
  FPGA_CMDSTRB	<= subbus_cmdstrb;
  FPGA_CMDSTRB_B	<= not subbus_cmdstrb;
  GPIO_ERROR_LED	<= subbus_fail_leds(0);
  GPIO_LED(2 DOWNTO 0) <= subbus_fail_leds(3 DOWNTO 1);
  GPIO_LED(3) <= Collision;
  -- GPIO_LED <= subbus_fail_leds(4 DOWNTO 1);
END ARCHITECTURE beh;

