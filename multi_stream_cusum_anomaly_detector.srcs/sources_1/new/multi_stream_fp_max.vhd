library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_stream_fp_max is
    Port ( aclk : in STD_LOGIC;
       arstn : in STD_LOGIC;
       a_valid : in STD_LOGIC;
       a_ready : out STD_LOGIC;
       a_data : in STD_LOGIC_VECTOR (63 downto 0);
       b_valid : in STD_LOGIC;
       b_ready : out STD_LOGIC;
       b_data : in STD_LOGIC_VECTOR (63 downto 0);
       max_valid : out STD_LOGIC;
       max_ready : in STD_LOGIC;
       max_data : out STD_LOGIC_VECTOR (63 downto 0));
end multi_stream_fp_max;

architecture Structural of multi_stream_fp_max is

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

COMPONENT axis_combiner_1
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axis_tready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axis_tdata : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(95 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fifo64x16
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

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

COMPONENT fp_greater_than
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal comp_res : std_logic_vector(7 downto 0);
signal axis_a_data_count, axis_a_wr_data_count, axis_a_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal axis_b_data_count, axis_b_wr_data_count, axis_b_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal tag_fifo_out : std_logic_vector(63 downto 0) := (others => '0');
signal tag_fifo_out_valid, tag_fifo_out_ready : std_logic := '0';
signal broadcast_a_data, broadcast_b_data : std_logic_vector (63 downto 0) := (others => '0');
signal broadcast_a_valid, broadcast_a_ready, broadcast_b_valid, broadcast_b_ready : std_logic_vector(1 downto 0) := "00";
signal combine_ready, combine_valid : std_logic_vector(2 downto 0) := "000";
signal combined_data, combine_data : std_logic_vector(95 downto 0) := (others => '0');

begin

--    comp : fp_greater_than
--      PORT MAP (
--        aclk => aclk,
--        s_axis_a_tvalid => a_valid,
--        s_axis_a_tready => a_ready,
--        s_axis_a_tdata => a_data(31 downto 0),
--        s_axis_b_tvalid => b_valid,
--        s_axis_b_tready => b_ready,
--        s_axis_b_tdata => b_data(31 downto 0),
--        m_axis_result_tvalid => max_valid,
--        m_axis_result_tready => max_ready,
--        m_axis_result_tdata => comp_res
--      );
      
--    max_data <= a_data when comp_res(0) = '1' else a_data(63 downto 32) & b_data(31 downto 0);

    a_broadcaster : axis_broadcaster_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => a_valid,
        s_axis_tready => a_ready,
        s_axis_tdata => a_data,
        m_axis_tvalid => broadcast_a_valid,
        m_axis_tready => broadcast_a_ready,
        m_axis_tdata => broadcast_a_data
    );
    
    b_broadcaster : axis_broadcaster_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => b_valid,
        s_axis_tready => b_ready,
        s_axis_tdata => b_data,
        m_axis_tvalid => broadcast_b_valid,
        m_axis_tready => broadcast_b_ready,
        m_axis_tdata => broadcast_b_data
    );

    comp : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => broadcast_a_valid(0),
        s_axis_a_tready => broadcast_a_ready(0),
        s_axis_a_tdata => broadcast_a_data(31 downto 0),
        s_axis_b_tvalid => broadcast_b_valid(0),
        s_axis_b_tready => broadcast_b_ready(0),
        s_axis_b_tdata => broadcast_b_data(31 downto 0),
        m_axis_result_tvalid => combine_valid(2),
        m_axis_result_tready => combine_ready(2),
        m_axis_result_tdata => comp_res
      );


    a_buffer : fifo64x16 port map (
        s_axis_aresetn => arstn,
        s_axis_aclk => aclk,
        s_axis_tvalid => broadcast_a_valid(1),
        s_axis_tready => broadcast_a_ready(1),
        s_axis_tdata => broadcast_a_data,
        m_axis_tvalid => combine_valid(1),
        m_axis_tready => combine_ready(1),
        m_axis_tdata => combine_data(95 downto 32),
        axis_data_count => axis_a_data_count,
        axis_wr_data_count => axis_a_wr_data_count,
        axis_rd_data_count => axis_a_rd_data_count
    ); 
    
    b_buffer : fifo32x16 port map (
        s_axis_aresetn => arstn,
        s_axis_aclk => aclk,
        s_axis_tvalid => broadcast_b_valid(1),
        s_axis_tready => broadcast_b_ready(1),
        s_axis_tdata => broadcast_b_data(31 downto 0),
        m_axis_tvalid => combine_valid(0),
        m_axis_tready => combine_ready(0),
        m_axis_tdata => combine_data(31 downto 0),
        axis_data_count => axis_b_data_count,
        axis_wr_data_count => axis_b_wr_data_count,
        axis_rd_data_count => axis_b_rd_data_count
    );
    
    combiner : axis_combiner_1
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => combine_valid,
        s_axis_tready => combine_ready,
        s_axis_tdata => combine_data,
        m_axis_tvalid => max_valid,
        m_axis_tready => max_ready,
        m_axis_tdata => combined_data
      );
    
      
    max_data <= combined_data(95 downto 32) when comp_res(0) = '1' else combined_data(95 downto 64) & combined_data(31 downto 0);

end Structural;
