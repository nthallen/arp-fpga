LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity BitClk IS
  PORT ( PMT, PMT_EN, OE, CLR: IN std_logic;
         Q, OVF: OUT std_logic );
END;

ARCHITECTURE BEHAVIOR OF BitClk IS
  SIGNAL FDQ, FDOVF : std_logic;
BEGIN

  PROCESS (PMT, PMT_EN, CLR)
  BEGIN
    FDQ <= '0';
    
    IF CLR = '1' THEN
        FDQ <= '0';
    ELSIF PMT_EN = '1' AND PMT = '1' AND PMT'event THEN
       FDQ <= '1';
    ELSE
       FDQ <= FDQ;
    END IF;
  END PROCESS;

  PROCESS (FDQ, PMT, PMT_EN, CLR)
  BEGIN
    FDOVF <= '0';
    
    IF CLR = '1' THEN
        FDOVF <= '0';
    ELSIF FDQ = '1' AND PMT_EN = '1' AND PMT = '1' AND PMT'event THEN
       FDOVF <= '1';
    ELSE
       FDOVF <= FDOVF;
    END IF;
  END PROCESS;
  
  PROCESS (FDQ, OE)
  BEGIN
    IF OE = '1' THEN
      Q <= FDQ;
    ELSE
      Q <= '0';
    END IF;
  END PROCESS;
  
  PROCESS (FDOVF, OE)
  BEGIN
    IF OE = '1' THEN
      OVF <= FDOVF;
    ELSE
      OVF <= '0';
    END IF;
  END PROCESS;

END;
