--
-- VHDL Architecture idx_fpga_lib.adc_summer.beh
--
-- Created:
--          by - Brian.UNKNOWN (BRIAN-LAPTOP)
--          at - 17:16:30 04/29/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY adc_summer IS
   GENERIC( 
      NBITSHIFT : integer := 1
   );
   PORT( 
      CLK       : IN     std_ulogic;
      CLR       : IN     std_logic;
      INTENSITY : IN     std_logic_vector (31 DOWNTO 0);
      rst       : IN     std_logic;
      SINT      : OUT    std_logic_vector (31 DOWNTO 0);
      ADD_EN    : IN     std_logic;
      ERR       : IN     std_logic
   );

-- Declarations

END adc_summer ;

--
ARCHITECTURE beh OF adc_summer IS
  SIGNAL INTENSITY_A : unsigned(31+NBITSHIFT DOWNTO 0);
  
BEGIN
   clocked_proc : PROCESS ( 
      clk
   )
   BEGIN
      IF (clk'EVENT AND clk = '1') THEN
         IF (rst = '1') THEN
           INTENSITY_A <= (others => '0');
         ELSIF (CLR = '1') THEN
           INTENSITY_A <= (others => '0');
         ELSIF (ADD_EN = '1' AND ERR = '0') THEN
           INTENSITY_A <= INTENSITY_A + unsigned(INTENSITY);
         END IF;
       END IF;
  END PROCESS clocked_proc;
  SINT <= std_logic_vector(INTENSITY_A(31+NBITSHIFT DOWNTO NBITSHIFT));     
  
END ARCHITECTURE beh;

