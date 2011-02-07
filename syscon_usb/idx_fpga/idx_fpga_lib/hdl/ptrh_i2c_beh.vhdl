--
-- VHDL Architecture idx_fpga_lib.ptrh_i2c.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:38:21 02/ 6/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY ptrh_i2c IS
   PORT( 
      F25M      : IN     std_ulogic;
      rst       : IN     std_ulogic;
      wb_adr_i  : IN     std_logic_vector (2 DOWNTO 0);
      wb_cyc_i  : IN     std_logic;
      wb_dat_i  : IN     std_logic_vector (7 DOWNTO 0);
      wb_stb_i  : IN     std_logic;
      wb_we_i   : IN     std_logic;
      scl       : INOUT  std_logic;
      sda       : INOUT  std_logic;
      wb_ack_o  : OUT    std_logic;
      wb_dat_o  : OUT    std_logic_vector (7 DOWNTO 0);
      wb_inta_o : OUT    std_logic
   );

-- Declarations

END ptrh_i2c ;

--
ARCHITECTURE beh OF ptrh_i2c IS
   SIGNAL scl_pad_i    : std_logic;
   SIGNAL scl_pad_o    : std_logic;
   SIGNAL scl_padoen_o : std_logic;
   SIGNAL sda_pad_i    : std_logic;
   SIGNAL sda_pad_o    : std_logic;
   SIGNAL sda_padoen_o : std_logic;
   COMPONENT i2c_master_top
      GENERIC (
         ARST_LVL : std_logic := '0'
      );
      PORT (
         wb_clk_i     : IN     std_logic;
         wb_rst_i     : IN     std_logic;
         arst_i       : IN     std_logic;
         wb_adr_i     : IN     std_logic_vector(2 downto 0);
         wb_dat_i     : IN     std_logic_vector(7 downto 0);
         wb_dat_o     : OUT    std_logic_vector(7 downto 0);
         wb_we_i      : IN     std_logic;
         wb_stb_i     : IN     std_logic;
         wb_cyc_i     : IN     std_logic;
         wb_ack_o     : OUT    std_logic;
         wb_inta_o    : OUT    std_logic;
         scl_pad_i    : IN     std_logic;
         scl_pad_o    : OUT    std_logic;
         scl_padoen_o : OUT    std_logic;
         sda_pad_i    : IN     std_logic;
         sda_pad_o    : OUT    std_logic;
         sda_padoen_o : OUT    std_logic
      );
   END COMPONENT;
   FOR ALL : i2c_master_top USE ENTITY idx_fpga_lib.i2c_master_top;
BEGIN
   --  hds hds_inst
   i2c_master : i2c_master_top
      GENERIC MAP (
         ARST_LVL => '0'
      )
      PORT MAP (
         wb_clk_i     => F25M,
         wb_rst_i     => rst,
         arst_i       => '1',
         wb_adr_i     => wb_adr_i,
         wb_dat_i     => wb_dat_i,
         wb_dat_o     => wb_dat_o,
         wb_we_i      => wb_we_i,
         wb_stb_i     => wb_stb_i,
         wb_cyc_i     => wb_cyc_i,
         wb_ack_o     => wb_ack_o,
         wb_inta_o    => wb_inta_o,
         scl_pad_i    => scl_pad_i,
         scl_pad_o    => scl_pad_o,
         scl_padoen_o => scl_padoen_o,
         sda_pad_i    => sda_pad_i,
         sda_pad_o    => sda_pad_o,
         sda_padoen_o => sda_padoen_o
      );
  
  sda_proc : Process (sda_padoen_o, sda_pad_o) IS
  Begin
    if sda_padoen_o = '0' then
      sda <= sda_pad_o;
    else
      sda <= 'Z';
    end if;
  End Process;
  sda_pad_i <= sda;

  scl_proc : Process (scl_padoen_o, scl_pad_o) IS
  Begin
    if scl_padoen_o = '0' then
      scl <= scl_pad_o;
    else
      scl <= 'Z';
    end if;
  End Process;
  scl_pad_i <= scl;
  
END ARCHITECTURE beh;

