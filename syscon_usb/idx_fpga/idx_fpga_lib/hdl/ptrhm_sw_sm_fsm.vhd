-- VHDL Entity idx_fpga_lib.ptrhm_sw_sm.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:13:15 11/10/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;

ENTITY ptrhm_sw_sm IS
   GENERIC( 
      N_ISBITS    : integer    := 4;
      ESID        : ESID_array := ( 3, 2, 1, 0, 0, 0, 0, 0 );
      ISwitchBit  : ISB_array  := ( 3, 2, 1, 0 );
      ESwitchAddr : ESA_array  := ( "0000000", "0000000", "0000000", "1110000" );
      ESwitchBit  : ESB_array  := ( 0, 0, 0, 4, 3, 2, 1, 0 );
      N_PTRH      : integer    := 8
   );
   PORT( 
      clk       : IN     std_logic;
      done      : IN     std_ulogic;
      err       : IN     std_ulogic;
      i2c_rdata : IN     std_ulogic_vector (23 DOWNTO 0);
      rst       : IN     std_logic;
      sw_addr   : IN     std_ulogic_vector (6 DOWNTO 0);
      sw_cmd    : IN     ptrhm_i2c_op;
      sw_wdata  : IN     std_logic_vector (7 DOWNTO 0);
      ISwitch   : OUT    std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      cmd       : OUT    ptrhm_i2c_op;
      i2c_addr  : OUT    std_ulogic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      sw_done   : OUT    std_ulogic;
      sw_err    : OUT    std_ulogic;
      sw_rdata  : OUT    std_ulogic_vector (23 DOWNTO 0)
   );

-- Declarations

END ptrhm_sw_sm ;

--
-- VHDL Architecture idx_fpga_lib.ptrhm_sw_sm.fsm
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:13:15 11/10/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.All;
 
ARCHITECTURE fsm OF ptrhm_sw_sm IS

   -- Architecture Declarations
   SIGNAL CurESID : std_logic_vector(3 DOWNTO 0);  
   SIGNAL ESwitchMask : std_logic_vector(7 DOWNTO 0);  
   SIGNAL PTRHn : integer RANGE N_PTRH-1 DOWNTO 0;  
   SIGNAL esidn : std_logic_vector(3 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      sw0,
      sw1,
      sw2,
      swcmd,
      sw4,
      sw5,
      sw_w1,
      sa1,
      sa2,
      sa3,
      sa9,
      sa4,
      sa5,
      sa6,
      sa7,
      sa8,
      sa10,
      sa11,
      sa12,
      so1,
      so2,
      so3,
      so4,
      so5,
      so7,
      so6,
      so8,
      so9,
      sw_wr0,
      sw_wr1
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL ISwitch_cld : std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
   SIGNAL cmd_cld : ptrhm_i2c_op ;
   SIGNAL i2c_addr_cld : std_ulogic_vector (6 DOWNTO 0);
   SIGNAL i2c_wdata_cld : std_logic_vector (7 DOWNTO 0);
   SIGNAL sw_done_cld : std_ulogic ;
   SIGNAL sw_err_cld : std_ulogic ;
   SIGNAL sw_rdata_cld : std_ulogic_vector (23 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk
   )
   -----------------------------------------------------------------
   Variable ESwMask : std_logic_vector(7 downto 0);
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (rst = '1') THEN
            current_state <= sw0;
            -- Default Reset Values
            ISwitch_cld <= (others => '0');
            cmd_cld <= Init;
            i2c_addr_cld <= (others => '0');
            i2c_wdata_cld <= (others => '0');
            sw_done_cld <= '0';
            sw_err_cld <= '0';
            sw_rdata_cld <= (others => '0');
            CurESID <= conv_std_logic_vector(ISwitchBit'length,4);
            ESwitchMask <= (others => '0');
            PTRHn <= 0;
            esidn <= X"0";
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN sw0 => 
                  cmd_cld <= Init;
                  sw_done_cld <= '0';
                  sw_err_cld <= '0';
                  ISwitch_cld <= (others => '0');
               WHEN sw1 => 
                  cmd_cld <= NOP;
               WHEN sw2 => 
                  sw_done_cld <= '1';
               WHEN swcmd => 
                  sw_done_cld <= '0';
                  sw_err_cld <= '0';
               WHEN sw4 => 
                  cmd_cld <= NOP;
               WHEN sw5 => 
                  sw_err_cld <= '1';
               WHEN sa1 => 
                  esidn <= X"0";
               WHEN sa9 => 
                  esidn <= esidn+1;
               WHEN sa4 => 
                  ISwitch_cld <=
                    (others => '0');
                  ISwitch_cld(ISwitchBit(conv_integer(esidn))) <= '1';
                  i2c_addr_cld <=
                   ESwitchAddr(conv_integer(esidn));
               WHEN sa5 => 
                  ESwMask := (others => '0');
                    -- for esi in conv_unsigned(ESID'high,4) downto conv_unsigned(0,4) loop
                  for esi in 7 downto 0 loop
                    if ESID(esi) = esidn then
                      ESwMask(ESwitchBit(esi)) := '1';
                    end if;
                  end loop;
                  i2c_wdata_cld <=
                   ESwMask;
               WHEN sa6 => 
                  i2c_wdata_cld <=
                  (others => '0');
               WHEN sa7 => 
                  cmd_cld <= Write;
               WHEN sa8 => 
                  cmd_cld <= NOP;
               WHEN sa11 => 
                  ISwitch_cld <= (others => '1');
               WHEN sa12 => 
                  ISwitch_cld <= (others => '0');
               WHEN so1 => 
                  PTRHn <= conv_integer(sw_wdata);
               WHEN so3 => 
                  i2c_addr_cld <=
                    ESwitchAddr(conv_integer(CurESID));
                  i2c_wdata_cld <= (others => '0');
                  cmd_cld <= Write;
               WHEN so4 => 
                  cmd_cld <= NOP;
               WHEN so5 => 
                  CurESID <=
                    conv_std_logic_vector(ESID(PTRHn),4);
                  ISwitch_cld <= (others => '0');
               WHEN so6 => 
                  ISwitch_cld(ISwitchBit(conv_integer(CurESID))) <= '1';
               WHEN so8 => 
                  ESwitchMask <= (others => '0');
                  ESwitchMask(ESwitchBit(PTRHn))
                     <= '1';
               WHEN so9 => 
                  i2c_addr_cld <=
                    ESwitchAddr(conv_integer(CurESID));
                  i2c_wdata_cld <=
                    ESwitchMask;
                  cmd_cld <= Write;
               WHEN sw_wr0 => 
                  i2c_addr_cld <= sw_addr;
                  i2c_wdata_cld <= sw_wdata;
                  cmd_cld <= sw_cmd;
               WHEN sw_wr1 => 
                  sw_rdata_cld <= i2c_rdata;
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      CurESID,
      PTRHn,
      current_state,
      done,
      err,
      esidn,
      sw_cmd,
      sw_wdata
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN sw0 => 
            IF (done = '1'
                  OR
                err = '1') THEN 
               next_state <= sw_w1;
            ELSE
               next_state <= sw0;
            END IF;
         WHEN sw1 => 
            IF (done = '0' AND
                err = '0') THEN 
               next_state <= sw2;
            ELSE
               next_state <= sw1;
            END IF;
         WHEN sw2 => 
            IF (sw_cmd = NOP) THEN 
               next_state <= swcmd;
            ELSE
               next_state <= sw2;
            END IF;
         WHEN swcmd => 
            IF (sw_cmd = SelectAll OR
                sw_cmd = DeselectAll) THEN 
               next_state <= sa1;
            ELSIF (sw_cmd = SelectOne AND
                   sw_wdata < N_PTRH) THEN 
               next_state <= so1;
            ELSIF (sw_cmd = Write OR
                   sw_cmd = WriteRead2 OR
                   sw_cmd = WriteRead3) THEN 
               next_state <= sw_wr0;
            ELSIF (sw_cmd = NOP) THEN 
               next_state <= swcmd;
            ELSE
               next_state <= sw5;
            END IF;
         WHEN sw4 => 
            IF (done = '0' AND
                err = '0') THEN 
               next_state <= sw5;
            ELSE
               next_state <= sw4;
            END IF;
         WHEN sw5 => 
            IF (sw_cmd = NOP) THEN 
               next_state <= swcmd;
            ELSE
               next_state <= sw5;
            END IF;
         WHEN sw_w1 => 
            IF (err = '1') THEN 
               next_state <= sw4;
            ELSE
               next_state <= sw1;
            END IF;
         WHEN sa1 => 
            next_state <= sa2;
         WHEN sa2 => 
            IF (esidn <=
                ESwitchAddr'high) THEN 
               next_state <= sa3;
            ELSE
               next_state <= sa10;
            END IF;
         WHEN sa3 => 
            IF (ESwitchAddr(conv_integer(esidn)) /=
                 "0000000") THEN 
               next_state <= sa4;
            ELSE
               next_state <= sa9;
            END IF;
         WHEN sa9 => 
            next_state <= sa2;
         WHEN sa4 => 
            IF (sw_cmd = SelectAll) THEN 
               next_state <= sa5;
            ELSE
               next_state <= sa6;
            END IF;
         WHEN sa5 => 
            next_state <= sa7;
         WHEN sa6 => 
            next_state <= sa7;
         WHEN sa7 => 
            IF (done = '1') THEN 
               next_state <= sa8;
            ELSE
               next_state <= sa7;
            END IF;
         WHEN sa8 => 
            IF (done = '0') THEN 
               next_state <= sa9;
            ELSE
               next_state <= sa8;
            END IF;
         WHEN sa10 => 
            IF (sw_cmd = SelectAll) THEN 
               next_state <= sa11;
            ELSE
               next_state <= sa12;
            END IF;
         WHEN sa11 => 
            next_state <= sw_w1;
         WHEN sa12 => 
            next_state <= sw_w1;
         WHEN so1 => 
            IF (CurESID /=
                 conv_std_logic_vector(
                   ESID(PTRHn),
                   4)) THEN 
               next_state <= so2;
            ELSE
               next_state <= so7;
            END IF;
         WHEN so2 => 
            IF (CurESID /= ISwitchBit'length AND
                ESwitchAddr(conv_integer(CurESID)) /=
                   "0000000") THEN 
               next_state <= so3;
            ELSE
               next_state <= so5;
            END IF;
         WHEN so3 => 
            IF (done = '1') THEN 
               next_state <= so4;
            ELSIF (err = '1') THEN 
               next_state <= sw_w1;
            ELSE
               next_state <= so3;
            END IF;
         WHEN so4 => 
            IF (done = '0'
                  AND
                err = '0') THEN 
               next_state <= so5;
            ELSE
               next_state <= so4;
            END IF;
         WHEN so5 => 
            next_state <= so6;
         WHEN so7 => 
            IF (ESwitchAddr(conv_integer(CurESID)) /=
                  "0000000") THEN 
               next_state <= so8;
            ELSE
               next_state <= sw_w1;
            END IF;
         WHEN so6 => 
            next_state <= so7;
         WHEN so8 => 
            next_state <= so9;
         WHEN so9 => 
            IF (done = '1'
                  OR
                err = '1') THEN 
               next_state <= sw_w1;
            ELSE
               next_state <= so9;
            END IF;
         WHEN sw_wr0 => 
            IF (done = '1'
                  OR
                err = '1') THEN 
               next_state <= sw_wr1;
            ELSE
               next_state <= sw_wr0;
            END IF;
         WHEN sw_wr1 => 
            next_state <= sw_w1;
         WHEN OTHERS =>
            next_state <= sw0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   ISwitch <= ISwitch_cld;
   cmd <= cmd_cld;
   i2c_addr <= i2c_addr_cld;
   i2c_wdata <= i2c_wdata_cld;
   sw_done <= sw_done_cld;
   sw_err <= sw_err_cld;
   sw_rdata <= sw_rdata_cld;
END fsm;
