-- VHDL Entity idx_fpga_lib.i2c_slave.symbol
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:47:27 07/27/2016
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY i2c_slave IS
  GENERIC( 
    I2C_ADDR : std_logic_vector(6 DOWNTO 0) := "1000000"
  );
  PORT( 
    clk   : IN     std_ulogic;
    rdata : IN     std_logic_vector (7 DOWNTO 0);
    rst   : IN     std_ulogic;
    scl   : IN     std_logic;
    WE    : OUT    std_logic;
    start : OUT    std_ulogic;
    wdata : OUT    std_ulogic_vector (7 DOWNTO 0);
    RE    : INOUT  std_logic;
    sda   : INOUT  std_logic
  );

-- Declarations

END ENTITY i2c_slave ;

--
-- VHDL Architecture idx_fpga_lib.i2c_slave.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 11:47:27 07/27/2016
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2016.1 (Build 8)
--

-- Generation properties:
--   Component declarations : yes
--   Configurations         : embedded statements
--                          : add pragmas
--                          : exclude view name
--   
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF i2c_slave IS

  -- Architecture declarations

  -- Internal signal declarations
  SIGNAL err  : std_ulogic;
  SIGNAL stop : std_ulogic;

  -- Implicit buffer signal declarations
  SIGNAL start_internal : std_ulogic;


  -- Component Declarations
  COMPONENT i2c_slave_bits
  GENERIC (
    I2C_ADDR : std_logic_vector(6 downto 0) := "1000000"
  );
  PORT (
    clk   : IN     std_ulogic ;
    err   : IN     std_ulogic ;
    rdata : IN     std_logic_vector (7 DOWNTO 0);
    rst   : IN     std_ulogic ;
    scl   : IN     std_logic ;
    start : IN     std_ulogic ;
    stop  : IN     std_ulogic ;
    WE    : OUT    std_logic ;
    wdata : OUT    std_ulogic_vector (7 DOWNTO 0);
    RE    : INOUT  std_logic ;
    sda   : INOUT  std_logic 
  );
  END COMPONENT i2c_slave_bits;
  COMPONENT i2c_slave_sup
  PORT (
    clk    : IN     std_ulogic ;
    rst    : IN     std_ulogic ;
    scl_in : IN     std_logic ;
    sda_in : IN     std_logic ;
    err    : OUT    std_ulogic ;
    start  : OUT    std_ulogic ;
    stop   : OUT    std_ulogic 
  );
  END COMPONENT i2c_slave_sup;

  -- Optional embedded configurations
  -- pragma synthesis_off
  FOR ALL : i2c_slave_bits USE ENTITY idx_fpga_lib.i2c_slave_bits;
  FOR ALL : i2c_slave_sup USE ENTITY idx_fpga_lib.i2c_slave_sup;
  -- pragma synthesis_on


BEGIN

  -- Instance port mappings.
  U_0 : i2c_slave_bits
    GENERIC MAP (
      I2C_ADDR => I2C_ADDR
    )
    PORT MAP (
      clk   => clk,
      err   => err,
      rdata => rdata,
      rst   => rst,
      scl   => scl,
      start => start_internal,
      stop  => stop,
      WE    => WE,
      wdata => wdata,
      RE    => RE,
      sda   => sda
    );
  U_1 : i2c_slave_sup
    PORT MAP (
      clk    => clk,
      rst    => rst,
      scl_in => scl,
      sda_in => sda,
      err    => err,
      start  => start_internal,
      stop   => stop
    );

  -- Implicit buffered output assignments
  start <= start_internal;

END ARCHITECTURE struct;
