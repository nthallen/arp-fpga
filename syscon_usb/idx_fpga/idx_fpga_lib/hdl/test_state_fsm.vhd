-- VHDL Entity idx_fpga_lib.test_state.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:15:31 11/16/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY test_state IS
   PORT( 
      clk  : IN     std_logic;
      rst  : IN     std_logic;
      done : OUT    std_logic
   );

-- Declarations

END test_state ;

--
-- VHDL Architecture idx_fpga_lib.test_state.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:15:31 11/16/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.STD_LOGIC_ARITH.all;
USE ieee.STD_LOGIC_UNSIGNED.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.all;
 
ARCHITECTURE fsm OF test_state IS

   TYPE STATE_TYPE IS (
      s0,
      s1,
      s2
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(2 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(2 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_s1 : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL done_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk,
      rst
   )
   -----------------------------------------------------------------
   BEGIN
      IF (rst = '0') THEN
         current_state <= s0;
         csm_timer <= (OTHERS => '0');
         -- Default Reset Values
         done_cld <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         current_state <= next_state;
         csm_timer <= csm_next_timer;

         -- Combined Actions
         CASE current_state IS
            WHEN s2 => 
               done_cld <= '1';
            WHEN OTHERS =>
               NULL;
         END CASE;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_s1 <= '0';
      CASE current_state IS
         WHEN s0 => 
            next_state <= s1;
            csm_to_s1 <= '1';
         WHEN s1 => 
            IF (csm_timeout = '1') THEN 
               next_state <= s2;
            ELSE
               next_state <= s1;
            END IF;
         WHEN s2 => 
            next_state <= s2;
         WHEN OTHERS =>
            next_state <= s0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_s1
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
         csm_next_timer <= "110"; -- no cycles(7)-1=6
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
   done <= done_cld;
END fsm;
