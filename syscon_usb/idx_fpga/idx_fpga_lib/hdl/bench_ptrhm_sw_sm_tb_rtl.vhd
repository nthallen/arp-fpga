--
-- VHDL Test Bench idx_fpga_lib.bench_ptrhm_sw_sm.ptrhm_sw_sm_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:59:29 11/ 8/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;


ENTITY bench_ptrhm_sw_sm IS
   GENERIC (
      N_ISBITS    : integer    := 4;
      ESID        : ESID_array := ( 0, 1, 2, 3, 3, 3, 3, 3 );
      ISwitchBit  : ISB_array  := ( 0, 1, 2, 3 );
      ESwitchAddr : ESA_array  := ( "0000000", "0000000", "0000000", "1110000" );
      ESwitchBit  : ESB_array  := ( 0, 0, 0, 0, 1, 2, 3, 4 );
      N_PTRH      : integer    := 8
   );
END bench_ptrhm_sw_sm;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ptrhm_sw_sm IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL clk       : std_logic;
   SIGNAL cmd       : ptrhm_i2c_op;
   SIGNAL done      : std_ulogic;
   SIGNAL err       : std_ulogic;
   SIGNAL i2c_addr  : std_ulogic_vector(6 DOWNTO 0);
   SIGNAL i2c_rdata : std_logic_vector(23 DOWNTO 0);
   SIGNAL i2c_wdata : std_logic_vector(7 DOWNTO 0);
   SIGNAL ISwitch   : std_ulogic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL rst       : std_logic;
   SIGNAL sw_addr   : std_ulogic_vector(6 DOWNTO 0);
   SIGNAL sw_cmd    : ptrhm_i2c_op;
   SIGNAL sw_done   : std_ulogic;
   SIGNAL sw_err    : std_ulogic;
   SIGNAL sw_rdata  : std_logic_vector(23 DOWNTO 0);
   SIGNAL sw_wdata  : std_logic_vector(7 DOWNTO 0);
   SIGNAL ClkDone   : std_ulogic;


   -- Component declarations
  COMPONENT ptrhm_sw_sm
    GENERIC (
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
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
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
      sw_rdata  : OUT    std_logic_vector (23 DOWNTO 0)
    );
  END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ptrhm_sw_sm : ptrhm_sw_sm USE ENTITY idx_fpga_lib.ptrhm_sw_sm;
   -- pragma synthesis_on

BEGIN

  DUT_ptrhm_sw_sm : ptrhm_sw_sm
    GENERIC MAP (
       N_ISBITS    => N_ISBITS,
       ESID        => ESID,
       ISwitchBit  => ISwitchBit,
       ESwitchAddr => ESwitchAddr,
       ESwitchBit  => ESwitchBit
    )
    PORT MAP (
       clk       => clk,
       cmd       => cmd,
       done      => done,
       err       => err,
       i2c_addr  => i2c_addr,
       i2c_rdata => i2c_rdata,
       i2c_wdata => i2c_wdata,
       ISwitch   => ISwitch,
       rst       => rst,
       sw_addr   => sw_addr,
       sw_cmd    => sw_cmd,
       sw_done   => sw_done,
       sw_err    => sw_err,
       sw_rdata  => sw_rdata,
       sw_wdata  => sw_wdata
    );

  clock : Process
  Begin
    clk <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while ClkDone = '0' loop
      clk <= '0';
      wait for 62 ns;
      clk <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  testproc : Process Is
  Begin
    ClkDone <= '0';
    done <= '0';
    err <= '0';
    i2c_rdata <= (others => '0');
    sw_addr <= (others => '0');
    sw_cmd <= Init;
    sw_wdata <= (others => '0');
    rst <= '1';
    -- pragma synthesis_off
    wait until clk'event AND clk = '1';
    wait until clk'event AND clk = '1';
    rst <= '0';
    wait until clk'event AND clk = '1';
    wait until clk'event AND clk = '1';
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    sw_cmd <= NOP;
    wait until sw_done = '0';
    
    -- test SelectAll
    sw_cmd <= SelectAll;
    wait until cmd = Write;
    assert i2c_wdata = "00011111"
      report "Wrong enable pattern in SelectAll"
      severity error;
    wait until clk'event AND clk = '1';
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    sw_cmd <= NOP;
    wait until sw_done = '0';
    assert ISwitch = "1111"
      report "ISwitch not all ones"
      severity error;
    
    -- test DeselectAll
    sw_cmd <= DeselectAll;
    wait until cmd = Write;
    assert i2c_wdata = "00000000"
      report "Wrong enable pattern in DeselectAll"
      severity error;
    wait until clk'event AND clk = '1';
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    sw_cmd <= NOP;
    wait until sw_done = '0';
    assert ISwitch = "0000"
      report "ISwitch not all zeroes"
      severity error;

    -- test SelectOne
    for i in N_PTRH-1 downto 0 loop
      sw_cmd <= SelectOne;
      sw_wdata <= conv_std_logic_vector(i,8);
      wait until sw_done = '1' OR cmd = Write;
      -- assert which bit is set
      if cmd = Write then
        wait until clk'event AND clk = '1';
        done <= '1';
        wait until cmd = NOP;
        done <= '0';
        wait until sw_done = '1';
      end if;
      sw_cmd <= NOP;
      wait until sw_done = '0';
      assert ISwitch /= "0000"
        report "ISwitch all zeroes after SelectOne"
        severity error;
    end loop;
    
    -- test PTRHn >= N_PTRH
    sw_cmd <= SelectOne;
    sw_wdata <= conv_std_logic_vector(N_PTRH,8);
    wait until sw_done = '1' OR sw_err = '1' OR cmd = Write;
    if cmd = Write then
      report "SelectOne(N_PTRH) should have delivered error"
        severity error;
      wait until clk'event AND clk = '1';
      done <= '1';
      wait until cmd = NOP;
      done <= '0';
      wait until sw_done = '1';
    end if;
    assert sw_err = '1'
      report "SelectOne(N_PTRH) should have delivered error"
      severity error;
    sw_cmd <= NOP;
    wait until sw_done = '0' AND sw_err = '0';
  
    -- test Write
    sw_cmd <= Write;
    sw_addr <= "1010101";
    sw_wdata <= X"55";
    wait until cmd = Write;
    assert i2c_wdata = X"55"
      report "i2c_wdata not set on Write"
      severity error;
    assert i2c_addr = "1010101"
      report "i2c_addr not set on Write"
      severity error;
    wait until clk'event AND clk = '1';
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    sw_cmd <= NOP;
    wait until sw_done = '0';

    -- test Write with no acknowledge
    sw_cmd <= Write;
    sw_addr <= "0101010";
    sw_wdata <= X"AA";
    wait until cmd = Write;
    assert i2c_wdata = X"AA"
      report "i2c_wdata not set on Write"
      severity error;
    assert i2c_addr = "0101010"
      report "i2c_addr not set on Write"
      severity error;
    wait until clk'event AND clk = '1';
    err <= '1';
    wait until cmd = NOP;
    err <= '0';
    wait until sw_err = '1';
    sw_cmd <= NOP;
    wait until sw_err = '0';
    
    -- test WriteRead2
    sw_cmd <= WriteRead2;
    sw_addr <= "1010101";
    sw_wdata <= X"55";
    wait until cmd = WriteRead2;
    assert i2c_wdata = X"55"
      report "i2c_wdata not set on Write"
      severity error;
    assert i2c_addr = "1010101"
      report "i2c_addr not set on Write"
      severity error;
    wait until clk'event AND clk = '1';
    i2c_rdata <= X"001234";
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    assert sw_rdata = X"001234"
      report "sw_rdata did not come through on WriteRead2"
      severity error;
    sw_cmd <= NOP;
    wait until sw_done = '0';
    
    -- test WriteRead3
    sw_cmd <= WriteRead3;
    sw_addr <= "1010101";
    sw_wdata <= X"55";
    wait until cmd = WriteRead3;
    assert i2c_wdata = X"55"
      report "i2c_wdata not set on Write"
      severity error;
    assert i2c_addr = "1010101"
      report "i2c_addr not set on Write"
      severity error;
    wait until clk'event AND clk = '1';
    i2c_rdata <= X"123456";
    done <= '1';
    wait until cmd = NOP;
    done <= '0';
    wait until sw_done = '1';
    assert sw_rdata = X"123456"
      report "sw_rdata did not come through on WriteRead3"
      severity error;
    sw_cmd <= NOP;
    wait until sw_done = '0';
    
    ClkDone <= '1';
    wait;
    -- pragma synthesis_on
  End Process;


END rtl;