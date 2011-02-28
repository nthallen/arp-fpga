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
    DW : IN    std_logic_vector (7 DOWNTO 0);
    DR : OUT   std_logic_vector (7 DOWNTO 0);
    IO : INOUT std_logic_vector (23 DOWNTO 0);
    Dir : OUT std_logic_vector (2 DOWNTO 0);
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
         DW      : IN     std_logic_vector(7 DOWNTO 0);
         DR      : OUT    std_logic_vector(7 DOWNTO 0);
         IO      : INOUT  std_logic_vector(7 DOWNTO 0);
         ConnEn  : IN     std_ulogic;
         PortEn  : IN     std_ulogic;
         RS      : IN     std_ulogic;
         RA      : IN     std_ulogic;
         Dir_In  : IN     std_logic;
         Dir_Out : OUT    std_logic;
         CfgEn   : IN     std_ulogic;
         WrEn    : IN     std_ulogic;
         Clk     : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : DigIO_Port USE ENTITY idx_fpga_lib.DigIO_Port;
   SIGNAL iDR     : std_logic_vector(23 DOWNTO 0);
   SIGNAL DIR_int : std_logic_vector(2 DOWNTO 0);
BEGIN
   Port1 : DigIO_Port
      GENERIC MAP (
         DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(0),
         DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(0)
      )
      PORT MAP (
         DW      => DW,
         DR      => iDR(7 DOWNTO 0),
         IO      => IO(7 DOWNTO 0),
         ConnEn  => ConnEn,
         PortEn  => PortEn(0),
         RS      => RS,
         RA      => RA,
         Dir_In  => DW(4),
         Dir_Out => Dir_int(0),
         CfgEn   => PortEn(3),
         WrEn    => WrEn,
         Clk     => Clk
      );
   Port2 : DigIO_Port
     GENERIC MAP (
        DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(1),
        DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(1)
     )
     PORT MAP (
        DW      => DW,
        DR      => iDR(15 DOWNTO 8),
        IO      => IO(15 DOWNTO 8),
        ConnEn  => ConnEn,
        PortEn  => PortEn(1),
        RS      => RS,
        RA      => RA,
        Dir_In  => DW(1),
        Dir_Out => Dir_int(1),
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        Clk     => Clk
     );
   Port3 : DigIO_Port
     GENERIC MAP (
        DIGIO_FORCE_DIR => DIGIO_FORCE_DIR(2),
        DIGIO_FORCE_DIR_VAL => DIGIO_FORCE_DIR_VAL(2)
     )
     PORT MAP (
        DW      => DW,
        DR      => iDR(23 DOWNTO 16),
        IO      => IO(23 DOWNTO 16),
        ConnEn  => ConnEn,
        PortEn  => PortEn(2),
        RS      => RS,
        RA      => RA,
        Dir_In  => DW(0),
        Dir_Out => Dir_int(2),
        CfgEn   => PortEn(3),
        WrEn    => WrEn,
        Clk     => Clk
     );

  RdCfg : Process (Clk) Is
  Begin
    if Clk'Event AND Clk = '1' then
      if PortEn(0) = '1' then
        DR <= iDR(7 DOWNTO 0);
      elsif PortEn(1) = '1' then
        DR <= iDR(15 DOWNTO 8);
      elsif PortEn(2) = '1' then
        DR <= iDR(23 DOWNTO 16);
      elsif PortEn(3) = '1' then
        DR(0) <= Dir_int(2);
        DR(1) <= Dir_int(1);
        DR(4) <= Dir_int(0);
        DR(3 DOWNTO 2) <= "00";
        DR(7 DOWNTO 5) <= "000";
      else
        DR <= (others => '0');
      end if;
    end if;
  End Process;
  
  Dir <= Dir_int;
END Architecture beh;