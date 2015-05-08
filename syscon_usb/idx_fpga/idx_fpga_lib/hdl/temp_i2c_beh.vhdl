--
-- VHDL Architecture idx_fpga_lib.temp_i2c.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 20:30:36 05/ 7/2015
--
-- using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

ENTITY temp_i2c IS
   PORT( 
      scl_pad_o    : IN     std_logic;
      scl_padoen_o : IN     std_logic;
      sda_pad_o    : IN     std_logic;
      sda_padoen_o : IN     std_logic;
      scl_pad_i    : OUT    std_logic;
      sda_pad_i    : OUT    std_logic;
      scl          : INOUT  std_logic;
      sda          : INOUT  std_logic
   );

-- Declarations

END temp_i2c ;

--
ARCHITECTURE beh OF temp_i2c IS
BEGIN
    
  sda_proc : Process (sda_padoen_o, sda_pad_o) IS
  Begin
    if sda_padoen_o = '0' then
      sda <= sda_pad_o;
    else
      sda <= 'Z';
    end if;
  End Process;
  sda_pad_i <= sda;

  scl_proc : Process (scl_padoen_o, scl_pad_o) IS
  Begin
    if scl_padoen_o = '0' then
      scl <= scl_pad_o;
    else
      scl <= 'Z';
    end if;
  End Process;
  scl_pad_i <= scl;

END ARCHITECTURE beh;

