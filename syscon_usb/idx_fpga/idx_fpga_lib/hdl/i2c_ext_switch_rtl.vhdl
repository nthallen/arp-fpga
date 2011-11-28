--
-- VHDL Architecture idx_fpga_lib.i2c_ext_switch.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:23:36 11/28/2011
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY i2c_ext_switch IS
   GENERIC (
     N_SWBITS : NATURAL range 8 downto 2 := 8;
     I2C_ADDR : std_logic_vector(6 downto 0) := "1110000"
   );
   PORT (
      clk   : IN     std_ulogic;
      m_scl : INOUT  std_logic_vector(N_SWBITS DOWNTO 0);
      m_sda : INOUT  std_logic_vector(N_SWBITS DOWNTO 0);
      rst   : IN     std_ulogic;
      scl   : INOUT  std_logic;
      sda   : INOUT  std_logic
   );
END i2c_ext_switch;

--
ARCHITECTURE rtl OF i2c_ext_switch IS
   SIGNAL wdata : std_ulogic_vector(7 DOWNTO 0);
   SIGNAL sdapad_i    : std_logic;
   SIGNAL sclpad_i    : std_logic;
   SIGNAL ien      : std_logic_vector(N_SWBITS DOWNTO 0);
   SIGNAL di       : std_logic;
   SIGNAL doen_o   : std_logic;
   SIGNAL dio      : std_logic;
   SIGNAL dadi     : std_logic;
   SIGNAL dadoen_o : std_logic;
   SIGNAL cldi     : std_logic;
   SIGNAL cldoen_o : std_logic;

   COMPONENT i2c_slave
      GENERIC (
         I2C_ADDR : std_logic_vector(6 DOWNTO 0) := "1000000"
      );
      PORT (
         clk   : IN     std_ulogic;
         rst   : IN     std_ulogic;
         scl   : IN     std_logic;
         wdata : OUT    std_ulogic_vector(7 DOWNTO 0);
         sda   : INOUT  std_logic
      );
   END COMPONENT i2c_slave;
   COMPONENT i2c_half_switch
      GENERIC (
         N_ISBITS : integer range 20 downto 2 := 4
      );
      PORT (
         En       : IN     std_ulogic_vector(N_ISBITS-1 DOWNTO 0);
         pad_o    : IN     std_logic;
         padoen_o : IN     std_logic;
         pad_i    : OUT    std_logic;
         pad      : INOUT  std_logic_vector(N_ISBITS-1 DOWNTO 0)
      );
   END COMPONENT i2c_half_switch;
   COMPONENT i2c_demux
      PORT (
         clk    : IN     std_logic;
         di     : IN     std_logic;
         rst    : IN     std_logic;
         doen_o : OUT    std_logic;
         dio    : INOUT  std_logic
      );
   END COMPONENT i2c_demux;
   FOR ALL : i2c_slave USE ENTITY idx_fpga_lib.i2c_slave;
   FOR ALL : i2c_half_switch USE ENTITY idx_fpga_lib.i2c_half_switch;
   FOR ALL : i2c_demux USE ENTITY idx_fpga_lib.i2c_demux;
BEGIN
   
   dadm : i2c_demux
      PORT MAP (
         clk    => clk,
         rst    => rst,
         di     => dadi,
         doen_o => dadoen_o,
         dio    => sda
      );

   cldm : i2c_demux
      PORT MAP (
         clk    => clk,
         rst    => rst,
         di     => cldi,
         doen_o => cldoen_o,
         dio    => scl
      );
   
   mux_ctrl : i2c_slave
      GENERIC MAP (
         I2C_ADDR => I2C_ADDR
      )
      PORT MAP (
         clk   => clk,
         rst   => rst,
         scl   => m_scl(N_SWBITS),
         sda   => m_sda(N_SWBITS),
         wdata => wdata
      );
   
   sda_sw : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => N_SWBITS+1
      )
      PORT MAP (
         En       => std_ulogic_vector(ien),
         pad_o    => '0',
         padoen_o => dadoen_o,
         pad_i    => dadi,
         pad      => m_sda
      );
      
   scl_sw : i2c_half_switch
      GENERIC MAP (
         N_ISBITS => N_SWBITS+1
      )
      PORT MAP (
         En       => std_ulogic_vector(ien),
         pad_o    => '0',
         padoen_o => cldoen_o,
         pad_i    => cldi,
         pad => m_scl
      );

  ien(N_SWBITS) <= '1';
  ien(N_SWBITS-1 DOWNTO 0) <= std_logic_vector(wdata);
  m_sda(N_SWBITS) <= 'H';
  m_scl(N_SWBITS) <= 'H';    
      
END ARCHITECTURE rtl;

