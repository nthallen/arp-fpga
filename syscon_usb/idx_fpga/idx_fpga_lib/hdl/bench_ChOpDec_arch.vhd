--
-- VHDL Architecture idx_fpga_lib.bench_ChOpDec.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:00:44 01/15/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_ChOpDec IS
  PORT (
    CfgEn_o   : OUT std_ulogic;
    CtEn_o    : OUT std_ulogic;
    PosEn_o   : OUT std_ulogic );
END ENTITY bench_ChOpDec;

--
ARCHITECTURE arch OF bench_ChOpDec IS
  SIGNAL ChanSel :  std_ulogic;
  SIGNAL OpCd    :  std_ulogic_vector (2 DOWNTO 0);
  SIGNAL CfgEn   :  std_ulogic;
  SIGNAL CtEn    :  std_ulogic;
  SIGNAL PosEn   :  std_ulogic;
  COMPONENT ChOpDec IS
     PORT( 
        ChanSel : IN     std_ulogic;
        OpCd    : IN     std_ulogic_vector (2 DOWNTO 0);
        CfgEn   : OUT    std_ulogic;
        CtEn    : OUT    std_ulogic;
        PosEn   : OUT    std_ulogic
     );
  END COMPONENT;
BEGIN
  DUT  : ChOpDec
    PORT MAP ( 
      ChanSel => ChanSel,
      OpCd => OpCd,
      CfgEn => CfgEn,
      CtEn => CtEn,
      PosEn => PosEn );
  
  process ( CfgEn, CtEn, PosEn )
  begin
    CfgEn_o <= CfgEn;
    CtEn_o <= CtEn;
    PosEn_o <= PosEn;
  end process;

  test_proc : process
    procedure test_codes(
      OpAddr : in std_ulogic_vector (2 downto 0);
      Cfg : in std_ulogic;
      Ct : in std_ulogic;
      Pos : in std_ulogic ) is
    begin
      ChanSel <= '0';
      OpCd <= OpAddr;
      -- pragma synthesis_off
      wait for 1 us;
      assert CfgEn = '0' report "CfgEn value incorrect" severity error;
      assert CtEn = '0' report "CtEn value incorrect" severity error;
      assert PosEn = '0' report "PosEn value incorrect" severity error;
      ChanSel <= '1';
      wait for 1 us;
      assert CfgEn = Cfg report "CfgEn value incorrect" severity error;
      assert CtEn = Ct report "CtEn value incorrect" severity error;
      assert PosEn = Pos report "PosEn value incorrect" severity error;
      -- pragma synthesis_on
      return;
    end procedure test_codes;
  begin
    ChanSel <= '0';
    OpCd <= "000";
    -- pragma synthesis_off
    test_codes( "000", '0', '1', '0' );
    test_codes( "001", '0', '0', '0' );
    test_codes( "010", '0', '1', '0' );
    test_codes( "011", '0', '0', '0' );
    test_codes( "100", '0', '0', '1' );
    test_codes( "101", '0', '0', '0' );
    test_codes( "110", '1', '0', '0' );
    test_codes( "111", '0', '0', '0' );
    -- pragma synthesis_on
  end process;
END ARCHITECTURE arch;

