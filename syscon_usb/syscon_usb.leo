<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet ekr_test?>
<leo_file>
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="ntallen.20100519134237.1502"><vh>@chapters</vh></v>
<v t="ntallen.20100519134237.1501" a="E"><vh>Syscon USB</vh>
<v t="ntallen.20100520123955.1247"><vh>Development Issues</vh>
<v t="ntallen.20100519134237.1503"><vh>12.1 Upgrade</vh></v>
<v t="ntallen.20100524120730.1249"><vh>ISE/XPS/SDK</vh>
<v t="ntallen.20100524120730.1250"><vh>Bit Stream</vh></v>
<v t="ntallen.20100524120730.1251"><vh>PROM</vh></v>
</v>
<v t="ntallen.20100524120730.1253"><vh>QNX</vh></v>
</v>
<v t="ntallen.20100525090916.1257" a="E"><vh>Development Plan</vh>
<v t="ntallen.20100525090916.1259"><vh>Document Serial Protocol</vh></v>
<v t="ntallen.20100525090916.1258" a="E"><vh>Update Syscon</vh>
<v t="ntallen.20100525090916.1263"><vh>Read Operation</vh></v>
<v t="ntallen.20100525090916.1264"><vh>Write Operation</vh></v>
</v>
<v t="ntallen.20100525090916.1260"><vh>Implement Subbus Library</vh></v>
<v t="ntallen.20100525090916.1261"><vh>Implement Design with Indexer</vh></v>
<v t="ntallen.20100525090916.1262"><vh>A/D VHDL</vh></v>
</v>
</v>
</vnodes>
<tnodes>
<t tx="ntallen.20100519134237.1501">@nocolor
</t>
<t tx="ntallen.20100519134237.1502"></t>
<t tx="ntallen.20100519134237.1503">Copied Syscon_rC from K

Performed the following steps several time (with clean copies from K)
Each time, I copied IP from the 11.1 distribution into the 12.1
Copying the old clock_generator 3.01.a did not work, but I just changed the
version to 4.00.a, since the ports never changed...

Opened in ISE 12.1 (upgraded)
Opened system.xmp (requires upgrade...)
  upgrading: microblaze, mdm
  upgrading xps_epc
  clock_generator can be updated from 3.01.a to 4.00.a (incompatible)
    CLK_IN sys_clk_s
    CLKOUT0 clk_60_0000MHz
    RST net_gnd
    LOCKED Dcm_all_locked
    Done
    
  cpu driver update 1.12.a to 1.12.b
  incompatible driver updates for bram, gpio and uartlite
    not done...

Tried to run "implement design"
  </t>
<t tx="ntallen.20100520123955.1247"></t>
<t tx="ntallen.20100524120730.1249">Xilinx provides multiple GUI frameworks for developing using processors.
ISE provides the most control over synthesis and routing.
XPS is a more high-level tool for piecing together IP
SDK is for software and can be invoked from either ISE or XPS.

It is possible to do entire designs in XPS/SDK. When working with a lot of VHDL, it may be easier to use ISE, including the XPS project as one component. That is the current strategy for this project. Hence we need to use all three GUI frameworks.

The ISE project is the root. (Syscon_rC)
The XPS project is found in the "system" subdirectory. XPS should be invoked from ISE by opening system.xmp, not directly.
SDK can be invoked directly or from either XPS or ISE. The SDK projects are under system/SDK.

</t>
<t tx="ntallen.20100524120730.1250">ISE will generate the bitstream for the FPGA. For this design, we expect all the software to bit within BRAM, and as such, initialization of the software can be done with a simple PROM initialization.

To include the program in the bitstream, we apparently need to create a software project in XPS. These seems counterintuitive as Xilinx has been steadily moving us away from XPS and toward the SDK for all software. As it happens, the only thing we need to do in XPS is to create an elf-only software project that points to the .elf file we want to include, and mark that project for inclusion in the bitstream. We don't need to generate the bitstream in XPS, just make that connection. (This is also odd: we don't use XPS to generate the bitstream or the software, but that's still the place we have to go to connect the two, even when the top level design is in ISE.)

Once the connection is made, the "Generate Programming File" option in ISE will create system_download.bit, which differs from system.bit in that it includes the software.
</t>
<t tx="ntallen.20100524120730.1251">We are using an SPI PROM to initialize the FPGA. The configuration is detailed in
http://www.xilinx.com/support/documentation/application_notes/xapp974.pdf

We are using the Indirect in-system programming (ISP) approach.

Note that the FTDI USB interface we are using also has its own connection to the SPI PROM, so we have the option to program it using iMPACT through the FPGA, or using FTDI's program and programming via USB.

To program the PROM, we need to reformat the bit file. The app note lists the command:
    promgen -spi -p mcs -o spi_prom.mcs -s 8192 -u 0 system_download.bit

In iMPACT, need to added SPI PROM to the design. The part on the FTDI board is M25P20.</t>
<t tx="ntallen.20100524120730.1253">The DLP board uses the FTDI FT2232D (0x0403,0x6010), but it is reportedly supported
by the devc-serusb driver, which is listed as supporting FT8U232AM (0x0403,0x6001)

I will try specifying the device ID on the devc-serusb command line

Apparently what I need is:
    /sbin/devc-serusb -d vid=0x0403,did=0x6010,module=ftdi

Some instability on removal, but insertion seemed to work fine.
Devices /dev/serusb1 and /dev/serusb2 show up.
</t>
<t tx="ntallen.20100525090916.1257"></t>
<t tx="ntallen.20100525090916.1258">I'm inclined to review the code for read and write and consider implementing some of it in VHDL.
The read logic is faulty, since it resets EXPRD before reading in the data (which is not latched in hardware)</t>
<t tx="ntallen.20100525090916.1259"></t>
<t tx="ntallen.20100525090916.1260"></t>
<t tx="ntallen.20100525090916.1261"></t>
<t tx="ntallen.20100525090916.1262"></t>
<t tx="ntallen.20100525090916.1263">Make sure data bus is set for input
Set EXPADDR
Set EXPRD
&lt;wait for 1 usec&gt;&lt;could be a hardware test&gt;
Record value of EXPDATA and EXPACK
Reset EXPRD</t>
<t tx="ntallen.20100525090916.1264">Set EXPDATA direction to output
Set EXPADDR
Set EXPDATA
Set EXPWR
&lt;wait for 1usec&gt;&lt;could be hardware timer&gt;
Record value of EXPACK
Reset EXPWR
Reset EXPDATA direction to input
</t>
</tnodes>
</leo_file>
