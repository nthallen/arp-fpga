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
      N_CHANNELS : integer range 15 downto 1 := 1
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      BaseEn : OUT    std_ulogic;
      INTA   : OUT    std_ulogic;
      Chan   : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd   : OUT    std_logic_vector (2 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn   : OUT    std_ulogic;
      F4M    : OUT    std_ulogic
   );

-- Declarations

END decode ;

--
ARCHITECTURE behavioral OF decode IS
  SIGNAL Wrote : std_ulogic;
  SIGNAL F4M_int : std_ulogic;
  SIGNAL Chan_sel : std_ulogic;
  SIGNAL Chan_int : std_ulogic_vector(15 downto 0);
  SIGNAL Base_int : std_ulogic;
  SIGNAL INTA_int : std_ulogic;
  SIGNAL RdEn_int : std_ulogic;
BEGIN
  process (Addr) is
    Variable Chan_num : unsigned(3 downto 0);
  begin
    INTA_int <= '0';
    Base_int <= '0';
    Chan_sel <= '0';
    Chan_int <= (others => '0');
    if Addr = X"0040" then
      INTA_int <= '1';
    elsif Addr = X"0A00" then
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
  
  -- WrEn does not need to be qualified with ExpAck because there
  -- are function-specific enables downstream.
  WrEnbl : Process (F8M) Is
  Begin
    if F8M'Event and F8M = '1' then
      if ExpWr = '1' then
        if Wrote = '1' then
          WrEn <= '0';
        else
          WrEn <= '1';
          Wrote <= '1';
        end if;
      else
        WrEn <= '0';
        Wrote <= '0';
      end if;
    end if;
  End Process;
   
  Ack : process ( F8M ) is
  begin
    if F8M'event and F8M = '1' then
      if (Chan_sel = '1' or INTA_int = '1' or Base_int = '1') then
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
      elsif ExpRd = '1' and (Chan_sel = '1' or INTA_int = '1' or Base_int = '1' ) then
        if RdEn_int = '0' then
          iData <= (others => 'Z');
          Data <= (others => 'Z');
        else
          --iData <= (others => 'Z');
          Data <= iData;
        end if;
      elsif RdEn_int = '1' then
        Data <= ( others => 'Z' );
        iData <= ( others => 'Z' );
      else
        --Data <= ( others => 'Z' );
        iData <= Data;
      end if;
      BaseEn <= Base_int;
      INTA <= INTA_int;
      Chan <= Chan_int(N_CHANNELS downto 1);
    end if;
  end process;

  RdEn <= RdEn_int;
      
END ARCHITECTURE behavioral;

