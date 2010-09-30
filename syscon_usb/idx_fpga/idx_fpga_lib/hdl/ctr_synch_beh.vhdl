--
-- VHDL Architecture idx_fpga_lib.ctr_synch.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:41:46 09/29/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY ctr_synch IS
  PORT (
    RdEn : IN std_ulogic;
    StatEn : IN std_ulogic;
    BdEn : IN std_ulogic;
    Lx4En : IN std_ulogic;
    Clk : IN std_ulogic;
    rst : IN std_ulogic;
    CntEn : OUT std_ulogic;
    RegEn : OUT std_ulogic;
    CntClr : OUT std_ulogic;
    L2Stat : OUT std_ulogic;
    ResynchStat : OUT std_ulogic
  );
END ENTITY ctr_synch;

--
ARCHITECTURE beh OF ctr_synch IS
  SIGNAL Rd0       : std_ulogic;
  SIGNAL RdEdge    : std_ulogic;
  SIGNAL Latch     : std_ulogic;
  SIGNAL Latch0    : std_ulogic;
  SIGNAL LatchEdge : std_ulogic;
  SIGNAL RS        : std_ulogic;
  SIGNAL L2        : std_ulogic;
  SIGNAL RSS_int   : std_ulogic;
  SIGNAL L2_int    : std_ulogic;
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
  COMPONENT ctr_resynch
     PORT (
        BdEn      : IN     std_ulogic;
        LatchEdge : IN     std_ulogic;
        RdEdge    : IN     std_ulogic;
        StatEn    : IN     std_ulogic;
        clk       : IN     std_logic;
        rst       : IN     std_logic;
        L2        : OUT    std_ulogic;
        RS        : OUT    std_ulogic
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
  FOR ALL : ctr_latch USE ENTITY idx_fpga_lib.ctr_latch;
  FOR ALL : ctr_resynch USE ENTITY idx_fpga_lib.ctr_resynch;
  FOR ALL : ctr_latchx4 USE ENTITY idx_fpga_lib.ctr_latchx4;
BEGIN
  ctr_latch_i : ctr_latch
    PORT MAP (
      clk    => Clk,
      latch  => Latch,
      rst    => rst,
      cntclr => CntClr,
      cnten  => CntEn,
      regen  => RegEn
    );
  --  hds hds_inst
  ctr_latchx4_i : ctr_latchx4
     PORT MAP (
        LatchX4 => Lx4En,
        RS      => RS,
        clk     => Clk,
        Latch   => Latch
     );
  --  hds hds_inst
  ctr_resynch_i : ctr_resynch
     PORT MAP (
        BdEn      => BdEn,
        LatchEdge => LatchEdge,
        RdEdge    => RdEdge,
        StatEn    => StatEn,
        clk       => clk,
        rst       => rst,
        L2        => L2,
        RS        => RS
     );

  Delay : process (Clk) is
  Begin
    if Clk'Event and Clk = '1' then
      Rd0 <= RdEn;
      Latch0 <= Latch;
      if RdEn = '1' and Rd0 /= '1' then
        RdEdge <= '1';
      else
        RdEdge <= '0';
      end if;
      if Latch = '1' and Latch0 /= '1' then
        LatchEdge <= '1';
      else
        LatchEdge <= '0';
      end if;
    end if;
  End Process;

  Status : process (Clk) is
  Begin
    if Clk'Event and Clk = '1' then
      if rst = '1' then
        L2Stat <= '0';
        L2_int <= '0';
        ResynchStat <= '0';
        RSS_int <= '0';
      elsif RdEdge = '1' and StatEn = '1' then
        ResynchStat <= RSS_int;
        L2Stat <= L2_int;
        RSS_int <= '0';
        L2_int <= '0';
      elsif RS = '1' then
        RSS_int <= '1';
        L2_int <= L2;
      end if;
    end if;
  End Process;

END ARCHITECTURE beh;

