--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\TRI_EN.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Sun Apr 27 11:17:24 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are speed optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TRI_EN IS
	PORT (CLK,CE,RESET: IN std_logic;
		EN1,EN2,EN3 : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF TRI_EN IS
	TYPE type_sreg IS (INIT,S1,S2,S3);
	SIGNAL sreg, next_sreg : type_sreg;
BEGIN
	PROCESS (CLK, next_sreg)
	BEGIN
		IF CLK='1' AND CLK'event THEN
			sreg <= next_sreg;
		END IF;
	END PROCESS;

	PROCESS (sreg,RESET)
	BEGIN

		next_sreg<=INIT;

		IF ( RESET='1' ) THEN
			next_sreg<=INIT;
		ELSE
			CASE sreg IS
				WHEN INIT =>
					next_sreg<=S1;
				WHEN S1 =>
					next_sreg<=S2;
				WHEN S2 =>
					next_sreg<=S3;
				WHEN S3 =>
					next_sreg<=S1;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;

	PROCESS (sreg)
	BEGIN
		IF ((  (sreg=INIT)) OR (  (sreg=S1))) THEN EN1<='1';
		ELSE EN1<='0';
		END IF;
	END PROCESS;

	PROCESS (sreg)
	BEGIN
		IF ((  (sreg=INIT)) OR (  (sreg=S2))) THEN EN2<='1';
		ELSE EN2<='0';
		END IF;
	END PROCESS;

	PROCESS (sreg)
	BEGIN
		IF ((  (sreg=INIT)) OR (  (sreg=S3))) THEN EN3<='1';
		ELSE EN3<='0';
		END IF;
	END PROCESS;
END BEHAVIOR;
