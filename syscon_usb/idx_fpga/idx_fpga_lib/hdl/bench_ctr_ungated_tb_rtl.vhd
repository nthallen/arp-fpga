--
-- VHDL Test Bench idx_fpga_lib.bench_ctr_ungated.bench_ctr_ungated_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:33:48 10/ 4/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_ctr_ungated IS
   GENERIC (
      BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
      N_COUNTERS   : integer range 4 DOWNTO 4       := 4;
      N_BITS       : integer range 32 DOWNTO 16     := 20
   );
END bench_ctr_ungated;


LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ctr_ungated IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL WData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL RData  : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL ExpAck : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL rst    : std_ulogic;
   SIGNAL PMT    : std_logic_vector(N_COUNTERS-1 DOWNTO 0);


   -- Component declarations
   COMPONENT ctr_ungated
      GENERIC (
         BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
         N_COUNTERS   : integer range 4 DOWNTO 4       := 4;
         N_BITS       : integer range 32 DOWNTO 16     := 20
      );
      PORT (
         Addr   : IN     std_logic_vector(15 DOWNTO 0);
         WData  : IN     std_logic_vector(15 DOWNTO 0);
         RData  : OUT    std_logic_vector(15 DOWNTO 0);
         ExpRd  : IN     std_ulogic;
         ExpWr  : IN     std_ulogic;
         ExpAck : OUT    std_ulogic;
         F8M    : IN     std_ulogic;
         rst    : IN     std_ulogic;
         PMT    : IN     std_logic_vector(N_COUNTERS-1 DOWNTO 0)
      );
   END COMPONENT;

   COMPONENT bench_ctr_ungated_tester
      GENERIC (
         BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0600";
         N_COUNTERS   : integer range 4 DOWNTO 4       := 4;
         N_BITS       : integer range 32 DOWNTO 16     := 20
      );
      PORT (
         Addr   : OUT    std_logic_vector(15 DOWNTO 0);
         WData  : OUT    std_logic_vector(15 DOWNTO 0);
         RData  : IN     std_logic_vector(15 DOWNTO 0);
         ExpRd  : OUT    std_ulogic;
         ExpWr  : OUT    std_ulogic;
         ExpAck : IN     std_ulogic;
         F8M    : OUT    std_ulogic;
         rst    : OUT    std_ulogic;
         PMT    : OUT    std_logic_vector(N_COUNTERS-1 DOWNTO 0)
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ctr_ungated : ctr_ungated USE ENTITY idx_fpga_lib.ctr_ungated;
   FOR DUT_bench_ctr_ungated_tester : bench_ctr_ungated_tester USE ENTITY idx_fpga_lib.bench_ctr_ungated_tester;
   -- pragma synthesis_on

BEGIN

         DUT_ctr_ungated : ctr_ungated
            GENERIC MAP (
               BASE_ADDRESS => BASE_ADDRESS,
               N_COUNTERS   => N_COUNTERS,
               N_BITS       => N_BITS
            )
            PORT MAP (
               Addr   => Addr,
               WData  => WData,
               RData  => RData,
               ExpRd  => ExpRd,
               ExpWr  => ExpWr,
               ExpAck => ExpAck,
               F8M    => F8M,
               rst    => rst,
               PMT    => PMT
            );

         DUT_bench_ctr_ungated_tester : bench_ctr_ungated_tester
            GENERIC MAP (
               BASE_ADDRESS => BASE_ADDRESS,
               N_COUNTERS   => N_COUNTERS,
               N_BITS       => N_BITS
            )
            PORT MAP (
               Addr   => Addr,
               WData  => WData,
               RData  => RData,
               ExpRd  => ExpRd,
               ExpWr  => ExpWr,
               ExpAck => ExpAck,
               F8M    => F8M,
               rst    => rst,
               PMT    => PMT
            );


END rtl;