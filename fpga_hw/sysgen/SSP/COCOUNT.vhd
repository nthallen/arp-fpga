--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\COCOUNT.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Wed Apr 16 10:05:01 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are area optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY COCOUNT IS
	PORT (coct_clk,BOS,coct_ce,empty,PSNZ,RESET,TC: IN std_logic;
		LastScan,LastSkip,PreSkip : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF COCOUNT IS
	TYPE type_sreg IS (Co_add,Last_Scan,Last_Skip,Pre_Skip);
	SIGNAL sreg, next_sreg : type_sreg;
BEGIN
	PROCESS (coct_clk, next_sreg)
	BEGIN
		IF coct_clk='1' AND coct_clk'event THEN
			sreg <= next_sreg;
		END IF;
	END PROCESS;

	PROCESS (sreg,BOS,empty,PSNZ,RESET,TC)
	BEGIN
		LastScan <= '0'; LastSkip <= '0'; PreSkip <= '0'; 

		next_sreg<=Co_add;

		IF ( RESET='1' ) THEN
			next_sreg<=Pre_Skip;
			LastScan<='0';
			PreSkip<='1';
			LastSkip<='0';
		ELSE
			CASE sreg IS
				WHEN Co_add =>
					LastScan<='0';
					PreSkip<='0';
					LastSkip<='0';
					IF ( BOS='1' AND TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
					IF ( BOS='0' ) OR ( TC='0' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='1' AND TC='1' AND empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
				WHEN Last_Scan =>
					LastScan<='1';
					PreSkip<='0';
					LastSkip<='0';
					IF ( BOS='0' ) OR ( TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
					IF ( TC='0' AND PSNZ='0' AND BOS='1' ) OR ( TC='0' AND empty='1' AND 
						BOS='1' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='1' AND PSNZ='1' AND empty='0' ) THEN
						next_sreg<=Pre_Skip;
					END IF;
					IF ( BOS='1' AND PSNZ='0' AND empty='0' AND TC='1' ) THEN
						next_sreg<=Last_Skip;
					END IF;
				WHEN Last_Skip =>
					LastScan<='0';
					PreSkip<='0';
					LastSkip<='1';
					IF ( BOS='0' ) OR ( empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
					IF ( BOS='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
				WHEN Pre_Skip =>
					LastScan<='0';
					PreSkip<='1';
					LastSkip<='0';
					IF ( BOS='1' AND PSNZ='0' AND TC='1' AND empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
					IF ( TC='0' AND PSNZ='0' AND BOS='1' ) OR ( TC='0' AND empty='1' AND 
						BOS='1' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='0' ) OR ( PSNZ='1' AND empty='0' ) THEN
						next_sreg<=Pre_Skip;
					END IF;
					IF ( BOS='1' AND TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;
END BEHAVIOR;
