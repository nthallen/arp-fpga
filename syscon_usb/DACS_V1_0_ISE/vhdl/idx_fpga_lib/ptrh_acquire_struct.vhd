-- VHDL Entity idx_fpga_lib.ptrh_acquire.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:06:52 04/20/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ptrh_acquire IS
   PORT( 
      F8M   : IN     std_ulogic;
      Full  : IN     std_ulogic_vector (12 DOWNTO 0);
      rst   : IN     std_ulogic;
      WrEn  : OUT    std_ulogic_vector (12 DOWNTO 0);
      wData : OUT    std_logic_vector (23 DOWNTO 0);
      scl   : INOUT  std_logic;
      sda   : INOUT  std_logic
   );

-- Declarations

END ptrh_acquire ;

--
-- VHDL Architecture idx_fpga_lib.ptrh_acquire.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:06:52 04/20/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF ptrh_acquire IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Done      : std_logic;
   SIGNAL Err       : std_logic;
   SIGNAL Rd        : std_logic;
   SIGNAL Rd3       : std_logic;
   SIGNAL Wr        : std_logic;
   SIGNAL WrStop    : std_logic;
   SIGNAL i2c_addr  : std_logic_vector(6 DOWNTO 0);
   SIGNAL i2c_rdata : std_logic_vector(23 DOWNTO 0);
   SIGNAL i2c_wdata : std_logic_vector(7 DOWNTO 0);
   SIGNAL wb_ack_o  : std_logic;
   SIGNAL wb_adr_i  : std_logic_vector(2 DOWNTO 0);
   SIGNAL wb_cyc_i  : std_logic;
   SIGNAL wb_dat_i  : std_logic_vector(7 DOWNTO 0);
   SIGNAL wb_dat_o  : std_logic_vector(7 DOWNTO 0);
   SIGNAL wb_inta_o : std_logic;
   SIGNAL wb_stb_i  : std_logic;
   SIGNAL wb_we_i   : std_logic;


   -- Component Declarations
   COMPONENT ptrh_acq_sm
   PORT (
      Done      : IN     std_logic ;
      Err       : IN     std_logic ;
      F8M       : IN     std_ulogic ;
      Full      : IN     std_ulogic_vector (12 DOWNTO 0);
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
      rst       : IN     std_ulogic ;
      Rd        : OUT    std_logic ;
      Rd3       : OUT    std_logic ;
      Wr        : OUT    std_logic ;
      WrEn      : OUT    std_ulogic_vector (12 DOWNTO 0);
      WrStop    : OUT    std_logic ;
      i2c_addr  : OUT    std_logic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      wData     : OUT    std_logic_vector (23 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT ptrh_i2c
   PORT (
      F8M       : IN     std_ulogic;
      rst       : IN     std_ulogic;
      wb_adr_i  : IN     std_logic_vector (2 DOWNTO 0);
      wb_cyc_i  : IN     std_logic;
      wb_dat_i  : IN     std_logic_vector (7 DOWNTO 0);
      wb_stb_i  : IN     std_logic;
      wb_we_i   : IN     std_logic;
      wb_ack_o  : OUT    std_logic;
      wb_dat_o  : OUT    std_logic_vector (7 DOWNTO 0);
      wb_inta_o : OUT    std_logic;
      scl       : INOUT  std_logic;
      sda       : INOUT  std_logic
   );
   END COMPONENT;
   COMPONENT ptrh_i2c_sm
   PORT (
      F8M       : IN     std_ulogic ;
      Rd        : IN     std_logic ;
      Rd3       : IN     std_logic ;
      Wr        : IN     std_logic ;
      WrStop    : IN     std_logic ;
      i2c_addr  : IN     std_logic_vector (6 DOWNTO 0);
      i2c_wdata : IN     std_logic_vector (7 DOWNTO 0);
      rst       : IN     std_ulogic ;
      wb_ack_o  : IN     std_logic ;
      wb_dat_o  : IN     std_logic_vector (7 DOWNTO 0);
      wb_inta_o : IN     std_logic ;
      Done      : OUT    std_logic ;
      Err       : OUT    std_logic ;
      i2c_rdata : OUT    std_logic_vector (23 DOWNTO 0);
      wb_adr_i  : OUT    std_logic_vector (2 DOWNTO 0);
      wb_cyc_i  : OUT    std_logic ;
      wb_dat_i  : OUT    std_logic_vector (7 DOWNTO 0);
      wb_stb_i  : OUT    std_logic ;
      wb_we_i   : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : ptrh_acq_sm USE ENTITY idx_fpga_lib.ptrh_acq_sm;
   FOR ALL : ptrh_i2c USE ENTITY idx_fpga_lib.ptrh_i2c;
   FOR ALL : ptrh_i2c_sm USE ENTITY idx_fpga_lib.ptrh_i2c_sm;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   acq_sm : ptrh_acq_sm
      PORT MAP (
         Done      => Done,
         Err       => Err,
         F8M       => F8M,
         Full      => Full,
         i2c_rdata => i2c_rdata,
         rst       => rst,
         Rd        => Rd,
         Rd3       => Rd3,
         Wr        => Wr,
         WrEn      => WrEn,
         WrStop    => WrStop,
         i2c_addr  => i2c_addr,
         i2c_wdata => i2c_wdata,
         wData     => wData
      );
   i2c : ptrh_i2c
      PORT MAP (
         F8M       => F8M,
         rst       => rst,
         wb_adr_i  => wb_adr_i,
         wb_cyc_i  => wb_cyc_i,
         wb_dat_i  => wb_dat_i,
         wb_stb_i  => wb_stb_i,
         wb_we_i   => wb_we_i,
         scl       => scl,
         sda       => sda,
         wb_ack_o  => wb_ack_o,
         wb_dat_o  => wb_dat_o,
         wb_inta_o => wb_inta_o
      );
   i2c_sm : ptrh_i2c_sm
      PORT MAP (
         F8M       => F8M,
         Rd        => Rd,
         Rd3       => Rd3,
         Wr        => Wr,
         WrStop    => WrStop,
         i2c_addr  => i2c_addr,
         i2c_wdata => i2c_wdata,
         rst       => rst,
         wb_ack_o  => wb_ack_o,
         wb_dat_o  => wb_dat_o,
         wb_inta_o => wb_inta_o,
         Done      => Done,
         Err       => Err,
         i2c_rdata => i2c_rdata,
         wb_adr_i  => wb_adr_i,
         wb_cyc_i  => wb_cyc_i,
         wb_dat_i  => wb_dat_i,
         wb_stb_i  => wb_stb_i,
         wb_we_i   => wb_we_i
      );

END struct;
