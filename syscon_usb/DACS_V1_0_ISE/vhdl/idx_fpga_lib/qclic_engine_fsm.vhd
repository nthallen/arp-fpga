-- VHDL Entity idx_fpga_lib.qclic_engine.interface
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 09:40:11 02/ 1/2012
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
--          at - 09:40:11 02/ 1/2012
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
   SIGNAL RWConflict : std_logic;  
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
      qe_ws,
      qe_rb0,
      qe_rb1,
      qe_rb2,
      qe_rb3,
      qe_rb4,
      qe_rf1,
      qe_rf2,
      qe_rf3,
      qe_rf5,
      qe_rf6,
      qe_rf7,
      qe_rf8,
      qe_wq0,
      qe_wq1,
      qe_wq5,
      qe_wq3,
      qe_wq2,
      qe_wf1,
      qe_wf2,
      qe_wf3,
      qe_rs0,
      qe_rs1,
      qe_rb5,
      qe_rb6,
      qe_rb7,
      qe_rb8,
      qe_rb9,
      qe_rb10,
      qe_rb11,
      qe_rb12,
      qe_rb13,
      qe_rb14,
      qe_rb15,
      qe_rs6,
      qe_rs7,
      qe_rs8,
      qe_rs9,
      qe_rb16,
      qe_rb17,
      qe_rb18,
      qe_wf4,
      qe_rb19,
      qe_rf4,
      qe_wf6,
      qe_rb20,
      qe_rf9,
      qe_wf7,
      qe_wf5,
      qe_rs10
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
            RWConflict <= '0';
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
                  rWr_cld <= '0';
                  rRd_cld <= '0';
                  WrSer_cld <= '0';
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
                  RdFAck_cld <= '0';
                  qcli_status_cld <= (others => '0');
                  Reading <= '0';
                  RBPending <= '0';
                  RBComplete <= '0';
                  WQPending <= '0';
                  QCLIResponding <= '0';
                  RWConflict <= '0';
                  FIFOOvf <= '0';
                  RdSer_cld <= '0';
                  WrAck_cld <= '1';
               WHEN qe_ws => 
                  WQPending <= '0';
                  WriteStop <= '0';
               WHEN qe_rb0 => 
                  RWConflict <= '1';
               WHEN qe_rb1 => 
                  RBPending <= '1';
               WHEN qe_rb2 => 
                  WDataS_cld(15 downto 8) <=
                      X"02";
                  WDataS_cld(7 downto 0) <=
                     WDataC(15 downto 8);
                  WrSer_cld <= '1';
               WHEN qe_rb3 => 
                  WrSer_cld <= '0';
               WHEN qe_rb4 => 
                  WDataS_cld <=
                      X"0500"; -- READ_DATA
                  WrSer_cld <= '1';
               WHEN qe_rf1 => 
                  FIFO_rdata_cld <= (others => '0');
                  RdFAck_cld <= '1';
                  RWConflict <= '1';
               WHEN qe_rf2 => 
                  RdFAck_cld <= '0';
               WHEN qe_rf3 => 
                  FIFOhead <=
                    FIFOhead+1;
               WHEN qe_rf5 => 
                  FIFOnonempty <= '0';
                  FIFO_rdata_cld <= (others => '0');
                  RdFAck_cld <= '1';
                  FIFO_cnt <= (others => '0');
                  RBComplete <= '0';
                  RBPending <= '0';
               WHEN qe_rf6 => 
                  rRd_cld <= '1';
               WHEN qe_rf7 => 
                  rRd_cld <= '0';
                  FIFOfull <= '0';
                  RdFAck_cld <= '1';
                  FIFO_cnt <= FIFO_cnt-1;
               WHEN qe_rf8 => 
                  FIFO_rdata_cld <=
                    ram_rdata;
               WHEN qe_wq0 => 
                  raddr_cld <= FIFOhead;
                  rRd_cld <= '1';
               WHEN qe_wq1 => 
                  rRd_cld <= '0';
                  FIFOhead <= FIFOhead+1;
                  FIFO_cnt <= FIFO_cnt-1;
                  FIFOfull <= '0';
               WHEN qe_wq5 => 
                  WrSer_cld <= '1';
               WHEN qe_wq3 => 
                  FIFOnonempty <= '0';
                  FIFO_cnt <= (others => '0');
               WHEN qe_wq2 => 
                  WDataS_cld <=
                    ram_rdata;
               WHEN qe_wf1 => 
                  FIFOOvf <= '1';
               WHEN qe_wf2 => 
                  rWr_cld <= '1';
                  FIFOtail <= FIFOtail+1;
                  WQPending <= '1';
                  FIFOnonempty <= '1';
                  FIFO_cnt <= FIFO_cnt+1;
               WHEN qe_wf3 => 
                  rWr_cld <= '0';
                  WriteStop <= '0';
               WHEN qe_rs0 => 
                  TOrst_cld <= '1';
                  Reading <= '1';
               WHEN qe_rs1 => 
                  RdSer_cld <= '1';
                  TOrst_cld <= '0';
               WHEN qe_rb5 => 
                  WrSer_cld <= '0';
                  FIFOhead <= (others => '0');
                  FIFOtail <= (others => '0');
                  FIFO_cnt <= (others => '0');
               WHEN qe_rb6 => 
                  WDataS_cld(15 downto 8) <=
                      X"03"; -- WRITE ADDRESS
                  WDataS_cld(7 downto 0) <=
                     WDataC(7 downto 0);
                  WrSer_cld <= '1';
               WHEN qe_rb8 => 
                  RdSer_cld <= '1';
               WHEN qe_rb10 => 
                  RdSer_cld <= '0';
               WHEN qe_rb13 => 
                  RBComplete <= '1';
                  FIFOfull <= '1';
               WHEN qe_rb14 => 
                  WDataS_cld <=
                      X"0100"; -- STOP
                  WrSer_cld <= '1';
               WHEN qe_rb15 => 
                  WrSer_cld <= '0';
               WHEN qe_rs6 => 
                  qcli_status_cld <= RDataS;
                  QCLIResponding <= '1';
                  RdSer_cld <= '0';
               WHEN qe_rs8 => 
                  Reading <= '0';
               WHEN qe_rs9 => 
                  QCLIResponding <= '0';
                  RdSer_cld <= '0';
               WHEN qe_rb16 => 
                  rWr_cld <= '0';
                  FIFOtail <= FIFOtail+1;
                  FIFO_cnt <= FIFO_cnt+1;
                  FIFOnonempty <= '1';
               WHEN qe_rb17 => 
                  FIFO_rdata_cld <= RDataS;
               WHEN qe_rb18 => 
                  ram_wdata_cld <= RDataS;
                  raddr_cld <= FIFOtail;
                  rWr_cld <= '1';
               WHEN qe_wf4 => 
                  RWConflict <= '1';
               WHEN qe_wf6 => 
                  raddr_cld
                    <= FIFOtail;
                  ram_wdata_cld
                    <= WDataC;
               WHEN qe_rb20 => 
                  WDataC <= WDataC+1;
                  WrSer_cld <= '0';
               WHEN qe_rf9 => 
                  raddr_cld <=
                    FIFOhead;
               WHEN qe_wf7 => 
                  rWr_cld <= '0';
                  WriteStop <= '1';
               WHEN qe_wf5 => 
                  FIFOfull <= '1';
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
      FIFO_cnt,
      FIFOfull,
      FIFOhead,
      FIFOnonempty,
      FIFOtail,
      RBComplete,
      RBPending,
      RdAck,
      RdFIFO,
      Reading,
      WQPending,
      WrEnB,
      WriteStop,
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
            ELSIF (WrEnB = '1') THEN 
               next_state <= qe_w0;
            ELSIF (RdFIFO = '1') THEN 
               next_state <= qe_rf4;
            ELSIF (Busy = '0' AND
                   FIFOnonempty = '1'
                   AND RBPending = '0') THEN 
               next_state <= qe_wq0;
            ELSIF (Busy = '0' AND
                   WQPending = '0' AND
                   timeout = '1') THEN 
               next_state <= qe_rs0;
            ELSIF (Busy = '0' AND
                   FIFOnonempty = '0'
                   AND RBPending = '0'
                   AND WriteStop = '1') THEN 
               next_state <= qe_ws;
            ELSIF (Reading = '1' AND
                   ( RdAck = '1' OR
                   timeout = '1' )) THEN 
               next_state <= qe_rs7;
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
               next_state <= qe_rb19;
            ELSIF (cmdC = "011" OR
                   cmdC = "100") THEN 
               next_state <= qe_wf6;
            ELSE
               next_state <= qe_idle;
            END IF;
         WHEN qe_rst => 
            IF (Ctrlr_rst = '0') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rst;
            END IF;
         WHEN qe_ws => 
            next_state <= qe_rs0;
         WHEN qe_rb0 => 
            next_state <= qe_idle;
         WHEN qe_rb1 => 
            IF (Busy = '0') THEN 
               next_state <= qe_rb2;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb1;
            END IF;
         WHEN qe_rb2 => 
            IF (Busy = '1') THEN 
               next_state <= qe_rb3;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb2;
            END IF;
         WHEN qe_rb3 => 
            IF (Busy = '0') THEN 
               next_state <= qe_rb4;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb3;
            END IF;
         WHEN qe_rb4 => 
            IF (Busy = '1') THEN 
               next_state <= qe_rb5;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb4;
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
            next_state <= qe_rf9;
         WHEN qe_rf5 => 
            IF (RdFIFO = '0') THEN 
               next_state <= qe_rf2;
            ELSE
               next_state <= qe_rf5;
            END IF;
         WHEN qe_rf6 => 
            next_state <= qe_rf7;
         WHEN qe_rf7 => 
            next_state <= qe_rf8;
         WHEN qe_rf8 => 
            IF (RdFIFO = '0') THEN 
               next_state <= qe_rf2;
            ELSE
               next_state <= qe_rf8;
            END IF;
         WHEN qe_wq0 => 
            next_state <= qe_wq1;
         WHEN qe_wq1 => 
            next_state <= qe_wq2;
         WHEN qe_wq5 => 
            IF (Busy = '1' OR
                Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_wq5;
            END IF;
         WHEN qe_wq3 => 
            next_state <= qe_wq5;
         WHEN qe_wq2 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_wq3;
            ELSE
               next_state <= qe_wq5;
            END IF;
         WHEN qe_wf1 => 
            next_state <= qe_idle;
         WHEN qe_wf2 => 
            IF (cmdC = "011") THEN 
               next_state <= qe_wf3;
            ELSE
               next_state <= qe_wf7;
            END IF;
         WHEN qe_wf3 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_wf5;
            ELSE
               next_state <= qe_idle;
            END IF;
         WHEN qe_rs0 => 
            IF (timeout = '0') THEN 
               next_state <= qe_rs1;
            ELSE
               next_state <= qe_rs0;
            END IF;
         WHEN qe_rs1 => 
            IF (Busy = '1' OR
                timeout = '1' OR
                Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rs1;
            END IF;
         WHEN qe_rb5 => 
            IF (Busy = '0') THEN 
               next_state <= qe_rb6;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb5;
            END IF;
         WHEN qe_rb6 => 
            IF (Busy = '1') THEN 
               next_state <= qe_rb20;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb6;
            END IF;
         WHEN qe_rb7 => 
            IF (Busy = '0') THEN 
               next_state <= qe_rb8;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb7;
            END IF;
         WHEN qe_rb8 => 
            IF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSIF (Busy = '1') THEN 
               next_state <= qe_rb9;
            ELSE
               next_state <= qe_rb8;
            END IF;
         WHEN qe_rb9 => 
            IF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSIF (RdAck = '1') THEN 
               next_state <= qe_rb10;
            ELSE
               next_state <= qe_rb9;
            END IF;
         WHEN qe_rb10 => 
            IF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSIF (Busy = '0' AND
                   RdAck = '0') THEN 
               next_state <= qe_rb11;
            ELSE
               next_state <= qe_rb10;
            END IF;
         WHEN qe_rb11 => 
            IF (FIFOnonempty = '0') THEN 
               next_state <= qe_rb17;
            ELSE
               next_state <= qe_rb18;
            END IF;
         WHEN qe_rb12 => 
            IF (FIFO_cnt /= X"80") THEN 
               next_state <= qe_rb6;
            ELSE
               next_state <= qe_rb14;
            END IF;
         WHEN qe_rb13 => 
            next_state <= qe_idle;
         WHEN qe_rb14 => 
            IF (Busy = '1') THEN 
               next_state <= qe_rb15;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb14;
            END IF;
         WHEN qe_rb15 => 
            IF (Busy = '0') THEN 
               next_state <= qe_rb13;
            ELSIF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSE
               next_state <= qe_rb15;
            END IF;
         WHEN qe_rs6 => 
            next_state <= qe_rs10;
         WHEN qe_rs7 => 
            IF (RdAck = '1') THEN 
               next_state <= qe_rs6;
            ELSE
               next_state <= qe_rs9;
            END IF;
         WHEN qe_rs8 => 
            next_state <= qe_idle;
         WHEN qe_rs9 => 
            next_state <= qe_rs10;
         WHEN qe_rb16 => 
            next_state <= qe_rb12;
         WHEN qe_rb17 => 
            next_state <= qe_rb18;
         WHEN qe_rb18 => 
            next_state <= qe_rb16;
         WHEN qe_wf4 => 
            next_state <= qe_idle;
         WHEN qe_rb19 => 
            IF (FIFOnonempty = '1') THEN 
               next_state <= qe_rb0;
            ELSE
               next_state <= qe_rb1;
            END IF;
         WHEN qe_rf4 => 
            IF (FIFOnonempty = '0' OR
                RBComplete = '0' OR
                WQPending = '1') THEN 
               next_state <= qe_rf1;
            ELSE
               next_state <= qe_rf3;
            END IF;
         WHEN qe_wf6 => 
            IF (RBPending = '1' OR
                RBComplete = '1') THEN 
               next_state <= qe_wf4;
            ELSIF (FIFOfull = '1') THEN 
               next_state <= qe_wf1;
            ELSE
               next_state <= qe_wf2;
            END IF;
         WHEN qe_rb20 => 
            next_state <= qe_rb7;
         WHEN qe_rf9 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_rf5;
            ELSE
               next_state <= qe_rf6;
            END IF;
         WHEN qe_wf7 => 
            IF (FIFOhead = FIFOtail) THEN 
               next_state <= qe_wf5;
            ELSE
               next_state <= qe_idle;
            END IF;
         WHEN qe_wf5 => 
            next_state <= qe_idle;
         WHEN qe_rs10 => 
            IF (Ctrlr_rst = '1') THEN 
               next_state <= qe_idle;
            ELSIF (Busy = '0' AND
                   RdAck = '0') THEN 
               next_state <= qe_rs8;
            ELSE
               next_state <= qe_rs10;
            END IF;
         WHEN OTHERS =>
            next_state <= qe_rst;
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
   ctrlr_status(13) <= RWConflict;
   ctrlr_status(14) <= Reading;
   ctrlr_status(15) <= '0';
END fsm;
