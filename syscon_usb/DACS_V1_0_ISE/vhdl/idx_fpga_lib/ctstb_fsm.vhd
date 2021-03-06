-- VHDL Entity idx_fpga_lib.CtStB.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:15:23 07/10/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY CtStB IS
   PORT( 
      F8M     : IN     std_ulogic;
      R       : IN     std_ulogic;
      StepClk : IN     std_ulogic;
      WrEn    : IN     std_ulogic;
      rst     : IN     std_logic;
      ClkEn   : OUT    std_ulogic
   );

-- Declarations

END CtStB ;

--
-- VHDL Architecture idx_fpga_lib.CtStB.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:16:40 07/10/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
 
ARCHITECTURE fsm OF CtStB IS

   TYPE STATE_TYPE IS (
      CtB0,
      CtB1,
      CtB2
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL ClkEn_cld : std_ulogic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= CtB0;
            -- Default Reset Values
            ClkEn_cld <= '0';
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN CtB0 => 
                  ClkEn_cld <= '0' ;
                  IF (StepClk = '1' AND R /= '1'  AND
                       WrEn /= '1') THEN 
                     ClkEn_cld <= '1';
                  END IF;
               WHEN CtB1 => 
                  IF (StepClk /= '1') THEN 
                     ClkEn_cld <= '0';
                  ELSIF (StepClk = '1') THEN 
                     ClkEn_cld <= '0';
                  END IF;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      R,
      StepClk,
      WrEn,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN CtB0 => 
            IF (StepClk = '1' AND R /= '1'  AND
                 WrEn /= '1') THEN 
               next_state <= CtB1;
            ELSE
               next_state <= CtB0;
            END IF;
         WHEN CtB1 => 
            IF (StepClk /= '1') THEN 
               next_state <= CtB0;
            ELSIF (StepClk = '1') THEN 
               next_state <= CtB2;
            ELSE
               next_state <= CtB1;
            END IF;
         WHEN CtB2 => 
            IF (StepClk = '1') THEN 
               next_state <= CtB2;
            ELSIF (StepClk /= '1') THEN 
               next_state <= CtB0;
            ELSE
               next_state <= CtB2;
            END IF;
         WHEN OTHERS =>
            next_state <= CtB0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   ClkEn <= ClkEn_cld;
END fsm;
