--
-- VHDL Test Bench idx_fpga_lib.bench_ana_addr.ana_addr_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:33:07 11/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ana_addr IS
  PORT (
    BdEn    : OUT std_ulogic;
    CfgAddr : OUT std_logic_vector(7 DOWNTO 0);
    AcqAddr : OUT std_logic_vector(7 DOWNTO 0)
    );
END bench_ana_addr;


LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ana_addr IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr    : std_logic_vector(15 DOWNTO 0);
   SIGNAL BdEn_int : std_ulogic;
   SIGNAL CfgAddr_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL AcqAddr_int : std_logic_vector(7 DOWNTO 0);

   -- Component declarations
   COMPONENT ana_addr
      PORT (
         Addr    : IN     std_logic_vector(15 DOWNTO 0);
         BdEn    : OUT    std_ulogic;
         CfgAddr : OUT    std_logic_vector(7 DOWNTO 0);
         AcqAddr : OUT    std_logic_vector(7 DOWNTO 0)
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ana_addr : ana_addr USE ENTITY idx_fpga_lib.ana_addr;
   -- pragma synthesis_on

BEGIN

  DUT_ana_addr : ana_addr
    PORT MAP (
       Addr    => Addr,
       BdEn    => BdEn_int,
       CfgAddr => CfgAddr_int,
       AcqAddr => AcqAddr_int
    );

  BdEn <= BdEn_int;
  CfgAddr <= CfgAddr_int;
  AcqAddr <= AcqAddr_int;

  test_proc : Process IS
    -- pragma synthesis_off
    Variable unmapped : unsigned(5 DOWNTO 0);
    Variable remapped : unsigned(5 DOWNTO 0);
    Variable chkaddr : std_logic_vector(7 DOWNTO 0);
    -- pragma synthesis_on
  Begin
    Addr <= X"0000";
    -- pragma synthesis_off
    wait for 50 ns;
    assert BdEn_int = '0' report "BdEn asserted" severity error;
    for i in 16#BFE# to 16#D03# loop
      Addr <=
          conv_std_logic_vector(
            conv_unsigned(i,16),16);
      wait for 33ns;
      unmapped(0) := CfgAddr_int(0);
      unmapped(1) := CfgAddr_int(1);
      unmapped(2) := CfgAddr_int(2);
      unmapped(3) := CfgAddr_int(4);
      unmapped(4) := CfgAddr_int(5);
      unmapped(5) := CfgAddr_int(6);
      remapped := unmapped + 16#9#;
      chkaddr(0) := remapped(0);
      chkaddr(1) := remapped(1);
      chkaddr(2) := remapped(2);
      chkaddr(3) := Addr(4);
      chkaddr(4) := remapped(3);
      chkaddr(5) := remapped(4);
      chkaddr(6) := remapped(5);
      chkaddr(7) := '0';
      assert AcqAddr_int= chkaddr
        report "Remap value incorrect"
        severity error;
      assert CfgAddr_int(7) = '0'
        report "CfgAddr bit 7 should be zero"
        severity error;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

END rtl;