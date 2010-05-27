--
-- VHDL Architecture idx_fpga_lib.syscon.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:59:01 05/26/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY syscon IS
  PORT (
    F8M : IN std_ulogic;
    Ctrl : IN std_ulogic_vector (1 DOWNTO 0); -- Wr,Rd
    Addr : IN std_ulogic_vector (15 DOWNTO 0);
    Data : INOUT std_logic_vector (15 DOWNTO 0);
    Status : OUT std_ulogic_vector (1 DOWNTO 0); -- Ack,Done
    ExpRd : OUT std_ulogic;
    ExpWr : OUT std_ulogic;
    ExpData : INOUT std_logic_vector (15 DOWNTO 0);
    ExpAddr : OUT std_ulogic_vector (15 DOWNTO 0);
    ExpAck : IN std_logic
  );
END ENTITY syscon;

--
ARCHITECTURE arch OF syscon IS
  SIGNAL DataIn : std_logic_vector (15 DOWNTO 0);
  SIGNAL Cnt : std_logic_vector (3 DOWNTO 0);
  SIGNAL Active : std_ulogic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias Done is Status(0);
  alias Ack is Status(1);
BEGIN
  rdwr : process (F8M) IS
  begin
    if F8M'Event and F8M = '1' then
      if Ctrl = "00" then
        ExpRd <= '0';
        ExpWr <= '0';
        ExpData <= (others => 'Z');
        Cnt <= "0000";
        Active <= '0';
        Done <= '0';
        Ack <= '0';
      elsif Active = '0' then
        if Ctrl = "01" or Ctrl = "10" then
          ExpRd <= RdEn;
          ExpWr <= WrEn;
          Active <= '1';
          Cnt <= X"7";
          if Ctrl(1) = '1' then
            ExpData <= Data;
          else
            ExpData <= (others => 'Z');
          end if;
        end if;
      elsif Active = '1' then
        if Cnt = "0000" then
          Done <= '1';
          ExpRd <= '0';
          ExpWr <= '0';
          ExpData <= (others => 'Z');
        else
          Cnt <= Cnt - 1;
          Ack <= ExpAck;
          if Ctrl(0) = '1' then
            DataIn <= ExpData;
          end if;
        end if;
      end if;
    end if;
  end process;
  
  dbus : process (F8M) is
  begin
    if F8M'Event and F8M = '1' then
      if Ctrl(0) = '1' then
        Data <= DataIn;
      else
        Data <= (others => 'Z');
      end if;
    end if;
  end process;
  
  ExpAddr <= Addr;
  
END ARCHITECTURE arch;
