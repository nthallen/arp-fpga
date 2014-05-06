-- VHDL Entity idx_fpga_lib.adc_glue.interface
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:09:16 04/08/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY adc_glue IS
   PORT( 
      DATA_READY : IN     std_logic;
      F8M        : IN     std_ulogic;
      HighWord   : IN     std_logic;
      INTENSITY  : IN     std_logic_vector (31 DOWNTO 0);
      RdEn       : IN     std_ulogic;
      WrEn       : IN     std_ulogic;
      rst        : IN     std_logic;
      Ack        : OUT    std_logic;
      RData      : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END adc_glue ;

--
-- VHDL Architecture idx_fpga_lib.adc_glue.fsm
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 11:09:15 04/08/14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF adc_glue IS

   TYPE STATE_TYPE IS (
      s0,
      s1,
      s2,
      s3,
      s4,
      s5,
      s6
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL Ack_cld : std_logic ;
   SIGNAL RData_cld : std_logic_vector (15 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= s0;
            -- Default Reset Values
            Ack_cld <= '0';
            RData_cld <= (others => '1');
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN s0 => 
                  RData_cld <=
                    (others => '1') ;
               WHEN s2 => 
                  RData_cld <=
                   INTENSITY (15 downto 0);
               WHEN s4 => 
                  RData_cld <=
                   INTENSITY (31 downto 16);
               WHEN s5 => 
                  Ack_cld <= '1' ;
               WHEN s6 => 
                  Ack_cld <= '0' ;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      DATA_READY,
      HighWord,
      RdEn,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN s0 => 
            IF (RdEn = '1' AND
                DATA_READY = '1' AND
                HighWord = '0') THEN 
               next_state <= s2;
            ELSIF (RdEn = '1' AND
                   ( DATA_READY = '0' OR
                   HighWord = '1')) THEN 
               next_state <= s1;
            ELSE
               next_state <= s0;
            END IF;
         WHEN s1 => 
            IF (RdEn = '0') THEN 
               next_state <= s0;
            ELSE
               next_state <= s1;
            END IF;
         WHEN s2 => 
            IF (RdEn = '0') THEN 
               next_state <= s3;
            ELSE
               next_state <= s2;
            END IF;
         WHEN s3 => 
            IF (RdEn = '1' AND
                DATA_READY = '1'
                AND HighWord = '1') THEN 
               next_state <= s4;
            ELSIF (DATA_READY = '0') THEN 
               next_state <= s0;
            ELSE
               next_state <= s3;
            END IF;
         WHEN s4 => 
            IF (RdEn = '0') THEN 
               next_state <= s5;
            ELSE
               next_state <= s4;
            END IF;
         WHEN s5 => 
            IF (DATA_READY = '0') THEN 
               next_state <= s6;
            ELSE
               next_state <= s5;
            END IF;
         WHEN s6 => 
            next_state <= s0;
         WHEN OTHERS =>
            next_state <= s0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   Ack <= Ack_cld;
   RData <= RData_cld;
END fsm;