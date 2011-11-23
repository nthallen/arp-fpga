--
-- VHDL Architecture idx_fpga_lib.bench_ptrhm_acq_sm.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:35:06 11/21/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.all;
USE idx_fpga_lib.ALL;

ENTITY bench_ptrhm_acq_sm IS
   GENERIC (
      N_PTRH : integer range 16 downto 1 := 8
   );
END ENTITY bench_ptrhm_acq_sm;

--
ARCHITECTURE rtl OF bench_ptrhm_acq_sm IS
   SIGNAL F8M      : std_ulogic;
   SIGNAL rst      : std_logic;
   SIGNAL sw_addr  : std_ulogic_vector(6 DOWNTO 0);
   SIGNAL sw_cmd   : ptrhm_i2c_op;
   SIGNAL sw_done  : std_ulogic;
   SIGNAL sw_err   : std_ulogic;
   SIGNAL sw_rdata : std_logic_vector(23 DOWNTO 0);
   SIGNAL sw_wdata : std_logic_vector(7 DOWNTO 0);
   SIGNAL wData    : std_logic_vector(23 DOWNTO 0);
   SIGNAL WrEn     : std_logic_vector(12 DOWNTO 0);
   SIGNAL WrPTRHEn : std_ulogic_vector(N_PTRH-1 DOWNTO 0);
   SIGNAL ClkDone   : std_ulogic;

   -- Component declarations
   COMPONENT ptrhm_acq_sm
      GENERIC (
         N_PTRH : integer range 16 downto 1 := 8
      );
      PORT (
         F8M      : IN     std_ulogic;
         rst      : IN     std_logic;
         sw_addr  : OUT    std_ulogic_vector(6 DOWNTO 0);
         sw_cmd   : OUT    ptrhm_i2c_op;
         sw_done  : IN     std_ulogic;
         sw_err   : IN     std_ulogic;
         sw_rdata : IN     std_logic_vector(23 DOWNTO 0);
         sw_wdata : OUT    std_logic_vector(7 DOWNTO 0);
         wData    : OUT    std_logic_vector(23 DOWNTO 0);
         WrEn     : OUT    std_logic_vector(12 DOWNTO 0);
         WrPTRHEn : OUT    std_ulogic_vector(N_PTRH-1 DOWNTO 0)
      );
   END COMPONENT;
   -- pragma synthesis_off
   FOR ALL : ptrhm_acq_sm USE ENTITY idx_fpga_lib.ptrhm_acq_sm;
   -- pragma synthesis_on
BEGIN

  DUT_ptrhm_acq_sm : ptrhm_acq_sm
    GENERIC MAP (
       N_PTRH => N_PTRH
    )
    PORT MAP (
       F8M      => F8M,
       rst      => rst,
       sw_addr  => sw_addr,
       sw_cmd   => sw_cmd,
       sw_done  => sw_done,
       sw_err   => sw_err,
       sw_rdata => sw_rdata,
       sw_wdata => sw_wdata,
       wData    => wData,
       WrEn     => WrEn,
       WrPTRHEn => WrPTRHEn
    );

  clock : Process
  Begin
    F8M <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while ClkDone = '0' loop
      F8M <= '0';
      wait for 62 ns;
      F8M <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

  sw : Process
  Begin
    sw_done <= '1';
    sw_err <= '0';
    sw_rdata <= (others => '0');
    -- pragma synthesis_off
    wait for 40 ns;
    while ClkDone = '0' loop
      wait until ClkDone = '1' OR sw_cmd = NOP;
      wait until F8M'event AND F8M = '1';
      wait until F8M'event AND F8M = '1';
      sw_done <= '0';
      wait until ClkDone = '1' OR sw_cmd /= NOP;
      wait until F8M'event AND F8M = '1';
      wait until F8M'event AND F8M = '1';
      sw_done <= '1';
      sw_rdata <= sw_rdata+X"135701";
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  testproc : Process Is
  Begin
    ClkDone <= '0';
    rst <= '1';
    -- pragma synthesis_off
    wait until F8M'event AND F8M = '1';
    wait until F8M'event AND F8M = '1';
    rst <= '0';
    wait until sw_cmd = SelectAll;
    wait until sw_cmd = NOP;
    wait until sw_cmd = SelectAll;
    wait until sw_cmd = NOP;
    wait until sw_cmd = SelectAll;
    wait until sw_cmd = NOP;
    wait until sw_cmd = SelectAll;
    wait until sw_cmd = NOP;
    wait until sw_cmd = SelectAll;
    wait until sw_cmd = NOP;
    
    ClkDone <= '1';
    wait;
    -- pragma synthesis_on
  End Process;
END ARCHITECTURE rtl;

