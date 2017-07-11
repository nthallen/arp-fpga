-- VHDL Entity idx_fpga_lib.Intr.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 16:14:14 07/10/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY Intr IS
  PORT( 
    F8M     : IN     std_ulogic;
    INTA    : IN     std_ulogic;
    Running : IN     std_ulogic;
    rst     : IN     std_logic;
    Ireq    : OUT    std_ulogic
  );

-- Declarations

END ENTITY Intr ;

--
-- VHDL Architecture idx_fpga_lib.Intr.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:47:26 07/27/2016
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
--  Machine             :  "csm", synchronous
--  Encoding            :  none
--  Style               :  case, 3 processes
--  Clock               :  "F8M", rising 
--  Synchronous Reset   :  "rst", synchronous, active high
--  State variable type :  [auto]
--  Default state assignment disabled
--  State actions registered on current state
--  
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
 
ARCHITECTURE fsm OF Intr IS

  TYPE STATE_TYPE IS (
    IR0,
    IR1,
    IR2,
    IR3,
    IR4
  );
 
  -- Declare current and next state signals
  SIGNAL current_state : STATE_TYPE;
  SIGNAL next_state : STATE_TYPE;

  -- Declare any pre-registered internal signals
  SIGNAL Ireq_cld : std_ulogic ;

BEGIN

  -----------------------------------------------------------------
  clocked_proc : PROCESS ( 
    F8M
  )
  -----------------------------------------------------------------
  BEGIN
    IF (F8M'EVENT AND F8M = '1') THEN
      IF (rst = '1') THEN
        current_state <= IR0;
        -- Default Reset Values
        Ireq_cld <= '0';
      ELSE
        current_state <= next_state;

        -- Combined Actions
        CASE current_state IS
          WHEN IR0 => 
            Ireq_cld <= '0';
          WHEN IR1 => 
            Ireq_cld <= '0';
          WHEN IR2 => 
            Ireq_cld <= '0';
          WHEN IR3 => 
            Ireq_cld <= '1';
          WHEN IR4 => 
            Ireq_cld <= '1';
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS clocked_proc;
 
  -----------------------------------------------------------------
  nextstate_proc : PROCESS ( 
    INTA,
    Running,
    current_state
  )
  -----------------------------------------------------------------
  BEGIN
    CASE current_state IS
      WHEN IR0 => 
        IF (Running = '0') THEN 
          next_state <= IR0;
        ELSIF (Running /= '0' and
               INTA = '0') THEN 
          next_state <= IR1;
        ELSE
          next_state <= IR2;
        END IF;
      WHEN IR1 => 
        IF (INTA /= '0') THEN 
          next_state <= IR2;
        ELSIF (INTA = '0' and
               Running = '0') THEN 
          next_state <= IR3;
        ELSE
          next_state <= IR1;
        END IF;
      WHEN IR2 => 
        IF (INTA = '0' and
            Running /= '0') THEN 
          next_state <= IR1;
        ELSIF (INTA = '0' and
               Running = '0') THEN 
          next_state <= IR3;
        ELSE
          next_state <= IR2;
        END IF;
      WHEN IR3 => 
        IF (INTA = '0' and
            Running /= '0') THEN 
          next_state <= IR2;
        ELSIF (INTA /= '0') THEN 
          next_state <= IR4;
        ELSE
          next_state <= IR3;
        END IF;
      WHEN IR4 => 
        IF (INTA = '0' and
            Running = '0') THEN 
          next_state <= IR0;
        ELSIF (INTA = '0' and
               Running /= '0') THEN 
          next_state <= IR1;
        ELSE
          next_state <= IR4;
        END IF;
      WHEN OTHERS =>
        next_state <= IR0;
    END CASE;
  END PROCESS nextstate_proc;
 
  -- Concurrent Statements
  -- Clocked output assignments
  Ireq <= Ireq_cld;
END ARCHITECTURE fsm;
