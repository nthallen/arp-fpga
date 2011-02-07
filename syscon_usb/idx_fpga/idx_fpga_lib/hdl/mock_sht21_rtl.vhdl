--
-- VHDL Architecture idx_fpga_lib.mock_sht21.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:07:49 02/ 3/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY mock_sht21 IS
  PORT(
    scl_pad_i    : OUT   std_logic;
    scl_pad_o    : IN    std_logic;
    scl_padoen_o : IN    std_logic;
    sda_pad_i    : OUT   std_logic;
    sda_pad_o    : IN    std_logic;
    sda_padoen_o : IN    std_logic;
    CLK          : IN    std_ulogic;
    rst          : IN    std_ulogic
  );
END ENTITY mock_sht21;

--
ARCHITECTURE rtl OF mock_sht21 IS
   SIGNAL SCL : std_logic;
   SIGNAL SDA : std_logic;

   COMPONENT mock_sht21_sm
      PORT (
         CLK : IN     std_logic;
         SCL : IN     std_logic;
         rst : IN     std_logic;
         SDA : INOUT  std_logic
      );
   END COMPONENT;
   FOR ALL : mock_sht21_sm USE ENTITY idx_fpga_lib.mock_sht21_sm;
BEGIN


  SM : mock_sht21_sm
    PORT MAP (
       CLK => CLK,
       SCL => SCL,
       rst => rst,
       SDA => SDA
    );

  scl_ctrl : Process (scl_padoen_o, scl_pad_o) IS
  Begin
    if scl_padoen_o = '0' then
      SCL <= scl_pad_o;
    else
      SCL <= '1';
    end if;
  End Process;

  sda_ctrl : Process (sda_padoen_o, sda_pad_o) IS
  Begin
    if sda_padoen_o = '0' then
      SDA <= sda_pad_o;
    else
      SDA <= 'H';
    end if;
  End Process;

  scl_pad_i <= SCL;
  sda_pad_i <= SDA;
END ARCHITECTURE rtl;

