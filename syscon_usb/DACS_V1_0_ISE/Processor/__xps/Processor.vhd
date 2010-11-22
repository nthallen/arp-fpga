LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Processor IS
PORT (
	fpga_0_Generic_IIC_Bus_Sda_pin : INOUT STD_LOGIC;
	fpga_0_Generic_IIC_Bus_Scl_pin : INOUT STD_LOGIC;
	fpga_0_RS232_RX_pin : IN STD_LOGIC;
	fpga_0_RS232_TX_pin : OUT STD_LOGIC;
	fpga_0_clk_1_sys_clk_pin : IN STD_LOGIC;
	fpga_0_rst_1_sys_rst_pin : IN STD_LOGIC;
	clk_8_0000MHz_pin : OUT STD_LOGIC;
	clk_30_0000MHz_pin : OUT STD_LOGIC;
	xps_epc_0_FTDI_RXF_pin : OUT STD_LOGIC;
	xps_epc_0_FTDI_WR_pin : OUT STD_LOGIC;
	xps_epc_0_PRH_Data_pin : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	xps_epc_0_PRH_Rd_n_pin : OUT STD_LOGIC;
	FTDI_SI_pin : OUT STD_LOGIC;
	xps_gpio_subbus_addr_pin : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	xps_gpio_subbus_ctrl_pin : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	xps_gpio_subbus_data_i_pin : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	xps_gpio_subbus_data_o_pin : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	xps_gpio_subbus_status_pin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	xps_gpio_subbus_leds_pin : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	xps_gpio_subbus_switches_pin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	xps_gpio_subbus_leds_readback_pin : IN STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END Processor;

ARCHITECTURE STRUCTURE OF Processor IS

BEGIN
END ARCHITECTURE STRUCTURE;
