--
-- VHDL Architecture idx_fpga_lib.ptrh_dprams.beh
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 10:35:37 02/ 6/2011
--
-- ptrhm_dprams encapsulates the ptrh_hold and ptrh_dprams
-- modules in order to provide support for multiple PTRH
-- channels
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
LIBRARY idx_fpga_lib;
--USE idx_fpga_lib.All;

ENTITY ptrhm_dprams IS
  GENERIC (
    N_PTRH : integer range 20 downto 1 := 2
  );
  PORT (
    F8M     : IN     std_ulogic;
    rst     : IN     std_ulogic;
    RdEn    : IN     std_ulogic;
    RegEn   : IN     std_logic_vector(12 DOWNTO 0);
    PTRHEn  : IN     std_ulogic_vector(N_PTRH-1 DOWNTO 0);
    WrEn    : IN     std_logic_vector(12 DOWNTO 0);
    WrPTRHEn: IN     std_ulogic_vector(N_PTRH-1 DOWNTO 0);
    wData   : IN     std_logic_vector(23 DOWNTO 0);
    rData   : OUT    std_logic_vector(15 DOWNTO 0)
  );
END ptrhm_dprams;

--
ARCHITECTURE beh OF ptrhm_dprams IS
   type iRData_t is array (N_PTRH-1 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
   SIGNAL iRData : iRData_t;
   type PTRHRegEn_t is array (N_PTRH-1 DOWNTO 0) of std_logic_vector(12 DOWNTO 0);
   SIGNAL PTRHRegEn : PTRHRegEn_t;
   SIGNAL WrRegEn   : PTRHRegEn_t;
   SIGNAL hold_D1   : std_ulogic_vector(N_PTRH-1 DOWNTO 0);
   SIGNAL hold_D2   : std_ulogic_vector(N_PTRH-1 DOWNTO 0);
   SIGNAL Full_int  : PTRHRegEn_t;
   COMPONENT ptrh_hold
      PORT (
         En0  : IN     std_ulogic;
         En1  : IN     std_ulogic;
         F8M  : IN     std_ulogic;
         RdEn : IN     std_ulogic;
         hold : OUT    std_logic;
         rst  : IN     std_ulogic
      );
   END COMPONENT;
   COMPONENT ptrh_dprams
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
   END COMPONENT;
   FOR ALL : ptrh_hold USE ENTITY idx_fpga_lib.ptrh_hold;
   FOR ALL : ptrh_dprams USE ENTITY idx_fpga_lib.ptrh_dprams;
BEGIN
  rams : for i in N_PTRH-1 DOWNTO 0 generate
    D1 : ptrh_hold
      PORT MAP (
        En0  => PTRHRegEn(i)(9),
        En1  => PTRHRegEn(i)(10),
        F8M  => F8M,
        RdEn => RdEn,
        hold => hold_D1(i),
        rst  => rst
      );
    D2 : ptrh_hold
      PORT MAP (
        En0  => PTRHRegEn(i)(11),
        En1  => PTRHRegEn(i)(12),
        F8M  => F8M,
        RdEn => RdEn,
        hold => hold_D2(i),
        rst  => rst
      );
    dprams : ptrh_dprams
      PORT MAP (
        F8M     => F8M,
        RdEn    => RdEn,
        RegEn   => PTRHRegEn(i),
        WrEn    => WrRegEn(i),
        hold_D1 => hold_D1(i),
        hold_D2 => hold_D2(i),
        wData   => wData,
        Full    => Full_int(i),
        rData   => irData(i)
      );
  end generate;
 
  PTRHReg : Process ( RegEn, PTRHEn ) IS
  Begin
    for i in N_PTRH-1 DOWNTO 0 loop
      if PTRHEn(i) = '1' then
        PTRHRegEn(i) <= RegEn;
      else
        PTRHRegEn(i) <= (others => '0');
      end if;
    end loop;
  End Process;
  
  WrPTRH : Process ( WrEn, WrPTRHEn ) IS
  Begin
    for i in N_PTRH-1 DOWNTO 0 loop
      if WrPTRHEn(i) = '1' then
        WrRegEn(i) <= WrEn;
      else
        WrRegEn(i) <= (others => '0');
      end if;
    end loop;
  End Process;
  
  rData_p : Process (PTRHEn, iRData) Is
  Begin
    rData <= (others => '0');
    for i in N_PTRH-1 DOWNTO 0 loop
      if PTRHEn(i) = '1' then
        rData <= iRData(i);
      end if;
    end loop;
  End Process;
END ARCHITECTURE beh;

