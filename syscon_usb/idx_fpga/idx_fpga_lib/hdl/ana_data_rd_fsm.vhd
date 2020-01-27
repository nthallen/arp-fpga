-- VHDL Entity idx_fpga_lib.ana_data_rd.symbol
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

ENTITY ana_data_rd IS
   PORT( 
      DataEn      : IN     std_ulogic;
      RAM_RD_DATA : IN     std_logic_vector (31 DOWNTO 0);
      RDEN        : IN     std_ulogic;
      RD_ADDR     : IN     std_logic_vector (8 DOWNTO 0);
      RD_CLK      : IN     std_ulogic;
      RST         : IN     std_ulogic;
      RAM_RD_EN   : OUT    std_ulogic;
      RD_DATA     : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END ana_data_rd ;

--
-- VHDL Architecture idx_fpga_lib.ana_data_rd.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 12:33:31 07/11/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF ana_data_rd IS

   -- Architecture Declarations
   SIGNAL RAM_ADDR_hold : std_logic_vector(7 DOWNTO 0);  
   SIGNAL RAM_CFG : std_logic_vector(8 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      ana_rd0,
      ana_rd1,
      ana_rd2,
      ana_rd3,
      ana_rd5,
      ana_rd6
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL RAM_RD_EN_cld : std_ulogic ;
   SIGNAL RD_DATA_cld : std_logic_vector (15 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      RD_CLK
   )
   -----------------------------------------------------------------
   BEGIN
      IF (RD_CLK'EVENT AND RD_CLK = '1') THEN
         IF (RST = '1') THEN
            current_state <= ana_rd0;
            -- Default Reset Values
            RAM_RD_EN_cld <= '0';
            RD_DATA_cld <= (others => '0');
            RAM_ADDR_hold <= (others => '0');
            RAM_CFG <= (others => '0');
         ELSE
            current_state <= next_state;
            -- Default Assignment To Internals
            RAM_RD_EN_cld <= '0';

            -- Combined Actions
            CASE current_state IS
               WHEN ana_rd1 => 
                  RAM_RD_EN_cld <= '1' ;
               WHEN ana_rd2 => 
                  RD_DATA_cld <= RAM_RD_DATA ( 15 DOWNTO 0);
                  RAM_CFG <= RAM_RD_DATA(24 DOWNTO 16);
               WHEN ana_rd3 => 
                  RAM_RD_EN_cld <= '0' ;
                  RAM_ADDR_hold <= RD_ADDR (8 DOWNTO 1);
               WHEN ana_rd5 => 
                  RD_DATA_cld(8 DOWNTO 0) <= RAM_CFG;
                  RD_DATA_cld(15 DOWNTO 9) <= (others => '0');
               WHEN ana_rd6 => 
                  RD_DATA_cld <= X"0200";
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      DataEn,
      RAM_ADDR_hold,
      RDEN,
      RD_ADDR,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN ana_rd0 => 
            IF (RDEN = '1' AND
                DataEn = '1' AND
                RD_ADDR ( 0 ) = '0') THEN 
               next_state <= ana_rd1;
            ELSIF (RDEN = '1' AND DataEn = '1' AND
                   RD_ADDR ( 0) = '1' AND
                   RD_ADDR(8 DOWNTO 1) = RAM_ADDR_hold) THEN 
               next_state <= ana_rd5;
            ELSIF (RDEN = '1' AND DataEn = '1' AND
                   RD_ADDR ( 0 ) = '1' AND 
                   RD_ADDR (8 DOWNTO 1) /= RAM_ADDR_hold) THEN 
               next_state <= ana_rd6;
            ELSE
               next_state <= ana_rd0;
            END IF;
         WHEN ana_rd1 => 
            next_state <= ana_rd3;
         WHEN ana_rd2 => 
            IF (RDEN = '0') THEN 
               next_state <= ana_rd0;
            ELSE
               next_state <= ana_rd2;
            END IF;
         WHEN ana_rd3 => 
            next_state <= ana_rd2;
         WHEN ana_rd5 => 
            IF (RDEN = '0') THEN 
               next_state <= ana_rd0;
            ELSE
               next_state <= ana_rd5;
            END IF;
         WHEN ana_rd6 => 
            IF (RDEN = '0') THEN 
               next_state <= ana_rd0;
            ELSE
               next_state <= ana_rd6;
            END IF;
         WHEN OTHERS =>
            next_state <= ana_rd0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   RAM_RD_EN <= RAM_RD_EN_cld;
   RD_DATA <= RD_DATA_cld;
END fsm;
