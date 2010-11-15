--
-- VHDL Architecture idx_fpga_lib.DigIO_Addr.beh
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

ENTITY DigIO_Addr IS
  GENERIC (
    BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
    N_CONNECTORS : integer range 4 DOWNTO 1 := 2
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    ConnEn : OUT std_ulogic_vector (N_CONNECTORS-1 DOWNTO 0);
    PortEnLB : OUT std_ulogic_vector (3 DOWNTO 0);
    PortEnHB : OUT std_ulogic_vector (3 DOWNTO 0);
    RS : OUT std_ulogic;
    BdEn : OUT std_ulogic;
    F8M : IN std_ulogic
  );
END ENTITY DigIO_Addr;

--
ARCHITECTURE beh OF DigIO_Addr IS
  SIGNAL PortEnLB_i : std_ulogic_vector (3 DOWNTO 0);
  SIGNAL PortEnHB_i : std_ulogic_vector (3 DOWNTO 0);
  SIGNAL ConnEn_i : std_ulogic_vector( N_CONNECTORS-1 DOWNTO 0);
  SIGNAL RS_i : std_ulogic;
  alias Port1 is PortEnLB_i(0);
  alias Port3 is PortEnLB_i(1);
  alias Port5 is PortEnLB_i(2);
  alias CfgLB is PortEnLB_i(3);
  alias Port2 is PortEnHB_i(0);
  alias Port4 is PortEnHB_i(1);
  alias Port6 is PortEnHB_i(2);
  alias CfgHB is PortEnHB_i(3);
BEGIN
  addr_decode : Process (Addr)
    variable ConnEned : std_ulogic;
    variable PortEned : std_ulogic;
  begin
    ConnEn_i <= ( others => '0');
    PortEnLB_i <= ( others => '0');
    PortEnHB_i <= ( others => '0');
    RS_i <= '0';
    ConnEned := '0';
    PortEned := '0';
    for Conn_Num in 0 to N_CONNECTORS-1 loop
      if unsigned(Addr(15 DOWNTO 5)) =
           unsigned(BASE_ADDRESS(15 DOWNTO 5))
            + Conn_Num then
        ConnEn_i(Conn_Num) <= '1';
        ConnEned := '1';
      end if;
    end loop;
    case Addr(4 DOWNTO 1) is
      when "0000" =>
        Port1 <= '1';
        Port2 <= '1';
        PortEned := '1';
      when "0001" =>
        Port3 <= '1';
        Port4 <= '1';
        PortEned := '1';
      when "0010" =>
        Port5 <= '1';
        Port6 <= '1';
        PortEned := '1';
      when "0011" =>
        CfgLB <= '1';
        CfgHB <= '1';
        PortEned := '1';
      when "0100" =>
        Port1 <= '1';
        PortEned := '1';
      when "0101" =>
        Port3 <= '1';
        PortEned := '1';
      when "0110" =>
        Port5 <= '1';
        PortEned := '1';
      when "0111" =>
        CfgLB <= '1';
        PortEned := '1';
      when "1000" =>
        Port2 <= '1';
        PortEned := '1';
      when "1001" =>
        Port4 <= '1';
        PortEned := '1';
      when "1010" =>
        Port6 <= '1';
        PortEned := '1';
      when "1011" =>
        CfgHB <= '1';
        PortEned := '1';
      when "1100" =>
        RS_i <= '1';
        PortEned := '1';
      when "1101" =>
        -- CfgCN <= '1';
        -- We'll ack, but nothing to do
        PortEned := '1';
      when others =>
    end case;
    BdEn <= PortEned AND ConnEned;
  end process;
  
  clocked: Process (F8M)
  BEGIN
    if F8M'EVENT AND F8M = '1' THEN
      ConnEn <= ConnEn_i;
      PortEnLB <= PortEnLB_i;
      PortEnHB <= PortEnHB_i;
      RS <= RS_i;
    end if;
  End Process;
END ARCHITECTURE beh;
