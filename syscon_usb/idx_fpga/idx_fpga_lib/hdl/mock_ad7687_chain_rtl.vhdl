--
-- VHDL Architecture idx_fpga_lib.mock_ad7687_chain.rtl
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 16:26:31 10/27/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mock_ad7687_chain IS
  PORT(
    SCK16 : IN std_ulogic;
    Conv  : IN std_ulogic;
    RST   : IN std_ulogic;
    SDO   : OUT std_ulogic;
    Row   : IN std_ulogic_vector(2 DOWNTO 0);
    Bank  : IN std_ulogic
  );
END ENTITY mock_ad7687_chain;

--
ARCHITECTURE rtl OF mock_ad7687_chain IS
  SIGNAL Col : unsigned(3 DOWNTO 0);
  SIGNAL Bit : unsigned(3 DOWNTO 0);
  SIGNAL SReg : std_ulogic_vector(15 DOWNTO 0);
  SIGNAL ConvCnt : unsigned(7 DOWNTO 0);
  SIGNAL ConvDly : std_ulogic;
  SIGNAL CurRow : std_ulogic_vector(2 DOWNTO 0);
BEGIN
  
  shift : Process (SCK16, Conv, RST, Row) Is
  Begin
    if RST = '1' then
      ConvCnt <= X"00";
    elsif Conv = '0' then
      Col <= (others => '0');
      Bit <= (others => '0');
      SReg <= X"FFFF";
      CurRow <= Row;
    elsif SCK16'Event AND SCK16 = '0' then
      if Bit = 0 then
        if Col = 8 then
          SReg <= X"FFFF";
          ConvCnt <= ConvCnt + 1;
        else
          SReg <= '0' & CurRow & Bank & To_StdULogicVector(not conv_std_logic_vector(Col,3))
            & To_StdULogicVector(conv_std_logic_vector(ConvCnt,8));
          Col <= Col+1;
        end if;
        Bit <= "1111";
      else
        SReg(15 DOWNTO 1) <= SReg(14 DOWNTO 0);
        SReg(0) <= '1';
        Bit <= Bit - 1;
      end if;
    end if;
  End Process;
  
  sdon : Process (Conv,ConvDly,SReg) IS
  Begin
    if Conv = '0' OR ConvDly = '0' then
      SDO <= '0';
    else
      SDO <= SReg(15);
    end if;
  End Process;
  
  cdly : Process IS
  Begin
    ConvDly <= '0';
    -- pragma synthesis_off
    loop
      wait until Conv = '0';
      ConvDly <= '0';
      wait until Conv = '1';
      wait for 3 us;
      ConvDly <= '1';
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
END ARCHITECTURE rtl;

