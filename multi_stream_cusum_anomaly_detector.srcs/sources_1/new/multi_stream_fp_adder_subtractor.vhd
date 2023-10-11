library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_stream_fp_adder_subtractor is
  Port (
      aclk : IN STD_LOGIC;
      arstn : IN STD_LOGIC;
      s_axis_a_tvalid : IN STD_LOGIC;
      s_axis_a_tready : OUT STD_LOGIC;
      s_axis_a_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_b_tvalid : IN STD_LOGIC;
      s_axis_b_tready : OUT STD_LOGIC;
      s_axis_b_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_operation_tvalid : IN STD_LOGIC;
      s_axis_operation_tready : OUT STD_LOGIC;
      s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_result_tvalid : OUT STD_LOGIC;
      m_axis_result_tready : IN STD_LOGIC;
      m_axis_result_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0));
end multi_stream_fp_adder_subtractor;

architecture Structural of multi_stream_fp_adder_subtractor is

COMPONENT axis_broadcaster_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tready : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

COMPONENT axis_combiner_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axis_tready : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

component fp_adder_subtracter
  Port (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_operation_tvalid : IN STD_LOGIC;
    s_axis_operation_tready : OUT STD_LOGIC;
    s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;

COMPONENT fifo32x16
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

signal axis_data_count, axis_wr_data_count, axis_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal broadcast_valid, broadcast_ready, combine_ready, combine_valid : std_logic_vector(1 downto 0) := "00";
signal broadcast_data, combine_data : std_logic_vector (63 downto 0) := (others => '0');

begin

    broadcaster : axis_broadcaster_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => s_axis_a_tvalid,
        s_axis_tready => s_axis_a_tready,
        s_axis_tdata => s_axis_a_tdata,
        m_axis_tvalid => broadcast_valid,
        m_axis_tready => broadcast_ready,
        m_axis_tdata => broadcast_data
    );
      
    fp : fp_adder_subtracter port map (
        aclk => aclk,
        s_axis_a_tvalid => broadcast_valid(0),
        s_axis_a_tready => broadcast_ready(0),
        s_axis_a_tdata => broadcast_data(31 downto 0),
        s_axis_b_tvalid => s_axis_b_tvalid,
        s_axis_b_tready => s_axis_b_tready,
        s_axis_b_tdata => s_axis_b_tdata(31 downto 0),
        s_axis_operation_tvalid => s_axis_operation_tvalid,
        s_axis_operation_tready => s_axis_operation_tready,
        s_axis_operation_tdata => s_axis_operation_tdata,
        m_axis_result_tvalid => combine_valid(0),
        m_axis_result_tready => combine_ready(0),
        m_axis_result_tdata => combine_data(31 downto 0)
    );

    tag_buffer : fifo32x16 port map (
        s_axis_aresetn => arstn,
        s_axis_aclk => aclk,
        s_axis_tvalid => broadcast_valid(1),
        s_axis_tready => broadcast_ready(1),
        s_axis_tdata => broadcast_data(63 downto 32),
        m_axis_tvalid => combine_valid(1),
        m_axis_tready => combine_ready(1),
        m_axis_tdata => combine_data(63 downto 32),
        axis_data_count => axis_data_count,
        axis_wr_data_count => axis_wr_data_count,
        axis_rd_data_count => axis_rd_data_count
    );    
    
    
    combiner : axis_combiner_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => combine_valid,
        s_axis_tready => combine_ready,
        s_axis_tdata => combine_data,
        m_axis_tvalid => m_axis_result_tvalid,
        m_axis_tready => m_axis_result_tready,
        m_axis_tdata => m_axis_result_tdata
      );

end Structural;
