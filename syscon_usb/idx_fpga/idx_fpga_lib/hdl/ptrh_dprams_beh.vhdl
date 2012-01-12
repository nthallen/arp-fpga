--
-- VHDL Architecture idx_fpga_lib.ptrh_dprams.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:35:37 02/ 6/2011
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;

ENTITY ptrh_dprams IS
   PORT (
      F8M     : IN     std_ulogic;
      RdEn    : IN     std_ulogic;
      RegEn   : IN     std_logic_vector(12 DOWNTO 0);
      WrEn    : IN     std_logic_vector(12 DOWNTO 0);
      hold_D1 : IN     std_ulogic;
      hold_D2 : IN     std_ulogic;
      wData   : IN     std_logic_vector(23 DOWNTO 0);
      Full    : OUT    std_logic_vector(12 DOWNTO 0);
      rData   : OUT    std_logic_vector(15 DOWNTO 0)
   );
END ptrh_dprams;

--
ARCHITECTURE beh OF ptrh_dprams IS
   type iRData_t is array (12 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
   SIGNAL hold : std_logic_vector(12 DOWNTO 0);
   SIGNAL iRData : iRData_t;
   COMPONENT ptrh_dpram
      PORT (
         F8M   : IN     std_ulogic;
         RdEn  : IN     std_ulogic;
         hold  : IN     std_logic;
         rData : OUT    std_logic_vector(15 DOWNTO 0);
         wData : IN     std_logic_vector(15 DOWNTO 0);
         WrEn  : IN     std_logic;
         Full  : OUT    std_logic
      );
   END COMPONENT;
   FOR ALL : ptrh_dpram USE ENTITY idx_fpga_lib.ptrh_dpram;
BEGIN
  hold(12) <= hold_D2;
  hold(11) <= hold_D2;
  hold(10) <= hold_D1;
  hold(9) <= hold_D1;
  hold(8 DOWNTO 0) <= (others => '0');
  
  rams : for i in 0 to 12 generate
    reg24 : if i = 10 OR i = 12 generate
      hi: ptrh_dpram
        PORT MAP (
           F8M   => F8M,
           RdEn  => RdEn,
           hold  => hold(i),
           rData => iRData(i),
           wData(7 DOWNTO 0) => wData(23 DOWNTO 16),
           wData(15 DOWNTO 8) => X"00",
           WrEn  => WrEn(i),
           Full  => Full(i)
        );
    end generate;
    reg16 : if i /= 10 AND i /= 12 generate
      lo: ptrh_dpram
        PORT MAP (
           F8M   => F8M,
           RdEn  => RdEn,
           hold  => hold(i),
           rData => iRData(i),
           wData => wData(15 DOWNTO 0),
           WrEn  => WrEn(i),
           Full  => Full(i)
        );
    end generate;
  end generate;
  
  rData_p : Process (RegEn, iRData) Is
  Begin
    rData <= (others => '0');
    for i in 12 DOWNTO 0 loop
      if RegEn(i) = '1' then
        rData <= iRData(i);
      end if;
    end loop;
  End Process;
END ARCHITECTURE beh;

