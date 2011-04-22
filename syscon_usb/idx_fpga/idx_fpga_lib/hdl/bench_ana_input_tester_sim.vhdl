--
-- VHDL Architecture idx_fpga_lib.bench_ana_input_tester.sim
--
-- Created:
--          by - nort.UNKNOWN (NORT-NBX200T)
--          at - 11:47:57 11/ 1/2010
--
-- using Mentor Graphics HDL Designer(TM) 2009.2 (Build 10)
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY idx_fpga_lib;
-- USE idx_fpga_lib.All;

ENTITY bench_ana_input_tester IS
   PORT( 
      CS5    : IN     std_ulogic;
      Conv   : IN     std_ulogic;
      ExpAck : IN     std_ulogic;
      Row    : IN     std_ulogic_vector (5 DOWNTO 0);
      SCK16  : IN     std_ulogic_vector (1 DOWNTO 0);
      SCK5   : IN     std_ulogic_vector (1 DOWNTO 0);
      SDO    : IN     std_ulogic_vector (1 DOWNTO 0);
      Addr   : OUT    std_logic_vector (15 DOWNTO 0);
      ExpRd  : OUT    std_ulogic;
      ExpWr  : OUT    std_ulogic;
      F8M    : OUT    std_ulogic;
      RST    : OUT    std_ulogic;
      SDI    : OUT    std_ulogic_vector (1 DOWNTO 0);
      WData  : OUT    std_logic_vector (15 DOWNTO 0);
      RData  : IN     std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END bench_ana_input_tester ;

--
ARCHITECTURE sim OF bench_ana_input_tester IS
   SIGNAL Bank : std_ulogic;
   SIGNAL RST_int : std_ulogic;
   SIGNAL F8M_int : std_ulogic;
   SIGNAL CvtCnt : unsigned(7 DOWNTO 0);
   SIGNAL Done : std_ulogic;
   SIGNAL Read_Result : std_logic_vector(15 DOWNTO 0);
   type cfg_array_t is array(7 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
   SIGNAL cfg_vals : cfg_array_t;
   SIGNAL ByRow : std_ulogic;
   SIGNAL SR50 : std_logic_vector(4 DOWNTO 0);
   SIGNAL SR51 : std_logic_vector(4 DOWNTO 0);
   SIGNAL ChkSD5 : std_logic;
   SIGNAL ChkCnvCnt : std_ulogic;
   
   COMPONENT mock_ad7687_chain
      PORT (
         SCK16 : IN     std_ulogic;
         Conv  : IN     std_ulogic;
         RST   : IN     std_ulogic;
         SDO   : OUT    std_ulogic;
         Row   : IN     std_ulogic_vector(2 DOWNTO 0);
         Bank  : IN     std_ulogic
      );
   END COMPONENT;
   FOR ALL : mock_ad7687_chain USE ENTITY idx_fpga_lib.mock_ad7687_chain;
   
   function char_string( Ain : in std_logic_vector(3 DOWNTO 0) )
   return string is
   begin
     case Ain is
       when X"0" => return "0";
       when X"1" => return "1";
       when X"2" => return "2";
       when X"3" => return "3";
       when X"4" => return "4";
       when X"5" => return "5";
       when X"6" => return "6";
       when X"7" => return "7";
       when X"8" => return "8";
       when X"9" => return "9";
       when X"A" => return "A";
       when X"B" => return "B";
       when X"C" => return "C";
       when X"D" => return "D";
       when X"E" => return "E";
       when X"F" => return "F";
       when others => return "X";
     end case;
   end char_string;
   
   function word_string( Ain : in std_logic_vector(15 DOWNTO 0) )
   return string is
   begin
     return
       char_string(Ain(15 downto 12)) &
       char_string(Ain(11 downto 8)) &
       char_string(Ain(7 downto 4)) &
       char_string(Ain(3 downto 0));
   end word_string;
   
   function pos_string( N : in integer )
   return string is
     Variable M : integer;
     Variable R : integer;
     Variable isneg : std_logic;
   begin
     if N = 0 then
       return "0";
     end if;
       M := N/10;
       R := N - M*10;
       if M = 0 then
         case R is
           when 0 => return "0";
           when 1 => return "1";
           when 2 => return "2";
           when 3 => return "3";
           when 4 => return "4";
           when 5 => return "5";
           when 6 => return "6";
           when 7 => return "7";
           when 8 => return "8";
           when 9 => return "9";
           when others => return "X";
         end case;
       else
         case R is
           when 0 => return pos_string(M) & "0";
           when 1 => return pos_string(M) & "1";
           when 2 => return pos_string(M) & "2";
           when 3 => return pos_string(M) & "3";
           when 4 => return pos_string(M) & "4";
           when 5 => return pos_string(M) & "5";
           when 6 => return pos_string(M) & "6";
           when 7 => return pos_string(M) & "7";
           when 8 => return pos_string(M) & "8";
           when 9 => return pos_string(M) & "9";
           when others => return pos_string(M) & "X";
         end case;
       end if;
   end pos_string;
   
   function int_string( N : in integer )
   return string is
   begin
     if N < 0 then
       return "-" & pos_string(-N);
     else
       return pos_string(N);
     end if;
   end int_string;
   
BEGIN
   bank0 : mock_ad7687_chain
      PORT MAP (
         SCK16 => SCK16(0),
         Conv  => Conv,
         RST   => RST_int,
         SDO   => SDI(0),
         Row   => Row(2 DOWNTO 0),
         Bank  => '0'
      );

  bank1 : mock_ad7687_chain
    PORT MAP (
      SCK16 => SCK16(1),
      Conv  => Conv,
      RST   => RST_int,
      SDO   => SDI(1),
      Row   => Row(2 DOWNTO 0),
      Bank  => '1'
    );

  clock8 : Process
  Begin
    F8M_int <= '0';
    -- pragma synthesis_off
    wait for 40 ns;
    while Done = '0' loop
      F8M_int <= '0';
      wait for 62 ns;
      F8M_int <= '1';
      wait for 63 ns;
    end loop;
    wait;
    -- pragma synthesis_on
  End Process;
  
  Count : Process (RST_int,CS5)
  Begin
    if RST_int = '1' then
      CvtCnt <= X"00";
    elsif CS5'Event AND CS5 = '0' then
      CvtCnt <= CvtCnt + 1;
    end if;
  End Process;
  
  
  ChkSD5_p : Process IS
    Variable n_bits : integer;
    Variable col_no : integer;
    Variable row_no : integer;
    Variable cfgbits : std_logic_vector(15 DOWNTO 0);
  Begin
    -- pragma synthesis_off
    wait for 100 ns;
    while Done = '0' loop
      wait until ChkSD5'Event AND ChkSD5 = '1';
      while ChkSD5 = '1' loop
        wait until CS5'Event AND CS5 = '0';
        col_no := 7;
        while col_no >= 0 loop
          n_bits := 0;
          while n_bits < 5 loop
            wait until SCK5(0)'Event AND SCK5(0) = '1';
            SR50(4 DOWNTO 1) <= SR50(3 DOWNTO 0);
            SR50(0) <= SDO(0);
            n_bits := n_bits+1;
          end loop;
          wait for 10 ns;
          cfgbits(4 downto 0) := SR50;
          cfgbits(15 downto 5) := (others => '0');
          if ByRow = '1' then
            row_no := 0;
            for i in 2 downto 0 loop
              row_no := row_no * 2;
              if Row(i) = '1' then
                row_no := row_no + 1;
              end if;
            end loop;
            assert cfgbits = cfg_vals(row_no)
              report "Config shift bits incorrect by row: (" & int_string(row_no)
                & ", " & int_string(col_no) & "): " & word_string(cfg_vals(row_no))
                & "/" & word_string(cfgbits)
              severity error;
          else
            assert cfgbits = cfg_vals(col_no)
              report "Config shift bits incorrect by column: (" & int_string(row_no)
                & ", " & int_string(col_no) & "): " & word_string(cfg_vals(row_no))
                & "/" & word_string(cfgbits)
              severity error;
          end if;
          col_no := col_no-1;
        end loop;
      end loop;
    end loop;
    -- pragma synthesis_on
  End Process;

  test_proc : Process
    Variable CvtdRow : unsigned(4 DOWNTO 0);
    Variable AddrV : unsigned(15 DOWNTO 0);
    
    procedure sbrd( addr_in : std_logic_vector (15 DOWNTO 0) ) is
    begin
      Addr <= addr_in;
      -- pragma synthesis_off
      wait until F8M_int'Event AND F8M_int = '1';
      wait for 1 ns;
      ExpRd <= '1';
      for i in 1 to 8 loop
        wait until F8M_int'Event AND F8M_int = '1';
      end loop;
      assert ExpAck = '1' report "No Acknowledge on read" severity error;
      Read_Result <= RData;
      ExpRd <= '0';
      wait for 125 ns;
      -- pragma synthesis_on
      return;
    end procedure sbrd;

    procedure sbwr( Addr_In : IN std_logic_vector (15 downto 0);
                    Data_In : IN std_logic_vector (15 downto 0) ) is
    begin
      Addr <= Addr_In;
      WData <= Data_in;
      -- pragma synthesis_off
      wait until F8M_int'Event AND F8M_int = '1';
      wait for 1 ns;
      ExpWr <= '1';
      for i in 1 to 8 loop
        wait until F8M_int'Event AND F8M_int = '1';
      end loop;
      assert ExpAck = '1' report "No acknowledge on write" severity error;
      ExpWr <= '0';
      wait for 250 ns;
      -- pragma synthesis_on
      return;
    end procedure sbwr;

    procedure check_chan( RD_Addr : IN std_logic_vector(15 downto 0);
                          Cfg_In  : IN std_logic_vector(15 downto 0);
                          Addr_In : IN std_logic_vector(15 downto 0)) is
      variable CvtdRow : unsigned(15 downto 0);
      variable ReadRow : unsigned(15 downto 0);
      variable Addr_U : unsigned(15 downto 0);
    begin
      sbrd( RD_Addr );
      assert Read_Result(15 DOWNTO 8) = Addr_In(8 DOWNTO 1)
        report "Mock output does not match row/column: " &
          word_string(Read_Result) & " Addr: " &
          word_string(Addr_In) & " match: " &
          word_string(Read_Result(15 DOWNTO 8) & Addr_In(8 DOWNTO 1))
        severity error;
      if ChkCnvCnt = '1' then
        assert Read_Result(2 DOWNTO 0) = Addr_In(7 DOWNTO 5)
          report "Mock low bits do not match cvt count row: " &
            word_string(Read_Result) & " Addr: " &
            word_string(Addr_In) & " match: " &
            word_string( "00000" & Read_Result(2 DOWNTO 0) &
                         "00000" & Addr_In(8 DOWNTO 6))
          severity error;
      end if;
      if RD_Addr(8) = '0' AND ChkCnvCnt = '1' then
        -- The CvtCnt test only applies reasonably to
        -- non-remuxed channels.
        -- Also does not apply when muxing in a non-standard order
        CvtdRow := (others => '0');
        CvtdRow(4 DOWNTO 0) := CvtCnt(7 DOWNTO 3);
        ReadRow := (others => '0');
        for i in 4 downto 0 loop
          ReadRow(i) := Read_Result(i+3);
        end loop;
        assert ( CvtdRow >= 16 AND ReadRow <= CvtdRow AND ReadRow >= CvtdRow-16) OR
            ( CvtdRow < 16 AND ( ReadRow <= CvtdRow OR ReadRow >= CvtdRow+16 ))
          report "Cvt Count does not match: Addr: " & word_string(RD_Addr) &
            " Read: " & word_string(conv_std_logic_vector(ReadRow,16)) &
            " Cvtd: " & word_string(conv_std_logic_vector(CvtdRow,16))
          severity error;
      end if;
      for i in 15 downto 0 loop
        Addr_U(i) := RD_Addr(i);
      end loop;
      sbrd( conv_std_logic_vector(Addr_U+1,16) );
      -- In the case of a muxed channel, the configuration reported
      -- at the base address will reflect the configuration of the
      -- last muxed channel reported, so it isn't easily predictable.
      -- However, at the reported addresses (RD_Addr(8)='1'), the
      -- reported configuration should be consistent.
      if Cfg_In(8) = '1' and RD_Addr(8) = '0' then
        assert Read_Result(8 DOWNTO 5) = Cfg_In(8 DOWNTO 5)
          report "Mux Cfg readback from: " &
                word_string(conv_std_logic_vector(Addr_U+1,16) ) &
                 " expected: " & word_string(Cfg_In) &
                 " read: " & word_string(Read_Result)
          severity error;
      else
        assert Read_Result = Cfg_In
          report "Configuration readback from: " &
                word_string(conv_std_logic_vector(Addr_U+1,16) ) &
                 " expected: " & word_string(Cfg_In) &
                 " read: " & word_string(Read_Result)
          severity error;
      end if;
      return;
    end procedure check_chan;
  
  Begin
    Done <= '0';
    ExpRd <= '0';
    ExpWr <= '0';
    WData <= (others => '0');
    cfg_vals(0) <= X"0001";
    cfg_vals(1) <= X"0002";
    cfg_vals(2) <= X"0000";
    cfg_vals(3) <= X"0008";
    cfg_vals(4) <= X"0010";
    cfg_vals(5) <= X"0018";
    cfg_vals(6) <= X"0014";
    cfg_vals(7) <= X"001C";
    ByRow <= '1';
    ChkSD5 <= '0';
    RST_int <= '1';
    ChkCnvCnt <= '1';

    -- pragma synthesis_off
    wait until F8M_int'Event AND F8M_int = '1';
    RST_int <= '0';
    -- wait for 100 us; -- wait for initial conversions
    for row in 0 to 7 loop
      for col in 0 to 7 loop
        AddrV := conv_unsigned(16#C00# + row*32 + col*2,16);
        -- sbwr( std_logic_vector(AddrV), X"0014" );
        sbwr( std_logic_vector(AddrV), cfg_vals(row) );
        AddrV := conv_unsigned(16#C10# + row*32 + col*2,16);
        -- sbwr( std_logic_vector(AddrV), X"0014" );
        sbwr( std_logic_vector(AddrV), cfg_vals(row) );
      end loop;
    end loop;
    sbwr( X"0C1E", X"0100" );
    sbwr( X"0C5E", X"0120" );
    sbwr( X"0C9E", X"0140" );
    ChkCnvCnt <= '0'; -- CnvCnt will not track when we add double converts
    -- sbwr( X"0C01", X"0800" ); -- double convert on row 0 only
    sbwr( X"0C01", X"1800" ); -- double convert always
    wait for 800 us;
    ChkSD5 <= '1';
    wait for 6600 us;
    
    for loopcnt in 0 to 5 loop
      for row in 0 to 7 loop
        for col in 0 to 7 loop
          AddrV := conv_unsigned(16#C00# + row*32 + col*2,16);
          check_chan( std_logic_vector(AddrV), cfg_vals(row), std_logic_vector(AddrV) );
          AddrV := conv_unsigned(16#C10# + row*32 + col*2,16);
          if Addrv = 16#C1E# then
            check_chan( std_logic_vector(AddrV), X"0100", std_logic_vector(AddrV) );
          elsif Addrv = 16#C5E# then
            check_chan( std_logic_vector(AddrV), X"0120", std_logic_vector(AddrV) );
          elsif Addrv = 16#C9E# then
            check_chan( std_logic_vector(AddrV), X"0140", std_logic_vector(AddrV) );
          else
            check_chan( std_logic_vector(AddrV), cfg_vals(row), std_logic_vector(AddrV) );
          end if;
        end loop;
      end loop;
    end loop;
    ChkSD5 <= '0';
    wait until CS5'Event AND CS5 = '1';
    
    for row in 0 to 7 loop
      for col in 0 to 7 loop
        AddrV := conv_unsigned(16#C00# + row*32 + col*2,16);
        -- sbwr( std_logic_vector(AddrV), X"0014" );
        sbwr( std_logic_vector(AddrV), cfg_vals(col) );
        AddrV := conv_unsigned(16#C10# + row*32 + col*2,16);
        -- sbwr( std_logic_vector(AddrV), X"0014" );
        sbwr( std_logic_vector(AddrV), cfg_vals(col) );
      end loop;
    end loop;
    sbwr( X"0C1E", X"0100" );
    sbwr( X"0C5E", X"0120" );
    sbwr( X"0C9E", X"0140" );
    wait for 800 us;
    ByRow <= '0';
    ChkSD5 <= '1';
    wait for 2200 us;
    
    for loopcnt in 0 to 5 loop
      for row in 0 to 7 loop
        for col in 0 to 7 loop
          AddrV := conv_unsigned(16#C00# + row*32 + col*2,16);
          check_chan( std_logic_vector(AddrV), cfg_vals(col), std_logic_vector(AddrV) );
          AddrV := conv_unsigned(16#C10# + row*32 + col*2,16);
          if Addrv = 16#C1E# then
            check_chan( std_logic_vector(AddrV), X"0100", std_logic_vector(AddrV) );
          elsif Addrv = 16#C5E# then
            check_chan( std_logic_vector(AddrV), X"0120", std_logic_vector(AddrV) );
          elsif Addrv = 16#C9E# then
            check_chan( std_logic_vector(AddrV), X"0140", std_logic_vector(AddrV) );
          else
            check_chan( std_logic_vector(AddrV), cfg_vals(col), std_logic_vector(AddrV) );
          end if;
        end loop;
      end loop;
    end loop;
    ChkCnvCnt <= '0'; -- Now we're messing with mux direction.
    wait until Conv'Event and Conv = '0';
    sbrd(X"0E00"); -- Check status address
    assert Read_Result = X"0F30"
      report "Status readback should have been 0F30"
      severity error;
    wait until Conv'Event and Conv = '1';
    sbrd(X"0E00");
    assert Read_Result = X"0F30"
      report "Status readback should have been 0F30"
      severity error;
    sbwr(X"0C01", X"0080" ); -- Disable Engine
    wait for 1 ms;
    sbrd(X"0E00");
    assert Read_Result(0) = '1'
      report "Status readback(0) should be 1"
      severity error;
    sbwr(X"0C01", X"0040" ); -- Fix Row at 0
    wait for 1 ms;
    sbwr(X"0C01", X"0047" ); -- Fix Row at 7
    wait for 1 ms;
    ChkSD5 <= '0';
    wait for 200 us;
    sbwr(X"0C01", X"0000" ); -- Back to normal
    wait for 5 us;
    ChkSD5 <= '1';
    wait for 2195 us;
    sbwr(X"0C01", X"0200" ); -- XtraSettle
    wait for 5000 us;
    sbwr(X"0C01", X"013F" ); -- Count Backwards
    wait for 2200 us;
    sbrd(X"0E00");
    assert Read_Result(0) = '1'
      report "Status readback(0) should still be 1"
      severity error;
    ChkSD5 <= '0';
    wait for 200 us;
    sbwr(X"0C01", X"0400" ); -- special reset
    wait for 200 us;
    sbwr(X"0C01", X"0000" ); -- unreset
    wait for 5 us;
    ChkSD5 <= '1';
    wait for 100 us;
    wait for 2200 us;
    
    for loopcnt in 0 to 5 loop
      for row in 0 to 7 loop
        for col in 0 to 7 loop
          AddrV := conv_unsigned(16#C00# + row*32 + col*2,16);
          check_chan( std_logic_vector(AddrV), cfg_vals(col), std_logic_vector(AddrV) );
          AddrV := conv_unsigned(16#C10# + row*32 + col*2,16);
          if Addrv = 16#C1E# then
            check_chan( std_logic_vector(AddrV), X"0100", std_logic_vector(AddrV) );
          elsif Addrv = 16#C5E# then
            check_chan( std_logic_vector(AddrV), X"0120", std_logic_vector(AddrV) );
          elsif Addrv = 16#C9E# then
            check_chan( std_logic_vector(AddrV), X"0140", std_logic_vector(AddrV) );
          else
            check_chan( std_logic_vector(AddrV), cfg_vals(col), std_logic_vector(AddrV) );
          end if;
        end loop;
      end loop;
    end loop;

    Done <= '1';
    wait;
    -- pragma synthesis_on
  End Process;

  F8M <= F8M_int;
  RST <= RST_int;
  
END ARCHITECTURE sim;



