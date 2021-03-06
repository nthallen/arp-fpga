-- VHDL Entity idx_fpga_lib.bench_ptrhm_i2c_sm.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:45:07 11/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--


ENTITY bench_ptrhm_i2c_sm IS
   GENERIC( 
      N_ISBITS : integer := 2
   );
-- Declarations

END bench_ptrhm_i2c_sm ;

--
-- VHDL Architecture idx_fpga_lib.bench_ptrhm_i2c_sm.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:45:07 11/ 7/2011
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ptrhm.ALL;


ARCHITECTURE struct OF bench_ptrhm_i2c_sm IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL En           : std_ulogic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL F8M          : std_ulogic;
   SIGNAL arst_i       : std_logic;
   SIGNAL cmd          : ptrhm_i2c_op;
   SIGNAL done         : std_ulogic;
   SIGNAL err          : std_ulogic;
   SIGNAL i2c_addr     : std_ulogic_vector(6 DOWNTO 0);
   SIGNAL i2c_rdata    : std_logic_vector(23 DOWNTO 0);
   SIGNAL i2c_wdata    : std_logic_vector(7 DOWNTO 0);
   SIGNAL pad_i        : std_logic;
   SIGNAL pad_i1       : std_logic;
   SIGNAL rst          : std_ulogic;
   SIGNAL scl          : std_logic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL scl_pad_o    : std_logic;
   SIGNAL scl_padoen_o : std_logic;
   SIGNAL sda          : std_logic_vector(N_ISBITS-1 DOWNTO 0);
   SIGNAL sda_pad_o    : std_logic;
   SIGNAL sda_padoen_o : std_logic;
   SIGNAL wb_ack_o     : std_logic;
   SIGNAL wb_adr_i     : std_logic_vector(2 DOWNTO 0);
   SIGNAL wb_cyc_i     : std_logic;
   SIGNAL wb_dat_i     : std_logic_vector(7 DOWNTO 0);
   SIGNAL wb_dat_o     : std_logic_vector(7 DOWNTO 0);
   SIGNAL wb_inta_o    : std_logic;
   SIGNAL wb_stb_i     : std_logic;
   SIGNAL wb_we_i      : std_logic;


   -- Component Declarations
   COMPONENT bench_ptrhm_i2c_sm_tester
   GENERIC (
      N_ISBITS : integer range 20 DOWNTO 2
   );
   PORT (
      done      : IN     std_ulogic ;
      err       : IN     std_ulogic ;
      i2c_rdata : IN     std_logic_vector (23 DOWNTO 0);
      scl       : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      sda       : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0);
      En        : OUT    std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      F8M       : OUT    std_ulogic ;
      cmd       : OUT    ptrhm_i2c_op ;
      i2c_addr  : OUT    std_ulogic_vector (6 DOWNTO 0);
      i2c_wdata : OUT    std_logic_vector (7 DOWNTO 0);
      rst       : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT i2c_half_switch
   GENERIC (
      N_ISBITS : integer range 20 downto 2 := 4
   );
   PORT (
      En       : IN     std_ulogic_vector (N_ISBITS-1 DOWNTO 0);
      pad_o    : IN     std_logic;
      padoen_o : IN     std_logic;
      pad_i    : OUT    std_logic;
      pad      : INOUT  std_logic_vector (N_ISBITS-1 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT i2c_master_top
   GENERIC (
      ARST_LVL : std_logic := '0'      -- asynchronous reset level
   );
   PORT (
      arst_i       : IN     std_logic  := not ARST_LVL;
      scl_pad_i    : IN     std_logic;
      sda_pad_i    : IN     std_logic;
      wb_adr_i     : IN     std_logic_vector (2 DOWNTO 0);
      wb_clk_i     : IN     std_logic;
      wb_cyc_i     : IN     std_logic;
      wb_dat_i     : IN     std_logic_vector (7 DOWNTO 0);
      wb_rst_i     : IN     std_logic  := '0';
      wb_stb_i     : IN     std_logic;
      wb_we_i      : IN     std_logic;
      scl_pad_o    : OUT    std_logic;
      scl_padoen_o : OUT    std_logic;
      sda_pad_o    : OUT    std_logic;
      sda_padoen_o : OUT    std_logic;
      wb_ack_o     : OUT    std_logic;
      wb_dat_o     : OUT    std_logic_vector (7 DOWNTO 0);
      wb_inta_o    : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT i2c_slave
   GENERIC (
      I2C_ADDR : std_logic_vector(6 DOWNTO 0) := "1000000"
   );
   PORT (
      clk : IN     std_ulogic ;
      rst : IN     std_ulogic ;
      scl : IN     std_logic ;
      sda : INOUT  std_logic 
   );
   END COMPONENT;
   COMPONENT ptrhm_i2c_sm
   PORT (
      F8M       : IN     std_ulogic ;
      cmd       : IN     ptrhm_i2c_op ;
      i2c_addr  : IN     std_ulogic_vector (6 DOWNTO 0);
      i2c_wdata : IN     std_logic_vector (7 DOWNTO 0);
      rst       : IN     std_ulogic ;
      wb_ack_o  : IN     std_logic ;
      wb_dat_o  : IN     std_logic_vector (7 DOWNTO 0);
      wb_inta_o : IN     std_logic ;
      arst_i    : OUT    std_logic ;
      done      : OUT    std_ulogic ;
      err       : OUT    std_ulogic ;
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
   FOR ALL : bench_ptrhm_i2c_sm_tester USE ENTITY idx_fpga_lib.bench_ptrhm_i2c_sm_tester;
   FOR ALL : i2c_half_switch USE ENTITY idx_fpga_lib.i2c_half_switch;
   FOR ALL : i2c_master_top USE ENTITY idx_fpga_lib.i2c_master_top;
   FOR ALL : i2c_slave USE ENTITY idx_fpga_lib.i2c_slave;
   FOR ALL : ptrhm_i2c_sm USE ENTITY idx_fpga_lib.ptrhm_i2c_sm;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   U_1 : bench_ptrhm_i2c_sm_tester
      GENERIC MAP (
         N_ISBITS => N_ISBITS
      )
      PORT MAP (
         done      => done,
         err       => err,
         i2c_rdata => i2c_rdata,
         scl       => scl,
         sda       => sda,
         En        => En,
         F8M       => F8M,
         cmd       => cmd,
         i2c_addr  => i2c_addr,
         i2c_wdata => i2c_wdata,
         rst       => rst
      );
   U_4 : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => N_ISBITS
      )
      PORT MAP (
         En       => En,
         pad_o    => scl_pad_o,
         padoen_o => scl_padoen_o,
         pad_i    => pad_i,
         pad      => scl
      );
   U_5 : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => N_ISBITS
      )
      PORT MAP (
         En       => En,
         pad_o    => sda_pad_o,
         padoen_o => sda_padoen_o,
         pad_i    => pad_i1,
         pad      => sda
      );
   U_2 : i2c_master_top
      GENERIC MAP (
         ARST_LVL => '0'         -- asynchronous reset level
      )
      PORT MAP (
         wb_clk_i     => F8M,
         wb_rst_i     => rst,
         arst_i       => arst_i,
         wb_adr_i     => wb_adr_i,
         wb_dat_i     => wb_dat_i,
         wb_dat_o     => wb_dat_o,
         wb_we_i      => wb_we_i,
         wb_stb_i     => wb_stb_i,
         wb_cyc_i     => wb_cyc_i,
         wb_ack_o     => wb_ack_o,
         wb_inta_o    => wb_inta_o,
         scl_pad_i    => pad_i,
         scl_pad_o    => scl_pad_o,
         scl_padoen_o => scl_padoen_o,
         sda_pad_i    => pad_i1,
         sda_pad_o    => sda_pad_o,
         sda_padoen_o => sda_padoen_o
      );
   U_3 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1000000"
      )
      PORT MAP (
         clk => F8M,
         rst => rst,
         scl => scl(0),
         sda => sda(0)
      );
   U_6 : i2c_slave
      GENERIC MAP (
         I2C_ADDR => "1110000"
      )
      PORT MAP (
         clk => F8M,
         rst => rst,
         scl => scl(1),
         sda => sda(1)
      );
   U_0 : ptrhm_i2c_sm
      PORT MAP (
         F8M       => F8M,
         cmd       => cmd,
         i2c_addr  => i2c_addr,
         i2c_wdata => i2c_wdata,
         rst       => rst,
         wb_ack_o  => wb_ack_o,
         wb_dat_o  => wb_dat_o,
         wb_inta_o => wb_inta_o,
         arst_i    => arst_i,
         done      => done,
         err       => err,
         i2c_rdata => i2c_rdata,
         wb_adr_i  => wb_adr_i,
         wb_cyc_i  => wb_cyc_i,
         wb_dat_i  => wb_dat_i,
         wb_stb_i  => wb_stb_i,
         wb_we_i   => wb_we_i
      );

END struct;
