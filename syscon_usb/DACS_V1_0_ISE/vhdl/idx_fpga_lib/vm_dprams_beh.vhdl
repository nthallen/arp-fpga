--
-- VHDL Architecture idx_fpga_lib.vm_dprams.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:56:04 04/19/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY vm_dprams IS
   PORT( 
      F8M   : IN     std_ulogic;
      RdEn  : IN     std_ulogic;
      RegEn : IN     std_ulogic_vector (4 DOWNTO 0);
      WrEn  : IN     std_ulogic_vector (4 DOWNTO 0);
      wData : IN     std_logic_vector (15 DOWNTO 0);
      rData : OUT    std_logic_vector (15 DOWNTO 0);
      rst   : IN     std_ulogic
   );

-- Declarations

END vm_dprams ;

--
ARCHITECTURE beh OF vm_dprams IS
  COMPONENT ptrh_dpram
     PORT (
        F8M   : IN     std_ulogic;
        rst   : IN     std_ulogic;
        RdEn  : IN     std_ulogic;
        hold  : IN     std_logic;
        rData : OUT    std_logic_vector(15 DOWNTO 0);
        wData : IN     std_logic_vector(15 DOWNTO 0);
        WrEn  : IN     std_ulogic;
        Full  : OUT    std_ulogic
     );
  END COMPONENT;
  FOR ALL : ptrh_dpram USE ENTITY idx_fpga_lib.ptrh_dpram;
  SIGNAL Full : std_ulogic_vector(4 DOWNTO 0);
  type iRData_t is array (4 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
  SIGNAL iRData : iRData_t;
BEGIN
  rams : for i in 0 to 4 generate
    lo: ptrh_dpram
      PORT MAP (
         F8M   => F8M,
         rst   => rst,
         RdEn  => RdEn,
         hold  => '0',
         rData => iRData(i),
         wData => wData,
         WrEn  => WrEn(i),
         Full  => Full(i)
      );
  end generate;
  
  rData_p : Process (RegEn, iRData) Is
  Begin
    rData <= (others => '0');
    for i in 4 DOWNTO 0 loop
      if RegEn(i) = '1' then
        rData <= iRData(i);
      end if;
    end loop;
  End Process;

END ARCHITECTURE beh;

