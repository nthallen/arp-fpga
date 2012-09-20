-- VHDL Entity idx_fpga_lib.lk204_sm.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 08:53:57 09/20/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_sm IS
   GENERIC( 
      LK204_ADDR0 : std_logic_vector(6 downto 0) := "0101000";
      PCA_ADDR    : std_logic_vector(6 downto 0) := "0100000"
   );
   PORT( 
      CharData : IN     std_logic_vector (8 DOWNTO 0);
      Done     : IN     std_logic;
      Empty    : IN     std_logic;
      Err      : IN     std_logic;
      F8M      : IN     std_ulogic;
      Full     : IN     std_logic;
      I2Crdata : IN     std_logic_vector (7 DOWNTO 0);
      Rst      : IN     std_logic;
      timeout  : IN     std_logic;
      I2Cwdata : OUT    std_logic_vector (7 DOWNTO 0);
      RE       : OUT    std_logic;
      RdI2C    : OUT    std_logic;
      SData    : OUT    std_logic_vector (7 DOWNTO 0);
      Status   : OUT    std_logic_vector (15 DOWNTO 0);
      TOrst    : OUT    std_logic;
      WE       : OUT    std_logic;
      WrI2C    : OUT    std_logic;
      WrStart  : OUT    std_logic;
      WrStop   : OUT    std_logic
   );

-- Declarations

END lk204_sm ;

--
-- VHDL Architecture idx_fpga_lib.lk204_sm.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 08:53:57 09/20/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF lk204_sm IS

   -- Architecture Declarations
   SIGNAL NowEmpty : std_logic;  
   SIGNAL OutChar : std_logic_vector(7 DOWNTO 0);  
   SIGNAL OutLK204 : std_logic;  
   SIGNAL OutVal : std_logic_vector(7 DOWNTO 0);  
   SIGNAL lk204_addr : std_logic_vector(6 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      init,
      lksm_idle,
      to_rst,
      lksm_0,
      di_1,
      wr_1,
      rd_1,
      di_2,
      di_3,
      di_4,
      di_5,
      di_6,
      di_9,
      di_10,
      di_31,
      di_8,
      di_7,
      di_11,
      di_12,
      di_13,
      di_14,
      di_15,
      di_16,
      di_17,
      di_18,
      di_19,
      di_20,
      di_21,
      di_22,
      di_23,
      di_24,
      di_25,
      di_26,
      di_27,
      di_28,
      di_29,
      di_30,
      wr_2,
      wr_39,
      wr_40,
      wr_42,
      wr_43,
      wr_44,
      wr_46,
      wr_47,
      wr_31,
      wr_32,
      wr_33,
      wr_34,
      wr_35,
      wr_36,
      wr_37,
      wr_3,
      rd_2,
      rd_3,
      rd_9,
      rd_7,
      rd_r,
      rd_10,
      rd_8,
      rd_5,
      rd_6,
      rd_11,
      rd_17,
      rd_15,
      rd_12,
      rd_18,
      rd_16,
      rd_13,
      rd_14,
      rd_19,
      rd_20,
      rd_21,
      rd_22,
      rd_23,
      wr_4,
      wr_48,
      wr_49,
      di_32,
      di_33,
      di_34,
      di_35,
      di_36,
      di_37,
      di_38,
      di_39
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL I2Cwdata_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL RE_cld : std_logic ;
   SIGNAL RdI2C_cld : std_logic ;
   SIGNAL SData_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL Status_cld : std_logic_vector (15 DOWNTO 0);
   SIGNAL TOrst_cld : std_logic ;
   SIGNAL WE_cld : std_logic ;
   SIGNAL WrI2C_cld : std_logic ;
   SIGNAL WrStart_cld : std_logic ;
   SIGNAL WrStop_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (Rst = '1') THEN
            current_state <= init;
            -- Default Reset Values
            I2Cwdata_cld <= (others => '0');
            RE_cld <= '0';
            RdI2C_cld <= '0';
            SData_cld <= (others => '0');
            Status_cld <= (others => '0');
            TOrst_cld <= '0';
            WE_cld <= '0';
            WrI2C_cld <= '0';
            WrStart_cld <= '0';
            WrStop_cld <= '0';
            NowEmpty <= '0';
            OutChar <= (others => '0');
            OutLK204 <= '0';
            OutVal <= (others => '0');
            lk204_addr <= LK204_ADDR0;
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN init => 
                  TOrst_cld <= '1';
                  WrI2C_cld <= '0';
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  I2Cwdata_cld <= (others => '0');
                  RE_cld <= '0';
                  WE_cld <= '0';
                  Status_cld <= (others => '0');
                  OutVal <= (others => '0');
               WHEN to_rst => 
                  TOrst_cld <= '1';
               WHEN lksm_0 => 
                  TOrst_cld <= '0';
               WHEN di_1 => 
                  I2Cwdata_cld <=
                    lk204_addr & '0';
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN wr_1 => 
                  OutLK204 <=
                    CharData(8);
               WHEN di_2 => 
                  WrI2C_cld <= '0';
               WHEN di_3 => 
                  I2Cwdata_cld <= X"FE";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_4 => 
                  WrI2C_cld <= '0';
               WHEN di_5 => 
                  I2Cwdata_cld <= X"4F";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_6 => 
                  WrI2C_cld <= '0';
               WHEN di_9 => 
                  Status_cld(1) <= '1';
               WHEN di_31 => 
                  Status_cld(0) <= '1';
               WHEN di_7 => 
                  I2Cwdata_cld <= X"FF";
                  WrStart_cld <= '0';
                  WrStop_cld <= '1';
                  WrI2C_cld <= '1';
               WHEN di_11 => 
                  I2Cwdata_cld <= X"03";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_12 => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "0";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_13 => 
                  WrI2C_cld <= '0';
               WHEN di_14 => 
                  WrI2C_cld <= '0';
               WHEN di_15 => 
                  WrI2C_cld <= '0';
               WHEN di_17 => 
                  I2Cwdata_cld <= X"00";
                  WrStart_cld <= '0';
                  WrStop_cld <= '1';
                  WrI2C_cld <= '1';
               WHEN di_18 => 
                  I2Cwdata_cld <= X"02";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_19 => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "0";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_20 => 
                  WrI2C_cld <= '0';
               WHEN di_21 => 
                  WrI2C_cld <= '0';
               WHEN di_22 => 
                  WrI2C_cld <= '0';
               WHEN di_24 => 
                  I2Cwdata_cld <= OutVal;
                  WrStart_cld <= '0';
                  WrStop_cld <= '1';
                  WrI2C_cld <= '1';
               WHEN di_25 => 
                  I2Cwdata_cld <= X"01";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_26 => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "0";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_27 => 
                  WrI2C_cld <= '0';
               WHEN di_28 => 
                  WrI2C_cld <= '0';
               WHEN di_29 => 
                  WrI2C_cld <= '0';
               WHEN wr_39 => 
                  I2Cwdata_cld <= OutChar;
                  WrStart_cld <= '0';
                  WrStop_cld <= NowEmpty;
                  WrI2C_cld <= '1';
               WHEN wr_40 => 
                  I2Cwdata_cld <=
                    lk204_addr & '0';
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN wr_42 => 
                  WrI2C_cld <= '0';
               WHEN wr_43 => 
                  WrI2C_cld <= '0';
               WHEN wr_46 => 
                  OutChar <=
                    CharData(7 downto 0);
                  NowEmpty <= '1';
                  RE_cld <= '1';
               WHEN wr_47 => 
                  RE_cld <= '0';
               WHEN wr_31 => 
                  I2Cwdata_cld <= OutVal;
                  WrStart_cld <= '0';
                  WrStop_cld <= '1';
                  WrI2C_cld <= '1';
               WHEN wr_32 => 
                  I2Cwdata_cld <= X"01";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN wr_33 => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "0";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN wr_34 => 
                  WrI2C_cld <= '0';
               WHEN wr_35 => 
                  WrI2C_cld <= '0';
               WHEN wr_36 => 
                  WrI2C_cld <= '0';
               WHEN wr_3 => 
                  OutVal <=
                    CharData(7 downto 0);
                  RE_cld <= '1';
               WHEN rd_9 => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "1";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  RdI2C_cld <= '1';
               WHEN rd_7 => 
                  I2Cwdata_cld <= X"00";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN rd_r => 
                  I2Cwdata_cld <=
                    PCA_ADDR & "0";
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN rd_10 => 
                  RdI2C_cld <= '0';
               WHEN rd_8 => 
                  WrI2C_cld <= '0';
               WHEN rd_5 => 
                  WrI2C_cld <= '0';
               WHEN rd_6 => 
                  Status_cld(3) <= '0';
               WHEN rd_11 => 
                  Status_cld(15 downto 8)
                   <= I2Crdata;
                  Status_cld(3) <= '1';
               WHEN rd_17 => 
                  I2Cwdata_cld <= X"26";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN rd_15 => 
                  I2Cwdata_cld <= X"FE";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN rd_12 => 
                  I2Cwdata_cld <=
                    lk204_addr & '0';
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN rd_18 => 
                  WrI2C_cld
                    <= '0';
               WHEN rd_16 => 
                  WrI2C_cld <= '0';
               WHEN rd_13 => 
                  WrI2C_cld <= '0';
               WHEN rd_14 => 
                  Status_cld(2) <= '0';
               WHEN rd_19 => 
                  I2Cwdata_cld <=
                    lk204_addr & '1';
                  WrStart_cld <= '1';
                  WrStop_cld <= '0';
                  RdI2C_cld <= '1';
               WHEN rd_20 => 
                  RdI2C_cld <= '0';
               WHEN rd_21 => 
                  SData_cld <= I2Crdata;
                  WE_cld <= '1';
               WHEN rd_22 => 
                  WE_cld <= '0';
                  Status_cld(2) <= '1';
               WHEN rd_23 => 
                  Status_cld(2)
                    <= '1';
               WHEN wr_4 => 
                  RE_cld <= '0';
               WHEN wr_49 => 
                  NowEmpty <= '0';
               WHEN di_32 => 
                  lk204_addr <=
                    lk204_addr + 1;
               WHEN di_34 => 
                  I2Cwdata_cld <= X"FE";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_35 => 
                  WrI2C_cld <= '0';
               WHEN di_36 => 
                  I2Cwdata_cld <= X"A0";
                  WrStart_cld <= '0';
                  WrStop_cld <= '0';
                  WrI2C_cld <= '1';
               WHEN di_37 => 
                  WrI2C_cld <= '0';
               WHEN di_38 => 
                  I2Cwdata_cld <= X"00";
                  WrStart_cld <= '0';
                  WrStop_cld <= '1';
                  WrI2C_cld <= '1';
               WHEN di_39 => 
                  WrI2C_cld <= '0';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      CharData,
      Done,
      Empty,
      Err,
      Full,
      I2Crdata,
      NowEmpty,
      OutLK204,
      Status_cld,
      current_state,
      lk204_addr,
      timeout
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN init => 
            IF (Done = '1') THEN 
               next_state <= di_10;
            ELSE
               next_state <= init;
            END IF;
         WHEN lksm_idle => 
            IF (Empty = '0') THEN 
               next_state <= wr_1;
            ELSIF (timeout = '1') THEN 
               next_state <= rd_1;
            ELSE
               next_state <= lksm_idle;
            END IF;
         WHEN to_rst => 
            IF (timeout = '0') THEN 
               next_state <= lksm_0;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN lksm_0 => 
            next_state <= lksm_idle;
         WHEN di_1 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_2;
            ELSE
               next_state <= di_1;
            END IF;
         WHEN wr_1 => 
            next_state <= wr_2;
         WHEN rd_1 => 
            IF (Status_cld(1) = '1') THEN 
               next_state <= rd_r;
            ELSE
               next_state <= rd_2;
            END IF;
         WHEN di_2 => 
            IF (Err = '1') THEN 
               next_state <= di_32;
            ELSIF (Done = '1') THEN 
               next_state <= di_3;
            ELSE
               next_state <= di_2;
            END IF;
         WHEN di_3 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_4;
            ELSE
               next_state <= di_3;
            END IF;
         WHEN di_4 => 
            IF (Err = '1') THEN 
               next_state <= di_8;
            ELSIF (Done = '1') THEN 
               next_state <= di_5;
            ELSE
               next_state <= di_4;
            END IF;
         WHEN di_5 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_6;
            ELSE
               next_state <= di_5;
            END IF;
         WHEN di_6 => 
            IF (Err = '1') THEN 
               next_state <= di_8;
            ELSIF (Done = '1') THEN 
               next_state <= di_34;
            ELSE
               next_state <= di_6;
            END IF;
         WHEN di_9 => 
            next_state <= to_rst;
         WHEN di_10 => 
            IF (Status_cld(1 downto 0) = "11") THEN 
               next_state <= to_rst;
            ELSIF (Status_cld(0) /= '1') THEN 
               next_state <= di_1;
            ELSE
               next_state <= di_12;
            END IF;
         WHEN di_31 => 
            IF (Status_cld(1) /= '1') THEN 
               next_state <= di_12;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN di_8 => 
            IF (Done = '1') THEN 
               next_state <= di_31;
            ELSIF (Status_cld(1) /= '1') THEN 
               next_state <= di_12;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN di_7 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_13;
            ELSE
               next_state <= di_7;
            END IF;
         WHEN di_11 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_14;
            ELSE
               next_state <= di_11;
            END IF;
         WHEN di_12 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_15;
            ELSE
               next_state <= di_12;
            END IF;
         WHEN di_13 => 
            IF (Done = '1' OR
                Err = '1') THEN 
               next_state <= di_16;
            ELSE
               next_state <= di_13;
            END IF;
         WHEN di_14 => 
            IF (Err = '1') THEN 
               next_state <= di_16;
            ELSIF (Done = '1') THEN 
               next_state <= di_7;
            ELSE
               next_state <= di_14;
            END IF;
         WHEN di_15 => 
            IF (Err = '1') THEN 
               next_state <= di_16;
            ELSIF (Done = '1') THEN 
               next_state <= di_11;
            ELSE
               next_state <= di_15;
            END IF;
         WHEN di_16 => 
            IF (Done = '1') THEN 
               next_state <= di_19;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN di_17 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_20;
            ELSE
               next_state <= di_17;
            END IF;
         WHEN di_18 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_21;
            ELSE
               next_state <= di_18;
            END IF;
         WHEN di_19 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_22;
            ELSE
               next_state <= di_19;
            END IF;
         WHEN di_20 => 
            IF (Done = '1' OR
                Err = '1') THEN 
               next_state <= di_23;
            ELSE
               next_state <= di_20;
            END IF;
         WHEN di_21 => 
            IF (Err = '1') THEN 
               next_state <= di_23;
            ELSIF (Done = '1') THEN 
               next_state <= di_17;
            ELSE
               next_state <= di_21;
            END IF;
         WHEN di_22 => 
            IF (Err = '1') THEN 
               next_state <= di_23;
            ELSIF (Done = '1') THEN 
               next_state <= di_18;
            ELSE
               next_state <= di_22;
            END IF;
         WHEN di_23 => 
            IF (Done = '1') THEN 
               next_state <= di_26;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN di_24 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_27;
            ELSE
               next_state <= di_24;
            END IF;
         WHEN di_25 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_28;
            ELSE
               next_state <= di_25;
            END IF;
         WHEN di_26 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_29;
            ELSE
               next_state <= di_26;
            END IF;
         WHEN di_27 => 
            IF (Done = '1' OR
                Err = '1') THEN 
               next_state <= di_30;
            ELSE
               next_state <= di_27;
            END IF;
         WHEN di_28 => 
            IF (Err = '1') THEN 
               next_state <= di_30;
            ELSIF (Done = '1') THEN 
               next_state <= di_24;
            ELSE
               next_state <= di_28;
            END IF;
         WHEN di_29 => 
            IF (Err = '1') THEN 
               next_state <= di_30;
            ELSIF (Done = '1') THEN 
               next_state <= di_25;
            ELSE
               next_state <= di_29;
            END IF;
         WHEN di_30 => 
            IF (Done = '1') THEN 
               next_state <= di_9;
            ELSE
               next_state <= to_rst;
            END IF;
         WHEN wr_2 => 
            IF (OutLK204 = '1' AND
                Status_cld(0) = '1') THEN 
               next_state <= wr_40;
            ELSIF (OutLK204 /= '1') THEN 
               next_state <= wr_3;
            ELSE
               next_state <= lksm_idle;
            END IF;
         WHEN wr_39 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= wr_42;
            ELSE
               next_state <= wr_39;
            END IF;
         WHEN wr_40 => 
            IF (Done = '0'
                  AND
                Err = '0') THEN 
               next_state <= wr_43;
            ELSE
               next_state <= wr_40;
            END IF;
         WHEN wr_42 => 
            IF (Err = '1' OR
                (Done = '1' AND
                 NowEmpty = '1')) THEN 
               next_state <= wr_44;
            ELSIF (Done = '1' AND
                   NowEmpty /= '1') THEN 
               next_state <= wr_46;
            ELSE
               next_state <= wr_42;
            END IF;
         WHEN wr_43 => 
            IF (Done = '1'
                   OR
                Err = '1') THEN 
               next_state <= wr_46;
            ELSE
               next_state <= wr_43;
            END IF;
         WHEN wr_44 => 
            next_state <= lksm_idle;
         WHEN wr_46 => 
            next_state <= wr_47;
         WHEN wr_47 => 
            IF (Err = '1') THEN 
               next_state <= lksm_idle;
            ELSE
               next_state <= wr_48;
            END IF;
         WHEN wr_31 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= wr_34;
            ELSE
               next_state <= wr_31;
            END IF;
         WHEN wr_32 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= wr_35;
            ELSE
               next_state <= wr_32;
            END IF;
         WHEN wr_33 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= wr_36;
            ELSE
               next_state <= wr_33;
            END IF;
         WHEN wr_34 => 
            IF (Done = '1' OR
                Err = '1') THEN 
               next_state <= wr_37;
            ELSE
               next_state <= wr_34;
            END IF;
         WHEN wr_35 => 
            IF (Err = '1') THEN 
               next_state <= wr_37;
            ELSIF (Done = '1') THEN 
               next_state <= wr_31;
            ELSE
               next_state <= wr_35;
            END IF;
         WHEN wr_36 => 
            IF (Err = '1') THEN 
               next_state <= wr_37;
            ELSIF (Done = '1') THEN 
               next_state <= wr_32;
            ELSE
               next_state <= wr_36;
            END IF;
         WHEN wr_37 => 
            next_state <= lksm_idle;
         WHEN wr_3 => 
            next_state <= wr_4;
         WHEN rd_2 => 
            IF (Status_cld(0) = '1'
                AND Full /= '1') THEN 
               next_state <= rd_12;
            ELSE
               next_state <= rd_3;
            END IF;
         WHEN rd_3 => 
            next_state <= di_10;
         WHEN rd_9 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_10;
            ELSE
               next_state <= rd_9;
            END IF;
         WHEN rd_7 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_8;
            ELSE
               next_state <= rd_7;
            END IF;
         WHEN rd_r => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_5;
            ELSE
               next_state <= rd_r;
            END IF;
         WHEN rd_10 => 
            IF (Err = '1') THEN 
               next_state <= rd_6;
            ELSIF (Done = '1') THEN 
               next_state <= rd_11;
            ELSE
               next_state <= rd_10;
            END IF;
         WHEN rd_8 => 
            IF (Err = '1') THEN 
               next_state <= rd_6;
            ELSIF (Done = '1') THEN 
               next_state <= rd_9;
            ELSE
               next_state <= rd_8;
            END IF;
         WHEN rd_5 => 
            IF (Err = '1') THEN 
               next_state <= rd_6;
            ELSIF (Done = '1') THEN 
               next_state <= rd_7;
            ELSE
               next_state <= rd_5;
            END IF;
         WHEN rd_6 => 
            next_state <= rd_2;
         WHEN rd_11 => 
            next_state <= rd_2;
         WHEN rd_17 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_18;
            ELSE
               next_state <= rd_17;
            END IF;
         WHEN rd_15 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_16;
            ELSE
               next_state <= rd_15;
            END IF;
         WHEN rd_12 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_13;
            ELSE
               next_state <= rd_12;
            END IF;
         WHEN rd_18 => 
            IF (Err = '1') THEN 
               next_state <= rd_14;
            ELSIF (Done = '1') THEN 
               next_state <= rd_19;
            ELSE
               next_state <= rd_18;
            END IF;
         WHEN rd_16 => 
            IF (Err = '1') THEN 
               next_state <= rd_14;
            ELSIF (Done = '1') THEN 
               next_state <= rd_17;
            ELSE
               next_state <= rd_16;
            END IF;
         WHEN rd_13 => 
            IF (Err = '1') THEN 
               next_state <= rd_14;
            ELSIF (Done = '1') THEN 
               next_state <= rd_15;
            ELSE
               next_state <= rd_13;
            END IF;
         WHEN rd_14 => 
            next_state <= rd_3;
         WHEN rd_19 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= rd_20;
            ELSE
               next_state <= rd_19;
            END IF;
         WHEN rd_20 => 
            IF (Err = '1') THEN 
               next_state <= rd_14;
            ELSIF (Done = '1' AND
                   I2Crdata /= X"00") THEN 
               next_state <= rd_21;
            ELSIF (Done = '1' AND
                    I2Crdata = X"00") THEN 
               next_state <= rd_23;
            ELSE
               next_state <= rd_20;
            END IF;
         WHEN rd_21 => 
            next_state <= rd_22;
         WHEN rd_22 => 
            IF (I2Crdata(7) = '1'
                AND Full /= '1') THEN 
               next_state <= rd_12;
            ELSE
               next_state <= rd_3;
            END IF;
         WHEN rd_23 => 
            next_state <= rd_3;
         WHEN wr_4 => 
            IF (Status_cld(1) = '1') THEN 
               next_state <= wr_33;
            ELSE
               next_state <= lksm_idle;
            END IF;
         WHEN wr_48 => 
            IF (Empty = '0' AND
                CharData(8) = '1') THEN 
               next_state <= wr_49;
            ELSE
               next_state <= wr_39;
            END IF;
         WHEN wr_49 => 
            next_state <= wr_39;
         WHEN di_32 => 
            next_state <= di_33;
         WHEN di_33 => 
            IF (lk204_addr = LK204_ADDR0) THEN 
               next_state <= di_8;
            ELSIF (lk204_addr = PCA_ADDR) THEN 
               next_state <= di_32;
            ELSE
               next_state <= di_1;
            END IF;
         WHEN di_34 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_35;
            ELSE
               next_state <= di_34;
            END IF;
         WHEN di_35 => 
            IF (Err = '1') THEN 
               next_state <= di_8;
            ELSIF (Done = '1') THEN 
               next_state <= di_36;
            ELSE
               next_state <= di_35;
            END IF;
         WHEN di_36 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_37;
            ELSE
               next_state <= di_36;
            END IF;
         WHEN di_37 => 
            IF (Err = '1') THEN 
               next_state <= di_8;
            ELSIF (Done = '1') THEN 
               next_state <= di_38;
            ELSE
               next_state <= di_37;
            END IF;
         WHEN di_38 => 
            IF (Done = '0' AND
                Err = '0') THEN 
               next_state <= di_39;
            ELSE
               next_state <= di_38;
            END IF;
         WHEN di_39 => 
            IF (Done = '1'
                  OR
                Err = '1') THEN 
               next_state <= di_8;
            ELSE
               next_state <= di_39;
            END IF;
         WHEN OTHERS =>
            next_state <= init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   I2Cwdata <= I2Cwdata_cld;
   RE <= RE_cld;
   RdI2C <= RdI2C_cld;
   SData <= SData_cld;
   Status <= Status_cld;
   TOrst <= TOrst_cld;
   WE <= WE_cld;
   WrI2C <= WrI2C_cld;
   WrStart <= WrStart_cld;
   WrStop <= WrStop_cld;
END fsm;
