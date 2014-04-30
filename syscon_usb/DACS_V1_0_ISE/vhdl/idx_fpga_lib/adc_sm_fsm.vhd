-- VHDL Entity idx_fpga_lib.adc_sm.symbol
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 12:51:19 04/07/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY adc_sm IS
   PORT( 
      ACK        : IN     std_logic;
      CLK        : IN     std_ulogic;
      MISO       : IN     std_logic;
      rst        : IN     std_logic;
      CS_B       : OUT    std_logic;
      DATA_READY : OUT    std_logic;
      INTENSITY  : OUT    std_logic_vector (31 DOWNTO 0);
      SCLK       : OUT    std_logic
   );

-- Declarations

END adc_sm ;

--
-- VHDL Architecture idx_fpga_lib.adc_sm.fsm
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 12:51:19 04/07/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
 
ARCHITECTURE fsm OF adc_sm IS

   -- Architecture Declarations
   SIGNAL ACC : std_logic_vector(31 DOWNTO 0);  
   SIGNAL COUNT : std_logic_vector(4 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      init,
      s0,
      s1,
      s2,
      s3,
      s4
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(2 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(2 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_s1 : std_logic;
   SIGNAL csm_to_s2 : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL CS_B_cld : std_logic ;
   SIGNAL DATA_READY_cld : std_logic ;
   SIGNAL INTENSITY_cld : std_logic_vector (31 DOWNTO 0);
   SIGNAL SCLK_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      CLK
   )
   -----------------------------------------------------------------
   BEGIN
      IF (CLK'EVENT AND CLK = '1') THEN
         IF (rst = '1') THEN
            current_state <= init;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            CS_B_cld <= '1';
            DATA_READY_cld <= '0';
            INTENSITY_cld <= (others => '0');
            SCLK_cld <= '0';
            ACC <= (others => '0');
            COUNT <= (others => '0');
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;

            -- Combined Actions
            CASE current_state IS
               WHEN s0 => 
                  CS_B_cld <= '0';
                  COUNT <= (others => '0');
               WHEN s1 => 
                  IF (csm_timeout = '1') THEN 
                     SCLK_cld <=  '1';
                     ACC <= ACC(30 downto 0) & MISO;
                     COUNT <= COUNT + 1;
                  END IF;
               WHEN s2 => 
                  IF (csm_timeout = '1' AND (COUNT /= 0)) THEN 
                     SCLK_cld <= '0';
                  END IF;
               WHEN s3 => 
                  DATA_READY_cld <= '1' ;
                  SCLK_cld <= '0';
                  INTENSITY_cld <= ACC;
               WHEN s4 => 
                  DATA_READY_cld <= '0';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      ACK,
      COUNT,
      MISO,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_s1 <= '0';
      csm_to_s2 <= '0';
      CASE current_state IS
         WHEN init => 
            next_state <= s0;
         WHEN s0 => 
            IF (MISO = '0') THEN 
               next_state <= s1;
               csm_to_s1 <= '1';
            ELSE
               next_state <= s0;
            END IF;
         WHEN s1 => 
            IF (csm_timeout = '1') THEN 
               next_state <= s2;
               csm_to_s2 <= '1';
            ELSE
               next_state <= s1;
            END IF;
         WHEN s2 => 
            IF (csm_timeout = '1' AND (COUNT /= 0)) THEN 
               next_state <= s1;
               csm_to_s1 <= '1';
            ELSIF (csm_timeout = '1' AND (COUNT = 0)) THEN 
               next_state <= s3;
            ELSE
               next_state <= s2;
            END IF;
         WHEN s3 => 
            IF (ACK = '1') THEN 
               next_state <= s4;
            ELSE
               next_state <= s3;
            END IF;
         WHEN s4 => 
            IF (ACK = '0') THEN 
               next_state <= s0;
            ELSE
               next_state <= s4;
            END IF;
         WHEN OTHERS =>
            next_state <= init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_s1,
      csm_to_s2
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_s1 = '1') THEN
         csm_next_timer <= "011"; -- no cycles(4)-1=3
      ELSIF (csm_to_s2 = '1') THEN
         csm_next_timer <= "011"; -- no cycles(4)-1=3
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
   CS_B <= CS_B_cld;
   DATA_READY <= DATA_READY_cld;
   INTENSITY <= INTENSITY_cld;
   SCLK <= SCLK_cld;
END fsm;
