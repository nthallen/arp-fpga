
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
  
  function char_string( Ain : in std_logic_vector(3 DOWNTO 0) )
  return string is
  begin
    case Ain is
      when X"0" => return "0";
      when X"1" => return "1";
      when X"2" => return "2";
      when X"3" => return "3";
      when X"4" => return "4";
      when X"5" => return "5";
      when X"6" => return "6";
      when X"7" => return "7";
      when X"8" => return "8";
      when X"9" => return "9";
      when X"A" => return "A";
      when X"B" => return "B";
      when X"C" => return "C";
      when X"D" => return "D";
      when X"E" => return "E";
      when X"F" => return "F";
      when others => return "X";
    end case;
  end char_string;
  
  function word_string( Ain : in std_logic_vector(15 DOWNTO 0) )
  return string is
  begin
    return
      char_string(Ain(15 downto 12)) &
      char_string(Ain(11 downto 8)) &
      char_string(Ain(7 downto 4)) &
      char_string(Ain(3 downto 0));
  end word_string;

  procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                  Data_In : IN std_logic_vector (15 downto 0) ) is
  begin
    -- pragma synthesis_off
    Addr <= Addr_In;
    Data_o <= Data_in;
    assert Done = '0'
      report "Done not clear before sbwr"
      severity error;
    WrEn <= '1';
    wait until Done = '1';
    assert Ack = '1'
      report "No acknowledge on writing to " & word_string(Addr_In)
      severity error;
    WrEn <= '0';
    wait until Done = '0';
    -- wait for 250 ns;
    -- pragma synthesis_on
    return;
  end procedure sbwr;
  
  procedure sbrd_check( addr_in : std_logic_vector (15 DOWNTO 0);
      expected : std_logic_vector(15 DOWNTO 0) ) is
  begin
    -- pragma synthesis_off
    Addr <= addr_in;
    assert Done = '0'
      report "Done not clear before sbwr"
      severity error;
    RdEn <= '1';
    wait until Done = '1';
    assert Ack = '1'
      report "No Acknowledge on reading from " & word_string(addr_in)
      severity error;
    assert Data_i = expected
      report "Read(" & word_string(addr_in) & " Read: " &
        word_string(Data_i) & " Expected: " & word_string(expected)
      severity error;
    RdEn <= '0';
    wait until Done = '0';
    -- wait for 200 ns;
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
    wait for 500 ns;
    rst <= '0';
    wait for 10 us;
    
    -- end of low level test. Now to test my cmd problem:
--    TickTock <= not TickTock;
--    arm <= '1';
--    CE <= '1';
--    sbwr(X"0810", X"0100");
--    CS <= '1';
--    wait for 1 us;
--    CS <= '0';
--    sbwr(X"0810", X"0000");
--    sbrd_check(X"0822", X"0010");
--    
--    sbwr(X"0810", X"0200");
--    CS <= '1';
--    wait for 1 us;
--    CS <= '0';
--    sbwr(X"0810", X"0000");
--    sbrd_check(X"0822", X"0000");

    -- Test of counter input
    -- Config all counters for 8 Hz
    sbwr( X"0600", X"0100" );
    sbwr( X"0620", X"0100" );
    sbwr( X"0640", X"0100" );
    
    for i in 0 to 20 loop
      sbrd_check( X"0600", X"0100" );
      sbrd_check( X"0610", X"0000" );
      sbrd_check( X"0612", X"0000" );
      sbrd_check( X"0614", X"0000" );
      sbrd_check( X"0616", X"0000" );
      sbrd_check( X"0618", X"0000" );
      sbrd_check( X"061A", X"0000" );
      sbrd_check( X"061C", X"0000" );
      sbrd_check( X"061E", X"0000" );
      
      sbrd_check( X"0620", X"0100" );
      sbrd_check( X"0630", X"0000" );
      sbrd_check( X"0632", X"0000" );
      sbrd_check( X"0634", X"0000" );
      sbrd_check( X"0636", X"0000" );
      sbrd_check( X"0638", X"0000" );
      sbrd_check( X"063A", X"0000" );
      sbrd_check( X"063C", X"0000" );
      sbrd_check( X"063E", X"0000" );

      sbrd_check( X"0640", X"0100" );
      sbrd_check( X"0650", X"0000" );
      sbrd_check( X"0652", X"0000" );
      sbrd_check( X"0654", X"0000" );
      sbrd_check( X"0656", X"0000" );
      sbrd_check( X"0658", X"0000" );
      sbrd_check( X"065A", X"0000" );
      sbrd_check( X"065C", X"0000" );
      sbrd_check( X"065E", X"0000" );
      wait for 125 ms;

    end loop;
    
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

