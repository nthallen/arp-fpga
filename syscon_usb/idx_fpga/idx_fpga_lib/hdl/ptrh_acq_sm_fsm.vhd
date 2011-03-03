-- VHDL Entity idx_fpga_lib.ptrh_acq_sm.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:25:29 03/ 3/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY ptrh_acq_sm IS
   PORT( 
      Done      : IN     std_logic;
      Err       : IN     std_logic;
      F25M      : IN     std_ulogic;
      Full      : IN     std_ulogic_vector (12 DOWNTO 0);
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
      rst       : IN     std_ulogic;
      Rd        : OUT    std_logic;
      Rd3       : OUT    std_logic;
      Wr        : OUT    std_logic;
      WrEn      : OUT    std_ulogic_vector (12 DOWNTO 0);
      WrStop    : OUT    std_logic;
      i2c_addr  : OUT    std_logic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      wData     : OUT    std_logic_vector (23 DOWNTO 0)
   );

-- Declarations

END ptrh_acq_sm ;

--
-- VHDL Architecture idx_fpga_lib.ptrh_acq_sm.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:25:29 03/ 3/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
 
ARCHITECTURE fsm OF ptrh_acq_sm IS

   -- Architecture Declarations
   SIGNAL Status : std_logic_vector(15 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      acq_0,
      acq_1,
      acq_2,
      acq_3,
      acq_4,
      acq_5,
      acq_6,
      acq_7,
      acq_8,
      acq_9,
      s0,
      s1,
      acq_10,
      acq_11,
      acq_14,
      acq_15,
      acq_12,
      acq_13,
      s2,
      acq_16,
      acq_17,
      acq_18,
      acq_19,
      acq_20,
      acq_21,
      s3,
      acq_22,
      acq_23,
      acq_24,
      acq_25,
      acq_26,
      acq_27,
      s4,
      acq_28,
      acq_29,
      acq_30,
      acq_31,
      acq_32,
      acq_33,
      s5,
      acq_34,
      acq_35,
      acq_36,
      acq_37,
      acq_38,
      acq_39,
      s6,
      acq_40,
      acq_41,
      acq_42,
      acq_43,
      acq_44,
      acq_45,
      acq_47,
      s7,
      acq_46,
      acq_48,
      acq_49,
      acq_50,
      acq_51,
      acq_52,
      acq_53,
      acq_54,
      acq_55,
      acq_56,
      acq_57,
      acq_58,
      acq_59,
      acq_60,
      acq_61,
      acq_62,
      acq_63,
      acq_64,
      acq_65,
      acq_66,
      acq_67,
      acq_68,
      acq_69,
      acq_70,
      acq_71,
      acq_72,
      acq_73,
      acq_74,
      acq_75,
      acq_76
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(17 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(17 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_acq_9 : std_logic;
   SIGNAL csm_to_acq_47 : std_logic;
   SIGNAL csm_to_s7 : std_logic;
   SIGNAL csm_to_acq_61 : std_logic;
   SIGNAL csm_to_acq_72 : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL Rd_cld : std_logic ;
   SIGNAL Rd3_cld : std_logic ;
   SIGNAL Wr_cld : std_logic ;
   SIGNAL WrEn_cld : std_ulogic_vector (12 DOWNTO 0);
   SIGNAL WrStop_cld : std_logic ;
   SIGNAL i2c_addr_cld : std_logic_vector (6 DOWNTO 0);
   SIGNAL i2c_wdata_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL wData_cld : std_logic_vector (23 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F25M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (rising_edge(F25M)) THEN
         IF (rst = '1') THEN
            current_state <= acq_0;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            Rd_cld <= '0';
            Rd3_cld <= '0';
            Wr_cld <= '0';
            WrEn_cld <= (others => '0');
            WrStop_cld <= '0';
            i2c_addr_cld <= (others => '0');
            i2c_wdata_cld <= (others => '0');
            wData_cld <= (others => '0');
            Status <= (others => '0');
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;

            -- Combined Actions
            CASE current_state IS
               WHEN acq_0 => 
                  IF (Done = '1') THEN 
                     i2c_addr_cld <= "1000000";
                     i2c_wdata_cld <= X"FE";
                     Wr_cld <= '1' ;
                     WrStop_cld <= '1' ;
                  END IF;
               WHEN acq_1 => 
                  IF (Done = '0') THEN 
                     Wr_cld <= '0' ;
                     WrStop_cld <= '0' ;
                  END IF;
               WHEN acq_2 => 
                  IF (Done = '1') THEN 
                     Status(0) <= '1';
                  END IF;
               WHEN acq_3 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
               WHEN acq_4 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_5 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"1E";
                  Wr_cld <= '1' ;
                  WrStop_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                     WrStop_cld <= '0' ;
                  END IF;
               WHEN acq_6 => 
                  IF (Done = '1') THEN 
                     Status(1) <= '1';
                  END IF;
               WHEN acq_7 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
               WHEN acq_8 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_10 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"A2";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_11 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_14 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(3) <= '0';
               WHEN acq_15 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_12 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_13 => 
                  IF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(3) <= '1';
                     Status(2) <= '1';
                  END IF;
               WHEN acq_16 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"A4";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_17 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_18 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_19 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(4) <= '1';
                     Status(3) <= '1';
                  END IF;
               WHEN acq_20 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(4) <= '0';
               WHEN acq_21 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_22 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"A6";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_23 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_24 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_25 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(5) <= '1';
                     Status(4) <= '1';
                  END IF;
               WHEN acq_26 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(5) <= '0';
               WHEN acq_27 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_28 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"A8";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_29 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_30 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_31 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(6) <= '1';
                     Status(5) <= '1';
                  END IF;
               WHEN acq_32 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(6) <= '0';
               WHEN acq_33 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_34 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"AA";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_35 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_36 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_37 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(7) <= '1';
                     Status(6) <= '1';
                  END IF;
               WHEN acq_38 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(7) <= '0';
               WHEN acq_39 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_40 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"AC";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_41 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                  END IF;
               WHEN acq_42 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                  END IF;
               WHEN acq_43 => 
                  IF (Err = '1') THEN 
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(15 DOWNTO 0);
                     WrEn_cld(8) <= '1';
                     Status(7) <= '1';
                  END IF;
               WHEN acq_44 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(8) <= '0';
               WHEN acq_45 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_46 => 
                  i2c_addr_cld <= "1000000";
                  i2c_wdata_cld <= X"E3";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_48 => 
                  IF (Err = '1') THEN 
                     Status(8) <= '0';
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                     Rd3_cld <= '1';
                  END IF;
               WHEN acq_49 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                     Rd3_cld <= '0';
                  END IF;
               WHEN acq_50 => 
                  IF (Err = '1') THEN 
                     Status(8) <= '0';
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(23 DOWNTO 8);
                     WrEn_cld(1) <= '1';
                     Status(8) <= '1';
                  END IF;
               WHEN acq_51 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(1) <= '0';
               WHEN acq_52 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_53 => 
                  i2c_addr_cld <= "1000000";
                  i2c_wdata_cld <= X"E5";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_54 => 
                  IF (Err = '1') THEN 
                     Status(9) <= '0';
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                     Rd3_cld <= '1';
                  END IF;
               WHEN acq_55 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                     Rd3_cld <= '0';
                  END IF;
               WHEN acq_56 => 
                  IF (Err = '1') THEN 
                     Status(9) <= '0';
                  ELSIF (Done = '1') THEN 
                     wData_cld(15 DOWNTO 0)
                       <= i2c_rdata(23 DOWNTO 8);
                     WrEn_cld(2) <= '1';
                     Status(9) <= '1';
                  END IF;
               WHEN acq_57 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(2) <= '0';
               WHEN acq_58 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_59 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"48";
                  Wr_cld <= '1' ;
                  WrStop_cld <= '1';
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                     WrStop_cld <= '0';
                  END IF;
               WHEN acq_60 => 
                  IF (Done = '1') THEN 
                  ELSIF (Err = '1') THEN 
                     Status(10) <= '0';
                  END IF;
               WHEN acq_62 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"00";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_63 => 
                  IF (Err = '1') THEN 
                     Status(10) <= '0';
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                     Rd3_cld <= '1';
                  END IF;
               WHEN acq_64 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                     Rd3_cld <= '0';
                  END IF;
               WHEN acq_65 => 
                  IF (Err = '1') THEN 
                     Status(10) <= '0';
                  ELSIF (Done = '1') THEN 
                     wData_cld
                       <= i2c_rdata;
                     WrEn_cld(9) <= '1';
                     WrEn_cld(10) <= '1';
                     Status(10) <= '1';
                  END IF;
               WHEN acq_66 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(9) <= '0';
                  WrEn_cld(10) <= '0';
               WHEN acq_67 => 
                  WrEn_cld(0) <= '0';
               WHEN acq_68 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"58";
                  Wr_cld <= '1' ;
                  WrStop_cld <= '1';
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                     WrStop_cld <= '0';
                  END IF;
               WHEN acq_69 => 
                  i2c_addr_cld <= "1110111";
                  i2c_wdata_cld <= X"00";
                  Wr_cld <= '1' ;
                  IF (Done = '0' AND Err = '0') THEN 
                     Wr_cld <= '0' ;
                  END IF;
               WHEN acq_70 => 
                  IF (Err = '1') THEN 
                     Status(11) <= '0';
                  END IF;
               WHEN acq_71 => 
                  IF (Err = '1') THEN 
                     Status(11) <= '0';
                  ELSIF (Done = '1') THEN 
                     Rd_cld <= '1' ;
                     Rd3_cld <= '1';
                  END IF;
               WHEN acq_73 => 
                  IF (Done = '0') THEN 
                     Rd_cld <= '0' ;
                     Rd3_cld <= '0';
                  END IF;
               WHEN acq_74 => 
                  IF (Err = '1') THEN 
                     Status(11) <= '0';
                  ELSIF (Done = '1') THEN 
                     wData_cld
                       <= i2c_rdata;
                     WrEn_cld(11) <= '1';
                     WrEn_cld(12) <= '1';
                     Status(11) <= '1';
                  END IF;
               WHEN acq_75 => 
                  wData_cld(15 DOWNTO 0)
                     <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(11) <= '0';
                  WrEn_cld(12) <= '0';
               WHEN acq_76 => 
                  WrEn_cld(0) <= '0';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      Done,
      Err,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_acq_9 <= '0';
      csm_to_acq_47 <= '0';
      csm_to_s7 <= '0';
      csm_to_acq_61 <= '0';
      csm_to_acq_72 <= '0';
      CASE current_state IS
         WHEN acq_0 => 
            IF (Done = '1') THEN 
               next_state <= acq_1;
            ELSE
               next_state <= acq_0;
            END IF;
         WHEN acq_1 => 
            IF (Done = '0') THEN 
               next_state <= acq_2;
            ELSE
               next_state <= acq_1;
            END IF;
         WHEN acq_2 => 
            IF (Done = '1') THEN 
               next_state <= acq_3;
            ELSIF (Err = '1') THEN 
               next_state <= acq_5;
            ELSE
               next_state <= acq_2;
            END IF;
         WHEN acq_3 => 
            next_state <= acq_4;
         WHEN acq_4 => 
            next_state <= acq_5;
         WHEN acq_5 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_6;
            ELSE
               next_state <= acq_5;
            END IF;
         WHEN acq_6 => 
            IF (Done = '1') THEN 
               next_state <= acq_7;
            ELSIF (Err = '1') THEN 
               next_state <= s0;
            ELSE
               next_state <= acq_6;
            END IF;
         WHEN acq_7 => 
            next_state <= acq_8;
         WHEN acq_8 => 
            next_state <= acq_9;
            csm_to_acq_9 <= '1';
         WHEN acq_9 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_10;
            ELSE
               next_state <= acq_9;
            END IF;
         WHEN s0 => 
            next_state <= s1;
         WHEN s1 => 
            next_state <= s2;
         WHEN acq_10 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_11;
            ELSE
               next_state <= acq_10;
            END IF;
         WHEN acq_11 => 
            IF (Err = '1') THEN 
               next_state <= s1;
            ELSIF (Done = '1') THEN 
               next_state <= acq_12;
            ELSE
               next_state <= acq_11;
            END IF;
         WHEN acq_14 => 
            next_state <= acq_15;
         WHEN acq_15 => 
            next_state <= acq_16;
         WHEN acq_12 => 
            IF (Done = '0') THEN 
               next_state <= acq_13;
            ELSE
               next_state <= acq_12;
            END IF;
         WHEN acq_13 => 
            IF (Done = '1') THEN 
               next_state <= acq_14;
            ELSIF (Err = '1') THEN 
               next_state <= s1;
            ELSE
               next_state <= acq_13;
            END IF;
         WHEN s2 => 
            next_state <= s3;
         WHEN acq_16 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_17;
            ELSE
               next_state <= acq_16;
            END IF;
         WHEN acq_17 => 
            IF (Err = '1') THEN 
               next_state <= s2;
            ELSIF (Done = '1') THEN 
               next_state <= acq_18;
            ELSE
               next_state <= acq_17;
            END IF;
         WHEN acq_18 => 
            IF (Done = '0') THEN 
               next_state <= acq_19;
            ELSE
               next_state <= acq_18;
            END IF;
         WHEN acq_19 => 
            IF (Err = '1') THEN 
               next_state <= s2;
            ELSIF (Done = '1') THEN 
               next_state <= acq_20;
            ELSE
               next_state <= acq_19;
            END IF;
         WHEN acq_20 => 
            next_state <= acq_21;
         WHEN acq_21 => 
            next_state <= acq_22;
         WHEN s3 => 
            next_state <= s4;
         WHEN acq_22 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_23;
            ELSE
               next_state <= acq_22;
            END IF;
         WHEN acq_23 => 
            IF (Err = '1') THEN 
               next_state <= s3;
            ELSIF (Done = '1') THEN 
               next_state <= acq_24;
            ELSE
               next_state <= acq_23;
            END IF;
         WHEN acq_24 => 
            IF (Done = '0') THEN 
               next_state <= acq_25;
            ELSE
               next_state <= acq_24;
            END IF;
         WHEN acq_25 => 
            IF (Err = '1') THEN 
               next_state <= s3;
            ELSIF (Done = '1') THEN 
               next_state <= acq_26;
            ELSE
               next_state <= acq_25;
            END IF;
         WHEN acq_26 => 
            next_state <= acq_27;
         WHEN acq_27 => 
            next_state <= acq_28;
         WHEN s4 => 
            next_state <= s5;
         WHEN acq_28 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_29;
            ELSE
               next_state <= acq_28;
            END IF;
         WHEN acq_29 => 
            IF (Err = '1') THEN 
               next_state <= s4;
            ELSIF (Done = '1') THEN 
               next_state <= acq_30;
            ELSE
               next_state <= acq_29;
            END IF;
         WHEN acq_30 => 
            IF (Done = '0') THEN 
               next_state <= acq_31;
            ELSE
               next_state <= acq_30;
            END IF;
         WHEN acq_31 => 
            IF (Err = '1') THEN 
               next_state <= s4;
            ELSIF (Done = '1') THEN 
               next_state <= acq_32;
            ELSE
               next_state <= acq_31;
            END IF;
         WHEN acq_32 => 
            next_state <= acq_33;
         WHEN acq_33 => 
            next_state <= acq_34;
         WHEN s5 => 
            next_state <= s6;
         WHEN acq_34 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_35;
            ELSE
               next_state <= acq_34;
            END IF;
         WHEN acq_35 => 
            IF (Err = '1') THEN 
               next_state <= s5;
            ELSIF (Done = '1') THEN 
               next_state <= acq_36;
            ELSE
               next_state <= acq_35;
            END IF;
         WHEN acq_36 => 
            IF (Done = '0') THEN 
               next_state <= acq_37;
            ELSE
               next_state <= acq_36;
            END IF;
         WHEN acq_37 => 
            IF (Err = '1') THEN 
               next_state <= s5;
            ELSIF (Done = '1') THEN 
               next_state <= acq_38;
            ELSE
               next_state <= acq_37;
            END IF;
         WHEN acq_38 => 
            next_state <= acq_39;
         WHEN acq_39 => 
            next_state <= acq_40;
         WHEN s6 => 
            next_state <= s7;
            csm_to_s7 <= '1';
         WHEN acq_40 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_41;
            ELSE
               next_state <= acq_40;
            END IF;
         WHEN acq_41 => 
            IF (Err = '1') THEN 
               next_state <= s6;
            ELSIF (Done = '1') THEN 
               next_state <= acq_42;
            ELSE
               next_state <= acq_41;
            END IF;
         WHEN acq_42 => 
            IF (Done = '0') THEN 
               next_state <= acq_43;
            ELSE
               next_state <= acq_42;
            END IF;
         WHEN acq_43 => 
            IF (Err = '1') THEN 
               next_state <= s6;
            ELSIF (Done = '1') THEN 
               next_state <= acq_44;
            ELSE
               next_state <= acq_43;
            END IF;
         WHEN acq_44 => 
            next_state <= acq_45;
         WHEN acq_45 => 
            next_state <= acq_47;
            csm_to_acq_47 <= '1';
         WHEN acq_47 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_46;
            ELSE
               next_state <= acq_47;
            END IF;
         WHEN s7 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_47;
               csm_to_acq_47 <= '1';
            ELSE
               next_state <= s7;
            END IF;
         WHEN acq_46 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_48;
            ELSE
               next_state <= acq_46;
            END IF;
         WHEN acq_48 => 
            IF (Err = '1') THEN 
               next_state <= acq_51;
            ELSIF (Done = '1') THEN 
               next_state <= acq_49;
            ELSE
               next_state <= acq_48;
            END IF;
         WHEN acq_49 => 
            IF (Done = '0') THEN 
               next_state <= acq_50;
            ELSE
               next_state <= acq_49;
            END IF;
         WHEN acq_50 => 
            IF (Err = '1') THEN 
               next_state <= acq_51;
            ELSIF (Done = '1') THEN 
               next_state <= acq_51;
            ELSE
               next_state <= acq_50;
            END IF;
         WHEN acq_51 => 
            next_state <= acq_52;
         WHEN acq_52 => 
            next_state <= acq_53;
         WHEN acq_53 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_54;
            ELSE
               next_state <= acq_53;
            END IF;
         WHEN acq_54 => 
            IF (Err = '1') THEN 
               next_state <= acq_57;
            ELSIF (Done = '1') THEN 
               next_state <= acq_55;
            ELSE
               next_state <= acq_54;
            END IF;
         WHEN acq_55 => 
            IF (Done = '0') THEN 
               next_state <= acq_56;
            ELSE
               next_state <= acq_55;
            END IF;
         WHEN acq_56 => 
            IF (Err = '1') THEN 
               next_state <= acq_57;
            ELSIF (Done = '1') THEN 
               next_state <= acq_57;
            ELSE
               next_state <= acq_56;
            END IF;
         WHEN acq_57 => 
            next_state <= acq_58;
         WHEN acq_58 => 
            next_state <= acq_59;
         WHEN acq_59 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_60;
            ELSE
               next_state <= acq_59;
            END IF;
         WHEN acq_60 => 
            IF (Done = '1') THEN 
               next_state <= acq_61;
               csm_to_acq_61 <= '1';
            ELSIF (Err = '1') THEN 
               next_state <= acq_66;
            ELSE
               next_state <= acq_60;
            END IF;
         WHEN acq_61 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_62;
            ELSE
               next_state <= acq_61;
            END IF;
         WHEN acq_62 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_63;
            ELSE
               next_state <= acq_62;
            END IF;
         WHEN acq_63 => 
            IF (Err = '1') THEN 
               next_state <= acq_66;
            ELSIF (Done = '1') THEN 
               next_state <= acq_64;
            ELSE
               next_state <= acq_63;
            END IF;
         WHEN acq_64 => 
            IF (Done = '0') THEN 
               next_state <= acq_65;
            ELSE
               next_state <= acq_64;
            END IF;
         WHEN acq_65 => 
            IF (Err = '1') THEN 
               next_state <= acq_66;
            ELSIF (Done = '1') THEN 
               next_state <= acq_66;
            ELSE
               next_state <= acq_65;
            END IF;
         WHEN acq_66 => 
            next_state <= acq_67;
         WHEN acq_67 => 
            next_state <= acq_68;
         WHEN acq_68 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_70;
            ELSE
               next_state <= acq_68;
            END IF;
         WHEN acq_69 => 
            IF (Done = '0' AND Err = '0') THEN 
               next_state <= acq_71;
            ELSE
               next_state <= acq_69;
            END IF;
         WHEN acq_70 => 
            IF (Err = '1') THEN 
               next_state <= acq_75;
            ELSIF (Done = '1') THEN 
               next_state <= acq_72;
               csm_to_acq_72 <= '1';
            ELSE
               next_state <= acq_70;
            END IF;
         WHEN acq_71 => 
            IF (Err = '1') THEN 
               next_state <= acq_75;
            ELSIF (Done = '1') THEN 
               next_state <= acq_73;
            ELSE
               next_state <= acq_71;
            END IF;
         WHEN acq_72 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_69;
            ELSE
               next_state <= acq_72;
            END IF;
         WHEN acq_73 => 
            IF (Done = '0') THEN 
               next_state <= acq_74;
            ELSE
               next_state <= acq_73;
            END IF;
         WHEN acq_74 => 
            IF (Err = '1') THEN 
               next_state <= acq_75;
            ELSIF (Done = '1') THEN 
               next_state <= acq_75;
            ELSE
               next_state <= acq_74;
            END IF;
         WHEN acq_75 => 
            next_state <= acq_76;
         WHEN acq_76 => 
            next_state <= acq_46;
         WHEN OTHERS =>
            next_state <= acq_0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_acq_9,
      csm_to_acq_47,
      csm_to_s7,
      csm_to_acq_61,
      csm_to_acq_72
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_acq_9 = '1') THEN
         csm_next_timer <= "010011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_acq_47 = '1') THEN
         csm_next_timer <= "111101000010001111"; -- no cycles(250000)-1=249999
      ELSIF (csm_to_s7 = '1') THEN
         csm_next_timer <= "011110100001000111"; -- no cycles(125000)-1=124999
      ELSIF (csm_to_acq_61 = '1') THEN
         csm_next_timer <= "111101000010001111"; -- no cycles(250000)-1=249999
      ELSIF (csm_to_acq_72 = '1') THEN
         csm_next_timer <= "111101000010001111"; -- no cycles(250000)-1=249999
      ELSE
         IF (csm_temp_timeout = '1') THEN
            csm_next_timer <= (OTHERS=>'0');
         ELSE
            csm_next_timer <= unsigned(csm_timer) - '1';
         END IF;
      END IF;
      csm_timeout <= csm_temp_timeout;
   END PROCESS csm_wait_combo_proc;

   -- Concurrent Statements
   -- Clocked output assignments
   Rd <= Rd_cld;
   Rd3 <= Rd3_cld;
   Wr <= Wr_cld;
   WrEn <= WrEn_cld;
   WrStop <= WrStop_cld;
   i2c_addr <= i2c_addr_cld;
   i2c_wdata <= i2c_wdata_cld;
   wData <= wData_cld;
END fsm;
