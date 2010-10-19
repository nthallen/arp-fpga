--
-- VHDL Test Bench idx_fpga_lib.bench_ctr_ugctr.ctr_ugctr_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 15:29:27 10/ 1/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ctr_ugctr IS
   GENERIC (
      N_BITS : integer range 32 DOWNTO 16 := 20
   );
END bench_ctr_ugctr;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ctr_ugctr IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL PMT    : std_ulogic;
   SIGNAL CntEn  : std_ulogic;
   SIGNAL RegEn  : std_ulogic;
   SIGNAL CntClr : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL HW_En  : std_ulogic;
   SIGNAL Data   : std_logic_vector(15 DOWNTO 0);
   SIGNAL OVF    : std_ulogic;
   SIGNAL OVF16  : std_ulogic;
   SIGNAL Divisor : unsigned(3 DOWNTO 0);
   SIGNAL rst     : std_ulogic;
   SIGNAL Lx4En   : std_ulogic;
   SIGNAL LatchX4 : std_logic;
   SIGNAL RS      : std_logic;
   SIGNAL Latch   : std_logic;
   SIGNAL Period  : unsigned(19 DOWNTO 0);
   SIGNAL Done    : std_ulogic;


   -- Component declarations
   COMPONENT ctr_ugctr
      GENERIC (
         N_BITS : integer range 32 DOWNTO 16 := 20
      );
      PORT (
         PMT    : IN     std_ulogic;
         CntEn  : IN     std_ulogic;
         RegEn  : IN     std_ulogic;
         CntClr : IN     std_ulogic;
         F8M    : IN     std_ulogic;
         HW_En  : IN     std_ulogic;
         Data   : OUT    std_logic_vector(15 DOWNTO 0);
         OVF    : OUT    std_ulogic;
         OVF16  : OUT    std_ulogic
      );
   END COMPONENT;
   COMPONENT ctr_lx4gen
      GENERIC (
         PRE_DIVISOR : unsigned (19 DOWNTO 0) := X"1E848"
      );
      PORT (
         F8M     : IN     std_ulogic;
         Divisor : IN     unsigned(3 DOWNTO 0);
         rst     : IN     std_ulogic;
         Lx4En   : OUT    std_ulogic
      );
   END COMPONENT;
   COMPONENT ctr_latch
      PORT (
         clk    : IN     std_logic;
         latch  : IN     std_logic;
         rst    : IN     std_logic;
         cntclr : OUT    std_logic;
         cnten  : OUT    std_logic;
         regen  : OUT    std_logic
      );
   END COMPONENT;
   COMPONENT ctr_latchx4
      PORT (
         LatchX4 : IN     std_logic;
         RS      : IN     std_logic;
         clk     : IN     std_logic;
         Latch   : OUT    std_logic
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ctr_ugctr : ctr_ugctr USE ENTITY idx_fpga_lib.ctr_ugctr;
   FOR ALL : ctr_lx4gen USE ENTITY idx_fpga_lib.ctr_lx4gen;
   FOR ALL : ctr_latch USE ENTITY idx_fpga_lib.ctr_latch;
   FOR ALL : ctr_latchx4 USE ENTITY idx_fpga_lib.ctr_latchx4;
   -- pragma synthesis_on

BEGIN

   DUT_ctr_ugctr : ctr_ugctr
      GENERIC MAP (
         N_BITS => N_BITS
      )
      PORT MAP (
         PMT    => PMT,
         CntEn  => CntEn,
         RegEn  => RegEn,
         CntClr => CntClr,
         F8M    => F8M,
         HW_En  => HW_En,
         Data   => Data,
         OVF    => OVF,
         OVF16  => OVF16
      );

   lxrgen_i : ctr_lx4gen
      GENERIC MAP (
         PRE_DIVISOR => X"1E847"
      )
      PORT MAP (
         F8M     => F8M,
         Divisor => Divisor,
         rst     => rst,
         Lx4En   => Lx4En
      );

   latch_i : ctr_latch
      PORT MAP (
         clk    => F8M,
         latch  => Latch,
         rst    => rst,
         cntclr => CntClr,
         cnten  => CntEn,
         regen  => RegEn
      );

   latchx4_i : ctr_latchx4
      PORT MAP (
         LatchX4 => Lx4En,
         RS      => RS,
         clk     => F8M,
         Latch   => Latch
      );

    clock : Process
    Begin
      F8M <= '0';
      -- pragma synthesis_off
      wait for 40 ns;
      while Done = '0' loop
        F8M <= '0';
        wait for 62 ns;
        F8M <= '1';
        wait for 63 ns;
      end loop;
      wait;
      -- pragma synthesis_on
    End Process;
    
    pmt_pulses : Process
      Variable cumdelay : unsigned(19 DOWNTO 0);
    Begin
      PMT <= '0';
      -- pragma synthesis_off
      wait for 400 ns;
      while Done = '0' loop
        -- This first section is tweaked to synchronize
        -- the first pulse with the very start of the
        -- integration period.
        if RegEn = '1' OR CntClr = '1' then
          wait until RegEn = '0' AND CntClr = '0';
        end if;
        wait for 5 ns;
        PMT <= '1';
        wait for 5 ns;
        PMT <= '0';
        
        -- Now a kluge to wait for a programmed amount of
        -- time. Extra code to break out of these loops
        -- when RegEn goes high so the next integration
        -- period will start cleanly.
        cumdelay := conv_unsigned(10,20);
        while cumdelay+500 <= Period and RegEn = '0' loop
          wait until RegEn = '1' for 500 ns;
          cumdelay := cumdelay+500;
        end loop;
        while cumdelay+50 <= Period and RegEn = '0' loop
          wait until RegEn = '1' for 50 ns;
          cumdelay := cumdelay+50;
        end loop;
        while cumdelay+5 <= Period and RegEn = '0' loop
          wait until RegEn = '1' for 5 ns;
          cumdelay := cumdelay+5;
        end loop;
      end loop;
      wait;
      -- pragma synthesis_on
    End Process;      
    
   
    test_proc : Process
      procedure confirm_count( low_byte : integer;
          high_byte : integer;
          ovf16_val : std_ulogic;
          ovf_val : std_ulogic ) is
      Begin
        wait for 1000 ns;
        assert Data = conv_std_logic_vector(low_byte,16)
          report "Low byte incorrect" severity error;
        HW_En <= '1';
        wait for 1000 ns;
        assert Data = conv_std_logic_vector(high_byte,16)
          report "High byte incorrect" severity error;
        HW_En <= '0';
      End Procedure confirm_count;
      
      procedure confirm( cnt : integer ) is
        Variable full_cnt : integer;
        Variable low_word : integer;
        Variable high_word : integer;
        Variable ovf16 : std_ulogic;
        Variable ovf : std_ulogic;
      Begin
        if cnt >= 2**20 then
          ovf := '1';
        else
          ovf := '0';
        end if;
        full_cnt := cnt mod 2**20;
        if full_cnt >= 2**16 then
          ovf16 := '1';
        else
          ovf16 := '0';
        end if;
        high_word := full_cnt / 2**16;
        low_word := full_cnt mod 2**16;
        confirm_count( low_word, high_word, ovf16, ovf );
      End Procedure confirm;

    Begin
      Done <= '0';
      Divisor <= X"F";
      HW_En <= '0';
      rst <= '1';
      Period <= conv_unsigned(100000,20); --10000 Hz
      -- pragma synthesis_off
      wait for 300 ns;
      rst <= '0';
      wait until RegEn'Event and RegEn = '1';
      wait until RegEn'Event and RegEn = '1';
      Period <= conv_unsigned(10000,20); --100000 Hz
      confirm(10000);
      wait until RegEn'Event and RegEn = '1';
      Period <= conv_unsigned(500,20); -- 2 MHz
      confirm(100000);
      wait until RegEn'Event and RegEn = '1';
      confirm(2000000);
      wait for 1000 ns;
      Done <= '1';
      wait;
      -- pragma synthesis_on
    End Process;


END rtl;