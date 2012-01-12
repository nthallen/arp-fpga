-- VHDL Entity idx_fpga_lib.qclic_rbuf.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:13:20 01/ 6/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_rbuf IS
   PORT( 
      F8M          : IN     std_logic;
      FIFO_rdata   : IN     std_logic_vector (15 DOWNTO 0);
      RdEn         : IN     std_ulogic;
      RdFAck       : IN     std_logic;
      cmd          : IN     std_logic_vector (2 DOWNTO 0);
      ctrlr_status : IN     std_logic_vector (15 DOWNTO 0);
      qcli_status  : IN     std_logic_vector (15 DOWNTO 0);
      rst          : IN     std_logic;
      RData        : OUT    std_logic_vector (15 DOWNTO 0);
      RdFIFO       : OUT    std_logic;
      TOset        : OUT    std_logic
   );

-- Declarations

END qclic_rbuf ;

--
-- VHDL Architecture idx_fpga_lib.qclic_rbuf.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:13:20 01/ 6/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF qclic_rbuf IS

   -- Architecture Declarations
   SIGNAL TOq : std_logic;  

   TYPE STATE_TYPE IS (
      qrb_idle,
      qrb_ctrl,
      qrb_qs1,
      qrb_qs2,
      qrb_to2,
      qrb_rf1,
      qrb_rf2,
      qrb_rf3,
      qrb_to1
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL RData_cld : std_logic_vector (15 DOWNTO 0);
   SIGNAL RdFIFO_cld : std_logic ;
   SIGNAL TOset_cld : std_logic ;

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= qrb_idle;
            -- Default Reset Values
            RData_cld <= (others => '0');
            RdFIFO_cld <= '0';
            TOset_cld <= '0';
            TOq <= '0';
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN qrb_idle => 
                  IF (RdEn = '1' AND
                      cmd = "000") THEN 
                     RData_cld <= ctrlr_status;
                  ELSIF (RdEn = '1' AND
                         cmd = "001") THEN 
                     RData_cld <= qcli_status;
                  ELSIF (RdEn = '1' AND
                         cmd = "010") THEN 
                     RData_cld <= FIFO_rdata;
                     RdFIFO_cld <= '1';
                  END IF;
               WHEN qrb_qs2 => 
                  TOq <= '1';
               WHEN qrb_to2 => 
                  TOset_cld <= '0';
               WHEN qrb_rf2 => 
                  IF (RdFAck = '1') THEN 
                     RdFIFO_cld <= '0';
                  END IF;
               WHEN qrb_rf3 => 
                  RdFIFO_cld <= '0';
               WHEN qrb_to1 => 
                  TOset_cld <= '1';
                  TOq <= '0';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      RdEn,
      RdFAck,
      TOq,
      cmd,
      ctrlr_status,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN qrb_idle => 
            IF (RdEn = '1' AND
                cmd = "000") THEN 
               next_state <= qrb_ctrl;
            ELSIF (RdEn = '1' AND
                   cmd = "001") THEN 
               next_state <= qrb_qs1;
            ELSIF (RdEn = '1' AND
                   cmd = "010") THEN 
               next_state <= qrb_rf1;
            ELSIF (TOq = '1' AND
                     ctrlr_status(14) = '0') THEN 
               next_state <= qrb_to1;
            ELSE
               next_state <= qrb_idle;
            END IF;
         WHEN qrb_ctrl => 
            IF (RdEn = '0') THEN 
               next_state <= qrb_idle;
            ELSE
               next_state <= qrb_ctrl;
            END IF;
         WHEN qrb_qs1 => 
            IF (RdEn = '0') THEN 
               next_state <= qrb_qs2;
            ELSE
               next_state <= qrb_qs1;
            END IF;
         WHEN qrb_qs2 => 
            next_state <= qrb_idle;
         WHEN qrb_to2 => 
            next_state <= qrb_idle;
         WHEN qrb_rf1 => 
            IF (RdFAck = '1') THEN 
               next_state <= qrb_rf3;
            ELSIF (RdEn = '0') THEN 
               next_state <= qrb_rf2;
            ELSE
               next_state <= qrb_rf1;
            END IF;
         WHEN qrb_rf2 => 
            IF (RdFAck = '1') THEN 
               next_state <= qrb_idle;
            ELSE
               next_state <= qrb_rf2;
            END IF;
         WHEN qrb_rf3 => 
            IF (RdEn = '0') THEN 
               next_state <= qrb_idle;
            ELSE
               next_state <= qrb_rf3;
            END IF;
         WHEN qrb_to1 => 
            next_state <= qrb_to2;
         WHEN OTHERS =>
            next_state <= qrb_idle;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   RData <= RData_cld;
   RdFIFO <= RdFIFO_cld;
   TOset <= TOset_cld;
END fsm;