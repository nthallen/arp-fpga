-- VHDL Entity idx_fpga_lib.qclic_timer.symbol
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:18 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_timer IS
   PORT( 
      F8M     : IN     std_logic;
      TOrst   : IN     std_logic;
      TOset   : IN     std_logic;
      rst     : IN     std_logic;
      timeout : OUT    std_logic
   );

-- Declarations

END qclic_timer ;

--
-- VHDL Architecture idx_fpga_lib.qclic_timer.fsm
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:18 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF qclic_timer IS

   TYPE STATE_TYPE IS (
      qt_wait,
      qt_timeout,
      qt_init
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(17 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(17 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_qt_wait : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL timeout_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= qt_init;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            timeout_cld <= '0';
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;

            -- Combined Actions
            CASE current_state IS
               WHEN qt_wait => 
                  timeout_cld <= '0';
               WHEN qt_timeout => 
                  timeout_cld <= '1';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      TOrst,
      TOset,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_qt_wait <= '0';
      CASE current_state IS
         WHEN qt_wait => 
            IF (TOrst = '1') THEN 
               next_state <= qt_wait;
               csm_to_qt_wait <= '1';
            ELSIF (TOset = '1') THEN 
               next_state <= qt_timeout;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= qt_timeout;
            ELSE
               next_state <= qt_wait;
            END IF;
         WHEN qt_timeout => 
            IF (TOrst = '1') THEN 
               next_state <= qt_wait;
               csm_to_qt_wait <= '1';
            ELSE
               next_state <= qt_timeout;
            END IF;
         WHEN qt_init => 
            next_state <= qt_wait;
            csm_to_qt_wait <= '1';
         WHEN OTHERS =>
            next_state <= qt_init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_qt_wait
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_qt_wait = '1') THEN
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
   timeout <= timeout_cld;
END fsm;
