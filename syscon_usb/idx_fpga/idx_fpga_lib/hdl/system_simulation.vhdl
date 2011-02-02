
-- VHDL Instantiation Created from source file system.vhd -- 11:16:29 06/16/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Processor IS
	PORT(
		fpga_0_clk_1_sys_clk_pin : IN std_logic;
		fpga_0_rst_1_sys_rst_pin : IN std_logic;
--    fpga_0_RS232_RX_pin : IN std_logic;
--    fpga_0_RS232_TX_pin : OUT std_logic;
--		fpga_0_Generic_IIC_Bus_Sda_pin : INOUT std_logic;
--		fpga_0_Generic_IIC_Bus_Scl_pin : INOUT std_logic;
    clk_8_0000MHz_pin : OUT std_logic;
    clk_30_0000MHz_pin : OUT std_logic;
    clk_66_6667MHz_pin : OUT std_logic;
		xps_epc_0_PRH_Data_pin : INOUT std_logic_vector(7 downto 0);      
		xps_epc_0_PRH_RDY_pin : IN std_logic;
		xps_epc_0_PRH_WR_n_pin : OUT std_logic;
		xps_epc_0_PRH_Rd_n_pin : OUT std_logic;
		FTDI_SI_pin : OUT std_logic;
    FTDI_RX_RDY_pin : IN std_logic;    

		xps_gpio_subbus_addr_pin : OUT std_logic_vector(15 downto 0);
		xps_gpio_subbus_ctrl_pin : OUT std_logic_vector(6 downto 0);
		xps_gpio_subbus_data_i_pin : IN std_logic_vector(15 downto 0);
		xps_gpio_subbus_data_o_pin : OUT std_logic_vector(15 downto 0);
		xps_gpio_subbus_status_pin : IN std_logic_vector(3 downto 0);
		xps_gpio_subbus_leds_pin : OUT std_logic_vector(4 downto 0);
    xps_gpio_subbus_leds_readback_pin : IN std_logic_vector(4 downto 0);    
		xps_gpio_subbus_switches_pin : IN std_logic_vector(3 downto 0)
		);
END Processor;

architecture Simulation of Processor is
  SIGNAL Addr : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_i : std_logic_vector (15 DOWNTO 0);
  SIGNAL Data_o : std_logic_vector (15 DOWNTO 0);
  SIGNAL Ctrl : std_logic_vector (6 DOWNTO 0);
  SIGNAL Status : std_logic_vector (3 DOWNTO 0); -- ExpIntr,Ack,Done
  SIGNAL Finish : std_ulogic;
  SIGNAL TickTock : std_ulogic;
  SIGNAL f8m : std_ulogic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias tick is Ctrl(5);
  alias arm is Ctrl(6);
  alias Done is Status(0);
  alias Ack is Status(1);
  alias ExpIntr is Status(2);

begin
  testproc: Process
  procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                  Data_In : IN std_logic_vector (15 downto 0) ) is
  begin
    -- pragma synthesis_off
    Addr <= Addr_In;
    Data_o <= Data_in;
    WrEn <= '1';
    wait for 1 us;
    assert Ack = '1' report "No acknowledge on write" severity error;
    WrEn <= '0';
    wait for 250 ns;
    -- pragma synthesis_on
    return;
  end procedure sbwr;
  
  procedure sbrd_check( addr_in : std_logic_vector (15 DOWNTO 0);
      expected : std_logic_vector(15 DOWNTO 0) ) is
  begin
    -- pragma synthesis_off
    Addr <= addr_in;
    RdEn <= '1';
    wait for 1 us;
    assert Ack = '1' report "No Acknowledge on read" severity error;
    assert Data_i = expected report "Input Value Incorrect" severity error;
    RdEn <= '0';
    wait for 200 ns;
    -- pragma synthesis_on
    return;
  end procedure sbrd_check;

  begin
    xps_epc_0_PRH_Data_pin <= (others => 'Z');
    xps_epc_0_PRH_Rd_n_pin <= '0';
    xps_epc_0_PRH_Wr_n_pin <= '0';
    Finish <= '0';
    Addr <= X"0000";
    Ctrl <= "0000000";
    Data_o <= X"5555";
    TickTock <= '0';
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
    wait until f8m'Event AND f8m = '1';
    wait until f8m'Event AND f8m = '1';
    wait for 50 ns;
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
    
    -- end of low level test. Now to test my cmd problem:
    TickTock <= not TickTock;
    arm <= '1';
    CE <= '1';
    sbwr(X"0810", X"0100");
    CS <= '1';
    wait for 1 us;
    CS <= '0';
    sbwr(X"0810", X"0000");
    sbrd_check(X"0822", X"0010");
    
    sbwr(X"0810", X"0200");
    CS <= '1';
    wait for 1 us;
    CS <= '0';
    sbwr(X"0810", X"0000");
    sbrd_check(X"0822", X"0000");
    
    Finish <= '1';
    wait;
    
    -- pragma synthesis_on
  end Process;

  f8m_clk : Process
  Begin
    -- pragma synthesis_off
    wait for 40 ns;
    while Finish = '0' loop
      f8m <= '0';
     wait for 62 ns;
      f8m <= '1';
     wait for 63 ns;
   end loop;
   wait;
    -- pragma synthesis_on
  End Process;

  f30m_clk : Process -- actually 25MHz
  Begin
    -- pragma synthesis_off
    wait for 40 ns;
    while Finish = '0' loop
      clk_30_0000MHz_pin <= '0';
     wait for 20 ns;
      clk_30_0000MHz_pin <= '1';
     wait for 20 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  f66m_clk : Process -- 66MHz
  Begin
    -- pragma synthesis_off
    wait for 40 ns;
    while Finish = '0' loop
      clk_66_6667MHz_pin <= '0';
     wait for 7 ns;
      clk_66_6667MHz_pin <= '1';
     wait for 8 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  Status <= xps_gpio_subbus_status_pin;
  Data_i <= xps_gpio_subbus_data_i_pin;
  xps_gpio_subbus_data_o_pin <= Data_o;
  xps_gpio_subbus_ctrl_pin <= Ctrl;
  xps_gpio_subbus_addr_pin <= Addr;
  tick <= TickTock;
  clk_8_0000MHz_pin <= f8m;
end Simulation;

