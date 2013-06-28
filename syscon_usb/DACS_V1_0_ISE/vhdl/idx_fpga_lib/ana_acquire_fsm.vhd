-- VHDL Entity idx_fpga_lib.ana_acquire.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:46:43 04/22/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_acquire IS
   PORT( 
      AICtrl    : IN     std_logic_vector (12 DOWNTO 0);
      CLK       : IN     std_ulogic;
      CurMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
      NewMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
      RST       : IN     std_ulogic;
      RdyIn     : IN     std_ulogic_vector (3 DOWNTO 0);
      SDI       : IN     std_ulogic_vector (1 DOWNTO 0);
      CS5       : OUT    std_ulogic;
      Col_Addr  : OUT    std_logic_vector (3 DOWNTO 0);
      Conv      : OUT    std_ulogic;
      NxtRow    : OUT    std_ulogic_vector (5 DOWNTO 0);
      RD_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      RdEn      : OUT    std_ulogic;
      Restart   : OUT    std_ulogic;
      S5WE      : OUT    std_ulogic_vector (1 DOWNTO 0);
      Start     : OUT    std_ulogic;
      Status    : OUT    std_ulogic_vector (11 DOWNTO 0);
      WR_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      WrEn      : OUT    std_ulogic
   );

-- Declarations
  attribute fsm_encoding: string;
  attribute fsm_encoding of ana_acquire : entity is "one-hot";
  attribute safe_implementation: string;
  attribute safe_implementation of ana_acquire : entity is "yes";
END ana_acquire ;

--
-- VHDL Architecture idx_fpga_lib.ana_acquire.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:46:43 04/22/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
 
ARCHITECTURE fsm OF ana_acquire IS

   -- Architecture Declarations
   function mkaddr(
     row : in std_logic_vector(5 DOWNTO 0);
     bank : in std_logic_vector(0 DOWNTO 0);
     col : in std_logic_vector(2 DOWNTO 0) 
   ) return std_logic_vector is
   begin
     return '0' & row(2 DOWNTO 0) &
       bank & col;
   end mkaddr;
   
   function muxaddr(
     cfg : in std_logic_vector(3 DOWNTO 0);
     bank : in std_logic_vector(0 DOWNTO 0);
     row : in std_logic_vector(5 DOWNTO 0)
   ) return std_logic_vector is
   begin
     return std_logic_vector( cfg & bank &
         row(5 DOWNTO 3));
   end muxaddr;
   
   function rmuxaddr(
     cfg : in std_logic_vector(3 DOWNTO 0);
     bank : in std_logic_vector(0 DOWNTO 0);
     col : in std_logic_vector(2 DOWNTO 0);
     rown : in std_logic_vector(5 DOWNTO 0);
     rownn : in std_logic_vector(5 DOWNTO 0)
   ) return std_logic_vector is
     Variable mrow : std_logic_vector(5 DOWNTO 0);
   begin
     if unsigned(col) < 2 then
       mrow := rown;
     else
       mrow := rownn;
     end if;
     return std_logic_vector( cfg & bank &
         mrow(5 DOWNTO 3));
   end rmuxaddr;
   
   function permute(
     row : in std_logic_vector(5 DOWNTO 0);
     rowN : in std_logic_vector(5 DOWNTO 0);
     bank : in std_logic_vector(0 DOWNTO 0);
     col : in std_logic_vector(2 DOWNTO 0) 
   ) return std_logic_vector is
       Variable permute : unsigned(3 DOWNTO 0);
       Variable mapped : unsigned(3 DOWNTO 0);
       Variable mrow : std_logic_vector(5 DOWNTO 0);
   begin
     permute(2 DOWNTO 0) := unsigned(col);
     permute(3) := '0';
     mapped := permute + 6;
     if mapped(3) = '0' then
       mrow := rowN;
     else
       mrow := row;
     end if;
     return '0' & mrow(2 DOWNTO 0) & bank &
       std_logic_vector(mapped(2 DOWNTO 0));
   end permute;
   SIGNAL AIEn : std_logic;  
   SIGNAL Col : std_logic_vector(2 DOWNTO 0);  
   SIGNAL DblConv : std_logic_vector(1 DOWNTO 0);  
   SIGNAL FixRow : std_logic;  
   SIGNAL Fixed : std_logic_vector(5 DOWNTO 0);  
   SIGNAL IncRow : std_logic;  
   SIGNAL NStat : std_ulogic_vector(4 DOWNTO 0);  
   SIGNAL RowN : std_logic_vector(5 DOWNTO 0);  
   SIGNAL RowNN : std_logic_vector(5 DOWNTO 0);  
   SIGNAL RowU : std_logic_vector(5 DOWNTO 0);  
   SIGNAL TOStat : std_ulogic_vector(1 DOWNTO 0);  
   SIGNAL WRow : std_ulogic;  
   SIGNAL WRowN : std_ulogic;  

   TYPE STATE_TYPE IS (
      acq_init_row,
      acq_idle,
      acq_start,
      acq_1,
      acq_2,
      acq_loop,
      acq_row_end,
      acq_conv,
      acq_b0e,
      acq_b0a,
      acq_b0h,
      acq_b1a,
      acq_b1e,
      acq_b1f,
      acq_b1g,
      acq_b1c,
      acq_settle,
      acq_col_end,
      acq_row,
      acq_b0c,
      acq_b0f,
      acq_rst,
      acq_3,
      acq_b0d,
      acq_b0g,
      acq_b1d,
      acq_b1h,
      acq_dbl,
      acq_dbl2,
      acq_row2
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(10 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(10 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_acq_idle : std_logic;
   SIGNAL csm_to_acq_conv : std_logic;
   SIGNAL csm_to_acq_settle : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL CS5_cld : std_ulogic ;
   SIGNAL Col_Addr_cld : std_logic_vector (3 DOWNTO 0);
   SIGNAL Conv_cld : std_ulogic ;
   SIGNAL NxtRow_cld : std_ulogic_vector (5 DOWNTO 0);
   SIGNAL RD_Addr_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL RdEn_cld : std_ulogic ;
   SIGNAL Restart_cld : std_ulogic ;
   SIGNAL S5WE_cld : std_ulogic_vector (1 DOWNTO 0);
   SIGNAL Start_cld : std_ulogic ;
   SIGNAL Status_int : std_ulogic_vector (11 DOWNTO 0);
   SIGNAL WR_Addr_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL WrEn_cld : std_ulogic ;

   attribute safe_recovery_state: string;
   attribute safe_recovery_state of current_state : signal is "acq_rst";
   attribute safe_recovery_state of next_state : signal is "acq_rst";
BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      CLK
   )
   -----------------------------------------------------------------
   BEGIN
      IF (CLK'EVENT AND CLK = '1') THEN
         IF (RST = '1') THEN
            current_state <= acq_rst;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            CS5_cld <= '1';
            Col_Addr_cld <= (others => '0');
            Conv_cld <= '1';
            NxtRow_cld <= (others => '0');
            RD_Addr_cld <= (others => '0');
            RdEn_cld <= '0';
            Restart_cld <= '0';
            S5WE_cld <= "00";
            Start_cld <= '0';
            WR_Addr_cld <= (others => '0');
            WrEn_cld <= '0';
            Col <= (others => '1');
            RowN <= "000000";
            RowNN <= "000001";
            RowU <= (others => '0');
            TOStat <= (others => '0');
            WRow <= '1';
            WRowN <= '1';
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;
            -- Registered output assignments
            Status <= Status_int;
            -- Default Assignment To Internals
            Conv_cld <= '1';

            -- Combined Actions
            CASE current_state IS
               WHEN acq_init_row => 
                  Col <= "111";
                  Conv_cld <= '1';
                  Start_cld <= '0';
                  Restart_cld <= '0';
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
                  S5WE_cld <= "00";
               WHEN acq_idle => 
                  Conv_cld <= '0';
                  IF (csm_timeout = '1' AND (SDI = "00"
                       AND AIEn = '1')) THEN 
                  ELSIF (csm_timeout = '1') THEN 
                     TOStat(0) <= '1';
                  END IF;
               WHEN acq_start => 
                  Start_cld <= '1' ;
                  CS5_cld <= '0';
                  RowN <= RowNN;
               WHEN acq_1 => 
                  Restart_cld <= '1';
               WHEN acq_2 => 
                  Restart_cld <= '0';
               WHEN acq_loop => 
                  Col_Addr_cld <=
                     '0' & Col;
               WHEN acq_conv => 
                  Conv_cld <= '1' ;
                  RowU <= RowN;
                  WRow <= WRowN;
                  IF (RdyIn = "1111"
                      AND SDI = "11") THEN 
                  ELSIF (csm_timeout = '1') THEN 
                     TOStat(1) <= '1';
                  END IF;
               WHEN acq_b0e => 
                  Col_Addr_cld <=
                     '1' & Col;
               WHEN acq_b0a => 
                  RD_Addr_cld <=
                    permute(RowN, RowNN, "0", Col);
                  WR_Addr_cld <=
                   mkaddr(RowU,"0",Col);
                  WrEn_cld <= WRow;
                  RdEn_cld <= '1';
               WHEN acq_b0h => 
                  S5WE_cld(0) <= '1';
               WHEN acq_b1a => 
                  S5WE_cld(0) <= '0';
                  RD_Addr_cld <=
                    permute(RowN,RowNN,"1",Col);
                  WR_Addr_cld <=
                    mkaddr(RowU,"1",Col);
                  WrEn_cld <= WRow;
                  RdEn_cld <= '1';
               WHEN acq_b1f => 
                  RD_Addr_cld <=
                    rmuxaddr(NewMuxCfg,"1",Col,RowN,RowNN);
                  RdEn_cld <= '1';
               WHEN acq_b1g => 
                  RdEn_cld <= '0';
               WHEN acq_b1c => 
                  WrEn_cld <= WRow;
                  RdEn_cld <= '0';
                  WR_Addr_cld <=
                    muxaddr(CurMuxCfg,"1",RowU);
               WHEN acq_col_end => 
                  S5WE_cld(1) <= '0';
                  Col <= Col-1;
               WHEN acq_row => 
                  Start_cld <= '0';
                  NxtRow_cld <=
                   std_ulogic_vector(RowN);
                  if FixRow = '1' then
                    RowNN <= Fixed;
                  elsif IncRow = '1' then
                    RowNN <=
                      unsigned(RowN) +
                       unsigned(Fixed);
                  else
                    RowNN <= RowN+1;
                  end if;
               WHEN acq_b0c => 
                  WR_Addr_cld <=
                    muxaddr(CurMuxCfg,"0",RowU);
                  WrEn_cld <= WRow;
                  RdEn_cld <= '0';
               WHEN acq_b0f => 
                  RD_Addr_cld <=
                    rmuxaddr(NewMuxCfg,"0",Col,RowN,RowNN);
                  RdEn_cld <= '1';
               WHEN acq_rst => 
                  Col <= "111";
                  Conv_cld <= '1';
                  Start_cld <= '0';
                  Restart_cld <= '0';
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
                  S5WE_cld <= "00";
                  RowN <= "000000";
                  NxtRow_cld <= "000000";
                  CS5_cld <= '1';
               WHEN acq_3 => 
                  CS5_cld <= '1';
               WHEN acq_b0d => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
               WHEN acq_b0g => 
                  RdEn_cld <= '0';
               WHEN acq_b1d => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
               WHEN acq_b1h => 
                  S5WE_cld(1) <= '1';
               WHEN acq_dbl => 
                  WRowN <= '1';
               WHEN acq_dbl2 => 
                  WRowN <= '0';
               WHEN acq_row2 => 
                  Start_cld <= '0';
                  NxtRow_cld <=
                   std_ulogic_vector(RowN);
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      AIEn,
      Col,
      CurMuxCfg,
      DblConv,
      NewMuxCfg,
      RdyIn,
      RowN,
      RowNN,
      SDI,
      WRowN,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_acq_idle <= '0';
      csm_to_acq_conv <= '0';
      csm_to_acq_settle <= '0';
      CASE current_state IS
         WHEN acq_init_row => 
            IF (RdyIn = "1111") THEN 
               next_state <= acq_idle;
               csm_to_acq_idle <= '1';
            ELSE
               next_state <= acq_init_row;
            END IF;
         WHEN acq_idle => 
            IF (csm_timeout = '1' AND (SDI = "00"
                 AND AIEn = '1')) THEN 
               next_state <= acq_conv;
               csm_to_acq_conv <= '1';
            ELSIF (csm_timeout = '1') THEN 
               next_state <= acq_idle;
            ELSE
               next_state <= acq_idle;
            END IF;
         WHEN acq_start => 
            IF (RdyIn = "0000"
                AND WRowN = '1') THEN 
               next_state <= acq_row;
            ELSIF (RdyIn = "0000"
                   AND WRowN /= '1') THEN 
               next_state <= acq_row2;
            ELSE
               next_state <= acq_start;
            END IF;
         WHEN acq_1 => 
            IF (RdyIn = "0000") THEN 
               next_state <= acq_2;
            ELSE
               next_state <= acq_1;
            END IF;
         WHEN acq_2 => 
            next_state <= acq_b0a;
         WHEN acq_loop => 
            IF (Col = 0 AND
                RdyIn = "1111") THEN 
               next_state <= acq_3;
            ELSIF (RdyIn = "1111") THEN 
               next_state <= acq_1;
            ELSE
               next_state <= acq_loop;
            END IF;
         WHEN acq_row_end => 
            next_state <= acq_init_row;
         WHEN acq_conv => 
            IF (RdyIn = "1111"
                AND SDI = "11") THEN 
               next_state <= acq_dbl;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= acq_idle;
               csm_to_acq_idle <= '1';
            ELSE
               next_state <= acq_conv;
            END IF;
         WHEN acq_b0e => 
            IF (NewMuxCfg(3) = '1') THEN 
               next_state <= acq_b0f;
            ELSE
               next_state <= acq_b0g;
            END IF;
         WHEN acq_b0a => 
            IF (CurMuxCfg(3) = '0') THEN 
               next_state <= acq_b0d;
            ELSE
               next_state <= acq_b0c;
            END IF;
         WHEN acq_b0h => 
            next_state <= acq_b1a;
         WHEN acq_b1a => 
            IF (CurMuxCfg(3) = '0') THEN 
               next_state <= acq_b1d;
            ELSE
               next_state <= acq_b1c;
            END IF;
         WHEN acq_b1e => 
            IF (NewMuxCfg(3) = '1') THEN 
               next_state <= acq_b1f;
            ELSE
               next_state <= acq_b1g;
            END IF;
         WHEN acq_b1f => 
            next_state <= acq_b1g;
         WHEN acq_b1g => 
            next_state <= acq_b1h;
         WHEN acq_b1c => 
            next_state <= acq_b1d;
         WHEN acq_settle => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_row_end;
            ELSE
               next_state <= acq_settle;
            END IF;
         WHEN acq_col_end => 
            IF (Col /= 0) THEN 
               next_state <= acq_loop;
            ELSE
               next_state <= acq_settle;
               csm_to_acq_settle <= '1';
            END IF;
         WHEN acq_row => 
            next_state <= acq_loop;
         WHEN acq_b0c => 
            next_state <= acq_b0d;
         WHEN acq_b0f => 
            next_state <= acq_b0g;
         WHEN acq_rst => 
            next_state <= acq_init_row;
         WHEN acq_3 => 
            next_state <= acq_b0a;
         WHEN acq_b0d => 
            next_state <= acq_b0e;
         WHEN acq_b0g => 
            next_state <= acq_b0h;
         WHEN acq_b1d => 
            next_state <= acq_b1e;
         WHEN acq_b1h => 
            next_state <= acq_col_end;
         WHEN acq_dbl => 
            IF (DblConv = "00"
                 OR
                RowN(2 DOWNTO 0) = RowNN(2 DOWNTO 0)
                OR
                (DblConv = "01" AND
                RowNN(2 DOWNTO 0) /= "000")) THEN 
               next_state <= acq_start;
            ELSE
               next_state <= acq_dbl2;
            END IF;
         WHEN acq_dbl2 => 
            next_state <= acq_start;
         WHEN acq_row2 => 
            next_state <= acq_loop;
         WHEN OTHERS =>
            next_state <= acq_rst;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   output_proc : PROCESS ( 
      AICtrl,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default Assignment To Internals
      AIEn <= not AICtrl(7);
      DblConv <= AICtrl(12 DOWNTO 11);
      FixRow <= AICtrl(6);
      Fixed <= AICtrl(5 DOWNTO 0);
      IncRow <= AICtrl(8);
      NStat <= (others => '0');

      -- Combined Actions
      CASE current_state IS
         WHEN acq_init_row => 
            NStat <= "00001";
         WHEN acq_idle => 
            NStat <= "00010";
         WHEN acq_start => 
            NStat <= "00110";
         WHEN acq_1 => 
            NStat <= "01010";
         WHEN acq_2 => 
            NStat <= "01100";
         WHEN acq_loop => 
            NStat <= "01001";
         WHEN acq_row_end => 
            NStat <= "11101";
         WHEN acq_conv => 
            NStat <= "00011";
         WHEN acq_b0e => 
            NStat <= "10000";
         WHEN acq_b0a => 
            NStat <= "01101";
         WHEN acq_b0h => 
            NStat <= "10011";
         WHEN acq_b1a => 
            NStat <= "10100";
         WHEN acq_b1e => 
            NStat <= "10111";
         WHEN acq_b1f => 
            NStat <= "11000";
         WHEN acq_b1g => 
            NStat <= "11001";
         WHEN acq_b1c => 
            NStat <= "10101";
         WHEN acq_settle => 
            NStat <= "11100";
         WHEN acq_col_end => 
            NStat <= "11011";
         WHEN acq_row => 
            NStat <= "01000";
         WHEN acq_b0c => 
            NStat <= "01110";
         WHEN acq_b0f => 
            NStat <= "10001";
         WHEN acq_rst => 
            NStat <= "00000";
         WHEN acq_3 => 
            NStat <= "01011";
         WHEN acq_b0d => 
            NStat <= "01111";
         WHEN acq_b0g => 
            NStat <= "10010";
         WHEN acq_b1d => 
            NStat <= "10110";
         WHEN acq_b1h => 
            NStat <= "11010";
         WHEN acq_dbl => 
            NStat <= "00100";
         WHEN acq_dbl2 => 
            NStat <= "00101";
         WHEN acq_row2 => 
            NStat <= "00111";
         WHEN OTHERS =>
            NULL;
      END CASE;
   END PROCESS output_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_acq_idle,
      csm_to_acq_conv,
      csm_to_acq_settle
   )
   -----------------------------------------------------------------
   VARIABLE csm_temp_timeout : std_logic;
   BEGIN
      IF (unsigned(csm_timer) = 0) THEN
         csm_temp_timeout := '1';
      ELSE
         csm_temp_timeout := '0';
      END IF;

      IF (csm_to_acq_idle = '1') THEN
         csm_next_timer <= "00000001001"; -- no cycles(10)-1=9
      ELSIF (csm_to_acq_conv = '1') THEN
         csm_next_timer <= "00000011111"; -- no cycles(32)-1=31
      ELSIF (csm_to_acq_settle = '1') THEN
         csm_next_timer <= "10010101111"; -- no cycles(1200)-1=1199
      ELSE
         IF (csm_temp_timeout = '1') THEN
            csm_next_timer <= (OTHERS=>'0');
         ELSE
            csm_next_timer <= unsigned(csm_timer) - '1';
         END IF;
      END IF;
      csm_timeout <= csm_temp_timeout;
   END PROCESS csm_wait_combo_proc;

   -- Concurrent Statements
   -- Clocked output assignments
   CS5 <= CS5_cld;
   Col_Addr <= Col_Addr_cld;
   Conv <= Conv_cld;
   NxtRow <= NxtRow_cld;
   RD_Addr <= RD_Addr_cld;
   RdEn <= RdEn_cld;
   Restart <= Restart_cld;
   S5WE <= S5WE_cld;
   Start <= Start_cld;
   WR_Addr <= WR_Addr_cld;
   WrEn <= WrEn_cld;
   Status_int(4 downto 0) <= NStat;
   Status_int(6 downto 5) <= TOStat;
   Status_int(7) <= '0';
   Status_int(11 downto 8) <= RdyIn;
END fsm;
