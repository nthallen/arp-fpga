--
-- VHDL Test Bench idx_fpga_lib.bench_ana_acquire.ana_acquire_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:22:47 10/18/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ana_acquire IS
END bench_ana_acquire;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ana_acquire IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL CLK       :     std_ulogic;
   SIGNAL CurMuxCfg :     std_logic_vector (3 DOWNTO 0);
   SIGNAL NewMuxCfg :     std_logic_vector (3 DOWNTO 0);
   SIGNAL RST       :     std_ulogic;
   SIGNAL RdyIn     :     std_ulogic;
   SIGNAL SDI       :     std_ulogic_vector (1 DOWNTO 0);
   SIGNAL CS5       :     std_ulogic;
   SIGNAL Col_Addr  :     std_logic_vector (3 DOWNTO 0);
   SIGNAL Conv      :     std_ulogic;
   SIGNAL NxtRow    :     std_ulogic_vector (5 DOWNTO 0);
   SIGNAL RAM_BUSY  :     std_ulogic;
   SIGNAL RD_Addr   :     std_logic_vector (7 DOWNTO 0);
   SIGNAL RdEn      :     std_ulogic;
   SIGNAL RdyOut    :     std_ulogic;
   SIGNAL S5WE      :     std_ulogic_vector (1 DOWNTO 0);
   SIGNAL Start     :     std_ulogic;
   SIGNAL WR_Addr   :     std_logic_vector (7 DOWNTO 0);
   SIGNAL WrEn      :     std_ulogic;
   SIGNAL Done      :     std_ulogic;


   -- Component declarations
   COMPONENT ana_acquire
     PORT( 
        CLK       : IN     std_ulogic;
        CurMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
        NewMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
        RST       : IN     std_ulogic;
        RdyIn     : IN     std_ulogic;
        SDI       : IN     std_ulogic_vector (1 DOWNTO 0);
        CS5       : OUT    std_ulogic;
        Col_Addr  : OUT    std_logic_vector (3 DOWNTO 0);
        Conv      : OUT    std_ulogic;
        NxtRow    : OUT    std_ulogic_vector (5 DOWNTO 0);
        RAM_BUSY  : OUT    std_ulogic;
        RD_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
        RdEn      : OUT    std_ulogic;
        RdyOut    : OUT    std_ulogic;
        S5WE      : OUT    std_ulogic_vector (1 DOWNTO 0);
        Start     : OUT    std_ulogic;
        WR_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
        WrEn      : OUT    std_ulogic
     );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_acquire : ana_acquire USE ENTITY idx_fpga_lib.ana_acquire;
   -- pragma synthesis_on

BEGIN

 DUT_ana_acquire : ana_acquire
    PORT MAP (
      CLK => CLK,
      CurMuxCfg => CurMuxCfg,
      NewMuxCfg => NewMuxCfg,
      RST => RST,
      RdyIn => RdyIn,
      SDI => SDI,
      CS5 => CS5,
      Col_Addr => Col_Addr,
      Conv => Conv,
      NxtRow => NxtRow,
      RAM_BUSY => RAM_BUSY,
      RD_Addr => RD_Addr,
      RdEn => RdEn,
      RdyOut => RdyOut,
      S5WE => S5WE,
      Start => Start,
      WR_Addr => WR_Addr,
      WrEn => WrEn
    );

  clock : Process
  Begin
    CLK <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      CLK <= '0';
      wait for 16 ns;
      CLK <= '1';
      wait for 17 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  rdy : Process
  Begin
    RdyIn <= '1';
    -- pragma synthesis_off
    wait for 100 ns;
    while Done = '0' loop
      wait until CLK'Event AND CLK = '1' AND Start = '1';
      RdyIn <= '0';
      for i in 1 to 31 loop
        wait until CLK'Event AND CLK = '1';
      end loop;
      RdyIn <= '1';
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  NewMuxCfg_p : Process (CLK)
  Begin
    if CLK'Event AND CLK = '1' then
      if RST = '1' then
        NewMuxCfg <= "0000";
      else
        if RdEn = '1' AND RD_Addr = "00100100" then -- r 2 b 0 c 4
          NewMuxCfg <= "1010";
        else
          NewMuxCfg <= "0000";
        end if;
      end if;
    end if;
  end Process;
  
  CurMuxCfg_p : Process (WR_Addr)
  Begin
    if WR_Addr = "00110110" then -- r 3 b 0 c 6
      CurMuxCfg <= "1010";
    else
      CurMuxCfg <= "0000";
    end if;
  end Process;
  
  test_proc : Process
    Begin
      SDI <= "00";
      Done <= '0';
      RST <= '1';
      -- pragma synthesis_off
      wait for 200 ns;
      RST <= '0';
      for i in 1 to 10 loop
        SDI <= "00";
        wait for 100 ns;
        SDI <= "11";
        wait until Conv <= '0';
      end loop;
      Done <= '1';
      wait;
      -- pragma synthesis_on
    End Process;

END rtl;