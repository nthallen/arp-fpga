--
-- VHDL Architecture idx_fpga_lib.decode.behavioral
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:35:21 12/ 9/2009
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decode IS
   GENERIC( 
      N_CHANNELS : integer range 15 DOWNTO 1 := 1
   );
   PORT( 
      Addr    : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd   : IN     std_ulogic;
      ExpWr   : IN     std_ulogic;
      F8M     : IN     std_ulogic;
      rst     : IN     std_ulogic;
      ExpAck  : OUT    std_ulogic;
      WrEn    : OUT    std_ulogic;
      BdIntr  : OUT    std_ulogic;
      Chan    : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Running : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      Ireq    : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd    : OUT    std_logic_vector (2 DOWNTO 0);
      Data    : INOUT  std_logic_vector (15 DOWNTO 0);
      iData   : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn    : OUT    std_ulogic;
      F4M     : OUT    std_ulogic
   );
   -- Data is the external data bus
   -- iData is the internal data bus that goes to the channels
   -- Addr,ExpRd,ExpWr,ExpAck all external.
   -- RdEn, WrEn are our qualified versions
   -- Chan is a vector of enable lines for the channels
   -- OpCd is the low order 3 bits of Addr

-- Declarations

END decode ;

--
ARCHITECTURE behavioral OF decode IS
  SIGNAL Wrote : std_ulogic;
  SIGNAL F4M_int : std_ulogic;
  SIGNAL Chan_sel : std_ulogic;
  SIGNAL Chan_int : std_ulogic_vector(15 DOWNTO 0);
  SIGNAL Base_int : std_ulogic;
  SIGNAL RdEn_int : std_ulogic;
  SIGNAL WrEn_int : std_ulogic;
  SIGNAL Intr_En : std_ulogic;
BEGIN
  process (Addr) is
    Variable Chan_num : unsigned(3 DOWNTO 0);
  begin
    Base_int <= '0';
    Chan_sel <= '0';
    Chan_int <= (others => '0');
    if Addr = X"0A00" then
      Base_int <= '1';
    elsif Addr(15 DOWNTO 7) = B"000010100" and Addr(0) = '0' then
      Chan_num := unsigned(Addr(6 DOWNTO 3));
      if Chan_num > 0 and Chan_num <= N_CHANNELS then
        Chan_sel <= '1';
        Chan_int(to_integer(Chan_num)) <= '1';
      end if;
    end if;
    OpCd <= Addr(2 DOWNTO 0);
  end process;

  f4m_clk : Process (F8M, rst, F4M_int)
  Begin
    if rst = '1' then
      F4M_int <= '0';
    elsif F8M'Event and F8M = '1' then
      F4M_int <= not F4M_int;
    end if;
    F4M <= F4M_int;
  End Process;
  
  -- WrEn_int does not need to be qualified with ExpAck because there
  -- are function-specific enables downstream.
  WrEnbl : Process (F8M) Is
  Begin
    if F8M'Event and F8M = '1' then
      if ExpWr = '1' then
        if Wrote = '1' then
          WrEn_int <= '0';
        else
          WrEn_int <= '1';
          Wrote <= '1';
        end if;
      else
        WrEn_int <= '0';
        Wrote <= '0';
      end if;
    end if;
  End Process;
   
  Ack : process ( F8M ) is
  begin
    if F8M'event and F8M = '1' then
      if (Chan_sel = '1' or Base_int = '1') then
        if ExpRd = '1' then
          RdEn_int <= '1';
          ExpAck <= '1';
        elsif ExpWr = '1' then
          RdEn_int <= '0';
          ExpAck <= '1';
        else
          RdEn_int <= '0';
          ExpAck <= '0';
        end if;
      else
        RdEn_int <= '0';
        ExpAck <= '0';
      end if;
    end if;
  end process;
  
  DataBus : process (F8M) is
  begin
    if F8M'event and F8M = '1' then
      if rst = '1' then
        iData <= (others => 'Z');
        Data <= (others => 'Z');
      elsif ExpRd = '1' and (Chan_sel = '1' or Base_int = '1' ) then
        if RdEn_int = '0' then
          iData <= (others => 'Z');
          Data <= (others => 'Z');
        elsif Base_int = '1' then
          Data(15 DOWNTO N_CHANNELS) <= ( others => '0' );
          Data(N_CHANNELS-1 DOWNTO 0) <= To_StdLogicVector(Running);
        else
          Data <= iData;
        end if;
      elsif RdEn_int = '1' then
        Data <= ( others => 'Z' );
        iData <= ( others => 'Z' );
      else
        iData <= Data;
      end if;

      Chan <= Chan_int(N_CHANNELS DOWNTO 1);
    end if;
  end process;
  
  Interrupt : process (F8M) is
    Variable intr_int: std_ulogic;
  begin
    if F8M'event and F8M = '1' then
      if rst = '1' then
        Intr_En <= '0';
      elsif WrEn_int = '1' and Addr = X"0A00" then
        Intr_En <= Data(5);
      end if;
      intr_int := '0';
      if Intr_En = '1' then
        for i in N_CHANNELS-1 DOWNTO 0 loop
          if Ireq(i) = '1' then
            intr_int := '1';
          end if;
        end loop;
      end if;
      BdIntr <= intr_int;
    end if;
  end process;

  RdEn <= RdEn_int;
  WrEn <= WrEn_int;
      
END ARCHITECTURE behavioral;

