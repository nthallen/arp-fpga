--
-- VHDL Architecture idx_fpga_lib.ctr_ugctr.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:44:00 09/30/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY ctr_ugctr IS
  GENERIC (
    N_BITS : integer range 32 DOWNTO 16 := 20
  );
  PORT (
    PMT : IN std_ulogic;
    CntEn : IN std_ulogic;
    RegEn : IN std_ulogic;
    CntClr : IN std_ulogic;
    F8M : IN std_ulogic;
    HW_En : IN std_ulogic;
    Data : OUT std_logic_vector (15 DOWNTO 0);
    OVF : OUT std_ulogic;
    OVF16 : OUT std_ulogic
  );
END ENTITY ctr_ugctr;

--
ARCHITECTURE beh OF ctr_ugctr IS
  SIGNAL count : unsigned (N_BITS-1 DOWNTO 0);
  SIGNAL count_reg : std_logic_vector(N_BITS-1 DOWNTO 0);
  SIGNAL OVF_reg : std_ulogic;
  SIGNAL OVF16_reg : std_ulogic;
BEGIN
  counting : Process (CntClr, PMT) is
    variable is_ovf : std_ulogic;
  Begin
    if CntClr = '1' then
      count <= (others => '0');
      OVF_reg <= '0';
      OVF16_reg <= '0';
    elsif PMT'Event and PMT = '1' then
      if CntEn = '1' then
        count <= count + 1;
        if std_logic_vector(count(15 DOWNTO 0)) = X"FFFF" then
          OVF16_reg <= '1';
          is_ovf := '1';
          for i in 16 to N_BITS-1 loop
            if count(i) = '0' then
              is_ovf := '0';
            end if;
          end loop;
          OVF_reg <= is_ovf;
        end if;
      end if;
    end if;
  End Process;

  Cnt_Register : Process (F8M) is
  Begin
    if F8M'Event and F8M = '1' then
      if RegEn = '1' then
        count_reg <= std_logic_vector(count);
        OVF <= OVF_reg;
        OVF16 <= OVF16_reg;
      end if;
    end if;
  End Process;
  
  IO : Process (F8M) is
  Begin
    if F8M'Event and F8M = '1' then
      if HW_En = '1' then
        Data(15 DOWNTO N_BITS-16) <= (others => '0');
        Data(N_BITS-17 DOWNTO 0) <= count_reg(N_BITS-1 DOWNTO 16);
      else
        Data <= count_reg(15 DOWNTO 0);
      end if;
  end if;
  End Process;
END ARCHITECTURE beh;

