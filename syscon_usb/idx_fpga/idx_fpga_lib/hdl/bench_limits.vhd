LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.std_logic_unsigned.all  ; 
ENTITY bench_limits  IS
  PORT (
    SIGNAL armzero_o : OUT std_ulogic;
    SIGNAL limit_o   : OUT std_ulogic );
END;

ARCHITECTURE bench_limits_arch OF bench_limits IS
  SIGNAL rst   :  std_logic  ; 
  SIGNAL inlimit   :  std_ulogic  ; 
  SIGNAL outlimit   :  std_ulogic  ; 
  SIGNAL f8m   :  std_ulogic  ; 
  SIGNAL dirout   :  std_ulogic  ; 
  SIGNAL armzero : std_ulogic;
  SIGNAL limit   : std_ulogic;
  COMPONENT limits  
    PORT ( 
      armzero  : out std_ulogic ; 
      rst  : in std_logic ; 
      inlimit  : in std_ulogic ; 
      limit  : out std_ulogic ; 
      outlimit  : in std_ulogic ; 
      f8m  : in std_ulogic ; 
      dirout  : in std_ulogic ); 
  END COMPONENT ; 
BEGIN
  DUT  : limits  
    PORT MAP ( 
      armzero   => armzero  ,
      rst   => rst  ,
      inlimit   => inlimit  ,
      limit   => limit  ,
      outlimit   => outlimit  ,
      f8m   => f8m  ,
      dirout   => dirout   ) ; 

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

-- "Constant Pattern"
-- Start Time = 5 ns, End Time = 10 us, Period = 0 ns
  Process
	Begin
	 inlimit  <= '0'  ;
	 -- pragma synthesis_off
	wait for 2 us ;
	 inlimit  <= '1'  ;
	wait for 1 us ;
	 inlimit  <= '0'  ;
	wait for 10 us ;
-- dumped values till 13 us
   inlimit  <= '1'  ;
  wait for 1 us ;
   inlimit  <= '0'  ;
  wait for 2 us;
-- dumped values till 16 us
   inlimit  <= '1'  ;
  wait for 1 us ;
   inlimit  <= '0'  ;
  wait for 3 us;
-- dumped values till 20 us
   inlimit <= '1';
  wait for 2 us;
   inlimit <= '0';
  wait;
   -- pragma synthesis_on
 End Process;


-- "Constant Pattern"
-- Start Time = 8 ns, End Time = 10 us, Period = 0 ns
  Process
	Begin
	 outlimit  <= '0'  ;
	 -- pragma synthesis_off
	wait for 5 us ;
	 outlimit  <= '1'  ;
	wait for 1 us ;
	 outlimit  <= '0'  ;
	wait for 2 us ;
	 -- verify that limit is insensitive to bounces
	 outlimit  <= '1'  ;
	wait for 1 us ;
	 outlimit  <= '0'  ;
	wait for 1 us ;
-- dumped values till 10 us
  wait for 1 us;
   -- verify that limit is insensitive to outlimit on in drive
   outlimit <= '1';
  wait for 1 us;
   outlimit <= '0';
  wait for 6 us;
-- dumped values till 18 us
   outlimit <= '1';
  wait for 1 us;
   outlimit <= '0';
-- dumped values till 19 us
  wait for 4 us;
   outlimit <= '1';
	wait;
	 -- pragma synthesis_on
 End Process;


-- "Constant Pattern"
-- Start Time = 5 ns, End Time = 10 us, Period = 0 ns
  Process
	Begin
	 dirout  <= '1';
	 -- pragma synthesis_off
	wait for 10 us ;
-- dumped values till 10 us
   dirout <= '0';
   wait for 5 us;
-- dumped values till 15 us
   dirout <= '1';
  wait for 6 us;
   dirout <= '0';
  wait for 3 us;
   dirout <= '1';
	wait;
	 -- pragma synthesis_on
 End Process;

  -- pragma synthesis_off
Process
Begin
 wait for 2 us;
  assert Limit = '0' report "Limit not 0 after reset" severity error;
  assert ArmZero = '0' report "ArmZero not 0 after reset" severity error;
 wait for 1 us;
  assert Limit = '0' report "Limit responded to wrong switch" severity error;
  assert ArmZero = '0' report "ArmZero tripped on wrong directrion" severity note;
 wait for 1 us;
  assert Limit = '0' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 2 us;
  -- 6 us
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 2 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 2 us;
  assert Limit = '0' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '0' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 2 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '1' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '1' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '0' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '0' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 2 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '1' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '1' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '1' report "ArmZero value incorrect" severity note;
 wait for 1 us;
  assert Limit = '1' report "Limit value incorrect" severity error;
  assert ArmZero = '0' report "ArmZero value incorrect" severity note;
wait;
End Process;
  -- pragma synthesis_on

  armzero_o <= ArmZero;
  limit_o <= Limit;
END;


