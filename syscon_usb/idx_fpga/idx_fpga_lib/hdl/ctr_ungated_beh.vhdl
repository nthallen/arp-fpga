--
-- VHDL Architecture idx_fpga_lib.ctr_ungated.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 14:40:52 09/30/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY ctr_ungated IS
  GENERIC (
    BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
    N_COUNTERS : integer range 4 DOWNTO 4 := 4;
    N_BITS : integer range 32 DOWNTO 16 := 20
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    WData   : IN     std_logic_vector (15 DOWNTO 0);
    RData   : OUT    std_logic_vector (15 DOWNTO 0);
    ExpRd   : IN     std_ulogic;
    ExpWr   : IN     std_ulogic;
    ExpAck  : OUT    std_ulogic;
    F8M     : IN     std_ulogic;
    rst     : IN     std_ulogic;
    PMT     : IN     std_logic_vector(N_COUNTERS-1 DOWNTO 0)
    );
  END ENTITY ctr_ungated;

  --
  ARCHITECTURE beh OF ctr_ungated IS
   type ctrdata_t is array (natural range <>) of
     std_logic_vector(15 downto 0);
   SIGNAL CtrData : ctrdata_t(N_COUNTERS-1 downto 0);
   SIGNAL RdEn  : std_ulogic;
   SIGNAL WrEn  : std_ulogic;
   SIGNAL BdEn  : std_ulogic;
   SIGNAL StatEn  : std_ulogic;
   SIGNAL RevEn   : std_ulogic;
   SIGNAL CtrEn   : natural range N_COUNTERS-1 DOWNTO 0;
   SIGNAL CtrsEn  : std_ulogic;
   SIGNAL CtrEnHW : std_ulogic;
   SIGNAL Lx4En       : std_ulogic;
   SIGNAL CntEn       : std_ulogic;
   SIGNAL RegEn       : std_ulogic;
   SIGNAL CntClr      : std_ulogic;
   SIGNAL L2Stat      : std_ulogic;
   SIGNAL ResynchStat : std_ulogic;
   SIGNAL OVF         : std_logic_vector(N_COUNTERS-1 DOWNTO 0);
   SIGNAL OVF16       : std_logic_vector(N_COUNTERS-1 DOWNTO 0);
   SIGNAL Divisor     : unsigned(3 DOWNTO 0);
   
   COMPONENT subbus_io
      PORT (
         ExpRd  : IN     std_ulogic;
         ExpWr  : IN     std_ulogic;
         ExpAck : OUT    std_ulogic;
         F8M    : IN     std_ulogic;
         RdEn   : OUT    std_ulogic;
         WrEn   : OUT    std_ulogic;
         BdEn   : IN     std_ulogic
      );
   END COMPONENT;
   
   COMPONENT ctr_addr
      GENERIC (
         BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
         N_COUNTERS   : integer range 4 downto 4       := 4
      );
      PORT (
         Addr    : IN     std_logic_vector(15 DOWNTO 0);
         StatEn  : OUT    std_ulogic;
         RevEn   : OUT    std_ulogic;
         CtrEn   : OUT    natural range N_COUNTERS-1 DOWNTO 0;
         CtrsEn  : OUT    std_ulogic;
         CtrEnHW : OUT    std_ulogic;
         BdEn    : OUT    std_ulogic
      );
   END COMPONENT;
   
   COMPONENT ctr_synch
      PORT (
         RdEn        : IN     std_ulogic;
         StatEn      : IN     std_ulogic;
         CtrsEn      : IN     std_ulogic;
         Lx4En       : IN     std_ulogic;
         Clk         : IN     std_ulogic;
         rst         : IN     std_ulogic;
         CntEn       : OUT    std_ulogic;
         RegEn       : OUT    std_ulogic;
         CntClr      : OUT    std_ulogic;
         L2Stat      : OUT    std_ulogic;
         ResynchStat : OUT    std_ulogic
      );
   END COMPONENT;
   
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
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   FOR ALL : ctr_addr USE ENTITY idx_fpga_lib.ctr_addr;
   FOR ALL : ctr_synch USE ENTITY idx_fpga_lib.ctr_synch;
   FOR ALL : ctr_ugctr USE ENTITY idx_fpga_lib.ctr_ugctr;
   FOR ALL : ctr_lx4gen USE ENTITY idx_fpga_lib.ctr_lx4gen;
BEGIN
   subbus_io_i : subbus_io
      PORT MAP (
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );
      
   ctr_addr_i : ctr_addr
      GENERIC MAP (
         BASE_ADDRESS => BASE_ADDRESS,
         N_COUNTERS   => N_COUNTERS
      )
      PORT MAP (
         Addr    => Addr,
         StatEn  => StatEn,
         RevEn   => RevEn,
         CtrEn   => CtrEn,
         CtrsEn  => CtrsEn,
         CtrEnHW => CtrEnHW,
         BdEn    => BdEn
      );
      
   ctr_synch_i : ctr_synch
      PORT MAP (
         RdEn        => RdEn,
         StatEn      => StatEn,
         CtrsEn      => CtrsEn,
         Lx4En       => Lx4En,
         Clk         => F8M,
         rst         => rst,
         CntEn       => CntEn,
         RegEn       => RegEn,
         CntClr      => CntClr,
         L2Stat      => L2Stat,
         ResynchStat => ResynchStat
      );
   ctr_lx4gen_i : ctr_lx4gen
      GENERIC MAP (
         PRE_DIVISOR => X"1E847"
      )
      PORT MAP (
         F8M     => F8M,
         Divisor => Divisor,
         rst     => rst,
         Lx4En   => Lx4En
      );
      
   counters : for i in 0 TO N_COUNTERS-1 generate
     ugctr : ctr_ugctr
        GENERIC MAP (
           N_BITS => N_BITS
        )
        PORT MAP (
           PMT    => PMT(i),
           CntEn  => CntEn,
           RegEn  => RegEn,
           CntClr => CntClr,
           F8M    => F8M,
           HW_En  => CtrEnHW,
           Data   => CtrData(i),
           OVF    => OVF(i),
           OVF16  => OVF16(i)
        );
    end generate;
    
    Status : process (F8M) is
    Begin
      if F8M'Event and F8M = '1' then
        if StatEn = '1' then
          RData(N_COUNTERS-1 DOWNTO 0) <= OVF;
          RData(2*N_COUNTERS-1 DOWNTO N_COUNTERS) <= OVF16;
          RData(11 DOWNTO 8) <= std_logic_vector(Divisor);
          RData(13 DOWNTO 12) <= (others => '0');
          RData(14) <= L2Stat;
          RData(15) <= ResynchStat;
        elsif RevEn = '1' then
          RData <= X"0002";
        elsif CtrsEn = '1' then
          RData <= CtrData(CtrEn);
        else
          RData <= (others => '0');
        end if;
    end if;
    End Process;
    
    DivReg : Process (F8M) is
    Begin
      if F8M'Event and F8M = '1' then
        if rst = '1' then
          Divisor <= X"F";
        elsif WrEn = '1' and StatEn = '1' then
          Divisor <= unsigned(WData(11 DOWNTO 8));
        end if;
      end if;
    End Process;
    
END ARCHITECTURE beh;
