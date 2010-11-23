--
-- VHDL Architecture idx_fpga_lib.ctr_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:00:17 09/21/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ctr_addr IS
  GENERIC (
    BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
    N_COUNTERS : integer range 4 downto 4 := 4
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    StatEn : OUT std_ulogic;
    RevEn : OUT std_ulogic;
    CtrEn : OUT natural range N_COUNTERS-1 DOWNTO 0;
    CtrsEn : OUT std_ulogic;
    CtrEnHW : OUT std_ulogic;
    BdEn : OUT std_ulogic
  );
END ENTITY ctr_addr;

--
ARCHITECTURE beh OF ctr_addr IS
BEGIN
  addr_decode : Process (Addr)
    variable CtrEned : std_ulogic;
  begin
    CtrEn <= 0;
    CtrsEn <= '0';
    CtrEnHW <= '0';
    StatEn <= '0';
    RevEn <= '0';
    BdEn <= '0';
    CtrEned := '0';
    for Ctr_Num in 0 to N_COUNTERS-1 loop
      if unsigned(Addr(15 DOWNTO 1)) =
           unsigned(BASE_ADDRESS(15 DOWNTO 1)) + 8
            + Ctr_Num * 2 then
        CtrEn <= Ctr_Num;
        CtrsEn <= '1';
        CtrEnHW <= '0';
        CtrEned := '1';
      end if;
      if unsigned(Addr(15 DOWNTO 1)) =
           unsigned(BASE_ADDRESS(15 DOWNTO 1)) + 9
            + Ctr_Num * 2 then
        CtrEn <= Ctr_Num;
        CtrsEn <= '1';
        CtrEnHW <= '1';
        CtrEned := '1';
      end if;
    end loop;
    if Addr = BASE_ADDRESS then
      StatEn <= '1';
      CtrEned := '1';
    elsif unsigned(Addr) = unsigned(BASE_ADDRESS) + 2 then
      RevEn <= '1';
      CtrEned := '1';
    end if;
    BdEn <= CtrEned;
  end process;
  
END ARCHITECTURE beh;
