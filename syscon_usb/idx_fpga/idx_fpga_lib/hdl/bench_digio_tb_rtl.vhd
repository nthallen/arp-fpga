--
-- VHDL Test Bench idx_fpga_lib.bench_DigIO.DigIO_tester
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 13:22:58 09/23/2010
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY bench_DigIO IS
   GENERIC (
      BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
      N_CONNECTORS : integer range 4 DOWNTO 1       := 2
   );
END bench_DigIO;


LIBRARY idx_fpga_lib;
USE idx_fpga_lib.ALL;


ARCHITECTURE rtl OF bench_DigIO IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL Addr   : std_logic_vector(15 DOWNTO 0);
   SIGNAL Data   : std_logic_vector(15 DOWNTO 0);
   SIGNAL ExpRd  : std_ulogic;
   SIGNAL ExpWr  : std_ulogic;
   SIGNAL ExpAck : std_ulogic;
   SIGNAL F8M    : std_ulogic;
   SIGNAL rst    : std_ulogic;
   SIGNAL IO     : std_logic_vector( N_CONNECTORS*6*8-1 DOWNTO 0);
   SIGNAL Dir    : std_logic_vector( N_CONNECTORS*6-1 DOWNTO 0);
   SIGNAL Done   : std_ulogic;


   -- Component declarations
   COMPONENT DigIO
      GENERIC (
         BASE_ADDRESS : std_logic_vector (15 DOWNTO 0) := X"0800";
         N_CONNECTORS : integer range 4 DOWNTO 1       := 2
      );
      PORT (
         Addr   : IN     std_logic_vector(15 DOWNTO 0);
         Data   : INOUT  std_logic_vector(15 DOWNTO 0);
         ExpRd  : IN     std_ulogic;
         ExpWr  : IN     std_ulogic;
         ExpAck : OUT    std_ulogic;
         F8M    : IN     std_ulogic;
         rst    : IN     std_ulogic;
         IO     : INOUT  std_logic_vector( N_CONNECTORS*6*8-1 DOWNTO 0);
         Dir    : OUT    std_logic_vector( N_CONNECTORS*6-1 DOWNTO 0)
      );
   END COMPONENT;

   -- embedded configurations
   -- pragma synthesis_off
   FOR DUT_DigIO : DigIO USE ENTITY idx_fpga_lib.DigIO;
   -- pragma synthesis_on

BEGIN

         DUT_DigIO : DigIO
            GENERIC MAP (
               BASE_ADDRESS => BASE_ADDRESS,
               N_CONNECTORS => N_CONNECTORS
            )
            PORT MAP (
               Addr   => Addr,
               Data   => Data,
               ExpRd  => ExpRd,
               ExpWr  => ExpWr,
               ExpAck => ExpAck,
               F8M    => F8M,
               rst    => rst,
               IO     => IO,
               Dir    => Dir
            );

    clock : Process
    Begin
      -- pragma synthesis_off
      wait for 40 ns;
      while done = '0' loop
        F8M <= '0';
        wait for 62.5 ns;
        F8M <= '1';
        wait for 62.5 ns;
      end loop;
      wait;
      -- pragma synthesis_on
    End Process;
    
    test_proc : Process
      variable bitmask : std_logic_vector ( 15 DOWNTO 0);
      variable gbitnum : integer;
      variable portaddr : std_logic_vector ( 15 DOWNTO 0);
      variable ok : integer;
      procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                      Data_In : IN std_logic_vector (15 downto 0) ) is
      begin
        Addr <= Addr_In;
        Data <= Data_in;
        -- pragma synthesis_off
        wait for 40 ns;
        ExpWr <= '1';
        wait for 1 us;
        assert ExpAck = '1' report "No acknowledge on write" severity error;
        ExpWr <= '0';
        wait for 250 ns;
        Data <= (others => 'Z');
        -- pragma synthesis_on
        return;
      end procedure sbwr;
      
      procedure sbrd_check( addr_in : std_logic_vector (15 DOWNTO 0);
          expected : std_logic_vector(15 DOWNTO 0) ) is
      begin
        Addr <= addr_in;
        wait for 40 ns;
        ExpRd <= '1';
        wait for 1 us;
        assert ExpAck = '1' report "No Acknowledge on read" severity error;
        assert Data = expected report "Input Value Incorrect" severity error;
        ExpRd <= '0';
        wait for 40 ns;
      end procedure sbrd_check;
      
      procedure check_input( conn_in : integer; portno_in : integer;
          bitmask : std_logic_vector (15 DOWNTO 0) ) is
        variable portaddr : std_logic_vector(15 DOWNTO 0);
      begin
        for conn in 0 to 1 loop
          for portno in 0 to 2 loop
            portaddr := X"0800";
            portaddr := CONV_STD_LOGIC_VECTOR(unsigned(portaddr) + conn*32 + portno*2, 16);
            if conn = conn_in AND portno = portno_in then
              sbrd_check( portaddr, bitmask );
            else
              sbrd_check( portaddr, X"0000" );
            end if;
          end loop;
        end loop;
      end procedure check_input;
    Begin
      done <= '0';
      ExpRd <= '0';
      ExpWr <= '0';
      rst <= '0';
      IO <= (others => 'Z');
      -- pragma synthesis_off
      rst <= '1';
      wait until F8M'Event AND F8M = '1';
      rst <= '0';
      -- initialize all ports to output
      sbwr(X"0806", X"0000");
      sbwr(X"0826", X"0000");
      for conn in 0 to 1 loop
        for byteno in 0 to 1 loop
          for portno in 0 to 2 loop
            portaddr := X"0800";
            portaddr := CONV_STD_LOGIC_VECTOR(unsigned(portaddr) + conn*32 + portno*2, 16);
            for bitno in 0 to 7 loop
              gbitnum := conn*48+byteno*24+portno*8+bitno;
              bitmask := X"0000";
              bitmask(byteno*8+bitno) := '1';
              sbwr(portaddr, bitmask);
              ok := 1;
              for i in 0 TO N_CONNECTORS*6*8-1 loop
                if i = gbitnum then
                  if IO(i) /= '1' then
                    ok := 0;
                  end if;
                elsif IO(i) /= '0' then
                  ok := 0;
                end if;
              end loop;
              assert ok = 1 report "Bad bit output" severity error;
            end loop;
            sbwr(portaddr, X"0000");
          end loop;
        end loop;
      end loop;
      -- initialize all ports to output
      sbwr(X"0806", X"1313");
      sbwr(X"0826", X"1313");
      IO <= (others => '0');
      wait for 40 ns;
      for conn in 0 to 1 loop
        for byteno in 0 to 1 loop
          for portno in 0 to 2 loop
            portaddr := X"0800";
            portaddr := CONV_STD_LOGIC_VECTOR(unsigned(portaddr) + conn*32 + portno*2, 16);
            for bitno in 0 to 7 loop
              gbitnum := conn*48+byteno*24+portno*8+bitno;
              bitmask := X"0000";
              bitmask(byteno*8+bitno) := '1';
              IO(gbitnum) <= '1';
              check_input(conn, portno, bitmask);
              IO(gbitnum) <= '0';
            end loop;
          end loop;
        end loop;
      end loop;
      -- pragma synthesis_on
      done <= '1';
      wait;
    End Process;


END rtl;