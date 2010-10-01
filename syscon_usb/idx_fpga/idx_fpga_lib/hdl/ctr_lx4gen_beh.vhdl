--
-- VHDL Architecture idx_fpga_lib.ctr_lx4gen.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:07:40 10/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ctr_lx4gen IS
  GENERIC (
    PRE_DIVISOR : unsigned (19 DOWNTO 0) := X"1E848"
  );
  PORT (
    F8M : IN std_ulogic;
    Divisor : IN unsigned (3 DOWNTO 0);
    rst : IN std_ulogic;
    Lx4En : OUT std_ulogic
  );
END ENTITY ctr_lx4gen;

--
ARCHITECTURE beh OF ctr_lx4gen IS
  SIGNAL PreCount : unsigned (16 DOWNTO 0);
  SIGNAL TrimCount : unsigned (3 DOWNTO 0);
  SIGNAL PreTC : std_ulogic;
BEGIN
  PreDiv : Process (F8M) is
    Variable TC : std_ulogic;
  Begin
    if F8M'Event AND F8M = '1' then
      if rst = '1' then
        PreCount <= (others => '0');
        PreTC <= '0';
      else
        TC := '1';
        for i in 0 to 16 loop
          if PreCount(i) = '1' then
            TC := '0';
          end if;
        end loop;
        if TC = '1' then
          PreCount <= PRE_DIVISOR(16 DOWNTO 0);
          PreTC <= '1';
        else
          PreCount <= PreCount - 1;
          PreTC <= '0';
        end if;
      end if;
    end if;
  End Process;

  TrimDiv : Process (F8M) is
  Begin
    if F8M'Event AND F8M = '1' then
      if rst = '1' then
        TrimCount <= (others => '0');
        Lx4En <= '0';
      elsif PreTC = '1' then
        if std_logic_vector(TrimCount) = X"0" then
          TrimCount <= Divisor;
          Lx4En <= '1';
        else
          TrimCount <= TrimCount - 1;
          Lx4En <= '0';
        end if;
      end if;
    end if;
  End Process;
  
END ARCHITECTURE beh;

