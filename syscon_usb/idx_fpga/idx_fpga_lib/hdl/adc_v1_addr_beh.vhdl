--
-- VHDL Architecture idx_fpga_lib.adc_v1_addr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 10:28:29 04/ 7/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY adc_v1_addr IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 downto 0) := X"0E80";
      N_ADC     : integer range 4 downto 0      := 2
   );
   PORT( 
      Addr      : IN     std_logic_vector (15 DOWNTO 0);
      ADC_EN    : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      BdEn      : OUT    std_ulogic;
      HighWord  : OUT    std_logic;
      STATUS_EN : OUT    std_logic
   );

-- Declarations

END adc_v1_addr ;

--
ARCHITECTURE beh OF adc_v1_addr IS
BEGIN
  BdEn_out : Process (Addr) Is
  begin
    ADC_EN <= (others => '0');
    BdEn <= '0';
    HighWord <= '0';
    STATUS_EN <= '0';
    if  Addr = BASE_ADDR then
      BdEn <= '1';
      STATUS_EN <= '1';
    else
      for i in 0 to N_ADC-1 LOOP
        if Addr = BASE_ADDR + 2 + 4*i then
          BdEn <= '1';
          ADC_EN(i) <= '1';
        elsif Addr = BASE_ADDR + 4+4*i then
          BdEn <= '1';
          ADC_EN(i) <= '1';
          HighWord <= '1';
        end if;
      end loop;
    end if;

  End Process;
END ARCHITECTURE beh;

