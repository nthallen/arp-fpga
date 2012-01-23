-- VHDL Entity idx_fpga_lib.ptrhm_i2c_sm.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:02:47 01/23/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;

ENTITY ptrhm_i2c_sm IS
   PORT( 
      F8M       : IN     std_ulogic;
      cmd       : IN     ptrhm_i2c_op;
      i2c_addr  : IN     std_ulogic_vector (6 DOWNTO 0);
      i2c_wdata : IN     std_logic_vector (7 DOWNTO 0);
      rst       : IN     std_ulogic;
      wb_ack_o  : IN     std_logic;
      wb_dat_o  : IN     std_logic_vector (7 DOWNTO 0);
      wb_inta_o : IN     std_logic;
      arst_i    : OUT    std_logic;
      done      : OUT    std_ulogic;
      err       : OUT    std_ulogic;
      i2c_rdata : OUT    std_logic_vector (23 DOWNTO 0);
      wb_adr_i  : OUT    std_logic_vector (2 DOWNTO 0);
      wb_cyc_i  : OUT    std_logic;
      wb_dat_i  : OUT    std_logic_vector (7 DOWNTO 0);
      wb_stb_i  : OUT    std_logic;
      wb_we_i   : OUT    std_logic
   );

-- Declarations

END ptrhm_i2c_sm ;

--
-- VHDL Architecture idx_fpga_lib.ptrhm_i2c_sm.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:02:48 01/23/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;
 
ARCHITECTURE fsm OF ptrhm_i2c_sm IS

   -- Architecture Declarations
   SIGNAL WrStop_int : std_ulogic;  

   TYPE STATE_TYPE IS (
      i2cim_0,
      i2cim_1,
      i2cim_2,
      i2cim_3,
      i2cim_4,
      i2cim_5,
      i2cim_6,
      i2cim_7,
      i2cim_8,
      i2cim_9,
      i2c_cmd,
      i2c_wait,
      i2c_wr0,
      i2c_wrz,
      i2c_err,
      i2c_r1,
      i2c_wr1,
      i2c_wr2,
      i2c_wr3,
      i2c_wr4,
      i2c_wr5,
      i2c_wr7,
      i2c_wr8,
      i2c_wr9,
      i2c_wr10,
      i2c_wr11,
      i2c_wr12,
      i2c_wr13,
      i2c_wr14,
      i2c_wr15,
      i2c_wr16,
      i2c_r2,
      i2c_r3,
      i2c_r4,
      i2c_r5,
      i2c_r6,
      i2c_r7,
      i2c_r8,
      i2c_r9,
      i2c_r10,
      i2c_r11,
      i2c_r12,
      i2c_r13,
      i2c_r14,
      i2c_r15,
      i2c_r16,
      i2c_r17,
      i2c_r18,
      i2c_r19,
      i2c_r20,
      i2c_r21,
      i2c_r22,
      i2c_r23,
      i2c_wr17,
      i2c_wr18,
      i2c_wr19,
      i2c_wr20,
      i2c_wr21
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL arst_i_cld : std_logic ;
   SIGNAL done_cld : std_ulogic ;
   SIGNAL err_cld : std_ulogic ;
   SIGNAL i2c_rdata_cld : std_logic_vector (23 DOWNTO 0);
   SIGNAL wb_adr_i_cld : std_logic_vector (2 DOWNTO 0);
   SIGNAL wb_cyc_i_cld : std_logic ;
   SIGNAL wb_dat_i_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL wb_stb_i_cld : std_logic ;
   SIGNAL wb_we_i_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= i2cim_0;
            -- Default Reset Values
            arst_i_cld <= '1';
            done_cld <= '0';
            err_cld <= '0';
            i2c_rdata_cld <= (others => '0');
            wb_adr_i_cld <= (others => '0');
            wb_cyc_i_cld <= '0';
            wb_dat_i_cld <= (others => '0');
            wb_stb_i_cld <= '0';
            wb_we_i_cld <= '0';
            WrStop_int <= '0';
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN i2cim_0 => 
                  done_cld <= '0' ;
                   err_cld <= '0' ;
               WHEN i2cim_1 => 
                  wb_adr_i_cld <= "000";
                  wb_dat_i_cld <= X"0E";
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
               WHEN i2cim_2 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2cim_4 => 
                  wb_adr_i_cld <= "001";
                  wb_dat_i_cld <= X"00";
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
               WHEN i2cim_5 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2cim_7 => 
                  wb_adr_i_cld <= "010";
                  wb_dat_i_cld <= X"C0";
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
               WHEN i2cim_8 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2cim_9 => 
                  done_cld <= '1';
               WHEN i2c_cmd => 
                  err_cld <= '0';
                  done_cld <= '0';
               WHEN i2c_wr0 => 
                  wb_adr_i_cld <= "011";
                  wb_dat_i_cld <=
                    To_StdLogicVector( i2c_addr & '0' );
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wrz => 
                  done_cld <= '1';
               WHEN i2c_err => 
                  err_cld <= '1';
               WHEN i2c_r1 => 
                  wb_adr_i_cld <= "011";
                  wb_dat_i_cld <=
                    To_StdLogicVector(i2c_addr & '1');
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr1 => 
                  IF (wb_ack_o = '0') THEN 
                     wb_adr_i_cld <= "100";
                     wb_dat_i_cld <= "10010001";
                     wb_we_i_cld <= '1' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_wr2 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr4 => 
                  IF (wb_inta_o = '1') THEN 
                     wb_adr_i_cld <= "100";
                     wb_we_i_cld <= '0' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_wr5 => 
                  IF (wb_ack_o = '1' AND 
                      wb_dat_o(7) /= '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     Err_cld <= '1' ;
                  ELSIF (wb_ack_o = '1' AND
                         wb_dat_o(7) = '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr8 => 
                  IF (wb_ack_o = '0') THEN 
                     wb_adr_i_cld <= "011";
                     wb_dat_i_cld <= i2c_wdata ;
                     wb_we_i_cld <= '1' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_wr9 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr11 => 
                  WrStop_int <= '1';
               WHEN i2c_wr12 => 
                  WrStop_int <= '0';
               WHEN i2c_wr13 => 
                  wb_adr_i_cld <= "100";
                  wb_dat_i_cld <= '0'
                     & WrStop_int
                     & "010001";
                  wb_we_i_cld <= '1' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr15 => 
                  IF (wb_inta_o = '1') THEN 
                     wb_adr_i_cld <= "100";
                     wb_we_i_cld <= '0' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_wr16 => 
                  IF (wb_ack_o = '1' AND 
                      wb_dat_o(7) /= '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     Err_cld <= '1' ;
                  ELSIF (wb_ack_o = '1' AND
                         wb_dat_o(7) = '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r2 => 
                  IF (wb_ack_o = '0') THEN 
                     wb_adr_i_cld <= "100";
                     wb_dat_i_cld <= X"91";
                     wb_we_i_cld <= '1' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_r3 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r6 => 
                  wb_adr_i_cld <= "100";
                  wb_we_i_cld <= '0' ;
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1' AND
                      wb_dat_o(7) /= '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     Err_cld <= '1' ;
                  ELSIF (wb_ack_o = '1' AND
                         wb_dat_o(7) = '0') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r9 => 
                  wb_adr_i_cld <= "100";
                  wb_dat_i_cld <=X"21";
                  wb_we_i_cld <= '1';
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r12 => 
                  wb_adr_i_cld <= "011";
                  wb_we_i_cld <= '0';
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     i2c_rdata_cld(23 DOWNTO 16)
                        <= wb_dat_o;
                  END IF;
               WHEN i2c_r14 => 
                  wb_adr_i_cld <= "100";
                  wb_dat_i_cld <=X"21";
                  wb_we_i_cld <= '1';
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r16 => 
                  IF (wb_inta_o = '1') THEN 
                     wb_adr_i_cld <= "011";
                     wb_we_i_cld <= '0';
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_r17 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     i2c_rdata_cld(15 DOWNTO 8)
                        <= wb_dat_o;
                  END IF;
               WHEN i2c_r19 => 
                  wb_adr_i_cld <= "100";
                  wb_dat_i_cld <=X"69";
                  wb_we_i_cld <= '1';
                  wb_cyc_i_cld <= '1' ;
                  wb_stb_i_cld <= '1' ;
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_r21 => 
                  IF (wb_inta_o = '1') THEN 
                     wb_adr_i_cld <= "011";
                     wb_we_i_cld <= '0';
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_r22 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     i2c_rdata_cld(7 DOWNTO 0)
                        <= wb_dat_o;
                  END IF;
               WHEN i2c_wr18 => 
                  IF (wb_ack_o = '0') THEN 
                     wb_adr_i_cld <= "100";
                     wb_dat_i_cld <= "01000001";
                     wb_we_i_cld <= '1' ;
                     wb_cyc_i_cld <= '1' ;
                     wb_stb_i_cld <= '1' ;
                  END IF;
               WHEN i2c_wr19 => 
                  IF (wb_ack_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                  END IF;
               WHEN i2c_wr21 => 
                  IF (wb_inta_o = '1') THEN 
                     wb_cyc_i_cld <= '0' ;
                     wb_stb_i_cld <= '0' ;
                     Err_cld <= '1' ;
                  END IF;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      cmd,
      current_state,
      err_cld,
      wb_ack_o,
      wb_dat_o,
      wb_inta_o
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN i2cim_0 => 
            next_state <= i2cim_1;
         WHEN i2cim_1 => 
            next_state <= i2cim_2;
         WHEN i2cim_2 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2cim_3;
            ELSE
               next_state <= i2cim_2;
            END IF;
         WHEN i2cim_3 => 
            next_state <= i2cim_4;
         WHEN i2cim_4 => 
            next_state <= i2cim_5;
         WHEN i2cim_5 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2cim_6;
            ELSE
               next_state <= i2cim_5;
            END IF;
         WHEN i2cim_6 => 
            next_state <= i2cim_7;
         WHEN i2cim_7 => 
            next_state <= i2cim_8;
         WHEN i2cim_8 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2cim_9;
            ELSE
               next_state <= i2cim_8;
            END IF;
         WHEN i2cim_9 => 
            next_state <= i2c_wait;
         WHEN i2c_cmd => 
            IF (cmd = Write OR
                cmd = WriteRead2 OR
                cmd = WriteRead3) THEN 
               next_state <= i2c_wr0;
            ELSIF (cmd = Read2) THEN 
               next_state <= i2c_r1;
            ELSIF (cmd = NOP) THEN 
               next_state <= i2c_cmd;
            ELSE
               next_state <= i2c_err;
            END IF;
         WHEN i2c_wait => 
            IF (cmd = Nop) THEN 
               next_state <= i2c_cmd;
            ELSE
               next_state <= i2c_wait;
            END IF;
         WHEN i2c_wr0 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_wr1;
            ELSE
               next_state <= i2c_wr0;
            END IF;
         WHEN i2c_wrz => 
            next_state <= i2c_wait;
         WHEN i2c_err => 
            next_state <= i2c_wait;
         WHEN i2c_r1 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r2;
            ELSE
               next_state <= i2c_r1;
            END IF;
         WHEN i2c_wr1 => 
            IF (wb_ack_o = '0') THEN 
               next_state <= i2c_wr2;
            ELSE
               next_state <= i2c_wr1;
            END IF;
         WHEN i2c_wr2 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_wr3;
            ELSE
               next_state <= i2c_wr2;
            END IF;
         WHEN i2c_wr3 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_wr4;
            ELSE
               next_state <= i2c_wr3;
            END IF;
         WHEN i2c_wr4 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_wr5;
            ELSE
               next_state <= i2c_wr4;
            END IF;
         WHEN i2c_wr5 => 
            IF (wb_ack_o = '1' AND 
                wb_dat_o(7) /= '0') THEN 
               next_state <= i2c_wr18;
            ELSIF (wb_ack_o = '1' AND
                   wb_dat_o(7) = '0') THEN 
               next_state <= i2c_wr8;
            ELSE
               next_state <= i2c_wr5;
            END IF;
         WHEN i2c_wr7 => 
            IF (err_cld = '1') THEN 
               next_state <= i2c_wait;
            ELSIF (cmd = Write) THEN 
               next_state <= i2c_wrz;
            ELSIF (cmd = WriteRead2 OR
                   cmd = WriteRead3) THEN 
               next_state <= i2c_r1;
            ELSE
               next_state <= i2c_err;
            END IF;
         WHEN i2c_wr8 => 
            IF (wb_ack_o = '0') THEN 
               next_state <= i2c_wr9;
            ELSE
               next_state <= i2c_wr8;
            END IF;
         WHEN i2c_wr9 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_wr10;
            ELSE
               next_state <= i2c_wr9;
            END IF;
         WHEN i2c_wr10 => 
            IF (cmd = Write) THEN 
               next_state <= i2c_wr11;
            ELSE
               next_state <= i2c_wr12;
            END IF;
         WHEN i2c_wr11 => 
            next_state <= i2c_wr13;
         WHEN i2c_wr12 => 
            next_state <= i2c_wr13;
         WHEN i2c_wr13 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_wr14;
            ELSE
               next_state <= i2c_wr13;
            END IF;
         WHEN i2c_wr14 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_wr15;
            ELSE
               next_state <= i2c_wr14;
            END IF;
         WHEN i2c_wr15 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_wr16;
            ELSE
               next_state <= i2c_wr15;
            END IF;
         WHEN i2c_wr16 => 
            IF (wb_ack_o = '1' AND 
                wb_dat_o(7) /= '0') THEN 
               next_state <= i2c_wr7;
            ELSIF (wb_ack_o = '1' AND
                   wb_dat_o(7) = '0') THEN 
               next_state <= i2c_wr17;
            ELSE
               next_state <= i2c_wr16;
            END IF;
         WHEN i2c_r2 => 
            IF (wb_ack_o = '0') THEN 
               next_state <= i2c_r3;
            ELSE
               next_state <= i2c_r2;
            END IF;
         WHEN i2c_r3 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r4;
            ELSE
               next_state <= i2c_r3;
            END IF;
         WHEN i2c_r4 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_r5;
            ELSE
               next_state <= i2c_r4;
            END IF;
         WHEN i2c_r5 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_r6;
            ELSE
               next_state <= i2c_r5;
            END IF;
         WHEN i2c_r6 => 
            IF (wb_ack_o = '1' AND
                wb_dat_o(7) /= '0') THEN 
               next_state <= i2c_r7;
            ELSIF (wb_ack_o = '1' AND
                   wb_dat_o(7) = '0') THEN 
               next_state <= i2c_r8;
            ELSE
               next_state <= i2c_r6;
            END IF;
         WHEN i2c_r7 => 
            IF (err_cld = '1') THEN 
               next_state <= i2c_wait;
            ELSE
               next_state <= i2c_wrz;
            END IF;
         WHEN i2c_r8 => 
            IF (cmd = WriteRead3) THEN 
               next_state <= i2c_r9;
            ELSE
               next_state <= i2c_r14;
            END IF;
         WHEN i2c_r9 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r10;
            ELSE
               next_state <= i2c_r9;
            END IF;
         WHEN i2c_r10 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_r11;
            ELSE
               next_state <= i2c_r10;
            END IF;
         WHEN i2c_r11 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_r12;
            ELSE
               next_state <= i2c_r11;
            END IF;
         WHEN i2c_r12 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r13;
            ELSE
               next_state <= i2c_r12;
            END IF;
         WHEN i2c_r13 => 
            next_state <= i2c_r14;
         WHEN i2c_r14 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r15;
            ELSE
               next_state <= i2c_r14;
            END IF;
         WHEN i2c_r15 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_r16;
            ELSE
               next_state <= i2c_r15;
            END IF;
         WHEN i2c_r16 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_r17;
            ELSE
               next_state <= i2c_r16;
            END IF;
         WHEN i2c_r17 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r18;
            ELSE
               next_state <= i2c_r17;
            END IF;
         WHEN i2c_r18 => 
            next_state <= i2c_r19;
         WHEN i2c_r19 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r20;
            ELSE
               next_state <= i2c_r19;
            END IF;
         WHEN i2c_r20 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_r21;
            ELSE
               next_state <= i2c_r20;
            END IF;
         WHEN i2c_r21 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_r22;
            ELSE
               next_state <= i2c_r21;
            END IF;
         WHEN i2c_r22 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_r23;
            ELSE
               next_state <= i2c_r22;
            END IF;
         WHEN i2c_r23 => 
            IF (err_cld = '1') THEN 
               next_state <= i2c_wait;
            ELSE
               next_state <= i2c_wrz;
            END IF;
         WHEN i2c_wr17 => 
            IF (err_cld = '1') THEN 
               next_state <= i2c_wait;
            ELSIF (cmd = Write) THEN 
               next_state <= i2c_wrz;
            ELSIF (cmd = WriteRead2 OR
                   cmd = WriteRead3) THEN 
               next_state <= i2c_r1;
            ELSE
               next_state <= i2c_err;
            END IF;
         WHEN i2c_wr18 => 
            IF (wb_ack_o = '0') THEN 
               next_state <= i2c_wr19;
            ELSE
               next_state <= i2c_wr18;
            END IF;
         WHEN i2c_wr19 => 
            IF (wb_ack_o = '1') THEN 
               next_state <= i2c_wr20;
            ELSE
               next_state <= i2c_wr19;
            END IF;
         WHEN i2c_wr20 => 
            IF (wb_inta_o = '0'
                AND
                wb_ack_o = '0') THEN 
               next_state <= i2c_wr21;
            ELSE
               next_state <= i2c_wr20;
            END IF;
         WHEN i2c_wr21 => 
            IF (wb_inta_o = '1') THEN 
               next_state <= i2c_wr7;
            ELSE
               next_state <= i2c_wr21;
            END IF;
         WHEN OTHERS =>
            next_state <= i2cim_0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   arst_i <= arst_i_cld;
   done <= done_cld;
   err <= err_cld;
   i2c_rdata <= i2c_rdata_cld;
   wb_adr_i <= wb_adr_i_cld;
   wb_cyc_i <= wb_cyc_i_cld;
   wb_dat_i <= wb_dat_i_cld;
   wb_stb_i <= wb_stb_i_cld;
   wb_we_i <= wb_we_i_cld;
END fsm;
