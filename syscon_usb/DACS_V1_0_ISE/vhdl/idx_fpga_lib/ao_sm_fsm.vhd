-- VHDL Entity idx_fpga_lib.ao_sm.symbol
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

ENTITY ao_sm IS
  GENERIC( 
    N_AO_CHIPS : natural range 15 downto 1 := 2
  );
  PORT( 
    Addr      : IN     std_logic_vector (15 DOWNTO 0);
    F8M       : IN     std_logic;
    WData     : IN     std_logic_vector (15 DOWNTO 0);
    WrEn      : IN     std_ulogic;
    rst       : IN     std_ulogic;
    AO_Idle   : OUT    std_logic;
    DA_CLR_B  : OUT    std_logic;
    DA_CS_B   : OUT    std_logic_vector (N_AO_CHIPS-1 DOWNTO 0);
    DA_LDAC_B : OUT    std_logic;
    DA_SCK    : OUT    std_logic;
    DA_SDI    : OUT    std_logic
  );

-- Declarations

END ENTITY ao_sm ;

--
-- VHDL Architecture idx_fpga_lib.ao_sm.fsm
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
 
ARCHITECTURE fsm OF ao_sm IS

  -- Architecture Declarations
  SIGNAL BN : unsigned(4 DOWNTO 0);  
  SIGNAL SR : std_logic_vector(23 DOWNTO 0);  

  TYPE STATE_TYPE IS (
    ao_0,
    ao_1,
    ao_2,
    ao_3,
    ao_5,
    ao_4,
    ao_1a
  );
 
  -- Declare current and next state signals
  SIGNAL current_state : STATE_TYPE;
  SIGNAL next_state : STATE_TYPE;

  -- Declare any pre-registered internal signals
  SIGNAL AO_Idle_cld : std_logic ;
  SIGNAL DA_CLR_B_cld : std_logic ;
  SIGNAL DA_CS_B_cld : std_logic_vector (N_AO_CHIPS-1 DOWNTO 0);
  SIGNAL DA_LDAC_B_cld : std_logic ;
  SIGNAL DA_SCK_cld : std_logic ;
  SIGNAL DA_SDI_cld : std_logic ;

BEGIN

  -----------------------------------------------------------------
  clocked_proc : PROCESS ( 
    F8M
  )
  -----------------------------------------------------------------
  BEGIN
    IF (F8M'EVENT AND F8M = '1') THEN
      IF (rst = '1') THEN
        current_state <= ao_0;
        -- Default Reset Values
        AO_Idle_cld <= '1';
        DA_CLR_B_cld <= '0';
        DA_CS_B_cld <= (others => '1');
        DA_LDAC_B_cld <= '1';
        DA_SCK_cld <= '0';
        DA_SDI_cld <= '0';
        BN <= "00000";
        SR <= (others => '0');
      ELSE
        current_state <= next_state;

        -- Combined Actions
        CASE current_state IS
          WHEN ao_1 => 
            DA_CLR_B_cld <= '1' ;
            AO_Idle_cld <= '1';
          WHEN ao_2 => 
            DA_SDI_cld <= SR(23);
            DA_SCK_cld <= '0';
            BN <= BN + 1;
          WHEN ao_3 => 
            DA_SCK_cld <= '1';
            SR(23 DOWNTO 1) <=
               SR(22 DOWNTO 0);
          WHEN ao_5 => 
            DA_CS_B_cld <= (others => '1');
          WHEN ao_4 => 
            DA_SCK_cld <= '0';
          WHEN ao_1a => 
            SR <= "00110" &
               Addr(3 DOWNTO 1) &
               WData;
            BN <= "00001";
            DA_SDI_cld <= '0';
            DA_CS_B_cld(conv_integer(Addr(7 DOWNTO 4)))
              <= '0';
            AO_Idle_cld <= '0';
          WHEN OTHERS =>
            NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS clocked_proc;
 
  -----------------------------------------------------------------
  nextstate_proc : PROCESS ( 
    Addr,
    BN,
    WrEn,
    current_state,
    rst
  )
  -----------------------------------------------------------------
  BEGIN
    CASE current_state IS
      WHEN ao_0 => 
        IF (rst = '1') THEN 
          next_state <= ao_0;
        ELSE
          next_state <= ao_1;
        END IF;
      WHEN ao_1 => 
        IF (WrEn = '1' AND
            conv_integer(Addr(7 DOWNTO 4))
              < N_AO_CHIPS) THEN 
          next_state <= ao_1a;
        ELSE
          next_state <= ao_1;
        END IF;
      WHEN ao_2 => 
        next_state <= ao_3;
      WHEN ao_3 => 
        IF (BN = 24) THEN 
          next_state <= ao_4;
        ELSE
          next_state <= ao_2;
        END IF;
      WHEN ao_5 => 
        next_state <= ao_1;
      WHEN ao_4 => 
        next_state <= ao_5;
      WHEN ao_1a => 
        next_state <= ao_3;
      WHEN OTHERS =>
        next_state <= ao_0;
    END CASE;
  END PROCESS nextstate_proc;
 
  -- Concurrent Statements
  -- Clocked output assignments
  AO_Idle <= AO_Idle_cld;
  DA_CLR_B <= DA_CLR_B_cld;
  DA_CS_B <= DA_CS_B_cld;
  DA_LDAC_B <= DA_LDAC_B_cld;
  DA_SCK <= DA_SCK_cld;
  DA_SDI <= DA_SDI_cld;
END ARCHITECTURE fsm;
