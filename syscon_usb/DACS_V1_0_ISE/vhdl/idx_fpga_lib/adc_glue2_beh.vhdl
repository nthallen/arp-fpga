--
-- VHDL Architecture idx_fpga_lib.adc_glue2.beh
--
-- Created:
--          by - Brian.UNKNOWN (BRIAN-LAPTOP)
--          at - 17:56:06 04/30/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY adc_glue2 IS
   GENERIC (
      N_ADC : integer range 4 downto 0 := 2 
   );
   PORT( 
      ADC_EN    : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      ERR       : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      F8M       : IN     std_ulogic;
      HighWord  : IN     std_logic;
      INTS      : IN     std_logic_vector (32*N_ADC-1 DOWNTO 0);
      RdEn      : IN     std_ulogic;
      STATUS    : IN     std_logic_vector (4 DOWNTO 0);
      STATUS_EN : IN     std_logic;
      WrEn      : IN     std_ulogic;
      RData     : OUT    std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END adc_glue2 ;

--
ARCHITECTURE beh OF adc_glue2 IS
  SIGNAL INTS_int : std_logic_vector (32*N_ADC-1 DOWNTO 0);
BEGIN
  run: Process (F8M) Is
  begin
    if F8M'EVENT AND F8M = '1' THEN
      if RdEn = '1' THEN
        if STATUS_EN = '1' THEN
          RDATA(15 DOWNTO N_ADC+8) <= (others => '0');
          RDATA(N_ADC+7 DOWNTO 8) <= ERR;
          RDATA(7 DOWNTO 5) <= (others => '0');
          RDATA(4 DOWNTO 0) <= STATUS;
          INTS_int <= INTS;
        else
          for i in 0 to N_ADC-1 LOOP
            if ADC_EN(i) = '1' THEN
              if HighWord = '1' THEN
                RDATA <= INTS_int(i*32+31 downto i*32+16);
              else
                RDATA <= INTS_int(i*32+15 downto i*32);
                end if;
            end if;
          end loop;
        end if;
      end if;
     end if; 
     end process run;
END ARCHITECTURE beh;

