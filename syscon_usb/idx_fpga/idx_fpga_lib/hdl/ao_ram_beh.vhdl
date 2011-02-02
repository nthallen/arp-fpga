--
-- VHDL Architecture idx_fpga_lib.ao_ram.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:54:10 02/ 1/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ao_ram IS
   PORT( 
      Addr  : IN     std_logic_vector (15 DOWNTO 0);
      F8M   : IN     std_ulogic;
      RdEn  : IN     std_ulogic;
      WrEn  : IN     std_ulogic;
      rst   : IN     std_ulogic;
      iData : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END ao_ram ;

--
ARCHITECTURE beh OF ao_ram IS
  type ao_cache_t is array (15 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
  SIGNAL ao_cache : ao_cache_t;
BEGIN
  -- On reset, set array to zero
  -- On write, store value
  -- On read, report value
  WrSide : Process (F8M) Is
    VARIABLE cacheaddr : unsigned(3 DOWNTO 0);
  Begin
    if F8M'Event AND F8M = '1' then
      if rst = '1' then
        for i in 15 downto 0 loop
          ao_cache(i) <= (others => '0');
        end loop;
      elsif WrEn = '1' then
        for i in 3 downto 0 loop
          cacheaddr(i) := Addr(i+1);
        end loop;
        ao_cache(conv_integer(cacheaddr)) <= iData;
      end if;
    end if;
  End Process;
  
  RdWide : Process (F8M) Is
    VARIABLE cacheaddr : unsigned(3 DOWNTO 0);
  Begin
    if F8M'Event and F8M = '1' then
      if RdEn = '1' then
        for i in 3 downto 0 loop
          cacheaddr(i) := Addr(i+1);
        end loop;
        iData <= ao_cache(conv_integer(cacheaddr));
      else
        iData <= (others => 'Z');
      end if;
    end if;
  End Process;
    
END ARCHITECTURE beh;

