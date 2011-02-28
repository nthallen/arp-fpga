--
-- VHDL Test Bench idx_fpga_lib.bench_dacs_ctrs.dacs_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:45:05 02/27/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_dacs_ctrs IS
   GENERIC (
      N_INTERRUPTS        : integer range 15 downto 1      := 1;
      CTR_UG_N_BDS        : integer range 5 downto 0       := 3;
      IDX_N_CHANNELS      : integer range 15 downto 1      := 1;
      IDX_BASE_ADDR       : std_logic_vector(15 downto 0)  := X"0A00";
      DIGIO_BASE_ADDRESS  : std_logic_vector (15 DOWNTO 0) := X"0800";
      DIGIO_N_CONNECTORS  : integer range 4 DOWNTO 1       := 4;
      DIGIO_FORCE_DIR     : std_ulogic_vector              := "111111111111000111110111";
      DIGIO_FORCE_DIR_VAL : std_ulogic_vector              := "000000001111000111100110"
   );
END bench_dacs_ctrs;

LIBRARY idx_fpga_lib;


ARCHITECTURE rtl OF bench_dacs_ctrs IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL fpga_0_rst_1_sys_rst_pin       : std_logic;
   SIGNAL fpga_0_clk_1_sys_clk_pin       : std_logic;
   SIGNAL xps_epc_0_PRH_Data_pin         : std_logic_vector(7 downto 0);
   SIGNAL FTDI_RD_pin                    : std_logic;
   SIGNAL FTDI_WR_pin                    : std_logic;
   SIGNAL FTDI_RXF_pin                   : std_logic;
   SIGNAL FTDI_TXE_pin                   : std_logic;
   SIGNAL FTDI_SI_pin                    : std_logic;
   SIGNAL fpga_0_RS232_RX_pin            : std_logic;
   SIGNAL fpga_0_RS232_TX_pin            : std_logic;
   SIGNAL fpga_0_Generic_IIC_Bus_Sda_pin : std_logic;
   SIGNAL fpga_0_Generic_IIC_Bus_Scl_pin : std_logic;
   SIGNAL subbus_cmdenbl                 : std_ulogic;
   SIGNAL subbus_cmdstrb                 : std_ulogic;
   SIGNAL subbus_fail_leds               : std_logic_vector(4 downto 0);
   SIGNAL subbus_flt_cpu_reset           : std_ulogic;
   SIGNAL subbus_reset                   : std_ulogic;
   SIGNAL DACS_switches                  : std_logic_vector(3 downto 0);
   SIGNAL idx_Run                        : std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
   SIGNAL idx_Step                       : std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
   SIGNAL idx_Dir                        : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_KillA                      : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_KillB                      : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_LimI                       : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_LimO                       : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL idx_ZR                         : std_ulogic_vector(IDX_N_CHANNELS-1 DOWNTO 0);
   SIGNAL dig_IO                         : std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
   SIGNAL dig_Dir                        : std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);
   SIGNAL ana_in_SDI                     : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL ana_in_CS5                     : std_ulogic;
   SIGNAL ana_in_Conv                    : std_ulogic;
   SIGNAL ana_in_Row                     : std_ulogic_vector(5 DOWNTO 0);
   SIGNAL ana_in_SCK16                   : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL ana_in_SCK5                    : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL ana_in_SDO                     : std_ulogic_vector(1 DOWNTO 0);
   SIGNAL ana_in_AIEn                    : std_ulogic;
   SIGNAL ctr_PMT                        : std_logic_vector(4*CTR_UG_N_BDS-1 DOWNTO 0);
   SIGNAL DA_CLR_B                       : std_logic;
   SIGNAL DA_CS_B                        : std_logic_vector(1 DOWNTO 0);
   SIGNAL DA_LDAC_B                      : std_logic;
   SIGNAL DA_SCK                         : std_logic;
   SIGNAL DA_SDI                         : std_logic;
   SIGNAL Collision                      : std_ulogic;


   -- Component declarations
   COMPONENT dacs
      GENERIC (
         N_INTERRUPTS        : integer range 15 downto 1      := 1;
         CTR_UG_N_BDS        : integer range 5 downto 0       := 3;
         IDX_N_CHANNELS      : integer range 15 downto 1      := 3;
         IDX_BASE_ADDR       : std_logic_vector(15 downto 0)  := X"0A00";
         DIGIO_BASE_ADDRESS  : std_logic_vector (15 DOWNTO 0) := X"0800";
         DIGIO_N_CONNECTORS  : integer range 4 DOWNTO 1       := 2;
         DIGIO_FORCE_DIR     : std_ulogic_vector              := "000000000000";
         DIGIO_FORCE_DIR_VAL : std_ulogic_vector              := "000000000000"
      );
      PORT (
         fpga_0_rst_1_sys_rst_pin       : IN     std_logic;
         fpga_0_clk_1_sys_clk_pin       : IN     std_logic;
         xps_epc_0_PRH_Data_pin         : INOUT  std_logic_vector(7 downto 0);
         FTDI_RD_pin                    : OUT    std_logic;
         FTDI_WR_pin                    : OUT    std_logic;
         FTDI_RXF_pin                   : IN     std_logic;
         FTDI_TXE_pin                   : IN     std_logic;
         FTDI_SI_pin                    : OUT    std_logic;
         fpga_0_RS232_RX_pin            : IN     std_logic;
         fpga_0_RS232_TX_pin            : OUT    std_logic;
         fpga_0_Generic_IIC_Bus_Sda_pin : INOUT  std_logic;
         fpga_0_Generic_IIC_Bus_Scl_pin : INOUT  std_logic;
         subbus_cmdenbl                 : OUT    std_ulogic;
         subbus_cmdstrb                 : OUT    std_ulogic;
         subbus_fail_leds               : OUT    std_logic_vector(4 downto 0);
         subbus_flt_cpu_reset           : OUT    std_ulogic;
         subbus_reset                   : OUT    std_ulogic;
         Collision                      : OUT    std_ulogic;
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
         ana_in_Row                     : OUT    std_ulogic_vector(5 DOWNTO 0);
         ana_in_SCK16                   : OUT    std_ulogic_vector(1 DOWNTO 0);
         ana_in_SCK5                    : OUT    std_ulogic_vector(1 DOWNTO 0);
         ana_in_SDO                     : OUT    std_ulogic_vector(1 DOWNTO 0);
         ana_in_AIEn                    : IN     std_ulogic;
         ctr_PMT                        : IN     std_logic_vector(4*CTR_UG_N_BDS-1 DOWNTO 0);
         DA_CLR_B                       : OUT    std_logic;
         DA_CS_B                        : OUT    std_logic_vector(1 DOWNTO 0);
         DA_LDAC_B                      : OUT    std_logic;
         DA_SCK                         : OUT    std_logic;
         DA_SDI                         : OUT    std_logic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_dacs : dacs USE ENTITY idx_fpga_lib.dacs;
   -- pragma synthesis_on

BEGIN

         DUT_dacs : dacs
            GENERIC MAP (
               N_INTERRUPTS        => N_INTERRUPTS,
               CTR_UG_N_BDS        => CTR_UG_N_BDS,
               IDX_N_CHANNELS      => IDX_N_CHANNELS,
               IDX_BASE_ADDR       => IDX_BASE_ADDR,
               DIGIO_BASE_ADDRESS  => DIGIO_BASE_ADDRESS,
               DIGIO_N_CONNECTORS  => DIGIO_N_CONNECTORS,
               DIGIO_FORCE_DIR     => DIGIO_FORCE_DIR,
               DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL
            )
            PORT MAP (
               fpga_0_rst_1_sys_rst_pin       => fpga_0_rst_1_sys_rst_pin,
               fpga_0_clk_1_sys_clk_pin       => fpga_0_clk_1_sys_clk_pin,
               xps_epc_0_PRH_Data_pin         => xps_epc_0_PRH_Data_pin,
               FTDI_RD_pin                    => FTDI_RD_pin,
               FTDI_WR_pin                    => FTDI_WR_pin,
               FTDI_RXF_pin                   => FTDI_RXF_pin,
               FTDI_TXE_pin                   => FTDI_TXE_pin,
               FTDI_SI_pin                    => FTDI_SI_pin,
               fpga_0_RS232_RX_pin            => fpga_0_RS232_RX_pin,
               fpga_0_RS232_TX_pin            => fpga_0_RS232_TX_pin,
               fpga_0_Generic_IIC_Bus_Sda_pin => fpga_0_Generic_IIC_Bus_Sda_pin,
               fpga_0_Generic_IIC_Bus_Scl_pin => fpga_0_Generic_IIC_Bus_Scl_pin,
               subbus_cmdenbl                 => subbus_cmdenbl,
               subbus_cmdstrb                 => subbus_cmdstrb,
               subbus_fail_leds               => subbus_fail_leds,
               subbus_flt_cpu_reset           => subbus_flt_cpu_reset,
               subbus_reset                   => subbus_reset,
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
               dig_IO                         => dig_IO,
               dig_Dir                        => dig_Dir,
               ana_in_SDI                     => ana_in_SDI,
               ana_in_CS5                     => ana_in_CS5,
               ana_in_Conv                    => ana_in_Conv,
               ana_in_Row                     => ana_in_Row,
               ana_in_SCK16                   => ana_in_SCK16,
               ana_in_SCK5                    => ana_in_SCK5,
               ana_in_SDO                     => ana_in_SDO,
               ana_in_AIEn                    => ana_in_AIEn,
               ctr_PMT                        => ctr_PMT,
               DA_CLR_B                       => DA_CLR_B,
               DA_CS_B                        => DA_CS_B,
               DA_LDAC_B                      => DA_LDAC_B,
               DA_SCK                         => DA_SCK,
               DA_SDI                         => DA_SDI
            );

  ctr_PMT <= (others => '0');

END rtl;
