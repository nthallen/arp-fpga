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
<v t="ntallen.20100601150619.1289"><vh>Todo</vh>
<v t="ntallen.20100601150619.1290"><vh>Take syscon back to HDL Designer</vh></v>
</v>
<v t="ntallen.20100520123955.1247" a="E"><vh>Development Issues</vh>
<v t="ntallen.20100519134237.1503"><vh>12.1 Upgrade</vh></v>
<v t="ntallen.20100524120730.1249"><vh>ISE/XPS/SDK</vh>
<v t="ntallen.20100524120730.1250"><vh>Bit Stream</vh></v>
<v t="ntallen.20100524120730.1251"><vh>PROM</vh></v>
</v>
<v t="ntallen.20100524120730.1253" a="E"><vh>QNX</vh>
<v t="ntallen.20100602103230.1293"><vh>Library Strategy</vh></v>
<v t="ntallen.20100602103230.1294"><vh>Alternate Strategy</vh></v>
<v t="ntallen.20100602103230.1295"><vh>Driver?</vh></v>
<v t="ntallen.20100607110403.1299"><vh>sbtest</vh></v>
<v t="ntallen.20100610083250.1301"><vh>Simulation problem</vh></v>
</v>
</v>
<v t="ntallen.20100525090916.1257"><vh>Development Plan</vh>
<v t="ntallen.20100525090916.1259"><vh>Document Serial Protocol</vh></v>
<v t="ntallen.20100525090916.1258"><vh>Update Syscon</vh>
<v t="ntallen.20100525090916.1263"><vh>Read Operation</vh></v>
<v t="ntallen.20100525090916.1264"><vh>Write Operation</vh></v>
<v t="ntallen.20100527162821.1273"><vh>Implemented syscon VHDL module</vh>
<v t="ntallen.20100527162821.1274"><vh>Done: Update XPS Proj</vh></v>
<v t="ntallen.20100527162821.1275"><vh>Update SDK Proj</vh></v>
<v t="ntallen.20100527162821.1278"><vh>Update ISE Proj</vh>
<v t="ntallen.20100527162821.1277"><vh>Done: Create new top-level VHDL</vh></v>
<v t="ntallen.20100527162821.1279"><vh>Bring in syscon, indexer</vh></v>
<v t="ntallen.20100528083113.1287"><vh>Add reset pin to ctrl bus</vh></v>
<v t="ntallen.20100527162821.1276"><vh>Update ucf</vh></v>
</v>
</v>
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
    promgen -spi -p mcs -o spi_prom.mcs -s 8192 -u 0 dacs_download.bit

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
<t tx="ntallen.20100525090916.1259">&lt;hex16&gt; : [0-9A-F]{4}
&lt;addr&gt; : &lt;hex16&gt;
&lt;data&gt; : &lt;hex16&gt;
&lt;cmdline&gt; : &lt;cmd&gt; '\n'
&lt;bit&gt; : '0' | '1'
&lt;cmd&gt; :
    R &lt;addr&gt;    // Read
    W &lt;addr&gt; : &lt;data&gt;  // Write
    C &lt;bit&gt;    // CMDENBL
    S &lt;bit&gt;    // CMDSTRB
    B          // Board Revision

Responses:
    R &lt;data&gt; '\n'  // Read data with acknowledge asserted
    r &lt;data&gt; '\n'  // Read data without acknowledge asserted
    W '\n'         // Write with acknowledge
    w '\n'         // Write without acknowledge
    S &lt;bit&gt; '\n'   // CMDSTRB value
    C &lt;bit&gt; '\n'   // CMDENBL value</t>
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
<t tx="ntallen.20100527162821.1273"></t>
<t tx="ntallen.20100527162821.1274">Reduced the number of GPIO instantiations by combining control and status bits.</t>
<t tx="ntallen.20100527162821.1275">Rewrite read/write operations to use the control and status ports and wait on the Done bit.
</t>
<t tx="ntallen.20100527162821.1276"></t>
<t tx="ntallen.20100527162821.1277"></t>
<t tx="ntallen.20100527162821.1278"></t>
<t tx="ntallen.20100527162821.1279">Brought in syscon_arch.vhd from HDS. Tried several ways to add to project. I want my vhdl to go in a subdirectory so it's separated from the mess of files in the root. "Add Copy of source file" does not allow you to say where you want to copy the source file. The approach that seems to work is to manually copy the source file into the vhdl directory, and then "Add source file" to link it into the project.

</t>
<t tx="ntallen.20100528083113.1287">and propogate through syscon and dacs and the subbus code
This could be handled via the processor reset: that's a discussion we need to have.

</t>
<t tx="ntallen.20100601150619.1289"></t>
<t tx="ntallen.20100601150619.1290">Done never goes high...</t>
<t tx="ntallen.20100602103230.1293">Shared objects:  oooo!

Original implementation loaded the single library that happened to be there, and then could query it to figure out what it was.

This approach might be more like asking for a particular library, perhaps by command-line option, and supporting multiple libraries.

Default behavior should be to load a single library, and perhaps by command-line option, and have the usual functions work

    driver
        Attempt to load some compile-time set of drivers, accepting the first found
    driver -s &lt;name&gt;
        Load the specified driver as the primary

After that, could provide APIs for loading multiple drivers

To support multiple drivers, we can't use the same function names in each driver, or they will be overwritten or otherwise conflicted.</t>
<t tx="ntallen.20100602103230.1294">Create apps linked separately against one or the other. Either:
    -l subbus
or
    -l subbus-usb

The executables could be segregated by hardware or by name

An alternate flavor of the subbus-usb library could use different names for the interface functions, which would allow for linking both into the same app. That would most likely be implemented by (optional) macros that recast the function names, so by recompiling, an app could use the same names, but access the alternate library.</t>
<t tx="ntallen.20100602103230.1295">I probably need a driver to arbitrate access to the serial device, though I can try to get away with the existing subbus library's arbitration scheme.
</t>
<t tx="ntallen.20100607110403.1299">Currently I can control cmdenbl and direction, which suggests that addresses are working,
but I always read back zeros. Changing cmdenbl should produce a 0x8000 from the channel status

Driving in zero or out zero produces a change in direction, but driving out a non-zero
amount has not produced steps, leading me to believe the data value is coming through as zeros

Routing output data &lt;0&gt; to a pin to see if it is coming through
Then may try separating input and output into separate ports

output data bus bit order was wrong. Should have been [15:0], but was [0:15]

Input data is still not registering.

subbus_data_i (between system and syscon) shows non-zero data during ExpRd. It continues to the end of RdEn unless ExpAck is asserted (read_ack( 0, &amp;data ))
</t>
<t tx="ntallen.20100610083250.1301">Unexpected SEH</t>
</tnodes>
</leo_file>
