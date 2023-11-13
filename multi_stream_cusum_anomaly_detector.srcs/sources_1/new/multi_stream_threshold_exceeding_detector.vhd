library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_stream_threshold_exceeding_detector is
    Port ( aclk : in STD_LOGIC;
       arstn : in STD_LOGIC;
       gp_in_valid : in STD_LOGIC;
       gp_in_ready : out STD_LOGIC;
       gp_in_data : in STD_LOGIC_VECTOR (63 downto 0);
       gn_in_valid : in STD_LOGIC;
       gn_in_ready : out STD_LOGIC;
       gn_in_data : in STD_LOGIC_VECTOR (63 downto 0);
       th_valid : in STD_LOGIC;
       th_ready : out STD_LOGIC;
       th_data : in STD_LOGIC_VECTOR (31 downto 0);
       abnormal_valid : out STD_LOGIC;
       abnormal_ready : in STD_LOGIC;
       abnormal_data : out STD_LOGIC;
       gp_out_valid : out STD_LOGIC;
       gp_out_ready : in STD_LOGIC;
       gp_out_data : out STD_LOGIC_VECTOR (63 downto 0);
       gn_out_valid : out STD_LOGIC;
       gn_out_ready : in STD_LOGIC;
       gn_out_data : out STD_LOGIC_VECTOR (63 downto 0));
end multi_stream_threshold_exceeding_detector;

architecture Structural of multi_stream_threshold_exceeding_detector is

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

COMPONENT axis_combiner_2
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axis_tready : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
  );
END COMPONENT;

signal comp_res_p, comp_res_n : std_logic_vector(7 downto 0);
--signal gp_in_ready_i, gn_in_ready_i, gp_out_valid_i, gn_out_valid_i, in_valid_i, out_ready_i, abnormal_data_i : std_logic;
--signal th_ready_n, th_ready_p : std_logic;
--signal th_valid_all : std_logic;
signal axis_gn_data_count, axis_gn_wr_data_count, axis_gn_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal axis_gp_data_count, axis_gp_wr_data_count, axis_gp_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal broadcast_gn_data, broadcast_gp_data : std_logic_vector (63 downto 0) := (others => '0');
signal broadcast_gn_valid, broadcast_gn_ready, broadcast_gp_valid, broadcast_gp_ready : std_logic_vector(1 downto 0) := "00";
signal combine_ready, combine_valid : std_logic_vector(3 downto 0) := "0000";
signal combined_valid, combined_ready : std_logic := '0';
signal combined_data, combine_data : std_logic_vector(127 downto 0) := (others => '0');
signal th_ready_n, th_ready_p : std_logic := '0';

begin

--    in_valid_i <= gp_in_valid and gn_in_valid;
--    gp_in_ready <= gp_in_ready_i and gn_in_ready_i;
--    gn_in_ready <= gp_in_ready_i and gn_in_ready_i;
    
--    th_valid_all <= th_valid and th_ready_n and th_ready_p;

--    comp_p : fp_greater_than
--      PORT MAP (
--        aclk => aclk,
--        s_axis_a_tvalid => in_valid_i,
--        s_axis_a_tready => gp_in_ready_i,
--        s_axis_a_tdata => gp_in_data(31 downto 0),
--        s_axis_b_tvalid => th_valid_all,
--        s_axis_b_tready => th_ready_p,
--        s_axis_b_tdata => th_data,
--        m_axis_result_tvalid => gp_out_valid_i,
--        m_axis_result_tready => out_ready_i,
--        m_axis_result_tdata => comp_res_p
--      );
      
      
--      out_ready_i <= gp_out_ready and gn_out_ready and abnormal_ready;
--      gp_out_valid <= gp_out_valid_i and out_ready_i;
--      gp_out_data(63 downto 32) <= gp_in_data(63 downto 32);
--      gp_out_data(31 downto 0) <= gp_in_data(31 downto 0) when abnormal_data_i = '0' else (others => '0');

--      comp_n : fp_greater_than
--      PORT MAP (
--        aclk => aclk,
--        s_axis_a_tvalid => in_valid_i,
--        s_axis_a_tready => gn_in_ready_i,
--        s_axis_a_tdata => gn_in_data(31 downto 0),
--        s_axis_b_tvalid => th_valid_all,
--        s_axis_b_tready => th_ready_n,
--        s_axis_b_tdata => th_data,
--        m_axis_result_tvalid => gn_out_valid_i,
--        m_axis_result_tready => out_ready_i,
--        m_axis_result_tdata => comp_res_n
--      );
      
--      th_ready <= th_ready_p and th_ready_n;
      
--      gn_out_valid <= gn_out_valid_i and out_ready_i;
--      gn_out_data(63 downto 32) <= gn_in_data(63 downto 32);
--      gn_out_data(31 downto 0) <= gn_in_data(31 downto 0) when abnormal_data_i = '0' else (others => '0');
      
--      abnormal_data_i <= comp_res_p(0) or comp_res_n(0);
--      abnormal_data <= abnormal_data_i;
--      abnormal_valid <= gp_out_valid_i and gn_out_valid_i and out_ready_i;

    gn_broadcaster : axis_broadcaster_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => gn_in_valid,
        s_axis_tready => gn_in_ready,
        s_axis_tdata => gn_in_data,
        m_axis_tvalid => broadcast_gn_valid,
        m_axis_tready => broadcast_gn_ready,
        m_axis_tdata => broadcast_gn_data
    );

    comp_n : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => broadcast_gn_valid(0),
        s_axis_a_tready => broadcast_gn_ready(0),
        s_axis_a_tdata => broadcast_gn_data(31 downto 0),
        s_axis_b_tvalid => th_valid,
        s_axis_b_tready => th_ready_n,
        s_axis_b_tdata => th_data,
        m_axis_result_tvalid => combine_valid(2),
        m_axis_result_tready => combine_ready(2),
        m_axis_result_tdata => comp_res_n
      );


    gn_buffer : fifo64x16 port map (
        s_axis_aresetn => arstn,
        s_axis_aclk => aclk,
        s_axis_tvalid => broadcast_gn_valid(1),
        s_axis_tready => broadcast_gn_ready(1),
        s_axis_tdata => broadcast_gn_data,
        m_axis_tvalid => combine_valid(3),
        m_axis_tready => combine_ready(3),
        m_axis_tdata => combine_data(127 downto 64),
        axis_data_count => axis_gn_data_count,
        axis_wr_data_count => axis_gn_wr_data_count,
        axis_rd_data_count => axis_gn_rd_data_count
    ); 
    
    gp_broadcaster : axis_broadcaster_0
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => gp_in_valid,
        s_axis_tready => gp_in_ready,
        s_axis_tdata => gp_in_data,
        m_axis_tvalid => broadcast_gp_valid,
        m_axis_tready => broadcast_gp_ready,
        m_axis_tdata => broadcast_gp_data
    );

    comp_p : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => broadcast_gp_valid(0),
        s_axis_a_tready => broadcast_gp_ready(0),
        s_axis_a_tdata => broadcast_gp_data(31 downto 0),
        s_axis_b_tvalid => th_valid,
        s_axis_b_tready => th_ready_p,
        s_axis_b_tdata => th_data,
        m_axis_result_tvalid => combine_valid(1),
        m_axis_result_tready => combine_ready(1),
        m_axis_result_tdata => comp_res_p
      );

    gp_buffer : fifo32x16 port map (
        s_axis_aresetn => arstn,
        s_axis_aclk => aclk,
        s_axis_tvalid => broadcast_gp_valid(1),
        s_axis_tready => broadcast_gp_ready(1),
        s_axis_tdata => broadcast_gp_data(31 downto 0),
        m_axis_tvalid => combine_valid(0),
        m_axis_tready => combine_ready(0),
        m_axis_tdata => combine_data(31 downto 0),
        axis_data_count => axis_gp_data_count,
        axis_wr_data_count => axis_gp_wr_data_count,
        axis_rd_data_count => axis_gp_rd_data_count
    );
    
    combine_data(63 downto 32) <= x"00000001" when comp_res_n(0) = '1' or comp_res_p(0) = '1' else x"00000000";
    
    combined_ready <= gn_out_ready and gp_out_ready and abnormal_ready;
    
    final_combiner : axis_combiner_2
      PORT MAP (
        aclk => aclk,
        aresetn => arstn,
        s_axis_tvalid => combine_valid,
        s_axis_tready => combine_ready,
        s_axis_tdata => combine_data,
        m_axis_tvalid => combined_valid,
        m_axis_tready => combined_ready,
        m_axis_tdata => combined_data
      );
      
    gn_out_data <= combined_data(127 downto 96) & x"00000000"  when comp_res_n(0) = '1' or comp_res_p(0) = '1' else combined_data(127 downto 64);
    gn_out_valid <= combined_valid;
    
    abnormal_data <= combined_data(32);
    abnormal_valid <= combined_valid;
    
    gp_out_data <= combined_data(127 downto 96) & x"00000000" when comp_res_n(0) = '1' or comp_res_p(0) = '1' else combined_data(127 downto 96) & combined_data(31 downto 0);
    gp_out_valid <= combined_valid; 
    
    th_ready <= th_ready_n and th_ready_p;
    
    assert gn_in_data(63 downto 32) = gp_in_data(63 downto 32)
        report "Ids are not the same..."
        severity FAILURE;

end Structural;
