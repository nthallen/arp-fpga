--
-- VHDL Architecture idx_fpga_lib.bench_bench.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:31:59 10/ 6/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
-- USE ieee.numeric_std.all; -- for division
-- USE ieee.numeric_bit.all; -- Maybe I can do both division and conversions?

ENTITY bench_bench IS
END ENTITY bench_bench;

--
ARCHITECTURE rtl OF bench_bench IS
  SIGNAL F8M : std_ulogic;
  SIGNAL Done : std_ulogic;
  type iarray is array(natural range <>) of unsigned(19 downto 0);
  SIGNAL Period : iarray(3 DOWNTO 0);
  SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);
  type uarray is array(natural range <>) of unsigned(31 downto 0);
  SIGNAL Read_Count : uarray(3 DOWNTO 0);
BEGIN

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
  
  test_proc : process is
    Variable rate : uarray(3 DOWNTO 0);
    Variable full_cnt : unsigned(31 DOWNTO 0);
    Variable read_cnt : unsigned(31 DOWNTO 0);
    Variable Addr : std_logic_vector(15 DOWNTO 0);
    Variable BaseAddr : unsigned(15 DOWNTO 0);
    Variable RegAddr : unsigned(15 DOWNTO 0);
    Variable SLV16 : std_logic_vector(15 DOWNTO 0);
    Variable SLV32 : std_logic_vector(31 DOWNTO 0);
    Variable High_Word : unsigned(15 DOWNTO 0);
    Variable Addend : unsigned(31 DOWNTO 0);

    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Read_Result <= addr_in;
      -- pragma sysnthesis_off
      wait for 125 ns;
      wait for 1 us;
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;
  Begin
    Done <= '0';
    rate(0) := conv_unsigned(10000,32);
    rate(1) := conv_unsigned(70000,32);
    rate(2) := conv_unsigned(1200000,32);
    rate(3) := conv_unsigned(2000000,32);
    wait until F8M'Event AND F8M = '1';
    for i in 3 downto 0 loop
      full_cnt := conv_unsigned(conv_integer(rate(i)) mod (2**20),32);
      BaseAddr := conv_unsigned(16#0600#,16);
      RegAddr := BaseAddr + (16 + (i*4));
      Addr := conv_std_logic_vector(RegAddr,16);
      sbrd(Addr);
      SLV16 := Read_Result;
      SLV32 := ext(SLV16,32);
      for j in 0 to 31 loop
        read_cnt(j) := SLV32(j);
      end loop;
      -- read_cnt := conv_unsigned(ext(conv_std_logic_vector(Read_Result,16),32),32);
      -- conv_unsigned(Read_Result,32);
      RegAddr := BaseAddr + (18 + (i*4));
      Addr := conv_std_logic_vector(RegAddr,16);
      sbrd(Addr);
      for j in 0 to 15 loop
        read_cnt(j+16) := Read_Result(j);
      end loop;
      Read_Count(i) <= read_cnt;
    end loop;
  End Process;
END ARCHITECTURE rtl;

