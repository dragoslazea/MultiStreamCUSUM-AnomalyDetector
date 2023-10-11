library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi_stream_threshold_exceeding_detector is
    Port ( aclk : in STD_LOGIC;
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

signal comp_res_p, comp_res_n : std_logic_vector(7 downto 0);
signal gp_in_ready_i, gn_in_ready_i, gp_out_valid_i, gn_out_valid_i, in_valid_i, out_ready_i, abnormal_data_i : std_logic;
signal th_ready_n, th_ready_p : std_logic;
signal th_valid_all : std_logic;

begin

    in_valid_i <= gp_in_valid and gn_in_valid;
    gp_in_ready <= gp_in_ready_i and gn_in_ready_i;
    gn_in_ready <= gp_in_ready_i and gn_in_ready_i;
    
    th_valid_all <= th_valid and th_ready_n and th_ready_p;

    comp_p : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => in_valid_i,
        s_axis_a_tready => gp_in_ready_i,
        s_axis_a_tdata => gp_in_data(31 downto 0),
        s_axis_b_tvalid => th_valid_all,
        s_axis_b_tready => th_ready_p,
        s_axis_b_tdata => th_data,
        m_axis_result_tvalid => gp_out_valid_i,
        m_axis_result_tready => out_ready_i,
        m_axis_result_tdata => comp_res_p
      );
      
      
      out_ready_i <= gp_out_ready and gn_out_ready and abnormal_ready;
      gp_out_valid <= gp_out_valid_i and out_ready_i;
      gp_out_data(63 downto 32) <= gp_in_data(63 downto 32);
      gp_out_data(31 downto 0) <= gp_in_data(31 downto 0) when abnormal_data_i = '0' else (others => '0');

      comp_n : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => in_valid_i,
        s_axis_a_tready => gn_in_ready_i,
        s_axis_a_tdata => gn_in_data(31 downto 0),
        s_axis_b_tvalid => th_valid_all,
        s_axis_b_tready => th_ready_n,
        s_axis_b_tdata => th_data,
        m_axis_result_tvalid => gn_out_valid_i,
        m_axis_result_tready => out_ready_i,
        m_axis_result_tdata => comp_res_n
      );
      
      th_ready <= th_ready_p and th_ready_n;
      
      gn_out_valid <= gn_out_valid_i and out_ready_i;
      gn_out_data(63 downto 32) <= gn_in_data(63 downto 32);
      gn_out_data(31 downto 0) <= gn_in_data(31 downto 0) when abnormal_data_i = '0' else (others => '0');
      
      abnormal_data_i <= comp_res_p(0) or comp_res_n(0);
      abnormal_data <= abnormal_data_i;
      abnormal_valid <= gp_out_valid_i and gn_out_valid_i and out_ready_i;

end Structural;
