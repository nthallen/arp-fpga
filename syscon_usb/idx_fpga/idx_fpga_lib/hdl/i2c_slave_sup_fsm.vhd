-- VHDL Entity idx_fpga_lib.i2c_slave_sup.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:47:27 07/27/2016
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY i2c_slave_sup IS
  PORT( 
    clk    : IN     std_ulogic;
    rst    : IN     std_ulogic;
    scl_in : IN     std_logic;
    sda_in : IN     std_logic;
    err    : OUT    std_ulogic;
    start  : OUT    std_ulogic;
    stop   : OUT    std_ulogic
  );

-- Declarations

END ENTITY i2c_slave_sup ;

--
-- VHDL Architecture idx_fpga_lib.i2c_slave_sup.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:47:27 07/27/2016
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
--  Machine             :  "csm", synchronous
--  Encoding            :  none
--  Style               :  case, 3 processes
--  Clock               :  "clk", rising 
--  Synchronous Reset   :  "rst", synchronous, active high
--  State variable type :  [auto]
--  Default state assignment disabled
--  State actions registered on current state
--  
--   SIGNAL    MODE    DEFAULT         RESET  SCHEME 
--   scl       LOCAL   To_X01(scl_in)         COMB   
--   sda       LOCAL   To_X01(sda_in)         COMB   
--   start     OUT                     '0'    CLKD   
--   stop      OUT                     '0'    CLKD   
--   prestart  LOCAL                   '0'    CLKD   
--   err       OUT                     '0'    CLKD   
--   
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF i2c_slave_sup IS

  -- Architecture Declarations
  SIGNAL prestart : std_ulogic;  
  SIGNAL scl : std_logic;  
  SIGNAL sda : std_logic;  

  TYPE STATE_TYPE IS (
    i2cs11,
    i2c210,
    i2cserr,
    i2cs01,
    i2cs00
  );
 
  -- Declare current and next state signals
  SIGNAL current_state : STATE_TYPE;
  SIGNAL next_state : STATE_TYPE;

  -- Declare any pre-registered internal signals
  SIGNAL err_cld : std_ulogic ;
  SIGNAL start_cld : std_ulogic ;
  SIGNAL stop_cld : std_ulogic ;

BEGIN

  -----------------------------------------------------------------
  clocked_proc : PROCESS ( 
    clk
  )
  -----------------------------------------------------------------
  BEGIN
    IF (clk'EVENT AND clk = '1') THEN
      IF (rst = '1') THEN
        current_state <= i2cs11;
        -- Default Reset Values
        err_cld <= '0';
        start_cld <= '0';
        stop_cld <= '0';
        prestart <= '0';
      ELSE
        current_state <= next_state;

        -- Combined Actions
        CASE current_state IS
          WHEN i2cs11 => 
            IF (scl='1' AND sda='0') THEN 
              stop_cld <= '0';
              prestart <= '1';
            ELSIF (scl='0' AND sda='1') THEN 
              stop_cld <= '0';
            END IF;
          WHEN i2c210 => 
            IF (scl='1' AND sda='1') THEN 
              prestart <= '0';
              stop_cld <= '1';
              err_cld <= '0';
            ELSIF (scl='0' AND sda='0') THEN 
              start_cld <= prestart;
              prestart <= '0';
            END IF;
          WHEN i2cserr => 
            start_cld <= '0';
            stop_cld <= '0';
            err_cld <= '0';
            prestart <= '0';
          WHEN i2cs00 => 
            IF (scl='0' AND sda='1') THEN 
              start_cld <= '0';
            ELSIF (scl='1' AND sda='0') THEN 
              start_cld <= '0';
            END IF;
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS clocked_proc;
 
  -----------------------------------------------------------------
  nextstate_proc : PROCESS ( 
    current_state,
    scl,
    sda
  )
  -----------------------------------------------------------------
  BEGIN
    CASE current_state IS
      WHEN i2cs11 => 
        IF (scl='1' AND sda='0') THEN 
          next_state <= i2c210;
        ELSIF (scl='0' AND sda='1') THEN 
          next_state <= i2cs01;
        ELSIF (scl='0' AND sda='0') THEN 
          next_state <= i2cserr;
        ELSE
          next_state <= i2cs11;
        END IF;
      WHEN i2c210 => 
        IF (scl='1' AND sda='1') THEN 
          next_state <= i2cs11;
        ELSIF (scl='0' AND sda='0') THEN 
          next_state <= i2cs00;
        ELSIF (scl='0' AND sda='1') THEN 
          next_state <= i2cserr;
        ELSE
          next_state <= i2c210;
        END IF;
      WHEN i2cserr => 
        IF (scl='1' AND sda='1') THEN 
          next_state <= i2cs11;
        ELSIF (scl='0' AND sda='1') THEN 
          next_state <= i2cs01;
        ELSIF (scl='1' AND sda='0') THEN 
          next_state <= i2c210;
        ELSIF (scl='0' AND sda='0') THEN 
          next_state <= i2cs00;
        ELSE
          next_state <= i2cserr;
        END IF;
      WHEN i2cs01 => 
        IF (scl='0' AND sda='0') THEN 
          next_state <= i2cs00;
        ELSIF (scl='1' AND sda='1') THEN 
          next_state <= i2cs11;
        ELSIF (scl='1' AND sda='0') THEN 
          next_state <= i2cserr;
        ELSE
          next_state <= i2cs01;
        END IF;
      WHEN i2cs00 => 
        IF (scl='0' AND sda='1') THEN 
          next_state <= i2cs01;
        ELSIF (scl='1' AND sda='0') THEN 
          next_state <= i2c210;
        ELSIF (scl='1' AND sda='1') THEN 
          next_state <= i2cserr;
        ELSE
          next_state <= i2cs00;
        END IF;
      WHEN OTHERS =>
        next_state <= i2cs11;
    END CASE;
  END PROCESS nextstate_proc;
 
  -----------------------------------------------------------------
  -- Default Assignment To Internals
  scl <= To_X01(scl_in);
  sda <= To_X01(sda_in);
 
  -- Concurrent Statements
  -- Clocked output assignments
  err <= err_cld;
  start <= start_cld;
  stop <= stop_cld;
END ARCHITECTURE fsm;
