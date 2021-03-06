-- VHDL Entity idx_fpga_lib.qclictrl.symbol
--
-- Created:
--          by - nort.UNKNOWN (EASWHLPT3425080)
--          at - 18:28:18 01/13/2019
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY qclictrl IS
   GENERIC( 
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
   );
   PORT( 
      Addr   : IN     std_logic_vector (15 DOWNTO 0);
      ExpRd  : IN     std_ulogic;
      ExpWr  : IN     std_ulogic;
      F8M    : IN     std_logic;
      QNBsy  : IN     std_logic;
      WData  : IN     std_logic_vector (15 DOWNTO 0);
      rst    : IN     std_logic;
      ExpAck : OUT    std_ulogic;
      QSync  : OUT    std_ulogic;
      RData  : OUT    std_logic_vector (15 DOWNTO 0);
      QSClk  : INOUT  std_logic;
      QSData : INOUT  std_logic
   );

-- Declarations

END qclictrl ;

--
-- VHDL Architecture idx_fpga_lib.qclictrl.struct
--
-- Created:
--          by - nort.UNKNOWN (NORT-XPS14)
--          at - 14:57:37 07/11/2017
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

LIBRARY idx_fpga_lib;

ARCHITECTURE struct OF qclictrl IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BdEn         : std_ulogic;
   SIGNAL Busy         : std_logic;
   SIGNAL Ctrlr_rst    : std_logic;
   SIGNAL FIFO_rdata   : std_logic_vector(15 DOWNTO 0);
   SIGNAL RDataS       : std_logic_vector(15 DOWNTO 0);
   SIGNAL RdAck        : std_logic;
   SIGNAL RdEn         : std_ulogic;
   SIGNAL RdFAck       : std_logic;
   SIGNAL RdFIFO       : std_logic;
   SIGNAL RdSer        : std_logic;
   SIGNAL TOrst        : std_logic;
   SIGNAL TOset        : std_logic;
   SIGNAL WDataB       : std_logic_vector(15 DOWNTO 0);
   SIGNAL WDataS       : std_logic_vector(15 DOWNTO 0);
   SIGNAL WrAck        : std_logic;
   SIGNAL WrEn         : std_ulogic;
   SIGNAL WrEnB        : std_logic;
   SIGNAL WrSer        : std_logic;
   SIGNAL cmd          : std_logic_vector(2 DOWNTO 0);
   SIGNAL cmdB         : std_logic_vector(2 DOWNTO 0);
   SIGNAL ctrlr_status : std_logic_vector(15 DOWNTO 0);
   SIGNAL oen          : std_logic;
   SIGNAL qcli_status  : std_logic_vector(15 DOWNTO 0);
   SIGNAL qsclk_i      : std_ulogic;
   SIGNAL qsclk_o      : std_ulogic;
   SIGNAL qsdata_i     : std_ulogic;
   SIGNAL qsdata_o     : std_ulogic;
   SIGNAL rRd          : std_ulogic;
   SIGNAL rWr          : std_ulogic;
   SIGNAL raddr        : std_logic_vector(6 DOWNTO 0);
   SIGNAL ram_rdata    : std_logic_vector(15 DOWNTO 0);
   SIGNAL ram_wdata    : std_logic_vector(15 DOWNTO 0);
   SIGNAL timeout      : std_logic;


   -- Component Declarations
   COMPONENT qclic_addr
   GENERIC (
      BASE_ADDR : std_logic_vector(15 DOWNTO 0) := X"1000"
   );
   PORT (
      Addr : IN     std_logic_vector (15 DOWNTO 0);
      BdEn : OUT    std_ulogic ;
      cmd  : OUT    std_logic_vector (2 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT qclic_bio
   PORT (
      clk : IN     std_logic;
      en  : IN     std_logic;
      o   : IN     std_ulogic;
      i   : OUT    std_ulogic;
      io  : INOUT  std_logic
   );
   END COMPONENT;
   COMPONENT qclic_engine
   PORT (
      Busy         : IN     std_logic ;
      Ctrlr_rst    : IN     std_logic ;
      F8M          : IN     std_logic ;
      RDataS       : IN     std_logic_vector (15 DOWNTO 0);
      RdAck        : IN     std_logic ;
      RdFIFO       : IN     std_logic ;
      WDataB       : IN     std_logic_vector (15 DOWNTO 0);
      WrEnB        : IN     std_logic ;
      cmdB         : IN     std_logic_vector (2 DOWNTO 0);
      ram_rdata    : IN     std_logic_vector (15 DOWNTO 0);
      rst          : IN     std_logic ;
      timeout      : IN     std_logic ;
      FIFO_rdata   : OUT    std_logic_vector (15 DOWNTO 0);
      RdFAck       : OUT    std_logic ;
      RdSer        : OUT    std_logic ;
      TOrst        : OUT    std_logic ;
      WDataS       : OUT    std_logic_vector (15 DOWNTO 0);
      WrAck        : OUT    std_logic ;
      WrSer        : OUT    std_logic ;
      ctrlr_status : OUT    std_logic_vector (15 DOWNTO 0);
      qcli_status  : OUT    std_logic_vector (15 DOWNTO 0);
      rRd          : OUT    std_ulogic ;
      rWr          : OUT    std_ulogic ;
      raddr        : OUT    std_logic_vector (6 DOWNTO 0);
      ram_wdata    : OUT    std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT qclic_ram
   PORT (
      rRd       : IN     std_ulogic ;
      rWr       : IN     std_ulogic ;
      raddr     : IN     std_logic_vector (6 DOWNTO 0);
      ram_wdata : IN     std_logic_vector (15 DOWNTO 0);
      ram_rdata : OUT    std_logic_vector (15 DOWNTO 0);
      F8M       : IN     std_logic ;
      rst       : IN     std_logic 
   );
   END COMPONENT;
   COMPONENT qclic_rbuf
   PORT (
      F8M          : IN     std_logic ;
      FIFO_rdata   : IN     std_logic_vector (15 DOWNTO 0);
      RdEn         : IN     std_ulogic ;
      RdFAck       : IN     std_logic ;
      cmd          : IN     std_logic_vector (2 DOWNTO 0);
      ctrlr_status : IN     std_logic_vector (15 DOWNTO 0);
      qcli_status  : IN     std_logic_vector (15 DOWNTO 0);
      rst          : IN     std_logic ;
      RData        : OUT    std_logic_vector (15 DOWNTO 0);
      RdFIFO       : OUT    std_logic ;
      TOset        : OUT    std_logic 
   );
   END COMPONENT;
   COMPONENT qclic_ser
   GENERIC (
      HPER : natural := 64
   );
   PORT (
      F8M      : IN     std_logic ;
      QNBsy    : IN     std_logic ;
      RdSer    : IN     std_logic ;
      WDataS   : IN     std_logic_vector (15 DOWNTO 0);
      WrSer    : IN     std_logic ;
      qsclk_i  : IN     std_ulogic ;
      qsdata_i : IN     std_ulogic ;
      rst      : IN     std_logic ;
      Busy     : OUT    std_logic ;
      QSync    : OUT    std_ulogic ;
      RDataS   : OUT    std_logic_vector (15 DOWNTO 0);
      RdAck    : OUT    std_logic ;
      oen      : OUT    std_logic ;
      qsclk_o  : OUT    std_ulogic ;
      qsdata_o : OUT    std_ulogic 
   );
   END COMPONENT;
   COMPONENT qclic_timer
   PORT (
      F8M     : IN     std_logic;
      TOrst   : IN     std_logic;
      TOset   : IN     std_logic;
      rst     : IN     std_logic;
      timeout : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT qclic_wbuf
   PORT (
      F8M       : IN     std_logic ;
      WData     : IN     std_logic_vector (15 DOWNTO 0);
      WrAck     : IN     std_logic ;
      WrEn      : IN     std_ulogic ;
      cmd       : IN     std_logic_vector (2 DOWNTO 0);
      rst       : IN     std_logic ;
      Ctrlr_rst : OUT    std_logic ;
      WDataB    : OUT    std_logic_vector (15 DOWNTO 0);
      WrEnB     : OUT    std_logic ;
      cmdB      : OUT    std_logic_vector (2 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT subbus_io
   PORT (
      ExpRd  : IN     std_ulogic ;
      ExpWr  : IN     std_ulogic ;
      ExpAck : OUT    std_ulogic ;
      F8M    : IN     std_ulogic ;
      RdEn   : OUT    std_ulogic ;
      WrEn   : OUT    std_ulogic ;
      BdEn   : IN     std_ulogic 
   );
   END COMPONENT;

   -- Optional embedded configurations
   -- pragma synthesis_off
   FOR ALL : qclic_addr USE ENTITY idx_fpga_lib.qclic_addr;
   FOR ALL : qclic_bio USE ENTITY idx_fpga_lib.qclic_bio;
   FOR ALL : qclic_engine USE ENTITY idx_fpga_lib.qclic_engine;
   FOR ALL : qclic_ram USE ENTITY idx_fpga_lib.qclic_ram;
   FOR ALL : qclic_rbuf USE ENTITY idx_fpga_lib.qclic_rbuf;
   FOR ALL : qclic_ser USE ENTITY idx_fpga_lib.qclic_ser;
   FOR ALL : qclic_timer USE ENTITY idx_fpga_lib.qclic_timer;
   FOR ALL : qclic_wbuf USE ENTITY idx_fpga_lib.qclic_wbuf;
   FOR ALL : subbus_io USE ENTITY idx_fpga_lib.subbus_io;
   -- pragma synthesis_on


BEGIN

   -- Instance port mappings.
   addrdec : qclic_addr
      GENERIC MAP (
         BASE_ADDR => BASE_ADDR
      )
      PORT MAP (
         Addr => Addr,
         BdEn => BdEn,
         cmd  => cmd
      );
   bio_sclk : qclic_bio
      PORT MAP (
         o   => qsclk_o,
         en  => oen,
         clk => F8M,
         io  => QSClk,
         i   => qsclk_i
      );
   bio_sdata : qclic_bio
      PORT MAP (
         o   => qsdata_o,
         en  => oen,
         clk => F8M,
         io  => QSData,
         i   => qsdata_i
      );
   engine : qclic_engine
      PORT MAP (
         Busy         => Busy,
         Ctrlr_rst    => Ctrlr_rst,
         F8M          => F8M,
         RDataS       => RDataS,
         RdAck        => RdAck,
         RdFIFO       => RdFIFO,
         WDataB       => WDataB,
         WrEnB        => WrEnB,
         cmdB         => cmdB,
         ram_rdata    => ram_rdata,
         rst          => rst,
         timeout      => timeout,
         FIFO_rdata   => FIFO_rdata,
         RdFAck       => RdFAck,
         RdSer        => RdSer,
         TOrst        => TOrst,
         WDataS       => WDataS,
         WrAck        => WrAck,
         WrSer        => WrSer,
         ctrlr_status => ctrlr_status,
         qcli_status  => qcli_status,
         rRd          => rRd,
         rWr          => rWr,
         raddr        => raddr,
         ram_wdata    => ram_wdata
      );
   ram : qclic_ram
      PORT MAP (
         rRd       => rRd,
         rWr       => rWr,
         raddr     => raddr,
         ram_wdata => ram_wdata,
         ram_rdata => ram_rdata,
         F8M       => F8M,
         rst       => rst
      );
   rbuf : qclic_rbuf
      PORT MAP (
         F8M          => F8M,
         FIFO_rdata   => FIFO_rdata,
         RdEn         => RdEn,
         RdFAck       => RdFAck,
         cmd          => cmd,
         ctrlr_status => ctrlr_status,
         qcli_status  => qcli_status,
         rst          => rst,
         RData        => RData,
         RdFIFO       => RdFIFO,
         TOset        => TOset
      );
   ser : qclic_ser
      GENERIC MAP (
         HPER => 64
      )
      PORT MAP (
         F8M      => F8M,
         QNBsy    => QNBsy,
         RdSer    => RdSer,
         WDataS   => WDataS,
         WrSer    => WrSer,
         qsclk_i  => qsclk_i,
         qsdata_i => qsdata_i,
         rst      => rst,
         Busy     => Busy,
         QSync    => QSync,
         RDataS   => RDataS,
         RdAck    => RdAck,
         oen      => oen,
         qsclk_o  => qsclk_o,
         qsdata_o => qsdata_o
      );
   timer : qclic_timer
      PORT MAP (
         F8M     => F8M,
         TOrst   => TOrst,
         TOset   => TOset,
         rst     => rst,
         timeout => timeout
      );
   wbuf : qclic_wbuf
      PORT MAP (
         F8M       => F8M,
         WData     => WData,
         WrAck     => WrAck,
         WrEn      => WrEn,
         cmd       => cmd,
         rst       => rst,
         Ctrlr_rst => Ctrlr_rst,
         WDataB    => WDataB,
         WrEnB     => WrEnB,
         cmdB      => cmdB
      );
   IO : subbus_io
      PORT MAP (
         ExpRd  => ExpRd,
         ExpWr  => ExpWr,
         ExpAck => ExpAck,
         F8M    => F8M,
         RdEn   => RdEn,
         WrEn   => WrEn,
         BdEn   => BdEn
      );

END struct;
