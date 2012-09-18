--
-- VHDL Architecture idx_fpga_lib.fifo.beh
--
-- Created:
--          by - nort (NORT-NBX200T)
--          at - 13:31:18 08/21/2012
--
-- using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

ENTITY fifo IS
   GENERIC( 
      FIFO_WIDTH  : integer range 16 downto 1  := 1;
      FIFO_LENGTH : integer range 255 downto 1 := 1
   );
   PORT( 
      WData : IN     std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      WE    : IN     std_logic;
      RE    : IN     std_logic;
      Clk   : IN     std_ulogic;
      Rst   : IN     std_logic;
      RData : OUT    std_logic_vector (FIFO_WIDTH-1 DOWNTO 0);
      Empty : OUT    std_logic;
      Full  : OUT    std_logic
   );

END fifo ;

-- FIFO will be implemented essentially as a linked list.
--
ARCHITECTURE beh OF fifo IS
  type FIFO_t is array (FIFO_LENGTH-1 DOWNTO 0) of std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
  SIGNAL FIFOdata : FIFO_t;
  SIGNAL FIFOcnt : std_logic_vector(7 DOWNTO 0);
  SIGNAL Full_int : std_logic;
  SIGNAL Empty_int : std_logic;
BEGIN
  action : Process (Clk) IS
    VARIABLE iaddr : integer range 255 DOWNTO 0;
  BEGIN
    if Clk'Event AND Clk = '1' then
      if Rst = '1' then
        FIFOcnt <= (others => '0');
        Full_int <= '0';
        Empty_int <= '1';
        for i in 1 to FIFO_LENGTH loop
          FIFOdata(i-1) <= (others => '0');
        end loop;
      else
        if RE = '1' AND Empty_int = '0' then
          for i in 1 to FIFO_LENGTH-1 loop
            FIFOdata(i-1) <= FIFOdata(i);
          end loop;
          FIFOdata(FIFO_LENGTH-1) <= (others => '0');
          if WE = '1' then
            iaddr := conv_integer(FIFOcnt-1);
            if iaddr < FIFO_LENGTH then
              FIFOdata(iaddr) <= WData;
            end if;
          else
            if FIFOcnt = 1 then
              Empty_int <= '1';
            end if;
            Full_int <= '0';
            FIFOcnt <= FIFOcnt-1;
          end if;
        elsif WE = '1' AND Full_int = '0' then
          iaddr := conv_integer(FIFOcnt);
          if iaddr < FIFO_LENGTH then
            FIFOdata(iaddr) <= WData;
          end if;
          if FIFOcnt >= FIFO_LENGTH-1 then
            Full_int <= '1';
          else
            Full_int <= '0';
          end if;
          FIFOcnt <= FIFOcnt + 1;
          Empty_int <= '0';
        end if;
      end if;
    end if;
  End Process;
  
  RData <= FIFOdata(0);
  Full <= Full_int;
  Empty <= Empty_int;
      
END ARCHITECTURE beh;

