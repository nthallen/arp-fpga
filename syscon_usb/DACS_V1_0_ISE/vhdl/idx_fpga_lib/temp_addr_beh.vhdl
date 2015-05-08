--
-- VHDL Architecture idx_fpga_lib.temp_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 10:05:19 05/ 7/2015
--
-- using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
--
-- Acknowledge 6*3 addresses, but require sequential reading
-- within a specific sensor.
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY temp_addr IS
   GENERIC( 
      BASE_ADDR : std_logic_vector (15 DOWNTO 0)
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_logic;
      F8M    : IN     std_logic;
      rst    : IN     std_logic;                       -- sync high
      BdEn   : OUT    std_ulogic;
      Sensor : OUT    std_logic_vector (2 DOWNTO 0);
      Word   : OUT    std_logic_vector (1 DOWNTO 0)
   );

-- Declarations

END temp_addr ;

--
ARCHITECTURE beh OF temp_addr IS
  SIGNAL Cur_Sensor : std_logic_vector(2 DOWNTO 0);
  SIGNAL Pos_Sensor : std_logic_vector(2 DOWNTO 0);
  SIGNAL Pos_Word : std_logic_vector(1 DOWNTO 0);
  SIGNAL BdEn_int : std_logic;
BEGIN
  BE : Process (Addr) BEGIN
    BdEn <= '0';
    IF Addr >= BASE_ADDR THEN
      for i in 0 to 5 loop
        if Addr = BASE_ADDR + i*6 THEN
          BdEn_int <= '1';
          Pos_Sensor <= i;
          Pos_Word <= "00";
        elsif Addr = BASE_ADDR + i*6 + 2 AND Cur_Sensor = i THEN
          BdEn_int <= '1';
          Pos_Sensor <= i;
          Pos_Word <= "01";
        elsif Addr = BASE_ADDR + i*6 + 4 AND Cur_Sensor = i THEN
          BdEn_int <= '1';
          Pos_Sensor <= i;
          Pos_Word <= "10";
        end if;
      end loop;
    END IF;
  END Process;
  
  CS : Process (F8M) BEGIN
    IF F8M'event AND F8M = '1' THEN
      IF rst = '1' THEN
        Cur_Sensor <= "111"; -- not a valid sensor
      ELSIF ExpRd = '1' AND BdEn_int = '1' THEN
        Cur_Sensor <= Pos_Sensor;
        Word <= Pos_Word;
      END IF;
    END IF;
  END Process;
  
  BdEn <= BdEn_int;
  Sensor <= Cur_Sensor;
END ARCHITECTURE beh;

