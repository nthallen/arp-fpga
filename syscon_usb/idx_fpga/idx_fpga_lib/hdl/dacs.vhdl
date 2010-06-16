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
use idx_fpga_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dacs is
    GENERIC (
      N_CHANNELS : integer range 15 downto 1 := 1
    );
    Port (
		fpga_0_rst_1_sys_rst_pin : IN std_logic;
		fpga_0_clk_1_sys_clk_pin : IN std_logic;
		xps_epc_0_FTDI_RXF_pin : IN std_logic_vector(0 to 0);
		xps_epc_0_PRH_Data : INOUT std_logic_vector(7 downto 0);
		xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
		xps_gpio_HBled_O_pin : OUT std_logic_vector(0 to 0);
		xps_epc_0_FTDI_WR_pin : OUT std_logic_vector(0 to 0);
      idata : OUT std_logic;
		ixdata : OUT std_logic;
      ExpRd_pin : OUT std_logic;
		RdEn_pin : OUT std_logic;
		subbus_cmdenbl : OUT std_ulogic;
		subbus_cmdstrb : OUT std_ulogic;
      idx_Run : OUT std_ulogic_vector(N_CHANNELS-1 downto 0);
      idx_Step : OUT std_ulogic_vector(N_CHANNELS-1 downto 0);
		idx_Dir : OUT std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
		idx_KillA : IN std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
		idx_KillB : IN std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
		idx_LimI : IN std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
		idx_LimO : IN std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
		idx_ZR : IN std_ulogic_vector (N_CHANNELS-1 DOWNTO 0)
	 );
end dacs;

architecture Behavioral of dacs is
	COMPONENT system
	PORT(
		fpga_0_rst_1_sys_rst_pin : IN std_logic;
		fpga_0_clk_1_sys_clk_pin : IN std_logic;
		xps_epc_0_FTDI_RXF_pin : IN std_logic_vector(0 to 0);
		xps_epc_0_PRH_Data : INOUT std_logic_vector(7 downto 0);
		xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
		xps_gpio_HBled_O_pin : OUT std_logic_vector(0 to 0);
		xps_epc_0_FTDI_WR_pin : OUT std_logic_vector(0 to 0);
		clk_8_0000MHz_pin : OUT std_logic;
		xps_gpio_subbus_intr_pin : IN std_logic_vector(0 to 0);
		xps_gpio_subbus_data_i_pin : IN std_logic_vector(15 downto 0);      
		xps_gpio_subbus_data_o_pin : OUT std_logic_vector(15 downto 0);      
		xps_gpio_subbus_addr_pin : OUT std_logic_vector(15 downto 0);
		xps_gpio_subbus_ctrl_pin : OUT std_logic_vector(4 downto 0);
		xps_gpio_subbus_status_pin : IN std_logic_vector(1 downto 0)
		);
	END COMPONENT;

	COMPONENT syscon
	PORT(
		F8M : IN std_logic;
		Addr : IN std_logic_vector(15 downto 0);    
		Data_i : OUT std_logic_vector(15 downto 0);
		Data_o : IN std_logic_vector(15 downto 0);
		Ctrl : IN std_logic_vector(4 downto 0);
		Status : OUT std_logic_vector(1 downto 0);
		ExpAddr : OUT std_logic_vector(15 downto 0);
		ExpData : INOUT std_logic_vector(15 downto 0);
		ExpRd : OUT std_logic;
		ExpWr : OUT std_logic;
		ExpAck : IN std_logic;
      ExpReset : OUT std_ulogic;
      CmdEnbl : OUT std_ulogic;
	    CmdStrb : OUT std_ulogic
		);
	END COMPONENT;
	
   COMPONENT gxidx
		GENERIC( 
			N_CHANNELS : integer range 15 downto 1 := 2
		);
		PORT( 
			rst         : IN     std_ulogic;
			Addr        : IN     std_logic_vector (15 DOWNTO 0);
			CMDENBL     : IN     std_ulogic;
			ExpRd       : IN     std_ulogic;
			ExpWr       : IN     std_ulogic;
			F8M         : IN     std_ulogic;
			KillA       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			KillB       : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			LimI        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			LimO        : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			ZR          : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			ExpAck      : OUT    std_logic;
			ExpIntr_Not : OUT    std_logic;
			Dir         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			Run         : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			Step        : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
			Data        : INOUT  std_logic_vector (15 DOWNTO 0)
		);
	END COMPONENT;

	attribute box_type : string;
	attribute box_type of system : component is "user_black_box";
	
	SIGNAL clk_8_0000MHz : std_logic;
	SIGNAL subbus_addr : std_logic_vector(15 downto 0);
	SIGNAL subbus_data_i : std_logic_vector(15 downto 0);      
	SIGNAL subbus_data_o : std_logic_vector(15 downto 0);      
	SIGNAL subbus_ctrl : std_logic_vector(4 downto 0);
	SIGNAL subbus_status : std_logic_vector(1 downto 0);
	SIGNAL subbus_intr : std_logic_vector(0 to 0);
	SIGNAL ExpAddr : std_logic_vector(15 downto 0);
	SIGNAL ExpData : std_logic_vector(15 downto 0);
	SIGNAL ExpRd : std_logic;
	SIGNAL ExpWr : std_logic;
	SIGNAL ExpAck : std_logic;
	SIGNAL CmdEnbl : std_ulogic;
	SIGNAL CmdStrb : std_ulogic;
	SIGNAL rst : std_ulogic;

begin
	Inst_system: system PORT MAP(
		fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
		fpga_0_clk_1_sys_clk_pin => fpga_0_clk_1_sys_clk_pin,
		xps_epc_0_PRH_Data => xps_epc_0_PRH_Data,
		xps_epc_0_PRH_Rd_n_pin => xps_epc_0_PRH_Rd_n_pin,
		xps_epc_0_FTDI_RXF_pin => xps_epc_0_FTDI_RXF_pin,
		xps_epc_0_FTDI_WR_pin => xps_epc_0_FTDI_WR_pin,
		xps_gpio_HBled_O_pin => xps_gpio_HBled_O_pin,
		clk_8_0000MHz_pin => clk_8_0000MHz,
		xps_gpio_subbus_addr_pin => subbus_addr,
		xps_gpio_subbus_data_i_pin => subbus_data_i,
		xps_gpio_subbus_data_o_pin => subbus_data_o,
		xps_gpio_subbus_ctrl_pin => subbus_ctrl,
		xps_gpio_subbus_status_pin => subbus_status,
		xps_gpio_subbus_intr_pin => subbus_intr
	);
	
	Inst_syscon: syscon PORT MAP(
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
		ExpReset => rst,
		CmdEnbl => CmdEnbl,
		CmdStrb => CmdStrb
	);
	
	Inst_idx: gxidx
	  GENERIC MAP ( N_CHANNELS => N_CHANNELS )
	  PORT MAP (
         rst         => rst,
         Addr        => ExpAddr,
         Data        => ExpData,
         CMDENBL     => CmdEnbl,
         ExpRd       => ExpRd,
         ExpWr       => ExpWr,
         ExpAck      => ExpAck,
         F8M         => clk_8_0000MHz,
         -- ExpIntr_Not => ExpIntr_Not,
         KillA       => idx_KillA,
         KillB       => idx_KillB,
         LimI        => idx_LimI,
         LimO        => idx_LimO,
         ZR          => idx_ZR,
         Dir         => idx_Dir,
         Run         => idx_Run,
         Step        => idx_Step
		);

  subbus_cmdenbl <= CmdEnbl;
  subbus_cmdstrb <= CmdStrb;
  idata <= subbus_data_i(0);
  ixdata <= ExpData(0);
  ExpRd_pin <= ExpRd;
  RdEn_pin <= subbus_ctrl(0);
end Behavioral;

