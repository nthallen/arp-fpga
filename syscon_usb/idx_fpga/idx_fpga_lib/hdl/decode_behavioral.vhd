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
   GENERIC ( N_CHANNELS : positive );
   PORT( 
      Addr   : IN     std_ulogic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_ulogic;
      rst    : IN     std_ulogic;
      ExpAck : OUT    std_ulogic;
      WrEn   : OUT    std_ulogic;
      BaseEn : OUT    std_ulogic;
      INTA   : OUT    std_ulogic;
      Chan   : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
      OpCd   : OUT    std_ulogic_vector (2 DOWNTO 0);
      Data   : INOUT  std_logic_vector (15 DOWNTO 0);
      iData  : INOUT  std_logic_vector (15 DOWNTO 0);
      RdEn   : OUT    std_ulogic;
      F4M    : OUT    std_ulogic
   );

-- Declarations

END decode ;

--
ARCHITECTURE behavioral OF decode IS
  subtype Chan_t is integer range 0 to N_CHANNELS;
  SIGNAL Wrote : std_ulogic;
  SIGNAL F4M_int : std_ulogic;
  SIGNAL ACK_int : std_ulogic;
  SIGNAL Chan_vec : std_ulogic_vector (Chan_t);
  SIGNAL Chan_num : Chan_t;
  SIGNAL Chan_sel : std_ulogic;
BEGIN
  process (Addr) is
  begin
    INTA <= '0';
    BaseEn <= '0';
    Chan_num <= 0;
    if Addr = X"0040" then
      INTA <= '1';
    elsif Addr = X"0A00" then
      BaseEn <= '1';
    elsif Addr(15 DOWNTO 7) = B"000010100" and Addr(0) = '0' then
      Chan_num <= to_integer(Addr(6 DOWNTO 3));
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
  
  Chan_En : Process (Chan_num) Is
  begin
    Chan_vec <= (others => '0');
    Chan_sel <= '0';
    if Chan_num /= 0 and Chan_num <= N_CHANNELS then
      Chan_vec(Chan_num) <= '1';
      Chan_sel <= '1';
    end if;
  end process;
  
  Chan_out : Process (Chan_vec) Is
  begin
    Chan <= Chan_vec(Chan_vec'high downto 1);
  end process;
   
  Ack : process ( F8M ) is
  begin
    if F8M'event and F8M = '1' then
      if (Chan_sel = '1' or INTA = '1' or BaseEn = '1') then
        if ExpRd = '1' then
          RdEn <= '1';
          ExpAck <= '1';
        elsif ExpWr = '1' then
          RdEn <= '0';
          ExpAck <= '1';
        else
          RdEn <= '0';
          ExpAck <= '0';
        end if;
      else
        RdEn <= '0';
        ExpAck <= '0';
      end if;
    end if;
  end process;
  
  DataBus : process (F8M) is
  begin
    if F8M'event and F8M = '1' then
      if ExpRd = '1' and Chan_int /= b"0000" then
        Data <= iData;
        iData <= (others => 'Z');
      else
        Data <= ( others => 'Z' );
        iData <= Data;
      end if;
    end if;
  end process;
      
END ARCHITECTURE behavioral;

