-- TestFAIL_5.vhdl
-- Redefinition of signal
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity PDACS_Carbon is
  port (
    FPGA_CMD_DIR : in STD_LOGIC := 'X'; 
    FPGA_CPU_RESET : in STD_LOGIC := 'X'; 
    FPGA_SYSCLK : in STD_LOGIC := 'X'; 
    FTDI_RXF : in STD_LOGIC := 'X'; 
    FTDI_TXE : in STD_LOGIC := 'X'; 
    USB_1_RX : in STD_LOGIC := 'X'; 
    COUNT_SDN : in STD_LOGIC := 'X'; 
    FPGA_CSO_B : in STD_LOGIC := 'X'; 
    FPGA_D0_DIN_MISO_MISO1 : in STD_LOGIC := 'X'; 
    FPGA_D1_MISO2 : in STD_LOGIC := 'X'; 
    FPGA_D2_MISO3 : in STD_LOGIC := 'X'; 
    FPGA_MOSI_CSI_B_MISO0 : in STD_LOGIC := 'X'; 
    FPGA_MSD_CS_B : in STD_LOGIC := 'X'; 
    FPGA_UFM_CS_B : in STD_LOGIC := 'X'; 
    FPGA_XCLK : in STD_LOGIC := 'X'; 
    FPGA_XTRIG : in STD_LOGIC := 'X'; 
    FTDI_PWREN_B : in STD_LOGIC := 'X'; 
    FTDI_SIWU : in STD_LOGIC := 'X'; 
    FTDI_SPR_AC1 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AC6 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AC7 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AD3 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AD5 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AD6 : in STD_LOGIC := 'X'; 
    FTDI_SPR_AD7 : in STD_LOGIC := 'X'; 
    FTDI_SPR_BC5 : in STD_LOGIC := 'X'; 
    FTDI_SPR_BC6 : in STD_LOGIC := 'X'; 
    FTDI_SPR_BC7 : in STD_LOGIC := 'X'; 
    FTDI_SUSPEND_B : in STD_LOGIC := 'X'; 
    FTDI_UPLOAD : in STD_LOGIC := 'X'; 
    MPS_PFO_B : in STD_LOGIC := 'X'; 
    MPS_RESET_B : in STD_LOGIC := 'X'; 
    MPS_WDI : in STD_LOGIC := 'X'; 
    PHY_COL : in STD_LOGIC := 'X'; 
    PHY_CRS : in STD_LOGIC := 'X'; 
    PHY_INT : in STD_LOGIC := 'X'; 
    PHY_MDC : in STD_LOGIC := 'X'; 
    PHY_MDIO : in STD_LOGIC := 'X'; 
    PHY_RESET : in STD_LOGIC := 'X'; 
    PHY_RXCTL_RXDV : in STD_LOGIC := 'X'; 
    PHY_RXC_RXCLK : in STD_LOGIC := 'X'; 
    PHY_RXD0 : in STD_LOGIC := 'X'; 
    PHY_RXD1 : in STD_LOGIC := 'X'; 
    PHY_RXD2 : in STD_LOGIC := 'X'; 
    PHY_RXD3 : in STD_LOGIC := 'X'; 
    PHY_RXER : in STD_LOGIC := 'X'; 
    PHY_TXCLK : in STD_LOGIC := 'X'; 
    PHY_TXCTL_TXEN : in STD_LOGIC := 'X'; 
    PHY_TXD0 : in STD_LOGIC := 'X'; 
    PHY_TXD1 : in STD_LOGIC := 'X'; 
    PHY_TXD2 : in STD_LOGIC := 'X'; 
    PHY_TXD3 : in STD_LOGIC := 'X'; 
    USB_1_CTS : in STD_LOGIC := 'X'; 
    USB_1_RTS : in STD_LOGIC := 'X'; 
    DA_CLR_B : out STD_LOGIC; 
    DA_LDAC_B : out STD_LOGIC; 
    DA_SCK : out STD_LOGIC; 
    DA_SDI : out STD_LOGIC; 
    DIO_OE : out STD_LOGIC; 
    DIO_OE_B : out STD_LOGIC; 
    FPGA_CMDENBL : out STD_LOGIC; 
    FPGA_CMDENBL_B : out STD_LOGIC; 
    FPGA_CMDSTRB : out STD_LOGIC; 
    FPGA_CMDSTRB_B : out STD_LOGIC; 
    FTDI_RD : out STD_LOGIC; 
    FTDI_SI : out STD_LOGIC; 
    FTDI_WR : out STD_LOGIC; 
    GPIO_ERROR_LED : out STD_LOGIC; 
    IIC_SCL : inout STD_LOGIC; 
    IIC_SDA : inout STD_LOGIC; 
    USB_1_TX : out STD_LOGIC; 
    AI_AD_MISO : in STD_LOGIC_VECTOR ( 1 downto 0 ); 
    GPIO_SW : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    COUNT : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    COUNT_LE : in STD_LOGIC_VECTOR ( 7 downto 0 ); 
    GPIO_HDR : in STD_LOGIC_VECTOR ( 15 downto 0 ); 
    DIO : inout STD_LOGIC_VECTOR ( 119 downto 0 ); 
    AI_AD_CNV : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    AI_AD_SCK : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    AI_AFE_CS_B : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    AI_AFE_MOSI : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    AI_AFE_SCK : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    AI_MUX0_A : out STD_LOGIC_VECTOR ( 2 downto 0 ); 
    AI_MUX1_A : out STD_LOGIC_VECTOR ( 2 downto 0 ); 
    DA_CS_B : out STD_LOGIC_VECTOR ( 1 downto 0 ); 
    BIO : inout STD_LOGIC_VECTOR ( 15 downto 0 ); 
    DIO_DIR : out STD_LOGIC_VECTOR ( 14 downto 0 ); 
    GPIO_LED : out STD_LOGIC_VECTOR ( 3 downto 0 ); 
    FTDI_D : inout STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end PDACS_Carbon;

architecture STRUCTURE of PDACS_Carbon is
  component Processor
    port (
      fpga_0_clk_1_sys_clk_pin : in STD_LOGIC := 'X'; 
      fpga_0_rst_1_sys_rst_pin : in STD_LOGIC := 'X'; 
      xps_epc_0_PRH_Rdy_pin : in STD_LOGIC := 'X'; 
      FTDI_RX_RDY_pin : in STD_LOGIC := 'X'; 
      clk_8_0000MHz_pin : out STD_LOGIC; 
      xps_epc_0_PRH_Wr_n_pin : out STD_LOGIC; 
      xps_epc_0_PRH_Rd_n_pin : out STD_LOGIC; 
      FTDI_SI_pin : out STD_LOGIC; 
      clk_66_6667MHz_pin : out STD_LOGIC; 
      xps_gpio_subbus_data_i_pin : in STD_LOGIC_VECTOR ( 15 downto 0 ); 
      xps_gpio_subbus_status_pin : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
      xps_gpio_subbus_switches_pin : in STD_LOGIC_VECTOR ( 0 to 7 ); 
      xps_gpio_subbus_leds_readback_pin : in STD_LOGIC_VECTOR ( 4 downto 0 ); 
      xps_epc_0_PRH_Data_pin : inout STD_LOGIC_VECTOR ( 7 downto 0 ); 
      xps_gpio_subbus_addr_pin : out STD_LOGIC_VECTOR ( 15 downto 0 ); 
      xps_gpio_subbus_ctrl_pin : out STD_LOGIC_VECTOR ( 6 downto 0 ); 
      xps_gpio_subbus_data_o_pin : out STD_LOGIC_VECTOR ( 15 downto 0 ); 
      xps_gpio_subbus_leds_pin : out STD_LOGIC_VECTOR ( 4 downto 0 ) 
    );
  end component;
  signal FPGA_SYSCLK_IBUF_9 : STD_LOGIC;
  signal FPGA_SYSCLK_IBUF_9 : STD_LOGIC;
  signal FPGA_CPU_RESET_IBUF_8 : STD_LOGIC;
  signal dacs_i_not_FTDI_TXE_pin : STD_LOGIC;
  signal dacs_i_not_FTDI_RXF_pin : STD_LOGIC;
  signal dacs_i_clk_8_0000MHz : STD_LOGIC;
  signal dacs_i_xps_epc_0_PRH_Wr_n_pin : STD_LOGIC;
  signal FTDI_RD_OBUF_45 : STD_LOGIC;
  signal FTDI_SI_OBUF_47 : STD_LOGIC;
  signal dacs_i_clk_66_6667MHz : STD_LOGIC;
  signal dacs_i_Inst_syscon_DataIn : STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal dacs_i_Inst_syscon_Tick_TwoSecTO_746 : STD_LOGIC;
  signal dacs_i_Inst_syscon_Status : STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal dacs_i_Inst_syscon_Done_int_743 : STD_LOGIC;
  signal GPIO_SW_3_IBUF_2 : STD_LOGIC;
  signal GPIO_SW_2_IBUF_3 : STD_LOGIC;
  signal GPIO_SW_1_IBUF_4 : STD_LOGIC;
  signal GPIO_SW_0_IBUF_5 : STD_LOGIC;
  signal DIO_OE_OBUF_12 : STD_LOGIC;
  signal DACS_switches : STD_LOGIC_VECTOR(2 DOWNTO 0);
  signal dacs_i_Fail_outputs : STD_LOGIC_VECTOR(4 DOWNTO 0);
  signal GPIO_ERROR_LED_OBUF_22 : STD_LOGIC;
  signal dacs_i_subbus_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
  signal DIO_115_OBUF_21 : STD_LOGIC;
  signal GPIO_LED_1_OBUF_24 : STD_LOGIC;
  signal dacs_i_subbus_ctrl_4_Q : STD_LOGIC;
  signal GPIO_LED_2_OBUF_23 : STD_LOGIC;
  signal dacs_i_subbus_ctrl_2_Q : STD_LOGIC;
  signal dacs_i_subbus_ctrl_1_Q : STD_LOGIC;
  signal dacs_i_subbus_ctrl_0_Q : STD_LOGIC;
  signal dacs_i_subbus_data_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
  dacs_i_Inst_Processor : Processor
    port map (
      fpga_0_clk_1_sys_clk_pin => FPGA_SYSCLK_IBUF_9,
      fpga_0_rst_1_sys_rst_pin => FPGA_CPU_RESET_IBUF_8,
      xps_epc_0_PRH_Rdy_pin => dacs_i_not_FTDI_TXE_pin,
      FTDI_RX_RDY_pin => dacs_i_not_FTDI_RXF_pin,
      clk_8_0000MHz_pin => dacs_i_clk_8_0000MHz,
      xps_epc_0_PRH_Wr_n_pin => dacs_i_xps_epc_0_PRH_Wr_n_pin,
      xps_epc_0_PRH_Rd_n_pin => FTDI_RD_OBUF_45,
      FTDI_SI_pin => FTDI_SI_OBUF_47,
      clk_66_6667MHz_pin => dacs_i_clk_66_6667MHz,
      xps_gpio_subbus_data_i_pin(15) => dacs_i_Inst_syscon_DataIn(15),
      xps_gpio_subbus_data_i_pin(14) => dacs_i_Inst_syscon_DataIn(14),
      xps_gpio_subbus_data_i_pin(13) => dacs_i_Inst_syscon_DataIn(13),
      xps_gpio_subbus_data_i_pin(12) => dacs_i_Inst_syscon_DataIn(12),
      xps_gpio_subbus_data_i_pin(11) => dacs_i_Inst_syscon_DataIn(11),
      xps_gpio_subbus_data_i_pin(10) => dacs_i_Inst_syscon_DataIn(10),
      xps_gpio_subbus_data_i_pin(9) => dacs_i_Inst_syscon_DataIn(9),
      xps_gpio_subbus_data_i_pin(8) => dacs_i_Inst_syscon_DataIn(8),
      xps_gpio_subbus_data_i_pin(7) => dacs_i_Inst_syscon_DataIn(7),
      xps_gpio_subbus_data_i_pin(6) => dacs_i_Inst_syscon_DataIn(6),
      xps_gpio_subbus_data_i_pin(5) => dacs_i_Inst_syscon_DataIn(5),
      xps_gpio_subbus_data_i_pin(4) => dacs_i_Inst_syscon_DataIn(4),
      xps_gpio_subbus_data_i_pin(3) => dacs_i_Inst_syscon_DataIn(3),
      xps_gpio_subbus_data_i_pin(2) => dacs_i_Inst_syscon_DataIn(2),
      xps_gpio_subbus_data_i_pin(1) => dacs_i_Inst_syscon_DataIn(1),
      xps_gpio_subbus_data_i_pin(0) => dacs_i_Inst_syscon_DataIn(0),
      xps_gpio_subbus_status_pin(3) => dacs_i_Inst_syscon_Tick_TwoSecTO_746,
      xps_gpio_subbus_status_pin(2) => dacs_i_Inst_syscon_Status(2),
      xps_gpio_subbus_status_pin(1) => dacs_i_Inst_syscon_Status(1),
      xps_gpio_subbus_status_pin(0) => dacs_i_Inst_syscon_Done_int_743,
      xps_gpio_subbus_switches_pin(0) => GPIO_SW_3_IBUF_2,
      xps_gpio_subbus_switches_pin(1) => GPIO_SW_2_IBUF_3,
      xps_gpio_subbus_switches_pin(2) => GPIO_SW_1_IBUF_4,
      xps_gpio_subbus_switches_pin(3) => GPIO_SW_0_IBUF_5,
      xps_gpio_subbus_switches_pin(4) => DIO_OE_OBUF_12,
      xps_gpio_subbus_switches_pin(5) => DACS_switches(2),
      xps_gpio_subbus_switches_pin(6) => DACS_switches(1),
      xps_gpio_subbus_switches_pin(7) => DACS_switches(0),
      xps_gpio_subbus_leds_readback_pin(4) => dacs_i_Fail_outputs(4),
      xps_gpio_subbus_leds_readback_pin(3) => dacs_i_Fail_outputs(3),
      xps_gpio_subbus_leds_readback_pin(2) => dacs_i_Fail_outputs(2),
      xps_gpio_subbus_leds_readback_pin(1) => dacs_i_Fail_outputs(1),
      xps_gpio_subbus_leds_readback_pin(0) => GPIO_ERROR_LED_OBUF_22,
      xps_epc_0_PRH_Data_pin(7) => FTDI_D(7),
      xps_epc_0_PRH_Data_pin(6) => FTDI_D(6),
      xps_epc_0_PRH_Data_pin(5) => FTDI_D(5),
      xps_epc_0_PRH_Data_pin(4) => FTDI_D(4),
      xps_epc_0_PRH_Data_pin(3) => FTDI_D(3),
      xps_epc_0_PRH_Data_pin(2) => FTDI_D(2),
      xps_epc_0_PRH_Data_pin(1) => FTDI_D(1),
      xps_epc_0_PRH_Data_pin(0) => FTDI_D(0),
      xps_gpio_subbus_addr_pin(15) => dacs_i_subbus_addr(15),
      xps_gpio_subbus_addr_pin(14) => dacs_i_subbus_addr(14),
      xps_gpio_subbus_addr_pin(13) => dacs_i_subbus_addr(13),
      xps_gpio_subbus_addr_pin(12) => dacs_i_subbus_addr(12),
      xps_gpio_subbus_addr_pin(11) => dacs_i_subbus_addr(11),
      xps_gpio_subbus_addr_pin(10) => dacs_i_subbus_addr(10),
      xps_gpio_subbus_addr_pin(9) => dacs_i_subbus_addr(9),
      xps_gpio_subbus_addr_pin(8) => dacs_i_subbus_addr(8),
      xps_gpio_subbus_addr_pin(7) => dacs_i_subbus_addr(7),
      xps_gpio_subbus_addr_pin(6) => dacs_i_subbus_addr(6),
      xps_gpio_subbus_addr_pin(5) => dacs_i_subbus_addr(5),
      xps_gpio_subbus_addr_pin(4) => dacs_i_subbus_addr(4),
      xps_gpio_subbus_addr_pin(3) => dacs_i_subbus_addr(3),
      xps_gpio_subbus_addr_pin(2) => dacs_i_subbus_addr(2),
      xps_gpio_subbus_addr_pin(1) => dacs_i_subbus_addr(1),
      xps_gpio_subbus_addr_pin(0) => dacs_i_subbus_addr(0),
      xps_gpio_subbus_ctrl_pin(6) => DIO_115_OBUF_21,
      xps_gpio_subbus_ctrl_pin(5) => GPIO_LED_1_OBUF_24,
      xps_gpio_subbus_ctrl_pin(4) => dacs_i_subbus_ctrl_4_Q,
      xps_gpio_subbus_ctrl_pin(3) => GPIO_LED_2_OBUF_23,
      xps_gpio_subbus_ctrl_pin(2) => dacs_i_subbus_ctrl_2_Q,
      xps_gpio_subbus_ctrl_pin(1) => dacs_i_subbus_ctrl_1_Q,
      xps_gpio_subbus_ctrl_pin(0) => dacs_i_subbus_ctrl_0_Q,
      xps_gpio_subbus_data_o_pin(15) => dacs_i_subbus_data_o(15),
      xps_gpio_subbus_data_o_pin(14) => dacs_i_subbus_data_o(14),
      xps_gpio_subbus_data_o_pin(13) => dacs_i_subbus_data_o(13),
      xps_gpio_subbus_data_o_pin(12) => dacs_i_subbus_data_o(12),
      xps_gpio_subbus_data_o_pin(11) => dacs_i_subbus_data_o(11),
      xps_gpio_subbus_data_o_pin(10) => dacs_i_subbus_data_o(10),
      xps_gpio_subbus_data_o_pin(9) => dacs_i_subbus_data_o(9),
      xps_gpio_subbus_data_o_pin(8) => dacs_i_subbus_data_o(8),
      xps_gpio_subbus_data_o_pin(7) => dacs_i_subbus_data_o(7),
      xps_gpio_subbus_data_o_pin(6) => dacs_i_subbus_data_o(6),
      xps_gpio_subbus_data_o_pin(5) => dacs_i_subbus_data_o(5),
      xps_gpio_subbus_data_o_pin(4) => dacs_i_subbus_data_o(4),
      xps_gpio_subbus_data_o_pin(3) => dacs_i_subbus_data_o(3),
      xps_gpio_subbus_data_o_pin(2) => dacs_i_subbus_data_o(2),
      xps_gpio_subbus_data_o_pin(1) => dacs_i_subbus_data_o(1),
      xps_gpio_subbus_data_o_pin(0) => dacs_i_subbus_data_o(0),
      xps_gpio_subbus_leds_pin(4) => dacs_i_Fail_outputs(4),
      xps_gpio_subbus_leds_pin(3) => dacs_i_Fail_outputs(3),
      xps_gpio_subbus_leds_pin(2) => dacs_i_Fail_outputs(2),
      xps_gpio_subbus_leds_pin(1) => dacs_i_Fail_outputs(1),
      xps_gpio_subbus_leds_pin(0) => dacs_i_Fail_outputs(0)
    );

end STRUCTURE;

-- synthesis translate_on
