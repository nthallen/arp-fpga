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
  SIGNAL Addr_int : std_logic_vector(15 DOWNTO 0);
  SIGNAL Ctrl_int : std_logic_vector (5 DOWNTO 0); -- Tick, Rst, CE,CS,Wr,Rd
  SIGNAL Cnt : std_logic_vector (3 DOWNTO 0);
  SIGNAL INTA_int : std_ulogic;
  SIGNAL Done_int : std_ulogic;
  SIGNAL Ack_int : std_ulogic;
  SIGNAL Start : std_ulogic;
  SIGNAL TwoMinuteTO : std_ulogic;
  TYPE STATE_TYPE IS ( s0, s1i, s1r, s1w, s2 );
  SIGNAL current_state : STATE_TYPE;
  TYPE DSTATE_TYPE IS ( d0, d1, d2, d3 );
  SIGNAL dcnt_state : DSTATE_TYPE;

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
  alias RdEn is Ctrl_int(0);
  alias WrEn is Ctrl_int(1);
  alias CS is Ctrl_int(2);
  alias CE is Ctrl_int(3);
  alias rst is Ctrl_int(4);
  alias TickTock is Ctrl_int(5);
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

  ExpAddrDataBus : process (F8M) is
  begin
    if F8M'Event and F8M = '1' then
      if RdEn = '1' then
        ExpData <= (others => 'Z');
      else
        ExpData <= Data_o;
      end if;
      Addr_int <= Addr;
      Ctrl_int <= Ctrl;
    end if;
  end process;
  
  intr : process (F8M) is
    Variable intr_int: std_ulogic;
  begin
    if F8M'Event and F8M = '1' then
      intr_int := '0';
      for i in N_INTERRUPTS-1 DOWNTO 0 loop
        if BdIntr(i) = '1' then
          intr_int := '1';
        end if;
      end loop;
      ExpIntr <= intr_int;
    end if;
  end process;
  
  -- ExpAck is not qualified here by RdEn or WrEn, because it
  -- should be qualified downstream.
  ackr : process (ExpAck, INTA_int) is
    Variable ack_i: std_ulogic;
  begin
    ack_i := INTA_int;
    for i in N_BOARDS-1 DOWNTO 0 loop
      if ExpAck(i) = '1' then
        ack_i := '1';
      end if;
    end loop;
    Ack_int <= ack_i;
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
  CmdStrb <= CS;
  ExpReset <= rst;
  ExpAddr <= Addr_int;
  INTA <= INTA_int;
  Done <= Done_int;

  -- outputs ExpRd, INTA_int, ExpWr, Ack, DataIn, Start
  clocked_proc : PROCESS ( F8M )
  BEGIN
    IF (F8M'EVENT AND F8M = '1') THEN
      if rst = '1' then
        current_state <= s0;
        Start <= '0';
        Ack <= '0';
        ExpRd <= '0';
        ExpWr <= '0';
        INTA_int <= '0';
      else
        CASE current_state IS
          WHEN s0 =>
            if RdEn = '1' AND WrEn = '0' AND Addr_int = X"0040" then
              current_state <= s1i;
              INTA_int <= '1';
              Start <= '1';
            elsif RdEn = '1' AND WrEn = '0' then
              current_state <= s1r;
              ExpRd <= '1';
              Start <= '1';
            elsif RdEn = '0' AND WrEn = '1' then
              current_state <= s1w;
              ExpWr <= '1';
              Start <= '1';
            else
              Start <= '0';
              Ack <= '0';
              ExpRd <= '0';
              ExpWr <= '0';
              INTA_int <= '0';
            end if;
          WHEN s1i =>
            if Done_int = '1' then
              current_state <= s2;
              INTA_int <= '0';
            else
              Ack <= ack_int;
              DataIn(15 downto N_INTERRUPTS) <= ( others => '0' );
              DataIn(N_INTERRUPTS-1 downto 0) <= To_StdLogicVector(BdIntr);
            end if;
          WHEN s1r =>
            if Done_int = '1' then
              current_state <= s2;
              ExpRd <= '0';
            else
              Ack <= ack_int;
              DataIn <= ExpData;
            end if;
          WHEN s1w =>
            if Done_int = '1' then
              current_state <= s2;
              ExpWr <= '0';
            else
              Ack <= ack_int;
            end if;
          WHEN s2 =>
            if RdEn = '0' AND WrEn = '0' then
              current_state <= s0;
              Start <= '0';
              Ack <= '0';
            end if;
          WHEN OTHERS =>
            current_state <= s0;
        END CASE;
      end if;
    end if;
  END PROCESS;

  -- outputs Done_int
  dclocked_proc : PROCESS ( F8M )
  BEGIN
    IF (F8M'EVENT AND F8M = '1') THEN
      if rst = '1' then
        dcnt_state <= d0;
        Done_int <= '0';
      else
        CASE dcnt_state IS
          WHEN d0 =>
            if Start = '1' then
              Cnt <= X"5";
              dcnt_state <= d1;
            end if;
          WHEN  d1 =>
            if Cnt = X"0" then
              dcnt_state <= d2;
              Done_int <= '1';
            else
              Cnt <= Cnt - 1;
            end if;
          WHEN  d2 =>
            if RdEn = '0' AND WrEn = '0' then
              dcnt_state <= d0;
              Done_int <= '0';
            end if;
          WHEN others =>
            dcnt_state <= d0;
        END CASE;
      end if;
    end if;
  END PROCESS;

END ARCHITECTURE arch;
