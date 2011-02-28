--
-- VHDL Architecture idx_fpga_lib.idx_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:02:14 02/28/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY idx_addr IS
  GENERIC (
    N_CHANNELS : integer range 15 downto 1 := 1;
    BASE_ADDR : std_logic_vector (15 DOWNTO 0) := X"0A00"
  );
  PORT (
    Addr    : IN     std_logic_vector (15 DOWNTO 0);
    BdEn    : OUT    std_ulogic;
    Chan    : OUT    std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
    OpCd    : OUT    std_logic_vector (2 DOWNTO 0);
    Ireq    : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
    BdIntr  : OUT    std_ulogic ;
    Running : IN     std_ulogic_vector (N_CHANNELS-1 DOWNTO 0);
    RData   : OUT    std_logic_vector (15 DOWNTO 0);
    iRData  : IN     std_logic_vector ((N_CHANNELS-1)*16+15 DOWNTO 0);
    RdEn    : IN     std_ulogic;
    WData5  : IN     std_logic;
    WrEn    : IN     std_ulogic;
    F8M     : IN     std_ulogic;
    F4M     : OUT    std_ulogic;
    rst     : IN     std_ulogic
  );
END ENTITY idx_addr;

--
ARCHITECTURE beh OF idx_addr IS
  SIGNAL F4M_int : std_ulogic;
  SIGNAL Chan_sel : std_ulogic; -- true if a channel is selected
  SIGNAL Chan_int : std_ulogic_vector(N_CHANNELS-1 DOWNTO 0); -- individual channel select lines
  SIGNAL Base_int : std_ulogic; -- true if base block is selected
  SIGNAL BdEn_int : std_ulogic; -- true if board is addressed
  SIGNAL Intr_En : std_ulogic;
BEGIN
  Addressing : process (Addr, BdEn_int) is
    Variable Chan_num : unsigned(3 DOWNTO 0);
  begin
    Base_int <= '0';
    Chan_sel <= '0';
    BdEn_int <= '0';
    Chan_int <= (others => '0');
    if Addr = BASE_ADDR then
      Base_int <= '1';
      BdEn_int <= '1';
    elsif Addr(15 DOWNTO 7) = BASE_ADDR(15 DOWNTO 7) and Addr(0) = '0' then
      Chan_num := unsigned(Addr(6 DOWNTO 3));
      for i in 0 to N_CHANNELS-1 loop
        if i+1 = conv_integer(Chan_num) then
          Chan_sel <= '1';
          BdEn_int <= '1';
          Chan_int(i) <= '1';
        end if;
      end loop;
        -- if Chan_num > 0 and Chan_num <= N_CHANNELS then
        -- Chan_sel <= '1';
        -- BdEn_int <= '1';
        -- Chan_int(conv_integer(Chan_num)) <= '1';
        -- end if;
    end if;
    OpCd <= Addr(2 DOWNTO 0);
    BdEn <= BdEn_int;
  end process;
  
  iRData_Bus : Process (F8M)
    Variable Chan_num : unsigned(3 DOWNTO 0);
  Begin
    if F8M'event and F8M = '1' then
      if RdEn = '1' and Base_int = '1' then
        RData(15 DOWNTO N_CHANNELS) <= ( others => '0' );
        RData(N_CHANNELS-1 DOWNTO 0) <= To_StdLogicVector(Running);
      elsif RdEn = '1' and Chan_sel = '1' then
        Chan_num := unsigned(Addr(6 DOWNTO 3));
        for i in 0 to N_CHANNELS-1 loop
          if i+1 = conv_integer(Chan_num) then
            RData <= iRData(16*i+15 DOWNTO 16*i);
          end if;
        end loop;
      end if;
    end if;
  End Process;
  
  -- This functionality could be in an external component
  Interrupt : process (F8M) is
    Variable intr_int: std_ulogic;
  begin
    if F8M'event and F8M = '1' then
      if rst = '1' then
        Intr_En <= '0';
      elsif WrEn = '1' and Base_int = '1' then
        Intr_En <= WData5;
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

  Channels : process (F8M) is
  begin
    if F8M'event AND F8M = '1' then
      Chan <= Chan_int;
    end if;
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
  
END ARCHITECTURE beh;

