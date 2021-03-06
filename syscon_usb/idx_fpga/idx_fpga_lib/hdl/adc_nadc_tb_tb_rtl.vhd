--
-- VHDL Test Bench idx_fpga_lib.adc_nadc_tb.adc_nadc_tester
--
-- Created:
--          by - . (BRIAN-LAPTOP)
--          at - 19:00:00 12/31/69
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2013.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY adc_nadc_tb IS
   GENERIC (
      N_ADC     : integer range 4 downto 0      := 2;
      RATE_DEF  : std_logic_vector (4 DOWNTO 0) := "11111";
      NBITSHIFT : integer range 31 downto 0     := 1
   );
END adc_nadc_tb;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF adc_nadc_tb IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL ADD_EN     : std_logic;
   SIGNAL CLR        : std_logic;
   SIGNAL F8M        : std_ulogic;
   SIGNAL MISO       : std_logic_vector(N_ADC-1 DOWNTO 0);
   SIGNAL OUT_ACK    : std_logic;
   SIGNAL RdEn       : std_ulogic;
   SIGNAL STATUS_EN  : std_logic;
   SIGNAL rst        : std_logic;
   SIGNAL CS_B       : std_logic_vector(N_ADC-1 DOWNTO 0);
   SIGNAL DATA_READY : std_logic;
   SIGNAL ERR        : std_logic_vector(N_ADC-1 DOWNTO 0);
   SIGNAL INTS       : std_logic_vector(32*N_ADC-1 DOWNTO 0);
   SIGNAL MOSI       : std_logic_vector(N_ADC-1 DOWNTO 0);
   SIGNAL SCLK       : std_logic_vector(N_ADC-1 DOWNTO 0);


   -- Component declarations
   COMPONENT adc_nadc
      GENERIC (
         N_ADC     : integer range 4 downto 0      := 2;
         RATE_DEF  : std_logic_vector (4 DOWNTO 0) := "11111";
         NBITSHIFT : integer range 31 downto 0     := 1
      );
      PORT (
         ADD_EN     : IN     std_logic;
         CLR        : IN     std_logic;
         F8M        : IN     std_ulogic;
         MISO       : IN     std_logic_vector(N_ADC-1 DOWNTO 0);
         OUT_ACK    : IN     std_logic;
         RdEn       : IN     std_ulogic;
         STATUS_EN  : IN     std_logic;
         rst        : IN     std_logic;
         CS_B       : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
         DATA_READY : OUT    std_logic;
         ERR        : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
         INTS       : OUT    std_logic_vector(32*N_ADC-1 DOWNTO 0);
         MOSI       : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
         SCLK       : OUT    std_logic_vector(N_ADC-1 DOWNTO 0)
      );
   END COMPONENT;

   COMPONENT adc_nadc_tester
      GENERIC (
         N_ADC     : integer range 4 downto 0      := 2;
         RATE_DEF  : std_logic_vector (4 DOWNTO 0) := "11111";
         NBITSHIFT : integer range 31 downto 0     := 1
      );
      PORT (
         ADD_EN     : OUT    std_logic;
         CLR        : OUT    std_logic;
         F8M        : OUT    std_ulogic;
         MISO       : OUT    std_logic_vector(N_ADC-1 DOWNTO 0);
         OUT_ACK    : OUT    std_logic;
         RdEn       : OUT    std_ulogic;
         STATUS_EN  : OUT    std_logic;
         rst        : OUT    std_logic;
         CS_B       : IN     std_logic_vector(N_ADC-1 DOWNTO 0);
         DATA_READY : IN     std_logic;
         ERR        : IN     std_logic_vector(N_ADC-1 DOWNTO 0);
         INTS       : IN     std_logic_vector(32*N_ADC-1 DOWNTO 0);
         MOSI       : IN     std_logic_vector(N_ADC-1 DOWNTO 0);
         SCLK       : IN     std_logic_vector(N_ADC-1 DOWNTO 0)
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR U_0 : adc_nadc USE ENTITY idx_fpga_lib.adc_nadc;
   FOR U_1 : adc_nadc_tester USE ENTITY idx_fpga_lib.adc_nadc_tester;
   -- pragma synthesis_on

BEGIN

         U_0 : adc_nadc
            GENERIC MAP (
               N_ADC     => N_ADC,
               RATE_DEF  => RATE_DEF,
               NBITSHIFT => NBITSHIFT
            )
            PORT MAP (
               ADD_EN     => ADD_EN,
               CLR        => CLR,
               F8M        => F8M,
               MISO       => MISO,
               OUT_ACK    => OUT_ACK,
               RdEn       => RdEn,
               STATUS_EN  => STATUS_EN,
               rst        => rst,
               CS_B       => CS_B,
               DATA_READY => DATA_READY,
               ERR        => ERR,
               INTS       => INTS,
               MOSI       => MOSI,
               SCLK       => SCLK
            );

         U_1 : adc_nadc_tester
            GENERIC MAP (
               N_ADC     => N_ADC,
               RATE_DEF  => RATE_DEF,
               NBITSHIFT => NBITSHIFT
            )
            PORT MAP (
               ADD_EN     => ADD_EN,
               CLR        => CLR,
               F8M        => F8M,
               MISO       => MISO,
               OUT_ACK    => OUT_ACK,
               RdEn       => RdEn,
               STATUS_EN  => STATUS_EN,
               rst        => rst,
               CS_B       => CS_B,
               DATA_READY => DATA_READY,
               ERR        => ERR,
               INTS       => INTS,
               MOSI       => MOSI,
               SCLK       => SCLK
            );


END rtl;