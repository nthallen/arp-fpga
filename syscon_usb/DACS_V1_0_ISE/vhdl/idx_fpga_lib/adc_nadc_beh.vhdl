--
-- VHDL Architecture idx_fpga_lib.adc_nadc.beh
--
-- Created:
--          by - Brian.UNKNOWN (BRIAN-LAPTOP)
--          at - 15:58:28 04/30/2014
--
-- using Mentor Graphics HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY adc_nadc IS
   GENERIC( 
      N_ADC     : integer range 4 downto 0  := 2;
      RATE_DEF  : std_logic_vector (4 DOWNTO 0) := "11111";
      NBITSHIFT : integer range 31 downto 0 := 1
   );
   PORT( 
      ADD_EN     : IN     std_logic;
      CLR        : IN     std_logic;
      F8M        : IN     std_ulogic;
      MISO       : IN     std_logic_vector (N_ADC-1 DOWNTO 0);
      RdEn       : IN     std_ulogic;
      STATUS_EN  : IN     std_logic;
      rst        : IN     std_logic;
      ALL_EOC    : OUT    std_logic;
      CS_B       : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      ERR        : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      INTS       : OUT    std_logic_vector (32*N_ADC-1 DOWNTO 0);
      MOSI       : OUT    std_logic_vector (N_ADC-1 DOWNTO 0);
      ACQ_OUT    : OUT    std_logic;
      SCLK       : OUT    std_logic_vector (N_ADC-1 DOWNTO 0)
   );

-- Declarations

END adc_nadc ;

--
ARCHITECTURE beh OF adc_nadc IS
   SIGNAL ACQ       : std_logic;
   SIGNAL EOC       : std_logic_vector(N_ADC-1 DOWNTO 0);
   SIGNAL ERR_int   : std_logic_vector(N_ADC-1 DOWNTO 0);
	SIGNAL ALL_EOC_int : std_logic;
   COMPONENT adc_int
      GENERIC (
         NBITSHIFT : integer := 1;
         RATE_DEF  : std_logic_vector(4 DOWNTO 0) := "11111"
      );
      PORT (
         ACQ       : IN     std_logic;
         ADD_EN    : IN     std_logic;
         CLK       : IN     std_ulogic;
         CLR       : IN     std_logic;
         MISO      : IN     std_logic;
         READ_EN   : IN     std_logic;
         STATUS_EN : IN     std_logic;
         rst       : IN     std_logic;
         CS_B      : OUT    std_logic;
         EOC       : OUT    std_logic;
         ERR       : OUT    std_logic;
         MOSI      : OUT    std_logic;
         SCLK      : OUT    std_logic;
         SINT      : OUT    std_logic_vector(31 DOWNTO 0)
      );
   END COMPONENT adc_int;
   FOR ALL : adc_int USE ENTITY idx_fpga_lib.adc_int;
BEGIN
   nth_adc: for i in 0 to N_ADC-1 generate 
   adc : adc_int
      GENERIC MAP (
         NBITSHIFT => NBITSHIFT,
         RATE_DEF => RATE_DEF
      )
      PORT MAP (
         ACQ       => ACQ,
         ADD_EN    => ADD_EN,
         CLK       => F8M,
         CLR       => CLR,
         MISO      => MISO(i),
         READ_EN   => RdEn,
         STATUS_EN => STATUS_EN,
         rst       => rst,
         CS_B      => CS_B(i),
         EOC       => EOC(i),
         ERR       => ERR_int(i),
         MOSI      => MOSI(i),
         SCLK      => SCLK(i),
         SINT      => INTS(32*i+31 DOWNTO 32*i)
      );
   end generate;
   
   ACQ_PROC: PROCESS (EOC,ERR_int, ACQ, ALL_EOC_int)
   BEGIN
     ACQ <= '1';
     ALL_EOC_int <= '0'; -- zero if all EOC(i) are zero
     for i in 0 to N_ADC-1 LOOP
       if ERR_int(i) = '0' AND EOC(i) = '0' THEN
         ACQ <= '0';
       end if;
       if EOC(i) = '1' THEN
         ALL_EOC_int <= '1';
       end if;
     end LOOP;
     if ACQ = '1' AND ALL_EOC_int = '1' THEN
       ACQ_OUT <= '1';
     else
       ACQ_OUT <= '0';
     end if;
   END PROCESS ACQ_PROC;   
  
   ERR <= ERR_int;
	ALL_EOC <= ALL_EOC_int;
      
END ARCHITECTURE beh;

