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
-- LIBRARY UNISIM;
-- USE UNISIM.vcomponents.all;


ENTITY bench_ana_ram IS
END bench_ana_ram;


LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


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
   -- pragma synthesis_off
   SIGNAL Done : std_ulogic;
   -- pragma synthesis_on


   -- Component declarations
   COMPONENT ana_ram
     generic (
       INIT_00 : bit_vector := X"0123456789ABCDEF000000000000000000000000000000000000000000000000";
       INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
       INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000"
     );
      PORT (
         RD_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         WR_ADDR : IN     std_logic_vector(7 DOWNTO 0);
         RD_DATA : OUT    std_logic_vector(31 DOWNTO 0);
         WR_DATA : IN     std_logic_vector(31 DOWNTO 0);
         WREN    : IN     std_ulogic;
         RDEN    : IN     std_ulogic;
         RD_CLK  : IN     std_ulogic;
         WR_CLK  : IN     std_ulogic;
         RST     : IN     std_ulogic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_ram : ana_ram USE ENTITY idx_fpga_lib.ana_ram;
   -- pragma synthesis_on

BEGIN

   DUT_ana_ram : ana_ram
      GENERIC MAP (
        INIT_00 => X"0123456789ABCDEF000000000000000000000000000000000000000000000000"
      )
      PORT MAP (
         RD_ADDR => RD_ADDR,
         WR_ADDR => WR_ADDR,
         RD_DATA => RD_DATA,
         WR_DATA => WR_DATA,
         WREN    => WREN,
         RDEN    => RDEN,
         RD_CLK  => CLK,
         WR_CLK  => CLK,
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
  
  -- This test demonstrates the RAM in simple dual-port mode
  -- with synchronous clocks. This is not the mode we will
  -- be using, but we are also planning to guarantee
  -- that we do not read and write at the same time.
  test_proc : process is
  Begin
    RDEN <= '0';
    WREN <= '0';
    RD_ADDR <= (others => '0');
    WR_ADDR <= (others => '0');
    WR_DATA <= (others => '0');
    RST <= '1';
    -- pragma synthesis_off
    Done <= '0';
    wait until CLK'Event AND CLK = '1';
    RST <= '0';
    wait until CLK'Event AND CLK = '1';
    -- Let's first see how initialization works
    RDEN <= '1';
    for i in 0 to 255 loop
      RD_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
    end loop;
    RDEN <= '0';
    WR_ADDR <= X"01";
    WR_DATA <= X"12345678";
    WREN <= '1';
    wait until CLK'Event AND CLK = '1';
    WREN <= '0';
    RD_ADDR <= X"01";
    RDEN <= '1';
    wait until CLK'Event AND CLK = '1';
    wait for 30 ns;
    assert RD_DATA = X"12345678" report "RD_DATA invalid" severity error;
    WR_DATA <= X"55555555";
    WREN <= '1';
    for i in 0 to 5 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
      -- assert RD_DATA = X"12345678" report "RD_DATA changed" severity error;
    end loop;
    RDEN <= '0';
    for i in 6 to 6 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
    end loop;
    RDEN <= '1';
    wait until CLK'Event AND CLK = '1';
    for i in 7 to 8 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
      assert RD_DATA = X"55555555" report "RD_DATA did not update" severity error;
    end loop;
    WR_DATA <= X"AAAAAAAA";
    for i in 0 to 8 loop
      WR_ADDR <= std_logic_vector(conv_unsigned(i, 8));
      wait until CLK'Event AND CLK = '1';
      -- assert RD_DATA = X"55555555" report "RD_DATA changed" severity error;
    end loop;
    wait until CLK'Event AND CLK = '1';
    wait until CLK'Event AND CLK = '1';
    wait until CLK'Event AND CLK = '1';
    wait until CLK'Event AND CLK = '1';
    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
END rtl;