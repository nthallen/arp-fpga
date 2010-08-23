
-- VHDL Instantiation Created from source file system.vhd -- 11:16:29 06/16/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY system IS
	PORT(
		fpga_0_rst_1_sys_rst_pin : IN std_logic;
		fpga_0_clk_1_sys_clk_pin : IN std_logic;
		xps_epc_0_FTDI_RXF_pin : IN std_logic_vector(0 to 0);
		xps_gpio_subbus_status_pin : IN std_logic_vector(2 downto 0);
		xps_gpio_subbus_data_i_pin : IN std_logic_vector(15 downto 0);    
		xps_epc_0_PRH_Data : INOUT std_logic_vector(7 downto 0);      
		xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
		xps_gpio_HBled_O_pin : OUT std_logic_vector(0 to 0);
		xps_gpio_subbus_addr_pin : OUT std_logic_vector(15 downto 0);
		xps_epc_0_FTDI_WR_pin : OUT std_logic_vector(0 to 0);
		xps_gpio_subbus_ctrl_pin : OUT std_logic_vector(4 downto 0);
		clk_8_0000MHz_pin : OUT std_logic;
		xps_gpio_subbus_data_o_pin : OUT std_logic_vector(15 downto 0)
		);
END system;

architecture Simulation of system is
  SIGNAL Addr : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_i : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_o : std_logic_vector (15 DOWNTO 0);
  SIGNAL Ctrl : std_logic_vector (4 DOWNTO 0);
  SIGNAL Status : std_logic_vector (2 DOWNTO 0); -- ExpIntr,Ack,Done
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias Done is Status(0);
  alias Ack is Status(1);
  alias ExpIntr is Status(2);

begin
  testproc: Process
  begin
    xps_epc_0_PRH_Data <= (others => 'Z');
    xps_epc_0_PRH_Rd_n_pin <= '0';
    xps_gpio_HBled_O_pin <= (others => '0');
    xps_epc_0_FTDI_Wr_pin <= (others => '0');
    Addr <= X"0000";
    Ctrl <= "00000";
    Data_o <= X"5555";
    -- pragma synthesis_off
    wait for 300 ns;
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 100 ns;
    RdEn <= '1';
    wait for 200 ns;
    wait until Done = '1';
    wait for 1000 ns;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    RdEn <= '0';
    wait for 300 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    Data_o <= X"5555";
    Addr <= X"0A0C";
    wait for 100 ns;
    WrEn <= '1';
    wait for 300 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    wait for 300 ns;
    assert Ack = '1' report "Ack should be asserted" severity error;
    wait for 600 ns;
    wait for 100 ns;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    WrEn <= '0';
    wait for 100 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    
    RdEn <= '1';
    wait for 200 ns;
    wait until Done = '1';
    wait for 1000 ns;
    assert Done = '1' report "Done should be asserted" severity error;
    assert Ack = '1' report "Ack should be asserted" severity error;
    assert Data_i = X"5555" report "Data_i should be 5555" severity error;
    RdEn <= '0';
    wait for 300 ns;
    assert Done = '0' report "Done should not be asserted" severity error;
    assert Ack = '0' report "Ack should not be asserted" severity error;
    wait;
    -- pragma synthesis_on
  end Process;

  f8m_clk : Process
  Begin
    clk_8_0000MHz_pin <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    clk_8_0000MHz_pin <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;
  
  Status <= xps_gpio_subbus_status_pin;
  Data_i <= xps_gpio_subbus_data_i_pin;
  xps_gpio_subbus_data_o_pin <= Data_o;
  xps_gpio_subbus_ctrl_pin <= Ctrl;
  xps_gpio_subbus_addr_pin <= Addr;
end Simulation;

