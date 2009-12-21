--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\SHSTATE.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Thu Apr 17 11:00:08 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are speed optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_unsigned.all;

ENTITY SHELL_SHSTATE IS
	PORT (sh_clk,CE0,CE1,CE2,empty,full,RESET,S: IN std_logic;
		MUXsel0,MUXsel1,MUXsel2,MUXsel3,REQ,Scan,WEQ : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF SHELL_SHSTATE IS
	TYPE type_sreg IS (Ch0,Ch1,Ch2,Idle,ShiftHeader,STLast,STWait);
	SIGNAL sreg, next_sreg : type_sreg;
	SIGNAL next_BP_Scan,next_RE,next_RWE,next_SHsel0,next_SHsel1,next_SHsel2,
		next_SHsel3,next_WE : std_logic;
	SIGNAL DataSel : std_logic_vector (3 DOWNTO 0);
	SIGNAL MUXsel : std_logic_vector (3 DOWNTO 0);
	SIGNAL SHsel : std_logic_vector (3 DOWNTO 0);

	FUNCTION cmp(a,b : type_sreg) RETURN std_logic IS
	BEGIN
		IF (a=b) THEN RETURN '1';
		ELSE RETURN '0';
		END IF; 
	END cmp;


	SIGNAL BP_REQ,BP_Scan,BP_WEQ,DataSel0,DataSel1,DataSel2,DataSel3,RE,RWE,
		SHCntEn,SHdone,SHsel0,SHsel1,SHsel2,SHsel3,WE: std_logic;
BEGIN
	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel3 <= '0';
			ELSE
				SHsel3 <= next_SHsel3;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel2 <= '0';
			ELSE
				SHsel2 <= next_SHsel2;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel1 <= '0';
			ELSE
				SHsel1 <= next_SHsel1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel0 <= '0';
			ELSE
				SHsel0 <= next_SHsel0;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				sreg <= Idle;
			ELSE
				sreg <= next_sreg;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				BP_Scan <= '0';
			ELSE
				BP_Scan <= next_BP_Scan;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				RE <= '1';
			ELSE
				RE <= next_RE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				RWE <= '0';
			ELSE
				RWE <= next_RWE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				WE <= '0';
			ELSE
				WE <= next_WE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sreg,BP_REQ,BP_Scan,BP_WEQ,CE0,CE1,CE2,RESET,RWE,S,SHdone)
	BEGIN
		next_BP_Scan <= BP_Scan;next_RWE <= RWE;
		next_RE <= '0'; next_WE <= '0'; 

		next_sreg<=Ch0;

		IF ( RESET='1' ) THEN
			next_sreg<=Idle;
			next_BP_Scan<='0';
			next_RWE<='0';
			next_WE<='0';
			next_RE<='1';
		ELSE
			CASE sreg IS
				WHEN Ch0 =>
					IF ( BP_WEQ='1' AND RWE='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND RWE='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='0' ) OR ( RWE='1' AND BP_REQ='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN Ch1 =>
					IF ( RWE='0' AND BP_WEQ='1' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND CE0='1' AND BP_WEQ='1' AND BP_REQ='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='0' ) OR ( RWE='1' AND BP_REQ='1' AND CE0='0' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
				WHEN Ch2 =>
					IF ( BP_WEQ='0' ) OR ( BP_REQ='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='1' AND CE1='1' AND CE0='0' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN Idle =>
					IF ( BP_REQ='0' ) THEN
						next_sreg<=Idle;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_REQ='1' ) THEN
						next_sreg<=ShiftHeader;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='1';
					END IF;
				WHEN ShiftHeader =>
					IF ( SHdone='0' ) THEN
						next_sreg<=ShiftHeader;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='1';
					END IF;
					IF ( SHdone='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( SHdone='1' AND CE0='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( SHdone='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN STLast =>
					IF ( BP_WEQ='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='1' ) THEN
						next_sreg<=Idle;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
				WHEN STWait =>
					IF ( BP_REQ='0' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;

	PROCESS (sreg,SHCntEn,SHsel0,SHsel1,SHsel2,SHsel3,SHsel)
	BEGIN
		SHsel <= ( ( (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)) +
			std_logic_vector'("0001") ) AND (  std_logic_vector'( SHCntEn, SHCntEn, 
			SHCntEn, SHCntEn)) ) OR  (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)
			) AND (  std_logic_vector'( NOT SHCntEn, NOT SHCntEn, NOT SHCntEn, NOT 
			SHCntEn)) AND (  std_logic_vector'( NOT cmp(Idle,sreg), NOT cmp(Idle,sreg), 
			NOT cmp(Idle,sreg), NOT cmp(Idle,sreg))) ));
		next_SHsel0 <= SHsel(0);
		next_SHsel1 <= SHsel(1);
		next_SHsel2 <= SHsel(2);
		next_SHsel3 <= SHsel(3);
	END PROCESS;

	PROCESS (empty,full,RE,RWE)
	BEGIN
		IF (( empty='0' AND RE='1' ) OR ( empty='0' AND RWE='1' AND full='0' )) 
			THEN BP_REQ<='1';
		ELSE BP_REQ<='0';
		END IF;
	END PROCESS;

	PROCESS (full,WE)
	BEGIN
		IF (( WE='1' AND full='0' )) THEN BP_WEQ<='1';
		ELSE BP_WEQ<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_REQ)
	BEGIN
		IF (( BP_REQ='1' )) THEN REQ<='1';
		ELSE REQ<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_Scan)
	BEGIN
		IF (( BP_Scan='1' )) THEN Scan<='1';
		ELSE Scan<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_WEQ,sreg)
	BEGIN
		IF ((  (sreg=ShiftHeader)AND BP_WEQ='1' )) THEN SHCntEn<='1';
		ELSE SHCntEn<='0';
		END IF;
	END PROCESS;

	PROCESS (SHCntEn,SHsel0,SHsel1,SHsel2,SHsel3)
	BEGIN
		IF (( SHCntEn='1' AND SHsel0='1' AND SHsel1='0' AND SHsel2='1' AND 
			SHsel3='0' )) THEN SHdone<='1';
		ELSE SHdone<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_WEQ)
	BEGIN
		IF (( BP_WEQ='1' )) THEN WEQ<='1';
		ELSE WEQ<='0';
		END IF;
	END PROCESS;

	PROCESS (sreg,DataSel)
	BEGIN
		DataSel <= ( (std_logic_vector'("0001") AND (  std_logic_vector'( cmp(Ch0,
			sreg), cmp(Ch0,sreg), cmp(Ch0,sreg), cmp(Ch0,sreg))) ) OR  (std_logic_vector'
			("0010") AND (  std_logic_vector'( cmp(Ch1,sreg), cmp(Ch1,sreg), cmp(Ch1,sreg
			), cmp(Ch1,sreg))) ) OR  (std_logic_vector'("0011") AND (  std_logic_vector'(
			 cmp(Ch2,sreg), cmp(Ch2,sreg), cmp(Ch2,sreg), cmp(Ch2,sreg))) ));
		DataSel0 <= DataSel(0);
		DataSel1 <= DataSel(1);
		DataSel2 <= DataSel(2);
		DataSel3 <= DataSel(3);
	END PROCESS;

	PROCESS (DataSel0,DataSel1,DataSel2,DataSel3,SHsel0,SHsel1,SHsel2,SHsel3,
		MUXsel)
	BEGIN
		MUXsel <= (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)) +( 
			std_logic_vector'(DataSel3, DataSel2, DataSel1, DataSel0)));
		MUXsel0 <= MUXsel(0);
		MUXsel1 <= MUXsel(1);
		MUXsel2 <= MUXsel(2);
		MUXsel3 <= MUXsel(3);
	END PROCESS;
END BEHAVIOR;

