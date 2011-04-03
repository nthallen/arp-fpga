--
-- VHDL Test Bench idx_fpga_lib.bench_ana_data_rd.ana_data_rd_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:48:25 01/18/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ana_data_rd IS
END bench_ana_data_rd;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ana_data_rd IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL RAM_BUSY    : std_ulogic;
   SIGNAL RAM_RD_DATA : std_logic_vector(31 DOWNTO 0);
   SIGNAL RAM_RD_EN   : std_ulogic;
   SIGNAL RD_ADDR     : std_logic_vector(8 DOWNTO 0);
   SIGNAL RD_CLK      : std_ulogic;
   SIGNAL RD_DATA     : std_logic_vector(15 DOWNTO 0);
   SIGNAL RDEN        : std_ulogic;
   SIGNAL RST         : std_ulogic;
   SIGNAL Done        : std_ulogic;


   -- Component declarations
   COMPONENT ana_data_rd
      PORT (
         RAM_BUSY    : OUT    std_ulogic;
         RAM_RD_DATA : IN     std_logic_vector(31 DOWNTO 0);
         RAM_RD_EN   : OUT    std_ulogic;
         RD_ADDR     : IN     std_logic_vector(8 DOWNTO 0);
         RD_CLK      : IN     std_ulogic;
         RD_DATA     : OUT    std_logic_vector(15 DOWNTO 0);
         RDEN        : IN     std_ulogic;
         RST         : IN     std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_data_rd : ana_data_rd USE ENTITY idx_fpga_lib.ana_data_rd;
   -- pragma synthesis_on

BEGIN

   DUT_ana_data_rd : ana_data_rd
      PORT MAP (
         RAM_BUSY    => RAM_BUSY,
         RAM_RD_DATA => RAM_RD_DATA,
         RAM_RD_EN   => RAM_RD_EN,
         RD_ADDR     => RD_ADDR,
         RD_CLK      => RD_CLK,
         RD_DATA     => RD_DATA,
         RDEN        => RDEN,
         RST         => RST
      );

    clock : Process
    Begin
      RD_CLK <= '0';
      -- pragma synthesis_off
      wait for 40 ns;
      while Done = '0' loop
        RD_CLK <= '0';
        wait for 62 ns;
        RD_CLK <= '1';
        wait for 63 ns;
      end loop;
      wait;
      -- pragma synthesis_on
    End Process;
    
    pram : Process (RD_CLK)
    Begin
      if RD_CLK'Event AND RD_CLK = '1' then
        if RST = '1' then
          RAM_RD_DATA <= (others => '0');
        elsif RAM_RD_EN = '1' then
          RAM_RD_DATA(31 downto 21) <= (others => '0');
          RAM_RD_DATA(20 downto 16) <= RD_ADDR(6 downto 2);
          RAM_RD_DATA(15 downto 8) <= (others => '0');
          RAM_RD_DATA(7 downto 0) <= RD_ADDR(8 downto 1);
        end if;
      end if;
    End Process;
    
    test_proc : Process
    Begin
      Done <= '0';
      RST <= '1';
      RDEN <= '0';
      RD_ADDR <= (others => '0');
      -- pragma synthesis_off
      wait until RD_CLK'Event AND RD_CLK = '1';
      RST <= '0';
      wait until RD_CLK'Event AND RD_CLK = '1';
      
      -- First read from addr 0
      RDEN <= '1';
      for i in 1 to 8 loop
        wait until RD_CLK'Event AND RD_CLK = '1';
      end loop;
      RDEN <= '0';
      wait until RD_CLK'Event AND RD_CLK = '1';

      -- Then read from addr 1 to get cached config
      RD_ADDR <= "000000001";
      RDEN <= '1';
      for i in 1 to 8 loop
        wait until RD_CLK'Event AND RD_CLK = '1';
      end loop;
      RDEN <= '0';
      wait until RD_CLK'Event AND RD_CLK = '1';

      -- Read from addr 3 to get an error
      RD_ADDR <= "000000011";
      RDEN <= '1';
      for i in 1 to 8 loop
        wait until RD_CLK'Event AND RD_CLK = '1';
      end loop;
      RDEN <= '0';
      wait until RD_CLK'Event AND RD_CLK = '1';

      wait until RD_CLK'Event AND RD_CLK = '1';

      Done <= '1';
      wait;
      -- pragma synthesis_on
      
    End Process;

END rtl;