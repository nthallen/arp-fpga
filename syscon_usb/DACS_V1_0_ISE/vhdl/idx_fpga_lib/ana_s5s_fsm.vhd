-- VHDL Entity idx_fpga_lib.ana_s5s.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:00:42 10/29/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_s5s IS
   PORT( 
      DI    : IN     std_logic_vector (4 DOWNTO 0);
      Start : IN     std_ulogic;
      clk   : IN     std_ulogic;
      rst   : IN     std_ulogic;
      DO    : OUT    std_logic_vector (4 DOWNTO 0);
      RDY   : OUT    std_ulogic;
      SCK   : OUT    std_ulogic;
      SDO   : OUT    std_ulogic
   );

-- Declarations

END ana_s5s ;

--
-- VHDL Architecture idx_fpga_lib.ana_s5s.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:00:42 10/29/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF ana_s5s IS

   -- Architecture Declarations
   SIGNAL N_Bits : unsigned(2 DOWNTO 0);  
   SIGNAL RDI : std_logic_vector(4 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      s5_init,
      s5_idle,
      s5_clk0,
      s5_clk1,
      s5_clk2,
      s5_clk3,
      s5_clk4,
      s5_clk5
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL DO_cld : std_logic_vector (4 DOWNTO 0);
   SIGNAL RDY_cld : std_ulogic ;
   SIGNAL SCK_cld : std_ulogic ;
   SIGNAL SDO_cld : std_ulogic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk
   )
   -----------------------------------------------------------------
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (rst = '1') THEN
            current_state <= s5_init;
            -- Default Reset Values
            DO_cld <= (others => '0');
            RDY_cld <= '0';
            SCK_cld <= '1';
            SDO_cld <= '0';
            N_Bits <= (others => '0');
            RDI <= (others => '0');
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN s5_init => 
                  RDY_cld <= '1';
               WHEN s5_idle => 
                  IF (Start = '1') THEN 
                     N_Bits <= conv_unsigned(5,3);
                     RDY_cld <= '0';
                     RDI <= DI;
                     DO_cld <= DI;
                  END IF;
               WHEN s5_clk0 => 
                  SCK_cld <= '0';
                  SDO_cld <= RDI(4);
                  RDI(4 DOWNTO 1) <= RDI(3 DOWNTO 0);
                  RDI(0) <= '0';
               WHEN s5_clk3 => 
                  SCK_cld <= '1';
                  N_Bits <= N_Bits - 1;
               WHEN s5_clk5 => 
                  IF (N_Bits /= 0) THEN 
                  ELSIF (N_Bits = 0) THEN 
                     RDY_cld <= '1';
                  END IF;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      N_Bits,
      Start,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN s5_init => 
            next_state <= s5_idle;
         WHEN s5_idle => 
            IF (Start = '1') THEN 
               next_state <= s5_clk0;
            ELSE
               next_state <= s5_idle;
            END IF;
         WHEN s5_clk0 => 
            next_state <= s5_clk1;
         WHEN s5_clk1 => 
            next_state <= s5_clk2;
         WHEN s5_clk2 => 
            next_state <= s5_clk3;
         WHEN s5_clk3 => 
            next_state <= s5_clk4;
         WHEN s5_clk4 => 
            next_state <= s5_clk5;
         WHEN s5_clk5 => 
            IF (N_Bits /= 0) THEN 
               next_state <= s5_clk0;
            ELSIF (N_Bits = 0) THEN 
               next_state <= s5_idle;
            END IF;
         WHEN OTHERS =>
            next_state <= s5_init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   DO <= DO_cld;
   RDY <= RDY_cld;
   SCK <= SCK_cld;
   SDO <= SDO_cld;
END fsm;