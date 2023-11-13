-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Mon Oct 30 16:51:20 2023
-- Host        : LAPTOP-S8S4C16E running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/IVA/Research/multi_stream_cusum_anomaly_detector/multi_stream_cusum_anomaly_detector.srcs/sources_1/ip/axis_broadcaster_1/axis_broadcaster_1_sim_netlist.vhdl
-- Design      : axis_broadcaster_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_broadcaster_1_axis_broadcaster_v1_1_11_core is
  port (
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axis_tready : out STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    m_axis_tready : in STD_LOGIC_VECTOR ( 2 downto 0 );
    aclken : in STD_LOGIC;
    aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_broadcaster_1_axis_broadcaster_v1_1_11_core : entity is "axis_broadcaster_v1_1_11_core";
end axis_broadcaster_1_axis_broadcaster_v1_1_11_core;

architecture STRUCTURE of axis_broadcaster_1_axis_broadcaster_v1_1_11_core is
  signal \m_ready_d[0]_i_1_n_0\ : STD_LOGIC;
  signal \m_ready_d[1]_i_1_n_0\ : STD_LOGIC;
  signal \m_ready_d[2]_i_1_n_0\ : STD_LOGIC;
  signal \m_ready_d_reg_n_0_[0]\ : STD_LOGIC;
  signal \m_ready_d_reg_n_0_[1]\ : STD_LOGIC;
  signal \m_ready_d_reg_n_0_[2]\ : STD_LOGIC;
  signal \s_axis_tready0__1\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \m_axis_tvalid[0]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \m_axis_tvalid[1]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \m_axis_tvalid[2]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of s_axis_tready_INST_0 : label is "soft_lutpair1";
begin
\m_axis_tvalid[0]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => aresetn,
      I1 => s_axis_tvalid,
      I2 => \m_ready_d_reg_n_0_[0]\,
      O => m_axis_tvalid(0)
    );
\m_axis_tvalid[1]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => aresetn,
      I1 => s_axis_tvalid,
      I2 => \m_ready_d_reg_n_0_[1]\,
      O => m_axis_tvalid(1)
    );
\m_axis_tvalid[2]_INST_0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => aresetn,
      I1 => s_axis_tvalid,
      I2 => \m_ready_d_reg_n_0_[2]\,
      O => m_axis_tvalid(2)
    );
\m_ready_d[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000AA00EA00AA00"
    )
        port map (
      I0 => \m_ready_d_reg_n_0_[0]\,
      I1 => s_axis_tvalid,
      I2 => m_axis_tready(0),
      I3 => aresetn,
      I4 => aclken,
      I5 => \s_axis_tready0__1\,
      O => \m_ready_d[0]_i_1_n_0\
    );
\m_ready_d[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000AA00EA00AA00"
    )
        port map (
      I0 => \m_ready_d_reg_n_0_[1]\,
      I1 => s_axis_tvalid,
      I2 => m_axis_tready(1),
      I3 => aresetn,
      I4 => aclken,
      I5 => \s_axis_tready0__1\,
      O => \m_ready_d[1]_i_1_n_0\
    );
\m_ready_d[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000AA00EA00AA00"
    )
        port map (
      I0 => \m_ready_d_reg_n_0_[2]\,
      I1 => s_axis_tvalid,
      I2 => m_axis_tready(2),
      I3 => aresetn,
      I4 => aclken,
      I5 => \s_axis_tready0__1\,
      O => \m_ready_d[2]_i_1_n_0\
    );
\m_ready_d_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[0]_i_1_n_0\,
      Q => \m_ready_d_reg_n_0_[0]\,
      R => '0'
    );
\m_ready_d_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[1]_i_1_n_0\,
      Q => \m_ready_d_reg_n_0_[1]\,
      R => '0'
    );
\m_ready_d_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => aclk,
      CE => '1',
      D => \m_ready_d[2]_i_1_n_0\,
      Q => \m_ready_d_reg_n_0_[2]\,
      R => '0'
    );
s_axis_tready_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \s_axis_tready0__1\,
      I1 => aresetn,
      O => s_axis_tready
    );
s_axis_tready_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEE0EEE0EEE00000"
    )
        port map (
      I0 => m_axis_tready(1),
      I1 => \m_ready_d_reg_n_0_[1]\,
      I2 => \m_ready_d_reg_n_0_[2]\,
      I3 => m_axis_tready(2),
      I4 => \m_ready_d_reg_n_0_[0]\,
      I5 => m_axis_tready(0),
      O => \s_axis_tready0__1\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_broadcaster_1_top_axis_broadcaster_1 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    aclken : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 95 downto 0 );
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 95 downto 0 );
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axis_tkeep : out STD_LOGIC_VECTOR ( 11 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tid : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tuser : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute C_AXIS_SIGNAL_SET : integer;
  attribute C_AXIS_SIGNAL_SET of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 3;
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of axis_broadcaster_1_top_axis_broadcaster_1 : entity is "artix7";
  attribute C_M_AXIS_TDATA_WIDTH : integer;
  attribute C_M_AXIS_TDATA_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 32;
  attribute C_M_AXIS_TUSER_WIDTH : integer;
  attribute C_M_AXIS_TUSER_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 3;
  attribute C_S_AXIS_TDATA_WIDTH : integer;
  attribute C_S_AXIS_TDATA_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 96;
  attribute C_S_AXIS_TUSER_WIDTH : integer;
  attribute C_S_AXIS_TUSER_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 1;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axis_broadcaster_1_top_axis_broadcaster_1 : entity is "top_axis_broadcaster_1";
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of axis_broadcaster_1_top_axis_broadcaster_1 : entity is 96;
end axis_broadcaster_1_top_axis_broadcaster_1;

architecture STRUCTURE of axis_broadcaster_1_top_axis_broadcaster_1 is
  signal \<const0>\ : STD_LOGIC;
  signal \^s_axis_tdata\ : STD_LOGIC_VECTOR ( 95 downto 0 );
begin
  \^s_axis_tdata\(95 downto 0) <= s_axis_tdata(95 downto 0);
  m_axis_tdata(95 downto 0) <= \^s_axis_tdata\(95 downto 0);
  m_axis_tdest(2) <= \<const0>\;
  m_axis_tdest(1) <= \<const0>\;
  m_axis_tdest(0) <= \<const0>\;
  m_axis_tid(2) <= \<const0>\;
  m_axis_tid(1) <= \<const0>\;
  m_axis_tid(0) <= \<const0>\;
  m_axis_tkeep(11) <= \<const0>\;
  m_axis_tkeep(10) <= \<const0>\;
  m_axis_tkeep(9) <= \<const0>\;
  m_axis_tkeep(8) <= \<const0>\;
  m_axis_tkeep(7) <= \<const0>\;
  m_axis_tkeep(6) <= \<const0>\;
  m_axis_tkeep(5) <= \<const0>\;
  m_axis_tkeep(4) <= \<const0>\;
  m_axis_tkeep(3) <= \<const0>\;
  m_axis_tkeep(2) <= \<const0>\;
  m_axis_tkeep(1) <= \<const0>\;
  m_axis_tkeep(0) <= \<const0>\;
  m_axis_tlast(2) <= \<const0>\;
  m_axis_tlast(1) <= \<const0>\;
  m_axis_tlast(0) <= \<const0>\;
  m_axis_tstrb(11) <= \<const0>\;
  m_axis_tstrb(10) <= \<const0>\;
  m_axis_tstrb(9) <= \<const0>\;
  m_axis_tstrb(8) <= \<const0>\;
  m_axis_tstrb(7) <= \<const0>\;
  m_axis_tstrb(6) <= \<const0>\;
  m_axis_tstrb(5) <= \<const0>\;
  m_axis_tstrb(4) <= \<const0>\;
  m_axis_tstrb(3) <= \<const0>\;
  m_axis_tstrb(2) <= \<const0>\;
  m_axis_tstrb(1) <= \<const0>\;
  m_axis_tstrb(0) <= \<const0>\;
  m_axis_tuser(2) <= \<const0>\;
  m_axis_tuser(1) <= \<const0>\;
  m_axis_tuser(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
broadcaster_core: entity work.axis_broadcaster_1_axis_broadcaster_v1_1_11_core
     port map (
      aclk => aclk,
      aclken => aclken,
      aresetn => aresetn,
      m_axis_tready(2 downto 0) => m_axis_tready(2 downto 0),
      m_axis_tvalid(2 downto 0) => m_axis_tvalid(2 downto 0),
      s_axis_tready => s_axis_tready,
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axis_broadcaster_1 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 95 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 95 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of axis_broadcaster_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of axis_broadcaster_1 : entity is "axis_broadcaster_1,top_axis_broadcaster_1,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of axis_broadcaster_1 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of axis_broadcaster_1 : entity is "top_axis_broadcaster_1,Vivado 2016.4";
end axis_broadcaster_1;

architecture STRUCTURE of axis_broadcaster_1 is
  signal NLW_inst_m_axis_tdest_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_m_axis_tid_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_m_axis_tkeep_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_inst_m_axis_tlast_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_inst_m_axis_tstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_inst_m_axis_tuser_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute C_AXIS_SIGNAL_SET : integer;
  attribute C_AXIS_SIGNAL_SET of inst : label is 3;
  attribute C_AXIS_TDEST_WIDTH : integer;
  attribute C_AXIS_TDEST_WIDTH of inst : label is 1;
  attribute C_AXIS_TID_WIDTH : integer;
  attribute C_AXIS_TID_WIDTH of inst : label is 1;
  attribute C_FAMILY : string;
  attribute C_FAMILY of inst : label is "artix7";
  attribute C_M_AXIS_TDATA_WIDTH : integer;
  attribute C_M_AXIS_TDATA_WIDTH of inst : label is 32;
  attribute C_M_AXIS_TUSER_WIDTH : integer;
  attribute C_M_AXIS_TUSER_WIDTH of inst : label is 1;
  attribute C_NUM_MI_SLOTS : integer;
  attribute C_NUM_MI_SLOTS of inst : label is 3;
  attribute C_S_AXIS_TDATA_WIDTH : integer;
  attribute C_S_AXIS_TDATA_WIDTH of inst : label is 96;
  attribute C_S_AXIS_TUSER_WIDTH : integer;
  attribute C_S_AXIS_TUSER_WIDTH of inst : label is 1;
  attribute G_INDX_SS_TDATA : integer;
  attribute G_INDX_SS_TDATA of inst : label is 1;
  attribute G_INDX_SS_TDEST : integer;
  attribute G_INDX_SS_TDEST of inst : label is 6;
  attribute G_INDX_SS_TID : integer;
  attribute G_INDX_SS_TID of inst : label is 5;
  attribute G_INDX_SS_TKEEP : integer;
  attribute G_INDX_SS_TKEEP of inst : label is 3;
  attribute G_INDX_SS_TLAST : integer;
  attribute G_INDX_SS_TLAST of inst : label is 4;
  attribute G_INDX_SS_TREADY : integer;
  attribute G_INDX_SS_TREADY of inst : label is 0;
  attribute G_INDX_SS_TSTRB : integer;
  attribute G_INDX_SS_TSTRB of inst : label is 2;
  attribute G_INDX_SS_TUSER : integer;
  attribute G_INDX_SS_TUSER of inst : label is 7;
  attribute G_MASK_SS_TDATA : integer;
  attribute G_MASK_SS_TDATA of inst : label is 2;
  attribute G_MASK_SS_TDEST : integer;
  attribute G_MASK_SS_TDEST of inst : label is 64;
  attribute G_MASK_SS_TID : integer;
  attribute G_MASK_SS_TID of inst : label is 32;
  attribute G_MASK_SS_TKEEP : integer;
  attribute G_MASK_SS_TKEEP of inst : label is 8;
  attribute G_MASK_SS_TLAST : integer;
  attribute G_MASK_SS_TLAST of inst : label is 16;
  attribute G_MASK_SS_TREADY : integer;
  attribute G_MASK_SS_TREADY of inst : label is 1;
  attribute G_MASK_SS_TSTRB : integer;
  attribute G_MASK_SS_TSTRB of inst : label is 4;
  attribute G_MASK_SS_TUSER : integer;
  attribute G_MASK_SS_TUSER of inst : label is 128;
  attribute G_TASK_SEVERITY_ERR : integer;
  attribute G_TASK_SEVERITY_ERR of inst : label is 2;
  attribute G_TASK_SEVERITY_INFO : integer;
  attribute G_TASK_SEVERITY_INFO of inst : label is 0;
  attribute G_TASK_SEVERITY_WARNING : integer;
  attribute G_TASK_SEVERITY_WARNING of inst : label is 1;
  attribute P_TPAYLOAD_WIDTH : integer;
  attribute P_TPAYLOAD_WIDTH of inst : label is 96;
begin
inst: entity work.axis_broadcaster_1_top_axis_broadcaster_1
     port map (
      aclk => aclk,
      aclken => '1',
      aresetn => aresetn,
      m_axis_tdata(95 downto 0) => m_axis_tdata(95 downto 0),
      m_axis_tdest(2 downto 0) => NLW_inst_m_axis_tdest_UNCONNECTED(2 downto 0),
      m_axis_tid(2 downto 0) => NLW_inst_m_axis_tid_UNCONNECTED(2 downto 0),
      m_axis_tkeep(11 downto 0) => NLW_inst_m_axis_tkeep_UNCONNECTED(11 downto 0),
      m_axis_tlast(2 downto 0) => NLW_inst_m_axis_tlast_UNCONNECTED(2 downto 0),
      m_axis_tready(2 downto 0) => m_axis_tready(2 downto 0),
      m_axis_tstrb(11 downto 0) => NLW_inst_m_axis_tstrb_UNCONNECTED(11 downto 0),
      m_axis_tuser(2 downto 0) => NLW_inst_m_axis_tuser_UNCONNECTED(2 downto 0),
      m_axis_tvalid(2 downto 0) => m_axis_tvalid(2 downto 0),
      s_axis_tdata(95 downto 0) => s_axis_tdata(95 downto 0),
      s_axis_tdest(0) => '0',
      s_axis_tid(0) => '0',
      s_axis_tkeep(11 downto 0) => B"111111111111",
      s_axis_tlast => '1',
      s_axis_tready => s_axis_tready,
      s_axis_tstrb(11 downto 0) => B"111111111111",
      s_axis_tuser(0) => '0',
      s_axis_tvalid => s_axis_tvalid
    );
end STRUCTURE;
