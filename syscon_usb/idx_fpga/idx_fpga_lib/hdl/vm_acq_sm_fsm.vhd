-- VHDL Entity idx_fpga_lib.vm_acq_sm.interface
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 10:37:18 02/09/12
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY vm_acq_sm IS
   GENERIC( 
      I2C_ADDR1 : std_logic_vector(6 DOWNTO 0) := "1101000";
      I2C_ADDR2 : std_logic_vector(6 DOWNTO 0) := "1101001"
   );
   PORT( 
      Done      : IN     std_logic;
      Err       : IN     std_logic;
      F8M       : IN     std_ulogic;
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
      rst       : IN     std_ulogic;
      Rd        : OUT    std_logic;
      Rd3       : OUT    std_logic;
      Wr        : OUT    std_logic;
      WrEn      : OUT    std_ulogic_vector (4 DOWNTO 0);
      WrStop    : OUT    std_logic;
      i2c_addr  : OUT    std_logic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      wData     : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END vm_acq_sm ;

--
-- VHDL Architecture idx_fpga_lib.vm_acq_sm.fsm
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 16:56:49 06/27/13
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF vm_acq_sm IS

   -- Architecture Declarations
   SIGNAL Status : std_logic_vector(15 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      vm_reset,
      vm_rst1,
      vm_I1_a,
      vm_I1_b,
      vm_I1_c,
      vm_I1_d,
      vm_I1_e,
      vm_I1_f,
      vm_I1_g,
      vm_to,
      vm_to1,
      vm_to2,
      vm_V1_a,
      vm_V1_b,
      vm_V1_c,
      vm_V1_e,
      vm_V1_d,
      vm_V1_f,
      vm_V1_g,
      vm_I2_a,
      vm_V2_a,
      vm_I2_b,
      vm_V2_b,
      vm_I2_c,
      vm_V1_c1,
      vm_I2_e,
      vm_I2_d,
      vm_V2_e,
      vm_V2_d,
      vm_I2_f,
      vm_V2_f,
      vm_I2_g,
      vm_V2_g,
      vm_I1_h,
      vm_V1_h,
      vm_I2_h,
      vm_V2_h
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(16 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(16 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_vm_I1_b : std_logic;
   SIGNAL csm_to_vm_I1_e : std_logic;
   SIGNAL csm_to_vm_V1_b : std_logic;
   SIGNAL csm_to_vm_V1_e : std_logic;
   SIGNAL csm_to_vm_I2_b : std_logic;
   SIGNAL csm_to_vm_V2_b : std_logic;
   SIGNAL csm_to_vm_I2_e : std_logic;
   SIGNAL csm_to_vm_V2_e : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL Rd_cld : std_logic ;
   SIGNAL Rd3_cld : std_logic ;
   SIGNAL Wr_cld : std_logic ;
   SIGNAL WrEn_cld : std_ulogic_vector (4 DOWNTO 0);
   SIGNAL WrStop_cld : std_logic ;
   SIGNAL i2c_addr_cld : std_logic_vector (6 DOWNTO 0);
   SIGNAL i2c_wdata_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL wData_cld : std_logic_vector (15 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= vm_reset;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            Rd_cld <= '0';
            Rd3_cld <= '0';
            Wr_cld <= '0';
            WrEn_cld <= "00000";
            WrStop_cld <= '0';
            i2c_addr_cld <= "0000000";
            i2c_wdata_cld <= X"00";
            wData_cld <= X"0000";
            Status <= X"0000";
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;

            -- Combined Actions
            CASE current_state IS
               WHEN vm_reset => 
                  Status <= (others => '0');
                  wData_cld <= (others => '0');
                  WrEn_cld <= "11111";
                  Rd_cld <= '0';
                  Rd3_cld <= '0';
                  Wr_cld <= '0';
                  WrStop_cld <= '0';
               WHEN vm_rst1 => 
                  WrEn_cld <= "00000";
               WHEN vm_I1_a => 
                  i2c_addr_cld <= I2C_ADDR1;
                  i2c_wdata_cld <= X"00";
                  Wr_cld <= '1';
                  WrStop_cld <= '0';
               WHEN vm_I1_b => 
                  Wr_cld <= '0';
               WHEN vm_I1_c => 
                  Rd_cld <= '1';
               WHEN vm_I1_d => 
                  Status(0) <= '0';
               WHEN vm_I1_e => 
                  Rd_cld <= '0';
               WHEN vm_I1_f => 
                  wData_cld <=
                    i2c_rdata(15 DOWNTO 0);
                  WrEn_cld(1) <= '1';
                  Status(0) <= '1';
               WHEN vm_I1_g => 
                  wData_cld <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(1) <= '0';
               WHEN vm_to => 
                  Status <= X"0010";
               WHEN vm_to1 => 
                  wData_cld <= Status;
                  WrEn_cld(0) <= '1';
               WHEN vm_to2 => 
                  WrEn_cld(0) <= '0';
               WHEN vm_V1_a => 
                  i2c_addr_cld <= I2C_ADDR1;
                  i2c_wdata_cld <= X"02";
                  Wr_cld <= '1';
                  WrStop_cld <= '0';
               WHEN vm_V1_b => 
                  Wr_cld <= '0';
               WHEN vm_V1_c => 
                  Rd_cld <= '1';
               WHEN vm_V1_e => 
                  Rd_cld <= '0';
               WHEN vm_V1_d => 
                  Status(1) <= '0';
               WHEN vm_V1_f => 
                  wData_cld <=
                    i2c_rdata(15 DOWNTO 0);
                  WrEn_cld(2) <= '1';
                  Status(1) <= '1';
               WHEN vm_V1_g => 
                  wData_cld <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(2) <= '0';
               WHEN vm_I2_a => 
                  i2c_addr_cld <= I2C_ADDR2;
                  i2c_wdata_cld <= X"00";
                  Wr_cld <= '1';
                  WrStop_cld <= '0';
               WHEN vm_V2_a => 
                  i2c_addr_cld <= I2C_ADDR2;
                  i2c_wdata_cld <= X"02";
                  Wr_cld <= '1';
                  WrStop_cld <= '0';
               WHEN vm_I2_b => 
                  Wr_cld <= '0';
               WHEN vm_V2_b => 
                  Wr_cld <= '0';
               WHEN vm_I2_c => 
                  Rd_cld <= '1';
               WHEN vm_V1_c1 => 
                  Rd_cld <= '1';
               WHEN vm_I2_e => 
                  Rd_cld <= '0';
               WHEN vm_I2_d => 
                  Status(2) <= '0';
               WHEN vm_V2_e => 
                  Rd_cld <= '0';
               WHEN vm_V2_d => 
                  Status(3) <= '0';
               WHEN vm_I2_f => 
                  wData_cld <=
                    i2c_rdata(15 DOWNTO 0);
                  WrEn_cld(3) <= '1';
                  Status(2) <= '1';
               WHEN vm_V2_f => 
                  wData_cld <=
                    i2c_rdata(15 DOWNTO 0);
                  WrEn_cld(4) <= '1';
                  Status(3) <= '1';
               WHEN vm_I2_g => 
                  wData_cld <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(3) <= '0';
               WHEN vm_V2_g => 
                  wData_cld <= Status;
                  WrEn_cld(0) <= '1';
                  WrEn_cld(4) <= '0';
               WHEN vm_I1_h => 
                  WrEn_cld(0) <= '0';
               WHEN vm_V1_h => 
                  WrEn_cld(0) <= '0';
               WHEN vm_I2_h => 
                  WrEn_cld(0) <= '0';
               WHEN vm_V2_h => 
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
      csm_to_vm_I1_b <= '0';
      csm_to_vm_I1_e <= '0';
      csm_to_vm_V1_b <= '0';
      csm_to_vm_V1_e <= '0';
      csm_to_vm_I2_b <= '0';
      csm_to_vm_V2_b <= '0';
      csm_to_vm_I2_e <= '0';
      csm_to_vm_V2_e <= '0';
      CASE current_state IS
         WHEN vm_reset => 
            next_state <= vm_rst1;
         WHEN vm_rst1 => 
            IF (Done = '1'
                  OR
                Err = '1') THEN 
               next_state <= vm_I1_a;
            ELSE
               next_state <= vm_rst1;
            END IF;
         WHEN vm_I1_a => 
            IF (Done = '0'
                  AND
                Err = '0') THEN 
               next_state <= vm_I1_b;
               csm_to_vm_I1_b <= '1';
            ELSE
               next_state <= vm_I1_a;
            END IF;
         WHEN vm_I1_b => 
            IF (Done = '1') THEN 
               next_state <= vm_I1_c;
            ELSIF (Err = '1') THEN 
               next_state <= vm_I1_d;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSE
               next_state <= vm_I1_b;
            END IF;
         WHEN vm_I1_c => 
            IF (Done = '0') THEN 
               next_state <= vm_I1_e;
               csm_to_vm_I1_e <= '1';
            ELSE
               next_state <= vm_I1_c;
            END IF;
         WHEN vm_I1_d => 
            next_state <= vm_I1_g;
         WHEN vm_I1_e => 
            IF (Done = '1') THEN 
               next_state <= vm_I1_f;
            ELSIF (Err = '1') THEN 
               next_state <= vm_I1_d;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSE
               next_state <= vm_I1_e;
            END IF;
         WHEN vm_I1_f => 
            next_state <= vm_I1_g;
         WHEN vm_I1_g => 
            next_state <= vm_I1_h;
         WHEN vm_to => 
            next_state <= vm_to1;
         WHEN vm_to1 => 
            next_state <= vm_to2;
         WHEN vm_to2 => 
            IF (Done = '1'
                  OR
                Err = '1') THEN 
               next_state <= vm_I1_a;
            ELSE
               next_state <= vm_to2;
            END IF;
         WHEN vm_V1_a => 
            IF (Done = '0'
                  AND
                Err = '0') THEN 
               next_state <= vm_V1_b;
               csm_to_vm_V1_b <= '1';
            ELSE
               next_state <= vm_V1_a;
            END IF;
         WHEN vm_V1_b => 
            IF (Done = '1') THEN 
               next_state <= vm_V1_c;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSIF (Err = '1') THEN 
               next_state <= vm_V1_d;
            ELSE
               next_state <= vm_V1_b;
            END IF;
         WHEN vm_V1_c => 
            IF (Done = '0') THEN 
               next_state <= vm_V1_e;
               csm_to_vm_V1_e <= '1';
            ELSE
               next_state <= vm_V1_c;
            END IF;
         WHEN vm_V1_e => 
            IF (Done = '1') THEN 
               next_state <= vm_V1_f;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSIF (Err = '1') THEN 
               next_state <= vm_V1_d;
            ELSE
               next_state <= vm_V1_e;
            END IF;
         WHEN vm_V1_d => 
            next_state <= vm_V1_g;
         WHEN vm_V1_f => 
            next_state <= vm_V1_g;
         WHEN vm_V1_g => 
            next_state <= vm_V1_h;
         WHEN vm_I2_a => 
            IF (Done = '0'
                  AND
                Err = '0') THEN 
               next_state <= vm_I2_b;
               csm_to_vm_I2_b <= '1';
            ELSE
               next_state <= vm_I2_a;
            END IF;
         WHEN vm_V2_a => 
            IF (Done = '0'
                  AND
                Err = '0') THEN 
               next_state <= vm_V2_b;
               csm_to_vm_V2_b <= '1';
            ELSE
               next_state <= vm_V2_a;
            END IF;
         WHEN vm_I2_b => 
            IF (Done = '1') THEN 
               next_state <= vm_I2_c;
            ELSIF (Err = '1') THEN 
               next_state <= vm_I2_d;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSE
               next_state <= vm_I2_b;
            END IF;
         WHEN vm_V2_b => 
            IF (Done = '1') THEN 
               next_state <= vm_V1_c1;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSIF (Err = '1') THEN 
               next_state <= vm_V2_d;
            ELSE
               next_state <= vm_V2_b;
            END IF;
         WHEN vm_I2_c => 
            IF (Done = '0') THEN 
               next_state <= vm_I2_e;
               csm_to_vm_I2_e <= '1';
            ELSE
               next_state <= vm_I2_c;
            END IF;
         WHEN vm_V1_c1 => 
            IF (Done = '0') THEN 
               next_state <= vm_V2_e;
               csm_to_vm_V2_e <= '1';
            ELSE
               next_state <= vm_V1_c1;
            END IF;
         WHEN vm_I2_e => 
            IF (Done = '1') THEN 
               next_state <= vm_I2_f;
            ELSIF (Err = '1') THEN 
               next_state <= vm_I2_d;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSE
               next_state <= vm_I2_e;
            END IF;
         WHEN vm_I2_d => 
            next_state <= vm_I2_g;
         WHEN vm_V2_e => 
            IF (Done = '1') THEN 
               next_state <= vm_V2_f;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= vm_to;
            ELSIF (Err = '1') THEN 
               next_state <= vm_V2_d;
            ELSE
               next_state <= vm_V2_e;
            END IF;
         WHEN vm_V2_d => 
            next_state <= vm_V2_g;
         WHEN vm_I2_f => 
            next_state <= vm_I2_g;
         WHEN vm_V2_f => 
            next_state <= vm_V2_g;
         WHEN vm_I2_g => 
            next_state <= vm_I2_h;
         WHEN vm_V2_g => 
            next_state <= vm_V2_h;
         WHEN vm_I1_h => 
            next_state <= vm_V1_a;
         WHEN vm_V1_h => 
            next_state <= vm_I2_a;
         WHEN vm_I2_h => 
            next_state <= vm_V2_a;
         WHEN vm_V2_h => 
            next_state <= vm_I1_a;
         WHEN OTHERS =>
            next_state <= vm_reset;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_vm_I1_b,
      csm_to_vm_I1_e,
      csm_to_vm_V1_b,
      csm_to_vm_V1_e,
      csm_to_vm_I2_b,
      csm_to_vm_V2_b,
      csm_to_vm_I2_e,
      csm_to_vm_V2_e
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_vm_I1_b = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_I1_e = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_V1_b = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_V1_e = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_I2_b = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_V2_b = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_I2_e = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
      ELSIF (csm_to_vm_V2_e = '1') THEN
         csm_next_timer <= "10011100001111111"; -- no cycles(80000)-1=79999
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
