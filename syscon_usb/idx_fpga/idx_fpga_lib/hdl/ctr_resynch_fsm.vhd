-- VHDL Entity idx_fpga_lib.ctr_resynch.symbol
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:17 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ctr_resynch IS
   PORT( 
      CtrsEn    : IN     std_ulogic;
      LatchEdge : IN     std_ulogic;
      RdEdge    : IN     std_ulogic;
      StatEn    : IN     std_ulogic;
      clk       : IN     std_logic;
      rst       : IN     std_logic;
      L2        : OUT    std_ulogic;
      RS        : OUT    std_ulogic
   );

-- Declarations

END ctr_resynch ;

--
-- VHDL Architecture idx_fpga_lib.ctr_resynch.fsm
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:17 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF ctr_resynch IS

   TYPE STATE_TYPE IS (
      crs0,
      crs1,
      crs2,
      crs3,
      crs4
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL L2_cld : std_ulogic ;
   SIGNAL RS_cld : std_ulogic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk,
      rst
   )
   -----------------------------------------------------------------
   BEGIN
      IF (rst = '1') THEN
         current_state <= crs0;
         -- Default Reset Values
         L2_cld <= '0';
         RS_cld <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         current_state <= next_state;

         -- Combined Actions
         CASE current_state IS
            WHEN crs1 => 
               IF (LatchEdge = '1') THEN 
                  RS_cld <= '0' ;
                  L2_cld <= '0' ;
               ELSE
                  RS_cld <= '0' ;
                  L2_cld <= '0' ;
               END IF;
            WHEN crs2 => 
               IF (RdEdge = '1' AND StatEn = '1') THEN 
                  L2_cld <= '1' ;
                  RS_cld <= '1' ;
               END IF;
            WHEN crs3 => 
               IF (RdEdge = '1' AND StatEn = '1') THEN 
                  RS_cld <= '1';
               END IF;
            WHEN crs4 => 
               IF (LatchEdge /= '1') THEN 
                  RS_cld <= '0' ;
               ELSE
                  RS_cld <= '0' ;
               END IF;
            WHEN OTHERS =>
               NULL;
         END CASE;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      CtrsEn,
      LatchEdge,
      RdEdge,
      StatEn,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN crs0 => 
            IF ((RdEdge = '1' AND CtrsEn = '1'  )
                OR LatchEdge = '1') THEN 
               next_state <= crs2;
            ELSIF (RdEdge = '1' AND StatEn = '1') THEN 
               next_state <= crs3;
            ELSE
               next_state <= crs0;
            END IF;
         WHEN crs1 => 
            IF (LatchEdge = '1') THEN 
               next_state <= crs0;
            ELSE
               next_state <= crs3;
            END IF;
         WHEN crs2 => 
            IF (RdEdge = '1' AND StatEn = '1') THEN 
               next_state <= crs1;
            ELSE
               next_state <= crs2;
            END IF;
         WHEN crs3 => 
            IF (RdEdge = '1' AND StatEn = '1') THEN 
               next_state <= crs4;
            ELSIF (LatchEdge = '1') THEN 
               next_state <= crs0;
            ELSE
               next_state <= crs3;
            END IF;
         WHEN crs4 => 
            IF (LatchEdge /= '1') THEN 
               next_state <= crs3;
            ELSE
               next_state <= crs0;
            END IF;
         WHEN OTHERS =>
            next_state <= crs0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   L2 <= L2_cld;
   RS <= RS_cld;
END fsm;
