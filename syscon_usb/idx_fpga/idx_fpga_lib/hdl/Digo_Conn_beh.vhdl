--
-- VHDL Architecture idx_fpga_lib.Digo_Conn.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 12:49:01 09/22/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
USE idx_fpga_lib.All;

ENTITY Digio_Conn IS
  -- Actually only half a connectore
  PORT (
    D : INOUT std_logic_vector (7 DOWNTO 0);
    IO1 : INOUT std_logic_vector (7 DOWNTO 0);
    Dir1 : OUT std_logic;
    IO2 : INOUT std_logic_vector (7 DOWNTO 0);
    Dir2 : OUT std_logic;
    IO3 : INOUT std_logic_vector (7 DOWNTO 0);
    Dir3 : OUT std_logic;
    RdEn : IN std_ulogic;
    WrEn : IN std_ulogic;
    ConnEn : IN std_ulogic;
    PortEn : IN std_ulogic_vector (3 DOWNTO 0);
    RS : IN std_ulogic;
    RA : IN std_ulogic;
    Clk : IN std_ulogic
  );
END ENTITY Digio_Conn;

--
ARCHITECTURE beh OF Digio_Conn IS
   COMPONENT DigIO_Port
      PORT (
         D       : INOUT  std_logic_vector(7 DOWNTO 0);
         IO      : INOUT  std_logic_vector(7 DOWNTO 0);
         ConnEn  : IN     std_ulogic;
         PortEn  : IN     std_ulogic;
         RS      : IN     std_ulogic;
         RA      : IN     std_ulogic;
         Dir_In  : IN     std_logic;
         Dir_Out : OUT    std_logic;
         CfgEn   : IN     std_ulogic;
         WrEn    : IN     std_ulogic;
         RdEn    : IN     std_ulogic;
         Clk     : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : DigIO_Port USE ENTITY idx_fpga_lib.DigIO_Port;
BEGIN
   Port1 : DigIO_Port
      PORT MAP (
         D       => D,
         IO      => IO1,
         ConnEn  => ConnEn,
         PortEn  => PortEn(0),
         RS      => RS,
         RA      => RA,
         Dir_In  => D(4),
         Dir_Out => Dir1,
         CfgEn   => PortEn(3),
         WrEn    => WrEn,
         RdEn    => RdEn,
         Clk     => Clk
      );
   Port2 : DigIO_Port
     PORT MAP (
        D       => D,
        IO      => IO2,
        ConnEn  => ConnEn,
        PortEn  => PortEn(1),
        RS      => RS,
        RA      => RA,
        Dir_In  => D(1),
        Dir_Out => Dir2,
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        RdEn    => RdEn,
        Clk     => Clk
     );
   Port3 : DigIO_Port
     PORT MAP (
        D       => D,
        IO      => IO3,
        ConnEn  => ConnEn,
        PortEn  => PortEn(2),
        RS      => RS,
        RA      => RA,
        Dir_In  => D(0),
        Dir_Out => Dir3,
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        RdEn    => RdEn,
        Clk     => Clk
     );

END Architecture beh;