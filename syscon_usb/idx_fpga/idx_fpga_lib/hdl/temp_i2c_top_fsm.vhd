-- VHDL Entity idx_fpga_lib.temp_i2c_top.interface
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 20:20:45 05/07/15
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

ENTITY temp_i2c_top IS
   PORT( 
      ack       : IN     std_logic;
      clk_8M    : IN     std_logic;
      done      : IN     std_logic;
      err       : IN     std_logic;
      rd_data   : IN     std_logic_vector (31 DOWNTO 0);
      rst       : IN     std_logic;
      adc_addr  : OUT    std_logic_vector (6 DOWNTO 0);
      brd_num   : OUT    std_logic_vector (2 DOWNTO 0);
      rd_cmd    : OUT    std_logic;
      rd_data_o : OUT    std_logic_vector (31 DOWNTO 0);
      rdy       : OUT    std_logic;
      wr_cmd    : OUT    std_logic;
      wr_data   : OUT    std_logic_vector (7 DOWNTO 0)
   );

-- Declarations

END temp_i2c_top ;

--
-- VHDL Architecture idx_fpga_lib.temp_i2c_top.fsm
--
-- Created:
--          by - nort.Domain Users (NORT-XPS14)
--          at - 20:20:11 05/07/15
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1b (Build 2)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.STD_LOGIC_UNSIGNED.ALL;
 
ARCHITECTURE fsm OF temp_i2c_top IS

   -- Architecture Declarations
   SIGNAL rd_count : std_logic_vector(10 DOWNTO 0);  
   SIGNAL resp : std_logic_vector(5 DOWNTO 0);  

   TYPE STATE_TYPE IS (
      top_init0,
      top_rd0,
      top_conf0,
      top_init1,
      top_conf_wait0,
      top_conf1,
      top_conf_wait1,
      top_conf2,
      top_conf_wait2,
      top_conf3,
      top_conf_wait3,
      top_conf4,
      top_conf_wait4,
      top_conf5,
      top_conf_wait5,
      top_init2,
      top_rc1,
      top_rd2,
      top_rd_count,
      top_rd3,
      top_rd_nonr1,
      top_rc2,
      top_rd5,
      top_rd6,
      top_rc3,
      top_rd8,
      top_rd_nonr2,
      top_rd9,
      top_rd_nonr3,
      top_rc4,
      top_rd7,
      top_rd_nonr4,
      top_rd10,
      top_rc5,
      top_rd11,
      top_rd12,
      top_rd_nonr5,
      top_rc6,
      top_rd13,
      top_rd14,
      top_rd_nonr6,
      top_rd_count1,
      top_rd_count2,
      top_rd_count3,
      top_rd_count4,
      top_rd_count5,
      s0,
      s1,
      s2,
      s3,
      s4,
      s5
   );
 
   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE;
   SIGNAL next_state : STATE_TYPE;

   -- Declare any pre-registered internal signals
   SIGNAL adc_addr_cld : std_logic_vector (6 DOWNTO 0);
   SIGNAL brd_num_cld : std_logic_vector (2 DOWNTO 0);
   SIGNAL rd_cmd_cld : std_logic ;
   SIGNAL rd_data_o_cld : std_logic_vector (31 DOWNTO 0);
   SIGNAL rdy_cld : std_logic ;
   SIGNAL wr_cmd_cld : std_logic ;
   SIGNAL wr_data_cld : std_logic_vector (7 DOWNTO 0);

BEGIN

   -----------------------------------------------------------------
   clocked_proc : PROCESS ( 
      clk_8M
   )
   -----------------------------------------------------------------
   BEGIN
      IF (clk_8M'EVENT AND clk_8M = '1') THEN
         IF (rst = '1') THEN
            current_state <= top_init0;
            -- Default Reset Values
            adc_addr_cld <= (others => '0');
            brd_num_cld <= (others => '0');
            rd_cmd_cld <= '0';
            rd_data_o_cld <= (others => '0');
            rdy_cld <= '0';
            wr_cmd_cld <= '0';
            wr_data_cld <= (others => '0');
            rd_count <= (others => '0');
            resp <= (others => '0');
         ELSE
            current_state <= next_state;

            -- Combined Actions
            CASE current_state IS
               WHEN top_init0 => 
                  wr_data_cld <= (others => '0');
                  adc_addr_cld <= (others => '0');
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_rd0 => 
                  rd_count <= "11111111111";
               WHEN top_conf0 => 
                  adc_addr_cld <= "0010100";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_init1 => 
                  brd_num_cld <= (others => '0');
                  rd_data_o_cld <= (others => '0');
                  rdy_cld <= '0';
               WHEN top_conf_wait0 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_conf1 => 
                  adc_addr_cld <= "0010101";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_conf_wait1 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_conf2 => 
                  adc_addr_cld <= "0010111";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_conf_wait2 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_conf3 => 
                  adc_addr_cld <= "0100100";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_conf_wait3 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_conf4 => 
                  adc_addr_cld <= "0100110";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_conf_wait4 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_conf5 => 
                  adc_addr_cld <= "0100111";
                  wr_cmd_cld <= '1';
                  rd_cmd_cld <= '0';
                  wr_data_cld <= "00000100";
               WHEN top_conf_wait5 => 
                  wr_cmd_cld <= '0';
                  rd_cmd_cld <= '0';
               WHEN top_init2 => 
                  resp <= (others => '0');
               WHEN top_rc1 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd2 => 
                  adc_addr_cld <= "0010100";
                  rd_cmd_cld <= '1';
                  IF (err = '1'
                      AND
                      rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd_count => 
                  rd_cmd_cld <= '0';
               WHEN top_rd3 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "001";
                  rdy_cld <= '1';
               WHEN top_rd_nonr1 => 
                  resp(0) <= '0';
               WHEN top_rc2 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd5 => 
                  adc_addr_cld <= "0010101";
                  rd_cmd_cld <= '1';
                  IF (err = '1' AND
                      rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd6 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "010";
                  rdy_cld <= '1';
               WHEN top_rc3 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd8 => 
                  adc_addr_cld <= "0010111";
                  rd_cmd_cld <= '1';
                  IF (err = '1' AND
                      rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd_nonr2 => 
                  resp(1) <= '0';
               WHEN top_rd9 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "011";
                  rdy_cld <= '1';
               WHEN top_rd_nonr3 => 
                  resp(2) <= '0';
               WHEN top_rc4 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd7 => 
                  adc_addr_cld <= "0100100";
                  rd_cmd_cld <= '1';
                  IF (done = '1') THEN 
                  ELSIF (err = '1' AND
                         rd_count = "00000000000") THEN 
                  ELSIF (err = '1' AND
                         rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd_nonr4 => 
                  resp(3) <= '0';
               WHEN top_rd10 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "100";
                  rdy_cld <= '1';
               WHEN top_rc5 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd11 => 
                  adc_addr_cld <= "0100110";
                  rd_cmd_cld <= '1';
                  IF (done = '1') THEN 
                  ELSIF (err = '1' AND
                         rd_count = "00000000000") THEN 
                  ELSIF (err = '1' AND
                         rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd12 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "101";
                  rdy_cld <= '1';
               WHEN top_rd_nonr5 => 
                  resp(4) <= '0';
               WHEN top_rc6 => 
                  rd_cmd_cld <= '0';
                  wr_cmd_cld <= '0';
                  rdy_cld <= '0';
               WHEN top_rd13 => 
                  adc_addr_cld <= "0100111";
                  rd_cmd_cld <= '1';
                  IF (done = '1') THEN 
                  ELSIF (err = '1' AND
                         rd_count = "00000000000") THEN 
                  ELSIF (err = '1' AND
                         rd_count > "00000000000") THEN 
                     rd_count <= rd_count - 1;
                  END IF;
               WHEN top_rd14 => 
                  rd_data_o_cld <= rd_data;
                  brd_num_cld <= "110";
                  rdy_cld <= '1';
               WHEN top_rd_nonr6 => 
                  resp(5) <= '0';
               WHEN top_rd_count1 => 
                  rd_cmd_cld <= '0';
               WHEN top_rd_count2 => 
                  rd_cmd_cld <= '0';
               WHEN top_rd_count3 => 
                  rd_cmd_cld <= '0';
               WHEN top_rd_count4 => 
                  rd_cmd_cld <= '0';
               WHEN top_rd_count5 => 
                  rd_cmd_cld <= '0';
               WHEN s0 => 
                  resp(0) <= '1';
               WHEN s1 => 
                  resp(1) <= '1';
               WHEN s2 => 
                  resp(2) <= '1';
               WHEN s3 => 
                  resp(3) <= '1';
               WHEN s4 => 
                  resp(4) <= '1';
               WHEN s5 => 
                  resp(5) <= '1';
               WHEN OTHERS =>
                  NULL;
            END CASE;
         END IF;
      END IF;
   END PROCESS clocked_proc;
 
   -----------------------------------------------------------------
   nextstate_proc : PROCESS ( 
      ack,
      current_state,
      done,
      err,
      rd_count,
      resp
   )
   -----------------------------------------------------------------
   BEGIN
      CASE current_state IS
         WHEN top_init0 => 
            next_state <= top_init1;
         WHEN top_rd0 => 
            next_state <= top_rc1;
         WHEN top_conf0 => 
            IF (done = '1') THEN 
               next_state <= s0;
            ELSIF (err = '1') THEN 
               next_state <= top_conf_wait0;
            ELSE
               next_state <= top_conf0;
            END IF;
         WHEN top_init1 => 
            next_state <= top_init2;
         WHEN top_conf_wait0 => 
            IF (resp(1) = '0'
                AND
                done = '0'
                AND
                err = '0') THEN 
               next_state <= top_conf1;
            ELSIF (resp(1) /= '0') THEN 
               next_state <= top_conf_wait1;
            ELSE
               next_state <= top_conf_wait0;
            END IF;
         WHEN top_conf1 => 
            IF (done = '1') THEN 
               next_state <= s1;
            ELSIF (err = '1') THEN 
               next_state <= top_conf_wait1;
            ELSE
               next_state <= top_conf1;
            END IF;
         WHEN top_conf_wait1 => 
            IF (resp(2) = '0'
                AND
                done = '0'
                AND
                err = '0') THEN 
               next_state <= top_conf2;
            ELSIF (resp(2) /= '0') THEN 
               next_state <= top_conf_wait2;
            ELSE
               next_state <= top_conf_wait1;
            END IF;
         WHEN top_conf2 => 
            IF (err = '1') THEN 
               next_state <= top_conf_wait2;
            ELSIF (done = '1') THEN 
               next_state <= s2;
            ELSE
               next_state <= top_conf2;
            END IF;
         WHEN top_conf_wait2 => 
            IF (resp(3) = '0'
                AND
                done = '0'
                AND
                err = '0') THEN 
               next_state <= top_conf3;
            ELSIF (resp(3) /= '0') THEN 
               next_state <= top_conf_wait3;
            ELSE
               next_state <= top_conf_wait2;
            END IF;
         WHEN top_conf3 => 
            IF (err = '1') THEN 
               next_state <= top_conf_wait3;
            ELSIF (done = '1') THEN 
               next_state <= s3;
            ELSE
               next_state <= top_conf3;
            END IF;
         WHEN top_conf_wait3 => 
            IF (resp(4) = '0'
                AND
                done = '0'
                AND
                err = '0') THEN 
               next_state <= top_conf4;
            ELSIF (resp(4) /= '0') THEN 
               next_state <= top_conf_wait4;
            ELSE
               next_state <= top_conf_wait3;
            END IF;
         WHEN top_conf4 => 
            IF (err = '1') THEN 
               next_state <= top_conf_wait4;
            ELSIF (done = '1') THEN 
               next_state <= s4;
            ELSE
               next_state <= top_conf4;
            END IF;
         WHEN top_conf_wait4 => 
            IF (resp(5) = '0'
                AND
                done = '0'
                AND
                err = '0') THEN 
               next_state <= top_conf5;
            ELSIF (resp(5) /= '0') THEN 
               next_state <= top_conf_wait5;
            ELSE
               next_state <= top_conf_wait4;
            END IF;
         WHEN top_conf5 => 
            IF (err = '1') THEN 
               next_state <= top_conf_wait5;
            ELSIF (done = '1') THEN 
               next_state <= s5;
            ELSE
               next_state <= top_conf5;
            END IF;
         WHEN top_conf_wait5 => 
            IF (done = '0'
                AND
                err = '0') THEN 
               next_state <= top_rd0;
            ELSE
               next_state <= top_conf_wait5;
            END IF;
         WHEN top_init2 => 
            IF ((err = '0'
                AND
                done = '0') AND (resp(0) = '0')) THEN 
               next_state <= top_conf0;
            ELSIF ((err = '0'
                   AND
                   done = '0') AND (resp(0) /= '0')) THEN 
               next_state <= top_conf_wait0;
            ELSE
               next_state <= top_init2;
            END IF;
         WHEN top_rc1 => 
            IF (resp(0) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd2;
            ELSIF (resp(0) = '0') THEN 
               next_state <= top_rc2;
            ELSE
               next_state <= top_rc1;
            END IF;
         WHEN top_rd2 => 
            IF (err = '1'
                AND
                rd_count > "00000000000") THEN 
               next_state <= top_rd_count;
            ELSIF (done = '1') THEN 
               next_state <= top_rd3;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr1;
            ELSE
               next_state <= top_rd2;
            END IF;
         WHEN top_rd_count => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd2;
            ELSE
               next_state <= top_rd_count;
            END IF;
         WHEN top_rd3 => 
            IF (ack = '1') THEN 
               next_state <= top_rc2;
            ELSE
               next_state <= top_rd3;
            END IF;
         WHEN top_rd_nonr1 => 
            next_state <= top_rc2;
         WHEN top_rc2 => 
            IF (resp(1) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd5;
            ELSIF (resp(1) = '0') THEN 
               next_state <= top_rc3;
            ELSE
               next_state <= top_rc2;
            END IF;
         WHEN top_rd5 => 
            IF (err = '1' AND
                rd_count > "00000000000") THEN 
               next_state <= top_rd_count1;
            ELSIF (done = '1') THEN 
               next_state <= top_rd6;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr2;
            ELSE
               next_state <= top_rd5;
            END IF;
         WHEN top_rd6 => 
            IF (ack = '1') THEN 
               next_state <= top_rc3;
            ELSE
               next_state <= top_rd6;
            END IF;
         WHEN top_rc3 => 
            IF (resp(2) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd8;
            ELSIF (resp(2) = '0') THEN 
               next_state <= top_rc4;
            ELSE
               next_state <= top_rc3;
            END IF;
         WHEN top_rd8 => 
            IF (err = '1' AND
                rd_count > "00000000000") THEN 
               next_state <= top_rd_count2;
            ELSIF (done = '1') THEN 
               next_state <= top_rd9;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr3;
            ELSE
               next_state <= top_rd8;
            END IF;
         WHEN top_rd_nonr2 => 
            next_state <= top_rc3;
         WHEN top_rd9 => 
            IF (ack = '1') THEN 
               next_state <= top_rc4;
            ELSE
               next_state <= top_rd9;
            END IF;
         WHEN top_rd_nonr3 => 
            next_state <= top_rc4;
         WHEN top_rc4 => 
            IF (resp(3) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd7;
            ELSIF (resp(3) = '0') THEN 
               next_state <= top_rc5;
            ELSE
               next_state <= top_rc4;
            END IF;
         WHEN top_rd7 => 
            IF (done = '1') THEN 
               next_state <= top_rd10;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr4;
            ELSIF (err = '1' AND
                   rd_count > "00000000000") THEN 
               next_state <= top_rd_count3;
            ELSE
               next_state <= top_rd7;
            END IF;
         WHEN top_rd_nonr4 => 
            next_state <= top_rc5;
         WHEN top_rd10 => 
            IF (ack = '1') THEN 
               next_state <= top_rc5;
            ELSE
               next_state <= top_rd10;
            END IF;
         WHEN top_rc5 => 
            IF (resp(4) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd11;
            ELSIF (resp(4) = '0') THEN 
               next_state <= top_rc6;
            ELSE
               next_state <= top_rc5;
            END IF;
         WHEN top_rd11 => 
            IF (done = '1') THEN 
               next_state <= top_rd12;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr5;
            ELSIF (err = '1' AND
                   rd_count > "00000000000") THEN 
               next_state <= top_rd_count4;
            ELSE
               next_state <= top_rd11;
            END IF;
         WHEN top_rd12 => 
            IF (ack = '1') THEN 
               next_state <= top_rc6;
            ELSE
               next_state <= top_rd12;
            END IF;
         WHEN top_rd_nonr5 => 
            next_state <= top_rc6;
         WHEN top_rc6 => 
            IF (resp(5) /= '0' 
                AND 
                done = '0' AND err = '0') THEN 
               next_state <= top_rd13;
            ELSIF ((resp(5) = '0') AND (resp = "000000") AND (resp(0) = '0')) THEN 
               next_state <= top_conf0;
            ELSIF ((resp(5) = '0') AND (resp = "000000") AND (resp(0) /= '0')) THEN 
               next_state <= top_conf_wait0;
            ELSIF (resp(5) = '0') THEN 
               next_state <= top_rd0;
            ELSE
               next_state <= top_rc6;
            END IF;
         WHEN top_rd13 => 
            IF (done = '1') THEN 
               next_state <= top_rd14;
            ELSIF (err = '1' AND
                   rd_count = "00000000000") THEN 
               next_state <= top_rd_nonr6;
            ELSIF (err = '1' AND
                   rd_count > "00000000000") THEN 
               next_state <= top_rd_count5;
            ELSE
               next_state <= top_rd13;
            END IF;
         WHEN top_rd14 => 
            IF ((ack = '1') AND (resp = "000000") AND (resp(0) = '0')) THEN 
               next_state <= top_conf0;
            ELSIF ((ack = '1') AND (resp = "000000") AND (resp(0) /= '0')) THEN 
               next_state <= top_conf_wait0;
            ELSIF (ack = '1') THEN 
               next_state <= top_rd0;
            ELSE
               next_state <= top_rd14;
            END IF;
         WHEN top_rd_nonr6 => 
            IF ((resp = "000000") AND (resp(0) = '0')) THEN 
               next_state <= top_conf0;
            ELSIF ((resp = "000000") AND (resp(0) /= '0')) THEN 
               next_state <= top_conf_wait0;
            ELSE
               next_state <= top_rd0;
            END IF;
         WHEN top_rd_count1 => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd5;
            ELSE
               next_state <= top_rd_count1;
            END IF;
         WHEN top_rd_count2 => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd8;
            ELSE
               next_state <= top_rd_count2;
            END IF;
         WHEN top_rd_count3 => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd7;
            ELSE
               next_state <= top_rd_count3;
            END IF;
         WHEN top_rd_count4 => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd11;
            ELSE
               next_state <= top_rd_count4;
            END IF;
         WHEN top_rd_count5 => 
            IF (done = '0' AND err = '0') THEN 
               next_state <= top_rd13;
            ELSE
               next_state <= top_rd_count5;
            END IF;
         WHEN s0 => 
            next_state <= top_conf_wait0;
         WHEN s1 => 
            next_state <= top_conf_wait1;
         WHEN s2 => 
            next_state <= top_conf_wait2;
         WHEN s3 => 
            next_state <= top_conf_wait3;
         WHEN s4 => 
            next_state <= top_conf_wait4;
         WHEN s5 => 
            next_state <= top_conf_wait5;
         WHEN OTHERS =>
            next_state <= top_init0;
      END CASE;
   END PROCESS nextstate_proc;
 
   -- Concurrent Statements
   -- Clocked output assignments
   adc_addr <= adc_addr_cld;
   brd_num <= brd_num_cld;
   rd_cmd <= rd_cmd_cld;
   rd_data_o <= rd_data_o_cld;
   rdy <= rdy_cld;
   wr_cmd <= wr_cmd_cld;
   wr_data <= wr_data_cld;
END fsm;
