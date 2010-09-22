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
USE idx_fpga_lib.All;

ENTITY Digio IS
  GENERIC (
    BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
    N_CONNECTORS : integer range 4 DOWNTO 1 := 2
  );
  PORT (
    Addr : IN std_logic_vector (15 DOWNTO 0);
    Data    : INOUT  std_logic_vector (15 DOWNTO 0);
    ExpRd   : IN     std_ulogic;
    ExpWr   : IN     std_ulogic;
    ExpAck  : OUT    std_ulogic;
    F8M     : IN     std_ulogic;
    rst     : IN     std_ulogic;
    IO : INOUT std_logic_vector( N_CONNECTORS*6*8-1 DOWNTO 0);
    Dirs : OUT std_logic_vector( N_CONNECTORS*6-1 DOWNTO 0)
  );
END ENTITY Digio;

--
ARCHITECTURE beh OF Digio IS
   SIGNAL ConnEn   : std_ulogic_vector(1 DOWNTO 0);
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
   COMPONENT DigIO_decode
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
   COMPONENT Digo_Conn
      PORT (
         D      : INOUT  std_logic_vector(7 DOWNTO 0);
         IO1    : INOUT  std_logic_vector(7 DOWNTO 0);
         Dir1   : OUT    std_logic;
         IO2    : INOUT  std_logic_vector(7 DOWNTO 0);
         Dir2   : OUT    std_logic;
         IO3    : INOUT  std_logic_vector(7 DOWNTO 0);
         Dir3   : OUT    std_logic;
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
   FOR ALL : DigIO_decode USE ENTITY idx_fpga_lib.DigIO_decode;
   FOR ALL : Digo_Conn USE ENTITY idx_fpga_lib.Digo_Conn;
BEGIN

   Dig_Addr : DigIO_Addr
      GENERIC MAP (
         BASE_ADDRESS => BASE_ADDRESS,
         N_CONNECTORS => N_CONNECTORS
      )
      PORT MAP (
         Addr     => Addr,
         ConnEn   => ConnEn ,
         PortEnLB => PortEnLB,
         PortEnHB => PortEnHB,
         RS       => RS,
         BdEn     => BdEn
      );

   Dig_decode : DigIO_decode
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

   for i in N_CONNECTORS-1 to 0 generate
   instanceName : Digo_Conn
      PORT MAP (
         D      => iData,
         IO1    => IO1,
         Dir1   => Dir1,
         IO2    => IO2,
         Dir2   => Dir2,
         IO3    => IO3,
         Dir3   => Dir3,
         RdEn   => RdEn,
         WrEn   => WrEn,
         ConnEn => ConnEn,
         PortEn => PortEn,
         RS     => RS,
         RA     => rst,
         Clk    => F8m
      );
END ARCHITECTURE beh;

