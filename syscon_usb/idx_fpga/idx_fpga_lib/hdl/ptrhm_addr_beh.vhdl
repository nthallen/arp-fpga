--
-- VHDL Architecture idx_fpga_lib.ptrhm_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:49:22 11/ 1/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
-- LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ptrhm.all;
-- USE idx_fpga_lib.All;

ENTITY ptrhm_addr IS
  GENERIC (
    BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"0300";
    -- Extending N_PTRH beyond 8 requires changes below
    N_PTRH : integer range 8 downto 2 := 2
  );
  PORT( 
    Addr   : IN     std_logic_vector (15 DOWNTO 0);
    BdEn   : OUT    std_ulogic;
    PTRHEn : OUT    std_ulogic_vector (N_PTRH-1 DOWNTO 0);
    RegEn  : OUT    std_ulogic_vector (12 DOWNTO 0)
  );

-- Declarations

END ptrhm_addr ;

--
ARCHITECTURE beh OF ptrhm_addr IS
Begin
  decode : Process (Addr) Is
    Variable RegSelected : std_ulogic;
    Variable PTRHSelected : std_ulogic;
  Begin
    BdEn <= '0';
    RegEn <= (others => '0');
    PTRHEn <= (others => '0');
    RegSelected := '0';
    PTRHSelected := '0';
    if Addr(15 DOWNTO 8) = BASE_ADDR(15 DOWNTO 8) then
      for i in 0 TO N_PTRH-1 loop
        if Addr(7 DOWNTO 5) = CONV_STD_LOGIC_VECTOR(i,3) then
          PTRHEn(i) <= '1';
          PTRHSelected := '1';
        end if;
      end loop;
      for i in 0 TO 12 loop
        if Addr(4 DOWNTO 1) = CONV_STD_LOGIC_VECTOR(i,4) then
          RegEn(i) <= '1';
          RegSelected := '1';
        end if;
      end loop;
    end if;
    if RegSelected = '1' AND PTRHSelected = '1' then
      BdEn <= '1';
    else
      BdEn <= '0';
    end if;
  End Process;
END ARCHITECTURE beh;

