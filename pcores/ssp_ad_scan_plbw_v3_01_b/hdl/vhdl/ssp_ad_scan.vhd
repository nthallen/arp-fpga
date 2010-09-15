--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file addsb_11_0_fb4bc67ba183533a.vhd when simulating
-- the core, addsb_11_0_fb4bc67ba183533a. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY addsb_11_0_fb4bc67ba183533a IS
	port (
	a: IN std_logic_VECTOR(32 downto 0);
	b: IN std_logic_VECTOR(32 downto 0);
	s: OUT std_logic_VECTOR(32 downto 0));
END addsb_11_0_fb4bc67ba183533a;

ARCHITECTURE addsb_11_0_fb4bc67ba183533a_a OF addsb_11_0_fb4bc67ba183533a IS
-- synthesis translate_off
component wrapped_addsb_11_0_fb4bc67ba183533a
	port (
	a: IN std_logic_VECTOR(32 downto 0);
	b: IN std_logic_VECTOR(32 downto 0);
	s: OUT std_logic_VECTOR(32 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_addsb_11_0_fb4bc67ba183533a use entity XilinxCoreLib.c_addsub_v11_0(behavioral)
		generic map(
			c_a_width => 33,
			c_out_width => 33,
			c_add_mode => 0,
			c_has_c_out => 0,
			c_b_type => 0,
			c_borrow_low => 1,
			c_ce_overrides_sclr => 0,
			c_implementation => 0,
			c_has_sclr => 0,
			c_verbosity => 0,
			c_latency => 0,
			c_has_bypass => 0,
			c_ainit_val => "0",
			c_bypass_low => 0,
			c_has_ce => 0,
			c_sclr_overrides_sset => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_c_in => 0,
			c_has_sinit => 0,
			c_b_constant => 0,
			c_ce_overrides_bypass => 1,
			c_xdevicefamily => "virtex4",
			c_a_type => 0,
			c_b_width => 33,
			c_b_value => "000000000000000000000000000000000");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_addsb_11_0_fb4bc67ba183533a
		port map (
			a => a,
			b => b,
			s => s);
-- synthesis translate_on

END addsb_11_0_fb4bc67ba183533a_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_1eabeaef14bdfc76.vhd when simulating
-- the core, cntr_11_0_1eabeaef14bdfc76. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_1eabeaef14bdfc76 IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(31 downto 0));
END cntr_11_0_1eabeaef14bdfc76;

ARCHITECTURE cntr_11_0_1eabeaef14bdfc76_a OF cntr_11_0_1eabeaef14bdfc76 IS
-- synthesis translate_off
component wrapped_cntr_11_0_1eabeaef14bdfc76
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(31 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_1eabeaef14bdfc76 use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 0,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 32,
			c_verbosity => 0,
			c_has_load => 0,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_1eabeaef14bdfc76
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			q => q);
-- synthesis translate_on

END cntr_11_0_1eabeaef14bdfc76_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_688cfddaf968f88b.vhd when simulating
-- the core, cntr_11_0_688cfddaf968f88b. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_688cfddaf968f88b IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	load: IN std_logic;
	l: IN std_logic_VECTOR(15 downto 0);
	q: OUT std_logic_VECTOR(15 downto 0));
END cntr_11_0_688cfddaf968f88b;

ARCHITECTURE cntr_11_0_688cfddaf968f88b_a OF cntr_11_0_688cfddaf968f88b IS
-- synthesis translate_off
component wrapped_cntr_11_0_688cfddaf968f88b
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	load: IN std_logic;
	l: IN std_logic_VECTOR(15 downto 0);
	q: OUT std_logic_VECTOR(15 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_688cfddaf968f88b use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 1,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 16,
			c_verbosity => 0,
			c_has_load => 1,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_688cfddaf968f88b
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			load => load,
			l => l,
			q => q);
-- synthesis translate_on

END cntr_11_0_688cfddaf968f88b_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_8dfcc050e9d5f132.vhd when simulating
-- the core, cntr_11_0_8dfcc050e9d5f132. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_8dfcc050e9d5f132 IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
END cntr_11_0_8dfcc050e9d5f132;

ARCHITECTURE cntr_11_0_8dfcc050e9d5f132_a OF cntr_11_0_8dfcc050e9d5f132 IS
-- synthesis translate_off
component wrapped_cntr_11_0_8dfcc050e9d5f132
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_8dfcc050e9d5f132 use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 0,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 16,
			c_verbosity => 0,
			c_has_load => 0,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_8dfcc050e9d5f132
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			q => q);
-- synthesis translate_on

END cntr_11_0_8dfcc050e9d5f132_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_9e1d282a7a5f1b1e.vhd when simulating
-- the core, cntr_11_0_9e1d282a7a5f1b1e. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_9e1d282a7a5f1b1e IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	up: IN std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
END cntr_11_0_9e1d282a7a5f1b1e;

ARCHITECTURE cntr_11_0_9e1d282a7a5f1b1e_a OF cntr_11_0_9e1d282a7a5f1b1e IS
-- synthesis translate_off
component wrapped_cntr_11_0_9e1d282a7a5f1b1e
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	up: IN std_logic;
	q: OUT std_logic_VECTOR(15 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_9e1d282a7a5f1b1e use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 2,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 16,
			c_verbosity => 0,
			c_has_load => 0,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_9e1d282a7a5f1b1e
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			up => up,
			q => q);
-- synthesis translate_on

END cntr_11_0_9e1d282a7a5f1b1e_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_f09d056deed69f8d.vhd when simulating
-- the core, cntr_11_0_f09d056deed69f8d. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_f09d056deed69f8d IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(13 downto 0));
END cntr_11_0_f09d056deed69f8d;

ARCHITECTURE cntr_11_0_f09d056deed69f8d_a OF cntr_11_0_f09d056deed69f8d IS
-- synthesis translate_off
component wrapped_cntr_11_0_f09d056deed69f8d
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	q: OUT std_logic_VECTOR(13 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_f09d056deed69f8d use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 0,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 14,
			c_verbosity => 0,
			c_has_load => 0,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "1",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_f09d056deed69f8d
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			q => q);
-- synthesis translate_on

END cntr_11_0_f09d056deed69f8d_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file cntr_11_0_fb550ac1b34e525f.vhd when simulating
-- the core, cntr_11_0_fb550ac1b34e525f. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY cntr_11_0_fb550ac1b34e525f IS
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	load: IN std_logic;
	l: IN std_logic_VECTOR(11 downto 0);
	q: OUT std_logic_VECTOR(11 downto 0));
END cntr_11_0_fb550ac1b34e525f;

ARCHITECTURE cntr_11_0_fb550ac1b34e525f_a OF cntr_11_0_fb550ac1b34e525f IS
-- synthesis translate_off
component wrapped_cntr_11_0_fb550ac1b34e525f
	port (
	clk: IN std_logic;
	ce: IN std_logic;
	sinit: IN std_logic;
	load: IN std_logic;
	l: IN std_logic_VECTOR(11 downto 0);
	q: OUT std_logic_VECTOR(11 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_cntr_11_0_fb550ac1b34e525f use entity XilinxCoreLib.c_counter_binary_v11_0(behavioral)
		generic map(
			c_count_mode => 1,
			c_load_low => 0,
			c_count_to => "1",
			c_implementation => 0,
			c_has_sclr => 0,
			c_ce_overrides_sync => 0,
			c_restrict_count => 0,
			c_width => 12,
			c_verbosity => 0,
			c_has_load => 1,
			c_latency => 1,
			c_has_thresh0 => 0,
			c_ainit_val => "0",
			c_has_ce => 1,
			c_sclr_overrides_sset => 1,
			c_fb_latency => 0,
			c_sinit_val => "0",
			c_has_sset => 0,
			c_has_sinit => 1,
			c_count_by => "1",
			c_xdevicefamily => "virtex4",
			c_thresh0_value => "1");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_cntr_11_0_fb550ac1b34e525f
		port map (
			clk => clk,
			ce => ce,
			sinit => sinit,
			load => load,
			l => l,
			q => q);
-- synthesis translate_on

END cntr_11_0_fb550ac1b34e525f_a;

--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2009 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file fifo_fg61_4b31b12dc888b197.vhd when simulating
-- the core, fifo_fg61_4b31b12dc888b197. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY fifo_fg61_4b31b12dc888b197 IS
	port (
	clk: IN std_logic;
	srst: IN std_logic;
	din: IN std_logic_VECTOR(95 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(95 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	data_count: OUT std_logic_VECTOR(11 downto 0));
END fifo_fg61_4b31b12dc888b197;

ARCHITECTURE fifo_fg61_4b31b12dc888b197_a OF fifo_fg61_4b31b12dc888b197 IS
-- synthesis translate_off
component wrapped_fifo_fg61_4b31b12dc888b197
	port (
	clk: IN std_logic;
	srst: IN std_logic;
	din: IN std_logic_VECTOR(95 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(95 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	data_count: OUT std_logic_VECTOR(11 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_fifo_fg61_4b31b12dc888b197 use entity XilinxCoreLib.fifo_generator_v6_1(behavioral)
		generic map(
			c_has_int_clk => 0,
			c_wr_response_latency => 1,
			c_rd_freq => 1,
			c_has_srst => 1,
			c_enable_rst_sync => 1,
			c_has_rd_data_count => 0,
			c_din_width => 96,
			c_has_wr_data_count => 0,
			c_full_flags_rst_val => 0,
			c_implementation_type => 0,
			c_family => "virtex4",
			c_use_embedded_reg => 0,
			c_has_wr_rst => 0,
			c_wr_freq => 1,
			c_use_dout_rst => 1,
			c_underflow_low => 0,
			c_has_meminit_file => 0,
			c_has_overflow => 0,
			c_preload_latency => 1,
			c_dout_width => 96,
			c_msgon_val => 1,
			c_rd_depth => 4096,
			c_default_value => "BlankString",
			c_mif_file_name => "BlankString",
			c_error_injection_type => 0,
			c_has_underflow => 0,
			c_has_rd_rst => 0,
			c_has_almost_full => 0,
			c_has_rst => 0,
			c_data_count_width => 12,
			c_has_wr_ack => 0,
			c_use_ecc => 0,
			c_wr_ack_low => 0,
			c_common_clock => 1,
			c_rd_pntr_width => 12,
			c_use_fwft_data_count => 0,
			c_has_almost_empty => 0,
			c_rd_data_count_width => 12,
			c_enable_rlocs => 0,
			c_wr_pntr_width => 12,
			c_overflow_low => 0,
			c_prog_empty_type => 0,
			c_optimization_mode => 0,
			c_wr_data_count_width => 12,
			c_preload_regs => 0,
			c_dout_rst_val => "0",
			c_has_data_count => 1,
			c_prog_full_thresh_negate_val => 4093,
			c_wr_depth => 4096,
			c_prog_empty_thresh_negate_val => 3,
			c_prog_empty_thresh_assert_val => 2,
			c_has_valid => 0,
			c_init_wr_pntr_val => 0,
			c_prog_full_thresh_assert_val => 4094,
			c_use_fifo16_flags => 0,
			c_has_backup => 0,
			c_valid_low => 0,
			c_prim_fifo_type => "4kx9",
			c_count_type => 0,
			c_prog_full_type => 0,
			c_memory_type => 1);
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_fifo_fg61_4b31b12dc888b197
		port map (
			clk => clk,
			srst => srst,
			din => din,
			wr_en => wr_en,
			rd_en => rd_en,
			dout => dout,
			full => full,
			empty => empty,
			data_count => data_count);
-- synthesis translate_on

END fifo_fg61_4b31b12dc888b197_a;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
package conv_pkg is
    constant simulating : boolean := false
      -- synopsys translate_off
        or true
      -- synopsys translate_on
    ;
    constant xlUnsigned : integer := 1;
    constant xlSigned : integer := 2;
    constant xlWrap : integer := 1;
    constant xlSaturate : integer := 2;
    constant xlTruncate : integer := 1;
    constant xlRound : integer := 2;
    constant xlRoundBanker : integer := 3;
    constant xlAddMode : integer := 1;
    constant xlSubMode : integer := 2;
    attribute black_box : boolean;
    attribute syn_black_box : boolean;
    attribute fpga_dont_touch: string;
    attribute box_type :  string;
    attribute keep : string;
    attribute syn_keep : boolean;
    function std_logic_vector_to_unsigned(inp : std_logic_vector) return unsigned;
    function unsigned_to_std_logic_vector(inp : unsigned) return std_logic_vector;
    function std_logic_vector_to_signed(inp : std_logic_vector) return signed;
    function signed_to_std_logic_vector(inp : signed) return std_logic_vector;
    function unsigned_to_signed(inp : unsigned) return signed;
    function signed_to_unsigned(inp : signed) return unsigned;
    function pos(inp : std_logic_vector; arith : INTEGER) return boolean;
    function all_same(inp: std_logic_vector) return boolean;
    function all_zeros(inp: std_logic_vector) return boolean;
    function is_point_five(inp: std_logic_vector) return boolean;
    function all_ones(inp: std_logic_vector) return boolean;
    function convert_type (inp : std_logic_vector; old_width, old_bin_pt,
                           old_arith, new_width, new_bin_pt, new_arith,
                           quantization, overflow : INTEGER)
        return std_logic_vector;
    function cast (inp : std_logic_vector; old_bin_pt,
                   new_width, new_bin_pt, new_arith : INTEGER)
        return std_logic_vector;
    function vec_slice (inp : std_logic_vector; upper, lower : INTEGER)
        return std_logic_vector;
    function s2u_slice (inp : signed; upper, lower : INTEGER)
        return unsigned;
    function u2u_slice (inp : unsigned; upper, lower : INTEGER)
        return unsigned;
    function s2s_cast (inp : signed; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return signed;
    function u2s_cast (inp : unsigned; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return signed;
    function s2u_cast (inp : signed; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return unsigned;
    function u2u_cast (inp : unsigned; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return unsigned;
    function u2v_cast (inp : unsigned; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return std_logic_vector;
    function s2v_cast (inp : signed; old_bin_pt,
                   new_width, new_bin_pt : INTEGER)
        return std_logic_vector;
    function trunc (inp : std_logic_vector; old_width, old_bin_pt, old_arith,
                    new_width, new_bin_pt, new_arith : INTEGER)
        return std_logic_vector;
    function round_towards_inf (inp : std_logic_vector; old_width, old_bin_pt,
                                old_arith, new_width, new_bin_pt,
                                new_arith : INTEGER) return std_logic_vector;
    function round_towards_even (inp : std_logic_vector; old_width, old_bin_pt,
                                old_arith, new_width, new_bin_pt,
                                new_arith : INTEGER) return std_logic_vector;
    function max_signed(width : INTEGER) return std_logic_vector;
    function min_signed(width : INTEGER) return std_logic_vector;
    function saturation_arith(inp:  std_logic_vector;  old_width, old_bin_pt,
                              old_arith, new_width, new_bin_pt, new_arith
                              : INTEGER) return std_logic_vector;
    function wrap_arith(inp:  std_logic_vector;  old_width, old_bin_pt,
                        old_arith, new_width, new_bin_pt, new_arith : INTEGER)
                        return std_logic_vector;
    function fractional_bits(a_bin_pt, b_bin_pt: INTEGER) return INTEGER;
    function integer_bits(a_width, a_bin_pt, b_width, b_bin_pt: INTEGER)
        return INTEGER;
    function sign_ext(inp : std_logic_vector; new_width : INTEGER)
        return std_logic_vector;
    function zero_ext(inp : std_logic_vector; new_width : INTEGER)
        return std_logic_vector;
    function zero_ext(inp : std_logic; new_width : INTEGER)
        return std_logic_vector;
    function extend_MSB(inp : std_logic_vector; new_width, arith : INTEGER)
        return std_logic_vector;
    function align_input(inp : std_logic_vector; old_width, delta, new_arith,
                          new_width: INTEGER)
        return std_logic_vector;
    function pad_LSB(inp : std_logic_vector; new_width: integer)
        return std_logic_vector;
    function pad_LSB(inp : std_logic_vector; new_width, arith : integer)
        return std_logic_vector;
    function max(L, R: INTEGER) return INTEGER;
    function min(L, R: INTEGER) return INTEGER;
    function "="(left,right: STRING) return boolean;
    function boolean_to_signed (inp : boolean; width: integer)
        return signed;
    function boolean_to_unsigned (inp : boolean; width: integer)
        return unsigned;
    function boolean_to_vector (inp : boolean)
        return std_logic_vector;
    function std_logic_to_vector (inp : std_logic)
        return std_logic_vector;
    function integer_to_std_logic_vector (inp : integer;  width, arith : integer)
        return std_logic_vector;
    function std_logic_vector_to_integer (inp : std_logic_vector;  arith : integer)
        return integer;
    function std_logic_to_integer(constant inp : std_logic := '0')
        return integer;
    function bin_string_element_to_std_logic_vector (inp : string;  width, index : integer)
        return std_logic_vector;
    function bin_string_to_std_logic_vector (inp : string)
        return std_logic_vector;
    function hex_string_to_std_logic_vector (inp : string; width : integer)
        return std_logic_vector;
    function makeZeroBinStr (width : integer) return STRING;
    function and_reduce(inp: std_logic_vector) return std_logic;
    -- synopsys translate_off
    function is_binary_string_invalid (inp : string)
        return boolean;
    function is_binary_string_undefined (inp : string)
        return boolean;
    function is_XorU(inp : std_logic_vector)
        return boolean;
    function to_real(inp : std_logic_vector; bin_pt : integer; arith : integer)
        return real;
    function std_logic_to_real(inp : std_logic; bin_pt : integer; arith : integer)
        return real;
    function real_to_std_logic_vector (inp : real;  width, bin_pt, arith : integer)
        return std_logic_vector;
    function real_string_to_std_logic_vector (inp : string;  width, bin_pt, arith : integer)
        return std_logic_vector;
    constant display_precision : integer := 20;
    function real_to_string (inp : real) return string;
    function valid_bin_string(inp : string) return boolean;
    function std_logic_vector_to_bin_string(inp : std_logic_vector) return string;
    function std_logic_to_bin_string(inp : std_logic) return string;
    function std_logic_vector_to_bin_string_w_point(inp : std_logic_vector; bin_pt : integer)
        return string;
    function real_to_bin_string(inp : real;  width, bin_pt, arith : integer)
        return string;
    type stdlogic_to_char_t is array(std_logic) of character;
    constant to_char : stdlogic_to_char_t := (
        'U' => 'U',
        'X' => 'X',
        '0' => '0',
        '1' => '1',
        'Z' => 'Z',
        'W' => 'W',
        'L' => 'L',
        'H' => 'H',
        '-' => '-');
    -- synopsys translate_on
end conv_pkg;
package body conv_pkg is
    function std_logic_vector_to_unsigned(inp : std_logic_vector)
        return unsigned
    is
    begin
        return unsigned (inp);
    end;
    function unsigned_to_std_logic_vector(inp : unsigned)
        return std_logic_vector
    is
    begin
        return std_logic_vector(inp);
    end;
    function std_logic_vector_to_signed(inp : std_logic_vector)
        return signed
    is
    begin
        return  signed (inp);
    end;
    function signed_to_std_logic_vector(inp : signed)
        return std_logic_vector
    is
    begin
        return std_logic_vector(inp);
    end;
    function unsigned_to_signed (inp : unsigned)
        return signed
    is
    begin
        return signed(std_logic_vector(inp));
    end;
    function signed_to_unsigned (inp : signed)
        return unsigned
    is
    begin
        return unsigned(std_logic_vector(inp));
    end;
    function pos(inp : std_logic_vector; arith : INTEGER)
        return boolean
    is
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
    begin
        vec := inp;
        if arith = xlUnsigned then
            return true;
        else
            if vec(width-1) = '0' then
                return true;
            else
                return false;
            end if;
        end if;
        return true;
    end;
    function max_signed(width : INTEGER)
        return std_logic_vector
    is
        variable ones : std_logic_vector(width-2 downto 0);
        variable result : std_logic_vector(width-1 downto 0);
    begin
        ones := (others => '1');
        result(width-1) := '0';
        result(width-2 downto 0) := ones;
        return result;
    end;
    function min_signed(width : INTEGER)
        return std_logic_vector
    is
        variable zeros : std_logic_vector(width-2 downto 0);
        variable result : std_logic_vector(width-1 downto 0);
    begin
        zeros := (others => '0');
        result(width-1) := '1';
        result(width-2 downto 0) := zeros;
        return result;
    end;
    function and_reduce(inp: std_logic_vector) return std_logic
    is
        variable result: std_logic;
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
    begin
        vec := inp;
        result := vec(0);
        if width > 1 then
            for i in 1 to width-1 loop
                result := result and vec(i);
            end loop;
        end if;
        return result;
    end;
    function all_same(inp: std_logic_vector) return boolean
    is
        variable result: boolean;
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
    begin
        vec := inp;
        result := true;
        if width > 0 then
            for i in 1 to width-1 loop
                if vec(i) /= vec(0) then
                    result := false;
                end if;
            end loop;
        end if;
        return result;
    end;
    function all_zeros(inp: std_logic_vector)
        return boolean
    is
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
        variable zero : std_logic_vector(width-1 downto 0);
        variable result : boolean;
    begin
        zero := (others => '0');
        vec := inp;
        -- synopsys translate_off
        if (is_XorU(vec)) then
            return false;
        end if;
         -- synopsys translate_on
        if (std_logic_vector_to_unsigned(vec) = std_logic_vector_to_unsigned(zero)) then
            result := true;
        else
            result := false;
        end if;
        return result;
    end;
    function is_point_five(inp: std_logic_vector)
        return boolean
    is
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
        variable result : boolean;
    begin
        vec := inp;
        -- synopsys translate_off
        if (is_XorU(vec)) then
            return false;
        end if;
         -- synopsys translate_on
        if (width > 1) then
           if ((vec(width-1) = '1') and (all_zeros(vec(width-2 downto 0)) = true)) then
               result := true;
           else
               result := false;
           end if;
        else
           if (vec(width-1) = '1') then
               result := true;
           else
               result := false;
           end if;
        end if;
        return result;
    end;
    function all_ones(inp: std_logic_vector)
        return boolean
    is
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
        variable one : std_logic_vector(width-1 downto 0);
        variable result : boolean;
    begin
        one := (others => '1');
        vec := inp;
        -- synopsys translate_off
        if (is_XorU(vec)) then
            return false;
        end if;
         -- synopsys translate_on
        if (std_logic_vector_to_unsigned(vec) = std_logic_vector_to_unsigned(one)) then
            result := true;
        else
            result := false;
        end if;
        return result;
    end;
    function full_precision_num_width(quantization, overflow, old_width,
                                      old_bin_pt, old_arith,
                                      new_width, new_bin_pt, new_arith : INTEGER)
        return integer
    is
        variable result : integer;
    begin
        result := old_width + 2;
        return result;
    end;
    function quantized_num_width(quantization, overflow, old_width, old_bin_pt,
                                 old_arith, new_width, new_bin_pt, new_arith
                                 : INTEGER)
        return integer
    is
        variable right_of_dp, left_of_dp, result : integer;
    begin
        right_of_dp := max(new_bin_pt, old_bin_pt);
        left_of_dp := max((new_width - new_bin_pt), (old_width - old_bin_pt));
        result := (old_width + 2) + (new_bin_pt - old_bin_pt);
        return result;
    end;
    function convert_type (inp : std_logic_vector; old_width, old_bin_pt,
                           old_arith, new_width, new_bin_pt, new_arith,
                           quantization, overflow : INTEGER)
        return std_logic_vector
    is
        constant fp_width : integer :=
            full_precision_num_width(quantization, overflow, old_width,
                                     old_bin_pt, old_arith, new_width,
                                     new_bin_pt, new_arith);
        constant fp_bin_pt : integer := old_bin_pt;
        constant fp_arith : integer := old_arith;
        variable full_precision_result : std_logic_vector(fp_width-1 downto 0);
        constant q_width : integer :=
            quantized_num_width(quantization, overflow, old_width, old_bin_pt,
                                old_arith, new_width, new_bin_pt, new_arith);
        constant q_bin_pt : integer := new_bin_pt;
        constant q_arith : integer := old_arith;
        variable quantized_result : std_logic_vector(q_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        result := (others => '0');
        full_precision_result := cast(inp, old_bin_pt, fp_width, fp_bin_pt,
                                      fp_arith);
        if (quantization = xlRound) then
            quantized_result := round_towards_inf(full_precision_result,
                                                  fp_width, fp_bin_pt,
                                                  fp_arith, q_width, q_bin_pt,
                                                  q_arith);
        elsif (quantization = xlRoundBanker) then
            quantized_result := round_towards_even(full_precision_result,
                                                  fp_width, fp_bin_pt,
                                                  fp_arith, q_width, q_bin_pt,
                                                  q_arith);
        else
            quantized_result := trunc(full_precision_result, fp_width, fp_bin_pt,
                                      fp_arith, q_width, q_bin_pt, q_arith);
        end if;
        if (overflow = xlSaturate) then
            result := saturation_arith(quantized_result, q_width, q_bin_pt,
                                       q_arith, new_width, new_bin_pt, new_arith);
        else
             result := wrap_arith(quantized_result, q_width, q_bin_pt, q_arith,
                                  new_width, new_bin_pt, new_arith);
        end if;
        return result;
    end;
    function cast (inp : std_logic_vector; old_bin_pt, new_width,
                   new_bin_pt, new_arith : INTEGER)
        return std_logic_vector
    is
        constant old_width : integer := inp'length;
        constant left_of_dp : integer := (new_width - new_bin_pt)
                                         - (old_width - old_bin_pt);
        constant right_of_dp : integer := (new_bin_pt - old_bin_pt);
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
        variable j   : integer;
    begin
        vec := inp;
        for i in new_width-1 downto 0 loop
            j := i - right_of_dp;
            if ( j > old_width-1) then
                if (new_arith = xlUnsigned) then
                    result(i) := '0';
                else
                    result(i) := vec(old_width-1);
                end if;
            elsif ( j >= 0) then
                result(i) := vec(j);
            else
                result(i) := '0';
            end if;
        end loop;
        return result;
    end;
    function vec_slice (inp : std_logic_vector; upper, lower : INTEGER)
      return std_logic_vector
    is
    begin
        return inp(upper downto lower);
    end;
    function s2u_slice (inp : signed; upper, lower : INTEGER)
      return unsigned
    is
    begin
        return unsigned(vec_slice(std_logic_vector(inp), upper, lower));
    end;
    function u2u_slice (inp : unsigned; upper, lower : INTEGER)
      return unsigned
    is
    begin
        return unsigned(vec_slice(std_logic_vector(inp), upper, lower));
    end;
    function s2s_cast (inp : signed; old_bin_pt, new_width, new_bin_pt : INTEGER)
        return signed
    is
    begin
        return signed(cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlSigned));
    end;
    function s2u_cast (inp : signed; old_bin_pt, new_width,
                   new_bin_pt : INTEGER)
        return unsigned
    is
    begin
        return unsigned(cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlSigned));
    end;
    function u2s_cast (inp : unsigned; old_bin_pt, new_width,
                   new_bin_pt : INTEGER)
        return signed
    is
    begin
        return signed(cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlUnsigned));
    end;
    function u2u_cast (inp : unsigned; old_bin_pt, new_width,
                   new_bin_pt : INTEGER)
        return unsigned
    is
    begin
        return unsigned(cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlUnsigned));
    end;
    function u2v_cast (inp : unsigned; old_bin_pt, new_width,
                   new_bin_pt : INTEGER)
        return std_logic_vector
    is
    begin
        return cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlUnsigned);
    end;
    function s2v_cast (inp : signed; old_bin_pt, new_width,
                   new_bin_pt : INTEGER)
        return std_logic_vector
    is
    begin
        return cast(std_logic_vector(inp), old_bin_pt, new_width, new_bin_pt, xlSigned);
    end;
    function boolean_to_signed (inp : boolean; width : integer)
        return signed
    is
        variable result : signed(width - 1 downto 0);
    begin
        result := (others => '0');
        if inp then
          result(0) := '1';
        else
          result(0) := '0';
        end if;
        return result;
    end;
    function boolean_to_unsigned (inp : boolean; width : integer)
        return unsigned
    is
        variable result : unsigned(width - 1 downto 0);
    begin
        result := (others => '0');
        if inp then
          result(0) := '1';
        else
          result(0) := '0';
        end if;
        return result;
    end;
    function boolean_to_vector (inp : boolean)
        return std_logic_vector
    is
        variable result : std_logic_vector(1 - 1 downto 0);
    begin
        result := (others => '0');
        if inp then
          result(0) := '1';
        else
          result(0) := '0';
        end if;
        return result;
    end;
    function std_logic_to_vector (inp : std_logic)
        return std_logic_vector
    is
        variable result : std_logic_vector(1 - 1 downto 0);
    begin
        result(0) := inp;
        return result;
    end;
    function trunc (inp : std_logic_vector; old_width, old_bin_pt, old_arith,
                                new_width, new_bin_pt, new_arith : INTEGER)
        return std_logic_vector
    is
        constant right_of_dp : integer := (old_bin_pt - new_bin_pt);
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if right_of_dp >= 0 then
            if new_arith = xlUnsigned then
                result := zero_ext(vec(old_width-1 downto right_of_dp), new_width);
            else
                result := sign_ext(vec(old_width-1 downto right_of_dp), new_width);
            end if;
        else
            if new_arith = xlUnsigned then
                result := zero_ext(pad_LSB(vec, old_width +
                                           abs(right_of_dp)), new_width);
            else
                result := sign_ext(pad_LSB(vec, old_width +
                                           abs(right_of_dp)), new_width);
            end if;
        end if;
        return result;
    end;
    function round_towards_inf (inp : std_logic_vector; old_width, old_bin_pt,
                                old_arith, new_width, new_bin_pt, new_arith
                                : INTEGER)
        return std_logic_vector
    is
        constant right_of_dp : integer := (old_bin_pt - new_bin_pt);
        constant expected_new_width : integer :=  old_width - right_of_dp  + 1;
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable one_or_zero : std_logic_vector(new_width-1 downto 0);
        variable truncated_val : std_logic_vector(new_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if right_of_dp >= 0 then
            if new_arith = xlUnsigned then
                truncated_val := zero_ext(vec(old_width-1 downto right_of_dp),
                                          new_width);
            else
                truncated_val := sign_ext(vec(old_width-1 downto right_of_dp),
                                          new_width);
            end if;
        else
            if new_arith = xlUnsigned then
                truncated_val := zero_ext(pad_LSB(vec, old_width +
                                                  abs(right_of_dp)), new_width);
            else
                truncated_val := sign_ext(pad_LSB(vec, old_width +
                                                  abs(right_of_dp)), new_width);
            end if;
        end if;
        one_or_zero := (others => '0');
        if (new_arith = xlSigned) then
            if (vec(old_width-1) = '0') then
                one_or_zero(0) := '1';
            end if;
            if (right_of_dp >= 2) and (right_of_dp <= old_width) then
                if (all_zeros(vec(right_of_dp-2 downto 0)) = false) then
                    one_or_zero(0) := '1';
                end if;
            end if;
            if (right_of_dp >= 1) and (right_of_dp <= old_width) then
                if vec(right_of_dp-1) = '0' then
                    one_or_zero(0) := '0';
                end if;
            else
                one_or_zero(0) := '0';
            end if;
        else
            if (right_of_dp >= 1) and (right_of_dp <= old_width) then
                one_or_zero(0) :=  vec(right_of_dp-1);
            end if;
        end if;
        if new_arith = xlSigned then
            result := signed_to_std_logic_vector(std_logic_vector_to_signed(truncated_val) +
                                                 std_logic_vector_to_signed(one_or_zero));
        else
            result := unsigned_to_std_logic_vector(std_logic_vector_to_unsigned(truncated_val) +
                                                  std_logic_vector_to_unsigned(one_or_zero));
        end if;
        return result;
    end;
    function round_towards_even (inp : std_logic_vector; old_width, old_bin_pt,
                                old_arith, new_width, new_bin_pt, new_arith
                                : INTEGER)
        return std_logic_vector
    is
        constant right_of_dp : integer := (old_bin_pt - new_bin_pt);
        constant expected_new_width : integer :=  old_width - right_of_dp  + 1;
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable one_or_zero : std_logic_vector(new_width-1 downto 0);
        variable truncated_val : std_logic_vector(new_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if right_of_dp >= 0 then
            if new_arith = xlUnsigned then
                truncated_val := zero_ext(vec(old_width-1 downto right_of_dp),
                                          new_width);
            else
                truncated_val := sign_ext(vec(old_width-1 downto right_of_dp),
                                          new_width);
            end if;
        else
            if new_arith = xlUnsigned then
                truncated_val := zero_ext(pad_LSB(vec, old_width +
                                                  abs(right_of_dp)), new_width);
            else
                truncated_val := sign_ext(pad_LSB(vec, old_width +
                                                  abs(right_of_dp)), new_width);
            end if;
        end if;
        one_or_zero := (others => '0');
        if (right_of_dp >= 1) and (right_of_dp <= old_width) then
            if (is_point_five(vec(right_of_dp-1 downto 0)) = false) then
                one_or_zero(0) :=  vec(right_of_dp-1);
            else
                one_or_zero(0) :=  vec(right_of_dp);
            end if;
        end if;
        if new_arith = xlSigned then
            result := signed_to_std_logic_vector(std_logic_vector_to_signed(truncated_val) +
                                                 std_logic_vector_to_signed(one_or_zero));
        else
            result := unsigned_to_std_logic_vector(std_logic_vector_to_unsigned(truncated_val) +
                                                  std_logic_vector_to_unsigned(one_or_zero));
        end if;
        return result;
    end;
    function saturation_arith(inp:  std_logic_vector;  old_width, old_bin_pt,
                              old_arith, new_width, new_bin_pt, new_arith
                              : INTEGER)
        return std_logic_vector
    is
        constant left_of_dp : integer := (old_width - old_bin_pt) -
                                         (new_width - new_bin_pt);
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
        variable overflow : boolean;
    begin
        vec := inp;
        overflow := true;
        result := (others => '0');
        if (new_width >= old_width) then
            overflow := false;
        end if;
        if ((old_arith = xlSigned and new_arith = xlSigned) and (old_width > new_width)) then
            if all_same(vec(old_width-1 downto new_width-1)) then
                overflow := false;
            end if;
        end if;
        if (old_arith = xlSigned and new_arith = xlUnsigned) then
            if (old_width > new_width) then
                if all_zeros(vec(old_width-1 downto new_width)) then
                    overflow := false;
                end if;
            else
                if (old_width = new_width) then
                    if (vec(new_width-1) = '0') then
                        overflow := false;
                    end if;
                end if;
            end if;
        end if;
        if (old_arith = xlUnsigned and new_arith = xlUnsigned) then
            if (old_width > new_width) then
                if all_zeros(vec(old_width-1 downto new_width)) then
                    overflow := false;
                end if;
            else
                if (old_width = new_width) then
                    overflow := false;
                end if;
            end if;
        end if;
        if ((old_arith = xlUnsigned and new_arith = xlSigned) and (old_width > new_width)) then
            if all_same(vec(old_width-1 downto new_width-1)) then
                overflow := false;
            end if;
        end if;
        if overflow then
            if new_arith = xlSigned then
                if vec(old_width-1) = '0' then
                    result := max_signed(new_width);
                else
                    result := min_signed(new_width);
                end if;
            else
                if ((old_arith = xlSigned) and vec(old_width-1) = '1') then
                    result := (others => '0');
                else
                    result := (others => '1');
                end if;
            end if;
        else
            if (old_arith = xlSigned) and (new_arith = xlUnsigned) then
                if (vec(old_width-1) = '1') then
                    vec := (others => '0');
                end if;
            end if;
            if new_width <= old_width then
                result := vec(new_width-1 downto 0);
            else
                if new_arith = xlUnsigned then
                    result := zero_ext(vec, new_width);
                else
                    result := sign_ext(vec, new_width);
                end if;
            end if;
        end if;
        return result;
    end;
   function wrap_arith(inp:  std_logic_vector;  old_width, old_bin_pt,
                       old_arith, new_width, new_bin_pt, new_arith : INTEGER)
        return std_logic_vector
    is
        variable result : std_logic_vector(new_width-1 downto 0);
        variable result_arith : integer;
    begin
        if (old_arith = xlSigned) and (new_arith = xlUnsigned) then
            result_arith := xlSigned;
        end if;
        result := cast(inp, old_bin_pt, new_width, new_bin_pt, result_arith);
        return result;
    end;
    function fractional_bits(a_bin_pt, b_bin_pt: INTEGER) return INTEGER is
    begin
        return max(a_bin_pt, b_bin_pt);
    end;
    function integer_bits(a_width, a_bin_pt, b_width, b_bin_pt: INTEGER)
        return INTEGER is
    begin
        return  max(a_width - a_bin_pt, b_width - b_bin_pt);
    end;
    function pad_LSB(inp : std_logic_vector; new_width: integer)
        return STD_LOGIC_VECTOR
    is
        constant orig_width : integer := inp'length;
        variable vec : std_logic_vector(orig_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
        variable pos : integer;
        constant pad_pos : integer := new_width - orig_width - 1;
    begin
        vec := inp;
        pos := new_width-1;
        if (new_width >= orig_width) then
            for i in orig_width-1 downto 0 loop
                result(pos) := vec(i);
                pos := pos - 1;
            end loop;
            if pad_pos >= 0 then
                for i in pad_pos downto 0 loop
                    result(i) := '0';
                end loop;
            end if;
        end if;
        return result;
    end;
    function sign_ext(inp : std_logic_vector; new_width : INTEGER)
        return std_logic_vector
    is
        constant old_width : integer := inp'length;
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if new_width >= old_width then
            result(old_width-1 downto 0) := vec;
            if new_width-1 >= old_width then
                for i in new_width-1 downto old_width loop
                    result(i) := vec(old_width-1);
                end loop;
            end if;
        else
            result(new_width-1 downto 0) := vec(new_width-1 downto 0);
        end if;
        return result;
    end;
    function zero_ext(inp : std_logic_vector; new_width : INTEGER)
        return std_logic_vector
    is
        constant old_width : integer := inp'length;
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if new_width >= old_width then
            result(old_width-1 downto 0) := vec;
            if new_width-1 >= old_width then
                for i in new_width-1 downto old_width loop
                    result(i) := '0';
                end loop;
            end if;
        else
            result(new_width-1 downto 0) := vec(new_width-1 downto 0);
        end if;
        return result;
    end;
    function zero_ext(inp : std_logic; new_width : INTEGER)
        return std_logic_vector
    is
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        result(0) := inp;
        for i in new_width-1 downto 1 loop
            result(i) := '0';
        end loop;
        return result;
    end;
    function extend_MSB(inp : std_logic_vector; new_width, arith : INTEGER)
        return std_logic_vector
    is
        constant orig_width : integer := inp'length;
        variable vec : std_logic_vector(orig_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if arith = xlUnsigned then
            result := zero_ext(vec, new_width);
        else
            result := sign_ext(vec, new_width);
        end if;
        return result;
    end;
    function pad_LSB(inp : std_logic_vector; new_width, arith: integer)
        return STD_LOGIC_VECTOR
    is
        constant orig_width : integer := inp'length;
        variable vec : std_logic_vector(orig_width-1 downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
        variable pos : integer;
    begin
        vec := inp;
        pos := new_width-1;
        if (arith = xlUnsigned) then
            result(pos) := '0';
            pos := pos - 1;
        else
            result(pos) := vec(orig_width-1);
            pos := pos - 1;
        end if;
        if (new_width >= orig_width) then
            for i in orig_width-1 downto 0 loop
                result(pos) := vec(i);
                pos := pos - 1;
            end loop;
            if pos >= 0 then
                for i in pos downto 0 loop
                    result(i) := '0';
                end loop;
            end if;
        end if;
        return result;
    end;
    function align_input(inp : std_logic_vector; old_width, delta, new_arith,
                         new_width: INTEGER)
        return std_logic_vector
    is
        variable vec : std_logic_vector(old_width-1 downto 0);
        variable padded_inp : std_logic_vector((old_width + delta)-1  downto 0);
        variable result : std_logic_vector(new_width-1 downto 0);
    begin
        vec := inp;
        if delta > 0 then
            padded_inp := pad_LSB(vec, old_width+delta);
            result := extend_MSB(padded_inp, new_width, new_arith);
        else
            result := extend_MSB(vec, new_width, new_arith);
        end if;
        return result;
    end;
    function max(L, R: INTEGER) return INTEGER is
    begin
        if L > R then
            return L;
        else
            return R;
        end if;
    end;
    function min(L, R: INTEGER) return INTEGER is
    begin
        if L < R then
            return L;
        else
            return R;
        end if;
    end;
    function "="(left,right: STRING) return boolean is
    begin
        if (left'length /= right'length) then
            return false;
        else
            test : for i in 1 to left'length loop
                if left(i) /= right(i) then
                    return false;
                end if;
            end loop test;
            return true;
        end if;
    end;
    -- synopsys translate_off
    function is_binary_string_invalid (inp : string)
        return boolean
    is
        variable vec : string(1 to inp'length);
        variable result : boolean;
    begin
        vec := inp;
        result := false;
        for i in 1 to vec'length loop
            if ( vec(i) = 'X' ) then
                result := true;
            end if;
        end loop;
        return result;
    end;
    function is_binary_string_undefined (inp : string)
        return boolean
    is
        variable vec : string(1 to inp'length);
        variable result : boolean;
    begin
        vec := inp;
        result := false;
        for i in 1 to vec'length loop
            if ( vec(i) = 'U' ) then
                result := true;
            end if;
        end loop;
        return result;
    end;
    function is_XorU(inp : std_logic_vector)
        return boolean
    is
        constant width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
        variable result : boolean;
    begin
        vec := inp;
        result := false;
        for i in 0 to width-1 loop
            if (vec(i) = 'U') or (vec(i) = 'X') then
                result := true;
            end if;
        end loop;
        return result;
    end;
    function to_real(inp : std_logic_vector; bin_pt : integer; arith : integer)
        return real
    is
        variable  vec : std_logic_vector(inp'length-1 downto 0);
        variable result, shift_val, undefined_real : real;
        variable neg_num : boolean;
    begin
        vec := inp;
        result := 0.0;
        neg_num := false;
        if vec(inp'length-1) = '1' then
            neg_num := true;
        end if;
        for i in 0 to inp'length-1 loop
            if  vec(i) = 'U' or vec(i) = 'X' then
                return undefined_real;
            end if;
            if arith = xlSigned then
                if neg_num then
                    if vec(i) = '0' then
                        result := result + 2.0**i;
                    end if;
                else
                    if vec(i) = '1' then
                        result := result + 2.0**i;
                    end if;
                end if;
            else
                if vec(i) = '1' then
                    result := result + 2.0**i;
                end if;
            end if;
        end loop;
        if arith = xlSigned then
            if neg_num then
                result := result + 1.0;
                result := result * (-1.0);
            end if;
        end if;
        shift_val := 2.0**(-1*bin_pt);
        result := result * shift_val;
        return result;
    end;
    function std_logic_to_real(inp : std_logic; bin_pt : integer; arith : integer)
        return real
    is
        variable result : real := 0.0;
    begin
        if inp = '1' then
            result := 1.0;
        end if;
        if arith = xlSigned then
            assert false
                report "It doesn't make sense to convert a 1 bit number to a signed real.";
        end if;
        return result;
    end;
    -- synopsys translate_on
    function integer_to_std_logic_vector (inp : integer;  width, arith : integer)
        return std_logic_vector
    is
        variable result : std_logic_vector(width-1 downto 0);
        variable unsigned_val : unsigned(width-1 downto 0);
        variable signed_val : signed(width-1 downto 0);
    begin
        if (arith = xlSigned) then
            signed_val := to_signed(inp, width);
            result := signed_to_std_logic_vector(signed_val);
        else
            unsigned_val := to_unsigned(inp, width);
            result := unsigned_to_std_logic_vector(unsigned_val);
        end if;
        return result;
    end;
    function std_logic_vector_to_integer (inp : std_logic_vector;  arith : integer)
        return integer
    is
        constant width : integer := inp'length;
        variable unsigned_val : unsigned(width-1 downto 0);
        variable signed_val : signed(width-1 downto 0);
        variable result : integer;
    begin
        if (arith = xlSigned) then
            signed_val := std_logic_vector_to_signed(inp);
            result := to_integer(signed_val);
        else
            unsigned_val := std_logic_vector_to_unsigned(inp);
            result := to_integer(unsigned_val);
        end if;
        return result;
    end;
    function std_logic_to_integer(constant inp : std_logic := '0')
        return integer
    is
    begin
        if inp = '1' then
            return 1;
        else
            return 0;
        end if;
    end;
    function makeZeroBinStr (width : integer) return STRING is
        variable result : string(1 to width+3);
    begin
        result(1) := '0';
        result(2) := 'b';
        for i in 3 to width+2 loop
            result(i) := '0';
        end loop;
        result(width+3) := '.';
        return result;
    end;
    -- synopsys translate_off
    function real_string_to_std_logic_vector (inp : string;  width, bin_pt, arith : integer)
        return std_logic_vector
    is
        variable result : std_logic_vector(width-1 downto 0);
    begin
        result := (others => '0');
        return result;
    end;
    function real_to_std_logic_vector (inp : real;  width, bin_pt, arith : integer)
        return std_logic_vector
    is
        variable real_val : real;
        variable int_val : integer;
        variable result : std_logic_vector(width-1 downto 0) := (others => '0');
        variable unsigned_val : unsigned(width-1 downto 0) := (others => '0');
        variable signed_val : signed(width-1 downto 0) := (others => '0');
    begin
        real_val := inp;
        int_val := integer(real_val * 2.0**(bin_pt));
        if (arith = xlSigned) then
            signed_val := to_signed(int_val, width);
            result := signed_to_std_logic_vector(signed_val);
        else
            unsigned_val := to_unsigned(int_val, width);
            result := unsigned_to_std_logic_vector(unsigned_val);
        end if;
        return result;
    end;
    -- synopsys translate_on
    function valid_bin_string (inp : string)
        return boolean
    is
        variable vec : string(1 to inp'length);
    begin
        vec := inp;
        if (vec(1) = '0' and vec(2) = 'b') then
            return true;
        else
            return false;
        end if;
    end;
    function hex_string_to_std_logic_vector(inp: string; width : integer)
        return std_logic_vector is
        constant strlen       : integer := inp'LENGTH;
        variable result       : std_logic_vector(width-1 downto 0);
        variable bitval       : std_logic_vector((strlen*4)-1 downto 0);
        variable posn         : integer;
        variable ch           : character;
        variable vec          : string(1 to strlen);
    begin
        vec := inp;
        result := (others => '0');
        posn := (strlen*4)-1;
        for i in 1 to strlen loop
            ch := vec(i);
            case ch is
                when '0' => bitval(posn downto posn-3) := "0000";
                when '1' => bitval(posn downto posn-3) := "0001";
                when '2' => bitval(posn downto posn-3) := "0010";
                when '3' => bitval(posn downto posn-3) := "0011";
                when '4' => bitval(posn downto posn-3) := "0100";
                when '5' => bitval(posn downto posn-3) := "0101";
                when '6' => bitval(posn downto posn-3) := "0110";
                when '7' => bitval(posn downto posn-3) := "0111";
                when '8' => bitval(posn downto posn-3) := "1000";
                when '9' => bitval(posn downto posn-3) := "1001";
                when 'A' | 'a' => bitval(posn downto posn-3) := "1010";
                when 'B' | 'b' => bitval(posn downto posn-3) := "1011";
                when 'C' | 'c' => bitval(posn downto posn-3) := "1100";
                when 'D' | 'd' => bitval(posn downto posn-3) := "1101";
                when 'E' | 'e' => bitval(posn downto posn-3) := "1110";
                when 'F' | 'f' => bitval(posn downto posn-3) := "1111";
                when others => bitval(posn downto posn-3) := "XXXX";
                               -- synopsys translate_off
                               ASSERT false
                                   REPORT "Invalid hex value" SEVERITY ERROR;
                               -- synopsys translate_on
            end case;
            posn := posn - 4;
        end loop;
        if (width <= strlen*4) then
            result :=  bitval(width-1 downto 0);
        else
            result((strlen*4)-1 downto 0) := bitval;
        end if;
        return result;
    end;
    function bin_string_to_std_logic_vector (inp : string)
        return std_logic_vector
    is
        variable pos : integer;
        variable vec : string(1 to inp'length);
        variable result : std_logic_vector(inp'length-1 downto 0);
    begin
        vec := inp;
        pos := inp'length-1;
        result := (others => '0');
        for i in 1 to vec'length loop
            -- synopsys translate_off
            if (pos < 0) and (vec(i) = '0' or vec(i) = '1' or vec(i) = 'X' or vec(i) = 'U')  then
                assert false
                    report "Input string is larger than output std_logic_vector. Truncating output.";
                return result;
            end if;
            -- synopsys translate_on
            if vec(i) = '0' then
                result(pos) := '0';
                pos := pos - 1;
            end if;
            if vec(i) = '1' then
                result(pos) := '1';
                pos := pos - 1;
            end if;
            -- synopsys translate_off
            if (vec(i) = 'X' or vec(i) = 'U') then
                result(pos) := 'U';
                pos := pos - 1;
            end if;
            -- synopsys translate_on
        end loop;
        return result;
    end;
    function bin_string_element_to_std_logic_vector (inp : string;  width, index : integer)
        return std_logic_vector
    is
        constant str_width : integer := width + 4;
        constant inp_len : integer := inp'length;
        constant num_elements : integer := (inp_len + 1)/str_width;
        constant reverse_index : integer := (num_elements-1) - index;
        variable left_pos : integer;
        variable right_pos : integer;
        variable vec : string(1 to inp'length);
        variable result : std_logic_vector(width-1 downto 0);
    begin
        vec := inp;
        result := (others => '0');
        if (reverse_index = 0) and (reverse_index < num_elements) and (inp_len-3 >= width) then
            left_pos := 1;
            right_pos := width + 3;
            result := bin_string_to_std_logic_vector(vec(left_pos to right_pos));
        end if;
        if (reverse_index > 0) and (reverse_index < num_elements) and (inp_len-3 >= width) then
            left_pos := (reverse_index * str_width) + 1;
            right_pos := left_pos + width + 2;
            result := bin_string_to_std_logic_vector(vec(left_pos to right_pos));
        end if;
        return result;
    end;
   -- synopsys translate_off
    function std_logic_vector_to_bin_string(inp : std_logic_vector)
        return string
    is
        variable vec : std_logic_vector(1 to inp'length);
        variable result : string(vec'range);
    begin
        vec := inp;
        for i in vec'range loop
            result(i) := to_char(vec(i));
        end loop;
        return result;
    end;
    function std_logic_to_bin_string(inp : std_logic)
        return string
    is
        variable result : string(1 to 3);
    begin
        result(1) := '0';
        result(2) := 'b';
        result(3) := to_char(inp);
        return result;
    end;
    function std_logic_vector_to_bin_string_w_point(inp : std_logic_vector; bin_pt : integer)
        return string
    is
        variable width : integer := inp'length;
        variable vec : std_logic_vector(width-1 downto 0);
        variable str_pos : integer;
        variable result : string(1 to width+3);
    begin
        vec := inp;
        str_pos := 1;
        result(str_pos) := '0';
        str_pos := 2;
        result(str_pos) := 'b';
        str_pos := 3;
        for i in width-1 downto 0  loop
            if (((width+3) - bin_pt) = str_pos) then
                result(str_pos) := '.';
                str_pos := str_pos + 1;
            end if;
            result(str_pos) := to_char(vec(i));
            str_pos := str_pos + 1;
        end loop;
        if (bin_pt = 0) then
            result(str_pos) := '.';
        end if;
        return result;
    end;
    function real_to_bin_string(inp : real;  width, bin_pt, arith : integer)
        return string
    is
        variable result : string(1 to width);
        variable vec : std_logic_vector(width-1 downto 0);
    begin
        vec := real_to_std_logic_vector(inp, width, bin_pt, arith);
        result := std_logic_vector_to_bin_string(vec);
        return result;
    end;
    function real_to_string (inp : real) return string
    is
        variable result : string(1 to display_precision) := (others => ' ');
    begin
        result(real'image(inp)'range) := real'image(inp);
        return result;
    end;
    -- synopsys translate_on
end conv_pkg;

-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity srl17e is
    generic (width : integer:=16;
             latency : integer :=8);
    port (clk   : in std_logic;
          ce    : in std_logic;
          d     : in std_logic_vector(width-1 downto 0);
          q     : out std_logic_vector(width-1 downto 0));
end srl17e;
architecture structural of srl17e is
    component SRL16E
        port (D   : in STD_ULOGIC;
              CE  : in STD_ULOGIC;
              CLK : in STD_ULOGIC;
              A0  : in STD_ULOGIC;
              A1  : in STD_ULOGIC;
              A2  : in STD_ULOGIC;
              A3  : in STD_ULOGIC;
              Q   : out STD_ULOGIC);
    end component;
    attribute syn_black_box of SRL16E : component is true;
    attribute fpga_dont_touch of SRL16E : component is "true";
    component FDE
        port(
            Q  :        out   STD_ULOGIC;
            D  :        in    STD_ULOGIC;
            C  :        in    STD_ULOGIC;
            CE :        in    STD_ULOGIC);
    end component;
    attribute syn_black_box of FDE : component is true;
    attribute fpga_dont_touch of FDE : component is "true";
    constant a : std_logic_vector(4 downto 0) :=
        integer_to_std_logic_vector(latency-2,5,xlSigned);
    signal d_delayed : std_logic_vector(width-1 downto 0);
    signal srl16_out : std_logic_vector(width-1 downto 0);
begin
    d_delayed <= d after 200 ps;
    reg_array : for i in 0 to width-1 generate
        srl16_used: if latency > 1 generate
            u1 : srl16e port map(clk => clk,
                                 d => d_delayed(i),
                                 q => srl16_out(i),
                                 ce => ce,
                                 a0 => a(0),
                                 a1 => a(1),
                                 a2 => a(2),
                                 a3 => a(3));
        end generate;
        srl16_not_used: if latency <= 1 generate
            srl16_out(i) <= d_delayed(i);
        end generate;
        fde_used: if latency /= 0  generate
            u2 : fde port map(c => clk,
                              d => srl16_out(i),
                              q => q(i),
                              ce => ce);
        end generate;
        fde_not_used: if latency = 0  generate
            q(i) <= srl16_out(i);
        end generate;
    end generate;
 end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity synth_reg is
    generic (width           : integer := 8;
             latency         : integer := 1);
    port (i       : in std_logic_vector(width-1 downto 0);
          ce      : in std_logic;
          clr     : in std_logic;
          clk     : in std_logic;
          o       : out std_logic_vector(width-1 downto 0));
end synth_reg;
architecture structural of synth_reg is
    component srl17e
        generic (width : integer:=16;
                 latency : integer :=8);
        port (clk : in std_logic;
              ce  : in std_logic;
              d   : in std_logic_vector(width-1 downto 0);
              q   : out std_logic_vector(width-1 downto 0));
    end component;
    function calc_num_srl17es (latency : integer)
        return integer
    is
        variable remaining_latency : integer;
        variable result : integer;
    begin
        result := latency / 17;
        remaining_latency := latency - (result * 17);
        if (remaining_latency /= 0) then
            result := result + 1;
        end if;
        return result;
    end;
    constant complete_num_srl17es : integer := latency / 17;
    constant num_srl17es : integer := calc_num_srl17es(latency);
    constant remaining_latency : integer := latency - (complete_num_srl17es * 17);
    type register_array is array (num_srl17es downto 0) of
        std_logic_vector(width-1 downto 0);
    signal z : register_array;
begin
    z(0) <= i;
    complete_ones : if complete_num_srl17es > 0 generate
        srl17e_array: for i in 0 to complete_num_srl17es-1 generate
            delay_comp : srl17e
                generic map (width => width,
                             latency => 17)
                port map (clk => clk,
                          ce  => ce,
                          d       => z(i),
                          q       => z(i+1));
        end generate;
    end generate;
    partial_one : if remaining_latency > 0 generate
        last_srl17e : srl17e
            generic map (width => width,
                         latency => remaining_latency)
            port map (clk => clk,
                      ce  => ce,
                      d   => z(num_srl17es-1),
                      q   => z(num_srl17es));
    end generate;
    o <= z(num_srl17es);
end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity synth_reg_reg is
    generic (width           : integer := 8;
             latency         : integer := 1);
    port (i       : in std_logic_vector(width-1 downto 0);
          ce      : in std_logic;
          clr     : in std_logic;
          clk     : in std_logic;
          o       : out std_logic_vector(width-1 downto 0));
end synth_reg_reg;
architecture behav of synth_reg_reg is
  type reg_array_type is array (latency-1 downto 0) of std_logic_vector(width -1 downto 0);
  signal reg_bank : reg_array_type := (others => (others => '0'));
  signal reg_bank_in : reg_array_type := (others => (others => '0'));
  attribute syn_allow_retiming : boolean;
  attribute syn_srlstyle : string;
  attribute syn_allow_retiming of reg_bank : signal is true;
  attribute syn_allow_retiming of reg_bank_in : signal is true;
  attribute syn_srlstyle of reg_bank : signal is "registers";
  attribute syn_srlstyle of reg_bank_in : signal is "registers";
begin
  latency_eq_0: if latency = 0 generate
    o <= i;
  end generate latency_eq_0;
  latency_gt_0: if latency >= 1 generate
    o <= reg_bank(latency-1);
    reg_bank_in(0) <= i;
    loop_gen: for idx in latency-2 downto 0 generate
      reg_bank_in(idx+1) <= reg_bank(idx);
    end generate loop_gen;
    sync_loop: for sync_idx in latency-1 downto 0 generate
      sync_proc: process (clk)
      begin
        if clk'event and clk = '1' then
          if ce = '1'  then
            reg_bank(sync_idx) <= reg_bank_in(sync_idx);
          end if;
        end if;
      end process sync_proc;
    end generate sync_loop;
  end generate latency_gt_0;
end behav;

-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity single_reg_w_init is
  generic (
    width: integer := 8;
    init_index: integer := 0;
    init_value: bit_vector := b"0000"
  );
  port (
    i: in std_logic_vector(width - 1 downto 0);
    ce: in std_logic;
    clr: in std_logic;
    clk: in std_logic;
    o: out std_logic_vector(width - 1 downto 0)
  );
end single_reg_w_init;
architecture structural of single_reg_w_init is
  function build_init_const(width: integer;
                            init_index: integer;
                            init_value: bit_vector)
    return std_logic_vector
  is
    variable result: std_logic_vector(width - 1 downto 0);
  begin
    if init_index = 0 then
      result := (others => '0');
    elsif init_index = 1 then
      result := (others => '0');
      result(0) := '1';
    else
      result := to_stdlogicvector(init_value);
    end if;
    return result;
  end;
  component fdre
    port (
      q: out std_ulogic;
      d: in  std_ulogic;
      c: in  std_ulogic;
      ce: in  std_ulogic;
      r: in  std_ulogic
    );
  end component;
  attribute syn_black_box of fdre: component is true;
  attribute fpga_dont_touch of fdre: component is "true";
  component fdse
    port (
      q: out std_ulogic;
      d: in  std_ulogic;
      c: in  std_ulogic;
      ce: in  std_ulogic;
      s: in  std_ulogic
    );
  end component;
  attribute syn_black_box of fdse: component is true;
  attribute fpga_dont_touch of fdse: component is "true";
  constant init_const: std_logic_vector(width - 1 downto 0)
    := build_init_const(width, init_index, init_value);
begin
  fd_prim_array: for index in 0 to width - 1 generate
    bit_is_0: if (init_const(index) = '0') generate
      fdre_comp: fdre
        port map (
          c => clk,
          d => i(index),
          q => o(index),
          ce => ce,
          r => clr
        );
    end generate;
    bit_is_1: if (init_const(index) = '1') generate
      fdse_comp: fdse
        port map (
          c => clk,
          d => i(index),
          q => o(index),
          ce => ce,
          s => clr
        );
    end generate;
  end generate;
end architecture structural;
-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity synth_reg_w_init is
  generic (
    width: integer := 8;
    init_index: integer := 0;
    init_value: bit_vector := b"0000";
    latency: integer := 1
  );
  port (
    i: in std_logic_vector(width - 1 downto 0);
    ce: in std_logic;
    clr: in std_logic;
    clk: in std_logic;
    o: out std_logic_vector(width - 1 downto 0)
  );
end synth_reg_w_init;
architecture structural of synth_reg_w_init is
  component single_reg_w_init
    generic (
      width: integer := 8;
      init_index: integer := 0;
      init_value: bit_vector := b"0000"
    );
    port (
      i: in std_logic_vector(width - 1 downto 0);
      ce: in std_logic;
      clr: in std_logic;
      clk: in std_logic;
      o: out std_logic_vector(width - 1 downto 0)
    );
  end component;
  signal dly_i: std_logic_vector((latency + 1) * width - 1 downto 0);
  signal dly_clr: std_logic;
begin
  latency_eq_0: if (latency = 0) generate
    o <= i;
  end generate;
  latency_gt_0: if (latency >= 1) generate
    dly_i((latency + 1) * width - 1 downto latency * width) <= i
      after 200 ps;
    dly_clr <= clr after 200 ps;
    fd_array: for index in latency downto 1 generate
       reg_comp: single_reg_w_init
          generic map (
            width => width,
            init_index => init_index,
            init_value => init_value
          )
          port map (
            clk => clk,
            i => dly_i((index + 1) * width - 1 downto index * width),
            o => dly_i(index * width - 1 downto (index - 1) * width),
            ce => ce,
            clr => dly_clr
          );
    end generate;
    o <= dly_i(width - 1 downto 0);
  end generate;
end structural;

-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- synopsys translate_off
library XilinxCoreLib;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.conv_pkg.all;
entity xladdsub is
  generic (
    core_name0: string := "";
    a_width: integer := 16;
    a_bin_pt: integer := 4;
    a_arith: integer := xlUnsigned;
    c_in_width: integer := 16;
    c_in_bin_pt: integer := 4;
    c_in_arith: integer := xlUnsigned;
    c_out_width: integer := 16;
    c_out_bin_pt: integer := 4;
    c_out_arith: integer := xlUnsigned;
    b_width: integer := 8;
    b_bin_pt: integer := 2;
    b_arith: integer := xlUnsigned;
    s_width: integer := 17;
    s_bin_pt: integer := 4;
    s_arith: integer := xlUnsigned;
    rst_width: integer := 1;
    rst_bin_pt: integer := 0;
    rst_arith: integer := xlUnsigned;
    en_width: integer := 1;
    en_bin_pt: integer := 0;
    en_arith: integer := xlUnsigned;
    full_s_width: integer := 17;
    full_s_arith: integer := xlUnsigned;
    mode: integer := xlAddMode;
    extra_registers: integer := 0;
    latency: integer := 0;
    quantization: integer := xlTruncate;
    overflow: integer := xlWrap;
    c_latency: integer := 0;
    c_output_width: integer := 17;
    c_has_c_in : integer := 0;
    c_has_c_out : integer := 0
  );
  port (
    a: in std_logic_vector(a_width - 1 downto 0);
    b: in std_logic_vector(b_width - 1 downto 0);
    c_in : in std_logic_vector (0 downto 0) := "0";
    ce: in std_logic;
    clr: in std_logic := '0';
    clk: in std_logic;
    rst: in std_logic_vector(rst_width - 1 downto 0) := "0";
    en: in std_logic_vector(en_width - 1 downto 0) := "1";
    c_out : out std_logic_vector (0 downto 0);
    s: out std_logic_vector(s_width - 1 downto 0)
  );
end xladdsub;
architecture behavior of xladdsub is
  component synth_reg
    generic (
      width: integer := 16;
      latency: integer := 5
    );
    port (
      i: in std_logic_vector(width - 1 downto 0);
      ce: in std_logic;
      clr: in std_logic;
      clk: in std_logic;
      o: out std_logic_vector(width - 1 downto 0)
    );
  end component;
  function format_input(inp: std_logic_vector; old_width, delta, new_arith,
                        new_width: integer)
    return std_logic_vector
  is
    variable vec: std_logic_vector(old_width-1 downto 0);
    variable padded_inp: std_logic_vector((old_width + delta)-1  downto 0);
    variable result: std_logic_vector(new_width-1 downto 0);
  begin
    vec := inp;
    if (delta > 0) then
      padded_inp := pad_LSB(vec, old_width+delta);
      result := extend_MSB(padded_inp, new_width, new_arith);
    else
      result := extend_MSB(vec, new_width, new_arith);
    end if;
    return result;
  end;
  constant full_s_bin_pt: integer := fractional_bits(a_bin_pt, b_bin_pt);
  constant full_a_width: integer := full_s_width;
  constant full_b_width: integer := full_s_width;
  signal full_a: std_logic_vector(full_a_width - 1 downto 0);
  signal full_b: std_logic_vector(full_b_width - 1 downto 0);
  signal core_s: std_logic_vector(full_s_width - 1 downto 0);
  signal conv_s: std_logic_vector(s_width - 1 downto 0);
  signal temp_cout : std_logic;
  signal internal_clr: std_logic;
  signal internal_ce: std_logic;
  signal extra_reg_ce: std_logic;
  signal override: std_logic;
  signal logic1: std_logic_vector(0 downto 0);
  component addsb_11_0_fb4bc67ba183533a
    port (
          a: in std_logic_vector(33 - 1 downto 0);
    s: out std_logic_vector(c_output_width - 1 downto 0);
    b: in std_logic_vector(33 - 1 downto 0)
    );
  end component;
  attribute syn_black_box of addsb_11_0_fb4bc67ba183533a:
    component is true;
  attribute fpga_dont_touch of addsb_11_0_fb4bc67ba183533a:
    component is "true";
  attribute box_type of addsb_11_0_fb4bc67ba183533a:
    component  is "black_box";
begin
  internal_clr <= (clr or (rst(0))) and ce;
  internal_ce <= ce and en(0);
  logic1(0) <= '1';
  addsub_process: process (a, b, core_s)
  begin
    full_a <= format_input (a, a_width, b_bin_pt - a_bin_pt, a_arith,
                            full_a_width);
    full_b <= format_input (b, b_width, a_bin_pt - b_bin_pt, b_arith,
                            full_b_width);
    conv_s <= convert_type (core_s, full_s_width, full_s_bin_pt, full_s_arith,
                            s_width, s_bin_pt, s_arith, quantization, overflow);
  end process addsub_process;

  comp0: if ((core_name0 = "addsb_11_0_fb4bc67ba183533a")) generate
    core_instance0: addsb_11_0_fb4bc67ba183533a
      port map (
         a => full_a,
         s => core_s,
         b => full_b
      );
  end generate;
  latency_test: if (extra_registers > 0) generate
      override_test: if (c_latency > 1) generate
       override_pipe: synth_reg
          generic map (
            width => 1,
            latency => c_latency
          )
          port map (
            i => logic1,
            ce => internal_ce,
            clr => internal_clr,
            clk => clk,
            o(0) => override);
       extra_reg_ce <= ce and en(0) and override;
      end generate override_test;
      no_override: if ((c_latency = 0) or (c_latency = 1)) generate
       extra_reg_ce <= ce and en(0);
      end generate no_override;
      extra_reg: synth_reg
        generic map (
          width => s_width,
          latency => extra_registers
        )
        port map (
          i => conv_s,
          ce => extra_reg_ce,
          clr => internal_clr,
          clk => clk,
          o => s
        );
      cout_test: if (c_has_c_out = 1) generate
      c_out_extra_reg: synth_reg
        generic map (
          width => 1,
          latency => extra_registers
        )
        port map (
          i(0) => temp_cout,
          ce => extra_reg_ce,
          clr => internal_clr,
          clk => clk,
          o => c_out
        );
      end generate cout_test;
  end generate;
  latency_s: if ((latency = 0) or (extra_registers = 0)) generate
    s <= conv_s;
  end generate latency_s;
  latency0: if (((latency = 0) or (extra_registers = 0)) and
                 (c_has_c_out = 1)) generate
    c_out(0) <= temp_cout;
  end generate latency0;
  tie_dangling_cout: if (c_has_c_out = 0) generate
    c_out <= "0";
  end generate tie_dangling_cout;
end architecture behavior;

-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity convert_func_call is
    generic (
        din_width    : integer := 16;
        din_bin_pt   : integer := 4;
        din_arith    : integer := xlUnsigned;
        dout_width   : integer := 8;
        dout_bin_pt  : integer := 2;
        dout_arith   : integer := xlUnsigned;
        quantization : integer := xlTruncate;
        overflow     : integer := xlWrap);
    port (
        din : in std_logic_vector (din_width-1 downto 0);
        result : out std_logic_vector (dout_width-1 downto 0));
end convert_func_call;
architecture behavior of convert_func_call is
begin
    result <= convert_type(din, din_width, din_bin_pt, din_arith,
                           dout_width, dout_bin_pt, dout_arith,
                           quantization, overflow);
end behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity xlconvert is
    generic (
        din_width    : integer := 16;
        din_bin_pt   : integer := 4;
        din_arith    : integer := xlUnsigned;
        dout_width   : integer := 8;
        dout_bin_pt  : integer := 2;
        dout_arith   : integer := xlUnsigned;
        en_width     : integer := 1;
        en_bin_pt    : integer := 0;
        en_arith     : integer := xlUnsigned;
        bool_conversion : integer :=0;
        latency      : integer := 0;
        quantization : integer := xlTruncate;
        overflow     : integer := xlWrap);
    port (
        din : in std_logic_vector (din_width-1 downto 0);
        en  : in std_logic_vector (en_width-1 downto 0);
        ce  : in std_logic;
        clr : in std_logic;
        clk : in std_logic;
        dout : out std_logic_vector (dout_width-1 downto 0));
end xlconvert;
architecture behavior of xlconvert is
    component synth_reg
        generic (width       : integer;
                 latency     : integer);
        port (i       : in std_logic_vector(width-1 downto 0);
              ce      : in std_logic;
              clr     : in std_logic;
              clk     : in std_logic;
              o       : out std_logic_vector(width-1 downto 0));
    end component;
    component convert_func_call
        generic (
            din_width    : integer := 16;
            din_bin_pt   : integer := 4;
            din_arith    : integer := xlUnsigned;
            dout_width   : integer := 8;
            dout_bin_pt  : integer := 2;
            dout_arith   : integer := xlUnsigned;
            quantization : integer := xlTruncate;
            overflow     : integer := xlWrap);
        port (
            din : in std_logic_vector (din_width-1 downto 0);
            result : out std_logic_vector (dout_width-1 downto 0));
    end component;
    -- synopsys translate_off
    -- synopsys translate_on
    signal result : std_logic_vector(dout_width-1 downto 0);
    signal internal_ce : std_logic;
begin
    -- synopsys translate_off
    -- synopsys translate_on
    internal_ce <= ce and en(0);

    bool_conversion_generate : if (bool_conversion = 1)
    generate
      result <= din;
    end generate;
    std_conversion_generate : if (bool_conversion = 0)
    generate
      convert : convert_func_call
        generic map (
          din_width   => din_width,
          din_bin_pt  => din_bin_pt,
          din_arith   => din_arith,
          dout_width  => dout_width,
          dout_bin_pt => dout_bin_pt,
          dout_arith  => dout_arith,
          quantization => quantization,
          overflow     => overflow)
        port map (
          din => din,
          result => result);
    end generate;
    latency_test : if (latency > 0) generate
        reg : synth_reg
            generic map (
              width => dout_width,
              latency => latency
            )
            port map (
              i => result,
              ce => internal_ce,
              clr => clr,
              clk => clk,
              o => dout
            );
    end generate;
    latency0 : if (latency = 0)
    generate
        dout <= result;
    end generate latency0;
end  behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_f6397bdee1 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_f6397bdee1;


architecture behavior of logical_f6397bdee1 is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal bit_2_27: std_logic;
  signal fully_2_1_bitnot: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  bit_2_27 <= d0_1_24 xor d1_1_27;
  fully_2_1_bitnot <= not bit_2_27;
  y <= std_logic_to_vector(fully_2_1_bitnot);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_e77c53f8bd is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_e77c53f8bd;


architecture behavior of logical_e77c53f8bd is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 xor d1_1_27;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_80f90b97d0 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_80f90b97d0;


architecture behavior of logical_80f90b97d0 is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.conv_pkg.all;
entity xlslice is
    generic (
        new_msb      : integer := 9;
        new_lsb      : integer := 1;
        x_width      : integer := 16;
        y_width      : integer := 8);
    port (
        x : in std_logic_vector (x_width-1 downto 0);
        y : out std_logic_vector (y_width-1 downto 0));
end xlslice;
architecture behavior of xlslice is
begin
    y <= x(new_msb downto new_lsb);
end  behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_2dc093ca7a is
  port (
    in0 : in std_logic_vector((1 - 1) downto 0);
    in1 : in std_logic_vector((1 - 1) downto 0);
    in2 : in std_logic_vector((1 - 1) downto 0);
    in3 : in std_logic_vector((1 - 1) downto 0);
    in4 : in std_logic_vector((1 - 1) downto 0);
    in5 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((6 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_2dc093ca7a;


architecture behavior of concat_2dc093ca7a is
  signal in0_1_23: unsigned((1 - 1) downto 0);
  signal in1_1_27: unsigned((1 - 1) downto 0);
  signal in2_1_31: unsigned((1 - 1) downto 0);
  signal in3_1_35: unsigned((1 - 1) downto 0);
  signal in4_1_39: unsigned((1 - 1) downto 0);
  signal in5_1_43: unsigned((1 - 1) downto 0);
  signal y_2_1_concat: unsigned((6 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  in3_1_35 <= std_logic_vector_to_unsigned(in3);
  in4_1_39 <= std_logic_vector_to_unsigned(in4);
  in5_1_43 <= std_logic_vector_to_unsigned(in5);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31) & unsigned_to_std_logic_vector(in3_1_35) & unsigned_to_std_logic_vector(in4_1_39) & unsigned_to_std_logic_vector(in5_1_43));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_09c011ee04 is
  port (
    in0 : in std_logic_vector((6 - 1) downto 0);
    in1 : in std_logic_vector((1 - 1) downto 0);
    in2 : in std_logic_vector((1 - 1) downto 0);
    in3 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((9 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_09c011ee04;


architecture behavior of concat_09c011ee04 is
  signal in0_1_23: unsigned((6 - 1) downto 0);
  signal in1_1_27: boolean;
  signal in2_1_31: boolean;
  signal in3_1_35: boolean;
  signal y_2_1_concat: unsigned((9 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= ((in1) = "1");
  in2_1_31 <= ((in2) = "1");
  in3_1_35 <= ((in3) = "1");
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & boolean_to_vector(in1_1_27) & boolean_to_vector(in2_1_31) & boolean_to_vector(in3_1_35));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_fe7b06fbf5 is
  port (
    in0 : in std_logic_vector((32 - 1) downto 0);
    in1 : in std_logic_vector((32 - 1) downto 0);
    in2 : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((96 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_fe7b06fbf5;


architecture behavior of concat_fe7b06fbf5 is
  signal in0_1_23: unsigned((32 - 1) downto 0);
  signal in1_1_27: unsigned((32 - 1) downto 0);
  signal in2_1_31: unsigned((32 - 1) downto 0);
  signal y_2_1_concat: unsigned((96 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_fd28b32bf8 is
  port (
    op : out std_logic_vector((12 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_fd28b32bf8;


architecture behavior of constant_fd28b32bf8 is
begin
  op <= "000000000000";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_6cb8f0ce02 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    d2 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_6cb8f0ce02;


architecture behavior of logical_6cb8f0ce02 is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal d2_1_30: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  d2_1_30 <= d2(0);
  fully_2_1_bit <= d0_1_24 or d1_1_27 or d2_1_30;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- synopsys translate_off
library XilinxCoreLib;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity xlcounter_free is
  generic (
    core_name0: string := "";
    op_width: integer := 5;
    op_arith: integer := xlSigned
  );
  port (
    ce: in std_logic;
    clr: in std_logic;
    clk: in std_logic;
    op: out std_logic_vector(op_width - 1 downto 0);
    up: in std_logic_vector(0 downto 0) := (others => '0');
    load: in std_logic_vector(0 downto 0) := (others => '0');
    din: in std_logic_vector(op_width - 1 downto 0) := (others => '0');
    en: in std_logic_vector(0 downto 0);
    rst: in std_logic_vector(0 downto 0)
  );
end xlcounter_free ;
architecture behavior of xlcounter_free is
  component cntr_11_0_9e1d282a7a5f1b1e
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      up: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_9e1d282a7a5f1b1e:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_9e1d282a7a5f1b1e:
    component is "true";
  attribute box_type of cntr_11_0_9e1d282a7a5f1b1e:
    component  is "black_box";
  component cntr_11_0_688cfddaf968f88b
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      load: in std_logic;
      l: in std_logic_vector(op_width - 1 downto 0);
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_688cfddaf968f88b:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_688cfddaf968f88b:
    component is "true";
  attribute box_type of cntr_11_0_688cfddaf968f88b:
    component  is "black_box";
  component cntr_11_0_8dfcc050e9d5f132
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_8dfcc050e9d5f132:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_8dfcc050e9d5f132:
    component is "true";
  attribute box_type of cntr_11_0_8dfcc050e9d5f132:
    component  is "black_box";
  component cntr_11_0_f09d056deed69f8d
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_f09d056deed69f8d:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_f09d056deed69f8d:
    component is "true";
  attribute box_type of cntr_11_0_f09d056deed69f8d:
    component  is "black_box";
  component cntr_11_0_fb550ac1b34e525f
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      load: in std_logic;
      l: in std_logic_vector(op_width - 1 downto 0);
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_fb550ac1b34e525f:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_fb550ac1b34e525f:
    component is "true";
  attribute box_type of cntr_11_0_fb550ac1b34e525f:
    component  is "black_box";
  component cntr_11_0_1eabeaef14bdfc76
    port (
      clk: in std_logic;
      ce: in std_logic;
      SINIT: in std_logic;
      q: out std_logic_vector(op_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of cntr_11_0_1eabeaef14bdfc76:
    component is true;
  attribute fpga_dont_touch of cntr_11_0_1eabeaef14bdfc76:
    component is "true";
  attribute box_type of cntr_11_0_1eabeaef14bdfc76:
    component  is "black_box";
-- synopsys translate_off
  constant zeroVec: std_logic_vector(op_width - 1 downto 0) := (others => '0');
  constant oneVec: std_logic_vector(op_width - 1 downto 0) := (others => '1');
  constant zeroStr: string(1 to op_width) :=
    std_logic_vector_to_bin_string(zeroVec);
  constant oneStr: string(1 to op_width) :=
    std_logic_vector_to_bin_string(oneVec);
-- synopsys translate_on
  signal core_sinit: std_logic;
  signal core_ce: std_logic;
  signal op_net: std_logic_vector(op_width - 1 downto 0);
begin
  core_ce <= ce and en(0);
  core_sinit <= (clr or rst(0)) and ce;
  op <= op_net;
  comp0: if ((core_name0 = "cntr_11_0_9e1d282a7a5f1b1e")) generate
    core_instance0: cntr_11_0_9e1d282a7a5f1b1e
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        up => up(0),
        q => op_net
      );
  end generate;
  comp1: if ((core_name0 = "cntr_11_0_688cfddaf968f88b")) generate
    core_instance1: cntr_11_0_688cfddaf968f88b
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        load => load(0),
        l => din,
        q => op_net
      );
  end generate;
  comp2: if ((core_name0 = "cntr_11_0_8dfcc050e9d5f132")) generate
    core_instance2: cntr_11_0_8dfcc050e9d5f132
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
      );
  end generate;
  comp3: if ((core_name0 = "cntr_11_0_f09d056deed69f8d")) generate
    core_instance3: cntr_11_0_f09d056deed69f8d
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
      );
  end generate;
  comp4: if ((core_name0 = "cntr_11_0_fb550ac1b34e525f")) generate
    core_instance4: cntr_11_0_fb550ac1b34e525f
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        load => load(0),
        l => din,
        q => op_net
      );
  end generate;
  comp5: if ((core_name0 = "cntr_11_0_1eabeaef14bdfc76")) generate
    core_instance5: cntr_11_0_1eabeaef14bdfc76
      port map (
        clk => clk,
        ce => core_ce,
        SINIT => core_sinit,
        q => op_net
      );
  end generate;
end behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity relational_ca8f2ee4fc is
  port (
    a : in std_logic_vector((16 - 1) downto 0);
    b : in std_logic_vector((12 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end relational_ca8f2ee4fc;


architecture behavior of relational_ca8f2ee4fc is
  signal a_1_31: unsigned((16 - 1) downto 0);
  signal b_1_34: unsigned((12 - 1) downto 0);
  signal cast_14_17: unsigned((16 - 1) downto 0);
  signal result_14_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_unsigned(b);
  cast_14_17 <= u2u_cast(b_1_34, 0, 16, 0);
  result_14_3_rel <= a_1_31 /= cast_14_17;
  op <= boolean_to_vector(result_14_3_rel);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_aacf6e1b0e is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_aacf6e1b0e;


architecture behavior of logical_aacf6e1b0e is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  fully_2_1_bit <= d0_1_24 or d1_1_27;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity inverter_e5b38cca3b is
  port (
    ip : in std_logic_vector((1 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end inverter_e5b38cca3b;


architecture behavior of inverter_e5b38cca3b is
  signal ip_1_26: boolean;
  type array_type_op_mem_22_20 is array (0 to (1 - 1)) of boolean;
  signal op_mem_22_20: array_type_op_mem_22_20 := (
    0 => false);
  signal op_mem_22_20_front_din: boolean;
  signal op_mem_22_20_back: boolean;
  signal op_mem_22_20_push_front_pop_back_en: std_logic;
  signal internal_ip_12_1_bitnot: boolean;
begin
  ip_1_26 <= ((ip) = "1");
  op_mem_22_20_back <= op_mem_22_20(0);
  proc_op_mem_22_20: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (op_mem_22_20_push_front_pop_back_en = '1')) then
        op_mem_22_20(0) <= op_mem_22_20_front_din;
      end if;
    end if;
  end process proc_op_mem_22_20;
  internal_ip_12_1_bitnot <= ((not boolean_to_vector(ip_1_26)) = "1");
  op_mem_22_20_push_front_pop_back_en <= '0';
  op <= boolean_to_vector(internal_ip_12_1_bitnot);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_954ee29728 is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    d2 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_954ee29728;


architecture behavior of logical_954ee29728 is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal d2_1_30: std_logic;
  signal fully_2_1_bit: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  d2_1_30 <= d2(0);
  fully_2_1_bit <= d0_1_24 and d1_1_27 and d2_1_30;
  y <= std_logic_to_vector(fully_2_1_bit);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_dfe2dded7f is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_dfe2dded7f;


architecture behavior of logical_dfe2dded7f is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal bit_2_26: std_logic;
  signal fully_2_1_bitnot: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  bit_2_26 <= d0_1_24 or d1_1_27;
  fully_2_1_bitnot <= not bit_2_26;
  y <= std_logic_to_vector(fully_2_1_bitnot);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity relational_d500ab1630 is
  port (
    a : in std_logic_vector((14 - 1) downto 0);
    b : in std_logic_vector((14 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end relational_d500ab1630;


architecture behavior of relational_d500ab1630 is
  signal a_1_31: unsigned((14 - 1) downto 0);
  signal b_1_34: unsigned((14 - 1) downto 0);
  signal result_12_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_unsigned(b);
  result_12_3_rel <= a_1_31 = b_1_34;
  op <= boolean_to_vector(result_12_3_rel);
end behavior;

--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\COCOUNT.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Wed Apr 16 10:05:01 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are area optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY COCOUNT IS
	PORT (coct_clk,BOS,coct_ce,empty,PSNZ,RESET,TC: IN std_logic;
		LastScan,LastSkip,PreSkip : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF COCOUNT IS
	TYPE type_sreg IS (Co_add,Last_Scan,Last_Skip,Pre_Skip);
	SIGNAL sreg, next_sreg : type_sreg;
BEGIN
	PROCESS (coct_clk, next_sreg)
	BEGIN
		IF coct_clk='1' AND coct_clk'event THEN
			sreg <= next_sreg;
		END IF;
	END PROCESS;

	PROCESS (sreg,BOS,empty,PSNZ,RESET,TC)
	BEGIN
		LastScan <= '0'; LastSkip <= '0'; PreSkip <= '0'; 

		next_sreg<=Co_add;

		IF ( RESET='1' ) THEN
			next_sreg<=Pre_Skip;
			LastScan<='0';
			PreSkip<='1';
			LastSkip<='0';
		ELSE
			CASE sreg IS
				WHEN Co_add =>
					LastScan<='0';
					PreSkip<='0';
					LastSkip<='0';
					IF ( BOS='1' AND TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
					IF ( BOS='0' ) OR ( TC='0' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='1' AND TC='1' AND empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
				WHEN Last_Scan =>
					LastScan<='1';
					PreSkip<='0';
					LastSkip<='0';
					IF ( BOS='0' ) OR ( TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
					IF ( TC='0' AND PSNZ='0' AND BOS='1' ) OR ( TC='0' AND empty='1' AND 
						BOS='1' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='1' AND PSNZ='1' AND empty='0' ) THEN
						next_sreg<=Pre_Skip;
					END IF;
					IF ( BOS='1' AND PSNZ='0' AND empty='0' AND TC='1' ) THEN
						next_sreg<=Last_Skip;
					END IF;
				WHEN Last_Skip =>
					LastScan<='0';
					PreSkip<='0';
					LastSkip<='1';
					IF ( BOS='0' ) OR ( empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
					IF ( BOS='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
				WHEN Pre_Skip =>
					LastScan<='0';
					PreSkip<='1';
					LastSkip<='0';
					IF ( BOS='1' AND PSNZ='0' AND TC='1' AND empty='0' ) THEN
						next_sreg<=Last_Skip;
					END IF;
					IF ( TC='0' AND PSNZ='0' AND BOS='1' ) OR ( TC='0' AND empty='1' AND 
						BOS='1' ) THEN
						next_sreg<=Co_add;
					END IF;
					IF ( BOS='0' ) OR ( PSNZ='1' AND empty='0' ) THEN
						next_sreg<=Pre_Skip;
					END IF;
					IF ( BOS='1' AND TC='1' AND empty='1' ) THEN
						next_sreg<=Last_Scan;
					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;
END BEHAVIOR;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_09a949dfe2 is
  port (
    d0 : in std_logic_vector((9 - 1) downto 0);
    d1 : in std_logic_vector((9 - 1) downto 0);
    y : out std_logic_vector((9 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_09a949dfe2;


architecture behavior of logical_09a949dfe2 is
  signal d0_1_24: std_logic_vector((9 - 1) downto 0);
  signal d1_1_27: std_logic_vector((9 - 1) downto 0);
  signal fully_2_1_bit: std_logic_vector((9 - 1) downto 0);
begin
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  fully_2_1_bit <= d0_1_24 or d1_1_27;
  y <= fully_2_1_bit;
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_bde51e424d is
  port (
    d0 : in std_logic_vector((1 - 1) downto 0);
    d1 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_bde51e424d;


architecture behavior of logical_bde51e424d is
  signal d0_1_24: std_logic;
  signal d1_1_27: std_logic;
  signal bit_2_27: std_logic;
  signal fully_2_1_bitnot: std_logic;
begin
  d0_1_24 <= d0(0);
  d1_1_27 <= d1(0);
  bit_2_27 <= d0_1_24 and d1_1_27;
  fully_2_1_bitnot <= not bit_2_27;
  y <= std_logic_to_vector(fully_2_1_bitnot);
end behavior;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity xlregister is
   generic (d_width          : integer := 5;
            init_value       : bit_vector := b"00");
   port (d   : in std_logic_vector (d_width-1 downto 0);
         rst : in std_logic_vector(0 downto 0) := "0";
         en  : in std_logic_vector(0 downto 0) := "1";
         ce  : in std_logic;
         clk : in std_logic;
         q   : out std_logic_vector (d_width-1 downto 0));
end xlregister;
architecture behavior of xlregister is
   component synth_reg_w_init
      generic (width      : integer;
               init_index : integer;
               init_value : bit_vector;
               latency    : integer);
      port (i   : in std_logic_vector(width-1 downto 0);
            ce  : in std_logic;
            clr : in std_logic;
            clk : in std_logic;
            o   : out std_logic_vector(width-1 downto 0));
   end component;
   -- synopsys translate_off
   signal real_d, real_q           : real;
   -- synopsys translate_on
   signal internal_clr             : std_logic;
   signal internal_ce              : std_logic;
begin
   internal_clr <= rst(0) and ce;
   internal_ce  <= en(0) and ce;
   synth_reg_inst : synth_reg_w_init
      generic map (width      => d_width,
                   init_index => 2,
                   init_value => init_value,
                   latency    => 1)
      port map (i   => d,
                ce  => internal_ce,
                clr => internal_clr,
                clk => clk,
                o   => q);
end architecture behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_09e13b86e0 is
  port (
    in0 : in std_logic_vector((1 - 1) downto 0);
    in1 : in std_logic_vector((1 - 1) downto 0);
    in2 : in std_logic_vector((1 - 1) downto 0);
    y : out std_logic_vector((3 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_09e13b86e0;


architecture behavior of concat_09e13b86e0 is
  signal in0_1_23: boolean;
  signal in1_1_27: boolean;
  signal in2_1_31: boolean;
  signal y_2_1_concat: unsigned((3 - 1) downto 0);
begin
  in0_1_23 <= ((in0) = "1");
  in1_1_27 <= ((in1) = "1");
  in2_1_31 <= ((in2) = "1");
  y_2_1_concat <= std_logic_vector_to_unsigned(boolean_to_vector(in0_1_23) & boolean_to_vector(in1_1_27) & boolean_to_vector(in2_1_31));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;
entity xldelay is
   generic(width        : integer := -1;
           latency      : integer := -1;
           reg_retiming : integer := 0);
   port(d       : in std_logic_vector (width-1 downto 0);
        ce      : in std_logic;
        clk     : in std_logic;
        en      : in std_logic;
        q       : out std_logic_vector (width-1 downto 0));
end xldelay;
architecture behavior of xldelay is
   component synth_reg
      generic (width       : integer;
               latency     : integer);
      port (i       : in std_logic_vector(width-1 downto 0);
            ce      : in std_logic;
            clr     : in std_logic;
            clk     : in std_logic;
            o       : out std_logic_vector(width-1 downto 0));
   end component;
   component synth_reg_reg
      generic (width       : integer;
               latency     : integer);
      port (i       : in std_logic_vector(width-1 downto 0);
            ce      : in std_logic;
            clr     : in std_logic;
            clk     : in std_logic;
            o       : out std_logic_vector(width-1 downto 0));
   end component;
   signal internal_ce  : std_logic;
begin
   internal_ce  <= ce and en;
   srl_delay: if (reg_retiming = 0) or (latency < 1) generate
     synth_reg_srl_inst : synth_reg
       generic map (
         width   => width,
         latency => latency)
       port map (
         i   => d,
         ce  => internal_ce,
         clr => '0',
         clk => clk,
         o   => q);
   end generate srl_delay;
   reg_delay: if (reg_retiming = 1) and (latency >= 1) generate
     synth_reg_reg_inst : synth_reg_reg
       generic map (
         width   => width,
         latency => latency)
       port map (
         i   => d,
         ce  => internal_ce,
         clr => '0',
         clk => clk,
         o   => q);
   end generate reg_delay;
end architecture behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_822933f89b is
  port (
    op : out std_logic_vector((3 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_822933f89b;


architecture behavior of constant_822933f89b is
begin
  op <= "000";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity relational_8fc7f5539b is
  port (
    a : in std_logic_vector((3 - 1) downto 0);
    b : in std_logic_vector((3 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end relational_8fc7f5539b;


architecture behavior of relational_8fc7f5539b is
  signal a_1_31: unsigned((3 - 1) downto 0);
  signal b_1_34: unsigned((3 - 1) downto 0);
  signal result_12_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_unsigned(b);
  result_12_3_rel <= a_1_31 = b_1_34;
  op <= boolean_to_vector(result_12_3_rel);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_963ed6358a is
  port (
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_963ed6358a;


architecture behavior of constant_963ed6358a is
begin
  op <= "0";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity mcode_block_f4d0462e0e is
  port (
    plbrst : in std_logic_vector((1 - 1) downto 0);
    plbabus : in std_logic_vector((32 - 1) downto 0);
    plbpavalid : in std_logic_vector((1 - 1) downto 0);
    plbrnw : in std_logic_vector((1 - 1) downto 0);
    plbwrdbus : in std_logic_vector((32 - 1) downto 0);
    rddata : in std_logic_vector((32 - 1) downto 0);
    addrpref : in std_logic_vector((20 - 1) downto 0);
    wrdbusreg : out std_logic_vector((32 - 1) downto 0);
    addrack : out std_logic_vector((1 - 1) downto 0);
    rdcomp : out std_logic_vector((1 - 1) downto 0);
    wrdack : out std_logic_vector((1 - 1) downto 0);
    bankaddr : out std_logic_vector((2 - 1) downto 0);
    rnwreg : out std_logic_vector((1 - 1) downto 0);
    rddack : out std_logic_vector((1 - 1) downto 0);
    rddbus : out std_logic_vector((32 - 1) downto 0);
    linearaddr : out std_logic_vector((8 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end mcode_block_f4d0462e0e;


architecture behavior of mcode_block_f4d0462e0e is
  signal plbrst_1_110: unsigned((1 - 1) downto 0);
  signal plbabus_1_118: unsigned((32 - 1) downto 0);
  signal plbpavalid_1_127: unsigned((1 - 1) downto 0);
  signal plbrnw_1_139: unsigned((1 - 1) downto 0);
  signal plbwrdbus_1_147: unsigned((32 - 1) downto 0);
  signal rddata_1_158: unsigned((32 - 1) downto 0);
  signal addrpref_1_166: unsigned((20 - 1) downto 0);
  signal plbrstreg_12_24_next: boolean;
  signal plbrstreg_12_24: boolean := false;
  signal plbabusreg_13_25_next: unsigned((32 - 1) downto 0);
  signal plbabusreg_13_25: unsigned((32 - 1) downto 0) := "00000000000000000000000000000000";
  signal plbpavalidreg_14_28_next: boolean;
  signal plbpavalidreg_14_28: boolean := false;
  signal plbrnwreg_15_24_next: unsigned((1 - 1) downto 0);
  signal plbrnwreg_15_24: unsigned((1 - 1) downto 0) := "0";
  signal plbwrdbusreg_16_27_next: unsigned((32 - 1) downto 0);
  signal plbwrdbusreg_16_27: unsigned((32 - 1) downto 0) := "00000000000000000000000000000000";
  signal avalidreg_28_23_next: boolean;
  signal avalidreg_28_23: boolean := false;
  signal ps1reg_39_20_next: boolean;
  signal ps1reg_39_20: boolean := false;
  signal psreg_47_19_next: boolean;
  signal psreg_47_19: boolean := false;
  type array_type_rdcompdelay_58_25 is array (0 to (3 - 1)) of unsigned((1 - 1) downto 0);
  signal rdcompdelay_58_25: array_type_rdcompdelay_58_25 := (
    "0",
    "0",
    "0");
  signal rdcompdelay_58_25_front_din: unsigned((1 - 1) downto 0);
  signal rdcompdelay_58_25_back: unsigned((1 - 1) downto 0);
  signal rdcompdelay_58_25_push_front_pop_back_en: std_logic;
  signal rdcompreg_62_23_next: unsigned((1 - 1) downto 0);
  signal rdcompreg_62_23: unsigned((1 - 1) downto 0) := "0";
  signal rddackreg_66_23_next: unsigned((1 - 1) downto 0);
  signal rddackreg_66_23: unsigned((1 - 1) downto 0) := "0";
  signal wrdackreg_70_23_next: unsigned((1 - 1) downto 0);
  signal wrdackreg_70_23: unsigned((1 - 1) downto 0) := "0";
  signal rddbusreg_84_23_next: unsigned((32 - 1) downto 0);
  signal rddbusreg_84_23: unsigned((32 - 1) downto 0) := "00000000000000000000000000000000";
  signal bankaddr_20_1_slice: unsigned((2 - 1) downto 0);
  signal linearaddr_21_1_slice: unsigned((8 - 1) downto 0);
  signal addrpref_in_32_1_slice: unsigned((20 - 1) downto 0);
  signal rel_33_4: boolean;
  signal ps1_join_33_1: boolean;
  signal ps_42_1_bit: boolean;
  signal bitnot_49_49: boolean;
  signal bitnot_49_73: boolean;
  signal bit_49_49: boolean;
  signal addrack_49_1_convert: unsigned((1 - 1) downto 0);
  signal bit_55_43: unsigned((1 - 1) downto 0);
  signal bitnot_72_35: unsigned((1 - 1) downto 0);
  signal wrdackreg_72_1_bit: unsigned((1 - 1) downto 0);
  signal rdsel_76_1_bit: unsigned((1 - 1) downto 0);
  signal rel_78_4: boolean;
  signal rddbus1_join_78_1: unsigned((32 - 1) downto 0);
  signal plbwrdbusreg_97_1_slice: unsigned((32 - 1) downto 0);
  signal plbrstreg_12_24_next_x_000000: boolean;
  signal plbpavalidreg_14_28_next_x_000000: boolean;
begin
  plbrst_1_110 <= std_logic_vector_to_unsigned(plbrst);
  plbabus_1_118 <= std_logic_vector_to_unsigned(plbabus);
  plbpavalid_1_127 <= std_logic_vector_to_unsigned(plbpavalid);
  plbrnw_1_139 <= std_logic_vector_to_unsigned(plbrnw);
  plbwrdbus_1_147 <= std_logic_vector_to_unsigned(plbwrdbus);
  rddata_1_158 <= std_logic_vector_to_unsigned(rddata);
  addrpref_1_166 <= std_logic_vector_to_unsigned(addrpref);
  proc_plbrstreg_12_24: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        plbrstreg_12_24 <= plbrstreg_12_24_next;
      end if;
    end if;
  end process proc_plbrstreg_12_24;
  proc_plbabusreg_13_25: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        plbabusreg_13_25 <= plbabusreg_13_25_next;
      end if;
    end if;
  end process proc_plbabusreg_13_25;
  proc_plbpavalidreg_14_28: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        plbpavalidreg_14_28 <= plbpavalidreg_14_28_next;
      end if;
    end if;
  end process proc_plbpavalidreg_14_28;
  proc_plbrnwreg_15_24: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        plbrnwreg_15_24 <= plbrnwreg_15_24_next;
      end if;
    end if;
  end process proc_plbrnwreg_15_24;
  proc_plbwrdbusreg_16_27: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        plbwrdbusreg_16_27 <= plbwrdbusreg_16_27_next;
      end if;
    end if;
  end process proc_plbwrdbusreg_16_27;
  proc_avalidreg_28_23: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        avalidreg_28_23 <= avalidreg_28_23_next;
      end if;
    end if;
  end process proc_avalidreg_28_23;
  proc_ps1reg_39_20: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        ps1reg_39_20 <= ps1reg_39_20_next;
      end if;
    end if;
  end process proc_ps1reg_39_20;
  proc_psreg_47_19: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        psreg_47_19 <= psreg_47_19_next;
      end if;
    end if;
  end process proc_psreg_47_19;
  rdcompdelay_58_25_back <= rdcompdelay_58_25(2);
  proc_rdcompdelay_58_25: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (rdcompdelay_58_25_push_front_pop_back_en = '1')) then
        for i in 2 downto 1 loop 
          rdcompdelay_58_25(i) <= rdcompdelay_58_25(i-1);
        end loop;
        rdcompdelay_58_25(0) <= rdcompdelay_58_25_front_din;
      end if;
    end if;
  end process proc_rdcompdelay_58_25;
  proc_rdcompreg_62_23: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        rdcompreg_62_23 <= rdcompreg_62_23_next;
      end if;
    end if;
  end process proc_rdcompreg_62_23;
  proc_rddackreg_66_23: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        rddackreg_66_23 <= rddackreg_66_23_next;
      end if;
    end if;
  end process proc_rddackreg_66_23;
  proc_wrdackreg_70_23: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        wrdackreg_70_23 <= wrdackreg_70_23_next;
      end if;
    end if;
  end process proc_wrdackreg_70_23;
  proc_rddbusreg_84_23: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        rddbusreg_84_23 <= rddbusreg_84_23_next;
      end if;
    end if;
  end process proc_rddbusreg_84_23;
  bankaddr_20_1_slice <= u2u_slice(plbabusreg_13_25, 11, 10);
  linearaddr_21_1_slice <= u2u_slice(plbabusreg_13_25, 9, 2);
  addrpref_in_32_1_slice <= u2u_slice(plbabusreg_13_25, 31, 12);
  rel_33_4 <= addrpref_in_32_1_slice = addrpref_1_166;
  proc_if_33_1: process (rel_33_4)
  is
  begin
    if rel_33_4 then
      ps1_join_33_1 <= true;
    else 
      ps1_join_33_1 <= false;
    end if;
  end process proc_if_33_1;
  ps_42_1_bit <= ((boolean_to_vector(ps1_join_33_1) and boolean_to_vector(plbpavalidreg_14_28)) = "1");
  bitnot_49_49 <= ((not boolean_to_vector(plbrstreg_12_24)) = "1");
  bitnot_49_73 <= ((not boolean_to_vector(psreg_47_19)) = "1");
  bit_49_49 <= ((boolean_to_vector(bitnot_49_49) and boolean_to_vector(ps_42_1_bit) and boolean_to_vector(bitnot_49_73)) = "1");
  addrack_49_1_convert <= u2u_cast(std_logic_vector_to_unsigned(boolean_to_vector(bit_49_49)), 0, 1, 0);
  bit_55_43 <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(addrack_49_1_convert) and unsigned_to_std_logic_vector(plbrnwreg_15_24));
  bitnot_72_35 <= std_logic_vector_to_unsigned(not unsigned_to_std_logic_vector(plbrnwreg_15_24));
  wrdackreg_72_1_bit <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(addrack_49_1_convert) and unsigned_to_std_logic_vector(bitnot_72_35));
  rdsel_76_1_bit <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(rdcompdelay_58_25_back) or unsigned_to_std_logic_vector(rdcompreg_62_23));
  rel_78_4 <= rdsel_76_1_bit = std_logic_vector_to_unsigned("1");
  proc_if_78_1: process (rddata_1_158, rel_78_4)
  is
  begin
    if rel_78_4 then
      rddbus1_join_78_1 <= rddata_1_158;
    else 
      rddbus1_join_78_1 <= std_logic_vector_to_unsigned("00000000000000000000000000000000");
    end if;
  end process proc_if_78_1;
  plbwrdbusreg_97_1_slice <= u2u_slice(plbwrdbus_1_147, 31, 0);
  plbrstreg_12_24_next_x_000000 <= (plbrst_1_110 /= "0");
  plbrstreg_12_24_next <= plbrstreg_12_24_next_x_000000;
  plbabusreg_13_25_next <= plbabus_1_118;
  plbpavalidreg_14_28_next_x_000000 <= (plbpavalid_1_127 /= "0");
  plbpavalidreg_14_28_next <= plbpavalidreg_14_28_next_x_000000;
  plbrnwreg_15_24_next <= plbrnw_1_139;
  plbwrdbusreg_16_27_next <= plbwrdbusreg_97_1_slice;
  avalidreg_28_23_next <= plbpavalidreg_14_28;
  ps1reg_39_20_next <= ps1_join_33_1;
  psreg_47_19_next <= ps_42_1_bit;
  rdcompdelay_58_25_front_din <= bit_55_43;
  rdcompdelay_58_25_push_front_pop_back_en <= '1';
  rdcompreg_62_23_next <= rdcompdelay_58_25_back;
  rddackreg_66_23_next <= rdcompreg_62_23;
  wrdackreg_70_23_next <= wrdackreg_72_1_bit;
  rddbusreg_84_23_next <= rddbus1_join_78_1;
  wrdbusreg <= unsigned_to_std_logic_vector(plbwrdbusreg_16_27);
  addrack <= unsigned_to_std_logic_vector(addrack_49_1_convert);
  rdcomp <= unsigned_to_std_logic_vector(rdcompreg_62_23);
  wrdack <= unsigned_to_std_logic_vector(wrdackreg_70_23);
  bankaddr <= unsigned_to_std_logic_vector(bankaddr_20_1_slice);
  rnwreg <= unsigned_to_std_logic_vector(plbrnwreg_15_24);
  rddack <= unsigned_to_std_logic_vector(rddackreg_66_23);
  rddbus <= unsigned_to_std_logic_vector(rddbusreg_84_23);
  linearaddr <= unsigned_to_std_logic_vector(linearaddr_21_1_slice);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity mcode_block_3a303afee5 is
  port (
    wrdbus : in std_logic_vector((32 - 1) downto 0);
    bankaddr : in std_logic_vector((2 - 1) downto 0);
    linearaddr : in std_logic_vector((8 - 1) downto 0);
    rnwreg : in std_logic_vector((1 - 1) downto 0);
    addrack : in std_logic_vector((1 - 1) downto 0);
    sm_srcsignal : in std_logic_vector((32 - 1) downto 0);
    sm_srcsignal_pfull : in std_logic_vector((1 - 1) downto 0);
    sm_srcsignal_empty : in std_logic_vector((1 - 1) downto 0);
    read_bank_out : out std_logic_vector((32 - 1) downto 0);
    sm_control_din : out std_logic_vector((8 - 1) downto 0);
    sm_control_en : out std_logic_vector((1 - 1) downto 0);
    sm_navg_din : out std_logic_vector((8 - 1) downto 0);
    sm_navg_en : out std_logic_vector((1 - 1) downto 0);
    sm_netsamples_din : out std_logic_vector((12 - 1) downto 0);
    sm_netsamples_en : out std_logic_vector((1 - 1) downto 0);
    sm_triggerlevel_din : out std_logic_vector((16 - 1) downto 0);
    sm_triggerlevel_en : out std_logic_vector((1 - 1) downto 0);
    sm_ncoadd_din : out std_logic_vector((14 - 1) downto 0);
    sm_ncoadd_en : out std_logic_vector((1 - 1) downto 0);
    sm_srcsignal_re : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end mcode_block_3a303afee5;


architecture behavior of mcode_block_3a303afee5 is
  signal wrdbus_1_219: unsigned((32 - 1) downto 0);
  signal bankaddr_1_227: unsigned((2 - 1) downto 0);
  signal linearaddr_1_237: unsigned((8 - 1) downto 0);
  signal rnwreg_1_249: unsigned((1 - 1) downto 0);
  signal addrack_1_257: unsigned((1 - 1) downto 0);
  signal sm_srcsignal_1_266: unsigned((32 - 1) downto 0);
  signal sm_srcsignal_pfull_1_280: unsigned((1 - 1) downto 0);
  signal sm_srcsignal_empty_1_300: boolean;
  signal fifo_bank_out_reg_25_31_next: unsigned((32 - 1) downto 0);
  signal fifo_bank_out_reg_25_31: unsigned((32 - 1) downto 0) := "00000000000000000000000000000000";
  signal read_bank_out_reg_119_31_next: unsigned((32 - 1) downto 0);
  signal read_bank_out_reg_119_31: unsigned((32 - 1) downto 0) := "00000000000000000000000000000000";
  signal bankaddr_reg_122_26_next: unsigned((2 - 1) downto 0);
  signal bankaddr_reg_122_26: unsigned((2 - 1) downto 0) := "00";
  signal sm_srcsignal_empty_bus_14_1_convert: unsigned((32 - 1) downto 0);
  signal rel_28_4: boolean;
  signal rel_30_8: boolean;
  signal rel_32_8: boolean;
  signal fifo_bank_out_reg_join_28_1: unsigned((32 - 1) downto 0);
  signal opcode_36_1_concat: unsigned((12 - 1) downto 0);
  signal rel_54_4: boolean;
  signal sm_srcsignal_re_join_54_1: boolean;
  signal rel_63_4: boolean;
  signal sm_control_en_join_63_1: boolean;
  signal rel_69_4: boolean;
  signal sm_navg_en_join_69_1: boolean;
  signal rel_75_4: boolean;
  signal sm_netsamples_en_join_75_1: boolean;
  signal rel_81_4: boolean;
  signal sm_triggerlevel_en_join_81_1: boolean;
  signal rel_87_4: boolean;
  signal sm_ncoadd_en_join_87_1: boolean;
  signal slice_102_35: unsigned((8 - 1) downto 0);
  signal slice_105_32: unsigned((8 - 1) downto 0);
  signal slice_108_38: unsigned((12 - 1) downto 0);
  signal slice_111_40: unsigned((16 - 1) downto 0);
  signal sm_triggerlevel_din_111_1_force: signed((16 - 1) downto 0);
  signal slice_114_34: unsigned((14 - 1) downto 0);
  signal rel_124_4: boolean;
  signal rel_127_8: boolean;
  signal rel_130_8: boolean;
  signal rel_133_8: boolean;
  signal read_bank_out_reg_join_124_1: unsigned((32 - 1) downto 0);
begin
  wrdbus_1_219 <= std_logic_vector_to_unsigned(wrdbus);
  bankaddr_1_227 <= std_logic_vector_to_unsigned(bankaddr);
  linearaddr_1_237 <= std_logic_vector_to_unsigned(linearaddr);
  rnwreg_1_249 <= std_logic_vector_to_unsigned(rnwreg);
  addrack_1_257 <= std_logic_vector_to_unsigned(addrack);
  sm_srcsignal_1_266 <= std_logic_vector_to_unsigned(sm_srcsignal);
  sm_srcsignal_pfull_1_280 <= std_logic_vector_to_unsigned(sm_srcsignal_pfull);
  sm_srcsignal_empty_1_300 <= ((sm_srcsignal_empty) = "1");
  proc_fifo_bank_out_reg_25_31: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        fifo_bank_out_reg_25_31 <= fifo_bank_out_reg_25_31_next;
      end if;
    end if;
  end process proc_fifo_bank_out_reg_25_31;
  proc_read_bank_out_reg_119_31: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        read_bank_out_reg_119_31 <= read_bank_out_reg_119_31_next;
      end if;
    end if;
  end process proc_read_bank_out_reg_119_31;
  proc_bankaddr_reg_122_26: process (clk)
  is
  begin
    if (clk'event and (clk = '1')) then
      if (ce = '1') then
        bankaddr_reg_122_26 <= bankaddr_reg_122_26_next;
      end if;
    end if;
  end process proc_bankaddr_reg_122_26;
  sm_srcsignal_empty_bus_14_1_convert <= u2u_cast(std_logic_vector_to_unsigned(boolean_to_vector(sm_srcsignal_empty_1_300)), 0, 32, 0);
  rel_28_4 <= linearaddr_1_237 = std_logic_vector_to_unsigned("00000000");
  rel_30_8 <= linearaddr_1_237 = std_logic_vector_to_unsigned("00000001");
  rel_32_8 <= linearaddr_1_237 = std_logic_vector_to_unsigned("00000010");
  proc_if_28_1: process (fifo_bank_out_reg_25_31, rel_28_4, rel_30_8, rel_32_8, sm_srcsignal_1_266, sm_srcsignal_empty_bus_14_1_convert, sm_srcsignal_pfull_1_280)
  is
  begin
    if rel_28_4 then
      fifo_bank_out_reg_join_28_1 <= sm_srcsignal_1_266;
    elsif rel_30_8 then
      fifo_bank_out_reg_join_28_1 <= u2u_cast(sm_srcsignal_pfull_1_280, 0, 32, 0);
    elsif rel_32_8 then
      fifo_bank_out_reg_join_28_1 <= sm_srcsignal_empty_bus_14_1_convert;
    else 
      fifo_bank_out_reg_join_28_1 <= fifo_bank_out_reg_25_31;
    end if;
  end process proc_if_28_1;
  opcode_36_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(addrack_1_257) & unsigned_to_std_logic_vector(rnwreg_1_249) & unsigned_to_std_logic_vector(bankaddr_1_227) & unsigned_to_std_logic_vector(linearaddr_1_237));
  rel_54_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("110100000000");
  proc_if_54_1: process (rel_54_4)
  is
  begin
    if rel_54_4 then
      sm_srcsignal_re_join_54_1 <= true;
    else 
      sm_srcsignal_re_join_54_1 <= false;
    end if;
  end process proc_if_54_1;
  rel_63_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("101000000000");
  proc_if_63_1: process (rel_63_4)
  is
  begin
    if rel_63_4 then
      sm_control_en_join_63_1 <= true;
    else 
      sm_control_en_join_63_1 <= false;
    end if;
  end process proc_if_63_1;
  rel_69_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("101000000001");
  proc_if_69_1: process (rel_69_4)
  is
  begin
    if rel_69_4 then
      sm_navg_en_join_69_1 <= true;
    else 
      sm_navg_en_join_69_1 <= false;
    end if;
  end process proc_if_69_1;
  rel_75_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("101000000010");
  proc_if_75_1: process (rel_75_4)
  is
  begin
    if rel_75_4 then
      sm_netsamples_en_join_75_1 <= true;
    else 
      sm_netsamples_en_join_75_1 <= false;
    end if;
  end process proc_if_75_1;
  rel_81_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("101000000011");
  proc_if_81_1: process (rel_81_4)
  is
  begin
    if rel_81_4 then
      sm_triggerlevel_en_join_81_1 <= true;
    else 
      sm_triggerlevel_en_join_81_1 <= false;
    end if;
  end process proc_if_81_1;
  rel_87_4 <= opcode_36_1_concat = std_logic_vector_to_unsigned("101000000100");
  proc_if_87_1: process (rel_87_4)
  is
  begin
    if rel_87_4 then
      sm_ncoadd_en_join_87_1 <= true;
    else 
      sm_ncoadd_en_join_87_1 <= false;
    end if;
  end process proc_if_87_1;
  slice_102_35 <= u2u_slice(wrdbus_1_219, 7, 0);
  slice_105_32 <= u2u_slice(wrdbus_1_219, 7, 0);
  slice_108_38 <= u2u_slice(wrdbus_1_219, 11, 0);
  slice_111_40 <= u2u_slice(wrdbus_1_219, 15, 0);
  sm_triggerlevel_din_111_1_force <= unsigned_to_signed(slice_111_40);
  slice_114_34 <= u2u_slice(wrdbus_1_219, 13, 0);
  rel_124_4 <= bankaddr_reg_122_26 = std_logic_vector_to_unsigned("00");
  rel_127_8 <= bankaddr_reg_122_26 = std_logic_vector_to_unsigned("01");
  rel_130_8 <= bankaddr_reg_122_26 = std_logic_vector_to_unsigned("10");
  rel_133_8 <= bankaddr_reg_122_26 = std_logic_vector_to_unsigned("11");
  proc_if_124_1: process (fifo_bank_out_reg_25_31, read_bank_out_reg_119_31, rel_124_4, rel_127_8, rel_130_8, rel_133_8)
  is
  begin
    if rel_124_4 then
      read_bank_out_reg_join_124_1 <= std_logic_vector_to_unsigned("00000000000000000000000000000000");
    elsif rel_127_8 then
      read_bank_out_reg_join_124_1 <= fifo_bank_out_reg_25_31;
    elsif rel_130_8 then
      read_bank_out_reg_join_124_1 <= std_logic_vector_to_unsigned("00000000000000000000000000000000");
    elsif rel_133_8 then
      read_bank_out_reg_join_124_1 <= std_logic_vector_to_unsigned("00000000000000000000000000000000");
    else 
      read_bank_out_reg_join_124_1 <= read_bank_out_reg_119_31;
    end if;
  end process proc_if_124_1;
  fifo_bank_out_reg_25_31_next <= fifo_bank_out_reg_join_28_1;
  read_bank_out_reg_119_31_next <= read_bank_out_reg_join_124_1;
  bankaddr_reg_122_26_next <= bankaddr_1_227;
  read_bank_out <= unsigned_to_std_logic_vector(read_bank_out_reg_119_31);
  sm_control_din <= unsigned_to_std_logic_vector(slice_102_35);
  sm_control_en <= boolean_to_vector(sm_control_en_join_63_1);
  sm_navg_din <= unsigned_to_std_logic_vector(slice_105_32);
  sm_navg_en <= boolean_to_vector(sm_navg_en_join_69_1);
  sm_netsamples_din <= unsigned_to_std_logic_vector(slice_108_38);
  sm_netsamples_en <= boolean_to_vector(sm_netsamples_en_join_75_1);
  sm_triggerlevel_din <= signed_to_std_logic_vector(sm_triggerlevel_din_111_1_force);
  sm_triggerlevel_en <= boolean_to_vector(sm_triggerlevel_en_join_81_1);
  sm_ncoadd_din <= unsigned_to_std_logic_vector(slice_114_34);
  sm_ncoadd_en <= boolean_to_vector(sm_ncoadd_en_join_87_1);
  sm_srcsignal_re <= boolean_to_vector(sm_srcsignal_re_join_54_1);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_a3923dd146 is
  port (
    op : out std_logic_vector((11 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_a3923dd146;


architecture behavior of constant_a3923dd146 is
begin
  op <= "00000000000";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity relational_18694f5198 is
  port (
    a : in std_logic_vector((12 - 1) downto 0);
    b : in std_logic_vector((11 - 1) downto 0);
    op : out std_logic_vector((1 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end relational_18694f5198;


architecture behavior of relational_18694f5198 is
  signal a_1_31: unsigned((12 - 1) downto 0);
  signal b_1_34: unsigned((11 - 1) downto 0);
  signal cast_12_17: unsigned((12 - 1) downto 0);
  signal result_12_3_rel: boolean;
begin
  a_1_31 <= std_logic_vector_to_unsigned(a);
  b_1_34 <= std_logic_vector_to_unsigned(b);
  cast_12_17 <= u2u_cast(b_1_34, 0, 12, 0);
  result_12_3_rel <= a_1_31 = cast_12_17;
  op <= boolean_to_vector(result_12_3_rel);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_847b94e62c is
  port (
    in0 : in std_logic_vector((3 - 1) downto 0);
    in1 : in std_logic_vector((3 - 1) downto 0);
    in2 : in std_logic_vector((3 - 1) downto 0);
    y : out std_logic_vector((9 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_847b94e62c;


architecture behavior of concat_847b94e62c is
  signal in0_1_23: unsigned((3 - 1) downto 0);
  signal in1_1_27: unsigned((3 - 1) downto 0);
  signal in2_1_31: unsigned((3 - 1) downto 0);
  signal y_2_1_concat: unsigned((9 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_6f6bdffe9c is
  port (
    in0 : in std_logic_vector((4 - 1) downto 0);
    in1 : in std_logic_vector((3 - 1) downto 0);
    in2 : in std_logic_vector((9 - 1) downto 0);
    y : out std_logic_vector((16 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_6f6bdffe9c;


architecture behavior of concat_6f6bdffe9c is
  signal in0_1_23: unsigned((4 - 1) downto 0);
  signal in1_1_27: unsigned((3 - 1) downto 0);
  signal in2_1_31: unsigned((9 - 1) downto 0);
  signal y_2_1_concat: unsigned((16 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity logical_defe35756e is
  port (
    d0 : in std_logic_vector((3 - 1) downto 0);
    d1 : in std_logic_vector((3 - 1) downto 0);
    y : out std_logic_vector((3 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end logical_defe35756e;


architecture behavior of logical_defe35756e is
  signal d0_1_24: std_logic_vector((3 - 1) downto 0);
  signal d1_1_27: std_logic_vector((3 - 1) downto 0);
  signal fully_2_1_bit: std_logic_vector((3 - 1) downto 0);
begin
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  fully_2_1_bit <= d0_1_24 and d1_1_27;
  y <= fully_2_1_bit;
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity addsub_0fca89c88b is
  port (
    a : in std_logic_vector((1 - 1) downto 0);
    b : in std_logic_vector((1 - 1) downto 0);
    c_in : in std_logic_vector((1 - 1) downto 0);
    s : out std_logic_vector((16 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end addsub_0fca89c88b;


architecture behavior of addsub_0fca89c88b is
  signal a_17_32: unsigned((1 - 1) downto 0);
  signal b_17_35: unsigned((1 - 1) downto 0);
  signal c_in_17_42: unsigned((1 - 1) downto 0);
  type array_type_op_mem_91_20 is array (0 to (1 - 1)) of unsigned((16 - 1) downto 0);
  signal op_mem_91_20: array_type_op_mem_91_20 := (
    0 => "0000000000000000");
  signal op_mem_91_20_front_din: unsigned((16 - 1) downto 0);
  signal op_mem_91_20_back: unsigned((16 - 1) downto 0);
  signal op_mem_91_20_push_front_pop_back_en: std_logic;
  type array_type_cout_mem_92_22 is array (0 to (1 - 1)) of unsigned((1 - 1) downto 0);
  signal cout_mem_92_22: array_type_cout_mem_92_22 := (
    0 => "0");
  signal cout_mem_92_22_front_din: unsigned((1 - 1) downto 0);
  signal cout_mem_92_22_back: unsigned((1 - 1) downto 0);
  signal cout_mem_92_22_push_front_pop_back_en: std_logic;
  signal prev_mode_93_22_next: unsigned((3 - 1) downto 0);
  signal prev_mode_93_22: unsigned((3 - 1) downto 0);
  signal prev_mode_93_22_reg_i: std_logic_vector((3 - 1) downto 0);
  signal prev_mode_93_22_reg_o: std_logic_vector((3 - 1) downto 0);
  signal cast_50_14: unsigned((2 - 1) downto 0);
  signal cast_50_18: unsigned((2 - 1) downto 0);
  signal a_op_b_50_5_addsub: unsigned((2 - 1) downto 0);
  signal cast_51_13: unsigned((3 - 1) downto 0);
  signal cast_51_22: unsigned((3 - 1) downto 0);
  signal sum_x_51_5_addsub: unsigned((3 - 1) downto 0);
  signal internal_cout_52_5_slice: unsigned((1 - 1) downto 0);
  signal cast_internal_s_66_3_convert: unsigned((2 - 1) downto 0);
  signal cast_internal_s_83_3_convert: unsigned((16 - 1) downto 0);
begin
  a_17_32 <= std_logic_vector_to_unsigned(a);
  b_17_35 <= std_logic_vector_to_unsigned(b);
  c_in_17_42 <= std_logic_vector_to_unsigned(c_in);
  op_mem_91_20_back <= op_mem_91_20(0);
  proc_op_mem_91_20: process (clk)
  is
    variable i: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (op_mem_91_20_push_front_pop_back_en = '1')) then
        op_mem_91_20(0) <= op_mem_91_20_front_din;
      end if;
    end if;
  end process proc_op_mem_91_20;
  cout_mem_92_22_back <= cout_mem_92_22(0);
  proc_cout_mem_92_22: process (clk)
  is
    variable i_x_000000: integer;
  begin
    if (clk'event and (clk = '1')) then
      if ((ce = '1') and (cout_mem_92_22_push_front_pop_back_en = '1')) then
        cout_mem_92_22(0) <= cout_mem_92_22_front_din;
      end if;
    end if;
  end process proc_cout_mem_92_22;
  prev_mode_93_22_reg_i <= unsigned_to_std_logic_vector(prev_mode_93_22_next);
  prev_mode_93_22 <= std_logic_vector_to_unsigned(prev_mode_93_22_reg_o);
  prev_mode_93_22_reg_inst: entity work.synth_reg_w_init
    generic map (
      init_index => 2, 
      init_value => b"010", 
      latency => 1, 
      width => 3)
    port map (
      ce => ce, 
      clk => clk, 
      clr => clr, 
      i => prev_mode_93_22_reg_i, 
      o => prev_mode_93_22_reg_o);
  cast_50_14 <= u2u_cast(a_17_32, 0, 2, 0);
  cast_50_18 <= u2u_cast(b_17_35, 0, 2, 0);
  a_op_b_50_5_addsub <= cast_50_14 + cast_50_18;
  cast_51_13 <= u2u_cast(a_op_b_50_5_addsub, 0, 3, 0);
  cast_51_22 <= u2u_cast(c_in_17_42, 0, 3, 0);
  sum_x_51_5_addsub <= cast_51_13 + cast_51_22;
  internal_cout_52_5_slice <= u2u_slice(sum_x_51_5_addsub, 1, 1);
  cast_internal_s_66_3_convert <= u2u_cast(sum_x_51_5_addsub, 0, 2, 0);
  cast_internal_s_83_3_convert <= u2u_cast(cast_internal_s_66_3_convert, 0, 16, 0);
  op_mem_91_20_push_front_pop_back_en <= '0';
  cout_mem_92_22_push_front_pop_back_en <= '0';
  prev_mode_93_22_next <= std_logic_vector_to_unsigned("000");
  s <= unsigned_to_std_logic_vector(cast_internal_s_83_3_convert);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_a369e00c6b is
  port (
    in0 : in std_logic_vector((16 - 1) downto 0);
    in1 : in std_logic_vector((16 - 1) downto 0);
    y : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_a369e00c6b;


architecture behavior of concat_a369e00c6b is
  signal in0_1_23: unsigned((16 - 1) downto 0);
  signal in1_1_27: unsigned((16 - 1) downto 0);
  signal y_2_1_concat: unsigned((32 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity bitbasher_ec0a00530d is
  port (
    le : in std_logic_vector((32 - 1) downto 0);
    be : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end bitbasher_ec0a00530d;


architecture behavior of bitbasher_ec0a00530d is
  signal le_1_27: signed((32 - 1) downto 0);
  signal slice_5_29: unsigned((8 - 1) downto 0);
  signal slice_5_46: unsigned((8 - 1) downto 0);
  signal slice_5_64: unsigned((8 - 1) downto 0);
  signal slice_5_83: unsigned((8 - 1) downto 0);
  signal fullbe_5_1_concat: unsigned((32 - 1) downto 0);
begin
  le_1_27 <= std_logic_vector_to_signed(le);
  slice_5_29 <= s2u_slice(le_1_27, 7, 0);
  slice_5_46 <= s2u_slice(le_1_27, 15, 8);
  slice_5_64 <= s2u_slice(le_1_27, 23, 16);
  slice_5_83 <= s2u_slice(le_1_27, 31, 24);
  fullbe_5_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(slice_5_29) & unsigned_to_std_logic_vector(slice_5_46) & unsigned_to_std_logic_vector(slice_5_64) & unsigned_to_std_logic_vector(slice_5_83));
  be <= unsigned_to_std_logic_vector(fullbe_5_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_37567836aa is
  port (
    op : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_37567836aa;


architecture behavior of constant_37567836aa is
begin
  op <= "00000000000000000000000000000000";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity mux_e68e4e3a85 is
  port (
    sel : in std_logic_vector((4 - 1) downto 0);
    d0 : in std_logic_vector((32 - 1) downto 0);
    d1 : in std_logic_vector((32 - 1) downto 0);
    d2 : in std_logic_vector((32 - 1) downto 0);
    d3 : in std_logic_vector((32 - 1) downto 0);
    d4 : in std_logic_vector((32 - 1) downto 0);
    d5 : in std_logic_vector((32 - 1) downto 0);
    d6 : in std_logic_vector((32 - 1) downto 0);
    d7 : in std_logic_vector((32 - 1) downto 0);
    d8 : in std_logic_vector((32 - 1) downto 0);
    d9 : in std_logic_vector((32 - 1) downto 0);
    y : out std_logic_vector((32 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end mux_e68e4e3a85;


architecture behavior of mux_e68e4e3a85 is
  signal sel_1_20: std_logic_vector((4 - 1) downto 0);
  signal d0_1_24: std_logic_vector((32 - 1) downto 0);
  signal d1_1_27: std_logic_vector((32 - 1) downto 0);
  signal d2_1_30: std_logic_vector((32 - 1) downto 0);
  signal d3_1_33: std_logic_vector((32 - 1) downto 0);
  signal d4_1_36: std_logic_vector((32 - 1) downto 0);
  signal d5_1_39: std_logic_vector((32 - 1) downto 0);
  signal d6_1_42: std_logic_vector((32 - 1) downto 0);
  signal d7_1_45: std_logic_vector((32 - 1) downto 0);
  signal d8_1_48: std_logic_vector((32 - 1) downto 0);
  signal d9_1_51: std_logic_vector((32 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((33 - 1) downto 0);
  signal unregy_29_5_convert: std_logic_vector((32 - 1) downto 0);
begin
  sel_1_20 <= sel;
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  d2_1_30 <= d2;
  d3_1_33 <= d3;
  d4_1_36 <= d4;
  d5_1_39 <= d5;
  d6_1_42 <= d6;
  d7_1_45 <= d7;
  d8_1_48 <= d8;
  d9_1_51 <= d9;
  proc_switch_6_1: process (d0_1_24, d1_1_27, d2_1_30, d3_1_33, d4_1_36, d5_1_39, d6_1_42, d7_1_45, d8_1_48, d9_1_51, sel_1_20)
  is
  begin
    case sel_1_20 is 
      when "0000" =>
        unregy_join_6_1 <= cast(d0_1_24, 0, 33, 0, xlUnsigned);
      when "0001" =>
        unregy_join_6_1 <= cast(d1_1_27, 0, 33, 0, xlUnsigned);
      when "0010" =>
        unregy_join_6_1 <= cast(d2_1_30, 0, 33, 0, xlUnsigned);
      when "0011" =>
        unregy_join_6_1 <= cast(d3_1_33, 0, 33, 0, xlUnsigned);
      when "0100" =>
        unregy_join_6_1 <= cast(d4_1_36, 0, 33, 0, xlUnsigned);
      when "0101" =>
        unregy_join_6_1 <= cast(d5_1_39, 0, 33, 0, xlUnsigned);
      when "0110" =>
        unregy_join_6_1 <= cast(d6_1_42, 0, 33, 0, xlUnsigned);
      when "0111" =>
        unregy_join_6_1 <= cast(d7_1_45, 0, 33, 0, xlSigned);
      when "1000" =>
        unregy_join_6_1 <= cast(d8_1_48, 0, 33, 0, xlSigned);
      when others =>
        unregy_join_6_1 <= cast(d9_1_51, 0, 33, 0, xlSigned);
    end case;
  end process proc_switch_6_1;
  unregy_29_5_convert <= convert_type(unregy_join_6_1, 33, 0, xlSigned, 32, 0, xlSigned, xlTruncate, xlSaturate);
  y <= unregy_29_5_convert;
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_711b303c09 is
  port (
    op : out std_logic_vector((16 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_711b303c09;


architecture behavior of constant_711b303c09 is
begin
  op <= "0000000000000110";
end behavior;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_unsigned.all;

ENTITY SHSTATE IS
	PORT (MUXsel : OUT std_logic_vector (3 DOWNTO 0);
    CE : IN std_logic_vector (2 DOWNTO 0);
		sh_clk,sh_ce,empty,full,RESET,S: IN std_logic;
		REQ,Scan,WEQ : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF SHSTATE IS
	COMPONENT SHELL_SHSTATE
		PORT (sh_clk,CE0,CE1,CE2,empty,full,RESET,S: IN std_logic;
			MUXsel0,MUXsel1,MUXsel2,MUXsel3,REQ,Scan,WEQ : OUT std_logic);
	END COMPONENT;
BEGIN
	SHELL1_SHSTATE : SHELL_SHSTATE PORT MAP (sh_clk=>sh_clk,CE0=>CE(0),CE1=>CE(1),
		CE2=>CE(2),empty=>empty,full=>full,RESET=>RESET,S=>S,MUXsel0=>MUXsel(0),MUXsel1
		=>MUXsel(1),MUXsel2=>MUXsel(2),MUXsel3=>MUXsel(3),REQ=>REQ,Scan=>Scan,WEQ=>
		WEQ);
END BEHAVIOR;
--  D:\DATA\XILINX\SYSGEN\SSP\SSP_PROTO\V2_2\STATECAD\SHSTATE.vhd
--  VHDL code created by Xilinx's StateCAD 9.2i
--  Thu Apr 17 11:00:08 2008

--  This VHDL code (for use with Xilinx XST) was generated using: 
--  enumerated state assignment with structured code format.
--  Minimization is enabled,  implied else is disabled, 
--  and outputs are speed optimized.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY ieee;
USE ieee.std_logic_unsigned.all;

ENTITY SHELL_SHSTATE IS
	PORT (sh_clk,CE0,CE1,CE2,empty,full,RESET,S: IN std_logic;
		MUXsel0,MUXsel1,MUXsel2,MUXsel3,REQ,Scan,WEQ : OUT std_logic);
END;

ARCHITECTURE BEHAVIOR OF SHELL_SHSTATE IS
	TYPE type_sreg IS (Ch0,Ch1,Ch2,Idle,ShiftHeader,STLast,STWait);
	SIGNAL sreg, next_sreg : type_sreg;
	SIGNAL next_BP_Scan,next_RE,next_RWE,next_SHsel0,next_SHsel1,next_SHsel2,
		next_SHsel3,next_WE : std_logic;
	SIGNAL DataSel : std_logic_vector (3 DOWNTO 0);
	SIGNAL MUXsel : std_logic_vector (3 DOWNTO 0);
	SIGNAL SHsel : std_logic_vector (3 DOWNTO 0);

	FUNCTION cmp(a,b : type_sreg) RETURN std_logic IS
	BEGIN
		IF (a=b) THEN RETURN '1';
		ELSE RETURN '0';
		END IF; 
	END cmp;


	SIGNAL BP_REQ,BP_Scan,BP_WEQ,DataSel0,DataSel1,DataSel2,DataSel3,RE,RWE,
		SHCntEn,SHdone,SHsel0,SHsel1,SHsel2,SHsel3,WE: std_logic;
BEGIN
	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel3 <= '0';
			ELSE
				SHsel3 <= next_SHsel3;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel2 <= '0';
			ELSE
				SHsel2 <= next_SHsel2;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel1 <= '0';
			ELSE
				SHsel1 <= next_SHsel1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk, RESET)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF (RESET='1') THEN
				SHsel0 <= '0';
			ELSE
				SHsel0 <= next_SHsel0;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				sreg <= Idle;
			ELSE
				sreg <= next_sreg;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				BP_Scan <= '0';
			ELSE
				BP_Scan <= next_BP_Scan;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				RE <= '1';
			ELSE
				RE <= next_RE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				RWE <= '0';
			ELSE
				RWE <= next_RWE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sh_clk)
	BEGIN
		IF sh_clk='1' AND sh_clk'event THEN
			IF ( RESET='1' ) THEN
				WE <= '0';
			ELSE
				WE <= next_WE;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (sreg,BP_REQ,BP_Scan,BP_WEQ,CE0,CE1,CE2,RESET,RWE,S,SHdone)
	BEGIN
		next_BP_Scan <= BP_Scan;next_RWE <= RWE;
		next_RE <= '0'; next_WE <= '0'; 

		next_sreg<=Ch0;

		IF ( RESET='1' ) THEN
			next_sreg<=Idle;
			next_BP_Scan<='0';
			next_RWE<='0';
			next_WE<='0';
			next_RE<='1';
		ELSE
			CASE sreg IS
				WHEN Ch0 =>
					IF ( BP_WEQ='1' AND RWE='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND RWE='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='0' ) OR ( RWE='1' AND BP_REQ='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN Ch1 =>
					IF ( RWE='0' AND BP_WEQ='1' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND CE0='1' AND BP_WEQ='1' AND BP_REQ='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( RWE='1' AND BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='0' ) OR ( RWE='1' AND BP_REQ='1' AND CE0='0' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
				WHEN Ch2 =>
					IF ( BP_WEQ='0' ) OR ( BP_REQ='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='1' AND CE1='1' AND CE0='0' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='0' AND S='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='1' AND BP_REQ='0' AND S='1' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN Idle =>
					IF ( BP_REQ='0' ) THEN
						next_sreg<=Idle;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_REQ='1' ) THEN
						next_sreg<=ShiftHeader;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='1';
					END IF;
				WHEN ShiftHeader =>
					IF ( SHdone='0' ) THEN
						next_sreg<=ShiftHeader;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='1';
					END IF;
					IF ( SHdone='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( SHdone='1' AND CE0='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( SHdone='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
				WHEN STLast =>
					IF ( BP_WEQ='0' ) THEN
						next_sreg<=STLast;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
					IF ( BP_WEQ='1' ) THEN
						next_sreg<=Idle;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';
						next_BP_Scan<='0';
					END IF;
				WHEN STWait =>
					IF ( BP_REQ='0' ) THEN
						next_sreg<=STWait;
						next_WE<='0';
						next_RE<='1';
						next_RWE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='0' AND CE1='0' ) THEN
						next_sreg<=Ch2;
						next_WE<='1';
						next_RE<='0';
						next_RWE<='1';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='0' AND CE1='1' ) THEN
						next_sreg<=Ch1;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
					IF ( BP_REQ='1' AND CE0='1' ) THEN
						next_sreg<=Ch0;
						next_WE<='1';
						next_RE<='0';

						IF (( BP_Scan='1' )) THEN next_BP_Scan<='1';
						ELSE next_BP_Scan<='0';
						END IF;

						IF (( CE1='0' AND CE2='0' )) THEN next_RWE<='1';
						ELSE next_RWE<='0';
						END IF;

					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;
	END PROCESS;

	PROCESS (sreg,SHCntEn,SHsel0,SHsel1,SHsel2,SHsel3,SHsel)
	BEGIN
		SHsel <= ( ( (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)) +
			std_logic_vector'("0001") ) AND (  std_logic_vector'( SHCntEn, SHCntEn, 
			SHCntEn, SHCntEn)) ) OR  (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)
			) AND (  std_logic_vector'( NOT SHCntEn, NOT SHCntEn, NOT SHCntEn, NOT 
			SHCntEn)) AND (  std_logic_vector'( NOT cmp(Idle,sreg), NOT cmp(Idle,sreg), 
			NOT cmp(Idle,sreg), NOT cmp(Idle,sreg))) ));
		next_SHsel0 <= SHsel(0);
		next_SHsel1 <= SHsel(1);
		next_SHsel2 <= SHsel(2);
		next_SHsel3 <= SHsel(3);
	END PROCESS;

	PROCESS (empty,full,RE,RWE)
	BEGIN
		IF (( empty='0' AND RE='1' ) OR ( empty='0' AND RWE='1' AND full='0' )) 
			THEN BP_REQ<='1';
		ELSE BP_REQ<='0';
		END IF;
	END PROCESS;

	PROCESS (full,WE)
	BEGIN
		IF (( WE='1' AND full='0' )) THEN BP_WEQ<='1';
		ELSE BP_WEQ<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_REQ)
	BEGIN
		IF (( BP_REQ='1' )) THEN REQ<='1';
		ELSE REQ<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_Scan)
	BEGIN
		IF (( BP_Scan='1' )) THEN Scan<='1';
		ELSE Scan<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_WEQ,sreg)
	BEGIN
		IF ((  (sreg=ShiftHeader)AND BP_WEQ='1' )) THEN SHCntEn<='1';
		ELSE SHCntEn<='0';
		END IF;
	END PROCESS;

	PROCESS (SHCntEn,SHsel0,SHsel1,SHsel2,SHsel3)
	BEGIN
		IF (( SHCntEn='1' AND SHsel0='1' AND SHsel1='0' AND SHsel2='1' AND 
			SHsel3='0' )) THEN SHdone<='1';
		ELSE SHdone<='0';
		END IF;
	END PROCESS;

	PROCESS (BP_WEQ)
	BEGIN
		IF (( BP_WEQ='1' )) THEN WEQ<='1';
		ELSE WEQ<='0';
		END IF;
	END PROCESS;

	PROCESS (sreg,DataSel)
	BEGIN
		DataSel <= ( (std_logic_vector'("0001") AND (  std_logic_vector'( cmp(Ch0,
			sreg), cmp(Ch0,sreg), cmp(Ch0,sreg), cmp(Ch0,sreg))) ) OR  (std_logic_vector'
			("0010") AND (  std_logic_vector'( cmp(Ch1,sreg), cmp(Ch1,sreg), cmp(Ch1,sreg
			), cmp(Ch1,sreg))) ) OR  (std_logic_vector'("0011") AND (  std_logic_vector'(
			 cmp(Ch2,sreg), cmp(Ch2,sreg), cmp(Ch2,sreg), cmp(Ch2,sreg))) ));
		DataSel0 <= DataSel(0);
		DataSel1 <= DataSel(1);
		DataSel2 <= DataSel(2);
		DataSel3 <= DataSel(3);
	END PROCESS;

	PROCESS (DataSel0,DataSel1,DataSel2,DataSel3,SHsel0,SHsel1,SHsel2,SHsel3,
		MUXsel)
	BEGIN
		MUXsel <= (( std_logic_vector'(SHsel3, SHsel2, SHsel1, SHsel0)) +( 
			std_logic_vector'(DataSel3, DataSel2, DataSel1, DataSel0)));
		MUXsel0 <= MUXsel(0);
		MUXsel1 <= MUXsel(1);
		MUXsel2 <= MUXsel(2);
		MUXsel3 <= MUXsel(3);
	END PROCESS;
END BEHAVIOR;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_9f5572ba51 is
  port (
    op : out std_logic_vector((16 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_9f5572ba51;


architecture behavior of constant_9f5572ba51 is
begin
  op <= "0000000000000000";
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity concat_955d2a4670 is
  port (
    in0 : in std_logic_vector((26 - 1) downto 0);
    in1 : in std_logic_vector((26 - 1) downto 0);
    in2 : in std_logic_vector((26 - 1) downto 0);
    y : out std_logic_vector((78 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end concat_955d2a4670;


architecture behavior of concat_955d2a4670 is
  signal in0_1_23: unsigned((26 - 1) downto 0);
  signal in1_1_27: unsigned((26 - 1) downto 0);
  signal in2_1_31: unsigned((26 - 1) downto 0);
  signal y_2_1_concat: unsigned((78 - 1) downto 0);
begin
  in0_1_23 <= std_logic_vector_to_unsigned(in0);
  in1_1_27 <= std_logic_vector_to_unsigned(in1);
  in2_1_31 <= std_logic_vector_to_unsigned(in2);
  y_2_1_concat <= std_logic_vector_to_unsigned(unsigned_to_std_logic_vector(in0_1_23) & unsigned_to_std_logic_vector(in1_1_27) & unsigned_to_std_logic_vector(in2_1_31));
  y <= unsigned_to_std_logic_vector(y_2_1_concat);
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity constant_124a45adb9 is
  port (
    op : out std_logic_vector((96 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end constant_124a45adb9;


architecture behavior of constant_124a45adb9 is
begin
  op <= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
end behavior;


-------------------------------------------------------------------
-- System Generator version 12.1 VHDL source file.
--
-- Copyright(C) 2010 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2010 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
-- synopsys translate_off
library XilinxCoreLib;
-- synopsys translate_on
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.conv_pkg.all;
entity xlfifogen is
  generic (
    core_name0: string := "";
    data_width: integer := -1;
    data_count_width: integer := -1;
    percent_full_width: integer := -1;
    has_ae : integer := 0;
    has_af : integer := 0
  );
  port (
    din: in std_logic_vector(data_width - 1 downto 0);
    we: in std_logic;
    we_ce: in std_logic;
    re: in std_logic;
    re_ce: in std_logic;
    rst: in std_logic;
    en: in std_logic;
    ce: in std_logic;
    clk: in std_logic;
    empty: out std_logic;
    full: out std_logic;
    percent_full: out std_logic_vector(percent_full_width - 1 downto 0);
    dcount: out std_logic_vector(data_count_width - 1 downto 0);
    ae: out std_logic;
    af: out std_logic;
    dout: out std_logic_vector(data_width - 1 downto 0)
  );
end xlfifogen ;
architecture behavior of xlfifogen is
  component fifo_fg61_4b31b12dc888b197
    port (
      clk: in std_logic;
      srst: in std_logic;
      din: in std_logic_vector(data_width - 1 downto 0);
      wr_en: in std_logic;
      rd_en: in std_logic;
      dout: out std_logic_vector(data_width - 1 downto 0);
      full: out std_logic;
      empty: out std_logic;
      data_count: out std_logic_vector(data_count_width - 1 downto 0)
    );
  end component;
  attribute syn_black_box of fifo_fg61_4b31b12dc888b197:
    component is true;
  attribute fpga_dont_touch of fifo_fg61_4b31b12dc888b197:
    component is "true";
  attribute box_type of fifo_fg61_4b31b12dc888b197:
    component  is "black_box";
  signal rd_en: std_logic;
  signal wr_en: std_logic;
  signal srst: std_logic;
  signal core_full: std_logic;
  signal core_dcount: std_logic_vector(data_count_width - 1 downto 0);
begin
  comp0: if ((core_name0 = "fifo_fg61_4b31b12dc888b197")) generate
    core_instance0: fifo_fg61_4b31b12dc888b197
      port map (
        clk => clk,
        srst => srst,
        din => din,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => dout,
        full => core_full,
        empty => empty,
        data_count => core_dcount
      );
  end generate;

  modify_count: process(core_full, core_dcount) is
  begin
    if core_full = '1' then
      percent_full <= (others => '1');
    else
      percent_full <= core_dcount(data_count_width-1 downto data_count_width-percent_full_width);
    end if;
  end process modify_count;

  rd_en <= re and en and re_ce;
  wr_en <= we and en and we_ce;
  full <= core_full;
  srst <= rst and ce;
  dcount <= core_dcount;

  terminate_core_ae: if has_ae /= 1 generate
  begin
    ae <= '0';
  end generate terminate_core_ae;
  terminate_core_af: if has_af /= 1 generate
  begin
    af <= '0';
  end generate terminate_core_af;
end  behavior;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.conv_pkg.all;

entity mux_df5cf57d6c is
  port (
    sel : in std_logic_vector((1 - 1) downto 0);
    d0 : in std_logic_vector((96 - 1) downto 0);
    d1 : in std_logic_vector((96 - 1) downto 0);
    y : out std_logic_vector((96 - 1) downto 0);
    clk : in std_logic;
    ce : in std_logic;
    clr : in std_logic);
end mux_df5cf57d6c;


architecture behavior of mux_df5cf57d6c is
  signal sel_1_20: std_logic;
  signal d0_1_24: std_logic_vector((96 - 1) downto 0);
  signal d1_1_27: std_logic_vector((96 - 1) downto 0);
  signal sel_internal_2_1_convert: std_logic_vector((1 - 1) downto 0);
  signal unregy_join_6_1: std_logic_vector((96 - 1) downto 0);
begin
  sel_1_20 <= sel(0);
  d0_1_24 <= d0;
  d1_1_27 <= d1;
  sel_internal_2_1_convert <= cast(std_logic_to_vector(sel_1_20), 0, 1, 0, xlUnsigned);
  proc_switch_6_1: process (d0_1_24, d1_1_27, sel_internal_2_1_convert)
  is
  begin
    case sel_internal_2_1_convert is 
      when "0" =>
        unregy_join_6_1 <= d0_1_24;
      when others =>
        unregy_join_6_1 <= d1_1_27;
    end case;
  end process proc_switch_6_1;
  y <= unregy_join_6_1;
end behavior;

library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/Coadd/SignedAdd"

entity signedadd_entity_af58c5b925 is
  port (
    a: in std_logic_vector(23 downto 0); 
    b: in std_logic_vector(31 downto 0); 
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    a_b: out std_logic_vector(31 downto 0); 
    ovf: out std_logic
  );
end signedadd_entity_af58c5b925;

architecture structural of signedadd_entity_af58c5b925 is
  signal addsub_s_net: std_logic_vector(31 downto 0);
  signal ce_1_sg_x0: std_logic;
  signal clk_1_sg_x0: std_logic;
  signal convert_dout_net_x2: std_logic_vector(23 downto 0);
  signal convert_dout_net_x3: std_logic_vector(31 downto 0);
  signal convert_dout_net_x4: std_logic_vector(31 downto 0);
  signal logical1_y_net: std_logic;
  signal logical2_y_net_x0: std_logic;
  signal logical_y_net: std_logic;
  signal msba_y_net: std_logic;
  signal msbb_y_net: std_logic;
  signal msbsum_y_net: std_logic;

begin
  convert_dout_net_x2 <= a;
  convert_dout_net_x3 <= b;
  ce_1_sg_x0 <= ce_1;
  clk_1_sg_x0 <= clk_1;
  a_b <= convert_dout_net_x4;
  ovf <= logical2_y_net_x0;

  addsub: entity work.xladdsub
    generic map (
      a_arith => xlSigned,
      a_bin_pt => 0,
      a_width => 24,
      b_arith => xlSigned,
      b_bin_pt => 0,
      b_width => 32,
      c_has_c_out => 0,
      c_latency => 0,
      c_output_width => 33,
      core_name0 => "addsb_11_0_fb4bc67ba183533a",
      extra_registers => 0,
      full_s_arith => 2,
      full_s_width => 33,
      latency => 0,
      overflow => 1,
      quantization => 1,
      s_arith => xlSigned,
      s_bin_pt => 0,
      s_width => 32
    )
    port map (
      a => convert_dout_net_x2,
      b => convert_dout_net_x3,
      ce => ce_1_sg_x0,
      clk => clk_1_sg_x0,
      clr => '0',
      en => "1",
      s => addsub_s_net
    );

  convert: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 2,
      din_bin_pt => 0,
      din_width => 32,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 32,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x0,
      clk => clk_1_sg_x0,
      clr => '0',
      din => addsub_s_net,
      en => "1",
      dout => convert_dout_net_x4
    );

  logical: entity work.logical_f6397bdee1
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => msba_y_net,
      d1(0) => msbb_y_net,
      y(0) => logical_y_net
    );

  logical1: entity work.logical_e77c53f8bd
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => msbsum_y_net,
      d1(0) => msba_y_net,
      y(0) => logical1_y_net
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical1_y_net,
      d1(0) => logical_y_net,
      y(0) => logical2_y_net_x0
    );

  msba: entity work.xlslice
    generic map (
      new_lsb => 23,
      new_msb => 23,
      x_width => 24,
      y_width => 1
    )
    port map (
      x => convert_dout_net_x2,
      y(0) => msba_y_net
    );

  msbb: entity work.xlslice
    generic map (
      new_lsb => 31,
      new_msb => 31,
      x_width => 32,
      y_width => 1
    )
    port map (
      x => convert_dout_net_x3,
      y(0) => msbb_y_net
    );

  msbsum: entity work.xlslice
    generic map (
      new_lsb => 31,
      new_msb => 31,
      x_width => 32,
      y_width => 1
    )
    port map (
      x => addsub_s_net,
      y(0) => msbsum_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/Coadd/UnConcat24"

entity unconcat24_entity_f461bff1ed is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    in24: in std_logic_vector(77 downto 0); 
    out0: out std_logic_vector(23 downto 0); 
    out1: out std_logic_vector(23 downto 0); 
    out2: out std_logic_vector(23 downto 0); 
    paovf: out std_logic_vector(5 downto 0)
  );
end unconcat24_entity_f461bff1ed;

architecture structural of unconcat24_entity_f461bff1ed is
  signal adoor0_53_y_net: std_logic;
  signal adoor1_27_y_net: std_logic;
  signal adoor2_1_y_net: std_logic;
  signal ce_1_sg_x3: std_logic;
  signal clk_1_sg_x3: std_logic;
  signal concat_y_net_x0: std_logic_vector(5 downto 0);
  signal convert1_dout_net_x2: std_logic_vector(23 downto 0);
  signal convert2_dout_net_x2: std_logic_vector(23 downto 0);
  signal convert_dout_net_x3: std_logic_vector(23 downto 0);
  signal paovf0_53_y_net: std_logic;
  signal paovf1_26_y_net: std_logic;
  signal paovf2_0_y_net: std_logic;
  signal register_q_net_x0: std_logic_vector(77 downto 0);
  signal sig0_54_77_y_net: std_logic_vector(23 downto 0);
  signal sig1_28_51_y_net: std_logic_vector(23 downto 0);
  signal sig2_2_25_y_net: std_logic_vector(23 downto 0);

begin
  ce_1_sg_x3 <= ce_1;
  clk_1_sg_x3 <= clk_1;
  register_q_net_x0 <= in24;
  out0 <= convert_dout_net_x3;
  out1 <= convert1_dout_net_x2;
  out2 <= convert2_dout_net_x2;
  paovf <= concat_y_net_x0;

  adoor0_53: entity work.xlslice
    generic map (
      new_lsb => 53,
      new_msb => 53,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => adoor0_53_y_net
    );

  adoor1_27: entity work.xlslice
    generic map (
      new_lsb => 27,
      new_msb => 27,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => adoor1_27_y_net
    );

  adoor2_1: entity work.xlslice
    generic map (
      new_lsb => 1,
      new_msb => 1,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => adoor2_1_y_net
    );

  concat: entity work.concat_2dc093ca7a
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0(0) => adoor2_1_y_net,
      in1(0) => adoor1_27_y_net,
      in2(0) => adoor0_53_y_net,
      in3(0) => paovf2_0_y_net,
      in4(0) => paovf1_26_y_net,
      in5(0) => paovf0_53_y_net,
      y => concat_y_net_x0
    );

  convert: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 24,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 24,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x3,
      clk => clk_1_sg_x3,
      clr => '0',
      din => sig0_54_77_y_net,
      en => "1",
      dout => convert_dout_net_x3
    );

  convert1: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 24,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 24,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x3,
      clk => clk_1_sg_x3,
      clr => '0',
      din => sig1_28_51_y_net,
      en => "1",
      dout => convert1_dout_net_x2
    );

  convert2: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 24,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 24,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x3,
      clk => clk_1_sg_x3,
      clr => '0',
      din => sig2_2_25_y_net,
      en => "1",
      dout => convert2_dout_net_x2
    );

  paovf0_53: entity work.xlslice
    generic map (
      new_lsb => 52,
      new_msb => 52,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => paovf0_53_y_net
    );

  paovf1_26: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 0,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => paovf1_26_y_net
    );

  paovf2_0: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 0,
      x_width => 78,
      y_width => 1
    )
    port map (
      x => register_q_net_x0,
      y(0) => paovf2_0_y_net
    );

  sig0_54_77: entity work.xlslice
    generic map (
      new_lsb => 54,
      new_msb => 77,
      x_width => 78,
      y_width => 24
    )
    port map (
      x => register_q_net_x0,
      y => sig0_54_77_y_net
    );

  sig1_28_51: entity work.xlslice
    generic map (
      new_lsb => 28,
      new_msb => 51,
      x_width => 78,
      y_width => 24
    )
    port map (
      x => register_q_net_x0,
      y => sig1_28_51_y_net
    );

  sig2_2_25: entity work.xlslice
    generic map (
      new_lsb => 2,
      new_msb => 25,
      x_width => 78,
      y_width => 24
    )
    port map (
      x => register_q_net_x0,
      y => sig2_2_25_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/Coadd/UnConcat32"

entity unconcat32_entity_f6ea947e70 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    in32: in std_logic_vector(95 downto 0); 
    out0: out std_logic_vector(31 downto 0); 
    out1: out std_logic_vector(31 downto 0); 
    out2: out std_logic_vector(31 downto 0)
  );
end unconcat32_entity_f6ea947e70;

architecture structural of unconcat32_entity_f6ea947e70 is
  signal ce_1_sg_x4: std_logic;
  signal clk_1_sg_x4: std_logic;
  signal convert1_dout_net_x3: std_logic_vector(31 downto 0);
  signal convert2_dout_net_x3: std_logic_vector(31 downto 0);
  signal convert_dout_net_x4: std_logic_vector(31 downto 0);
  signal mux1_y_net_x0: std_logic_vector(95 downto 0);
  signal slice3_y_net: std_logic_vector(31 downto 0);
  signal slice4_y_net: std_logic_vector(31 downto 0);
  signal slice5_y_net: std_logic_vector(31 downto 0);

begin
  ce_1_sg_x4 <= ce_1;
  clk_1_sg_x4 <= clk_1;
  mux1_y_net_x0 <= in32;
  out0 <= convert_dout_net_x4;
  out1 <= convert1_dout_net_x3;
  out2 <= convert2_dout_net_x3;

  convert: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 32,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 32,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x4,
      clk => clk_1_sg_x4,
      clr => '0',
      din => slice3_y_net,
      en => "1",
      dout => convert_dout_net_x4
    );

  convert1: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 32,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 32,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x4,
      clk => clk_1_sg_x4,
      clr => '0',
      din => slice4_y_net,
      en => "1",
      dout => convert1_dout_net_x3
    );

  convert2: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 32,
      dout_arith => 2,
      dout_bin_pt => 0,
      dout_width => 32,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x4,
      clk => clk_1_sg_x4,
      clr => '0',
      din => slice5_y_net,
      en => "1",
      dout => convert2_dout_net_x3
    );

  slice3: entity work.xlslice
    generic map (
      new_lsb => 64,
      new_msb => 95,
      x_width => 96,
      y_width => 32
    )
    port map (
      x => mux1_y_net_x0,
      y => slice3_y_net
    );

  slice4: entity work.xlslice
    generic map (
      new_lsb => 32,
      new_msb => 63,
      x_width => 96,
      y_width => 32
    )
    port map (
      x => mux1_y_net_x0,
      y => slice4_y_net
    );

  slice5: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 31,
      x_width => 96,
      y_width => 32
    )
    port map (
      x => mux1_y_net_x0,
      y => slice5_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/Coadd"

entity coadd_entity_2d9be86573 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    in24: in std_logic_vector(77 downto 0); 
    in32: in std_logic_vector(95 downto 0); 
    out32: out std_logic_vector(95 downto 0); 
    ovf: out std_logic_vector(8 downto 0)
  );
end coadd_entity_2d9be86573;

architecture structural of coadd_entity_2d9be86573 is
  signal ce_1_sg_x5: std_logic;
  signal clk_1_sg_x5: std_logic;
  signal concat1_y_net_x0: std_logic_vector(95 downto 0);
  signal concat_y_net_x0: std_logic_vector(5 downto 0);
  signal concat_y_net_x1: std_logic_vector(8 downto 0);
  signal convert1_dout_net_x2: std_logic_vector(23 downto 0);
  signal convert1_dout_net_x3: std_logic_vector(31 downto 0);
  signal convert2_dout_net_x2: std_logic_vector(23 downto 0);
  signal convert2_dout_net_x3: std_logic_vector(31 downto 0);
  signal convert_dout_net_x0: std_logic_vector(31 downto 0);
  signal convert_dout_net_x1: std_logic_vector(31 downto 0);
  signal convert_dout_net_x3: std_logic_vector(23 downto 0);
  signal convert_dout_net_x4: std_logic_vector(31 downto 0);
  signal convert_dout_net_x5: std_logic_vector(31 downto 0);
  signal logical2_y_net_x0: std_logic;
  signal logical2_y_net_x1: std_logic;
  signal logical2_y_net_x2: std_logic;
  signal mux1_y_net_x1: std_logic_vector(95 downto 0);
  signal register_q_net_x1: std_logic_vector(77 downto 0);

begin
  ce_1_sg_x5 <= ce_1;
  clk_1_sg_x5 <= clk_1;
  register_q_net_x1 <= in24;
  mux1_y_net_x1 <= in32;
  out32 <= concat1_y_net_x0;
  ovf <= concat_y_net_x1;

  concat: entity work.concat_09c011ee04
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => concat_y_net_x0,
      in1(0) => logical2_y_net_x0,
      in2(0) => logical2_y_net_x1,
      in3(0) => logical2_y_net_x2,
      y => concat_y_net_x1
    );

  concat1: entity work.concat_fe7b06fbf5
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => convert_dout_net_x4,
      in1 => convert_dout_net_x0,
      in2 => convert_dout_net_x1,
      y => concat1_y_net_x0
    );

  signedadd1_c81ed95a1f: entity work.signedadd_entity_af58c5b925
    port map (
      a => convert1_dout_net_x2,
      b => convert1_dout_net_x3,
      ce_1 => ce_1_sg_x5,
      clk_1 => clk_1_sg_x5,
      a_b => convert_dout_net_x0,
      ovf => logical2_y_net_x1
    );

  signedadd2_e3d057a3cb: entity work.signedadd_entity_af58c5b925
    port map (
      a => convert2_dout_net_x2,
      b => convert2_dout_net_x3,
      ce_1 => ce_1_sg_x5,
      clk_1 => clk_1_sg_x5,
      a_b => convert_dout_net_x1,
      ovf => logical2_y_net_x2
    );

  signedadd_af58c5b925: entity work.signedadd_entity_af58c5b925
    port map (
      a => convert_dout_net_x3,
      b => convert_dout_net_x5,
      ce_1 => ce_1_sg_x5,
      clk_1 => clk_1_sg_x5,
      a_b => convert_dout_net_x4,
      ovf => logical2_y_net_x0
    );

  unconcat24_f461bff1ed: entity work.unconcat24_entity_f461bff1ed
    port map (
      ce_1 => ce_1_sg_x5,
      clk_1 => clk_1_sg_x5,
      in24 => register_q_net_x1,
      out0 => convert_dout_net_x3,
      out1 => convert1_dout_net_x2,
      out2 => convert2_dout_net_x2,
      paovf => concat_y_net_x0
    );

  unconcat32_f6ea947e70: entity work.unconcat32_entity_f6ea947e70
    port map (
      ce_1 => ce_1_sg_x5,
      clk_1 => clk_1_sg_x5,
      in32 => mux1_y_net_x1,
      out0 => convert_dout_net_x5,
      out1 => convert1_dout_net_x3,
      out2 => convert2_dout_net_x3
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/CoaddCount/Counts/NSkipNext"

entity nskipnext_entity_a8d9a9487d is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    dec: in std_logic; 
    inc: in std_logic; 
    rst: in std_logic; 
    nskipnext: out std_logic_vector(15 downto 0)
  );
end nskipnext_entity_a8d9a9487d;

architecture structural of nskipnext_entity_a8d9a9487d is
  signal ce_1_sg_x6: std_logic;
  signal clk_1_sg_x6: std_logic;
  signal constant1_op_net: std_logic_vector(11 downto 0);
  signal logical1_y_net_x0: std_logic;
  signal logical1_y_net_x1: std_logic;
  signal logical2_y_net: std_logic;
  signal logical6_y_net_x0: std_logic;
  signal logical7_y_net_x0: std_logic;
  signal ntoskipnext_op_net_x0: std_logic_vector(15 downto 0);
  signal relational1_op_net: std_logic;

begin
  ce_1_sg_x6 <= ce_1;
  clk_1_sg_x6 <= clk_1;
  logical1_y_net_x1 <= dec;
  logical7_y_net_x0 <= inc;
  logical6_y_net_x0 <= rst;
  nskipnext <= ntoskipnext_op_net_x0;

  constant1: entity work.constant_fd28b32bf8
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant1_op_net
    );

  logical1: entity work.logical_6cb8f0ce02
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x0,
      d1(0) => logical7_y_net_x0,
      d2(0) => logical2_y_net,
      y(0) => logical1_y_net_x0
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical1_y_net_x1,
      d1(0) => relational1_op_net,
      y(0) => logical2_y_net
    );

  ntoskipnext: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_9e1d282a7a5f1b1e",
      op_arith => xlUnsigned,
      op_width => 16
    )
    port map (
      ce => ce_1_sg_x6,
      clk => clk_1_sg_x6,
      clr => '0',
      en(0) => logical1_y_net_x0,
      rst(0) => logical6_y_net_x0,
      up(0) => logical7_y_net_x0,
      op => ntoskipnext_op_net_x0
    );

  relational1: entity work.relational_ca8f2ee4fc
    port map (
      a => ntoskipnext_op_net_x0,
      b => constant1_op_net,
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => relational1_op_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/CoaddCount/Counts/PreSkipCt"

entity preskipct_entity_b0b62fbf05 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    decr: in std_logic; 
    din: in std_logic_vector(15 downto 0); 
    load: in std_logic; 
    psnz_x0: out std_logic
  );
end preskipct_entity_b0b62fbf05;

architecture structural of preskipct_entity_b0b62fbf05 is
  signal ce_1_sg_x7: std_logic;
  signal clk_1_sg_x7: std_logic;
  signal constant_op_net: std_logic_vector(11 downto 0);
  signal eos_x0: std_logic;
  signal logical12_y_net: std_logic;
  signal logical14_y_net: std_logic;
  signal logical6_y_net_x1: std_logic;
  signal ntoskipnext_op_net_x1: std_logic_vector(15 downto 0);
  signal preskipct_op_net: std_logic_vector(15 downto 0);
  signal psnz_x1: std_logic;

begin
  ce_1_sg_x7 <= ce_1;
  clk_1_sg_x7 <= clk_1;
  eos_x0 <= decr;
  ntoskipnext_op_net_x1 <= din;
  logical6_y_net_x1 <= load;
  psnz_x0 <= psnz_x1;

  constant_x0: entity work.constant_fd28b32bf8
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant_op_net
    );

  logical12: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x1,
      d1(0) => logical14_y_net,
      y(0) => logical12_y_net
    );

  logical14: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => eos_x0,
      d1(0) => psnz_x1,
      y(0) => logical14_y_net
    );

  preskipct: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_688cfddaf968f88b",
      op_arith => xlUnsigned,
      op_width => 16
    )
    port map (
      ce => ce_1_sg_x7,
      clk => clk_1_sg_x7,
      clr => '0',
      din => ntoskipnext_op_net_x1,
      en(0) => logical12_y_net,
      load(0) => logical6_y_net_x1,
      rst => "0",
      op => preskipct_op_net
    );

  relational: entity work.relational_ca8f2ee4fc
    port map (
      a => preskipct_op_net,
      b => constant_op_net,
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => psnz_x1
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/CoaddCount/Counts"

entity counts_entity_0ed2ea68cc is
  port (
    bos: in std_logic; 
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    empty: in std_logic; 
    eos: in std_logic; 
    lastscan: in std_logic; 
    lastskip: in std_logic; 
    preskip: in std_logic; 
    reset: in std_logic; 
    tc: in std_logic; 
    nskf: out std_logic_vector(15 downto 0); 
    nskl: out std_logic_vector(15 downto 0); 
    preskipnz: out std_logic; 
    scanenable: out std_logic
  );
end counts_entity_0ed2ea68cc;

architecture structural of counts_entity_0ed2ea68cc is
  signal ce_1_sg_x8: std_logic;
  signal clk_1_sg_x8: std_logic;
  signal cocount_lastscan_net_x0: std_logic;
  signal cocount_lastskip_net_x0: std_logic;
  signal cocount_preskip_net_x0: std_logic;
  signal eos_x1: std_logic;
  signal inverter1_op_net: std_logic;
  signal inverter2_op_net: std_logic;
  signal lastskipeos: std_logic;
  signal logical10_y_net: std_logic;
  signal logical11_y_net: std_logic;
  signal logical1_y_net_x1: std_logic;
  signal logical2_y_net: std_logic;
  signal logical5_y_net_x0: std_logic;
  signal logical6_y_net_x0: std_logic;
  signal logical6_y_net_x1: std_logic;
  signal logical7_y_net_x0: std_logic;
  signal logical_y_net_x0: std_logic;
  signal nls_x0: std_logic_vector(15 downto 0);
  signal nps_x0: std_logic_vector(15 downto 0);
  signal ntoskipnext_op_net_x1: std_logic_vector(15 downto 0);
  signal preskipeos: std_logic;
  signal psnz_x2: std_logic;
  signal rdy_x0: std_logic;
  signal relational_op_net_x0: std_logic;

begin
  logical6_y_net_x0 <= bos;
  ce_1_sg_x8 <= ce_1;
  clk_1_sg_x8 <= clk_1;
  rdy_x0 <= empty;
  eos_x1 <= eos;
  cocount_lastscan_net_x0 <= lastscan;
  cocount_lastskip_net_x0 <= lastskip;
  cocount_preskip_net_x0 <= preskip;
  logical_y_net_x0 <= reset;
  relational_op_net_x0 <= tc;
  nskf <= nps_x0;
  nskl <= nls_x0;
  preskipnz <= psnz_x2;
  scanenable <= logical5_y_net_x0;

  inverter1: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x8,
      clk => clk_1_sg_x8,
      clr => '0',
      ip(0) => logical5_y_net_x0,
      op(0) => inverter1_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x8,
      clk => clk_1_sg_x8,
      clr => '0',
      ip(0) => relational_op_net_x0,
      op(0) => inverter2_op_net
    );

  logical1: entity work.logical_954ee29728
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x0,
      d1(0) => inverter2_op_net,
      d2(0) => rdy_x0,
      y(0) => logical1_y_net_x1
    );

  logical10: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x1,
      d1(0) => lastskipeos,
      y(0) => logical10_y_net
    );

  logical11: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x1,
      d1(0) => preskipeos,
      y(0) => logical11_y_net
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_lastscan_net_x0,
      d1(0) => eos_x1,
      y(0) => logical2_y_net
    );

  logical3: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_preskip_net_x0,
      d1(0) => eos_x1,
      y(0) => preskipeos
    );

  logical4: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_lastskip_net_x0,
      d1(0) => eos_x1,
      y(0) => lastskipeos
    );

  logical5: entity work.logical_dfe2dded7f
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_lastskip_net_x0,
      d1(0) => cocount_preskip_net_x0,
      y(0) => logical5_y_net_x0
    );

  logical6: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical2_y_net,
      d1(0) => logical_y_net_x0,
      y(0) => logical6_y_net_x1
    );

  logical7: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter1_op_net,
      d1(0) => eos_x1,
      y(0) => logical7_y_net_x0
    );

  nlastskipped: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_8dfcc050e9d5f132",
      op_arith => xlUnsigned,
      op_width => 16
    )
    port map (
      ce => ce_1_sg_x8,
      clk => clk_1_sg_x8,
      clr => '0',
      en(0) => logical10_y_net,
      rst(0) => logical6_y_net_x1,
      op => nls_x0
    );

  npreskipped: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_8dfcc050e9d5f132",
      op_arith => xlUnsigned,
      op_width => 16
    )
    port map (
      ce => ce_1_sg_x8,
      clk => clk_1_sg_x8,
      clr => '0',
      en(0) => logical11_y_net,
      rst(0) => logical6_y_net_x1,
      op => nps_x0
    );

  nskipnext_a8d9a9487d: entity work.nskipnext_entity_a8d9a9487d
    port map (
      ce_1 => ce_1_sg_x8,
      clk_1 => clk_1_sg_x8,
      dec => logical1_y_net_x1,
      inc => logical7_y_net_x0,
      rst => logical6_y_net_x1,
      nskipnext => ntoskipnext_op_net_x1
    );

  preskipct_b0b62fbf05: entity work.preskipct_entity_b0b62fbf05
    port map (
      ce_1 => ce_1_sg_x8,
      clk_1 => clk_1_sg_x8,
      decr => eos_x1,
      din => ntoskipnext_op_net_x1,
      load => logical6_y_net_x1,
      psnz_x0 => psnz_x2
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/CoaddCount/ScanCount"

entity scancount_entity_61896eea03 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en: in std_logic; 
    nc: in std_logic_vector(13 downto 0); 
    rst: in std_logic; 
    tc: out std_logic
  );
end scancount_entity_61896eea03;

architecture structural of scancount_entity_61896eea03 is
  signal ce_1_sg_x9: std_logic;
  signal clk_1_sg_x9: std_logic;
  signal logical8_y_net_x0: std_logic;
  signal logical9_y_net_x0: std_logic;
  signal ncoadding_op_net: std_logic_vector(13 downto 0);
  signal register_q_net_x0: std_logic_vector(13 downto 0);
  signal relational_op_net_x1: std_logic;

begin
  ce_1_sg_x9 <= ce_1;
  clk_1_sg_x9 <= clk_1;
  logical8_y_net_x0 <= en;
  register_q_net_x0 <= nc;
  logical9_y_net_x0 <= rst;
  tc <= relational_op_net_x1;

  ncoadding: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_f09d056deed69f8d",
      op_arith => xlUnsigned,
      op_width => 14
    )
    port map (
      ce => ce_1_sg_x9,
      clk => clk_1_sg_x9,
      clr => '0',
      en(0) => logical8_y_net_x0,
      rst(0) => logical9_y_net_x0,
      op => ncoadding_op_net
    );

  relational: entity work.relational_d500ab1630
    port map (
      a => register_q_net_x0,
      b => ncoadding_op_net,
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => relational_op_net_x1
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/CoaddCount"

entity coaddcount_entity_0b1f7727cd is
  port (
    bos: in std_logic; 
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    dv: in std_logic; 
    dv0q_x0: in std_logic; 
    empty: in std_logic; 
    eos: in std_logic; 
    ncoaddin: in std_logic_vector(13 downto 0); 
    ovfin: in std_logic_vector(8 downto 0); 
    reset: in std_logic; 
    firstscan: out std_logic; 
    ncoadd: out std_logic_vector(13 downto 0); 
    nskf: out std_logic_vector(15 downto 0); 
    nskl: out std_logic_vector(15 downto 0); 
    ovf: out std_logic_vector(8 downto 0); 
    re0: out std_logic; 
    we0: out std_logic; 
    we1: out std_logic
  );
end coaddcount_entity_0b1f7727cd;

architecture structural of coaddcount_entity_0b1f7727cd is
  signal ce_1_sg_x10: std_logic;
  signal clk_1_sg_x10: std_logic;
  signal cocount_lastscan_net_x0: std_logic;
  signal cocount_lastskip_net_x0: std_logic;
  signal cocount_preskip_net_x0: std_logic;
  signal concat_y_net_x2: std_logic_vector(8 downto 0);
  signal delay1_q_net_x0: std_logic;
  signal dv0q_x1: std_logic;
  signal eos_x2: std_logic;
  signal from_register3_data_out_net_x0: std_logic_vector(13 downto 0);
  signal inverter1_op_net: std_logic;
  signal inverter2_op_net: std_logic;
  signal inverter3_op_net: std_logic;
  signal inverter4_op_net: std_logic;
  signal logical10_y_net: std_logic;
  signal logical11_y_net: std_logic_vector(8 downto 0);
  signal logical13_y_net: std_logic;
  signal logical14_y_net_x0: std_logic;
  signal logical15_y_net: std_logic;
  signal logical1_y_net: std_logic;
  signal logical2_y_net: std_logic;
  signal logical3_y_net: std_logic;
  signal logical4_y_net: std_logic;
  signal logical5_y_net: std_logic;
  signal logical5_y_net_x0: std_logic;
  signal logical6_y_net_x1: std_logic;
  signal logical6_y_net_x2: std_logic;
  signal logical7_y_net_x0: std_logic;
  signal logical8_y_net_x0: std_logic;
  signal logical9_y_net_x0: std_logic;
  signal logical_y_net: std_logic;
  signal logical_y_net_x1: std_logic;
  signal nls_x1: std_logic_vector(15 downto 0);
  signal nps_x1: std_logic_vector(15 downto 0);
  signal psnz_x2: std_logic;
  signal rdy_x1: std_logic;
  signal register1_q_net_x0: std_logic_vector(8 downto 0);
  signal register6_q_net_x0: std_logic;
  signal register_q_net_x1: std_logic_vector(13 downto 0);
  signal relational_op_net_x1: std_logic;
  signal we: std_logic;

begin
  logical6_y_net_x1 <= bos;
  ce_1_sg_x10 <= ce_1;
  clk_1_sg_x10 <= clk_1;
  delay1_q_net_x0 <= dv;
  dv0q_x1 <= dv0q_x0;
  rdy_x1 <= empty;
  eos_x2 <= eos;
  from_register3_data_out_net_x0 <= ncoaddin;
  concat_y_net_x2 <= ovfin;
  logical_y_net_x1 <= reset;
  firstscan <= register6_q_net_x0;
  ncoadd <= register_q_net_x1;
  nskf <= nps_x1;
  nskl <= nls_x1;
  ovf <= register1_q_net_x0;
  re0 <= logical14_y_net_x0;
  we0 <= logical6_y_net_x2;
  we1 <= logical7_y_net_x0;

  cocount_x0: entity work.COCOUNT
    port map (
      bos => logical6_y_net_x1,
      coct_ce => ce_1_sg_x10,
      coct_clk => clk_1_sg_x10,
      empty => rdy_x1,
      psnz => psnz_x2,
      reset => logical_y_net_x1,
      tc => relational_op_net_x1,
      lastscan => cocount_lastscan_net_x0,
      lastskip => cocount_lastskip_net_x0,
      preskip => cocount_preskip_net_x0
    );

  counts_0ed2ea68cc: entity work.counts_entity_0ed2ea68cc
    port map (
      bos => logical6_y_net_x1,
      ce_1 => ce_1_sg_x10,
      clk_1 => clk_1_sg_x10,
      empty => rdy_x1,
      eos => eos_x2,
      lastscan => cocount_lastscan_net_x0,
      lastskip => cocount_lastskip_net_x0,
      preskip => cocount_preskip_net_x0,
      reset => logical_y_net_x1,
      tc => relational_op_net_x1,
      nskf => nps_x1,
      nskl => nls_x1,
      preskipnz => psnz_x2,
      scanenable => logical5_y_net_x0
    );

  inverter1: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      clr => '0',
      ip(0) => logical6_y_net_x1,
      op(0) => inverter1_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      clr => '0',
      ip(0) => register6_q_net_x0,
      op(0) => inverter2_op_net
    );

  inverter3: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      clr => '0',
      ip(0) => cocount_lastscan_net_x0,
      op(0) => inverter3_op_net
    );

  inverter4: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      clr => '0',
      ip(0) => cocount_lastscan_net_x0,
      op(0) => inverter4_op_net
    );

  logical: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical5_y_net_x0,
      d1(0) => eos_x2,
      y(0) => logical_y_net
    );

  logical1: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_lastscan_net_x0,
      d1(0) => eos_x2,
      y(0) => logical1_y_net
    );

  logical10: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => eos_x2,
      d1(0) => inverter4_op_net,
      y(0) => logical10_y_net
    );

  logical11: entity work.logical_09a949dfe2
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => register1_q_net_x0,
      d1 => concat_y_net_x2,
      y => logical11_y_net
    );

  logical12: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay1_q_net_x0,
      d1(0) => logical5_y_net_x0,
      y(0) => we
    );

  logical13: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical10_y_net,
      d1(0) => logical15_y_net,
      y(0) => logical13_y_net
    );

  logical14: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical13_y_net,
      d1(0) => logical5_y_net_x0,
      y(0) => logical14_y_net_x0
    );

  logical15: entity work.logical_954ee29728
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter1_op_net,
      d1(0) => inverter2_op_net,
      d2(0) => dv0q_x1,
      y(0) => logical15_y_net
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical4_y_net,
      d1(0) => register6_q_net_x0,
      y(0) => logical2_y_net
    );

  logical3: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical1_y_net,
      d1(0) => logical_y_net_x1,
      y(0) => logical3_y_net
    );

  logical4: entity work.logical_bde51e424d
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical5_y_net_x0,
      d1(0) => eos_x2,
      y(0) => logical4_y_net
    );

  logical5: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical3_y_net,
      d1(0) => logical2_y_net,
      y(0) => logical5_y_net
    );

  logical6: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => we,
      d1(0) => inverter3_op_net,
      y(0) => logical6_y_net_x2
    );

  logical7: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => we,
      d1(0) => cocount_lastscan_net_x0,
      y(0) => logical7_y_net_x0
    );

  logical8: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical_y_net_x1,
      d1(0) => logical_y_net,
      y(0) => logical8_y_net_x0
    );

  logical9: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => cocount_lastscan_net_x0,
      d1(0) => logical_y_net_x1,
      y(0) => logical9_y_net_x0
    );

  register1: entity work.xlregister
    generic map (
      d_width => 9,
      init_value => b"000000000"
    )
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      d => logical11_y_net,
      en(0) => we,
      rst(0) => logical3_y_net,
      q => register1_q_net_x0
    );

  register6: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      d(0) => logical5_y_net,
      en => "1",
      rst => "0",
      q(0) => register6_q_net_x0
    );

  register_x0: entity work.xlregister
    generic map (
      d_width => 14,
      init_value => b"00000000000000"
    )
    port map (
      ce => ce_1_sg_x10,
      clk => clk_1_sg_x10,
      d => from_register3_data_out_net_x0,
      en(0) => logical_y_net_x1,
      rst => "0",
      q => register_q_net_x1
    );

  scancount_61896eea03: entity work.scancount_entity_61896eea03
    port map (
      ce_1 => ce_1_sg_x10,
      clk_1 => clk_1_sg_x10,
      en => logical8_y_net_x0,
      nc => register_q_net_x1,
      rst => logical9_y_net_x0,
      tc => relational_op_net_x1
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/DS_Redist/AllTrue/ChEnDec"

entity chendec_entity_d981a39e2e is
  port (
    chen: in std_logic_vector(2 downto 0); 
    ce0: out std_logic; 
    ce1: out std_logic; 
    ce2: out std_logic
  );
end chendec_entity_d981a39e2e;

architecture structural of chendec_entity_d981a39e2e is
  signal chenblbit0_y_net_x0: std_logic;
  signal chenblbit1_y_net_x0: std_logic;
  signal chenblbit2_y_net_x0: std_logic;
  signal delay4_q_net_x0: std_logic_vector(2 downto 0);

begin
  delay4_q_net_x0 <= chen;
  ce0 <= chenblbit0_y_net_x0;
  ce1 <= chenblbit1_y_net_x0;
  ce2 <= chenblbit2_y_net_x0;

  chenblbit0: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 0,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => delay4_q_net_x0,
      y(0) => chenblbit0_y_net_x0
    );

  chenblbit1: entity work.xlslice
    generic map (
      new_lsb => 1,
      new_msb => 1,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => delay4_q_net_x0,
      y(0) => chenblbit1_y_net_x0
    );

  chenblbit2: entity work.xlslice
    generic map (
      new_lsb => 2,
      new_msb => 2,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => delay4_q_net_x0,
      y(0) => chenblbit2_y_net_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/DS_Redist/AllTrue"

entity alltrue_entity_0dd0e180c1 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    d0: in std_logic; 
    d1: in std_logic; 
    d2: in std_logic; 
    en: in std_logic_vector(2 downto 0); 
    all_x0: out std_logic
  );
end alltrue_entity_0dd0e180c1;

architecture structural of alltrue_entity_0dd0e180c1 is
  signal ce_1_sg_x11: std_logic;
  signal chenblbit0_y_net_x0: std_logic;
  signal chenblbit1_y_net_x0: std_logic;
  signal chenblbit2_y_net_x0: std_logic;
  signal clk_1_sg_x11: std_logic;
  signal delay4_q_net_x1: std_logic_vector(2 downto 0);
  signal inverter1_op_net: std_logic;
  signal inverter2_op_net: std_logic;
  signal inverter2_op_net_x3: std_logic;
  signal inverter2_op_net_x4: std_logic;
  signal inverter2_op_net_x5: std_logic;
  signal inverter_op_net: std_logic;
  signal logical1_y_net: std_logic;
  signal logical2_y_net_x0: std_logic;
  signal logical4_y_net: std_logic;
  signal logical6_y_net: std_logic;

begin
  ce_1_sg_x11 <= ce_1;
  clk_1_sg_x11 <= clk_1;
  inverter2_op_net_x5 <= d0;
  inverter2_op_net_x4 <= d1;
  inverter2_op_net_x3 <= d2;
  delay4_q_net_x1 <= en;
  all_x0 <= logical2_y_net_x0;

  chendec_d981a39e2e: entity work.chendec_entity_d981a39e2e
    port map (
      chen => delay4_q_net_x1,
      ce0 => chenblbit0_y_net_x0,
      ce1 => chenblbit1_y_net_x0,
      ce2 => chenblbit2_y_net_x0
    );

  inverter: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x11,
      clk => clk_1_sg_x11,
      clr => '0',
      ip(0) => chenblbit0_y_net_x0,
      op(0) => inverter_op_net
    );

  inverter1: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x11,
      clk => clk_1_sg_x11,
      clr => '0',
      ip(0) => chenblbit1_y_net_x0,
      op(0) => inverter1_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x11,
      clk => clk_1_sg_x11,
      clr => '0',
      ip(0) => chenblbit2_y_net_x0,
      op(0) => inverter2_op_net
    );

  logical1: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net_x5,
      d1(0) => inverter_op_net,
      y(0) => logical1_y_net
    );

  logical2: entity work.logical_954ee29728
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical1_y_net,
      d1(0) => logical4_y_net,
      d2(0) => logical6_y_net,
      y(0) => logical2_y_net_x0
    );

  logical4: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net_x4,
      d1(0) => inverter1_op_net,
      y(0) => logical4_y_net
    );

  logical6: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net_x3,
      d1(0) => inverter2_op_net,
      y(0) => logical6_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/DS_Redist/DSIDec0"

entity dsidec0_entity_38d913571f is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    dsi: in std_logic_vector(2 downto 0); 
    dataready: out std_logic; 
    dataready2: out std_logic; 
    reset_ack: out std_logic
  );
end dsidec0_entity_38d913571f;

architecture structural of dsidec0_entity_38d913571f is
  signal ce_1_sg_x14: std_logic;
  signal clk_1_sg_x14: std_logic;
  signal ds_bot3_y_net_x0: std_logic_vector(2 downto 0);
  signal empty_bit2_y_net: std_logic;
  signal full_bit1_y_net_x3: std_logic;
  signal inverter2_op_net_x4: std_logic;
  signal rack_bit0_y_net_x3: std_logic;

begin
  ce_1_sg_x14 <= ce_1;
  clk_1_sg_x14 <= clk_1;
  ds_bot3_y_net_x0 <= dsi;
  dataready <= inverter2_op_net_x4;
  dataready2 <= full_bit1_y_net_x3;
  reset_ack <= rack_bit0_y_net_x3;

  empty_bit2: entity work.xlslice
    generic map (
      new_lsb => 2,
      new_msb => 2,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => ds_bot3_y_net_x0,
      y(0) => empty_bit2_y_net
    );

  full_bit1: entity work.xlslice
    generic map (
      new_lsb => 1,
      new_msb => 1,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => ds_bot3_y_net_x0,
      y(0) => full_bit1_y_net_x3
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x14,
      clk => clk_1_sg_x14,
      clr => '0',
      ip(0) => empty_bit2_y_net,
      op(0) => inverter2_op_net_x4
    );

  rack_bit0: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 0,
      x_width => 3,
      y_width => 1
    )
    port map (
      x => ds_bot3_y_net_x0,
      y(0) => rack_bit0_y_net_x3
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/DS_Redist"

entity ds_redist_entity_ad0f060043 is
  port (
    ce_1: in std_logic; 
    chen: in std_logic_vector(2 downto 0); 
    clk_1: in std_logic; 
    dsi0: in std_logic_vector(2 downto 0); 
    dsi1: in std_logic_vector(2 downto 0); 
    dsi2: in std_logic_vector(2 downto 0); 
    allack: out std_logic; 
    allready: out std_logic; 
    allready2: out std_logic
  );
end ds_redist_entity_ad0f060043;

architecture structural of ds_redist_entity_ad0f060043 is
  signal ce_1_sg_x17: std_logic;
  signal clk_1_sg_x17: std_logic;
  signal delay4_q_net_x6: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x3: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x4: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x5: std_logic_vector(2 downto 0);
  signal full_bit1_y_net_x3: std_logic;
  signal full_bit1_y_net_x4: std_logic;
  signal full_bit1_y_net_x5: std_logic;
  signal inverter2_op_net_x4: std_logic;
  signal inverter2_op_net_x5: std_logic;
  signal inverter2_op_net_x6: std_logic;
  signal logical2_y_net_x3: std_logic;
  signal logical2_y_net_x4: std_logic;
  signal logical2_y_net_x5: std_logic;
  signal rack_bit0_y_net_x3: std_logic;
  signal rack_bit0_y_net_x4: std_logic;
  signal rack_bit0_y_net_x5: std_logic;

begin
  ce_1_sg_x17 <= ce_1;
  delay4_q_net_x6 <= chen;
  clk_1_sg_x17 <= clk_1;
  ds_bot3_y_net_x5 <= dsi0;
  ds_bot3_y_net_x3 <= dsi1;
  ds_bot3_y_net_x4 <= dsi2;
  allack <= logical2_y_net_x5;
  allready <= logical2_y_net_x3;
  allready2 <= logical2_y_net_x4;

  alltrue1_25114b75c3: entity work.alltrue_entity_0dd0e180c1
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      d0 => full_bit1_y_net_x5,
      d1 => full_bit1_y_net_x4,
      d2 => full_bit1_y_net_x3,
      en => delay4_q_net_x6,
      all_x0 => logical2_y_net_x4
    );

  alltrue2_2a8d584770: entity work.alltrue_entity_0dd0e180c1
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      d0 => rack_bit0_y_net_x5,
      d1 => rack_bit0_y_net_x4,
      d2 => rack_bit0_y_net_x3,
      en => delay4_q_net_x6,
      all_x0 => logical2_y_net_x5
    );

  alltrue_0dd0e180c1: entity work.alltrue_entity_0dd0e180c1
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      d0 => inverter2_op_net_x6,
      d1 => inverter2_op_net_x5,
      d2 => inverter2_op_net_x4,
      en => delay4_q_net_x6,
      all_x0 => logical2_y_net_x3
    );

  dsidec0_38d913571f: entity work.dsidec0_entity_38d913571f
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      dsi => ds_bot3_y_net_x4,
      dataready => inverter2_op_net_x4,
      dataready2 => full_bit1_y_net_x3,
      reset_ack => rack_bit0_y_net_x3
    );

  dsidec1_693035c694: entity work.dsidec0_entity_38d913571f
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      dsi => ds_bot3_y_net_x3,
      dataready => inverter2_op_net_x5,
      dataready2 => full_bit1_y_net_x4,
      reset_ack => rack_bit0_y_net_x4
    );

  dsidec2_21f7bd4e8c: entity work.dsidec0_entity_38d913571f
    port map (
      ce_1 => ce_1_sg_x17,
      clk_1 => clk_1_sg_x17,
      dsi => ds_bot3_y_net_x5,
      dataready => inverter2_op_net_x6,
      dataready2 => full_bit1_y_net_x5,
      reset_ack => rack_bit0_y_net_x5
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/FIFO_RE/FIFOdec"

entity fifodec_entity_1c2b4a92ab is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en: in std_logic; 
    reset_x0: in std_logic; 
    en0: out std_logic; 
    en1: out std_logic; 
    en2: out std_logic
  );
end fifodec_entity_1c2b4a92ab;

architecture structural of fifodec_entity_1c2b4a92ab is
  signal ce_1_sg_x18: std_logic;
  signal clk_1_sg_x18: std_logic;
  signal delay1_q_net_x0: std_logic;
  signal delay_q_net_x0: std_logic;
  signal logical10_y_net: std_logic;
  signal logical1_y_net: std_logic;
  signal logical2_y_net: std_logic;
  signal logical3_y_net: std_logic;
  signal logical4_y_net: std_logic;
  signal logical5_y_net: std_logic;
  signal logical6_y_net: std_logic;
  signal logical7_y_net: std_logic;
  signal logical8_y_net: std_logic;
  signal logical9_y_net: std_logic;
  signal logical_y_net: std_logic;
  signal reset: std_logic;
  signal we: std_logic;
  signal we0_x0: std_logic;
  signal we1_x0: std_logic;
  signal we2_x0: std_logic;

begin
  ce_1_sg_x18 <= ce_1;
  clk_1_sg_x18 <= clk_1;
  delay_q_net_x0 <= en;
  delay1_q_net_x0 <= reset_x0;
  en0 <= we0_x0;
  en1 <= we1_x0;
  en2 <= we2_x0;

  inverter1: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x18,
      clk => clk_1_sg_x18,
      clr => '0',
      ip(0) => delay_q_net_x0,
      op(0) => we
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x18,
      clk => clk_1_sg_x18,
      clr => '0',
      ip(0) => delay1_q_net_x0,
      op(0) => reset
    );

  logical: entity work.logical_6cb8f0ce02
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay1_q_net_x0,
      d1(0) => logical1_y_net,
      d2(0) => logical2_y_net,
      y(0) => logical_y_net
    );

  logical1: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay_q_net_x0,
      d1(0) => we2_x0,
      y(0) => logical1_y_net
    );

  logical10: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => reset,
      d1(0) => logical7_y_net,
      y(0) => logical10_y_net
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => we,
      d1(0) => we0_x0,
      y(0) => logical2_y_net
    );

  logical3: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical4_y_net,
      d1(0) => logical5_y_net,
      y(0) => logical3_y_net
    );

  logical4: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay_q_net_x0,
      d1(0) => we0_x0,
      y(0) => logical4_y_net
    );

  logical5: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => we,
      d1(0) => we1_x0,
      y(0) => logical5_y_net
    );

  logical6: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => reset,
      d1(0) => logical3_y_net,
      y(0) => logical6_y_net
    );

  logical7: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical8_y_net,
      d1(0) => logical9_y_net,
      y(0) => logical7_y_net
    );

  logical8: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay_q_net_x0,
      d1(0) => we1_x0,
      y(0) => logical8_y_net
    );

  logical9: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => we,
      d1(0) => we2_x0,
      y(0) => logical9_y_net
    );

  register1: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x18,
      clk => clk_1_sg_x18,
      d(0) => logical10_y_net,
      en => "1",
      rst => "0",
      q(0) => we2_x0
    );

  register3: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x18,
      clk => clk_1_sg_x18,
      d(0) => logical6_y_net,
      en => "1",
      rst => "0",
      q(0) => we1_x0
    );

  register5: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x18,
      clk => clk_1_sg_x18,
      d(0) => logical_y_net,
      en => "1",
      rst => "0",
      q(0) => we0_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat/FIFO_RE"

entity fifo_re_entity_90a38e1a93 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en: in std_logic; 
    reset: in std_logic; 
    re: out std_logic_vector(2 downto 0)
  );
end fifo_re_entity_90a38e1a93;

architecture structural of fifo_re_entity_90a38e1a93 is
  signal ce_1_sg_x19: std_logic;
  signal clk_1_sg_x19: std_logic;
  signal concat_y_net_x0: std_logic_vector(2 downto 0);
  signal delay1_q_net_x1: std_logic;
  signal delay_q_net_x1: std_logic;
  signal we0_x0: std_logic;
  signal we1_x0: std_logic;
  signal we2_x0: std_logic;

begin
  ce_1_sg_x19 <= ce_1;
  clk_1_sg_x19 <= clk_1;
  delay_q_net_x1 <= en;
  delay1_q_net_x1 <= reset;
  re <= concat_y_net_x0;

  concat: entity work.concat_09e13b86e0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0(0) => we2_x0,
      in1(0) => we1_x0,
      in2(0) => we0_x0,
      y => concat_y_net_x0
    );

  fifodec_1c2b4a92ab: entity work.fifodec_entity_1c2b4a92ab
    port map (
      ce_1 => ce_1_sg_x19,
      clk_1 => clk_1_sg_x19,
      en => delay_q_net_x1,
      reset_x0 => delay1_q_net_x1,
      en0 => we0_x0,
      en1 => we1_x0,
      en2 => we2_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/DStat"

entity dstat_entity_8b1939ae91 is
  port (
    ce_1: in std_logic; 
    chen: in std_logic_vector(2 downto 0); 
    clk_1: in std_logic; 
    dsi0: in std_logic_vector(2 downto 0); 
    dsi1: in std_logic_vector(2 downto 0); 
    dsi2: in std_logic_vector(2 downto 0); 
    eos: in std_logic; 
    reset: in std_logic; 
    dv0: out std_logic; 
    pa_reset: out std_logic; 
    re: out std_logic_vector(2 downto 0)
  );
end dstat_entity_8b1939ae91;

architecture structural of dstat_entity_8b1939ae91 is
  signal ce_1_sg_x20: std_logic;
  signal clk_1_sg_x20: std_logic;
  signal concat_y_net_x1: std_logic_vector(2 downto 0);
  signal delay1_q_net_x2: std_logic;
  signal delay4_q_net_x7: std_logic_vector(2 downto 0);
  signal delay_q_net_x2: std_logic;
  signal ds_bot3_y_net_x6: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x7: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x8: std_logic_vector(2 downto 0);
  signal eos_x3: std_logic;
  signal inverter2_op_net: std_logic;
  signal inverter_op_net: std_logic;
  signal logical1_y_net: std_logic;
  signal logical2_y_net: std_logic;
  signal logical2_y_net_x3: std_logic;
  signal logical2_y_net_x4: std_logic;
  signal logical2_y_net_x5: std_logic;
  signal logical3_y_net: std_logic;
  signal logical4_y_net: std_logic;
  signal logical5_y_net: std_logic;
  signal logical9_y_net: std_logic;
  signal logical_y_net: std_logic;
  signal logical_y_net_x2: std_logic;

begin
  ce_1_sg_x20 <= ce_1;
  delay4_q_net_x7 <= chen;
  clk_1_sg_x20 <= clk_1;
  ds_bot3_y_net_x8 <= dsi0;
  ds_bot3_y_net_x6 <= dsi1;
  ds_bot3_y_net_x7 <= dsi2;
  eos_x3 <= eos;
  logical_y_net_x2 <= reset;
  dv0 <= delay_q_net_x2;
  pa_reset <= delay1_q_net_x2;
  re <= concat_y_net_x1;

  delay: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 1
    )
    port map (
      ce => ce_1_sg_x20,
      clk => clk_1_sg_x20,
      d(0) => logical3_y_net,
      en => '1',
      q(0) => delay_q_net_x2
    );

  delay1: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 1
    )
    port map (
      ce => ce_1_sg_x20,
      clk => clk_1_sg_x20,
      d(0) => logical1_y_net,
      en => '1',
      q(0) => delay1_q_net_x2
    );

  ds_redist_ad0f060043: entity work.ds_redist_entity_ad0f060043
    port map (
      ce_1 => ce_1_sg_x20,
      chen => delay4_q_net_x7,
      clk_1 => clk_1_sg_x20,
      dsi0 => ds_bot3_y_net_x8,
      dsi1 => ds_bot3_y_net_x6,
      dsi2 => ds_bot3_y_net_x7,
      allack => logical2_y_net_x5,
      allready => logical2_y_net_x3,
      allready2 => logical2_y_net_x4
    );

  fifo_re_90a38e1a93: entity work.fifo_re_entity_90a38e1a93
    port map (
      ce_1 => ce_1_sg_x20,
      clk_1 => clk_1_sg_x20,
      en => delay_q_net_x2,
      reset => delay1_q_net_x2,
      re => concat_y_net_x1
    );

  inverter: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x20,
      clk => clk_1_sg_x20,
      clr => '0',
      ip(0) => delay_q_net_x2,
      op(0) => inverter_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x20,
      clk => clk_1_sg_x20,
      clr => '0',
      ip(0) => logical2_y_net_x5,
      op(0) => inverter2_op_net
    );

  logical: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter_op_net,
      d1(0) => logical2_y_net_x3,
      y(0) => logical_y_net
    );

  logical1: entity work.logical_6cb8f0ce02
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical_y_net_x2,
      d1(0) => eos_x3,
      d2(0) => logical2_y_net,
      y(0) => logical1_y_net
    );

  logical2: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net,
      d1(0) => delay1_q_net_x2,
      y(0) => logical2_y_net
    );

  logical3: entity work.logical_dfe2dded7f
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical9_y_net,
      d1(0) => logical5_y_net,
      y(0) => logical3_y_net
    );

  logical4: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical2_y_net_x3,
      d1(0) => logical2_y_net_x4,
      y(0) => logical4_y_net
    );

  logical5: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical1_y_net,
      d1(0) => delay1_q_net_x2,
      y(0) => logical5_y_net
    );

  logical9: entity work.logical_dfe2dded7f
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical_y_net,
      d1(0) => logical4_y_net,
      y(0) => logical9_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/Decode"

entity decode_entity_89b3e3d4d0 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    in_x0: in std_logic_vector(7 downto 0); 
    chen: out std_logic_vector(2 downto 0); 
    ssp_reset: out std_logic; 
    trigconfig: out std_logic_vector(3 downto 0)
  );
end decode_entity_89b3e3d4d0;

architecture structural of decode_entity_89b3e3d4d0 is
  signal ce_1_sg_x21: std_logic;
  signal chenblslice_y_net: std_logic_vector(2 downto 0);
  signal clk_1_sg_x21: std_logic;
  signal constant_op_net: std_logic_vector(2 downto 0);
  signal delay2_q_net: std_logic;
  signal delay3_q_net_x0: std_logic_vector(3 downto 0);
  signal delay4_q_net_x8: std_logic_vector(2 downto 0);
  signal from_register_data_out_net_x0: std_logic_vector(7 downto 0);
  signal logical_y_net_x3: std_logic;
  signal relational_op_net: std_logic;
  signal resetslice_y_net: std_logic;
  signal trigconfigslice_y_net: std_logic_vector(3 downto 0);

begin
  ce_1_sg_x21 <= ce_1;
  clk_1_sg_x21 <= clk_1;
  from_register_data_out_net_x0 <= in_x0;
  chen <= delay4_q_net_x8;
  ssp_reset <= logical_y_net_x3;
  trigconfig <= delay3_q_net_x0;

  chenblslice: entity work.xlslice
    generic map (
      new_lsb => 5,
      new_msb => 7,
      x_width => 8,
      y_width => 3
    )
    port map (
      x => from_register_data_out_net_x0,
      y => chenblslice_y_net
    );

  constant_x0: entity work.constant_822933f89b
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant_op_net
    );

  delay2: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 1
    )
    port map (
      ce => ce_1_sg_x21,
      clk => clk_1_sg_x21,
      d(0) => resetslice_y_net,
      en => '1',
      q(0) => delay2_q_net
    );

  delay3: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 4
    )
    port map (
      ce => ce_1_sg_x21,
      clk => clk_1_sg_x21,
      d => trigconfigslice_y_net,
      en => '1',
      q => delay3_q_net_x0
    );

  delay4: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 3
    )
    port map (
      ce => ce_1_sg_x21,
      clk => clk_1_sg_x21,
      d => chenblslice_y_net,
      en => delay2_q_net,
      q => delay4_q_net_x8
    );

  logical: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => relational_op_net,
      d1(0) => delay2_q_net,
      y(0) => logical_y_net_x3
    );

  relational: entity work.relational_8fc7f5539b
    port map (
      a => delay4_q_net_x8,
      b => constant_op_net,
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => relational_op_net
    );

  resetslice: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 0,
      x_width => 8,
      y_width => 1
    )
    port map (
      x => from_register_data_out_net_x0,
      y(0) => resetslice_y_net
    );

  trigconfigslice: entity work.xlslice
    generic map (
      new_lsb => 1,
      new_msb => 4,
      x_width => 8,
      y_width => 4
    )
    port map (
      x => from_register_data_out_net_x0,
      y => trigconfigslice_y_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/EDK Processor"

entity edk_processor_entity_63b432f549 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    from_fifo: in std_logic_vector(31 downto 0); 
    from_fifo_x0: in std_logic; 
    from_fifo_x1: in std_logic; 
    plb_abus: in std_logic_vector(31 downto 0); 
    plb_pavalid: in std_logic; 
    plb_rnw: in std_logic; 
    plb_wrdbus: in std_logic_vector(31 downto 0); 
    sg_plb_addrpref: in std_logic_vector(19 downto 0); 
    splb_rst: in std_logic; 
    constant5_x0: out std_logic; 
    plb_decode_x0: out std_logic; 
    plb_decode_x1: out std_logic; 
    plb_decode_x2: out std_logic; 
    plb_decode_x3: out std_logic; 
    plb_decode_x4: out std_logic_vector(31 downto 0); 
    plb_memmap_x0: out std_logic_vector(7 downto 0); 
    plb_memmap_x1: out std_logic; 
    plb_memmap_x10: out std_logic; 
    plb_memmap_x2: out std_logic_vector(7 downto 0); 
    plb_memmap_x3: out std_logic; 
    plb_memmap_x4: out std_logic_vector(11 downto 0); 
    plb_memmap_x5: out std_logic; 
    plb_memmap_x6: out std_logic_vector(15 downto 0); 
    plb_memmap_x7: out std_logic; 
    plb_memmap_x8: out std_logic_vector(13 downto 0); 
    plb_memmap_x9: out std_logic
  );
end edk_processor_entity_63b432f549;

architecture structural of edk_processor_entity_63b432f549 is
  signal bankaddr: std_logic_vector(1 downto 0);
  signal ce_1_sg_x22: std_logic;
  signal clk_1_sg_x22: std_logic;
  signal control_din_x0: std_logic_vector(7 downto 0);
  signal control_en_x0: std_logic;
  signal linearaddr: std_logic_vector(7 downto 0);
  signal navg_din_x0: std_logic_vector(7 downto 0);
  signal navg_en_x0: std_logic;
  signal ncoadd_din_x0: std_logic_vector(13 downto 0);
  signal ncoadd_en_x0: std_logic;
  signal netsamples_din_x0: std_logic_vector(11 downto 0);
  signal netsamples_en_x0: std_logic;
  signal plb_abus_net_x0: std_logic_vector(31 downto 0);
  signal plb_pavalid_net_x0: std_logic;
  signal plb_rnw_net_x0: std_logic;
  signal plb_wrdbus_net_x0: std_logic_vector(31 downto 0);
  signal rddata: std_logic_vector(31 downto 0);
  signal rnwreg: std_logic;
  signal sg_plb_addrpref_net_x0: std_logic_vector(19 downto 0);
  signal sl_addrack_x0: std_logic;
  signal sl_rdcomp_x0: std_logic;
  signal sl_rddack_x0: std_logic;
  signal sl_rddbus_x0: std_logic_vector(31 downto 0);
  signal sl_wait_x0: std_logic;
  signal sl_wrdack_x0: std_logic;
  signal splb_rst_net_x0: std_logic;
  signal srcsignal_dout_x0: std_logic_vector(31 downto 0);
  signal srcsignal_empty_x0: std_logic;
  signal srcsignal_pfull_x0: std_logic;
  signal srcsignal_re_x0: std_logic;
  signal triggerlevel_din_x0: std_logic_vector(15 downto 0);
  signal triggerlevel_en_x0: std_logic;
  signal wrdbusreg: std_logic_vector(31 downto 0);

begin
  ce_1_sg_x22 <= ce_1;
  clk_1_sg_x22 <= clk_1;
  srcsignal_dout_x0 <= from_fifo;
  srcsignal_pfull_x0 <= from_fifo_x0;
  srcsignal_empty_x0 <= from_fifo_x1;
  plb_abus_net_x0 <= plb_abus;
  plb_pavalid_net_x0 <= plb_pavalid;
  plb_rnw_net_x0 <= plb_rnw;
  plb_wrdbus_net_x0 <= plb_wrdbus;
  sg_plb_addrpref_net_x0 <= sg_plb_addrpref;
  splb_rst_net_x0 <= splb_rst;
  constant5_x0 <= sl_wait_x0;
  plb_decode_x0 <= sl_addrack_x0;
  plb_decode_x1 <= sl_rdcomp_x0;
  plb_decode_x2 <= sl_wrdack_x0;
  plb_decode_x3 <= sl_rddack_x0;
  plb_decode_x4 <= sl_rddbus_x0;
  plb_memmap_x0 <= control_din_x0;
  plb_memmap_x1 <= control_en_x0;
  plb_memmap_x10 <= srcsignal_re_x0;
  plb_memmap_x2 <= navg_din_x0;
  plb_memmap_x3 <= navg_en_x0;
  plb_memmap_x4 <= netsamples_din_x0;
  plb_memmap_x5 <= netsamples_en_x0;
  plb_memmap_x6 <= triggerlevel_din_x0;
  plb_memmap_x7 <= triggerlevel_en_x0;
  plb_memmap_x8 <= ncoadd_din_x0;
  plb_memmap_x9 <= ncoadd_en_x0;

  constant5: entity work.constant_963ed6358a
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => sl_wait_x0
    );

  plb_decode: entity work.mcode_block_f4d0462e0e
    port map (
      addrpref => sg_plb_addrpref_net_x0,
      ce => ce_1_sg_x22,
      clk => clk_1_sg_x22,
      clr => '0',
      plbabus => plb_abus_net_x0,
      plbpavalid(0) => plb_pavalid_net_x0,
      plbrnw(0) => plb_rnw_net_x0,
      plbrst(0) => splb_rst_net_x0,
      plbwrdbus => plb_wrdbus_net_x0,
      rddata => rddata,
      addrack(0) => sl_addrack_x0,
      bankaddr => bankaddr,
      linearaddr => linearaddr,
      rdcomp(0) => sl_rdcomp_x0,
      rddack(0) => sl_rddack_x0,
      rddbus => sl_rddbus_x0,
      rnwreg(0) => rnwreg,
      wrdack(0) => sl_wrdack_x0,
      wrdbusreg => wrdbusreg
    );

  plb_memmap: entity work.mcode_block_3a303afee5
    port map (
      addrack(0) => sl_addrack_x0,
      bankaddr => bankaddr,
      ce => ce_1_sg_x22,
      clk => clk_1_sg_x22,
      clr => '0',
      linearaddr => linearaddr,
      rnwreg(0) => rnwreg,
      sm_srcsignal => srcsignal_dout_x0,
      sm_srcsignal_empty(0) => srcsignal_empty_x0,
      sm_srcsignal_pfull(0) => srcsignal_pfull_x0,
      wrdbus => wrdbusreg,
      read_bank_out => rddata,
      sm_control_din => control_din_x0,
      sm_control_en(0) => control_en_x0,
      sm_navg_din => navg_din_x0,
      sm_navg_en(0) => navg_en_x0,
      sm_ncoadd_din => ncoadd_din_x0,
      sm_ncoadd_en(0) => ncoadd_en_x0,
      sm_netsamples_din => netsamples_din_x0,
      sm_netsamples_en(0) => netsamples_en_x0,
      sm_srcsignal_re(0) => srcsignal_re_x0,
      sm_triggerlevel_din => triggerlevel_din_x0,
      sm_triggerlevel_en(0) => triggerlevel_en_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/PAOutBusDe1"

entity paoutbusde1_entity_549c244dcc is
  port (
    pa_out: in std_logic_vector(28 downto 0); 
    dstat: out std_logic_vector(2 downto 0); 
    signal_x0: out std_logic_vector(25 downto 0)
  );
end paoutbusde1_entity_549c244dcc;

architecture structural of paoutbusde1_entity_549c244dcc is
  signal ds_bot3_y_net_x7: std_logic_vector(2 downto 0);
  signal pa_1_out_net_x0: std_logic_vector(28 downto 0);
  signal sig_top26_y_net_x0: std_logic_vector(25 downto 0);

begin
  pa_1_out_net_x0 <= pa_out;
  dstat <= ds_bot3_y_net_x7;
  signal_x0 <= sig_top26_y_net_x0;

  ds_bot3: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 2,
      x_width => 29,
      y_width => 3
    )
    port map (
      x => pa_1_out_net_x0,
      y => ds_bot3_y_net_x7
    );

  sig_top26: entity work.xlslice
    generic map (
      new_lsb => 3,
      new_msb => 28,
      x_width => 29,
      y_width => 26
    )
    port map (
      x => pa_1_out_net_x0,
      y => sig_top26_y_net_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/SampleCount"

entity samplecount_entity_83d95acbaa is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    count: in std_logic_vector(11 downto 0); 
    dv0: in std_logic; 
    reset: in std_logic; 
    bos: out std_logic; 
    dv: out std_logic; 
    dv0q: out std_logic; 
    eos: out std_logic; 
    ns: out std_logic_vector(11 downto 0); 
    scannum: out std_logic_vector(31 downto 0)
  );
end samplecount_entity_83d95acbaa;

architecture structural of samplecount_entity_83d95acbaa is
  signal ce_1_sg_x23: std_logic;
  signal clk_1_sg_x23: std_logic;
  signal constant2_op_net: std_logic_vector(10 downto 0);
  signal counter1_op_net: std_logic_vector(11 downto 0);
  signal delay1_q_net_x3: std_logic;
  signal delay1_q_net_x4: std_logic;
  signal delay_q_net_x3: std_logic;
  signal dv0q_x2: std_logic;
  signal eos_x4: std_logic;
  signal from_register1_data_out_net_x0: std_logic_vector(11 downto 0);
  signal inverter1_op_net: std_logic;
  signal inverter2_op_net: std_logic;
  signal inverter3_op_net: std_logic;
  signal logical1_y_net: std_logic;
  signal logical4_y_net: std_logic;
  signal logical5_y_net: std_logic;
  signal logical6_y_net_x2: std_logic;
  signal register_q_net_x0: std_logic_vector(11 downto 0);
  signal rst: std_logic;
  signal scannumber_op_net_x0: std_logic_vector(31 downto 0);
  signal tc: std_logic;

begin
  ce_1_sg_x23 <= ce_1;
  clk_1_sg_x23 <= clk_1;
  from_register1_data_out_net_x0 <= count;
  delay_q_net_x3 <= dv0;
  delay1_q_net_x3 <= reset;
  bos <= logical6_y_net_x2;
  dv <= delay1_q_net_x4;
  dv0q <= dv0q_x2;
  eos <= eos_x4;
  ns <= register_q_net_x0;
  scannum <= scannumber_op_net_x0;

  constant2: entity work.constant_a3923dd146
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant2_op_net
    );

  counter1: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_fb550ac1b34e525f",
      op_arith => xlUnsigned,
      op_width => 12
    )
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      clr => '0',
      din => register_q_net_x0,
      en(0) => logical1_y_net,
      load(0) => delay1_q_net_x3,
      rst => "0",
      op => counter1_op_net
    );

  delay1: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 1
    )
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      d(0) => dv0q_x2,
      en => '1',
      q(0) => delay1_q_net_x4
    );

  delay2: entity work.xldelay
    generic map (
      latency => 1,
      reg_retiming => 0,
      width => 1
    )
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      d(0) => logical5_y_net,
      en => '1',
      q(0) => rst
    );

  inverter1: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      clr => '0',
      ip(0) => dv0q_x2,
      op(0) => inverter1_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      clr => '0',
      ip(0) => delay1_q_net_x3,
      op(0) => inverter2_op_net
    );

  inverter3: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      clr => '0',
      ip(0) => tc,
      op(0) => inverter3_op_net
    );

  logical1: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay1_q_net_x3,
      d1(0) => dv0q_x2,
      y(0) => logical1_y_net
    );

  logical2: entity work.logical_954ee29728
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net,
      d1(0) => delay_q_net_x3,
      d2(0) => inverter3_op_net,
      y(0) => dv0q_x2
    );

  logical3: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => delay1_q_net_x4,
      d1(0) => tc,
      y(0) => eos_x4
    );

  logical4: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => rst,
      d1(0) => inverter1_op_net,
      y(0) => logical4_y_net
    );

  logical5: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical4_y_net,
      d1(0) => delay1_q_net_x3,
      y(0) => logical5_y_net
    );

  logical6: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => dv0q_x2,
      d1(0) => rst,
      y(0) => logical6_y_net_x2
    );

  register_x0: entity work.xlregister
    generic map (
      d_width => 12,
      init_value => b"000000000000"
    )
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      d => from_register1_data_out_net_x0,
      en(0) => delay1_q_net_x3,
      rst => "0",
      q => register_q_net_x0
    );

  relational: entity work.relational_18694f5198
    port map (
      a => counter1_op_net,
      b => constant2_op_net,
      ce => '0',
      clk => '0',
      clr => '0',
      op(0) => tc
    );

  scannumber: entity work.xlcounter_free
    generic map (
      core_name0 => "cntr_11_0_1eabeaef14bdfc76",
      op_arith => xlUnsigned,
      op_width => 32
    )
    port map (
      ce => ce_1_sg_x23,
      clk => clk_1_sg_x23,
      clr => '0',
      en(0) => logical6_y_net_x2,
      rst => "0",
      op => scannumber_op_net_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/ShiftOut/EndOfSeqStatus"

entity endofseqstatus_entity_33f1782736 is
  port (
    ce_1: in std_logic; 
    chen: in std_logic_vector(2 downto 0); 
    clk_1: in std_logic; 
    ovf: in std_logic_vector(8 downto 0); 
    ovfen: in std_logic; 
    trigconfig: in std_logic_vector(3 downto 0); 
    eoseq: out std_logic_vector(31 downto 0)
  );
end endofseqstatus_entity_33f1782736;

architecture structural of endofseqstatus_entity_33f1782736 is
  signal adoor_6_8_y_net: std_logic_vector(2 downto 0);
  signal caovf_0_2_y_net: std_logic_vector(2 downto 0);
  signal ce_1_sg_x24: std_logic;
  signal clk_1_sg_x24: std_logic;
  signal concat4_y_net: std_logic_vector(8 downto 0);
  signal concat5_y_net: std_logic_vector(15 downto 0);
  signal convert5_dout_net_x0: std_logic_vector(31 downto 0);
  signal delay3_q_net_x1: std_logic_vector(3 downto 0);
  signal delay4_q_net_x9: std_logic_vector(2 downto 0);
  signal logical1_y_net: std_logic_vector(2 downto 0);
  signal logical2_y_net: std_logic_vector(2 downto 0);
  signal logical6_y_net_x0: std_logic;
  signal logical_y_net: std_logic_vector(2 downto 0);
  signal paovf_3_5_y_net: std_logic_vector(2 downto 0);
  signal register1_q_net: std_logic_vector(8 downto 0);
  signal register1_q_net_x1: std_logic_vector(8 downto 0);

begin
  ce_1_sg_x24 <= ce_1;
  delay4_q_net_x9 <= chen;
  clk_1_sg_x24 <= clk_1;
  register1_q_net_x1 <= ovf;
  logical6_y_net_x0 <= ovfen;
  delay3_q_net_x1 <= trigconfig;
  eoseq <= convert5_dout_net_x0;

  adoor_6_8: entity work.xlslice
    generic map (
      new_lsb => 6,
      new_msb => 8,
      x_width => 9,
      y_width => 3
    )
    port map (
      x => register1_q_net_x1,
      y => adoor_6_8_y_net
    );

  caovf_0_2: entity work.xlslice
    generic map (
      new_lsb => 0,
      new_msb => 2,
      x_width => 9,
      y_width => 3
    )
    port map (
      x => register1_q_net_x1,
      y => caovf_0_2_y_net
    );

  concat4: entity work.concat_847b94e62c
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => logical2_y_net,
      in1 => logical_y_net,
      in2 => logical1_y_net,
      y => concat4_y_net
    );

  concat5: entity work.concat_6f6bdffe9c
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => delay3_q_net_x1,
      in1 => delay4_q_net_x9,
      in2 => register1_q_net,
      y => concat5_y_net
    );

  convert5: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 16,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 32,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x24,
      clk => clk_1_sg_x24,
      clr => '0',
      din => concat5_y_net,
      en => "1",
      dout => convert5_dout_net_x0
    );

  logical: entity work.logical_defe35756e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => delay4_q_net_x9,
      d1 => paovf_3_5_y_net,
      y => logical_y_net
    );

  logical1: entity work.logical_defe35756e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => delay4_q_net_x9,
      d1 => caovf_0_2_y_net,
      y => logical1_y_net
    );

  logical2: entity work.logical_defe35756e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => delay4_q_net_x9,
      d1 => adoor_6_8_y_net,
      y => logical2_y_net
    );

  paovf_3_5: entity work.xlslice
    generic map (
      new_lsb => 3,
      new_msb => 5,
      x_width => 9,
      y_width => 3
    )
    port map (
      x => register1_q_net_x1,
      y => paovf_3_5_y_net
    );

  register1: entity work.xlregister
    generic map (
      d_width => 9,
      init_value => b"000000000"
    )
    port map (
      ce => ce_1_sg_x24,
      clk => clk_1_sg_x24,
      d => concat4_y_net,
      en(0) => logical6_y_net_x0,
      rst => "0",
      q => register1_q_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/ShiftOut/NCh"

entity nch_entity_fbe090b5e7 is
  port (
    ce_1: in std_logic; 
    chen: in std_logic_vector(2 downto 0); 
    clk_1: in std_logic; 
    nch: out std_logic_vector(15 downto 0)
  );
end nch_entity_fbe090b5e7;

architecture structural of nch_entity_fbe090b5e7 is
  signal addsub_s_net_x0: std_logic_vector(15 downto 0);
  signal ce_1_sg_x25: std_logic;
  signal chenblbit0_y_net_x0: std_logic;
  signal chenblbit1_y_net_x0: std_logic;
  signal chenblbit2_y_net_x0: std_logic;
  signal clk_1_sg_x25: std_logic;
  signal convert1_dout_net: std_logic;
  signal convert2_dout_net: std_logic;
  signal convert_dout_net: std_logic;
  signal delay4_q_net_x11: std_logic_vector(2 downto 0);

begin
  ce_1_sg_x25 <= ce_1;
  delay4_q_net_x11 <= chen;
  clk_1_sg_x25 <= clk_1;
  nch <= addsub_s_net_x0;

  addsub: entity work.addsub_0fca89c88b
    port map (
      a(0) => convert_dout_net,
      b(0) => convert1_dout_net,
      c_in(0) => convert2_dout_net,
      ce => ce_1_sg_x25,
      clk => clk_1_sg_x25,
      clr => '0',
      s => addsub_s_net_x0
    );

  chendec_b2e62a974a: entity work.chendec_entity_d981a39e2e
    port map (
      chen => delay4_q_net_x11,
      ce0 => chenblbit0_y_net_x0,
      ce1 => chenblbit1_y_net_x0,
      ce2 => chenblbit2_y_net_x0
    );

  convert: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 1,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 1,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x25,
      clk => clk_1_sg_x25,
      clr => '0',
      din(0) => chenblbit0_y_net_x0,
      en => "1",
      dout(0) => convert_dout_net
    );

  convert1: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 1,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 1,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x25,
      clk => clk_1_sg_x25,
      clr => '0',
      din(0) => chenblbit1_y_net_x0,
      en => "1",
      dout(0) => convert1_dout_net
    );

  convert2: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 1,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 1,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x25,
      clk => clk_1_sg_x25,
      clr => '0',
      din(0) => chenblbit2_y_net_x0,
      en => "1",
      dout(0) => convert2_dout_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/ShiftOut/NSkips"

entity nskips_entity_f939db968d is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    en: in std_logic; 
    nskl: in std_logic_vector(15 downto 0); 
    nskp: in std_logic_vector(15 downto 0); 
    nskips: out std_logic_vector(31 downto 0)
  );
end nskips_entity_f939db968d;

architecture structural of nskips_entity_f939db968d is
  signal ce_1_sg_x26: std_logic;
  signal clk_1_sg_x26: std_logic;
  signal concat3_y_net: std_logic_vector(31 downto 0);
  signal convert3_dout_net: std_logic_vector(15 downto 0);
  signal convert4_dout_net: std_logic_vector(15 downto 0);
  signal logical4_y_net_x0: std_logic;
  signal nls_x2: std_logic_vector(15 downto 0);
  signal nps_x2: std_logic_vector(15 downto 0);
  signal register_q_net_x0: std_logic_vector(31 downto 0);

begin
  ce_1_sg_x26 <= ce_1;
  clk_1_sg_x26 <= clk_1;
  logical4_y_net_x0 <= en;
  nls_x2 <= nskl;
  nps_x2 <= nskp;
  nskips <= register_q_net_x0;

  concat3: entity work.concat_a369e00c6b
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => convert3_dout_net,
      in1 => convert4_dout_net,
      y => concat3_y_net
    );

  convert3: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 16,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 16,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x26,
      clk => clk_1_sg_x26,
      clr => '0',
      din => nps_x2,
      en => "1",
      dout => convert3_dout_net
    );

  convert4: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 16,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 16,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x26,
      clk => clk_1_sg_x26,
      clr => '0',
      din => nls_x2,
      en => "1",
      dout => convert4_dout_net
    );

  register_x0: entity work.xlregister
    generic map (
      d_width => 32,
      init_value => b"00000000000000000000000000000000"
    )
    port map (
      ce => ce_1_sg_x26,
      clk => clk_1_sg_x26,
      d => concat3_y_net,
      en(0) => logical4_y_net_x0,
      rst => "0",
      q => register_q_net_x0
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/ShiftOut/StateRSE"

entity staterse_entity_3d59131223 is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    eos: in std_logic; 
    reset: in std_logic; 
    scan: in std_logic; 
    ovfen: out std_logic; 
    rdy: out std_logic; 
    s_x0: out std_logic; 
    snen: out std_logic
  );
end staterse_entity_3d59131223;

architecture structural of staterse_entity_3d59131223 is
  signal ce_1_sg_x27: std_logic;
  signal clk_1_sg_x27: std_logic;
  signal eos_x5: std_logic;
  signal inverter2_op_net: std_logic;
  signal inverter3_op_net: std_logic;
  signal inverter_op_net: std_logic;
  signal logical10_y_net: std_logic;
  signal logical12_y_net: std_logic;
  signal logical14_y_net: std_logic;
  signal logical2_y_net: std_logic;
  signal logical3_y_net: std_logic;
  signal logical4_y_net_x1: std_logic;
  signal logical5_y_net: std_logic;
  signal logical6_y_net_x1: std_logic;
  signal logical7_y_net: std_logic;
  signal logical9_y_net: std_logic;
  signal logical_y_net: std_logic;
  signal logical_y_net_x4: std_logic;
  signal rdy_x2: std_logic;
  signal s_x1: std_logic;
  signal shstate_scan_net_x0: std_logic;
  signal stse: std_logic;

begin
  ce_1_sg_x27 <= ce_1;
  clk_1_sg_x27 <= clk_1;
  eos_x5 <= eos;
  logical_y_net_x4 <= reset;
  shstate_scan_net_x0 <= scan;
  ovfen <= logical6_y_net_x1;
  rdy <= rdy_x2;
  s_x0 <= s_x1;
  snen <= logical4_y_net_x1;

  inverter: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      clr => '0',
      ip(0) => eos_x5,
      op(0) => inverter_op_net
    );

  inverter2: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      clr => '0',
      ip(0) => logical_y_net_x4,
      op(0) => inverter2_op_net
    );

  inverter3: entity work.inverter_e5b38cca3b
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      clr => '0',
      ip(0) => shstate_scan_net_x0,
      op(0) => inverter3_op_net
    );

  logical: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter3_op_net,
      d1(0) => rdy_x2,
      y(0) => logical_y_net
    );

  logical10: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical6_y_net_x1,
      d1(0) => logical9_y_net,
      y(0) => logical10_y_net
    );

  logical12: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => stse,
      d1(0) => inverter3_op_net,
      y(0) => logical12_y_net
    );

  logical14: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net,
      d1(0) => logical10_y_net,
      y(0) => logical14_y_net
    );

  logical2: entity work.logical_6cb8f0ce02
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical12_y_net,
      d1(0) => logical_y_net,
      d2(0) => logical_y_net_x4,
      y(0) => logical2_y_net
    );

  logical3: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter_op_net,
      d1(0) => s_x1,
      y(0) => logical3_y_net
    );

  logical4: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => rdy_x2,
      d1(0) => shstate_scan_net_x0,
      y(0) => logical4_y_net_x1
    );

  logical5: entity work.logical_aacf6e1b0e
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => logical4_y_net_x1,
      d1(0) => logical3_y_net,
      y(0) => logical5_y_net
    );

  logical6: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => s_x1,
      d1(0) => eos_x5,
      y(0) => logical6_y_net_x1
    );

  logical7: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => inverter2_op_net,
      d1(0) => logical5_y_net,
      y(0) => logical7_y_net
    );

  logical9: entity work.logical_80f90b97d0
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0(0) => shstate_scan_net_x0,
      d1(0) => stse,
      y(0) => logical9_y_net
    );

  strdy: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      d(0) => logical2_y_net,
      en => "1",
      rst => "0",
      q(0) => rdy_x2
    );

  sts: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      d(0) => logical7_y_net,
      en => "1",
      rst => "0",
      q(0) => s_x1
    );

  stse_x0: entity work.xlregister
    generic map (
      d_width => 1,
      init_value => b"0"
    )
    port map (
      ce => ce_1_sg_x27,
      clk => clk_1_sg_x27,
      d(0) => logical14_y_net,
      en => "1",
      rst => "0",
      q(0) => stse
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan/ShiftOut"

entity shiftout_entity_5522e31b65 is
  port (
    ce_1: in std_logic; 
    chen: in std_logic_vector(2 downto 0); 
    clk_1: in std_logic; 
    empty: in std_logic; 
    eos: in std_logic; 
    full: in std_logic; 
    na: in std_logic_vector(7 downto 0); 
    nc: in std_logic_vector(13 downto 0); 
    ns: in std_logic_vector(11 downto 0); 
    nskl: in std_logic_vector(15 downto 0); 
    nskp: in std_logic_vector(15 downto 0); 
    ovf: in std_logic_vector(8 downto 0); 
    reset: in std_logic; 
    scannum: in std_logic_vector(31 downto 0); 
    sigin: in std_logic_vector(95 downto 0); 
    trigconfig: in std_logic_vector(3 downto 0); 
    data: out std_logic_vector(31 downto 0); 
    rdy: out std_logic; 
    re1: out std_logic; 
    we2: out std_logic
  );
end shiftout_entity_5522e31b65;

architecture structural of shiftout_entity_5522e31b65 is
  signal addsub_s_net_x0: std_logic_vector(15 downto 0);
  signal bitbasher_be_net_x0: std_logic_vector(31 downto 0);
  signal ce_1_sg_x29: std_logic;
  signal clk_1_sg_x29: std_logic;
  signal concat1_y_net: std_logic_vector(31 downto 0);
  signal concat2_y_net: std_logic_vector(31 downto 0);
  signal concat_y_net: std_logic_vector(31 downto 0);
  signal constant_op_net: std_logic_vector(31 downto 0);
  signal convert1_dout_net: std_logic_vector(15 downto 0);
  signal convert1_dout_net_x0: std_logic_vector(31 downto 0);
  signal convert2_dout_net: std_logic_vector(15 downto 0);
  signal convert2_dout_net_x0: std_logic_vector(31 downto 0);
  signal convert5_dout_net_x0: std_logic_vector(31 downto 0);
  signal convert_dout_net: std_logic_vector(15 downto 0);
  signal convert_dout_net_x0: std_logic_vector(31 downto 0);
  signal delay3_q_net_x2: std_logic_vector(3 downto 0);
  signal delay4_q_net_x12: std_logic_vector(2 downto 0);
  signal eos_x6: std_logic;
  signal fifo1_dout_net_x1: std_logic_vector(95 downto 0);
  signal fifo1_empty_net_x0: std_logic;
  signal from_register4_data_out_net_x0: std_logic_vector(7 downto 0);
  signal logical4_y_net_x1: std_logic;
  signal logical6_y_net_x1: std_logic;
  signal logical_y_net_x5: std_logic;
  signal mux_y_net: std_logic_vector(31 downto 0);
  signal nls_x3: std_logic_vector(15 downto 0);
  signal nps_x3: std_logic_vector(15 downto 0);
  signal nwhdr_op_net: std_logic_vector(15 downto 0);
  signal rdy_x3: std_logic;
  signal register1_q_net_x2: std_logic_vector(8 downto 0);
  signal register_q_net: std_logic_vector(31 downto 0);
  signal register_q_net_x2: std_logic_vector(31 downto 0);
  signal register_q_net_x3: std_logic_vector(13 downto 0);
  signal register_q_net_x4: std_logic_vector(11 downto 0);
  signal s_x1: std_logic;
  signal scannumber_op_net_x1: std_logic_vector(31 downto 0);
  signal shstate_muxsel_net: std_logic_vector(3 downto 0);
  signal shstate_req_net_x0: std_logic;
  signal shstate_scan_net_x0: std_logic;
  signal shstate_weq_net_x0: std_logic;
  signal to_fifo2_full_net_x0: std_logic;
  signal version_op_net: std_logic_vector(15 downto 0);

begin
  ce_1_sg_x29 <= ce_1;
  delay4_q_net_x12 <= chen;
  clk_1_sg_x29 <= clk_1;
  fifo1_empty_net_x0 <= empty;
  eos_x6 <= eos;
  to_fifo2_full_net_x0 <= full;
  from_register4_data_out_net_x0 <= na;
  register_q_net_x3 <= nc;
  register_q_net_x4 <= ns;
  nls_x3 <= nskl;
  nps_x3 <= nskp;
  register1_q_net_x2 <= ovf;
  logical_y_net_x5 <= reset;
  scannumber_op_net_x1 <= scannum;
  fifo1_dout_net_x1 <= sigin;
  delay3_q_net_x2 <= trigconfig;
  data <= bitbasher_be_net_x0;
  rdy <= rdy_x3;
  re1 <= shstate_req_net_x0;
  we2 <= shstate_weq_net_x0;

  bitbasher: entity work.bitbasher_ec0a00530d
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      le => mux_y_net,
      be => bitbasher_be_net_x0
    );

  concat: entity work.concat_a369e00c6b
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => version_op_net,
      in1 => nwhdr_op_net,
      y => concat_y_net
    );

  concat1: entity work.concat_a369e00c6b
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => convert_dout_net,
      in1 => addsub_s_net_x0,
      y => concat1_y_net
    );

  concat2: entity work.concat_a369e00c6b
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => convert1_dout_net,
      in1 => convert2_dout_net,
      y => concat2_y_net
    );

  constant_x0: entity work.constant_37567836aa
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant_op_net
    );

  convert: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 12,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 16,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x29,
      clk => clk_1_sg_x29,
      clr => '0',
      din => register_q_net_x4,
      en => "1",
      dout => convert_dout_net
    );

  convert1: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 8,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 16,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x29,
      clk => clk_1_sg_x29,
      clr => '0',
      din => from_register4_data_out_net_x0,
      en => "1",
      dout => convert1_dout_net
    );

  convert2: entity work.xlconvert
    generic map (
      bool_conversion => 0,
      din_arith => 1,
      din_bin_pt => 0,
      din_width => 14,
      dout_arith => 1,
      dout_bin_pt => 0,
      dout_width => 16,
      latency => 0,
      overflow => xlWrap,
      quantization => xlTruncate
    )
    port map (
      ce => ce_1_sg_x29,
      clk => clk_1_sg_x29,
      clr => '0',
      din => register_q_net_x3,
      en => "1",
      dout => convert2_dout_net
    );

  endofseqstatus_33f1782736: entity work.endofseqstatus_entity_33f1782736
    port map (
      ce_1 => ce_1_sg_x29,
      chen => delay4_q_net_x12,
      clk_1 => clk_1_sg_x29,
      ovf => register1_q_net_x2,
      ovfen => logical6_y_net_x1,
      trigconfig => delay3_q_net_x2,
      eoseq => convert5_dout_net_x0
    );

  mux: entity work.mux_e68e4e3a85
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => concat_y_net,
      d1 => concat1_y_net,
      d2 => concat2_y_net,
      d3 => register_q_net_x2,
      d4 => register_q_net,
      d5 => constant_op_net,
      d6 => convert5_dout_net_x0,
      d7 => convert_dout_net_x0,
      d8 => convert1_dout_net_x0,
      d9 => convert2_dout_net_x0,
      sel => shstate_muxsel_net,
      y => mux_y_net
    );

  nch_fbe090b5e7: entity work.nch_entity_fbe090b5e7
    port map (
      ce_1 => ce_1_sg_x29,
      chen => delay4_q_net_x12,
      clk_1 => clk_1_sg_x29,
      nch => addsub_s_net_x0
    );

  nskips_f939db968d: entity work.nskips_entity_f939db968d
    port map (
      ce_1 => ce_1_sg_x29,
      clk_1 => clk_1_sg_x29,
      en => logical4_y_net_x1,
      nskl => nls_x3,
      nskp => nps_x3,
      nskips => register_q_net_x2
    );

  nwhdr: entity work.constant_711b303c09
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => nwhdr_op_net
    );

  register_x0: entity work.xlregister
    generic map (
      d_width => 32,
      init_value => b"00000000000000000000000000000000"
    )
    port map (
      ce => ce_1_sg_x29,
      clk => clk_1_sg_x29,
      d => scannumber_op_net_x1,
      en(0) => logical4_y_net_x1,
      rst => "0",
      q => register_q_net
    );

  shstate_x0: entity work.SHSTATE
    port map (
      ce => delay4_q_net_x12,
      empty => fifo1_empty_net_x0,
      full => to_fifo2_full_net_x0,
      reset => logical_y_net_x5,
      s => s_x1,
      sh_ce => ce_1_sg_x29,
      sh_clk => clk_1_sg_x29,
      muxsel => shstate_muxsel_net,
      req => shstate_req_net_x0,
      scan => shstate_scan_net_x0,
      weq => shstate_weq_net_x0
    );

  staterse_3d59131223: entity work.staterse_entity_3d59131223
    port map (
      ce_1 => ce_1_sg_x29,
      clk_1 => clk_1_sg_x29,
      eos => eos_x6,
      reset => logical_y_net_x5,
      scan => shstate_scan_net_x0,
      ovfen => logical6_y_net_x1,
      rdy => rdy_x3,
      s_x0 => s_x1,
      snen => logical4_y_net_x1
    );

  unconcat32_ff303fc542: entity work.unconcat32_entity_f6ea947e70
    port map (
      ce_1 => ce_1_sg_x29,
      clk_1 => clk_1_sg_x29,
      in32 => fifo1_dout_net_x1,
      out0 => convert_dout_net_x0,
      out1 => convert1_dout_net_x0,
      out2 => convert2_dout_net_x0
    );

  version: entity work.constant_9f5572ba51
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => version_op_net
    );

end structural;
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "ssp_ad_scan"

entity ssp_ad_scan is
  port (
    ce_1: in std_logic; 
    clk_1: in std_logic; 
    data_out: in std_logic_vector(7 downto 0); 
    data_out_x0: in std_logic_vector(11 downto 0); 
    data_out_x1: in std_logic_vector(15 downto 0); 
    data_out_x2: in std_logic_vector(13 downto 0); 
    data_out_x3: in std_logic_vector(7 downto 0); 
    data_out_x4: in std_logic_vector(31 downto 0); 
    empty: in std_logic; 
    full: in std_logic; 
    pa_0_out: in std_logic_vector(28 downto 0); 
    pa_1_out: in std_logic_vector(28 downto 0); 
    pa_2_out: in std_logic_vector(28 downto 0); 
    percent_full: in std_logic; 
    plb_abus: in std_logic_vector(31 downto 0); 
    plb_pavalid: in std_logic; 
    plb_rnw: in std_logic; 
    plb_wrdbus: in std_logic_vector(31 downto 0); 
    sg_plb_addrpref: in std_logic_vector(19 downto 0); 
    splb_rst: in std_logic; 
    data_in: out std_logic_vector(31 downto 0); 
    data_in_x0: out std_logic_vector(7 downto 0); 
    data_in_x1: out std_logic_vector(7 downto 0); 
    data_in_x2: out std_logic_vector(11 downto 0); 
    data_in_x3: out std_logic_vector(15 downto 0); 
    data_in_x4: out std_logic_vector(13 downto 0); 
    en: out std_logic; 
    en_x0: out std_logic; 
    en_x1: out std_logic; 
    en_x2: out std_logic; 
    en_x3: out std_logic; 
    navg: out std_logic_vector(7 downto 0); 
    pa_re: out std_logic_vector(2 downto 0); 
    pa_reset: out std_logic; 
    re: out std_logic; 
    rst: out std_logic; 
    sl_addrack: out std_logic; 
    sl_rdcomp: out std_logic; 
    sl_rddack: out std_logic; 
    sl_rddbus: out std_logic_vector(31 downto 0); 
    sl_wait: out std_logic; 
    sl_wrcomp: out std_logic; 
    sl_wrdack: out std_logic; 
    ssp_reset: out std_logic; 
    trigconfig: out std_logic_vector(3 downto 0); 
    triggerlevel: out std_logic_vector(15 downto 0); 
    we: out std_logic
  );
end ssp_ad_scan;

architecture structural of ssp_ad_scan is
  attribute core_generation_info: string;
  attribute core_generation_info of structural : architecture is "ssp_ad_scan,sysgen_core,{black_box_isim_used=1,clock_period=10.00000000,clocking=Clock_Enables,compilation=Export_as_a_pcore_to_EDK,sample_periods=1.00000000000,testbench=0,total_blocks=627,xilinx_adder_subtracter_block=4,xilinx_arithmetic_relational_operator_block=5,xilinx_bit_slice_extractor_block=57,xilinx_bitbasher_block=1,xilinx_black_box_block=2,xilinx_bus_concatenator_block=11,xilinx_bus_multiplexer_block=2,xilinx_constant_block_block=9,xilinx_counter_block=7,xilinx_delay_block=7,xilinx_edk_processor_block=1,xilinx_fifo_block_block=2,xilinx_gateway_in_block=9,xilinx_gateway_out_block=13,xilinx_inverter_block=28,xilinx_logical_block_block=89,xilinx_mcode_block_block=2,xilinx_register_block=14,xilinx_shared_memory_based_from_fifo_block=1,xilinx_shared_memory_based_from_register_block=5,xilinx_shared_memory_based_to_fifo_block=1,xilinx_shared_memory_based_to_register_block=5,xilinx_system_generator_block=1,xilinx_type_converter_block=21,}";

  signal ce_1_sg_x30: std_logic;
  signal clk_1_sg_x30: std_logic;
  signal concat1_y_net_x0: std_logic_vector(95 downto 0);
  signal concat_y_net: std_logic_vector(77 downto 0);
  signal concat_y_net_x2: std_logic_vector(8 downto 0);
  signal constant_op_net: std_logic_vector(95 downto 0);
  signal data_in_net: std_logic_vector(31 downto 0);
  signal data_in_x0_net: std_logic_vector(7 downto 0);
  signal data_in_x1_net: std_logic_vector(7 downto 0);
  signal data_in_x2_net: std_logic_vector(11 downto 0);
  signal data_in_x3_net: std_logic_vector(15 downto 0);
  signal data_in_x4_net: std_logic_vector(13 downto 0);
  signal data_out_net: std_logic_vector(7 downto 0);
  signal data_out_x0_net: std_logic_vector(11 downto 0);
  signal data_out_x2_net: std_logic_vector(13 downto 0);
  signal data_out_x4_net: std_logic_vector(31 downto 0);
  signal delay1_q_net_x4: std_logic;
  signal delay4_q_net_x12: std_logic_vector(2 downto 0);
  signal delay_q_net_x3: std_logic;
  signal ds_bot3_y_net_x7: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x8: std_logic_vector(2 downto 0);
  signal ds_bot3_y_net_x9: std_logic_vector(2 downto 0);
  signal dv0q_x2: std_logic;
  signal empty_net: std_logic;
  signal en_net: std_logic;
  signal en_x0_net: std_logic;
  signal en_x1_net: std_logic;
  signal en_x2_net: std_logic;
  signal en_x3_net: std_logic;
  signal eos_x6: std_logic;
  signal fifo0_dout_net: std_logic_vector(95 downto 0);
  signal fifo1_dout_net_x1: std_logic_vector(95 downto 0);
  signal fifo1_empty_net_x0: std_logic;
  signal from_register2_data_out_net: std_logic_vector(15 downto 0);
  signal from_register4_data_out_net_x1: std_logic_vector(7 downto 0);
  signal full_net: std_logic;
  signal logical14_y_net_x0: std_logic;
  signal logical6_y_net_x2: std_logic;
  signal logical6_y_net_x3: std_logic;
  signal logical7_y_net_x0: std_logic;
  signal logical_y_net_x6: std_logic;
  signal mux1_y_net_x1: std_logic_vector(95 downto 0);
  signal nls_x3: std_logic_vector(15 downto 0);
  signal nps_x3: std_logic_vector(15 downto 0);
  signal pa_0_out_net: std_logic_vector(28 downto 0);
  signal pa_1_out_net: std_logic_vector(28 downto 0);
  signal pa_2_out_net: std_logic_vector(28 downto 0);
  signal pa_re_net: std_logic_vector(2 downto 0);
  signal pa_reset_net: std_logic;
  signal percent_full_net: std_logic;
  signal plb_abus_net: std_logic_vector(31 downto 0);
  signal plb_pavalid_net: std_logic;
  signal plb_rnw_net: std_logic;
  signal plb_wrdbus_net: std_logic_vector(31 downto 0);
  signal rdy_x3: std_logic;
  signal re_net: std_logic;
  signal register1_q_net_x2: std_logic_vector(8 downto 0);
  signal register6_q_net_x0: std_logic;
  signal register_q_net_x1: std_logic_vector(77 downto 0);
  signal register_q_net_x3: std_logic_vector(13 downto 0);
  signal register_q_net_x4: std_logic_vector(11 downto 0);
  signal scannumber_op_net_x1: std_logic_vector(31 downto 0);
  signal sg_plb_addrpref_net: std_logic_vector(19 downto 0);
  signal shstate_req_net_x0: std_logic;
  signal sig_top26_y_net_x0: std_logic_vector(25 downto 0);
  signal sig_top26_y_net_x1: std_logic_vector(25 downto 0);
  signal sig_top26_y_net_x2: std_logic_vector(25 downto 0);
  signal sl_addrack_net: std_logic;
  signal sl_rdcomp_net: std_logic;
  signal sl_rddack_net: std_logic;
  signal sl_rddbus_net: std_logic_vector(31 downto 0);
  signal sl_wait_net: std_logic;
  signal sl_wrdack_x1: std_logic;
  signal splb_rst_net: std_logic;
  signal trigconfig_net: std_logic_vector(3 downto 0);
  signal we_net: std_logic;

begin
  ce_1_sg_x30 <= ce_1;
  clk_1_sg_x30 <= clk_1;
  data_out_net <= data_out;
  data_out_x0_net <= data_out_x0;
  from_register2_data_out_net <= data_out_x1;
  data_out_x2_net <= data_out_x2;
  from_register4_data_out_net_x1 <= data_out_x3;
  data_out_x4_net <= data_out_x4;
  empty_net <= empty;
  full_net <= full;
  pa_0_out_net <= pa_0_out;
  pa_1_out_net <= pa_1_out;
  pa_2_out_net <= pa_2_out;
  percent_full_net <= percent_full;
  plb_abus_net <= plb_abus;
  plb_pavalid_net <= plb_pavalid;
  plb_rnw_net <= plb_rnw;
  plb_wrdbus_net <= plb_wrdbus;
  sg_plb_addrpref_net <= sg_plb_addrpref;
  splb_rst_net <= splb_rst;
  data_in <= data_in_net;
  data_in_x0 <= data_in_x0_net;
  data_in_x1 <= data_in_x1_net;
  data_in_x2 <= data_in_x2_net;
  data_in_x3 <= data_in_x3_net;
  data_in_x4 <= data_in_x4_net;
  en <= en_net;
  en_x0 <= en_x0_net;
  en_x1 <= en_x1_net;
  en_x2 <= en_x2_net;
  en_x3 <= en_x3_net;
  navg <= from_register4_data_out_net_x1;
  pa_re <= pa_re_net;
  pa_reset <= pa_reset_net;
  re <= re_net;
  rst <= logical_y_net_x6;
  sl_addrack <= sl_addrack_net;
  sl_rdcomp <= sl_rdcomp_net;
  sl_rddack <= sl_rddack_net;
  sl_rddbus <= sl_rddbus_net;
  sl_wait <= sl_wait_net;
  sl_wrcomp <= sl_wrdack_x1;
  sl_wrdack <= sl_wrdack_x1;
  ssp_reset <= logical_y_net_x6;
  trigconfig <= trigconfig_net;
  triggerlevel <= from_register2_data_out_net;
  we <= we_net;

  coadd_2d9be86573: entity work.coadd_entity_2d9be86573
    port map (
      ce_1 => ce_1_sg_x30,
      clk_1 => clk_1_sg_x30,
      in24 => register_q_net_x1,
      in32 => mux1_y_net_x1,
      out32 => concat1_y_net_x0,
      ovf => concat_y_net_x2
    );

  coaddcount_0b1f7727cd: entity work.coaddcount_entity_0b1f7727cd
    port map (
      bos => logical6_y_net_x3,
      ce_1 => ce_1_sg_x30,
      clk_1 => clk_1_sg_x30,
      dv => delay1_q_net_x4,
      dv0q_x0 => dv0q_x2,
      empty => rdy_x3,
      eos => eos_x6,
      ncoaddin => data_out_x2_net,
      ovfin => concat_y_net_x2,
      reset => logical_y_net_x6,
      firstscan => register6_q_net_x0,
      ncoadd => register_q_net_x3,
      nskf => nps_x3,
      nskl => nls_x3,
      ovf => register1_q_net_x2,
      re0 => logical14_y_net_x0,
      we0 => logical6_y_net_x2,
      we1 => logical7_y_net_x0
    );

  concat: entity work.concat_955d2a4670
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      in0 => sig_top26_y_net_x2,
      in1 => sig_top26_y_net_x0,
      in2 => sig_top26_y_net_x1,
      y => concat_y_net
    );

  constant_x0: entity work.constant_124a45adb9
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      op => constant_op_net
    );

  decode_89b3e3d4d0: entity work.decode_entity_89b3e3d4d0
    port map (
      ce_1 => ce_1_sg_x30,
      clk_1 => clk_1_sg_x30,
      in_x0 => data_out_net,
      chen => delay4_q_net_x12,
      ssp_reset => logical_y_net_x6,
      trigconfig => trigconfig_net
    );

  dstat_8b1939ae91: entity work.dstat_entity_8b1939ae91
    port map (
      ce_1 => ce_1_sg_x30,
      chen => delay4_q_net_x12,
      clk_1 => clk_1_sg_x30,
      dsi0 => ds_bot3_y_net_x9,
      dsi1 => ds_bot3_y_net_x7,
      dsi2 => ds_bot3_y_net_x8,
      eos => eos_x6,
      reset => logical_y_net_x6,
      dv0 => delay_q_net_x3,
      pa_reset => pa_reset_net,
      re => pa_re_net
    );

  edk_processor_63b432f549: entity work.edk_processor_entity_63b432f549
    port map (
      ce_1 => ce_1_sg_x30,
      clk_1 => clk_1_sg_x30,
      from_fifo => data_out_x4_net,
      from_fifo_x0 => percent_full_net,
      from_fifo_x1 => empty_net,
      plb_abus => plb_abus_net,
      plb_pavalid => plb_pavalid_net,
      plb_rnw => plb_rnw_net,
      plb_wrdbus => plb_wrdbus_net,
      sg_plb_addrpref => sg_plb_addrpref_net,
      splb_rst => splb_rst_net,
      constant5_x0 => sl_wait_net,
      plb_decode_x0 => sl_addrack_net,
      plb_decode_x1 => sl_rdcomp_net,
      plb_decode_x2 => sl_wrdack_x1,
      plb_decode_x3 => sl_rddack_net,
      plb_decode_x4 => sl_rddbus_net,
      plb_memmap_x0 => data_in_x0_net,
      plb_memmap_x1 => en_net,
      plb_memmap_x10 => re_net,
      plb_memmap_x2 => data_in_x1_net,
      plb_memmap_x3 => en_x0_net,
      plb_memmap_x4 => data_in_x2_net,
      plb_memmap_x5 => en_x1_net,
      plb_memmap_x6 => data_in_x3_net,
      plb_memmap_x7 => en_x2_net,
      plb_memmap_x8 => data_in_x4_net,
      plb_memmap_x9 => en_x3_net
    );

  fifo0: entity work.xlfifogen
    generic map (
      core_name0 => "fifo_fg61_4b31b12dc888b197",
      data_count_width => 12,
      data_width => 96,
      has_ae => 0,
      has_af => 0,
      percent_full_width => 1
    )
    port map (
      ce => ce_1_sg_x30,
      clk => clk_1_sg_x30,
      din => concat1_y_net_x0,
      en => '1',
      re => logical14_y_net_x0,
      re_ce => ce_1_sg_x30,
      rst => logical_y_net_x6,
      we => logical6_y_net_x2,
      we_ce => ce_1_sg_x30,
      dout => fifo0_dout_net
    );

  fifo1: entity work.xlfifogen
    generic map (
      core_name0 => "fifo_fg61_4b31b12dc888b197",
      data_count_width => 12,
      data_width => 96,
      has_ae => 0,
      has_af => 0,
      percent_full_width => 1
    )
    port map (
      ce => ce_1_sg_x30,
      clk => clk_1_sg_x30,
      din => concat1_y_net_x0,
      en => '1',
      re => shstate_req_net_x0,
      re_ce => ce_1_sg_x30,
      rst => logical_y_net_x6,
      we => logical7_y_net_x0,
      we_ce => ce_1_sg_x30,
      dout => fifo1_dout_net_x1,
      empty => fifo1_empty_net_x0
    );

  mux1: entity work.mux_df5cf57d6c
    port map (
      ce => '0',
      clk => '0',
      clr => '0',
      d0 => fifo0_dout_net,
      d1 => constant_op_net,
      sel(0) => register6_q_net_x0,
      y => mux1_y_net_x1
    );

  paoutbusde1_549c244dcc: entity work.paoutbusde1_entity_549c244dcc
    port map (
      pa_out => pa_1_out_net,
      dstat => ds_bot3_y_net_x7,
      signal_x0 => sig_top26_y_net_x0
    );

  paoutbusde2_10e15a9d65: entity work.paoutbusde1_entity_549c244dcc
    port map (
      pa_out => pa_2_out_net,
      dstat => ds_bot3_y_net_x8,
      signal_x0 => sig_top26_y_net_x1
    );

  paoutbusde3_ac7d8bce18: entity work.paoutbusde1_entity_549c244dcc
    port map (
      pa_out => pa_0_out_net,
      dstat => ds_bot3_y_net_x9,
      signal_x0 => sig_top26_y_net_x2
    );

  register_x0: entity work.xlregister
    generic map (
      d_width => 78,
      init_value => b"000000000000000000000000000000000000000000000000000000000000000000000000000000"
    )
    port map (
      ce => ce_1_sg_x30,
      clk => clk_1_sg_x30,
      d => concat_y_net,
      en(0) => delay_q_net_x3,
      rst => "0",
      q => register_q_net_x1
    );

  samplecount_83d95acbaa: entity work.samplecount_entity_83d95acbaa
    port map (
      ce_1 => ce_1_sg_x30,
      clk_1 => clk_1_sg_x30,
      count => data_out_x0_net,
      dv0 => delay_q_net_x3,
      reset => pa_reset_net,
      bos => logical6_y_net_x3,
      dv => delay1_q_net_x4,
      dv0q => dv0q_x2,
      eos => eos_x6,
      ns => register_q_net_x4,
      scannum => scannumber_op_net_x1
    );

  shiftout_5522e31b65: entity work.shiftout_entity_5522e31b65
    port map (
      ce_1 => ce_1_sg_x30,
      chen => delay4_q_net_x12,
      clk_1 => clk_1_sg_x30,
      empty => fifo1_empty_net_x0,
      eos => eos_x6,
      full => full_net,
      na => from_register4_data_out_net_x1,
      nc => register_q_net_x3,
      ns => register_q_net_x4,
      nskl => nls_x3,
      nskp => nps_x3,
      ovf => register1_q_net_x2,
      reset => logical_y_net_x6,
      scannum => scannumber_op_net_x1,
      sigin => fifo1_dout_net_x1,
      trigconfig => trigconfig_net,
      data => data_in_net,
      rdy => rdy_x3,
      re1 => shstate_req_net_x0,
      we2 => we_net
    );

end structural;
