library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

-- Generated from Simulink block "parking_lot"

entity ssp_ad_scan_sm is
  port (
    ce: in std_logic := '1';
    clk: in std_logic;
    fsl2sg_fsl_m_full: in std_logic;
    fsl2sg_fsl_s_control: in std_logic;
    fsl2sg_fsl_s_data: in std_logic_vector(31 downto 0);
    fsl2sg_fsl_s_exists: in std_logic;
    pa_0_out: in std_logic_vector(28 downto 0);
    pa_1_out: in std_logic_vector(28 downto 0);
    pa_2_out: in std_logic_vector(28 downto 0);
    navg: out std_logic_vector(7 downto 0);
    pa_re: out std_logic_vector(2 downto 0);
    pa_reset: out std_logic;
    sg2fsl_fsl_m_control: out std_logic;
    sg2fsl_fsl_m_data: out std_logic_vector(31 downto 0);
    sg2fsl_fsl_m_write: out std_logic;
    sg2fsl_fsl_s_read: out std_logic;
    ssp_reset: out std_logic;
    trigconfig: out std_logic_vector(3 downto 0);
    triggerlevel: out std_logic_vector(15 downto 0)
  );
end ssp_ad_scan_sm;

architecture structural of ssp_ad_scan_sm is
  signal clk_x0: std_logic;
  signal x: std_logic;
  signal x_x0: std_logic;
  signal x_x1: std_logic;
  signal x_x10: std_logic;
  signal x_x11: std_logic;
  signal x_x12: std_logic_vector(31 downto 0);
  signal x_x13: std_logic;
  signal x_x14: std_logic;
  signal x_x15: std_logic;
  signal x_x16: std_logic_vector(3 downto 0);
  signal x_x17: std_logic_vector(15 downto 0);
  signal x_x2: std_logic;
  signal x_x3: std_logic_vector(31 downto 0);
  signal x_x4: std_logic;
  signal x_x5: std_logic_vector(7 downto 0);
  signal x_x6: std_logic_vector(28 downto 0);
  signal x_x7: std_logic_vector(28 downto 0);
  signal x_x8: std_logic_vector(28 downto 0);
  signal x_x9: std_logic_vector(2 downto 0);

begin
  x <= ce;
  x_x0 <= clk;
  x_x1 <= fsl2sg_fsl_m_full;
  x_x2 <= fsl2sg_fsl_s_control;
  x_x3 <= fsl2sg_fsl_s_data;
  x_x4 <= fsl2sg_fsl_s_exists;
  x_x6 <= pa_0_out;
  x_x7 <= pa_1_out;
  x_x8 <= pa_2_out;
  navg <= x_x5;
  pa_re <= x_x9;
  pa_reset <= x_x10;
  sg2fsl_fsl_m_control <= x_x11;
  sg2fsl_fsl_m_data <= x_x12;
  sg2fsl_fsl_m_write <= x_x13;
  sg2fsl_fsl_s_read <= x_x14;
  ssp_reset <= x_x15;
  trigconfig <= x_x16;
  triggerlevel <= x_x17;

  sysgen_dut: entity work.ssp_ad_scan_cw
    port map (
      ce => x,
      clk => x_x0,
      fsl2sg_fsl_m_full => x_x1,
      fsl2sg_fsl_s_control => x_x2,
      fsl2sg_fsl_s_data => x_x3,
      fsl2sg_fsl_s_exists => x_x4,
      pa_0_out => x_x6,
      pa_1_out => x_x7,
      pa_2_out => x_x8,
      navg => x_x5,
      pa_re => x_x9,
      pa_reset => x_x10,
      sg2fsl_fsl_m_control => x_x11,
      sg2fsl_fsl_m_data => x_x12,
      sg2fsl_fsl_m_write => x_x13,
      sg2fsl_fsl_s_read => x_x14,
      ssp_reset => x_x15,
      trigconfig => x_x16,
      triggerlevel => x_x17
    );

end structural;
