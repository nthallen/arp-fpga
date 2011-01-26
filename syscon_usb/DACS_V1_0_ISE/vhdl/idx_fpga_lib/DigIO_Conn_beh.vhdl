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
-- USE idx_fpga_lib.All;

ENTITY DigIO_Conn IS
  -- Actually only half a connector
  GENERIC ( DIGIO_FORCE_DIR : std_ulogic_vector (0 to 2) := "000";
            DIGIO_FORCE_DIR_VAL : std_ulogic_vector (0 to 2) := "000" );
  PORT (
    D : INOUT std_logic_vector (7 DOWNTO 0);
    IO : INOUT std_logic_vector (23 DOWNTO 0);
    Dir : OUT std_logic_vector (2 DOWNTO 0);
    RdEn : IN std_ulogic;
    WrEn : IN std_ulogic;
    ConnEn : IN std_ulogic;
    PortEn : IN std_ulogic_vector (3 DOWNTO 0);
    RS : IN std_ulogic;
    RA : IN std_ulogic;
    Clk : IN std_ulogic
  );
END ENTITY DigIO_Conn;

--
ARCHITECTURE beh OF DigIO_Conn IS
   COMPONENT DigIO_Port
     GENERIC ( DIGIO_FORCE_DIR : std_ulogic := '0';
               DIGIO_FORCE_DIR_VAL : std_ulogic := '0' );
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
   SIGNAL D_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL DIR_int : std_logic_vector(2 DOWNTO 0);
BEGIN
   Port1 : DigIO_Port
      GENERIC MAP (
         DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(0),
         DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(0)
      )
      PORT MAP (
         D       => D_int,
         IO      => IO(7 DOWNTO 0),
         ConnEn  => ConnEn,
         PortEn  => PortEn(0),
         RS      => RS,
         RA      => RA,
         Dir_In  => D(4),
         Dir_Out => Dir_int(0),
         CfgEn   => PortEn(3),
         WrEn    => WrEn,
         RdEn    => RdEn,
         Clk     => Clk
      );
   Port2 : DigIO_Port
     GENERIC MAP (
        DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(1),
        DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(1)
     )
     PORT MAP (
        D       => D_int,
        IO      => IO(15 DOWNTO 8),
        ConnEn  => ConnEn,
        PortEn  => PortEn(1),
        RS      => RS,
        RA      => RA,
        Dir_In  => D(1),
        Dir_Out => Dir_int(1),
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        RdEn    => RdEn,
        Clk     => Clk
     );
   Port3 : DigIO_Port
     GENERIC MAP (
        DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(2),
        DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(2)
     )
     PORT MAP (
        D       => D_int,
        IO      => IO(23 DOWNTO 16),
        ConnEn  => ConnEn,
        PortEn  => PortEn(2),
        RS      => RS,
        RA      => RA,
        Dir_In  => D(0),
        Dir_Out => Dir_int(2),
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        RdEn    => RdEn,
        Clk     => Clk
     );

  RdBuf : Process (RdEn, ConnEn, D) Is
  Begin
    if RdEn = '1' and ConnEn = '1' then
      D_int <= (others => 'Z');
    else
      D_int <= D;
    end if;
  End Process;

  RdCfg : Process (Clk) Is
  Begin
    if Clk'Event AND Clk = '1' then
      if RdEn = '1' and ConnEn = '1' and PortEn(3) = '1' then
        D(0) <= Dir_int(2);
        D(1) <= Dir_int(1);
        D(4) <= Dir_int(0);
        D(3 DOWNTO 2) <= "00";
        D(7 DOWNTO 5) <= "000";
      elsif RdEn = '1' and ConnEn = '1' then
        D <= D_int;
      else
        D <= (others => 'Z');
      end if;
    end if;
  End Process;
  
  Dir <= Dir_int;
END Architecture beh;