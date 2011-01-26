--
-- VHDL Architecture idx_fpga_lib.Digio.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:35:48 09/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY DigIO IS
  GENERIC (
    DIGIO_BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
    DIGIO_N_CONNECTORS : integer range 4 DOWNTO 1 := 2;
    DIGIO_FORCE_DIR : std_ulogic_vector := "000000000000";
    DIGIO_FORCE_DIR_VAL : std_ulogic_vector := "000000000000"
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    Data    : INOUT  std_logic_vector (15 DOWNTO 0);
    ExpRd   : IN     std_ulogic;
    ExpWr   : IN     std_ulogic;
    ExpAck  : OUT    std_ulogic;
    F8M     : IN     std_ulogic;
    rst     : IN     std_ulogic;
    IO      : INOUT std_logic_vector( DIGIO_N_CONNECTORS*6*8-1 DOWNTO 0);
    Dir     : OUT std_logic_vector( DIGIO_N_CONNECTORS*6-1 DOWNTO 0)
  );
END ENTITY DigIO;

--
ARCHITECTURE beh OF DigIO IS
   SIGNAL ConnEn   : std_ulogic_vector(DIGIO_N_CONNECTORS-1 DOWNTO 0);
   SIGNAL PortEnLB : std_ulogic_vector(3 DOWNTO 0);
   SIGNAL PortEnHB : std_ulogic_vector(3 DOWNTO 0);
   SIGNAL RS       : std_ulogic;
   SIGNAL BdEn     : std_ulogic;
   SIGNAL iData    : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdEn     : std_ulogic;
   SIGNAL WrEn     : std_ulogic;

   COMPONENT DigIO_Addr
      GENERIC (
         BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
         N_CONNECTORS : integer range 4 DOWNTO 1       := 2
      );
      PORT (
         Addr     : IN     std_logic_vector(15 DOWNTO 0);
         ConnEn   : OUT    std_ulogic_vector(N_CONNECTORS-1 DOWNTO 0);
         PortEnLB : OUT    std_ulogic_vector(3 DOWNTO 0);
         PortEnHB : OUT    std_ulogic_vector(3 DOWNTO 0);
         RS       : OUT    std_ulogic;
         BdEn     : OUT    std_ulogic
      );
   END COMPONENT;
   COMPONENT subbus_io
      PORT (
         Data   : INOUT  std_logic_vector(15 DOWNTO 0);
         ExpRd  : IN     std_ulogic;
         ExpWr  : IN     std_ulogic;
         ExpAck : OUT    std_ulogic;
         F8M    : IN     std_ulogic;
         rst    : IN     std_ulogic;
         iData  : INOUT  std_logic_vector(15 DOWNTO 0);
         RdEn   : OUT    std_ulogic;
         WrEn   : OUT    std_ulogic;
         BdEn   : IN     std_ulogic
      );
   END COMPONENT;
   COMPONENT DigIO_Conn
      GENERIC ( DIGIO_FORCE_DIR : std_ulogic_vector (0 to 2) := "000";
                DIGIO_FORCE_DIR_VAL : std_ulogic_vector (0 to 2) := "000" );
      PORT (
         D      : INOUT  std_logic_vector(7 DOWNTO 0);
         IO     : INOUT  std_logic_vector(23 DOWNTO 0);
         Dir    : OUT    std_logic_vector(2 DOWNTO 0);
         RdEn   : IN     std_ulogic;
         WrEn   : IN     std_ulogic;
         ConnEn : IN     std_ulogic;
         PortEn : IN     std_ulogic_vector(3 DOWNTO 0);
         RS     : IN     std_ulogic;
         RA     : IN     std_ulogic;
         Clk    : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : DigIO_Addr USE ENTITY idx_fpga_lib.DigIO_Addr;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   FOR ALL : DigIO_Conn USE ENTITY idx_fpga_lib.DigIO_Conn;
BEGIN

   Dig_Addr : DigIO_Addr
      GENERIC MAP (
         BASE_ADDRESS => DIGIO_BASE_ADDRESS,
         N_CONNECTORS => DIGIO_N_CONNECTORS
      )
      PORT MAP (
         Addr     => Addr,
         ConnEn   => ConnEn,
         PortEnLB => PortEnLB,
         PortEnHB => PortEnHB,
         RS       => RS,
         BdEn     => BdEn
      );

   Dig_decode : subbus_io
      PORT MAP (
         Data   => Data,
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         rst    => rst,
         iData  => iData,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );

  connectors : for i in DIGIO_N_CONNECTORS-1 DOWNTO 0 generate
    LowByte : DigIO_Conn
       GENERIC MAP (
         DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(i*6 TO i*6+2),
         DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(i*6 TO i*6+2)
       )
       PORT MAP (
          D      => iData(7 DOWNTO 0),
          IO     => IO(i*48+23 DOWNTO i*48),
          Dir    => Dir(i*6+2 DOWNTO i*6),
          RdEn   => RdEn,
          WrEn   => WrEn,
          ConnEn => ConnEn(i),
          PortEn => PortEnLB,
          RS     => RS,
          RA     => rst,
          Clk    => F8m
       );
    HighByte : DigIO_Conn
      GENERIC MAP (
        DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(i*6+3 TO i*6+5),
        DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(i*6+3 TO i*6+5)
      )
      PORT MAP (
        D      => iData(15 DOWNTO 8),
        IO     => IO(i*48+47 DOWNTO i*48+24),
        Dir    => Dir(i*6+5 DOWNTO i*6+3),
        RdEn   => RdEn,
        WrEn   => WrEn,
        ConnEn => ConnEn(i),
        PortEn => PortEnHB,
        RS     => RS,
        RA     => rst,
        Clk    => F8m
      );
  end generate;
END ARCHITECTURE beh;

