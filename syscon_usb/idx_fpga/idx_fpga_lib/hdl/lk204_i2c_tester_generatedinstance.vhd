-- VHDL Entity idx_fpga_lib.lk204_i2c_tester.generatedInstance
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:57:00 09/10/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY lk204_i2c_tester IS
   PORT( 
      Done     : IN     std_logic;
      En       : OUT    std_logic;
      Err      : IN     std_logic;
      F8M      : OUT    std_ulogic;
      I2Crdata : IN     std_logic_vector (7 DOWNTO 0);
      I2Cwdata : OUT    std_logic_vector (7 DOWNTO 0);
      RdI2C    : OUT    std_logic;
      Rst      : OUT    std_logic;
      wdata    : IN     std_logic_vector (7 DOWNTO 0);
      wdata2   : IN     std_logic_vector (7 DOWNTO 0);
      WrI2C    : OUT    std_logic;
      WrStart  : OUT    std_logic;
      WrStop   : OUT    std_logic
   );

END lk204_i2c_tester ;

-- 
-- Auto generated dummy architecture for leaf level instance.
-- 
ARCHITECTURE generatedInstance OF lk204_i2c_tester IS 
BEGIN


END generatedInstance;
