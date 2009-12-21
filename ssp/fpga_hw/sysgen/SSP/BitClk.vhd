LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity BitClk IS
  PORT ( bc_clk, bc_ce, PMT, PMT_EN, OE, CLR: IN std_logic;
         Q: OUT std_logic );
END;

ARCHITECTURE BEHAVIOR OF BitClk IS
  SIGNAL FDQ : std_logic;
BEGIN

  PROCESS (PMT, PMT_EN, CLR)
  BEGIN
    FDQ <= '0';
    
    IF PMT = '1' AND PMT'event THEN
      FDQ <= '1';
    ELSE
      IF CLR = '1' THEN
        FDQ <= '0';
      END IF;
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

END;
