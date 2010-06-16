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
    F8M : IN std_logic;
    Ctrl : IN std_logic_vector (4 DOWNTO 0); -- Rst, CE,CS,Wr,Rd
    Addr : IN std_logic_vector (15 DOWNTO 0);
    Data_i : OUT std_logic_vector (15 DOWNTO 0);
    Data_o : IN std_logic_vector (15 DOWNTO 0);
    Status : OUT std_logic_vector (1 DOWNTO 0); -- Ack,Done
    ExpRd : OUT std_logic;
    ExpWr : OUT std_logic;
    ExpData : INOUT std_logic_vector (15 DOWNTO 0);
    ExpAddr : OUT std_logic_vector (15 DOWNTO 0);
    ExpAck : IN std_logic;
	 CmdEnbl : OUT std_ulogic;
	 CmdStrb : OUT std_ulogic;
	 ExpReset : OUT std_ulogic
  );
END ENTITY syscon;

--
ARCHITECTURE arch OF syscon IS
  SIGNAL DataIn : std_logic_vector (15 DOWNTO 0);
  SIGNAL Cnt : std_logic_vector (3 DOWNTO 0);
  SIGNAL Active : std_ulogic;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias Done is Status(0);
  alias Ack is Status(1);
BEGIN
  rdwr : process (F8M) IS
  begin
    if F8M'Event and F8M = '1' then
      if RdEn = '0' and WrEn = '0' then
        ExpRd <= '0';
        ExpWr <= '0';
        ExpData <= Data_o;
        Cnt <= "0000";
        Active <= '0';
        Done <= '0';
		    DataIn <= (others => '0');
        Ack <= '0';
      elsif Active = '0' then
        if RdEn = '1' xor WrEn = '1' then -- exactly one
          ExpRd <= RdEn;
          ExpWr <= WrEn;
          Active <= '1';
          Cnt <= X"7";
          if RdEn = '1' then
            ExpData <= (others => 'Z');
          end if;
        end if;
      elsif Active = '1' then
        if Cnt = "0000" then
          Done <= '1';
          ExpRd <= '0';
          ExpWr <= '0';
          --ExpData <= (others => 'Z');
        else
          Cnt <= Cnt - 1;
          Ack <= ExpAck;
          if RdEn = '1' then
            DataIn <= ExpData;
          end if;
        end if;
      end if;
    end if;
  end process;

  Data_i <= DataIn;
  ExpAddr <= Addr;
  CmdEnbl <= CE;
  CmdStrb <= CS;
  ExpReset <= rst;
  
END ARCHITECTURE arch;
