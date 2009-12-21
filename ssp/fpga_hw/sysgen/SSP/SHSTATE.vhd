
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_unsigned.all;

ENTITY SHSTATE IS
	PORT (MUXsel : OUT std_logic_vector (3 DOWNTO 0);
    CE : IN std_logic_vector (2 DOWNTO 0);
		sh_clk,sh_ce,empty,full,RESET,S: IN std_logic;
		REQ,Scan,WEQ : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF SHSTATE IS
	COMPONENT SHELL_SHSTATE
		PORT (sh_clk,CE0,CE1,CE2,empty,full,RESET,S: IN std_logic;
			MUXsel0,MUXsel1,MUXsel2,MUXsel3,REQ,Scan,WEQ : OUT std_logic);
	END COMPONENT;
BEGIN
	SHELL1_SHSTATE : SHELL_SHSTATE PORT MAP (sh_clk=>sh_clk,CE0=>CE(0),CE1=>CE(1),
		CE2=>CE(2),empty=>empty,full=>full,RESET=>RESET,S=>S,MUXsel0=>MUXsel(0),MUXsel1
		=>MUXsel(1),MUXsel2=>MUXsel(2),MUXsel3=>MUXsel(3),REQ=>REQ,Scan=>Scan,WEQ=>
		WEQ);
END BEHAVIOR;
