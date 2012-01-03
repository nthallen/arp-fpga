-- VHDL Entity idx_fpga_lib.qclic_engine.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:39:58 01/ 3/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY qclic_engine IS
   PORT( 
      Busy         : IN     std_logic;
      Ctrlr_rst    : IN     std_logic;
      F8M          : IN     std_logic;
      RDataS       : IN     std_logic_vector (15 DOWNTO 0);
      RdAck        : IN     std_logic;
      RdFIFO       : IN     std_logic;
      WDataB       : IN     std_logic_vector (15 DOWNTO 0);
      WrEnB        : IN     std_logic;
      cmdB         : IN     std_logic_vector (2 DOWNTO 0);
      ram_rdata    : IN     std_logic_vector (15 DOWNTO 0);
      rst          : IN     std_logic;
      timeout      : IN     std_logic;
      FIFO_rdata   : OUT    std_logic_vector (15 DOWNTO 0);
      RdFAck       : OUT    std_logic;
      RdSer        : OUT    std_logic;
      TOrst        : OUT    std_logic;
      WDataS       : OUT    std_logic_vector (15 DOWNTO 0);
      WrAck        : OUT    std_logic;
      WrSer        : OUT    std_logic;
      ctrlr_status : OUT    std_logic_vector (15 DOWNTO 0);
      qcli_status  : OUT    std_logic_vector (15 DOWNTO 0);
      rRd          : OUT    std_ulogic;
      rWr          : OUT    std_ulogic;
      raddr        : OUT    std_logic_vector (6 DOWNTO 0);
      ram_wdata    : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END qclic_engine ;

--
-- VHDL Architecture idx_fpga_lib.qclic_engine.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:39:58 01/ 3/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
 
ARCHITECTURE fsm OF qclic_engine IS

   -- Architecture Declarations
   SIGNAL FIFOOvf : std_logic;  
   SIGNAL FIFO_cnt : std_logic_vector(7 DOWNTO 0);  
   SIGNAL FIFOfull : std_logic;  
   SIGNAL FIFOhead : std_logic_vector(6 DOWNTO 0);  
   SIGNAL FIFOnonempty : std_logic;  
   SIGNAL FIFOtail : std_logic_vector(6 DOWNTO 0);  
   SIGNAL QCLIResponding : std_logic;  
   SIGNAL RBComplete : std_logic;  
   SIGNAL RBPending : std_logic;  
   SIGNAL Reading : std_logic;  
   SIGNAL WDataC : std_logic_vector(15 DOWNTO 0);  
   SIGNAL WQPending : std_logic;  
   SIGNAL WriteStop : std_logic;  
   SIGNAL cmdC : std_logic_vector(2 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      qe_idle,
      qe_w0,
      qe_w1,
      qe_rst,
      s1,
      qe_rf0,
      qe_rf1,
      qe_rf2,
      qe_rf3,
      qe_rf4,
      qe_rf5,
      qe_rf6,
      qe_rf7,
      qe_wq0,
      qe_wq1,
      qe_wq2,
      qe_wq5,
      qe_wq3,
      qe_wq4,
      qe_wq6,
      qe_wq7,
      qe_wf0,
      qe_wf1,
      qe_wf2,
      qe_wf3,
      qe_wf4,
      qe_wf5,
      qe_wf6,
      qe_wf7,
      qe_rs0,
      qe_rs1,
      qe_rs2,
      qe_rs3,
      qe_rs4,
      qe_rs5
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL FIFO_rdata_cld : std_logic_vector (15 DOWNTO 0);
   SIGNAL RdFAck_cld : std_logic ;
   SIGNAL RdSer_cld : std_logic ;
   SIGNAL TOrst_cld : std_logic ;
   SIGNAL WDataS_cld : std_logic_vector (15 DOWNTO 0);
   SIGNAL WrAck_cld : std_logic ;
   SIGNAL WrSer_cld : std_logic ;
   SIGNAL qcli_status_cld : std_logic_vector (15 DOWNTO 0);
   SIGNAL rRd_cld : std_ulogic ;
   SIGNAL rWr_cld : std_ulogic ;
   SIGNAL raddr_cld : std_logic_vector (6 DOWNTO 0);
   SIGNAL ram_wdata_cld : std_logic_vector (15 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      F8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (F8M'EVENT AND F8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= qe_rst;
            -- Default Reset Values
            FIFO_rdata_cld <= (others => '0');
            RdFAck_cld <= '0';
            RdSer_cld <= '0';
            TOrst_cld <= '0';
            WDataS_cld <= (others => '0');
            WrAck_cld <= '0';
            WrSer_cld <= '0';
            qcli_status_cld <= (others => '0');
            rRd_cld <= '0';
            rWr_cld <= '0';
            raddr_cld <= (others => '0');
            ram_wdata_cld <= (others => '0');
            FIFOOvf <= '0';
            FIFO_cnt <= (others => '0');
            FIFOfull <= '0';
            FIFOhead <= (others => '0');
            FIFOnonempty <= '0';
            FIFOtail <= (others => '0');
            QCLIResponding <= '0';
            RBComplete <= '0';
            RBPending <= '0';
            Reading <= '0';
            WDataC <= (others => '0');
            WQPending <= '0';
            WriteStop <= '0';
            cmdC <= (others => '0');
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN qe_idle => 
                  WrAck_cld <= '0';
                  RdFAck_cld <= '0';
                  rWr_cld <= '0';
                  rRd_cld <= '0';
                  WrSer_cld <= '0';
                  RdSer_cld <= '0';
                  IF (Ctrlr_rst = '1') THEN 
                  ELSIF (WrEnB = '1' AND
                          cmdB /= "110") THEN 
                  ELSIF (RdFIFO = '1') THEN 
                  ELSIF (Busy = '0' AND
                         FIFOnonempty = '1' AND
                         RBPending = '0') THEN 
                  ELSIF (Busy = '0' AND
                         WQPending = '0' AND
                         timeout = '1') THEN 
                     TOrst_cld <= '1';
                     Reading <= '1';
                  END IF;
               WHEN qe_w0 => 
                  CmdC <= CmdB;
                  WDataC <= WDataB;
                  WrAck_cld <= '1';
               WHEN qe_w1 => 
                  WrAck_cld <= '0';
               WHEN qe_rst => 
                  FIFOhead <= (others => '0');
                  FIFOtail <= (others => '0');
                  FIFOnonempty <= '0';
                  FIFOfull <= '0';
                  FIFO_cnt <= (others => '0');
                  RdFAck_cld <= '1';
                  qcli_status_cld <= (others => '0');
                  RBPending <= '0';
                  RBComplete <= '0';
                  WQPending <= '0';
                  QCLIResponding <= '0';
                  FIFOOvf <= '0';
               WHEN qe_rf0 => 
                  IF (FIFOnonempty = '0' OR
                      RBComplete = '0') THEN 
                     FIFO_rdata_cld <= (others => '0');
                     RdFAck_cld <= '1';
                  END IF;
               WHEN qe_rf2 => 
                  RdFAck_cld <= '0';
               WHEN qe_rf3 => 
                  FIFOhead <= FIFOhead+1;
               WHEN qe_rf4 => 
                  raddr_cld <= FIFOhead;
                  IF (FIFOhead = FIFOtail) THEN 
                     FIFOnonempty <= '0';
                     FIFO_rdata_cld <= (others => '0');
                     RdFAck_cld <= '1';
                     FIFO_cnt <= (others => '0');
                     RBComplete <= '0';
                     RBPending <= '0';
                  END IF;
               WHEN qe_rf6 => 
                  rRd_cld <= '1';
                  rRd_cld <= '0';
                  FIFO_rdata_cld <= ram_rdata;
                  FIFOfull <= '0';
                  RdFAck_cld <= '1';
                  FIFO_cnt <= FIFO_cnt-1;
               WHEN qe_wq0 => 
                  raddr_cld <= FIFOhead;
                  rRd_cld <= '1';
               WHEN qe_wq1 => 
                  FIFOhead <= FIFOhead+1;
                  rRd_cld <= '0';
                  WDataS_cld <= ram_rdata;
                  FIFO_cnt <= FIFO_cnt-1;
                  FIFOfull <= '0';
               WHEN qe_wq2 => 
                  IF (FIFOhead = FIFOtail) THEN 
                     FIFOnonempty <= '0';
                     FIFO_cnt <= (others => '0');
                  ELSE
                     WrSer_cld <= '1';
                  END IF;
               WHEN qe_wq5 => 
                  IF (Busy = '1') THEN 
                     WrSer_cld <= '0';
                  END IF;
               WHEN qe_wq3 => 
                  WrSer_cld <= '1';
               WHEN qe_wq4 => 
                  WQPending <= '0';
                  WriteStop <= '0';
               WHEN qe_wf1 => 
                  FIFOOvf <= '1';
               WHEN qe_wf2 => 
                  raddr_cld <= FIFOtail;
                  ram_wdata_cld <= WDataC;
                  rWr_cld <= '1';
                  FIFOtail <= FIFOtail+1;
                  WQPending <= '1';
               WHEN qe_wf3 => 
                  rWr_cld <= '0';
                  FIFOnonempty <= '1';
                  FIFO_cnt <= FIFO_cnt+1;
               WHEN qe_wf4 => 
                  FIFOfull <= '1';
               WHEN qe_wf6 => 
                  WriteStop <= '0';
               WHEN qe_wf7 => 
                  WriteStop <= '1';
               WHEN qe_rs0 => 
                  IF (timeout = '0') THEN 
                     RdSer_cld <= '1';
                     TOrst_cld <= '0';
                  END IF;
               WHEN qe_rs2 => 
                  IF (RdAck = '1') THEN 
                     qcli_status_cld <= RDataS;
                     QCLIResponding <= '1';
                     RdSer_cld <= '0';
                  ELSIF (timeout = '1') THEN 
                     QCLIResponding <= '0';
                     RdSer_cld <= '0';
                  END IF;
               WHEN qe_rs5 => 
                  Reading <= '0';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      Busy,
      Ctrlr_rst,
      FIFOfull,
      FIFOhead,
      FIFOnonempty,
      FIFOtail,
      RBComplete,
      RBPending,
      RdAck,
      RdFIFO,
      WQPending,
      WrEnB,
      WriteStop,
      cmdB,
      cmdC,
      current_state,
      timeout
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN qe_idle => 
            IF (Ctrlr_rst = '1') THEN 
               next_state <= qe_rst;
            ELSIF (WrEnB = '1' AND
                    cmdB /= "110") THEN 
               next_state <= qe_w0;
            ELSIF (RdFIFO = '1') THEN 
               next_state <= qe_rf0;
            ELSIF (Busy = '0' AND
                   FIFOnonempty = '1' AND
                   RBPending = '0') THEN 
               next_state <= qe_wq0;
            ELSIF (Busy = '0' AND
                   WQPending = '0' AND
                   timeout = '1') THEN 
               next_state <= qe_rs0;
            ELSE
               next_state <= qe_idle;
            END IF;
         WHEN qe_w0 => 
            IF (WrEnB = '0') THEN 
               next_state <= qe_w1;
            ELSE
               next_state <= qe_w0;
            END IF;
         WHEN qe_w1 => 
            IF (cmdC =
                 "101") THEN 
               next_state <= s1;
            ELSE
               next_state <= qe_wf0;
            END IF;
         WHEN qe_rst => 
            IF (Ctrlr_rst = '0') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rst;
            END IF;
         WHEN s1 => 
            next_state <= qe_idle;
         WHEN qe_rf0 => 
            IF (FIFOnonempty = '0' OR
                RBComplete = '0') THEN 
               next_state <= qe_rf1;
            ELSE
               next_state <= qe_rf3;
            END IF;
         WHEN qe_rf1 => 
            IF (RdFIFO = '0') THEN 
               next_state <= qe_rf2;
            ELSE
               next_state <= qe_rf1;
            END IF;
         WHEN qe_rf2 => 
            next_state <= qe_idle;
         WHEN qe_rf3 => 
            next_state <= qe_rf4;
         WHEN qe_rf4 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_rf5;
            ELSE
               next_state <= qe_rf6;
            END IF;
         WHEN qe_rf5 => 
            IF (RdFIFO = '0') THEN 
               next_state <= qe_rf2;
            ELSE
               next_state <= qe_rf5;
            END IF;
         WHEN qe_rf6 => 
            next_state <= qe_rf7;
         WHEN qe_rf7 => 
            IF (RdFIFO = '0') THEN 
               next_state <= qe_rf2;
            ELSE
               next_state <= qe_rf7;
            END IF;
         WHEN qe_wq0 => 
            next_state <= qe_wq1;
         WHEN qe_wq1 => 
            next_state <= qe_wq2;
         WHEN qe_wq2 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_wq3;
            ELSE
               next_state <= qe_wq5;
            END IF;
         WHEN qe_wq5 => 
            IF (Busy = '1') THEN 
               next_state <= qe_wq6;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_wq5;
            END IF;
         WHEN qe_wq3 => 
            next_state <= qe_wq5;
         WHEN qe_wq4 => 
            next_state <= qe_idle;
         WHEN qe_wq6 => 
            IF (Busy = '0') THEN 
               next_state <= qe_wq7;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_wq6;
            END IF;
         WHEN qe_wq7 => 
            IF (WriteStop = '1' AND
                FIFOnonempty = '0') THEN 
               next_state <= qe_wq4;
            ELSE
               next_state <= qe_idle;
            END IF;
         WHEN qe_wf0 => 
            IF (FIFOfull = '1') THEN 
               next_state <= qe_wf1;
            ELSE
               next_state <= qe_wf2;
            END IF;
         WHEN qe_wf1 => 
            next_state <= qe_idle;
         WHEN qe_wf2 => 
            next_state <= qe_wf3;
         WHEN qe_wf3 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_wf4;
            ELSE
               next_state <= qe_wf5;
            END IF;
         WHEN qe_wf4 => 
            next_state <= qe_wf5;
         WHEN qe_wf5 => 
            IF (cmdC = "011") THEN 
               next_state <= qe_wf6;
            ELSE
               next_state <= qe_wf7;
            END IF;
         WHEN qe_wf6 => 
            next_state <= qe_idle;
         WHEN qe_wf7 => 
            next_state <= qe_idle;
         WHEN qe_rs0 => 
            IF (timeout = '0') THEN 
               next_state <= qe_rs1;
            ELSE
               next_state <= qe_rs0;
            END IF;
         WHEN qe_rs1 => 
            IF (Busy = '1') THEN 
               next_state <= qe_rs2;
            ELSE
               next_state <= qe_rs1;
            END IF;
         WHEN qe_rs2 => 
            IF (RdAck = '1') THEN 
               next_state <= qe_rs3;
            ELSIF (timeout = '1') THEN 
               next_state <= qe_rs4;
            ELSE
               next_state <= qe_rs2;
            END IF;
         WHEN qe_rs3 => 
            IF (Busy = '0' AND
                RdAck = '0') THEN 
               next_state <= qe_rs5;
            ELSE
               next_state <= qe_rs3;
            END IF;
         WHEN qe_rs4 => 
            IF (Busy = '0' AND
                RdAck = '0') THEN 
               next_state <= qe_rs5;
            ELSE
               next_state <= qe_rs4;
            END IF;
         WHEN qe_rs5 => 
            next_state <= qe_idle;
         WHEN OTHERS =>
            next_state <= qe_idle;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   FIFO_rdata <= FIFO_rdata_cld;
   RdFAck <= RdFAck_cld;
   RdSer <= RdSer_cld;
   TOrst <= TOrst_cld;
   WDataS <= WDataS_cld;
   WrAck <= WrAck_cld;
   WrSer <= WrSer_cld;
   qcli_status <= qcli_status_cld;
   rRd <= rRd_cld;
   rWr <= rWr_cld;
   raddr <= raddr_cld;
   ram_wdata <= ram_wdata_cld;
   ctrlr_status(7 downto 0) <= FIFO_cnt;
   ctrlr_status(8) <= RBPending;
   ctrlr_status(9) <= RBComplete;
   ctrlr_status(10) <= WQPending;
   ctrlr_status(11) <= QCLIResponding;
   ctrlr_status(12) <= FIFOOvf;
   ctrlr_status(13) <= '0';
   ctrlr_status(14) <= Reading;
   ctrlr_status(15) <= '0';
END fsm;
