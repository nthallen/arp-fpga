--
-- VHDL Architecture idx_fpga_lib.bench_zero.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:27:51 01/14/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY bench_zero IS
  PORT ( ResetPosO : OUT  std_ulogic ); 
END ENTITY bench_zero;

--
ARCHITECTURE arch OF bench_zero IS
  SIGNAL ArmZero  :  std_ulogic  ;
  SIGNAL DirOut   :  std_ulogic  ; 
  SIGNAL ZeroRef  :  std_ulogic  ;
  SIGNAL F8M      :  std_ulogic  ; 
  SIGNAL rst      :  std_logic  ;
  SIGNAL ResetPos :  std_ulogic;
  COMPONENT Zero IS
     PORT( 
        ArmZero  : IN     std_ulogic;
        DirOut   : IN     std_ulogic;
        F8M      : IN     std_ulogic;
        ZeroRef  : IN     std_logic;
        rst      : IN     std_logic;
        ResetPos : OUT    std_ulogic
     );
  END COMPONENT;
BEGIN
  DUT  : Zero
    PORT MAP ( 
      ArmZero   => ArmZero,
      DirOut => DirOut,
      F8M => F8M,
      ZeroRef => ZeroRef,
      rst   => rst,
      ResetPos => ResetPos );

-- "Constant Pattern"
-- Start Time = 0 ns, End Time = 1 us, Period = 0 ns
  Process
  Begin
   rst  <= '1'  ;
   -- pragma synthesis_off
  wait for 1 us ;
-- dumped values till 1 us
   rst  <= '0'  ;
  wait;
   -- pragma synthesis_on
 End Process;

  Process
  Begin
    f8m <= '0';
    -- pragma synthesis_off
   wait for 62.5 ns;
    f8m <= '1';
   wait for 62.5 ns;
    -- pragma synthesis_on
  End Process;

  Process
  Begin
    DirOut <= '0';
    ZeroRef <= '0';
    ArmZero <= '0';
    -- pragma synthesis_off
   wait for 2 us;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
    ArmZero <= '1';
   wait for 1 us;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
    DirOut <= '1';
    ArmZero <= '0';
   wait for 1 us;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
    ZeroRef <= '1';
   wait for 250 ns;
    assert ResetPos = '1' report "ResetPos value incorrect" severity error;
   wait for 125 ns;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
   wait for 625 ns;
    DirOut <= '0';
   wait for 1 us;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
    ArmZero <= '1';
   wait for 1 us;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
    DirOut <= '1';
    ArmZero <= '0';
   wait for 250 ns;
    assert ResetPos = '1' report "ResetPos value incorrect" severity error;
   wait for 125 ns;
    assert ResetPos = '0' report "ResetPos value incorrect" severity error;
   wait for 625 ns;
  wait;
   -- pragma synthesis_on
  End Process;
  
  ResetPosO <= ResetPos;
END ARCHITECTURE arch;

