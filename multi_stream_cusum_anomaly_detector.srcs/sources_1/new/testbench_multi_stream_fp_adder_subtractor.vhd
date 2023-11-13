library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_multi_stream_fp_adder_subtractor is
end testbench_multi_stream_fp_adder_subtractor;

architecture tb of testbench_multi_stream_fp_adder_subtractor is

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

COMPONENT fifo64x1024
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

constant T : time := 20 ns;

signal clk, nrst : std_logic := '0';
signal a, b, res : std_logic_vector(63 downto 0);
signal a_valid, b_valid, op_valid, res_valid : std_logic := '0';
signal a_ready, b_ready, op_ready : std_logic := '0';


subtype index_type is integer range 0 to 9;
signal i : index_type := 0;

type test_array is array(0 to 9) of std_logic_vector(63 downto 0);
signal test_data : test_array := (
    x"0000000041200000", -- 10.0
    x"0000000041300000", -- 11.0
    x"0000000141b0cccd", -- 22.1
    x"0000000141400000", -- 12.0
    x"0000000241500000", -- 13.0
    x"0000000241600000", -- 14.0
    x"00000003416b3333", -- 14.7
    x"0000000300000000", -- 0.0
    others => (others => '0')
    
);

begin

    clk <= not clk after T / 2;
    nrst <= '0', '1' after 5 * T;
    
--    a_valid <= not a_valid after 2 * T;
--    b_valid <= not b_valid after T;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if a_ready = '1' then 
                if i >= index_type'high - 1 then
                    i <= index_type'low;
                else
                    i <= i + 2;
                end if;
            end if;
        end if;
    end process;
    
    a_valid <= '0', '1' after 10 * T;
    b_valid <= '0', '1' after 10 * T;
    op_valid <= '0', '1' after 10 * T;
    
    a <= test_data(i);
    b <= test_data(i + 1);
    
    fp_alu : multi_stream_fp_adder_subtractor port map(
        aclk => clk,
        arstn => nrst,
        s_axis_a_tvalid => a_valid,
        s_axis_a_tready => a_ready,
        s_axis_a_tdata => a,
        s_axis_b_tvalid => b_valid,
        s_axis_b_tready => b_ready,
        s_axis_b_tdata => b,
        s_axis_operation_tvalid => op_valid,
        s_axis_operation_tready => op_ready,
        s_axis_operation_tdata => "00000000",
        m_axis_result_tvalid => res_valid,
        m_axis_result_tready => '1',
        m_axis_result_tdata => res
    );



end tb;
