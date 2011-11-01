--
-- VHDL Architecture idx_fpga_lib.i2c_half_switch.syn
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:42:51 11/ 1/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;

ENTITY i2c_half_switch IS
  GENERIC (
    N_ISBITS : integer range 20 downto 2 := 4
  );
  PORT( 
    En       : IN     std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
    pad_o    : IN     std_logic;
    padoen_o : IN     std_logic;
    pad_i    : OUT    std_logic;
    pad      : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
  );

-- Declarations

END i2c_half_switch ;

--
ARCHITECTURE syn OF i2c_half_switch IS
BEGIN
  ipad : Process (pad_o, padoen_o, En, pad) Is
  Begin
    pad_i <= '1';
    if padoen_o = '0' AND pad_o = '0' then
      pad_i <= '0';
    else
      for i in N_ISBITS-1 DOWNTO 0 loop
        if pad(i) = '0' then
          pad_i <= '0';
        end if;
      end loop;
    end if;
  End Process;
  
  opad : Process (pad_o, padoen_o, En) Is
  Begin
    for i in N_ISBITS-1 DOWNTO 0 loop
      if En(i) = '1' AND padoen_o = '0' AND pad_o = '0' then
        pad(i) <= '0';
      else
        pad(i) <= 'Z';
      end if;
    end loop;
  End Process;
  
END ARCHITECTURE syn;

