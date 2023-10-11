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
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

signal comp_res : std_logic_vector(7 downto 0);
signal a_fifo_ready, a_ready_i, b_fifo_ready, b_ready_i, tag_ready, inputs_valid, inputs_ready, outputs_ready, res_valid, out_tag_valid, out_tag_ready : std_logic := '0';
signal output_tag : std_logic_vector(31 downto 0) := (others => '0');
signal axis_a_data_count, axis_a_wr_data_count, axis_a_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal axis_b_data_count, axis_b_wr_data_count, axis_b_rd_data_count : std_logic_vector(31 downto 0) := (others => '0');
signal a_fifo_out, b_fifo_out : std_logic_vector(63 downto 0) := (others => '0');
signal a_fifo_out_valid, b_fifo_out_valid, a_fifo_out_ready, b_fifo_out_ready : std_logic := '0';

begin

    comp : fp_greater_than
      PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => a_valid,
        s_axis_a_tready => a_ready,
        s_axis_a_tdata => a_data(31 downto 0),
        s_axis_b_tvalid => b_valid,
        s_axis_b_tready => b_ready,
        s_axis_b_tdata => b_data(31 downto 0),
        m_axis_result_tvalid => max_valid,
        m_axis_result_tready => max_ready,
        m_axis_result_tdata => comp_res
      );
      
    max_data <= a_data when comp_res(0) = '1' else a_data(63 downto 32) & b_data(31 downto 0);
   

end Structural;
