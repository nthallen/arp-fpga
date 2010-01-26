--
-- VHDL Architecture idx_fpga_lib.DriveCtr.arch
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:50:08 01/ 7/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.1 (Build 12)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY DriveCtr IS
   PORT( 
      CtEn     : IN     std_ulogic;
      DirOutIn : IN     std_ulogic;
      DirOut   : OUT    std_ulogic;
      Ld       : IN     std_ulogic;
      ClkEn    : IN     std_ulogic;
      Data     : IN     std_logic_vector ( 15 DOWNTO 0 );
      rst      : IN     std_logic;
      F8M      : IN     std_ulogic;
      ZeroCt   : OUT    std_ulogic
   );

-- Declarations

END DriveCtr ;

-- Counter 
ARCHITECTURE arch OF DriveCtr IS
  SIGNAL Steps : std_logic_vector (15 downto 0);
BEGIN
  PROCESS (F8M)
    BEGIN
      if F8M'event AND F8M = '1' then
        if rst = '1' then
          Steps <= (others => '0');
          ZeroCt <= '1';
          DirOut <= '0';
        elsif Ld = '1' and CtEn = '1' then
          Steps <= Data;
          DirOut <= DirOutIn;
          if Data = X"0000" then
            ZeroCt <= '1';
          else
            ZeroCt <= '0';
          end if;
        elsif ClkEn = '1' then
          if Steps = X"0001" then
            ZeroCt <= '1';
          else
            ZeroCt <= '0';
          end if;
          Steps <= unsigned(Steps) - 1;
        end if;
      end if;
    END PROCESS;

END ARCHITECTURE arch;

