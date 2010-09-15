LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity SSP_PMT_Input IS
  PORT ( CLK, PMT, RESET: IN std_logic;
         SIG: OUT std_logic_vector (15 downto 0);
         OVF: OUT std_logic );
END;

ARCHITECTURE BEHAVIOR OF SSP_PMT_Input IS
  COMPONENT BitClk IS
    PORT ( PMT, PMT_EN, OE, CLR: IN std_logic;
           Q, OVF: OUT std_logic );
  END COMPONENT;
  COMPONENT TRI_EN IS
  	PORT (CLK,RESET: IN std_logic;
  		EN1,EN2,EN3 : OUT std_logic);
  END COMPONENT;
  SIGNAL EN1, EN2, EN3, Q1, Q2, Q3, OVF1, OVF2, OVF3, Qout, OVFout : std_logic;
BEGIN
  TRI_EN1 : TRI_EN PORT MAP (
    CLK => CLK, RESET => RESET, EN1 => EN1, EN2 => EN2, EN3 => EN3
  );
  BitClk1 : BitClk PORT MAP (
    PMT => PMT, PMT_EN => EN1, OE => EN2, CLR => EN3, Q => Q1, OVF => OVF1
  );
  BitClk2 : BitClk PORT MAP (
    PMT => PMT, PMT_EN => EN2, OE => EN3, CLR => EN1, Q => Q2, OVF => OVF2
  );
  BitClk3 : BitClk PORT MAP (
    PMT => PMT, PMT_EN => EN3, OE => EN1, CLR => EN2, Q => Q3, OVF => OVF3
  );
  PROCESS ( Q1, Q2, Q3 )
  BEGIN
    Qout <= '0';
    IF ( Q1 = '1' OR Q2 = '1' OR Q3 = '1' ) THEN
      Qout <= '1';
    ELSE
      Qout <= '0';
    END IF;
  END PROCESS;
  
  PROCESS ( OVF1, OVF2, OVF3 )
  BEGIN
    OVFout <= '0';
    IF ( OVF1 = '1' OR OVF2 = '1' OR OVF3 = '1' ) THEN
      OVFout <= '1';
    ELSE
      OVFout <= '0';
    END IF;
  END PROCESS;
  
  SIG(15 downto 1) <= B"000000000000000";
  SIG(0) <= Qout;
  
  OVF <= OVFout;
END;
