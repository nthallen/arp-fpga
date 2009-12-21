--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\SH_RSE.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Wed Apr 09 11:37:27 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are speed optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SH_RSE IS
	PORT (rse_clk,rse_ce,EOS,RESET,Scan: IN std_logic;
		OVFEn,S,SNEn : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF SH_RSE IS
	TYPE type_sreg IS (EOSseen,Ready,Scanning);
	SIGNAL sreg, next_sreg : type_sreg;
	SIGNAL next_S : std_logic;
BEGIN
	PROCESS (rse_clk)
	BEGIN
		IF rse_clk='1' AND rse_clk'event THEN
			IF ( RESET='1' ) THEN
				sreg <= Ready;
			ELSE
				sreg <= next_sreg;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (rse_clk)
	BEGIN
		IF rse_clk='1' AND rse_clk'event THEN
			IF ( RESET='1' ) THEN
				S <= '0';
			ELSE
				S <= next_S;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sreg,EOS,RESET,Scan)
	BEGIN
		OVFEn <= '0'; next_S <= '0'; SNEn <= '0'; 

		next_sreg<=EOSseen;

		IF ( RESET='1' ) THEN
			next_sreg<=Ready;
			SNEn<='0';
			next_S<='0';
			OVFEn<='0';
		ELSE
			CASE sreg IS
				WHEN EOSseen =>
					SNEn<='0';
					OVFEn<='0';
					IF ( Scan='0' ) THEN
						next_sreg<=Ready;
						next_S<='0';
					END IF;
					IF ( Scan='1' ) THEN
						next_sreg<=EOSseen;
						next_S<='0';
					END IF;
				WHEN Ready =>
					OVFEn<='0';
					IF ( Scan='1' ) THEN
						next_sreg<=Scanning;
						SNEn<='1';
						next_S<='1';
					END IF;
					IF ( Scan='0' ) THEN
						next_sreg<=Ready;
						SNEn<='0';
						next_S<='0';
					END IF;
				WHEN Scanning =>
					SNEn<='0';
					IF ( EOS='1' ) THEN
						next_sreg<=EOSseen;
						next_S<='0';
						OVFEn<='1';
					END IF;
					IF ( EOS='0' ) THEN
						next_sreg<=Scanning;
						OVFEn<='0';
						next_S<='1';
					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;
END BEHAVIOR;
