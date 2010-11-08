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
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library idx_fpga_lib;
-- use idx_fpga_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dacs is
    GENERIC (
      N_INTERRUPTS : integer range 15 downto 1 := 1;
      N_BOARDS : integer range 15 downto 1 := 2;
      IDX_N_CHANNELS : integer range 15 downto 1 := 1;
      IDX_BASE_ADDR : std_logic_vector(15 downto 0) := X"0A00";
      DIGIO_N_CONNECTORS : integer range 4 downto 1 := 2
    );
    Port (
      fpga_0_rst_1_sys_rst_pin : IN std_logic;
      fpga_0_clk_1_sys_clk_pin : IN std_logic;
      xps_epc_0_FTDI_RXF_pin : IN std_logic;
      xps_epc_0_PRH_Data_pin : INOUT std_logic_vector(7 downto 0);
      xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
      xps_epc_0_FTDI_WR_pin : OUT std_logic;
      FTDI_SI_pin : OUT std_logic;
      
      fpga_0_RS232_RX_pin : IN std_logic;
      fpga_0_RS232_TX_pin : OUT std_logic;
      fpga_0_Generic_IIC_Bus_Sda_pin : INOUT std_logic;
      fpga_0_Generic_IIC_Bus_Scl_pin : INOUT std_logic;
      
      subbus_cmdenbl : OUT std_ulogic;
      subbus_cmdstrb : OUT std_ulogic;
      subbus_fail_leds : OUT std_logic_vector(4 downto 0);
      DACS_switches : IN std_logic_vector(3 downto 0);

      idx_Run : OUT std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
      idx_Step : OUT std_ulogic_vector(IDX_N_CHANNELS-1 downto 0);
      idx_Dir : OUT std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_KillA : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_KillB : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_LimI : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_LimO : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0);
      idx_ZR : IN std_ulogic_vector (IDX_N_CHANNELS-1 DOWNTO 0)
 );
end dacs;

architecture Behavioral of dacs is
	COMPONENT system
   	PORT(
       fpga_0_clk_1_sys_clk_pin : IN std_logic;
       fpga_0_rst_1_sys_rst_pin : IN std_logic;
       fpga_0_RS232_RX_pin : IN std_logic;
       xps_gpio_subbus_leds_readback_pin : IN std_logic_vector(4 downto 0);    
       fpga_0_Generic_IIC_Bus_Sda_pin : INOUT std_logic;
       fpga_0_Generic_IIC_Bus_Scl_pin : INOUT std_logic;
       xps_epc_0_PRH_Data_pin : INOUT std_logic_vector(7 downto 0);      
       fpga_0_RS232_TX_pin : OUT std_logic;
       clk_8_0000MHz_pin : OUT std_logic;
       clk_30_0000MHz_pin : OUT std_logic;
       xps_epc_0_FTDI_RXF_pin : IN std_logic;
       xps_epc_0_FTDI_WR_pin : OUT std_logic;
       xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
       FTDI_SI_pin : OUT std_logic;
       xps_gpio_subbus_addr_pin : OUT std_logic_vector(15 downto 0);
       xps_gpio_subbus_ctrl_pin : OUT std_logic_vector(5 downto 0);
       xps_gpio_subbus_data_i_pin : IN std_logic_vector(15 downto 0);
       xps_gpio_subbus_data_o_pin : OUT std_logic_vector(15 downto 0);
       xps_gpio_subbus_status_pin : IN std_logic_vector(3 downto 0);
       xps_gpio_subbus_leds_pin : OUT std_logic_vector(4 downto 0);
       xps_gpio_subbus_switches_pin : IN std_logic_vector(3 downto 0)
   	);
  END COMPONENT;

	COMPONENT syscon
    GENERIC(
      N_INTERRUPTS : integer range 15 downto 0 := 1;
      N_BOARDS : integer range 15 downto 0 := 1
    );
   	PORT(
    		F8M : IN std_logic;
    		Addr : IN std_logic_vector(15 downto 0);    
    		Data_i : OUT std_logic_vector(15 downto 0);
    		Data_o : IN std_logic_vector(15 downto 0);
    		Ctrl : IN std_logic_vector(5 downto 0);
    		Status : OUT std_logic_vector(3 downto 0);
    		ExpRd : OUT std_logic;
    		ExpWr : OUT std_logic;
      ExpData : INOUT std_logic_vector(15 downto 0);
      ExpAddr : OUT std_logic_vector(15 downto 0);
      ExpAck : IN std_logic_vector (N_BOARDS-1 DOWNTO 0);
      BdIntr : IN std_ulogic_vector(N_INTERRUPTS-1 downto 0);
      INTA    : OUT std_ulogic;
      CmdEnbl : OUT std_ulogic;
      CmdStrb : OUT std_ulogic;
      ExpReset : OUT std_ulogic;
      Fail_In : IN std_ulogic;
      Fail_Out : OUT std_ulogic
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
			Data        : INOUT  std_logic_vector (15 DOWNTO 0)
		);
	END COMPONENT;

  COMPONENT DigIO
     GENERIC (
        BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
        N_CONNECTORS : integer range 4 DOWNTO 1       := 2
     );
     PORT (
        Addr   : IN     std_logic_vector(15 DOWNTO 0);
        Data   : INOUT  std_logic_vector(15 DOWNTO 0);
        ExpRd  : IN     std_ulogic;
        ExpWr  : IN     std_ulogic;
        ExpAck : OUT    std_ulogic;
        F8M    : IN     std_ulogic;
        rst    : IN     std_ulogic;
        IO     : INOUT  std_logic_vector( N_CONNECTORS*6*8-1 DOWNTO 0);
        Dir    : OUT    std_logic_vector( N_CONNECTORS*6-1 DOWNTO 0)
     );
  END COMPONENT;
  FOR ALL : DigIO USE ENTITY idx_fpga_lib.DigIO;

	attribute box_type : string;
	attribute box_type of system : component is "user_black_box";
	
	SIGNAL clk_8_0000MHz : std_logic;
	SIGNAL clk_30_0000MHz : std_logic;
	SIGNAL subbus_addr : std_logic_vector(15 downto 0);
	SIGNAL subbus_data_i : std_logic_vector(15 downto 0);      
	SIGNAL subbus_data_o : std_logic_vector(15 downto 0);      
	SIGNAL subbus_ctrl : std_logic_vector(5 downto 0);
	SIGNAL subbus_status : std_logic_vector(3 downto 0);
	SIGNAL ExpAddr : std_logic_vector(15 downto 0);
	SIGNAL ExpData : std_logic_vector(15 downto 0);
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
  SIGNAL IO : std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
  SIGNAL Dir : std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0);

begin
	Inst_system: system
	 PORT MAP(
     fpga_0_Generic_IIC_Bus_Sda_pin => fpga_0_Generic_IIC_Bus_Sda_pin,
     fpga_0_Generic_IIC_Bus_Scl_pin => fpga_0_Generic_IIC_Bus_Scl_pin,
     fpga_0_RS232_RX_pin => fpga_0_RS232_RX_pin,
     fpga_0_RS232_TX_pin => fpga_0_RS232_TX_pin,
     fpga_0_clk_1_sys_clk_pin => fpga_0_clk_1_sys_clk_pin,
     fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
     clk_8_0000MHz_pin => clk_8_0000MHz,
     clk_30_0000MHz_pin => clk_30_0000MHz,
     xps_epc_0_FTDI_RXF_pin => xps_epc_0_FTDI_RXF_pin,
     xps_epc_0_FTDI_WR_pin => xps_epc_0_FTDI_WR_pin,
     xps_epc_0_PRH_Data_pin => xps_epc_0_PRH_Data_pin,
     xps_epc_0_PRH_Rd_n_pin => xps_epc_0_PRH_Rd_n_pin,
     FTDI_SI_pin => FTDI_SI_pin,
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
    		ExpData => ExpData,
    		ExpAddr => ExpAddr,
    		ExpAck => ExpAck,
    		BdIntr => BdIntr,
    		INTA => INTA,
    		CmdEnbl => CmdEnbl,
    		CmdStrb => CmdStrb,
      ExpReset => rst,
      Fail_In => Fail_outputs(0),
      Fail_Out => Fail_inputs(0)
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
       ExpAck      => ExpAck(0),
       BdIntr      => BdIntr(0),
       Dir         => idx_Dir,
       Run         => idx_Run,
       Step        => idx_Step,
       Data        => ExpData
   	);

 Inst_DigIO : DigIO
    GENERIC MAP (
       BASE_ADDRESS => X"0800",
       N_CONNECTORS => DIGIO_N_CONNECTORS
    )
    PORT MAP (
       Addr   => ExpAddr,
       Data   => ExpData,
       ExpRd  => ExpRd,
       ExpWr  => ExpWr,
       ExpAck => ExpAck(1),
       F8M    => clk_8_0000MHz,
       rst    => rst,
       IO     => IO,
       Dir    => Dir
    );

  subbus_cmdenbl <= CmdEnbl;
  subbus_cmdstrb <= CmdStrb;
  Fail_inputs(4 DOWNTO 1) <= Fail_outputs(4 DOWNTO 1);
  subbus_fail_leds <= Fail_inputs;
end Behavioral;

