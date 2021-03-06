--
-- VHDL Test Bench idx_fpga_lib.bench_ptrhm_addr.ptrhm_addr_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:25:16 11/ 1/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
-- USE ieee.numeric_std.all;


ENTITY bench_ptrhm_addr IS
   GENERIC (
      BASE_ADDR : unsigned(15 DOWNTO 0) := X"0300";
      N_PTRH    : integer range 8 downto 2      := 8
   );
END bench_ptrhm_addr;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_ptrhm_addr IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL BdEn   : std_ulogic;
   SIGNAL PTRHEn : std_ulogic_vector(N_PTRH-1 DOWNTO 0);
   SIGNAL RegEn  : std_ulogic_vector(12 DOWNTO 0);


   -- Component declarations
   COMPONENT ptrhm_addr
      GENERIC (
         BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"0300";
         N_PTRH    : integer range 8 downto 2      := 2
      );
      PORT (
         Addr   : IN     std_logic_vector(15 DOWNTO 0);
         BdEn   : OUT    std_ulogic;
         PTRHEn : OUT    std_ulogic_vector(N_PTRH-1 DOWNTO 0);
         RegEn  : OUT    std_ulogic_vector(12 DOWNTO 0)
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_ptrhm_addr : ptrhm_addr USE ENTITY idx_fpga_lib.ptrhm_addr;
   -- pragma synthesis_on

BEGIN

  DUT_ptrhm_addr : ptrhm_addr
    GENERIC MAP (
      BASE_ADDR => CONV_STD_LOGIC_VECTOR(CONV_INTEGER(BASE_ADDR),16),
      N_PTRH    => N_PTRH
    )
    PORT MAP (
      Addr   => Addr,
      BdEn   => BdEn,
      PTRHEn => PTRHEn,
      RegEn  => RegEn
    );

  testproc: Process IS
    -- pragma synthesis_off
    Variable ChkPTRHEn : std_ulogic_vector(N_PTRH-1 DOWNTO 0);
    -- pragma synthesis_on
  Begin
    Addr <= X"0000";
    -- pragma synthesis_off
    ChkPTRHEn := (others => '0');
    wait for 10 ns;
    assert BdEn = '0'
      report "Permanent Acknowledge"
      severity error;
    assert PTRHEn = ChkPTRHEn
      report "Permanent PTRH Enable"
      severity error;
    assert RegEn = "0000000000000"
      report "Permanent Reg Enable"
      severity error;
    for ptrh in 0 TO N_PTRH-1 loop
      for reg in 0 TO 15 loop
        Addr <= CONV_STD_LOGIC_VECTOR(BASE_ADDR + ptrh * 32 + reg * 2, 16);
        wait for 10 ns;
        if reg <= 12 then
          assert BdEn = '1'
            report "Board should be enabled"
            severity error;
        else
          assert BdEn = '0'
            report "Board should not be enabled"
            severity error;
        end if;
        for ptrh_r in 0 TO N_PTRH-1 loop
          if ptrh_r = ptrh then
            assert PTRHEn(ptrh_r) = '1'
              report "PTRH should have been asserted"
              severity error;
          else
            assert PTRHEn(ptrh_r) = '0'
              report "Wrong PTRH asserted"
              severity error;
          end if;
        end loop;
        for reg_r in 0 TO 12 loop
        end loop;
    end loop;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;

END rtl;