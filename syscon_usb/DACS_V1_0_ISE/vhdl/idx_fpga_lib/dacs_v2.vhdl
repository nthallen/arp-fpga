----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:37:51 05/27/2010 
-- Design Name: 
-- Module Name:    dacs - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision:
-- Build 44: Add ES96 Temperature Sensor Interface
-- Build 43: ana_acquire even longer settling time
-- Build 42: Add long settling time for 1M therms
-- Build 41: Add ES96 ADC interface
-- Build 35: Reduce AO to 8 MHz
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
library idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;

entity dacs_v2 is
    GENERIC (
      DACS_BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"002C"; -- 44
      INSTRUMENT_ID : std_logic_vector(15 DOWNTO 0) := X"0001";
      N_INTERRUPTS : integer range 15 downto 1 := 1;
      
      N_PTRH      : integer range 16 downto 1 := 8;
      N_ISBITS    : integer range 8 downto 1 := 4;
      ESID        : ESID_array := ( 3, 2, 1, 0, 0, 0, 0, 0 );
      ESwitchBit  : ESB_array  := ( 0, 0, 0, 4, 3, 2, 1, 0 );
      ISwitchBit  : ISB_array  := ( 3, 2, 1, 0 );
      ESwitchAddr : ESA_array  := ( "0000000", "0000000", "0000000", "1110000" );
      
      N_AO_CHIPS : natural range 15 downto 1 := 2;
      CTR_UG_N_BDS : integer range 5 downto 0 := 2;
      IDX_N_CHANNELS : integer range 15 downto 1 := 3;
      IDX_BASE_ADDR : std_logic_vector(15 downto 0) := X"0A00";
      DIGIO_BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
      DIGIO_N_CONNECTORS : integer range 8 DOWNTO 1 := 2;
      DIGIO_FORCE_DIR : std_ulogic_vector := "000000000000";
      DIGIO_FORCE_DIR_VAL : std_ulogic_vector := "000000000000";
      N_QCLICTRL : integer range 5 downto 0 := 1;
      N_VM : integer range 5 downto 0 := 1;
      N_LK204 : integer range 1 downto 0 := 0;
      N_ADC : integer range 4 downto 0 := 0;
      ADC_NBITSHIFT : integer range 31 downto 0 := 1;
      ADC_RATE_DEF : std_logic_vector(4 DOWNTO 0) := "11111";
      N_TEMP_SENSOR : integer range 1 downto 0 := 0
    );
    Port (
      fpga_0_rst_1_sys_rst_pin : IN std_logic;
      fpga_0_clk_1_sys_clk_pin : IN std_logic;
      
      xps_epc_0_PRH_Data_pin : INOUT std_logic_vector(7 downto 0);
      FTDI_RD_pin : OUT std_logic;
      FTDI_WR_pin : OUT std_logic;
      FTDI_RXF_pin : IN std_logic;
      FTDI_TXE_pin : IN std_logic;
      FTDI_SI_pin : OUT std_logic;
      
      fpga_0_RS232_RX_pin : IN std_logic;
      fpga_0_RS232_TX_pin : OUT std_logic;
      PTRH_SDA_pin : INOUT std_logic_vector(N_ISBITS-1 DOWNTO 0);
      PTRH_SCK_pin : INOUT std_logic_vector(N_ISBITS-1 DOWNTO 0);
      VM_SDA_pin : INOUT std_logic_vector(N_VM-1 DOWNTO 0);
      VM_SCL_pin : INOUT std_logic_vector(N_VM-1 DOWNTO 0);
      LK204_SDA_pin : INOUT std_logic_vector(N_LK204-1 DOWNTO 0);
      LK204_SCL_pin : INOUT std_logic_vector(N_LK204-1 DOWNTO 0);
      
      subbus_cmdenbl : OUT std_ulogic;
      subbus_cmdstrb : OUT std_ulogic;
      subbus_fail_leds : OUT std_logic_vector(4 downto 0);
      subbus_flt_cpu_reset : OUT std_ulogic;
      subbus_reset : OUT std_ulogic;
      DACS_switches : IN std_logic_vector(7 downto 0);
      Collision : OUT std_ulogic;

      idx_Run : OUT std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
      idx_Step : OUT std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
      idx_Dir : OUT std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_KillA : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_KillB : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_LimI : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_LimO : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_ZR : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      
      dig_IO : INOUT std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
      dig_Dir : OUT std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);
      
      ana_in_SDI : IN std_ulogic_vector(1 DOWNTO 0); -- From A/D Converter
      ana_in_CS5 : OUT std_ulogic; -- To LMP7312
      ana_in_Conv : OUT std_ulogic; -- To A/D Converter
      ana_in_Row : OUT std_ulogic_vector(5 DOWNTO 0);
      ana_in_SCK16 : OUT std_ulogic_vector(1 DOWNTO 0);
      ana_in_SCK5 : OUT std_ulogic_vector(1 DOWNTO 0);
      ana_in_SDO  : OUT std_ulogic_vector(1 DOWNTO 0);
      
      ctr_PMT     : IN std_logic_vector(4*CTR_UG_N_BDS-1 DOWNTO 0);
      
      DA_CLR_B    : OUT std_logic;
      DA_CS_B     : OUT std_logic_vector(N_AO_CHIPS-1 DOWNTO 0);
      DA_LDAC_B   : OUT std_logic;
      DA_SCK      : OUT std_logic;
      DA_SDI      : OUT std_logic;

      QSync       : OUT    std_ulogic_vector(N_QCLICTRL-1 DOWNTO 0);
      QSClk       : INOUT  std_logic_vector(N_QCLICTRL-1 DOWNTO 0);
      QSData      : INOUT  std_logic_vector(N_QCLICTRL-1 DOWNTO 0);
      QNBsy       : IN     std_logic_vector(N_QCLICTRL-1 DOWNTO 0);
      
      ADC_MISO    : IN     std_logic_vector(N_ADC-1 DOWNTO 0);
      ADC_MOSI    : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
      ADC_CS_B    : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
      ADC_SCLK    : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
      
      TS_SDA      : INOUT std_logic_vector(N_TEMP_SENSOR-1 DOWNTO 0);
      TS_SCL      : INOUT std_logic_vector(N_TEMP_SENSOR-1 DOWNTO 0)
    );
end dacs_v2;

architecture Behavioral of dacs_v2 is
	COMPONENT Processor
	PORT(
		fpga_0_clk_1_sys_clk_pin : IN std_logic;
		fpga_0_rst_1_sys_rst_pin : IN std_logic;
		clk_8_0000MHz_pin : OUT std_logic;
    clk_66_6667MHz_pin : OUT std_logic;

		xps_epc_0_PRH_Rdy_pin : IN std_logic;
		xps_epc_0_PRH_Data_pin : INOUT std_logic_vector(7 downto 0);      
		xps_epc_0_PRH_Wr_n_pin : OUT std_logic;
		xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
		FTDI_SI_pin : OUT std_logic;
		FTDI_RX_RDY_pin : IN std_logic;    

		xps_gpio_subbus_data_i_pin : IN std_logic_vector(15 downto 0);
		xps_gpio_subbus_status_pin : IN std_logic_vector(3 downto 0);
		xps_gpio_subbus_switches_pin : IN std_logic_vector(7 downto 0);
		xps_gpio_subbus_leds_readback_pin : IN std_logic_vector(4 downto 0);
		xps_gpio_subbus_addr_pin : OUT std_logic_vector(15 downto 0);
		xps_gpio_subbus_ctrl_pin : OUT std_logic_vector(6 downto 0);
		xps_gpio_subbus_data_o_pin : OUT std_logic_vector(15 downto 0);
		xps_gpio_subbus_leds_pin : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT syscon
    GENERIC(
      DACS_BUILD_NUMBER : std_logic_vector(15 DOWNTO 0) := X"0007";
      INSTRUMENT_ID : std_logic_vector(15 DOWNTO 0) := X"0001";
      N_INTERRUPTS : integer range 15 downto 0 := 1;
      N_BOARDS : integer range 15 downto 0 := 1
    );
   	PORT(
    		F8M : IN std_logic;
    		Addr : IN std_logic_vector(15 downto 0);    
    		Data_i : OUT std_logic_vector(15 downto 0);
    		Data_o : IN std_logic_vector(15 downto 0);
    		Ctrl : IN std_logic_vector(6 downto 0);
    		Status : OUT std_logic_vector(3 downto 0);
    		ExpRd : OUT std_logic;
    		ExpWr : OUT std_logic;
      WData : OUT std_logic_vector (15 DOWNTO 0);
      RData : IN std_logic_vector (16*N_BOARDS-1 DOWNTO 0);
      ExpAddr : OUT std_logic_vector(15 downto 0);
      ExpAck : IN std_logic_vector (N_BOARDS-1 DOWNTO 0);
      BdIntr : IN std_ulogic_vector(N_INTERRUPTS-1 downto 0);
      INTA    : OUT std_ulogic;
      Collision : OUT std_ulogic;
      CmdEnbl : OUT std_ulogic;
      CmdStrb : OUT std_ulogic;
      ExpReset : OUT std_ulogic;
      Fail_In : IN std_ulogic;
      Fail_Out : OUT std_ulogic;
      Flt_CPU_Reset : OUT std_ulogic
		);
	END COMPONENT;
	
  COMPONENT gxidx
    GENERIC( 
      N_CHANNELS : integer range 15 downto 1 := 2;
      BASE_ADDR : std_logic_vector (15 DOWNTO 0) := X"0A00"
    );
		PORT( 
			rst         : IN     std_ulogic;
			Addr        : IN     std_logic_vector (15 DOWNTO 0);
			CMDENBL     : IN     std_ulogic;
			ExpRd       : IN     std_ulogic;
			ExpWr       : IN     std_ulogic;
      INTA        : IN     std_ulogic;
			F8M         : IN     std_ulogic;
			KillA       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			KillB       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			LimI        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			LimO        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			ZR          : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			ExpAck      : OUT    std_logic;
      BdIntr      : OUT    std_ulogic;
			Dir         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			Run         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			Step        : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			WData       : IN     std_logic_vector (15 DOWNTO 0);
      RData       : OUT    std_logic_vector (15 DOWNTO 0)
		);
	END COMPONENT;

  COMPONENT DigIO
     GENERIC (
       DIGIO_BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
       DIGIO_N_CONNECTORS : integer range 8 DOWNTO 1 := 2;
       DIGIO_FORCE_DIR : std_ulogic_vector := "000000000000";
       DIGIO_FORCE_DIR_VAL : std_ulogic_vector := "000000000000"
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        WData  : IN     std_logic_vector(15 DOWNTO 0);
        RData  : OUT    std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        ExpAck : OUT    std_ulogic;
        F8M    : IN     std_ulogic;
        rst    : IN     std_ulogic;
        IO     : INOUT  std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
        Dir    : OUT    std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0)
     );
  END COMPONENT;
  FOR ALL : DigIO USE ENTITY idx_fpga_lib.DigIO;
  
  COMPONENT ana_input
    PORT (
      Addr   : IN     std_logic_vector(15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      SDI    : IN     std_ulogic_vector(1 DOWNTO 0);
      RST    : IN     std_ulogic;
      CS5    : OUT    std_ulogic;
      Conv   : OUT    std_ulogic;
      ExpAck : OUT    std_ulogic;
      Row    : OUT    std_ulogic_vector(5 DOWNTO 0);
      SCK16  : OUT    std_ulogic_vector(1 DOWNTO 0);
      SCK5   : OUT    std_ulogic_vector(1 DOWNTO 0);
      SDO    : OUT    std_ulogic_vector(1 DOWNTO 0);
      WData  : IN     std_logic_vector(15 DOWNTO 0);
      RData  : OUT    std_logic_vector(15 DOWNTO 0)
   );
  END COMPONENT;
  FOR ALL : ana_input USE ENTITY idx_fpga_lib.ana_input;

  COMPONENT ctr_ungated
     GENERIC (
        BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
        N_COUNTERS   : integer range 4 DOWNTO 4       := 4;
        N_BITS       : integer range 32 DOWNTO 16     := 20
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        WData  : IN     std_logic_vector(15 DOWNTO 0);
        RData  : OUT    std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        ExpAck : OUT    std_ulogic;
        F8M    : IN     std_ulogic;
        rst    : IN     std_ulogic;
        PMT    : IN     std_logic_vector(N_COUNTERS-1 DOWNTO 0)
     );
  END COMPONENT;

  COMPONENT ao
     GENERIC( 
        N_AO_CHIPS : natural range 15 downto 1 := 2
     );
     PORT (
        Addr      : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd     : IN     std_ulogic;
        ExpWr     : IN     std_ulogic;
        F8M       : IN     std_ulogic;
        rst       : IN     std_ulogic;
        DA_CLR_B  : OUT    std_logic;
        DA_CS_B   : OUT    std_logic_vector(N_AO_CHIPS-1 DOWNTO 0);
        DA_LDAC_B : OUT    std_logic;
        DA_SCK    : OUT    std_logic;
        DA_SDI    : OUT    std_logic;
        ExpAck    : OUT    std_ulogic;
        WData     : IN     std_logic_vector(15 DOWNTO 0);
        RData     : OUT    std_logic_vector(15 DOWNTO 0)
     );
  END COMPONENT;
  
  COMPONENT vm
     GENERIC (
        BASE_ADDR : unsigned(15 DOWNTO 0) := X"0360"
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        F8M    : IN     std_ulogic;
        rst    : IN     std_ulogic;
        ExpAck : OUT    std_ulogic;
        rData  : OUT    std_logic_vector(15 DOWNTO 0);
        SCL    : INOUT  std_logic;
        SDA    : INOUT  std_logic
     );
  END COMPONENT;

  COMPONENT ptrhm_acquire
     GENERIC (
        N_PTRH      : integer range 16 downto 1 := 8;
        N_ISBITS    : integer range 8 downto 1  := 4;
        ESID        : ESID_array                := ( 3, 2, 1, 0, 0, 0, 0, 0 );
        ESwitchBit  : ESB_array                 := ( 0, 0, 0, 4, 3, 2, 1, 0 );
        ESwitchAddr : ESA_array                 := ( "0000000", "0000000", "0000000", "1110000" );
        ISwitchBit  : ISB_array                 := ( 3, 2, 1, 0 )
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        F8M    : IN     std_ulogic;
        rst    : IN     std_logic;
        ExpAck : OUT    std_ulogic;
        rData  : OUT    std_logic_vector(15 DOWNTO 0);
        scl    : INOUT  std_logic_vector(N_ISBITS-1 DOWNTO 0);
        sda    : INOUT  std_logic_vector(N_ISBITS-1 DOWNTO 0)
     );
  END COMPONENT;

  COMPONENT qclictrl
     GENERIC (
        BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        F8M    : IN     std_logic;
        QNBsy  : IN     std_logic;
        WData  : IN     std_logic_vector(15 DOWNTO 0);
        rst    : IN     std_logic;
        ExpAck : OUT    std_ulogic;
        QSync  : OUT    std_ulogic;
        RData  : OUT    std_logic_vector(15 DOWNTO 0);
        QSClk  : INOUT  std_logic;
        QSData : INOUT  std_logic
     );
  END COMPONENT;
  
  COMPONENT lk204
     GENERIC (
        BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1100"
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        F8M    : IN     std_ulogic;
        INTA   : IN     std_ulogic;
        Rst    : IN     std_logic;
        WData  : IN     std_logic_vector(15 DOWNTO 0);
        BdIntr : OUT    std_ulogic;
        ExpAck : OUT    std_ulogic;
        RData  : OUT    std_logic_vector(15 DOWNTO 0);
        scl    : INOUT  std_logic_vector(0 TO 0);
        sda    : INOUT  std_logic_vector(0 TO 0)
     );
  END COMPONENT;
  
  COMPONENT adc_v1
     GENERIC( 
        BASE_ADDR : std_logic_vector := X"0E80";
        N_ADC : integer range 4 DOWNTO 0 := 2;
        NBITSHIFT : integer range 31 DOWNTO 0 := 1;
        RATE_DEF : std_logic_vector(4 DOWNTO 0) := "11111"
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        F8M    : IN     std_ulogic;
        MISO   : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
        rst    : IN     std_logic;
        CS_B   : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
        ExpAck : OUT    std_ulogic;
        MOSI   : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
        RData  : OUT    std_logic_vector (15 DOWNTO 0);
        SCLK   : OUT    std_logic_vector (N_ADC-1 DOWNTO 0)
     );
  END COMPONENT adc_v1;
  
  COMPONENT temp_top
     GENERIC (
        BASE_ADDR : unsigned (15 DOWNTO 0) := X"0000"
     );
     PORT (
        Addr  : IN     std_logic_vector(15 DOWNTO 0);
        ExpRd : IN     std_logic;
        ExpWr : IN     std_logic;
        F8M   : IN     std_logic;
        rst   : IN     std_logic;                     -- sync high
        ExpAck : OUT   std_logic;
        RData : OUT    std_logic_vector(15 DOWNTO 0);
        scl   : INOUT  std_logic;
        sda   : INOUT  std_logic
     );
  END COMPONENT temp_top;
  
  FOR ALL : ctr_ungated USE ENTITY idx_fpga_lib.ctr_ungated;
  FOR ALL : ao USE ENTITY idx_fpga_lib.ao;
  FOR ALL : vm USE ENTITY idx_fpga_lib.vm;
  FOR ALL : ptrhm_acquire USE ENTITY idx_fpga_lib.ptrhm_acquire;
  FOR ALL : qclictrl USE ENTITY idx_fpga_lib.qclictrl;
  FOR ALL : lk204 USE ENTITY idx_fpga_lib.lk204;
  FOR ALL : adc_v1 USE ENTITY idx_fpga_lib.adc_v1;
  FOR ALL : temp_top USE ENTITY idx_fpga_lib.temp_top;

	attribute box_type : string;
	attribute box_type of Processor : component is "user_black_box";
	
	function N_ADC_BD return integer IS
	BEGIN
	  IF N_ADC > 0 THEN
	    return 1;
    ELSE
	    return 0;
    END IF;
	END N_ADC_BD;
	
	CONSTANT IDX_BDNO : integer := 0;
	CONSTANT DIGIO_BDNO : integer := 1;
	CONSTANT AI_BDNO : integer := 2;
	CONSTANT AO_BDNO : integer := 3;
	CONSTANT PTRHM_BDNO : integer := 4;
	CONSTANT VM_BDNO : integer := PTRHM_BDNO+1;
	CONSTANT CTR_UG_BDNO : integer := VM_BDNO+N_VM;
	CONSTANT QCLI_BDNO : integer := CTR_UG_BDNO+CTR_UG_N_BDS;
	CONSTANT LK204_BDNO : integer := QCLI_BDNO+N_QCLICTRL;
	CONSTANT ADC_BDNO : integer := LK204_BDNO+N_LK204;
	CONSTANT TS_BDNO : integer := ADC_BDNO+N_ADC_BD;
	CONSTANT N_BOARDS : integer := TS_BDNO+N_TEMP_SENSOR;
	SIGNAL clk_8_0000MHz : std_logic;
	SIGNAL clk_66_6667MHz : std_logic;
  SIGNAL xps_epc_0_PRH_Wr_n_pin : std_logic;
	SIGNAL subbus_addr : std_logic_vector(15 downto 0);
	SIGNAL subbus_data_i : std_logic_vector(15 downto 0);      
	SIGNAL subbus_data_o : std_logic_vector(15 downto 0);      
	SIGNAL subbus_ctrl : std_logic_vector(6 downto 0);
	SIGNAL subbus_status : std_logic_vector(3 downto 0);
  SIGNAL subbus_switches : std_logic_vector(7 downto 0);
	SIGNAL ExpAddr : std_logic_vector(15 downto 0);
	SIGNAL WData  : std_logic_vector(15 DOWNTO 0);
	SIGNAL iRData : std_logic_vector((N_BOARDS-1)*16+15 downto 0);
	SIGNAL ExpRd : std_logic;
	SIGNAL ExpWr : std_logic;
	SIGNAL ExpAck : std_logic_vector (N_BOARDS-1 DOWNTO 0);
	SIGNAL CmdEnbl : std_ulogic;
	SIGNAL CmdStrb : std_ulogic;
	SIGNAL rst : std_ulogic;
  SIGNAL BdIntr : std_ulogic_vector(N_INTERRUPTS-1 downto 0);
  SIGNAL INTA : std_ulogic;
  SIGNAL Fail_outputs : std_logic_vector(4 DOWNTO 0);
  SIGNAL Fail_inputs : std_logic_vector(4 DOWNTO 0);
  SIGNAL not_FTDI_TXE_pin : std_ulogic; --  not FTDI_TXE_pin
  SIGNAL not_FTDI_RXF_pin : std_ulogic; --  not FTDI_RXF_pin
  SIGNAL Addr                   : std_logic_vector(15 DOWNTO 0);
  SIGNAL F8M                    : std_ulogic;
  SIGNAL rData                  : std_logic_vector(15 DOWNTO 0);
  SIGNAL scl                    : std_logic_vector(N_ISBITS-1 DOWNTO 0);
  SIGNAL sda                    : std_logic_vector(N_ISBITS-1 DOWNTO 0);

begin
	Inst_Processor: Processor
	 PORT MAP(
     -- fpga_0_RS232_RX_pin => fpga_0_RS232_RX_pin,
     -- fpga_0_RS232_TX_pin => fpga_0_RS232_TX_pin,
     fpga_0_clk_1_sys_clk_pin => fpga_0_clk_1_sys_clk_pin,
     fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
     clk_8_0000MHz_pin => clk_8_0000MHz,
     clk_66_6667MHz_pin => clk_66_6667MHz,

     xps_epc_0_PRH_Rdy_pin =>  not_FTDI_TXE_pin,
     xps_epc_0_PRH_Wr_n_pin => xps_epc_0_PRH_Wr_n_pin,
     xps_epc_0_PRH_Data_pin => xps_epc_0_PRH_Data_pin,
     xps_epc_0_PRH_Rd_n_pin => FTDI_RD_pin,
     FTDI_SI_pin => FTDI_SI_pin,
     FTDI_RX_RDY_pin => not_FTDI_RXF_pin,

     xps_gpio_subbus_addr_pin => subbus_addr,
     xps_gpio_subbus_data_i_pin => subbus_data_i,
     xps_gpio_subbus_data_o_pin => subbus_data_o,
     xps_gpio_subbus_ctrl_pin => subbus_ctrl,
     xps_gpio_subbus_status_pin => subbus_status,
     xps_gpio_subbus_leds_pin => Fail_outputs,
     xps_gpio_subbus_switches_pin => DACS_switches,
     xps_gpio_subbus_leds_readback_pin => Fail_inputs
	 );
	
	Inst_syscon: syscon
  	 GENERIC MAP (
      DACS_BUILD_NUMBER => DACS_BUILD_NUMBER,
      INSTRUMENT_ID => INSTRUMENT_ID,
  	   N_INTERRUPTS => N_INTERRUPTS,
  	   N_BOARDS => N_BOARDS
  	 )
  	 PORT MAP(
    		F8M => clk_8_0000MHz,
    		Ctrl => subbus_ctrl,
    		Addr => subbus_addr,
    		Data_i => subbus_data_i,
    		Data_o => subbus_data_o,
    		Status => subbus_status,
    		ExpRd => ExpRd,
    		ExpWr => ExpWr,
    		WData => WData,
    		RData => iRData,
    		ExpAddr => ExpAddr,
    		ExpAck => ExpAck,
    		BdIntr => BdIntr,
    		INTA => INTA,
    		Collision => Collision,
    		CmdEnbl => CmdEnbl,
    		CmdStrb => CmdStrb,
      ExpReset => rst,
      Fail_In => Fail_outputs(0),
      Fail_Out => Fail_inputs(0),
      Flt_CPU_Reset => subbus_flt_cpu_reset
   	);
	
	Inst_idx: gxidx
	  GENERIC MAP (
	    N_CHANNELS => IDX_N_CHANNELS,
	    BASE_ADDR => IDX_BASE_ADDR
	  )
	  PORT MAP (
       rst         => rst,
       Addr        => ExpAddr,
       CMDENBL     => CmdEnbl,
       ExpRd       => ExpRd,
       ExpWr       => ExpWr,
       INTA        => INTA,
       F8M         => clk_8_0000MHz,
       KillA       => idx_KillA,
       KillB       => idx_KillB,
       LimI        => idx_LimI,
       LimO        => idx_LimO,
       ZR          => idx_ZR,
       Dir         => idx_Dir,
       Run         => idx_Run,
       Step        => idx_Step,
       WData       => WData,
       ExpAck      => ExpAck(IDX_BDNO),
       BdIntr      => BdIntr(0),
       RData       => iRData(16*IDX_BDNO+15 DOWNTO 16*IDX_BDNO)
   	);

 Inst_DigIO : DigIO
    GENERIC MAP (
      DIGIO_BASE_ADDRESS => DIGIO_BASE_ADDRESS,
      DIGIO_N_CONNECTORS => DIGIO_N_CONNECTORS,
      DIGIO_FORCE_DIR => DIGIO_FORCE_DIR,
      DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL
    )
    PORT MAP (
       Addr   => ExpAddr,
       ExpRd  => ExpRd,
       ExpWr  => ExpWr,
       F8M    => clk_8_0000MHz,
       rst    => rst,
       IO     => dig_IO,
       Dir    => dig_Dir,
       WData  => WData,
       ExpAck => ExpAck(DIGIO_BDNO),
       Rdata  => iRData(16*DIGIO_BDNO+15 DOWNTO 16*DIGIO_BDNO)
    );

 Inst_ana_in : ana_input
    PORT MAP (
       Addr   => ExpAddr,
       ExpRd  => ExpRd,
       ExpWr  => ExpWr,
       F8M    => clk_8_0000MHz,
       RST    => rst,
       SDI    => ana_in_SDI,
       CS5    => ana_in_CS5,
       Conv   => ana_in_Conv,
       Row    => ana_in_Row,
       SCK16  => ana_in_SCK16,
       SCK5   => ana_in_SCK5,
       SDO    => ana_in_SDO,
       WData  => WData,
       ExpAck => ExpAck(AI_BDNO),
       RData  => iRData(16*AI_BDNO+15 DOWNTO 16*AI_BDNO)
    );

  Inst_ao : ao
     GENERIC MAP (
       N_AO_CHIPS => N_AO_CHIPS
     )
     PORT MAP (
        Addr      => ExpAddr,
        ExpRd     => ExpRd,
        ExpWr     => ExpWr,
        F8M       => clk_8_0000MHz,
        rst       => rst,
        DA_CLR_B  => DA_CLR_B,
        DA_CS_B   => DA_CS_B,
        DA_LDAC_B => DA_LDAC_B,
        DA_SCK    => DA_SCK,
        DA_SDI    => DA_SDI,
        WData     => WData,
        ExpAck    => ExpAck(AO_BDNO),
        RData     => iRData(16*AO_BDNO+15 DOWNTO 16*AO_BDNO)
     );

  ptrhm : ptrhm_acquire
     GENERIC MAP (
        N_PTRH      => N_PTRH,
        N_ISBITS    => N_ISBITS,
        ESID        => ESID,
        ESwitchBit  => ESwitchBit,
        ESwitchAddr => ESwitchAddr,
        ISwitchBit  => ISwitchBit
     )
     PORT MAP (
        Addr   => ExpAddr,
        ExpRd  => ExpRd,
        ExpWr  => ExpWr,
        F8M    => clk_8_0000MHz,
        rst    => rst,
        ExpAck => ExpAck(PTRHM_BDNO),
        rData  => iRData(16*PTRHM_BDNO+15 DOWNTO 16*PTRHM_BDNO),
        scl    => PTRH_SCK_pin,
        sda    => PTRH_SDA_pin
     );

  vms : for i in 0 TO N_VM-1 generate
    Inst_vm : vm
       GENERIC MAP (
         -- 864 = 0x360
         BASE_ADDR => CONV_UNSIGNED(864+i*16,16)
       )
       PORT MAP (
          Addr   => ExpAddr,
          ExpRd  => ExpRd,
          F8M    => clk_8_0000MHz,
          rst    => rst,
          ExpAck => ExpAck(VM_BDNO+i),
          rData  => iRData(16*(VM_BDNO+i)+15 DOWNTO 16*(VM_BDNO+i)),
          SCL    => VM_SCL_pin(i),
          SDA    => VM_SDA_pin(i)
       );
  end generate;

  ctrs : for i in 0 TO CTR_UG_N_BDS-1 generate
    
    ctr_ug: ctr_ungated
      GENERIC MAP (
         BASE_ADDRESS => CONV_STD_LOGIC_VECTOR(6*256+i*32,16),
         N_COUNTERS   => 4,
         N_BITS       => 20
      )
      PORT MAP (
         Addr   => ExpAddr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => clk_8_0000MHz,
         rst    => rst,
         PMT    => ctr_PMT(i*4+3 DOWNTO i*4),
         WData  => WData,
         ExpAck => ExpAck(CTR_UG_BDNO+i),
         RData  => iRData(16*(CTR_UG_BDNO+i)+15 DOWNTO 16*(CTR_UG_BDNO+i))
      );
  end generate;
  
  qcli : for i in 0 TO N_QCLICTRL-1 generate
    qcli : qclictrl
      GENERIC MAP (
         BASE_ADDR => CONV_STD_LOGIC_VECTOR(4096+i*16,16)
      )
      PORT MAP (
         Addr   => ExpAddr,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         F8M    => clk_8_0000MHz,
         WData  => WData,
         rst    => rst,
         ExpAck => ExpAck(QCLI_BDNO+i),
         QSync  => QSync(i),
         RData  => iRData(16*(QCLI_BDNO+i)+15 DOWNTO 16*(QCLI_BDNO+i)),
         QSClk  => QSClk(i),
         QSData => QSData(i),
         QNBsy  => QNBsy(i)
      );
  end generate;

  lk204_gen: if N_LK204 = 1 generate
    lk204_if : lk204
      GENERIC MAP (
        BASE_ADDR => X"1100"
      )
      PORT MAP (
        Addr   => ExpAddr,
        ExpRd  => ExpRd,
        ExpWr  => ExpWr,
        F8M    => clk_8_0000MHz,
        INTA   => INTA,
        Rst    => rst,
        WData  => WData,
        BdIntr => BdIntr(1),
        ExpAck => ExpAck(LK204_BDNO),
        RData  => iRData(16*LK204_BDNO+15 DOWNTO 16*LK204_BDNO),
        scl    => LK204_SCL_pin,
        sda    => LK204_SDA_pin
      );
  end generate;

  adc_gen: if N_ADC > 0 generate
    adc_if: adc_v1
     GENERIC MAP (
       BASE_ADDR => X"0E80",
       N_ADC => N_ADC,
       NBITSHIFT => ADC_NBITSHIFT,
       RATE_DEF => ADC_RATE_DEF
     )
     PORT MAP (
        Addr   => ExpAddr,
        ExpRd  => ExpRd,
        ExpWr  => ExpWr,
        F8M    => clk_8_0000MHz,
        MISO   => ADC_MISO,
        MOSI   => ADC_MOSI,
        CS_B   => ADC_CS_B,
        SCLK   => ADC_SCLK,
        ExpAck => ExpAck(ADC_BDNO),
        RData  => iRData(16*ADC_BDNO+15 DOWNTO 16*ADC_BDNO),
        rst    => rst
     );
  end generate;
  
  ts_gen: if N_TEMP_SENSOR > 0 generate
    ts_inst : temp_top
       GENERIC MAP (
          BASE_ADDR => X"0480"  
       )
       PORT MAP (
          Addr  => ExpAddr,
          ExpRd => ExpRd,
          ExpWr => ExpWr,
          ExpAck => ExpAck(TS_BDNO),
          F8M   => clk_8_0000MHz,
          rst   => rst,
          RData => iRData(16*TS_BDNO+15 DOWNTO 16*TS_BDNO),
          scl   => TS_SCL(0),
          sda   => TS_SDA(0)
       );
  end generate;

  subbus_cmdenbl <= CmdEnbl;
  subbus_cmdstrb <= CmdStrb;
  Fail_inputs(4 DOWNTO 1) <= Fail_outputs(4 DOWNTO 1);
  -- subbus_fail_leds <= Fail_inputs;
  subbus_fail_leds(0) <= Fail_inputs(0);
  subbus_fail_leds(1) <= subbus_ctrl(6); -- Arm
  subbus_fail_leds(2) <= subbus_ctrl(5); -- Tick
  subbus_fail_leds(3) <= subbus_ctrl(3); -- CE
  subbus_fail_leds(4) <= subbus_status(3); -- TwoSecTO
  subbus_reset <= rst;
  FTDI_WR_pin <= not xps_epc_0_PRH_Wr_n_pin;
  fpga_0_RS232_TX_pin <= '0';
  not_FTDI_TXE_pin <= not FTDI_TXE_pin;
  not_FTDI_RXF_pin <= not FTDI_RXF_pin;

end Behavioral;

