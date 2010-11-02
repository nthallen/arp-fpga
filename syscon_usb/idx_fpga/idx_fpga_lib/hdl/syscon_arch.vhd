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
LIBRARY idx_fpga_lib;

ENTITY syscon IS
  GENERIC(
    N_INTERRUPTS : integer range 15 downto 0 := 1;
    N_BOARDS : integer range 15 downto 0 := 1
  );
  PORT (
    F8M : IN std_logic;
    Ctrl : IN std_logic_vector (5 DOWNTO 0); -- Tick, Rst, CE,CS,Wr,Rd
    Addr : IN std_logic_vector (15 DOWNTO 0);
    Data_i : OUT std_logic_vector (15 DOWNTO 0);
    Data_o : IN std_logic_vector (15 DOWNTO 0);
    Status : OUT std_logic_vector (3 DOWNTO 0); -- 2SecTO, ExpIntr,Ack,Done
    ExpRd : OUT std_logic;
    ExpWr : OUT std_logic;
    ExpData : INOUT std_logic_vector (15 DOWNTO 0);
    ExpAddr : OUT std_logic_vector (15 DOWNTO 0);
    ExpAck : IN std_logic_vector (N_BOARDS-1 DOWNTO 0);
    BdIntr : IN std_ulogic_vector(N_INTERRUPTS-1 downto 0);
    INTA    : OUT std_ulogic;
	  CmdEnbl : OUT std_ulogic;
	  CmdStrb : OUT std_ulogic;
	  ExpReset : OUT std_ulogic;
	  Fail_In : IN std_ulogic;
	  Fail_Out : OUT std_ulogic
  );
END ENTITY syscon;

--
ARCHITECTURE arch OF syscon IS
  SIGNAL DataIn : std_logic_vector (15 DOWNTO 0);
  SIGNAL Cnt : std_logic_vector (3 DOWNTO 0);
  SIGNAL INTA_int : std_ulogic;
  SIGNAL Active : std_ulogic;
  SIGNAL TwoMinuteTO : std_ulogic;
  COMPONENT syscon_tick
     GENERIC (
        DEBUG_MULTIPLIER : integer := 100
     );
     PORT (
        TickTock    : IN     std_ulogic;
        CmdEnbl_cmd : IN     std_ulogic;
        CmdEnbl     : OUT    std_ulogic;
        TwoSecondTO : OUT    std_ulogic;
        TwoMinuteTO : OUT    std_ulogic;
        F8M         : IN     std_ulogic
     );
  END COMPONENT;
  FOR ALL : syscon_tick USE ENTITY idx_fpga_lib.syscon_tick;
  alias RdEn is Ctrl(0);
  alias WrEn is Ctrl(1);
  alias CS is Ctrl(2);
  alias CE is Ctrl(3);
  alias rst is Ctrl(4);
  alias TickTock is Ctrl(5);
  alias Done is Status(0);
  alias Ack is Status(1);
  alias ExpIntr is Status(2);
  alias TwoSecondTO is Status(3);
BEGIN

  Tick : syscon_tick
    GENERIC MAP (
      DEBUG_MULTIPLIER => 100
    )
    PORT MAP (
      TickTock    => TickTock,
      CmdEnbl_cmd => CE,
      CmdEnbl     => CmdEnbl,
      TwoSecondTO => TwoSecondTO,
      TwoMinuteTO => TwoMinuteTO,
      F8M         => F8M
    );

  rdwr : process (F8M) IS
    Variable intr_int: std_ulogic;
    Variable ack_int: std_ulogic;
  begin
    if F8M'Event and F8M = '1' then
      if RdEn = '0' and WrEn = '0' then
        ExpRd <= '0';
        ExpWr <= '0';
        INTA_int  <= '0';
        ExpData <= Data_o;
        Cnt <= "0000";
        Active <= '0';
        Done <= '0';
		    DataIn <= (others => '0');
        Ack <= '0';
      elsif Active = '0' then
        if RdEn = '1' xor WrEn = '1' then -- exactly one
          if RdEn = '1' and Addr = X"0040" then
            INTA_int <= '1';
            ExpRd <= '0';
          else
            ExpRd <= RdEn;
          end if;
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
          INTA_int <= '0';
          --ExpData <= (others => 'Z');
        else
          Cnt <= Cnt - 1;
          ack_int := INTA_int;
          for i in N_BOARDS-1 DOWNTO 0 loop
            if ExpAck(i) = '1' then
              ack_int := '1';
            end if;
          end loop;
          Ack <= ack_int;
          if RdEn = '1' then
            if INTA_int = '1' then
              DataIn(15 downto N_INTERRUPTS) <= ( others => '0' );
              DataIn(N_INTERRUPTS-1 downto 0) <= To_StdLogicVector(BdIntr);
            else
              DataIn <= ExpData;
            end if;
          end if;
        end if;
      end if;
      
      intr_int := '0';
      for i in N_INTERRUPTS-1 DOWNTO 0 loop
        if BdIntr(i) = '1' then
          intr_int := '1';
        end if;
      end loop;
      ExpIntr <= intr_int;
    end if;
  end process;
  
  Failer : Process (Fail_In, TwoMinuteTO) IS
  Begin
    if Fail_In = '1' OR TwoMinuteTO = '1' then
      Fail_Out <= '1';
    else
      Fail_Out <= '0';
    end if;
  End Process;

  Data_i <= DataIn;
  ExpAddr <= Addr;
  CmdStrb <= CS;
  ExpReset <= rst;
  INTA <= INTA_int;

END ARCHITECTURE arch;
