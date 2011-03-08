-- VHDL Entity idx_fpga_lib.ana_acquire.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:29:16 03/ 8/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ana_acquire IS
   PORT( 
      AIEn      : IN     std_ulogic;
      CLK       : IN     std_ulogic;
      CurMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
      NewMuxCfg : IN     std_logic_vector (3 DOWNTO 0);
      RAM_BUSY  : IN     std_ulogic;
      RST       : IN     std_ulogic;
      RdyIn     : IN     std_ulogic;
      SDI       : IN     std_ulogic_vector (1 DOWNTO 0);
      CS5       : OUT    std_ulogic;
      Col_Addr  : OUT    std_logic_vector (3 DOWNTO 0);
      Conv      : OUT    std_ulogic;
      NxtRow    : OUT    std_ulogic_vector (5 DOWNTO 0);
      RD_Addr   : OUT    std_logic_vector (7 DOWNTO 0);
      RdEn      : OUT    std_ulogic;
      RdyOut    : OUT    std_ulogic;
      S5WE      : OUT    std_ulogic_vector (1 DOWNTO 0);
      Start     : OUT    std_ulogic;
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
--          at - 11:29:16 03/ 8/2011
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
   
   function permute(
     row : in std_logic_vector(5 DOWNTO 0);
     bank : in std_logic_vector(0 DOWNTO 0);
     col : in std_logic_vector(2 DOWNTO 0) 
   ) return std_logic_vector is
       Variable permute : unsigned(5 DOWNTO 0);
       Variable mapped : unsigned(5 DOWNTO 0);
   begin
     permute(2 DOWNTO 0) := unsigned(not col);
     permute(5 DOWNTO 3) := unsigned(row(2 DOWNTO 0));
     mapped := permute + 2;
     return '0' &std_logic_vector( mapped(5 DOWNTO 3)) &
       bank & std_logic_vector(not std_logic_vector(mapped(2 DOWNTO 0)));
   end permute;
   SIGNAL Col : std_logic_vector(2 DOWNTO 0);  
   SIGNAL RowN : std_logic_vector(5 DOWNTO 0);  
   SIGNAL RowU : std_logic_vector(5 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      acq_init,
      acq_idle,
      acq_start,
      acq_1,
      acq_2,
      acq_14,
      acq_1a,
      acq_end,
      acq_conv,
      acq_6,
      acq_5,
      acq_7,
      acq_8,
      acq_9,
      acq_10,
      acq_11,
      acq_12,
      acq_13,
      acq_5a,
      acq_9a,
      acq_settle,
      acq_busy1,
      acq_busy2
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare Wait State internal signals
   SIGNAL csm_timer : std_logic_vector(8 DOWNTO 0);
   SIGNAL csm_next_timer : std_logic_vector(8 DOWNTO 0);
   SIGNAL csm_timeout : std_logic;
   SIGNAL csm_to_acq_idle : std_logic;
   SIGNAL csm_to_acq_settle : std_logic;

   -- Declare any pre-registered internal signals
   SIGNAL CS5_cld : std_ulogic ;
   SIGNAL Col_Addr_cld : std_logic_vector (3 DOWNTO 0);
   SIGNAL Conv_cld : std_ulogic ;
   SIGNAL NxtRow_cld : std_ulogic_vector (5 DOWNTO 0);
   SIGNAL RD_Addr_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL RdEn_cld : std_ulogic ;
   SIGNAL RdyOut_cld : std_ulogic ;
   SIGNAL S5WE_cld : std_ulogic_vector (1 DOWNTO 0);
   SIGNAL Start_cld : std_ulogic ;
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
            current_state <= acq_init;
            csm_timer <= (OTHERS => '0');
            -- Default Reset Values
            CS5_cld <= '1';
            Col_Addr_cld <= (others => '0');
            Conv_cld <= '0';
            NxtRow_cld <= (others => '0');
            RD_Addr_cld <= (others => '0');
            RdEn_cld <= '0';
            RdyOut_cld <= '1';
            S5WE_cld <= (others => '0');
            Start_cld <= '0';
            WR_Addr_cld <= (others => '0');
            WrEn_cld <= '0';
            Col <= (others => '1');
            RowN <= "000001";
            RowU <= (others => '0');
         ELSE
            current_state <= next_state;
            csm_timer <= csm_next_timer;

            -- Combined Actions
            CASE current_state IS
               WHEN acq_init => 
                  Conv_cld <= '0';
               WHEN acq_idle => 
                  IF (csm_timeout = '1' AND (SDI = "00" AND AIEn = '1')) THEN 
                     Conv_cld <= '1' ;
                  END IF;
               WHEN acq_start => 
                  IF (RdyIn = '0') THEN 
                     Start_cld <= '0';
                     NxtRow_cld <=
                      std_ulogic_vector(RowN);
                  END IF;
               WHEN acq_1 => 
                  IF (RdyIn = '1') THEN 
                     Start_cld <= '1';
                  END IF;
               WHEN acq_2 => 
                  Start_cld <= '0';
                  Col_Addr_cld <=
                     '0' & Col;
                  WR_Addr_cld <=
                   mkaddr(RowU,"0",Col);
               WHEN acq_14 => 
                  IF (Col = 7) THEN 
                     RowU <= RowN;
                     CS5_cld <= '1';
                  END IF;
               WHEN acq_end => 
                  Conv_cld <= '0';
               WHEN acq_conv => 
                  IF (RdyIn = '1' AND SDI = "11") THEN 
                     Start_cld <= '1' ;
                     CS5_cld <= '0';
                     RdyOut_cld <= '0';
                     RowN <= RowU+1;
                  END IF;
               WHEN acq_6 => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
                  Col_Addr_cld <= '1' & Col;
               WHEN acq_5 => 
                  RD_Addr_cld <=
                     permute(RowN,"0",Col);
                  WrEn_cld <= '1';
                  RdEn_cld <= '1';
               WHEN acq_7 => 
                  WrEn_cld <= '0';
                  IF (NewMuxCfg(3) = '1'
                      AND RAM_BUSY /= '0') THEN 
                  ELSIF (NewMuxCfg(3) = '1' AND RAM_BUSY = '0') THEN 
                     RD_Addr_cld <=
                       muxaddr(NewMuxCfg,"0",RowN);
                     RdEn_cld <= '1';
                  ELSIF (NewMuxCfg(3) /= '1') THEN 
                     S5WE_cld(0) <= '1';
                     WR_Addr_cld <=
                       mkaddr(RowU,"1",Col);
                  END IF;
               WHEN acq_8 => 
                  S5WE_cld(0) <= '1';
                  RdEn_cld <= '0';
                  WR_Addr_cld <=
                    mkaddr(RowU,"1",Col);
               WHEN acq_9 => 
                  S5WE_cld(0) <= '0';
                  RD_Addr_cld <=
                    permute(RowN,"1",Col);
                  IF (RAM_BUSY /= '0') THEN 
                  ELSIF (CurMuxCfg(3) = '0' AND RAM_BUSY = '0') THEN 
                     WrEn_cld <= '1';
                     RdEn_cld <= '1';
                  ELSIF (CurMuxCfg(3) /= '0' AND RAM_BUSY = '0') THEN 
                     WrEn_cld <= '1';
                     RdEn_cld <= '1';
                  END IF;
               WHEN acq_10 => 
                  WrEn_cld <= '0';
                  RdEn_cld <= '0';
               WHEN acq_11 => 
                  WrEn_cld <= '0';
                  IF (NewMuxCfg(3) = '1'
                      AND RAM_BUSY /= '0') THEN 
                  ELSIF (NewMuxCfg(3) = '1' AND RAM_BUSY = '0') THEN 
                     RD_Addr_cld <=
                       muxaddr(NewMuxCfg,"1",RowN);
                     RdEn_cld <= '1';
                  ELSIF (NewMuxCfg(3) /= '1') THEN 
                     S5WE_cld(1) <= '1';
                  END IF;
               WHEN acq_12 => 
                  S5WE_cld(1) <= '1';
                  RdEn_cld <= '0';
               WHEN acq_13 => 
                  S5WE_cld(1) <= '0';
                  Col <= Col-1;
               WHEN acq_5a => 
                  WR_Addr_cld <=
                    muxaddr(CurMuxCfg,"0",RowU);
                  IF (RAM_BUSY /= '0') THEN 
                     WrEn_cld <= '0';
                     RdEn_cld <= '0';
                  ELSE
                     RdEn_cld <= '0';
                  END IF;
               WHEN acq_9a => 
                  WR_Addr_cld <=
                    muxaddr(CurMuxCfg,"1",RowU);
                  IF (RAM_BUSY /= '0') THEN 
                     WrEn_cld <= '0';
                     RdEn_cld <= '0';
                  ELSIF (RAM_BUSY = '0') THEN 
                     RdEn_cld <= '0';
                  END IF;
               WHEN acq_settle => 
                  IF (csm_timeout = '1') THEN 
                     RdyOut_cld <= '1';
                  END IF;
               WHEN acq_busy1 => 
                  IF (RAM_BUSY /= '0') THEN 
                  ELSIF (RAM_BUSY = '0') THEN 
                     WrEn_cld <= '1';
                  END IF;
               WHEN acq_busy2 => 
                  IF (RAM_BUSY /= '0') THEN 
                  ELSIF (RAM_BUSY = '0') THEN 
                     WrEn_cld <= '1';
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
      NewMuxCfg,
      RAM_BUSY,
      RdyIn,
      SDI,
      csm_timeout,
      current_state
   )
   -----------------------------------------------------------------
   BEGIN
      -- Default assignments to Wait State entry flags
      csm_to_acq_idle <= '0';
      csm_to_acq_settle <= '0';
      CASE current_state IS
         WHEN acq_init => 
            next_state <= acq_idle;
            csm_to_acq_idle <= '1';
         WHEN acq_idle => 
            IF (csm_timeout = '1' AND (SDI = "00" AND AIEn = '1')) THEN 
               next_state <= acq_conv;
            ELSE
               next_state <= acq_idle;
            END IF;
         WHEN acq_start => 
            IF (RdyIn = '0') THEN 
               next_state <= acq_1;
            ELSE
               next_state <= acq_start;
            END IF;
         WHEN acq_1 => 
            IF (RdyIn = '1') THEN 
               next_state <= acq_2;
            ELSE
               next_state <= acq_1;
            END IF;
         WHEN acq_2 => 
            IF (RAM_BUSY ='0') THEN 
               next_state <= acq_5;
            ELSE
               next_state <= acq_2;
            END IF;
         WHEN acq_14 => 
            IF (Col = 7) THEN 
               next_state <= acq_settle;
               csm_to_acq_settle <= '1';
            ELSIF (Col = 0) THEN 
               next_state <= acq_1a;
            ELSE
               next_state <= acq_1;
            END IF;
         WHEN acq_1a => 
            IF (RdyIn = '1') THEN 
               next_state <= acq_2;
            ELSE
               next_state <= acq_1a;
            END IF;
         WHEN acq_end => 
            next_state <= acq_idle;
            csm_to_acq_idle <= '1';
         WHEN acq_conv => 
            IF (RdyIn = '1' AND SDI = "11") THEN 
               next_state <= acq_start;
            ELSE
               next_state <= acq_conv;
            END IF;
         WHEN acq_6 => 
            next_state <= acq_7;
         WHEN acq_5 => 
            IF (CurMuxCfg(3) = '0') THEN 
               next_state <= acq_6;
            ELSIF (CurMuxCfg(3) /='0') THEN 
               next_state <= acq_5a;
            END IF;
         WHEN acq_7 => 
            IF (NewMuxCfg(3) = '1'
                AND RAM_BUSY /= '0') THEN 
               next_state <= acq_7;
            ELSIF (NewMuxCfg(3) = '1' AND RAM_BUSY = '0') THEN 
               next_state <= acq_8;
            ELSIF (NewMuxCfg(3) /= '1') THEN 
               next_state <= acq_9;
            END IF;
         WHEN acq_8 => 
            next_state <= acq_9;
         WHEN acq_9 => 
            IF (RAM_BUSY /= '0') THEN 
               next_state <= acq_9;
            ELSIF (CurMuxCfg(3) = '0' AND RAM_BUSY = '0') THEN 
               next_state <= acq_10;
            ELSIF (CurMuxCfg(3) /= '0' AND RAM_BUSY = '0') THEN 
               next_state <= acq_9a;
            END IF;
         WHEN acq_10 => 
            next_state <= acq_11;
         WHEN acq_11 => 
            IF (NewMuxCfg(3) = '1'
                AND RAM_BUSY /= '0') THEN 
               next_state <= acq_11;
            ELSIF (NewMuxCfg(3) = '1' AND RAM_BUSY = '0') THEN 
               next_state <= acq_12;
            ELSIF (NewMuxCfg(3) /= '1') THEN 
               next_state <= acq_13;
            END IF;
         WHEN acq_12 => 
            next_state <= acq_13;
         WHEN acq_13 => 
            next_state <= acq_14;
         WHEN acq_5a => 
            IF (RAM_BUSY /= '0') THEN 
               next_state <= acq_busy1;
            ELSE
               next_state <= acq_7;
            END IF;
         WHEN acq_9a => 
            IF (RAM_BUSY /= '0') THEN 
               next_state <= acq_busy2;
            ELSIF (RAM_BUSY = '0') THEN 
               next_state <= acq_11;
            END IF;
         WHEN acq_settle => 
            IF (csm_timeout = '1') THEN 
               next_state <= acq_end;
            ELSE
               next_state <= acq_settle;
            END IF;
         WHEN acq_busy1 => 
            IF (RAM_BUSY /= '0') THEN 
               next_state <= acq_busy1;
            ELSIF (RAM_BUSY = '0') THEN 
               next_state <= acq_7;
            END IF;
         WHEN acq_busy2 => 
            IF (RAM_BUSY /= '0') THEN 
               next_state <= acq_busy2;
            ELSIF (RAM_BUSY = '0') THEN 
               next_state <= acq_11;
            END IF;
         WHEN OTHERS =>
            next_state <= acq_init;
      END CASE;
   END PROCESS nextstate_proc;
 
   -----------------------------------------------------------------
   csm_wait_combo_proc: PROCESS (
      csm_timer,
      csm_to_acq_idle,
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
         csm_next_timer <= "000001001"; -- no cycles(10)-1=9
      ELSIF (csm_to_acq_settle = '1') THEN
         csm_next_timer <= "101110110"; -- no cycles(375)-1=374
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
   S5WE <= S5WE_cld;
   Start <= Start_cld;
   WR_Addr <= WR_Addr_cld;
   WrEn <= WrEn_cld;
END fsm;
