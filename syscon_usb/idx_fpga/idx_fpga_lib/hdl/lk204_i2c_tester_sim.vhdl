--
-- VHDL Architecture idx_fpga_lib.lk204_i2c_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:21:38 09/11/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY lk204_i2c_tester IS
   GENERIC( 
      N_ISBITS : integer range 8 downto 1 := 1
   );
   PORT( 
      Done     : IN     std_logic;
      Err      : IN     std_logic;
      I2Crdata : IN     std_logic_vector (7 DOWNTO 0);
      wdata    : IN     std_ulogic_vector (7 DOWNTO 0);
      wdata2   : IN     std_ulogic_vector (7 DOWNTO 0);
      En       : OUT    std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      F8M      : OUT    std_ulogic;
      I2Cwdata : OUT    std_logic_vector (7 DOWNTO 0);
      RdI2C    : OUT    std_logic;
      Rst      : OUT    std_logic;
      WrI2C    : OUT    std_logic;
      WrStart  : OUT    std_logic;
      WrStop   : OUT    std_logic;
      scl      : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda      : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );

-- Declarations

END lk204_i2c_tester ;

--
ARCHITECTURE sim OF lk204_i2c_tester IS
  SIGNAL SimDone : std_ulogic;
BEGIN

  clock : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while SimDone = '0' loop
      F8M <= '0';
      wait for 62 ns;
      F8M <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  test_proc : process is
  Begin
    SimDone <= '0';
    En <= (others => '1');
    I2Cwdata <= (others => '0');
    RdI2C <= '0';
    WrI2C <= '0';
    WrStart <= '0';
    WrStop <= '0';
    Rst <= '1';
    -- pragma synthesis_off
    wait until F8M'event AND F8M = '1';
    assert Done = '0'
      report "Done not clear on reset" severity error;
    Rst <= '0';
    wait until Done = '1';

    -- Initialize Keypad    
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"80";
    WrStart <= '1';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';
    
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"FE";
    WrStart <= '0';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';
    
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"4F";
    WrStart <= '0';
    WrStop <= '1';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';

    -- Poll Keypad   
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"80";
    WrStart <= '1';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';
    
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"FE";
    WrStart <= '0';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';
    
    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"26";
    WrStart <= '0';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1';

    wait until F8M'Event AND F8M = '1';
    I2Cwdata <= X"81";
    WrStart <= '1';
    WrStop <= '0';
    RdI2C <= '1';
    wait until Done = '0';
    RdI2C <= '0';
    wait until Done = '1';
    -- Check I2Crdata for result


    -- Poll Keypad   
    wait until F8M'Event AND F8M = '1';
    En <= (others => '0');
    I2Cwdata <= X"80";
    WrStart <= '1';
    WrStop <= '0';
    WrI2C <= '1';
    wait until Done = '0';
    WrI2C <= '0';
    wait until Done = '1' OR Err = '1';
    
    -- End of tests
    SimDone <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  sda <= ( others => 'H' );
  scl <= ( others => 'H' );
END ARCHITECTURE sim;

