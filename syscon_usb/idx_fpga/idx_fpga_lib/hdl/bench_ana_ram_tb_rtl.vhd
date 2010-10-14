--
-- VHDL Test Bench idx_fpga_lib.bench_ana_ram.ana_ram_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:39:32 10/14/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY UNISIM;
USE UNISIM.vcomponents.all;


ENTITY bench_ana_ram IS
END bench_ana_ram;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ana_ram IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL RD_ADDR : std_logic_vector(7 DOWNTO 0);
   SIGNAL WR_ADDR : std_logic_vector(7 DOWNTO 0);
   SIGNAL RD_DATA : std_logic_vector(31 DOWNTO 0);
   SIGNAL WR_DATA : std_logic_vector(31 DOWNTO 0);
   SIGNAL WREN    : std_ulogic;
   SIGNAL RDEN    : std_ulogic;
   SIGNAL CLK     : std_ulogic;
   SIGNAL RST     : std_ulogic;
   SIGNAL Done : std_ulogic;


   -- Component declarations
   COMPONENT ana_ram
      PORT (
         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
         WREN    : IN     std_ulogic;
         RDEN    : IN     std_ulogic;
         CLK     : IN     std_ulogic;
         RST     : IN     std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_ram : ana_ram USE ENTITY idx_fpga_lib.ana_ram;
   -- pragma synthesis_on

BEGIN

   DUT_ana_ram : ana_ram
      PORT MAP (
         RD_ADDR => RD_ADDR,
         WR_ADDR => WR_ADDR,
         RD_DATA => RD_DATA,
         WR_DATA => WR_DATA,
         WREN    => WREN,
         RDEN    => RDEN,
         CLK     => CLK,
         RST     => RST
      );


  clock : Process
  Begin
    CLK <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      CLK <= '0';
      wait for 25 ns;
      CLK <= '1';
      wait for 25 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  test_proc : process is
  Begin
    Done <= '0';
    RDEN <= '0';
    WREN <= '0';
    RD_ADDR <= (others => '0');
    WR_ADDR <= (others => '0');
    WR_DATA <= (others => '0');
    RST <= '1';
    -- pragma synthesis_off
    wait until CLK'Event AND CLK = '1';
    RST <= '0';
    wait until CLK'Event AND CLK = '1';
    WR_ADDR <= X"01";
    WR_DATA <= X"12345678";
    WREN <= '1';
    wait until CLK'Event AND CLK = '1';
    WREN <= '0';
    RD_ADDR <= X"01";
    RDEN <= '1';
    wait until CLK'Event AND CLK = '1';
    WR_DATA <= X"55555555";
    WREN <= '1';
    for i in 0 to 8 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
    end loop;
    RDEN <= '0';
    WR_DATA <= X"AAAAAAAA";
    for i in 0 to 8 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
    end loop;
    wait until CLK'Event AND CLK = '1';
    -- pragma synthesis_on
    Done <= '1';
    wait;
  End Process;
END rtl;