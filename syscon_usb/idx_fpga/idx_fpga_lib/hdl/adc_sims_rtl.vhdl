--
-- VHDL Architecture idx_fpga_lib.adc_sims.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 20:56:25 05/ 1/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY adc_sims IS
   GENERIC(
     N_ADC : integer range 4 downto 1 := 2
   );
   PORT( 
      CS_B : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      MOSI : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      SCLK : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      MISO : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      En   : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      rst  : IN     std_logic;
      F8M  : IN     std_ulogic
   );

-- Declarations

END adc_sims ;

--
ARCHITECTURE rtl OF adc_sims IS
   COMPONENT adc_sim
      PORT (
         CS_B : IN     std_logic;
         En   : IN     std_logic;
         F8M  : IN     std_ulogic;
         MOSI : IN     std_logic;
         SCLK : IN     std_logic;
         rst  : IN     std_logic;
         MISO : OUT    std_logic
      );
   END COMPONENT adc_sim;
   FOR ALL : adc_sim USE ENTITY idx_fpga_lib.adc_sim;
BEGIN
  adcs: for i in 0 to N_ADC-1 generate
   --  hds hds_inst
   adc : adc_sim
      PORT MAP (
         CS_B => CS_B(i),
         En   => En(i),
         F8M  => F8M,
         MOSI => MOSI(i),
         SCLK => SCLK(i),
         rst  => rst,
         MISO => MISO(i)
      );
  end generate;
END ARCHITECTURE rtl;

