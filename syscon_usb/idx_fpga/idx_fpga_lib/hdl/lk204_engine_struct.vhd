-- VHDL Entity idx_fpga_lib.lk204_engine.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:22:33 09/17/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY lk204_engine IS
   PORT( 
      CharData     : IN     std_logic_vector (8 DOWNTO 0);
      Empty        : IN     std_logic;
      F8M          : IN     std_ulogic;
      Full         : IN     std_logic;
      Rst          : IN     std_logic;
      scl_pad_i    : IN     std_logic;
      sda_pad_i    : IN     std_logic;
      RE           : OUT    std_logic;
      SData        : OUT    std_logic_vector (7 DOWNTO 0);
      Status       : OUT    std_logic_vector (15 DOWNTO 0);
      WE           : OUT    std_logic;
      scl_pad_o    : OUT    std_logic;                       -- i2c clock line output
      scl_padoen_o : OUT    std_logic;                       -- i2c clock line output enable, active low
      sda_pad_o    : OUT    std_logic;                       -- i2c data line output
      sda_padoen_o : OUT    std_logic                        -- i2c data line output enable, active low
   );

-- Declarations

END lk204_engine ;

--
-- VHDL Architecture idx_fpga_lib.lk204_engine.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:22:33 09/17/2012
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2012.1 (Build 6)
--
--  Copyright 2011 President and Fellows of Harvard College
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF lk204_engine IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Done      : std_logic;
   SIGNAL Err       : std_logic;
   SIGNAL I2Crdata  : std_logic_vector(7 DOWNTO 0);
   SIGNAL I2Cwdata  : std_logic_vector(7 DOWNTO 0);
   SIGNAL RdI2C     : std_logic;
   SIGNAL TOrst     : std_logic;
   SIGNAL WrI2C     : std_logic;
   SIGNAL WrStart   : std_logic;
   SIGNAL WrStop    : std_logic;
   SIGNAL arst_i    : std_logic;                       -- asynchronous reset
   SIGNAL timeout   : std_logic;
   SIGNAL wb_ack_o  : std_logic;                       -- Bus cycle acknowledge output
   SIGNAL wb_adr_i  : std_logic_vector(2 DOWNTO 0);    -- lower address bits
   SIGNAL wb_cyc_i  : std_logic;                       -- Valid bus cycle input
   SIGNAL wb_dat_i  : std_logic_vector(7 DOWNTO 0);    -- Databus input
   SIGNAL wb_dat_o  : std_logic_vector(7 DOWNTO 0);    -- Databus output
   SIGNAL wb_inta_o : std_logic;                       -- interrupt request output signal
   SIGNAL wb_stb_i  : std_logic;                       -- Strobe signals / core select signal
   SIGNAL wb_we_i   : std_logic;                       -- Write enable input


   -- Component Declarations
   COMPONENT i2c_master_top
   GENERIC (
      ARST_LVL : std_logic := '0'      -- asynchronous reset level
   );
   PORT (
      -- wishbone signals
      wb_clk_i     : IN     std_logic ;                    -- master clock input
      wb_rst_i     : IN     std_logic  := '0';             -- synchronous active high reset
      arst_i       : IN     std_logic  := not ARST_LVL;    -- asynchronous reset
      wb_adr_i     : IN     std_logic_vector (2 DOWNTO 0); -- lower address bits
      wb_dat_i     : IN     std_logic_vector (7 DOWNTO 0); -- Databus input
      wb_dat_o     : OUT    std_logic_vector (7 DOWNTO 0); -- Databus output
      wb_we_i      : IN     std_logic ;                    -- Write enable input
      wb_stb_i     : IN     std_logic ;                    -- Strobe signals / core select signal
      wb_cyc_i     : IN     std_logic ;                    -- Valid bus cycle input
      wb_ack_o     : OUT    std_logic ;                    -- Bus cycle acknowledge output
      wb_inta_o    : OUT    std_logic ;                    -- interrupt request output signal
      -- i2c lines
      scl_pad_i    : IN     std_logic ;                    -- i2c clock line input
      scl_pad_o    : OUT    std_logic ;                    -- i2c clock line output
      scl_padoen_o : OUT    std_logic ;                    -- i2c clock line output enable, active low
      sda_pad_i    : IN     std_logic ;                    -- i2c data line input
      sda_pad_o    : OUT    std_logic ;                    -- i2c data line output
      sda_padoen_o : OUT    std_logic                      -- i2c data line output enable, active low
   );
   END COMPONENT;
   COMPONENT lk204_i2c
   GENERIC (
      I2C_CLK_PRESCALE : std_logic_vector(15 DOWNTO 0) := X"000E"
   );
   PORT (
      F8M       : IN     std_ulogic ;
      I2Cwdata  : IN     std_logic_vector (7 DOWNTO 0);
      RdI2C     : IN     std_logic ;
      Rst       : IN     std_logic ;
      WrI2C     : IN     std_logic ;
      WrStart   : IN     std_logic ;
      WrStop    : IN     std_logic ;
      wb_ack_o  : IN     std_logic ;                    -- Bus cycle acknowledge output
      wb_dat_o  : IN     std_logic_vector (7 DOWNTO 0); -- Databus output
      wb_inta_o : IN     std_logic ;                    -- interrupt request output signal
      Done      : OUT    std_logic ;
      Err       : OUT    std_logic ;
      I2Crdata  : OUT    std_logic_vector (7 DOWNTO 0);
      arst_i    : OUT    std_logic ;                    -- asynchronous reset
      wb_adr_i  : OUT    std_logic_vector (2 DOWNTO 0); -- lower address bits
      wb_cyc_i  : OUT    std_logic ;                    -- Valid bus cycle input
      wb_dat_i  : OUT    std_logic_vector (7 DOWNTO 0); -- Databus input
      wb_stb_i  : OUT    std_logic ;                    -- Strobe signals / core select signal
      wb_we_i   : OUT    std_logic                      -- Write enable input
   );
   END COMPONENT;
   COMPONENT lk204_sm
   PORT (
      CharData : IN     std_logic_vector (8 DOWNTO 0);
      Done     : IN     std_logic ;
      Empty    : IN     std_logic ;
      Err      : IN     std_logic ;
      F8M      : IN     std_ulogic ;
      Full     : IN     std_logic ;
      I2Crdata : IN     std_logic_vector (7 DOWNTO 0);
      Rst      : IN     std_logic ;
      timeout  : IN     std_logic ;
      I2Cwdata : OUT    std_logic_vector (7 DOWNTO 0);
      RE       : OUT    std_logic ;
      RdI2C    : OUT    std_logic ;
      SData    : OUT    std_logic_vector (7 DOWNTO 0);
      Status   : OUT    std_logic_vector (15 DOWNTO 0);
      TOrst    : OUT    std_logic ;
      WE       : OUT    std_logic ;
      WrI2C    : OUT    std_logic ;
      WrStart  : OUT    std_logic ;
      WrStop   : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT lk204_to
   PORT (
      F8M     : IN     std_ulogic ;
      Rst     : IN     std_logic ;
      TOrst   : IN     std_logic ;
      timeout : OUT    std_logic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : i2c_master_top USE ENTITY idx_fpga_lib.i2c_master_top;
   FOR ALL : lk204_i2c USE ENTITY idx_fpga_lib.lk204_i2c;
   FOR ALL : lk204_sm USE ENTITY idx_fpga_lib.lk204_sm;
   FOR ALL : lk204_to USE ENTITY idx_fpga_lib.lk204_to;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   i2c_top : i2c_master_top
      GENERIC MAP (
         ARST_LVL => '0'         -- asynchronous reset level
      )
      PORT MAP (
         wb_clk_i     => F8M,
         wb_rst_i     => Rst,
         arst_i       => arst_i,
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
   EngI2C : lk204_i2c
      GENERIC MAP (
         I2C_CLK_PRESCALE => X"000E"
      )
      PORT MAP (
         F8M       => F8M,
         I2Cwdata  => I2Cwdata,
         RdI2C     => RdI2C,
         Rst       => Rst,
         WrI2C     => WrI2C,
         WrStart   => WrStart,
         WrStop    => WrStop,
         wb_ack_o  => wb_ack_o,
         wb_dat_o  => wb_dat_o,
         wb_inta_o => wb_inta_o,
         Done      => Done,
         Err       => Err,
         I2Crdata  => I2Crdata,
         arst_i    => arst_i,
         wb_adr_i  => wb_adr_i,
         wb_cyc_i  => wb_cyc_i,
         wb_dat_i  => wb_dat_i,
         wb_stb_i  => wb_stb_i,
         wb_we_i   => wb_we_i
      );
   EngSM : lk204_sm
      PORT MAP (
         CharData => CharData,
         Done     => Done,
         Empty    => Empty,
         Err      => Err,
         F8M      => F8M,
         Full     => Full,
         I2Crdata => I2Crdata,
         Rst      => Rst,
         timeout  => timeout,
         I2Cwdata => I2Cwdata,
         RE       => RE,
         RdI2C    => RdI2C,
         SData    => SData,
         Status   => Status,
         TOrst    => TOrst,
         WE       => WE,
         WrI2C    => WrI2C,
         WrStart  => WrStart,
         WrStop   => WrStop
      );
   poll_to : lk204_to
      PORT MAP (
         F8M     => F8M,
         Rst     => Rst,
         TOrst   => TOrst,
         timeout => timeout
      );

END struct;