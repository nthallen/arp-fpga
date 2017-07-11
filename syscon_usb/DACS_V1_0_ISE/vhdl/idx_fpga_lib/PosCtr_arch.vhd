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
-- USE ieee.std_logic_arith.all;
-- USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY PosCtr IS
  PORT( 
    RdEn     : IN     std_ulogic;
    PosEn    : IN     std_ulogic;
    F8M      : IN     std_ulogic;
    rst      : IN     std_logic;
    Ld       : IN     std_ulogic;
    ClkEn    : IN     std_ulogic;
    DirOut   : IN     std_ulogic;
    ResetPos : IN     std_ulogic;
    WData    : IN     std_logic_vector ( 15 DOWNTO 0 );
    PosData  : OUT    std_logic_vector ( 15 DOWNTO 0 )
  );

-- Declarations

END ENTITY PosCtr ;

-- Counter 
ARCHITECTURE arch OF PosCtr IS
  SIGNAL Position : unsigned (15 downto 0);
BEGIN
  PROCESS (F8M, rst)
    BEGIN
      if rst = '1' then
        Position <= (others => '0');
      elsif F8M'event AND F8M = '1' then
        if ResetPos = '1' then
          Position <= (others => '0');
        elsif Ld = '1' then
          if PosEn = '1' then
            Position <= unsigned(WData);
          end if;
        elsif ClkEn = '1' then
          if DirOut = '1' then
            Position <= Position + 1;
          else
            Position <= Position - 1;
          end if;
        end if;
      end if;
    END PROCESS;
  
  PROCESS (F8M, rst)
    BEGIN
      if rst = '1' then
        PosData <= ( others => '0' );
      elsif F8M'event AND F8M = '1' then
        if RdEn = '1' and PosEn = '1' then
          PosData <= std_logic_vector(Position);
        end if;
      end if;
    END PROCESS;
END ARCHITECTURE arch;

