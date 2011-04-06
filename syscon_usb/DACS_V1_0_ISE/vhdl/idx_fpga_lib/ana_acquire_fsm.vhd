-- VHDL Entity idx_fpga_lib.ana_acquire.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:39:57 04/ 6/2011
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
      RAM_BusyR : IN     std_ulogic;
      RAM_BusyW : IN     std_ulogic;
      RST       : IN     std_ulogic;
      RdyIn     : IN     std_ulogic_vector (3 DOWNTO 0);
      SDI       : IN     std_ulogic_vector (1 DOWNTO 0);
      CS5       : OUT    std_ulogic;
      Col_Addr  : OUT    std_logic_vector (3 DOWNTO 0);
      Conv      : OUT    std_ulogic;
      NxtRow    : OUT    std_ulogic_vector (5 DOWNTO 0);
      RD_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      RdEn      : OUT    std_ulogic;
      RdyOut    : OUT    std_ulogic;
      Restart   : OUT    std_ulogic;
      S5WE      : OUT    std_ulogic_vector (1 DOWNTO 0);
      Start     : OUT    std_ulogic;
      Status    : OUT    std_ulogic_vector (11 DOWNTO 0);
      WR_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      WrEn      : OUT    std_ulogic
   );

-- Declarations

END ana_acquire ;

--
-- VHDL Architecture idx_fpga_lib.ana_acquire.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:39:58 04/ 6/2011
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
   SIGNAL NStat : std_ulogic_vector(3 DOWNTO 0);  
   SIGNAL RowN : std_logic_vector(5 DOWNTO 0);  
   SIGNAL RowNN : std_logic_vector(5 DOWNTO 0);  
   SIGNAL RowU : std_logic_vector(5 DOWNTO 0);  
   SIGNAL TOStat : std_ulogic_vector(1 DOWNTO 0);  
   SIGNAL XtraSettle : std_logic;  

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
      acq_b0b,
      acq_b1c,
      acq_settle,
      acq_col_end,
      acq_settle1,
      acq_row,
      acq_b0c,
      acq_b0f,
      acq_b1b,
      acq_rst,
      acq_3,
      acq_b0i,
      acq_b0d,
      acq_b0g,
      acq_b1d,
      acq_b1h,
      acq_dbl,
      acq_idle2,
      acq_conv2,
      acq_dbl2
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(14 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(14 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_acq_idle : std_logic;
   SIGNAL csm_to_acq_conv : std_logic;
   SIGNAL csm_to_acq_settle : std_logic;
   SIGNAL csm_to_acq_settle1 : std_logic;
   SIGNAL csm_to_acq_idle2 : std_logic;
   SIGNAL csm_to_acq_conv2 : std_logic;
   SIGNAL csm_to_acq_dbl2 : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL CS5_cld : std_ulogic ;
   SIGNAL Col_Addr_cld : std_logic_vector (3 DOWNTO 0);
   SIGNAL Conv_cld : std_ulogic ;
   SIGNAL NxtRow_cld : std_ulogic_vector (5 DOWNTO 0);
   SIGNAL RD_Addr_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL RdEn_cld : std_ulogic ;
   SIGNAL RdyOut_cld : std_ulogic ;
   SIGNAL Restart_cld : std_ulogic ;
   SIGNAL S5WE_cld : std_ulogic_vector (1 DOWNTO 0);
   SIGNAL Start_cld : std_ulogic ;
   SIGNAL Status_int : std_ulogic_vector (11 DOWNTO 0);
   SIGNAL WR_Addr_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL WrEn_cld : std_ulogic ;

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
            RdyOut_cld <= '0';
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
                  RdyOut_cld <= '0';
                  RowN <= RowNN;
               WHEN acq_1 => 
                  Restart_cld <= '1';
               WHEN acq_2 => 
                  Restart_cld <= '0';
               WHEN acq_loop => 
                  Col_Addr_cld <=
                     '0' & Col;
               WHEN acq_row_end => 
                  RdyOut_cld <= '1';
               WHEN acq_conv => 
                  Conv_cld <= '1' ;
                  RowU <= RowN;
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
                  WrEn_cld <= '1';
                  RdEn_cld <= '1';
               WHEN acq_b0h => 
                  S5WE_cld(0) <= '1';
               WHEN acq_b1a => 
                  S5WE_cld(0) <= '0';
                  RD_Addr_cld <=
                    permute(RowN,RowNN,"1",Col);
                  WR_Addr_cld <=
                    mkaddr(RowU,"1",Col);
                  WrEn_cld <= '1';
                  RdEn_cld <= '1';
               WHEN acq_b1f => 
                  RD_Addr_cld <=
                    rmuxaddr(NewMuxCfg,"1",Col,RowN,RowNN);
                  RdEn_cld <= '1';
               WHEN acq_b1g => 
                  RdEn_cld <= '0';
               WHEN acq_b0b => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
               WHEN acq_b1c => 
                  WrEn_cld <= '1';
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
                  WrEn_cld <= '1';
                  RdEn_cld <= '0';
               WHEN acq_b0f => 
                  RD_Addr_cld <=
                    rmuxaddr(NewMuxCfg,"0",Col,RowN,RowNN);
                  RdEn_cld <= '1';
               WHEN acq_b1b => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
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
               WHEN acq_b0i => 
                  S5WE_cld(0) <= '0';
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
               WHEN acq_idle2 => 
                  Conv_cld <= '0';
                  IF (csm_timeout = '1' AND (SDI = "00"
                       AND AIEn = '1')) THEN 
                  ELSIF (csm_timeout = '1') THEN 
                     TOStat(0) <= '1';
                  END IF;
               WHEN acq_conv2 => 
                  Conv_cld <= '1' ;
                  IF (RdyIn = "1111"
                      AND SDI = "11") THEN 
                  ELSIF (csm_timeout = '1') THEN 
                     TOStat(1) <= '1';
                  END IF;
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
      RAM_BusyR,
      RAM_BusyW,
      RdyIn,
      RowU,
      SDI,
      XtraSettle,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_acq_idle <= '0';
      csm_to_acq_conv <= '0';
      csm_to_acq_settle <= '0';
      csm_to_acq_settle1 <= '0';
      csm_to_acq_idle2 <= '0';
      csm_to_acq_conv2 <= '0';
      csm_to_acq_dbl2 <= '0';
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
            IF (RdyIn = "0000") THEN 
               next_state <= acq_row;
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
            IF (RAM_BusyR ='0' AND
                 RAM_BusyW = '0') THEN 
               next_state <= acq_b0a;
            ELSE
               next_state <= acq_2;
            END IF;
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
            IF (NewMuxCfg(3) = '1' AND
                 RAM_BusyR = '0') THEN 
               next_state <= acq_b0f;
            ELSIF (NewMuxCfg(3) = '1'
                   AND RAM_BusyR /= '0') THEN 
               next_state <= acq_b0e;
            ELSE
               next_state <= acq_b0g;
            END IF;
         WHEN acq_b0a => 
            IF (CurMuxCfg(3) = '0') THEN 
               next_state <= acq_b0d;
            ELSIF (RAM_BusyW = '1') THEN 
               next_state <= acq_b0b;
            ELSE
               next_state <= acq_b0c;
            END IF;
         WHEN acq_b0h => 
            IF (RAM_BusyR /='0' OR
                 RAM_BusyW /= '0') THEN 
               next_state <= acq_b0i;
            ELSE
               next_state <= acq_b1a;
            END IF;
         WHEN acq_b1a => 
            IF (CurMuxCfg(3) = '0') THEN 
               next_state <= acq_b1d;
            ELSIF (RAM_BusyW = '1') THEN 
               next_state <= acq_b1b;
            ELSE
               next_state <= acq_b1c;
            END IF;
         WHEN acq_b1e => 
            IF (NewMuxCfg(3) = '1' AND
                 RAM_BusyR = '0') THEN 
               next_state <= acq_b1f;
            ELSIF (NewMuxCfg(3) = '1'
                   AND RAM_BusyR /= '0') THEN 
               next_state <= acq_b1e;
            ELSE
               next_state <= acq_b1g;
            END IF;
         WHEN acq_b1f => 
            next_state <= acq_b1g;
         WHEN acq_b1g => 
            next_state <= acq_b1h;
         WHEN acq_b0b => 
            IF (RAM_BusyW = '0') THEN 
               next_state <= acq_b0c;
            ELSE
               next_state <= acq_b0b;
            END IF;
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
            ELSIF (XtraSettle = '1') THEN 
               next_state <= acq_settle1;
               csm_to_acq_settle1 <= '1';
            ELSE
               next_state <= acq_settle;
               csm_to_acq_settle <= '1';
            END IF;
         WHEN acq_settle1 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_settle;
               csm_to_acq_settle <= '1';
            ELSE
               next_state <= acq_settle1;
            END IF;
         WHEN acq_row => 
            next_state <= acq_loop;
         WHEN acq_b0c => 
            next_state <= acq_b0d;
         WHEN acq_b0f => 
            next_state <= acq_b0g;
         WHEN acq_b1b => 
            IF (RAM_BusyW = '0') THEN 
               next_state <= acq_b1c;
            ELSE
               next_state <= acq_b1b;
            END IF;
         WHEN acq_rst => 
            next_state <= acq_init_row;
         WHEN acq_3 => 
            IF (RAM_BusyR /='0' OR
                 RAM_BusyW /= '0') THEN 
               next_state <= acq_2;
            ELSE
               next_state <= acq_b0a;
            END IF;
         WHEN acq_b0i => 
            IF (RAM_BusyR ='0' AND
                 RAM_BusyW = '0') THEN 
               next_state <= acq_b1a;
            ELSE
               next_state <= acq_b0i;
            END IF;
         WHEN acq_b0d => 
            next_state <= acq_b0e;
         WHEN acq_b0g => 
            next_state <= acq_b0h;
         WHEN acq_b1d => 
            next_state <= acq_b1e;
         WHEN acq_b1h => 
            next_state <= acq_col_end;
         WHEN acq_dbl => 
            IF (DblConv = "00" OR
                (DblConv = "01" AND
                RowU(2 DOWNTO 0) /= "000")) THEN 
               next_state <= acq_start;
            ELSE
               next_state <= acq_dbl2;
               csm_to_acq_dbl2 <= '1';
            END IF;
         WHEN acq_idle2 => 
            IF (csm_timeout = '1' AND (SDI = "00"
                 AND AIEn = '1')) THEN 
               next_state <= acq_conv2;
               csm_to_acq_conv2 <= '1';
            ELSIF (csm_timeout = '1') THEN 
               next_state <= acq_idle2;
            ELSE
               next_state <= acq_idle2;
            END IF;
         WHEN acq_conv2 => 
            IF (RdyIn = "1111"
                AND SDI = "11") THEN 
               next_state <= acq_start;
            ELSIF (csm_timeout = '1') THEN 
               next_state <= acq_idle2;
               csm_to_acq_idle2 <= '1';
            ELSE
               next_state <= acq_conv2;
            END IF;
         WHEN acq_dbl2 => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_idle2;
               csm_to_acq_idle2 <= '1';
            END IF;
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
      XtraSettle <= AICtrl(9);

      -- Combined Actions
      CASE current_state IS
         WHEN acq_init_row => 
            NStat <= X"1";
         WHEN acq_idle => 
            NStat <= X"2";
         WHEN acq_start => 
            NStat <= X"4";
         WHEN acq_1 => 
            NStat <= X"6";
         WHEN acq_2 => 
            NStat <= X"7";
         WHEN acq_loop => 
            NStat <= X"5";
         WHEN acq_conv => 
            NStat <= X"3";
         WHEN acq_b0e => 
            NStat <= X"9";
         WHEN acq_b1e => 
            NStat <= X"C";
         WHEN acq_b0b => 
            NStat <= X"8";
         WHEN acq_b1b => 
            NStat <= X"B";
         WHEN acq_b0i => 
            NStat <= X"A";
         WHEN acq_idle2 => 
            NStat <= X"2";
         WHEN acq_conv2 => 
            NStat <= X"3";
         WHEN OTHERS =>
            NULL;
      END CASE;
   END PROCESS output_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_acq_idle,
      csm_to_acq_conv,
      csm_to_acq_settle,
      csm_to_acq_settle1,
      csm_to_acq_idle2,
      csm_to_acq_conv2,
      csm_to_acq_dbl2
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
         csm_next_timer <= "000000000001001"; -- no cycles(10)-1=9
      ELSIF (csm_to_acq_conv = '1') THEN
         csm_next_timer <= "000000001100011"; -- no cycles(100)-1=99
      ELSIF (csm_to_acq_settle = '1') THEN
         csm_next_timer <= "000111010100101"; -- no cycles(3750)-1=3749
      ELSIF (csm_to_acq_settle1 = '1') THEN
         csm_next_timer <= "101001100000001"; -- no cycles(21250)-1=21249
      ELSIF (csm_to_acq_idle2 = '1') THEN
         csm_next_timer <= "000000000001001"; -- no cycles(10)-1=9
      ELSIF (csm_to_acq_conv2 = '1') THEN
         csm_next_timer <= "000000001100011"; -- no cycles(100)-1=99
      ELSIF (csm_to_acq_dbl2 = '1') THEN
         csm_next_timer <= "000111110011111"; -- no cycles(4000)-1=3999
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
   RdyOut <= RdyOut_cld;
   Restart <= Restart_cld;
   S5WE <= S5WE_cld;
   Start <= Start_cld;
   WR_Addr <= WR_Addr_cld;
   WrEn <= WrEn_cld;
   Status_int(1 downto 0) <= TOStat;
   Status_int(2) <= Start_cld;
   Status_int(3) <= Restart_cld;
   Status_int(7 downto 4) <= NStat;
   Status_int(11 downto 8) <= RdyIn;
END fsm;
