library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity multi_stream_cusum_detector is
    Port ( 
           -- control inputs
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           
           -- data inputs
           current_sensor_in_data : in STD_LOGIC_VECTOR (63 downto 0);
           current_sensor_in_ready : out STD_LOGIC;
           current_sensor_in_valid : in STD_LOGIC;
           
           previous_sensor_in_data : in STD_LOGIC_VECTOR (63 downto 0);
           previous_sensor_in_ready : out STD_LOGIC;
           previous_sensor_in_valid : in STD_LOGIC;
           
           threshold_data : in STD_LOGIC_VECTOR (31 downto 0);
           threshold_ready : out STD_LOGIC;
           threshold_valid : in STD_LOGIC;
           
           drift_data : in STD_LOGIC_VECTOR (31 downto 0);
           drift_ready : out STD_LOGIC;
           drift_valid : in STD_LOGIC;
           
           -- outputs
           abnormal_data : out STD_LOGIC;
           abnormal_ready : in STD_LOGIC;
           abnormal_valid : out STD_LOGIC;
           
           timestamp_data : out STD_LOGIC_VECTOR (31 downto 0);
           timestamp_ready : in STD_LOGIC;
           timestamp_valid : out STD_LOGIC);
end multi_stream_cusum_detector;

architecture Structural of multi_stream_cusum_detector is

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

component multi_stream_fp_adder_subtractor is
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
end component;

component multi_stream_threshold_exceeding_detector is
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
end component;

component multi_stream_fp_max is
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
end component;

-- data signals
signal current_sensor_measurement, previous_sensor_measurement : STD_LOGIC_VECTOR (63 downto 0);
signal s_t_in, s_t_out, gn_t_1, gp_t_1, gn_s_t_in, gp_s_t_in, gn_s_t_out, gp_s_t_out : STD_LOGIC_VECTOR (63 downto 0);
signal gn_s_t_drift_in, gp_s_t_drift_in, gn_s_t_drift_out, gp_s_t_drift_out : STD_LOGIC_VECTOR (63 downto 0);
signal max_gn_in, max_gp_in, max_gn_out, max_gp_out, gn_t, gp_t, gn_fifo_in, gp_fifo_in : STD_LOGIC_VECTOR (63 downto 0);
signal timestamp_i : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal abnormal_flag : STD_LOGIC;
signal s_t_result, tagged_drift : STD_LOGIC_VECTOR (63 downto 0);

-- ready signals
signal current_sensor_measurement_ready, previous_sensor_measurement_ready : STD_LOGIC;
signal s_t_in_ready, s_t_out_ready, gn_t_1_ready, gp_t_1_ready, gn_s_t_in_ready, gp_s_t_in_ready, gn_s_t_out_ready, gp_s_t_out_ready : STD_LOGIC;
signal gn_s_t_drift_in_ready, gp_s_t_drift_in_ready, gn_s_t_drift_out_ready, gp_s_t_drift_out_ready : STD_LOGIC;
signal max_gn_in_ready, max_gp_in_ready, max_gn_out_ready, max_gp_out_ready, gn_t_ready, gp_t_ready, gn_fifo_in_ready, gp_fifo_in_ready : STD_LOGIC;
signal timestamp_in_ready, s_t_op_ready, gn_s_t_op_ready, gp_s_t_op_ready, gn_s_t_drift_op_ready, gp_s_t_drift_op_ready, max_gn_op_ready, max_gp_op_ready : STD_LOGIC;
signal gn_s_t_ready, gp_s_t_ready : STD_LOGIC;
signal max_gn_0_ready, max_gp_0_ready : STD_LOGIC;
signal abnormal_flag_ready : STD_LOGIC;
signal timestamp_out_ready : STD_LOGIC;
signal s_t_result_ready : STD_LOGIC;
signal gn_drift_ready, gp_drift_ready : STD_LOGIC;

-- valid signals
signal current_sensor_measurement_valid, previous_sensor_measurement_valid : STD_LOGIC;
signal s_t_in_valid, s_t_out_valid, gn_t_1_valid, gp_t_1_valid, gn_s_t_in_valid, gp_s_t_in_valid, gn_s_t_out_valid, gp_s_t_out_valid : STD_LOGIC;
signal gn_s_t_drift_in_valid, gp_s_t_drift_in_valid, gn_s_t_drift_out_valid, gp_s_t_drift_out_valid : STD_LOGIC;
signal max_gn_in_valid, max_gp_in_valid, max_gn_out_valid, max_gp_out_valid, gn_t_valid, gp_t_valid, gn_fifo_in_valid, gp_fifo_in_valid : STD_LOGIC;
signal timestamp_in_valid : STD_LOGIC;
signal gn_s_t_valid, gp_s_t_valid : STD_LOGIC;
signal abnormal_flag_valid : STD_LOGIC;
signal drift_valid_all : STD_LOGIC;

-- data count signals
signal current_sensor_in_data_count, previous_sensor_in_data_count, s_t_data_count, gn_data_count, gp_data_count : STD_LOGIC_VECTOR (31 downto 0);
signal gn_s_t_data_count, gp_s_t_data_count, gn_s_t_drift_data_count, gp_s_t_drift_data_count, max_gp_data_count, max_gn_data_count, timestamp_data_count, abnormal_data_count : STD_LOGIC_VECTOR (31 downto 0);

-- read count signals
signal current_sensor_in_rd_count, previous_sensor_in_rd_count, s_t_rd_count, gn_rd_count, gp_rd_count : STD_LOGIC_VECTOR (31 downto 0);
signal gn_s_t_rd_count, gp_s_t_rd_count, gn_s_t_drift_rd_count, gp_s_t_drift_rd_count, max_gp_rd_count, max_gn_rd_count, timestamp_rd_count, abnormal_rd_count : STD_LOGIC_VECTOR (31 downto 0);

-- write count signals
signal current_sensor_in_wr_count, previous_sensor_in_wr_count, s_t_wr_count, gn_wr_count, gp_wr_count : STD_LOGIC_VECTOR (31 downto 0);
signal gn_s_t_wr_count, gp_s_t_wr_count, gn_s_t_drift_wr_count, gp_s_t_drift_wr_count, max_gp_wr_count, max_gn_wr_count, timestamp_wr_count, abnormal_wr_count : STD_LOGIC_VECTOR (31 downto 0);

-- is first control signal
signal is_first : STD_LOGIC := '1';
signal measurements_valid : STD_LOGIC := '1';

signal gn_s_t_input, gp_s_t_input : STD_LOGIC_VECTOR (63 downto 0);
signal gn_s_t_input_valid, gp_s_t_input_valid : STD_LOGIC;

begin


    current_sensor_in_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => current_sensor_in_valid,
        s_axis_tready => current_sensor_in_ready,
        s_axis_tdata => current_sensor_in_data,
        m_axis_tvalid => current_sensor_measurement_valid,
        m_axis_tready => current_sensor_measurement_ready,
        m_axis_tdata => current_sensor_measurement,
        axis_data_count => current_sensor_in_data_count,
        axis_wr_data_count => current_sensor_in_wr_count,
        axis_rd_data_count => current_sensor_in_rd_count 
    );
    
    previous_sensor_in_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => previous_sensor_in_valid,
        s_axis_tready => previous_sensor_in_ready,
        s_axis_tdata => previous_sensor_in_data,
        m_axis_tvalid => previous_sensor_measurement_valid,
        m_axis_tready => previous_sensor_measurement_ready,
        m_axis_tdata => previous_sensor_measurement,
        axis_data_count => previous_sensor_in_data_count,
        axis_wr_data_count => previous_sensor_in_wr_count,
        axis_rd_data_count => previous_sensor_in_rd_count 
    );
    
    measurements_valid <= current_sensor_measurement_valid and previous_sensor_measurement_valid;
    
    s_t_sub : multi_stream_fp_adder_subtractor port map (
        aclk => clk,
        arstn => rst,
        s_axis_a_tvalid => current_sensor_measurement_valid,
        s_axis_a_tready => current_sensor_measurement_ready,
        s_axis_a_tdata => current_sensor_measurement,
        s_axis_b_tvalid => previous_sensor_measurement_valid,
        s_axis_b_tready => previous_sensor_measurement_ready,
        s_axis_b_tdata => previous_sensor_measurement,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => s_t_op_ready,
        s_axis_operation_tdata => "00000001",
        m_axis_result_tvalid => s_t_in_valid,
        m_axis_result_tready => s_t_in_ready,
        m_axis_result_tdata => s_t_in
    ); 

    s_t_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => s_t_in_valid,
        s_axis_tready => s_t_in_ready,
        s_axis_tdata => s_t_in,
        m_axis_tvalid => s_t_out_valid,
        m_axis_tready => s_t_result_ready,
        m_axis_tdata => s_t_out,
        axis_data_count => s_t_data_count,
        axis_wr_data_count => s_t_wr_count,
        axis_rd_data_count => s_t_rd_count 
    );
    
    s_t_result_ready <= s_t_out_ready when is_first = '0' else '1';
    s_t_result <= s_t_out when is_first = '0' else current_sensor_measurement(63 downto 32) & x"00000000";
    
    -- pe clock si verificare is first + s_t_out_valid = '1'
    -- is_first = '1' pe reset in acelasi proces
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                is_first <= '1';
            else 
                if s_t_out_valid = '1' and is_first = '1' then
                    is_first <= '0';
                end if;
            end if;
        end if;
    end process;    
    
    gn_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gn_t_valid,
        s_axis_tready => gn_t_ready,
        s_axis_tdata => gn_t,
        m_axis_tvalid => gn_t_1_valid,
        m_axis_tready => gn_t_1_ready,
        m_axis_tdata => gn_t_1,
        axis_data_count => gn_data_count,
        axis_wr_data_count => gn_wr_count,
        axis_rd_data_count => gn_rd_count    
    );
    
    gp_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gp_t_valid,
        s_axis_tready => gp_t_ready,
        s_axis_tdata => gp_t,
        m_axis_tvalid => gp_t_1_valid,
        m_axis_tready => gp_t_1_ready,
        m_axis_tdata => gp_t_1,
        axis_data_count => gp_data_count,
        axis_wr_data_count => gp_wr_count,
        axis_rd_data_count => gp_rd_count    
    );
    
    s_t_out_ready <= gn_s_t_ready and gp_s_t_ready;
    gn_s_t_valid <= s_t_out_ready and s_t_out_valid;
    gp_s_t_valid <= s_t_out_ready and s_t_out_valid;
    
    gn_s_t_input <= current_sensor_measurement(63 downto 32) & x"00000000" when is_first = '1' else gn_t_1;
    gn_s_t_input_valid <= '1' when is_first = '1' else gn_t_1_valid;
    
    gn_s_t_sub : multi_stream_fp_adder_subtractor port map (
        aclk => clk,
        arstn => rst,
        s_axis_a_tvalid => gn_s_t_input_valid,
        s_axis_a_tready => gn_t_1_ready,
        s_axis_a_tdata => gn_s_t_input,
        s_axis_b_tvalid => gn_s_t_valid,
        s_axis_b_tready => gn_s_t_ready,
        s_axis_b_tdata => s_t_result,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => gn_s_t_op_ready,
        s_axis_operation_tdata => "00000001",
        m_axis_result_tvalid => gn_s_t_in_valid,
        m_axis_result_tready => gn_s_t_in_ready,
        m_axis_result_tdata => gn_s_t_in
    ); 
    
    gp_s_t_input <= current_sensor_measurement(63 downto 32) & x"00000000" when is_first = '1' else gp_t_1;
    gp_s_t_input_valid <= '1' when is_first = '1' else gp_t_1_valid;
    
    gp_s_t_add : multi_stream_fp_adder_subtractor port map (
        aclk => clk,
        arstn => rst,
        s_axis_a_tvalid => gp_s_t_input_valid,
        s_axis_a_tready => gp_t_1_ready,
        s_axis_a_tdata => gp_s_t_input,
        s_axis_b_tvalid => gp_s_t_valid,
        s_axis_b_tready => gp_s_t_ready,
        s_axis_b_tdata => s_t_result,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => gp_s_t_op_ready,
        s_axis_operation_tdata => "00000000",
        m_axis_result_tvalid => gp_s_t_in_valid,
        m_axis_result_tready => gp_s_t_in_ready,
        m_axis_result_tdata => gp_s_t_in
    ); 
    
    
    gn_s_t_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gn_s_t_in_valid,
        s_axis_tready => gn_s_t_in_ready,
        s_axis_tdata => gn_s_t_in,
        m_axis_tvalid => gn_s_t_out_valid,
        m_axis_tready => gn_s_t_out_ready,
        m_axis_tdata => gn_s_t_out,
        axis_data_count => gn_s_t_data_count,
        axis_wr_data_count => gn_s_t_wr_count,
        axis_rd_data_count => gn_s_t_rd_count    
    );
    
    gp_s_t_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gp_s_t_in_valid,
        s_axis_tready => gp_s_t_in_ready,
        s_axis_tdata => gp_s_t_in,
        m_axis_tvalid => gp_s_t_out_valid,
        m_axis_tready => gp_s_t_out_ready,
        m_axis_tdata => gp_s_t_out,
        axis_data_count => gp_s_t_data_count,
        axis_wr_data_count => gp_s_t_wr_count,
        axis_rd_data_count => gp_s_t_rd_count    
    );
    
    tagged_drift <= gn_s_t_out(63 downto 32) & drift_data;
    
    gn_drift_sub : multi_stream_fp_adder_subtractor port map (
        aclk => clk,
        arstn => rst,
        s_axis_a_tvalid => gn_s_t_out_valid,
        s_axis_a_tready => gn_s_t_out_ready,
        s_axis_a_tdata => gn_s_t_out,
        s_axis_b_tvalid => drift_valid,
        s_axis_b_tready => gn_drift_ready,
        s_axis_b_tdata => tagged_drift,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => gn_s_t_drift_op_ready,
        s_axis_operation_tdata => "00000001",
        m_axis_result_tvalid => gn_s_t_drift_in_valid,
        m_axis_result_tready => gn_s_t_drift_in_ready,
        m_axis_result_tdata => gn_s_t_drift_in
    );
    
    gp_drift_sub : multi_stream_fp_adder_subtractor port map (
        aclk => clk,
        arstn => rst,
        s_axis_a_tvalid => gp_s_t_out_valid,
        s_axis_a_tready => gp_s_t_out_ready,
        s_axis_a_tdata => gp_s_t_out,
        s_axis_b_tvalid => drift_valid,
        s_axis_b_tready => gp_drift_ready,
        s_axis_b_tdata => tagged_drift,
        s_axis_operation_tvalid => '1',
        s_axis_operation_tready => gp_s_t_drift_op_ready,
        s_axis_operation_tdata => "00000001",
        m_axis_result_tvalid => gp_s_t_drift_in_valid,
        m_axis_result_tready => gp_s_t_drift_in_ready,
        m_axis_result_tdata => gp_s_t_drift_in
    ); 
    
    drift_ready <= gn_drift_ready and gp_drift_ready;

    gn_s_t_drift_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gn_s_t_drift_in_valid,
        s_axis_tready => gn_s_t_drift_in_ready,
        s_axis_tdata => gn_s_t_drift_in,
        m_axis_tvalid => gn_s_t_drift_out_valid,
        m_axis_tready => gn_s_t_drift_out_ready,
        m_axis_tdata => gn_s_t_drift_out,
        axis_data_count => gn_s_t_drift_data_count,
        axis_wr_data_count => gn_s_t_drift_wr_count,
        axis_rd_data_count => gn_s_t_drift_rd_count    
    );
    
    gp_s_t_drift_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => gp_s_t_drift_in_valid,
        s_axis_tready => gp_s_t_drift_in_ready,
        s_axis_tdata => gp_s_t_drift_in,
        m_axis_tvalid => gp_s_t_drift_out_valid,
        m_axis_tready => gp_s_t_drift_out_ready,
        m_axis_tdata => gp_s_t_drift_out,
        axis_data_count => gp_s_t_drift_data_count,
        axis_wr_data_count => gp_s_t_drift_wr_count,
        axis_rd_data_count => gp_s_t_drift_rd_count    
    );
    
    gn_s_t_max : multi_stream_fp_max port map (
        aclk => clk,
        arstn => rst,
        a_valid => gn_s_t_drift_out_valid,
        a_ready => gn_s_t_drift_out_ready,
        a_data => gn_s_t_drift_out,
        b_valid => '1',
        b_ready => max_gn_0_ready,
        b_data => (others => '0'),
        max_valid => max_gn_in_valid,
        max_ready => max_gn_in_ready,
        max_data => max_gn_in
    );
    
    gp_s_t_max : multi_stream_fp_max port map (
        aclk => clk,
        arstn => rst,
        a_valid => gp_s_t_drift_out_valid,
        a_ready => gp_s_t_drift_out_ready,
        a_data => gp_s_t_drift_out,
        b_valid => '1',
        b_ready => max_gp_0_ready,
        b_data => (others => '0'),
        max_valid => max_gp_in_valid,
        max_ready => max_gp_in_ready,
        max_data => max_gp_in
    );
    
    max_gn_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => max_gn_in_valid,
        s_axis_tready => max_gn_in_ready,
        s_axis_tdata => max_gn_in,
        m_axis_tvalid => max_gn_out_valid,
        m_axis_tready => max_gn_out_ready,
        m_axis_tdata => max_gn_out,
        axis_data_count => max_gn_data_count,
        axis_wr_data_count => max_gn_wr_count,
        axis_rd_data_count => max_gn_rd_count    
    );
    
    max_gp_fifo_buffer : fifo64x16 port map (
        s_axis_aresetn => rst,
        s_axis_aclk => clk,
        s_axis_tvalid => max_gp_in_valid,
        s_axis_tready => max_gp_in_ready,
        s_axis_tdata => max_gp_in,
        m_axis_tvalid => max_gp_out_valid,
        m_axis_tready => max_gp_out_ready,
        m_axis_tdata => max_gp_out,
        axis_data_count => max_gp_data_count,
        axis_wr_data_count => max_gp_wr_count,
        axis_rd_data_count => max_gp_rd_count    
    );
    
    threshold_exceeding_checker : multi_stream_threshold_exceeding_detector port map (
        aclk => clk,
        gp_in_valid => max_gp_out_valid,
        gp_in_ready => max_gp_out_ready,
        gp_in_data => max_gp_out,
        gn_in_valid => max_gn_out_valid,
        gn_in_ready => max_gn_out_ready,
        gn_in_data => max_gn_out,
        th_valid => threshold_valid,
        th_ready => threshold_ready,
        th_data => threshold_data,
        abnormal_valid => abnormal_flag_valid,
        abnormal_ready => abnormal_ready,
        abnormal_data => abnormal_data,
        gp_out_valid => gp_t_valid,
        gp_out_ready => gp_t_ready,
        gp_out_data => gp_t,
        gn_out_valid => gn_t_valid,
        gn_out_ready => gn_t_ready,
        gn_out_data => gn_t
    );
    
    abnormal_valid <= abnormal_flag_valid;
    
    timestamp_counter : process(clk)
    begin
        if rising_edge(clk) then
            if abnormal_flag_valid = '1' then
                timestamp_i <= timestamp_i + 1;
            end if;
        end if;
    end process timestamp_counter;
    
    timestamp_data <= timestamp_i;
end Structural;
